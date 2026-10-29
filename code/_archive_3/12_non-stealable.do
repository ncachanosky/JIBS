/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
Firm-level cash-holdings response to populist regime takeovers
================================================================================
WHAT THIS FILE DOES
"Where did the cash go" companion to 09_estimates-sample-splits-polity--
ebalance.do. That file shows ch_at (cash / total assets) falls after a
populist takeover. This file re-runs the IDENTICAL estimation architecture
- same stacked event-study design, same entropy-balance procedure, same wild
cluster bootstrap inference, same sample splits - on five alternative
outcomes built from the new Compustat pull, to test whether the cash is
being redeployed into assets a populist government cannot easily seize:

  intan_at  = intangible assets (intan) / total assets (at)
  ppent_at  = net PP&E (ppent) / total assets (at)              [placebo:
              tangible, seizable - included as a falsification check, not
              part of the "non-stealable" story]
  xrd_at    = R&D expense (xrd) / total assets (at)
  xsga_at   = SG&A expense (xsga) / total assets (at)
  noncash_at = (intan + xrd + xsga) / total assets (at)  [composite
              "aggregate" outcome - the 6th estimation requested. ppent is
              DELIBERATELY EXCLUDED from this sum - see note below]

NOTE ppent_at is estimated as its own (fifth) outcome per Nicolas's
variable list, but economically it is the ONE variable in this set that
should NOT rise if the non-stealable-asset story is right (net PP&E is
physically domestic and easy to expropriate). It is kept as its own
standalone placebo/falsification-check outcome, but is DELIBERATELY
EXCLUDED from the noncash_at composite: a "non-stealable assets" aggregate
that included a stealable, tangible-domestic-asset variable would no
longer measure what it claims to. noncash_at is therefore
(intan + xrd + xsga) / at only. See the results summary for how each of
the five individual outcomes behaves before leaning on the composite
number alone, and treat ppent_at's result as a check on (not a component
of) the main "where did it go" story.

Each outcome is winsorized 1%/99% IN-SAMPLE exactly as ch_at is in file 09
(own percentiles per spec, not inherited from the full panel) via a single
generic winsorize_outcome program (parameterized by global $outcome, in
place of file 09's outcome-specific winsorize_ch_at).

Everything else - entropy-balance targeting each outcome's own pre-period
level lags (t=-4..-1), firm FE via -areg-, cohort-year FE, event dummies
d0..d7, wild cluster bootstrap (Webb weights, null imposed, clustered by
iso) - is carried over unchanged from 09_estimates-sample-splits-polity--
ebalance.do. polity2 is NOT part of the ebalance target here by default,
for the same reason it defaults off in file 09 (weight-collapse risk - see
that file's header) - $include_polity below controls this identically.

ARCHITECTURE: rather than hand-duplicating each of file 09's seven sections
six times (once per outcome - roughly 6x the file, mostly identical code
differing only in which variable is regressed), this file genericizes that
entire body around a single global, $outcome, and its four level-lag
variables (`$outcome'_l1..l4), then wraps sections 1-7 in one outer
`foreach outcome' loop. This is a structural change from file 09's layout
(which hardcodes ch_at throughout) but every individual regression,
ebalance call, and boottest call is otherwise byte-for-byte the same
specification file 09 runs, just parameterized. Graph/log file names embed
the outcome name so all six runs' output coexists without overwriting.

FILE OUTLINE (search these section headers to jump around)
  SETUP & USER SETTINGS ..... global toggles: $reps, output verbosity
                               switches, outcome list. Change these, not
                               the code below, to alter how the file runs.
  OUTCOME CONSTRUCTION ....... builds intan_at, ppent_at, xrd_at, xsga_at,
                               noncash_at from the raw Compustat pull, once,
                               before the outcome loop begins.
  HELPER PROGRAMS ........... winsorize_outcome, pick_balancevars,
                               run_subgroup_loop, robustness_excl - all
                               genericized on $outcome (see each program's
                               header for what changed vs. file 09)
  OUTER LOOP: foreach outcome, running sections 1-7 identical to file 09:
  1. Baseline ................ full worldwide sample
  2. Excluding no-treated regions
  3. Left / Right populists .. same firms, split by treating leader's ideology
  4. By continent ............ Asia / Europe (Americas/Africa/Oceania dropped)
  5. By World Bank income group ... High / Middle income
  6. By European sub-region .. Southern vs. Eastern Europe
  7. By democracy status ..... Fully Democratic sample; Transitioning sample
                               (Arm A vs Arm B)

==============================================================================*/

//------------------------------------------------------------------------------
// SETUP & USER SETTINGS
//------------------------------------------------------------------------------
quietly {
clear all
set more off
set seed 20260705
}

global reps 9999             // wild cluster bootstrap replications. Drop to
                              // ~500-1000 for exploratory runs; raise back
                              // to 9999 for paper-output runs. Same knob as
                              // file 09 - identical tradeoff.

global run_unweighted 0      // 1 = also run each spec without entropy-
                              // balance weights, as a sanity check. Same
                              // semantics as file 09.

global include_polity 0      // 1 = add polity2's four level lags to the
                              // entropy-balance target, alongside the
                              // outcome's own (subject to the same
                              // degeneracy guard as file 09 - polity2 is
                              // still dropped for any spec where it isn't
                              // numerically identified). 0 (default) =
                              // target the outcome's own level lags only.
                              // See file 09's header for the full
                              // rationale (weight-collapse risk).

global polity_sd_min 0.5     // identical semantics/value to file 09.

global target_label  "Level-Lag Ebalance"
if $include_polity {
	global target_suffix "--polity"
}
else {
	global target_suffix "--no-polity"
}

// The five requested outcomes plus the composite "aggregate" (6th
// estimation). ppent_at is a placebo (see header) but is estimated with
// the same machinery as the others per the variable list provided.
global outcome_list "intan_at ppent_at xrd_at xsga_at noncash_at"

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-stacked-firm.dta"
global plotpath "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/plots"

timer clear 99
timer on 99

//------------------------------------------------------------------------------
// PRE-FLIGHT CHECK: confirm the four new Compustat variables and `at' exist
//------------------------------------------------------------------------------
// Fails fast with a clear message if a variable name doesn't match the
// actual pull, rather than failing deep inside the outcome loop with a
// less legible "variable not found" error. Run once, before anything else.
quietly use "$datafile", clear
foreach v in intan ppent xrd xsga at {
	capture confirm variable `v'
	if _rc != 0 {
		di as error "FATAL: variable `v' not found in $datafile - check the Compustat pull/merge before running this file."
		exit 111
	}
}
di as result "Pre-flight check passed: intan, ppent, xrd, xsga, at all present."

//------------------------------------------------------------------------------
// RESULTS LOGGING (readable CSV + Markdown output, alongside the console log)
//------------------------------------------------------------------------------
// Identical mechanics to file 09's log_test/results_log_init (see that
// file's header for the full explanation of the hypindex argument and the
// file-write quoting mechanics - not repeated here). The only change: the
// CSV/Markdown paths are now built per-outcome inside the outer loop (see
// "OUTER LOOP" below), so log_test itself doesn't need to change, but
// results_log_init is called once per outcome rather than once total.
capture program drop log_test
program define log_test
	args nclusters hypindex
	if "`hypindex'" == "" {
		local pval = r(p)
		local tstat = r(t)
	}
	else {
		local pval = r(p_`hypindex')
		local tstat = r(t_`hypindex')
	}
	local ci_lo = .
	local ci_hi = .
	if "`hypindex'" == "" {
		capture matrix ci_tmp = r(CI)
	}
	else {
		capture matrix ci_tmp = r(CI_`hypindex')
	}
	if _rc == 0 {
		local ci_lo = ci_tmp[1,1]
		local ci_hi = ci_tmp[rowsof(ci_tmp), colsof(ci_tmp)]
	}
	local coef = .
	if "$LT_dummyname" != "" {
		capture local coef = _b[$LT_dummyname]
	}
	file open reslog using "$resultslog", write append
	file write reslog (char(34)) "$LT_spec" (char(34)) "," ///
		(char(34)) "$LT_testtype" (char(34)) "," ///
		(char(34)) "$LT_nullhyp" (char(34)) "," ///
		%9.0g (`coef') "," %9.4f (`tstat') "," %9.4f (`pval') "," ///
		%9.0g (`ci_lo') "," %9.0g (`ci_hi') "," (`nclusters') "," ///
		"$target_suffix" "," "$reps" _n
	file close reslog
end

capture program drop results_log_init
program define results_log_init
	capture erase "$resultslog"
	file open reslog using "$resultslog", write replace
	file write reslog "spec,test_type,null_hypothesis,coefficient,t_stat,p_value,ci_low,ci_high,n_clusters,ebal_target,reps" _n
	file close reslog
end

//------------------------------------------------------------------------------
// HELPER PROGRAMS (genericized on $outcome - see each header for the delta
// vs. the file 09 version)
//------------------------------------------------------------------------------

// winsorize_outcome: caps the variable named in $outcome at its own 1st/
// 99th percentile IN THE CURRENT WORKING SAMPLE. Direct generalization of
// file 09's winsorize_ch_at (which was hardcoded to ch_at) - same in-
// sample-percentile logic, just reads the variable name from $outcome
// instead of a fixed name.
capture program drop winsorize_outcome
program define winsorize_outcome
	qui centile $outcome, centile(1 99)
	local p1 = r(c_1)
	local p99 = r(c_2)
	qui replace $outcome = `p1'  if $outcome < `p1'  & !missing($outcome)
	qui replace $outcome = `p99' if $outcome > `p99' & !missing($outcome)
end

// pick_balancevars: identical logic to file 09's version, except the
// outcome's own four level lags are read as `$outcome'_l1..l4 (built fresh
// for the current $outcome inside each section below) rather than the
// fixed ch_at_l1..l4. polity2 guard behavior is unchanged.
capture program drop pick_balancevars
program define pick_balancevars
	args label ifcond
	if !$include_polity {
		c_local balancevars "${outcome}_l1 ${outcome}_l2 ${outcome}_l3 ${outcome}_l4"
		exit
	}
	qui sum polity2_l1 if `ifcond'
	if r(sd) < $polity_sd_min {
		c_local balancevars "${outcome}_l1 ${outcome}_l2 ${outcome}_l3 ${outcome}_l4"
		di as error "`label': polity2 dropped from ebalance target (treated-group sd of polity2 level = " %5.3f r(sd) " < $polity_sd_min)"
	}
	else {
		c_local balancevars "${outcome}_l1 ${outcome}_l2 ${outcome}_l3 ${outcome}_l4 polity2_l1 polity2_l2 polity2_l3 polity2_l4"
	}
end

// robustness_excl: identical to file 09's version except every reference
// to ch_at is replaced by $outcome, and the dX-dummy variable names get an
// outcome-specific suffix (dX0_$outcome etc.) so repeated calls across
// different outcomes in the same session never collide.
capture program drop robustness_excl
program define robustness_excl
	args label exclcountry
	di as result "=== `label' [$outcome]: leave-`exclcountry'-out robustness check ==="
	cap drop _ebalX ebalX post_x dX0_$outcome dX1_$outcome dX2_$outcome dX4_$outcome dX5_$outcome dX6_$outcome dX7_$outcome
	qui count if treat==1
	local nt_before = r(N)
	qui drop if treat==1 & country=="`exclcountry'"
	qui count if treat==1
	di as result "`label' [$outcome] (excl. `exclcountry'): treated firms = " r(N) " (was `nt_before')"
	pick_balancevars "`label' (excl. `exclcountry')" "relative_year==0 & treat==1"
	capture noisily ebalance treat `balancevars' if relative_year==0, gen(_ebalX)
	capture confirm variable _ebalX
	if _rc != 0 {
		di as error "`label' [$outcome] (excl. `exclcountry'): ebalance failed to converge"
		exit
	}
	qui egen ebalX = mean(_ebalX), by(firm_id)
	qui distinct iso
	local ncl = r(ndistinct)
	qui forvalues r = 0/7 {
		if `r' != 3 gen byte dX`r'_$outcome = (treat==1 & rel_year==`r')
	}
	qui areg $outcome dX0_$outcome dX1_$outcome dX2_$outcome i.cy [aweight=ebalX], ///
		absorb(firm_id) cluster(iso)
	di as result "`label' [$outcome] (excl. `exclcountry'): joint pre-trend test"
	boottest {dX0_$outcome} {dX1_$outcome} {dX2_$outcome}, weighttype(webb) nograph reps($reps) level(90)
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_pretrend"
	global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
	global LT_dummyname "dX0_$outcome"
	log_test `ncl' 1
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_pretrend"
	global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
	global LT_dummyname "dX1_$outcome"
	log_test `ncl' 2
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_pretrend"
	global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
	global LT_dummyname "dX2_$outcome"
	log_test `ncl' 3
	qui gen byte post_x = (treat==1 & rel_year>=4)
	qui areg $outcome dX0_$outcome dX1_$outcome dX2_$outcome post_x i.cy [aweight=ebalX], ///
		absorb(firm_id) cluster(iso)
	di as result "`label' [$outcome] (excl. `exclcountry'): pooled post-treatment ATT"
	boottest {post_x}, weighttype(webb) nograph reps($reps) level(90)
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_att"
	global LT_nullhyp "no average treatment effect in periods 0-3, excluding `exclcountry' (H0: coefficient on post_x = 0)"
	global LT_dummyname "post_x"
	log_test `ncl' ""
end

// run_subgroup_loop: identical to file 09's version except every reference
// to ch_at is replaced by $outcome (the level-lag build loop now builds
// `$outcome'_l1..l4 alongside polity2_l1..l4), and the y-axis label on each
// panel reads $outcome_label (a short human-readable string set right
// before each call, e.g. "Intangibles / Total Assets") rather than the
// hardcoded "Cash / Total Assets".
capture program drop run_subgroup_loop
program define run_subgroup_loop
	args groupvar plot_prefix title_prefix exclpairs export_name

	qui levelsof `groupvar', local(groups)
	qui cap egen cy = group(cohort year)
	local ok_panels ""

	foreach grp of local groups {
		preserve
		quietly keep if `groupvar' == "`grp'"
		quietly {
		cap drop `v'_l* _ebal ebal
		tsset firm_id relative_year
		foreach v of varlist $outcome polity2 {
			bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
			bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
			bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
			bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
		}
		}

		pick_balancevars "`grp'" "relative_year==0 & treat==1"
		capture noisily ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
		capture confirm variable _ebal
		if _rc != 0 {
			di as error "ebalance failed to converge (no _ebal created) for group: `grp' [$outcome]"
			restore
			continue
		}
		quietly egen ebal = mean(_ebal), by(firm_id)

		local tag = subinstr("`grp'", " ", "", .)
		quietly {
		distinct iso
		local ncl = r(ndistinct)
		distinct firm_id if treat==1
		local nt = r(ndistinct)
		distinct firm_id if treat==0
		local nc = r(ndistinct)
		}

		di as result "`grp' [$outcome]: treated firms by country/year"
		tab country year if treat==1 & relative_year==0

		qui count if relative_year==0 & treat==0 & !missing(ebal)
		local ncw = r(N)
		qui sum ebal if relative_year==0 & treat==0 & !missing(ebal), detail
		local wmax = r(max)
		local wmin = r(min)
		qui gen double w2 = ebal^2 if relative_year==0 & treat==0 & !missing(ebal)
		qui sum ebal if relative_year==0 & treat==0 & !missing(ebal)
		local sumw = r(sum)
		qui sum w2 if relative_year==0 & treat==0 & !missing(ebal)
		local sumw2 = r(sum)
		local effN = (`sumw')^2 / `sumw2'
		cap drop w2
		di as result "`grp' [$outcome]: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
		di as result "`grp' [$outcome]: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"

		qui forvalues k = 0/7 {
			if `k' != 3 gen byte d`k' = (treat==1 & rel_year==`k')
		}
		qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
		di as result "`grp' [$outcome]: joint pre-trend test"
		boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
		global LT_spec "`grp'"
		global LT_testtype "pretrend"
		global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
		global LT_dummyname "d0"
		log_test `ncl' 1
		global LT_spec "`grp'"
		global LT_testtype "pretrend"
		global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
		global LT_dummyname "d1"
		log_test `ncl' 2
		global LT_spec "`grp'"
		global LT_testtype "pretrend"
		global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
		global LT_dummyname "d2"
		log_test `ncl' 3
		qui cap drop post
		qui gen byte post = (treat==1 & rel_year>=4)
		qui areg $outcome d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
		di as result "`grp' [$outcome]: pooled post-treatment ATT"
		boottest {post}, weighttype(webb) nograph reps($reps) level(90)
		global LT_spec "`grp'"
		global LT_testtype "att"
		global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
		global LT_dummyname "post"
		log_test `ncl' ""
		if $run_unweighted {
			qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy, absorb(firm_id) cluster(iso)
			di as result "`grp' [$outcome]: unweighted joint pre-trend test"
			boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
			qui areg $outcome d0 d1 d2 post i.cy, absorb(firm_id) cluster(iso)
			di as result "`grp' [$outcome]: unweighted pooled post-treatment ATT"
			boottest {post}, weighttype(webb) nograph reps($reps) level(90)
		}

		if `"`exclpairs'"' != "" {
			local remaining `"`exclpairs'"'
			while `"`remaining'"' != "" {
				local semipos = strpos(`"`remaining'"', ";")
				if `semipos' == 0 {
					local pair `"`remaining'"'
					local remaining ""
				}
				else {
					local pair = substr(`"`remaining'"', 1, `semipos' - 1)
					local remaining = substr(`"`remaining'"', `semipos' + 1, .)
				}
				local colonpos = strpos("`pair'", ":")
				local pairgroup = substr("`pair'", 1, `colonpos' - 1)
				local paircountry = substr("`pair'", `colonpos' + 1, .)
				if "`grp'" == "`pairgroup'" {
					robustness_excl "`grp'" "`paircountry'"
				}
			}
		}

		local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'

		qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
		tempname pf
		tempfile res
		qui postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
		qui foreach k of numlist 0 1 2 4 5 6 7 {
			local b = _b[d`k']
			qui boottest d`k', weighttype(webb) reps($reps) level(90) nograph
			matrix ci = r(CI)
			local phase = (`k' >= 4)
			post `pf' (`k' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
		}
		qui postclose `pf'
		qui use "`res'", clear
		quietly {
		twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
		       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
		       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
		       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
		       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
			yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
			ytitle("$outcome_label", size(small)) ///
			xtitle("Periods Since Populist Leader", size(small)) ///
			xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
			xscale(range(0.5 8.5)) legend(off) ///
			subtitle("`title_prefix' `grp'", justification(center) size(small)) ///
			note(`notearg', justification(left) size(vsmall)) ///
			name(`plot_prefix'_`tag', replace) nodraw
		}
		local ok_panels "`ok_panels' `plot_prefix'_`tag'"
		restore
	}

	if `"`ok_panels'"' != "" {
		graph combine `ok_panels', xcommon ycommon rows(1)
		graph export "$plotpath/`export_name'--${outcome}${target_suffix}.png", replace
	}
end

//==============================================================================
// OUTCOME CONSTRUCTION
//==============================================================================
// Built once, on the full raw pull, before the outcome loop begins. Each
// ratio uses the SAME `at' denominator; noncash_at is the simple sum of
// numerators divided once by at (not a sum of already-divided ratios
// re-summed - equivalent algebraically, but building it this way avoids
// compounding separate roundings/missing-value patterns into the
// composite). ppent is INTENTIONALLY OMITTED from noncash_at - it is a
// tangible, domestically-seizable asset and does not belong in a
// "non-stealable assets" aggregate, even though it is estimated on its own
// as a standalone placebo outcome below (see header). Firms with at<=0 or
// missing at are set to missing for every outcome, matching how ch_at
// itself is presumably handled upstream (division by a non-positive or
// missing total-assets figure is not economically meaningful).
use "$datafile", clear
quietly {
gen double intan_at   = intan / at   if at > 0 & !missing(at)
gen double ppent_at   = ppent / at   if at > 0 & !missing(at)
gen double xrd_at     = xrd   / at   if at > 0 & !missing(at)
gen double xsga_at    = xsga  / at   if at > 0 & !missing(at)
gen double noncash_at = (intan + xrd + xsga) / at if at > 0 & !missing(at)
}
di as result "Outcome variables built: intan_at, ppent_at, xrd_at, xsga_at, noncash_at"
foreach v of global outcome_list {
	qui count if !missing(`v')
	di as result "  `v': " r(N) " non-missing observations"
}
save "`c(tmpdir)'/_temp_master_with_outcomes.dta", replace
global datafile_ext "`c(tmpdir)'/_temp_master_with_outcomes.dta"

//==============================================================================
// OUTER LOOP: one full pass of sections 1-7 (identical spec to file 09) per
// outcome. $outcome and $outcome_label are set at the top of each pass;
// everything below is otherwise byte-for-byte the section 1-7 logic from
// 09_estimates-sample-splits-polity--ebalance.do, with ch_at replaced by
// $outcome throughout.
//==============================================================================
local outcome_labels_intan_at   "Intangibles / Total Assets"
local outcome_labels_ppent_at   "Net PP&E / Total Assets (placebo)"
local outcome_labels_xrd_at     "R&D Expense / Total Assets"
local outcome_labels_xsga_at    "SG&A Expense / Total Assets"
local outcome_labels_noncash_at "Intangibles+R&D+SG&A Composite / Total Assets"

foreach outcome of global outcome_list {
global outcome "`outcome'"
global outcome_label "`outcome_labels_`outcome''"
global resultslog "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-log--${outcome}${target_suffix}.csv"
global resultsmd  "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-summary--${outcome}${target_suffix}.md"

di as result "=========================================================="
di as result "BEGIN OUTCOME: $outcome ($outcome_label)"
di as result "=========================================================="

results_log_init

//------------------------------------------------------------------------------
// 1. Baseline: full worldwide sample
//------------------------------------------------------------------------------
use "$datafile_ext", clear
quietly {
winsorize_outcome
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v of varlist $outcome polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
pick_balancevars "Baseline" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Baseline [$outcome]: treated firms by country/year"
tab country year if treat==1 & relative_year==0
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Baseline [$outcome]: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Baseline [$outcome]: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Baseline [$outcome]: joint pre-trend test (H0: d0=d1=d2=0)"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Baseline"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
global LT_dummyname "d0"
log_test `ncl' 1
global LT_spec "Baseline"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
global LT_dummyname "d1"
log_test `ncl' 2
global LT_spec "Baseline"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
global LT_dummyname "d2"
log_test `ncl' 3
qui cap drop post
qui gen byte post = (treat == 1 & rel_year >= 4)
qui areg $outcome d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Baseline [$outcome]: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Baseline"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy, absorb(firm_id) cluster(iso)
	di as result "Baseline [$outcome]: unweighted joint pre-trend test (H0: d0=d1=d2=0)"
	boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
}
local notearg1 `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
tempname pf1
tempfile res1
qui postfile `pf1' double xpos double b double lo double hi byte phase using "`res1'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf1' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf1'
preserve
qui use "`res1'", clear
quietly {
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("$outcome_label", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Baseline", justification(center) size(small)) ///
	note(`notearg1', justification(left) size(vsmall)) ///
	name(e1, replace) nodraw
}
restore

//------------------------------------------------------------------------------
// 2. Excluding regions with no treated cases
//------------------------------------------------------------------------------
use "$datafile_ext", clear
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
quietly {
winsorize_outcome
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v of varlist $outcome polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
pick_balancevars "Excluding no-treated regions" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Excluding no-treated regions [$outcome]: treated firms by country/year"
tab country year if treat==1 & relative_year==0
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions [$outcome]: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Excluding no-treated regions"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
global LT_dummyname "d0"
log_test `ncl' 1
global LT_spec "Excluding no-treated regions"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
global LT_dummyname "d1"
log_test `ncl' 2
global LT_spec "Excluding no-treated regions"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
global LT_dummyname "d2"
log_test `ncl' 3
qui cap drop post
qui gen byte post = (treat == 1 & rel_year >= 4)
qui areg $outcome d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions [$outcome]: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Excluding no-treated regions"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy, absorb(firm_id) cluster(iso)
	di as result "Excluding no-treated regions [$outcome]: unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
local notearg2 `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
tempname pf2
tempfile res2
qui postfile `pf2' double xpos double b double lo double hi byte phase using "`res2'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf2' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf2'
preserve
qui use "`res2'", clear
quietly {
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("$outcome_label", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Excluding regions with no treated", justification(center) size(small)) ///
	note(`notearg2', justification(left) size(vsmall)) ///
	name(e2, replace) nodraw
}
restore

//------------------------------------------------------------------------------
// 3. Left / Right populists
//------------------------------------------------------------------------------
use "$datafile_ext", clear
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
tab lpop relative_year if treat==0 | lpop==1
tab rpop relative_year if treat==0 | rpop==1
quietly {
winsorize_outcome
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v of varlist $outcome polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}

// ---- Left populists ----
qui cap drop _ebal ebal
pick_balancevars "Left populists" "relative_year==0 & lpop==1"
qui ebalance lpop `balancevars' if relative_year == 0 & (treat==0 | lpop==1), gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso if treat==0 | lpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if lpop==1
local nt = r(ndistinct)
}
di as result "Left populists [$outcome]: treated firms by country/year"
tab country year if lpop==1 & relative_year==0
qui forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (lpop == 1 & rel_year == `r')
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Left populists [$outcome]: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Left populists"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
global LT_dummyname "d0"
log_test `ncl' 1
global LT_spec "Left populists"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
global LT_dummyname "d1"
log_test `ncl' 2
global LT_spec "Left populists"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
global LT_dummyname "d2"
log_test `ncl' 3
qui cap drop post
qui gen byte post = (lpop == 1 & rel_year >= 4)
qui areg $outcome d0 d1 d2 post i.cy if treat==0 | lpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Left populists [$outcome]: pooled post-treatment ATT"
boottest {post}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Left populists"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1, absorb(firm_id) cluster(iso)
	di as result "Left populists [$outcome]: unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
local notearg3 `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
tempname pf3
tempfile res3
qui postfile `pf3' double xpos double b double lo double hi byte phase using "`res3'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf3' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf3'
preserve
qui use "`res3'", clear
quietly {
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("$outcome_label", size(small)) ///
	xtitle("Periods Since Left-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Left Populists: $target_label", justification(center) size(small)) ///
	note(`notearg3', justification(left) size(vsmall)) ///
	name(e3, replace) nodraw
}
restore

// ---- Right populists ----
qui cap drop _ebal ebal
pick_balancevars "Right populists" "relative_year==0 & rpop==1"
qui ebalance rpop `balancevars' if relative_year == 0 & (treat==0 | rpop==1), gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso if treat==0 | rpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if rpop==1
local nt = r(ndistinct)
}
di as result "Right populists [$outcome]: treated firms by country/year"
tab country year if rpop==1 & relative_year==0
qui forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (rpop == 1 & rel_year == `r')
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Right populists [$outcome]: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Right populists"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
global LT_dummyname "d0"
log_test `ncl' 1
global LT_spec "Right populists"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
global LT_dummyname "d1"
log_test `ncl' 2
global LT_spec "Right populists"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
global LT_dummyname "d2"
log_test `ncl' 3
qui cap drop post
qui gen byte post = (rpop == 1 & rel_year >= 4)
qui areg $outcome d0 d1 d2 post i.cy if treat==0 | rpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Right populists [$outcome]: pooled post-treatment ATT"
boottest {post}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Right populists"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1, absorb(firm_id) cluster(iso)
	di as result "Right populists [$outcome]: unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
local notearg4 `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
tempname pf4
tempfile res4
qui postfile `pf4' double xpos double b double lo double hi byte phase using "`res4'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf4' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf4'
preserve
qui use "`res4'", clear
quietly {
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("$outcome_label", size(small)) ///
	xtitle("Periods Since Right-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Right Populists: $target_label", justification(center) size(small)) ///
	note(`notearg4', justification(left) size(vsmall)) ///
	name(e4, replace) nodraw
}
restore
graph combine e1 e2 e3 e4, xcommon rows(2)
graph export "$plotpath/wild-baseline-left-right-polity--${outcome}${target_suffix}.png", replace

//------------------------------------------------------------------------------
// 4. By continent
//------------------------------------------------------------------------------
use "$datafile_ext", clear
qui drop if continent == "Africa" | continent == "Americas" | continent == "Oceania"
quietly winsorize_outcome
qui gen rel_year = relative_year + 4
run_subgroup_loop continent "cont" "" "Asia:Thailand" "wild-by-continent-polity"

//------------------------------------------------------------------------------
// 5. By World Bank income group
//------------------------------------------------------------------------------
use "$datafile_ext", clear
quietly winsorize_outcome
qui gen rel_year = relative_year + 4
qui gen _wb_region = ""
qui replace _wb_region = "High Income"   if wb_region == "High income"
qui replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
									  | wb_region == "Upper middle income"
run_subgroup_loop _wb_region "wb" "World Bank" "Middle Income:Thailand;High Income:United States" "wild-by-wb-region-polity"

//------------------------------------------------------------------------------
// 6. By European sub-region: Southern vs. Eastern
//------------------------------------------------------------------------------
use "$datafile_ext", clear
qui keep if inlist(region, "Southern Europe", "Eastern Europe")
quietly winsorize_outcome
qui gen rel_year = relative_year + 4
run_subgroup_loop region "euro" "" "" "wild-by-euro-subregion-polity"

//------------------------------------------------------------------------------
// 7. By democracy status
//------------------------------------------------------------------------------
use "$datafile_ext", clear
quietly winsorize_outcome
qui gen rel_year = relative_year + 4
qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)

// ---- (a) Fully Democratic ----
preserve
qui keep if dem_sample==1
quietly {
tsset firm_id relative_year
foreach v of varlist $outcome polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
pick_balancevars "Fully Democratic Sample" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Fully Democratic Sample [$outcome]: treated firms by country/year"
tab country year if treat==1 & relative_year==0
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Fully Democratic Sample [$outcome]: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Fully Democratic Sample"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
global LT_dummyname "d0"
log_test `ncl' 1
global LT_spec "Fully Democratic Sample"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
global LT_dummyname "d1"
log_test `ncl' 2
global LT_spec "Fully Democratic Sample"
global LT_testtype "pretrend"
global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
global LT_dummyname "d2"
log_test `ncl' 3
qui cap drop post
qui gen byte post = (treat == 1 & rel_year >= 4)
qui areg $outcome d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Fully Democratic Sample [$outcome]: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Fully Democratic Sample"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
qui areg $outcome d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
local notearg5 `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
tempname pf5
tempfile res5
qui postfile `pf5' double xpos double b double lo double hi byte phase using "`res5'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf5' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf5'
qui use "`res5'", clear
quietly {
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("$outcome_label", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Fully Democratic Sample", justification(center) size(small)) ///
	note(`notearg5', justification(left) size(vsmall)) ///
	name(eDem, replace) nodraw
}
restore

// ---- (b) Transitioning: Arm A (populist-only) vs Arm B (also exits democracy) ----
preserve
qui egen ndem_post = total(polity2<=5 & relative_year>0), by(firm_id)
qui egen dem_pre = total(polity2>5 & relative_year<0), by(firm_id)
qui gen trans_sample = . if treat==1 & relative_year==0
qui replace trans_sample = 1 if dem_sample==1 & treat==0
qui replace trans_sample = 1 if dem_sample==1 & treat==1
qui replace trans_sample = 1 if dem_pre==4 & ndem_post > 0 & treat==1
tab trans_sample treat if relative_year==0
tab country year if trans_sample==1 & treat==1 & relative_year==0
qui keep if trans_sample == 1
qui cap egen cy = group(cohort year)
quietly {
tsset firm_id relative_year
foreach v of varlist $outcome polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
}
pick_balancevars "Transitioning sample" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
qui egen ebal = mean(_ebal), by(firm_id)

qui gen byte groupA = (treat == 1 & ndem_post == 0)
qui gen byte groupB = (treat == 1 & ndem_post > 0)
qui forvalues k = 0/7 {
	if `k' != 3 {
		gen byte dA`k' = (groupA == 1 & rel_year == `k')
		gen byte dB`k' = (groupB == 1 & rel_year == `k')
	}
}
qui areg $outcome dA0 dA1 dA2 dA4 dA5 dA6 dA7 dB0 dB1 dB2 dB4 dB5 dB6 dB7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
qui distinct iso
local ncl = r(ndistinct)
di as result "Transitioning sample [$outcome]: Arm A vs Arm B, full profile equality"
boottest {dA0=dB0} {dA1=dB1} {dA2=dB2} {dA4=dB4} {dA5=dB5} {dA6=dB6} {dA7=dB7}, ///
	weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0)"
global LT_dummyname ""
log_test `ncl' 1
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1)"
global LT_dummyname ""
log_test `ncl' 2
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2)"
global LT_dummyname ""
log_test `ncl' 3
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4)"
global LT_dummyname ""
log_test `ncl' 4
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5)"
global LT_dummyname ""
log_test `ncl' 5
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6)"
global LT_dummyname ""
log_test `ncl' 6
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7)"
global LT_dummyname ""
log_test `ncl' 7
di as result "Transitioning sample [$outcome]: Arm A vs Arm B, post-period only"
boottest {dA4=dB4} {dA5=dB5} {dA6=dB6} {dA7=dB7}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality_postonly"
global LT_nullhyp "Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4)"
global LT_dummyname ""
log_test `ncl' 1
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality_postonly"
global LT_nullhyp "Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5)"
global LT_dummyname ""
log_test `ncl' 2
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality_postonly"
global LT_nullhyp "Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6)"
global LT_dummyname ""
log_test `ncl' 3
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality_postonly"
global LT_nullhyp "Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7)"
global LT_dummyname ""
log_test `ncl' 4
quietly {
distinct firm_id if groupA==1
local ntA = r(ndistinct)
distinct firm_id if groupB==1
local ntB = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
tempname pf6
tempfile res6
qui postfile `pf6' double xpos double b double lo double hi byte arm byte phase using "`res6'", replace
qui foreach arm in A B {
	local off = cond("`arm'"=="A", -0.12, 0.12)
	local armnum = cond("`arm'"=="A", 1, 2)
	foreach k of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`arm'`k']
		qui boottest d`arm'`k', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`k' >= 4)
		post `pf6' (`k' + 1 + `off') (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`armnum') (`phase')
	}
}
qui postclose `pf6'
local notearg6 `""`ntA' populist-only, `ntB' populist+non-democratic, and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
tempfile transdata_snapshot
qui save "`transdata_snapshot'"
qui use "`res6'", clear
quietly {
twoway (rcap hi lo xpos if arm==1, lcolor(midblue)) ///
       (scatter b xpos if arm==1, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if arm==2, lcolor(cranberry)) ///
       (scatter b xpos if arm==2, mcolor(cranberry) msymbol(Oh)) ///
       (scatteri 0 4, mcolor(navy) msymbol(D) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("$outcome_label", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) ///
	legend(order(2 "Populist + Democratic" 4 "Populist + Non-Democratic" 5 "Reference (t=-1)") ///
	       rows(1) size(vsmall) position(6)) ///
	subtitle("Transitioning Sample", justification(center) size(small)) ///
	note(`notearg6', justification(left) size(vsmall)) ///
	name(eTrans, replace)
}
qui use "`transdata_snapshot'", clear

// dominant-episode check: Thailand is 47% of this spec's treated firms
robustness_excl "Transitioning sample" "Thailand"

graph combine eDem eTrans, rows(2) xcommon xsize(7) ysize(10)
graph export "$plotpath/wild-by-democratic--${outcome}${target_suffix}.png", replace
restore

//------------------------------------------------------------------------------
// Build readable Markdown summary from $resultslog (this outcome only)
//------------------------------------------------------------------------------
preserve
import delimited "$resultslog", clear varnames(1) case(preserve) stringcols(_all)
destring t_stat p_value coefficient ci_low ci_high n_clusters, replace force

capture file close mdfile
file open mdfile using "$resultsmd", write replace
file write mdfile "# Results summary: $outcome ($outcome_label) - $target_label (`c(current_date)')" _n _n
file write mdfile "Outcome: $outcome ($outcome_label). Wild cluster bootstrap inference " ///
	"(Webb weights, null imposed, `=string($reps)' replications), clustered by country. " ///
	"See 12_estimates-noncash-destinations--ebalance.do header for full method notes, " ///
	"and 09_estimates-sample-splits-polity--ebalance.do for the underlying ch_at spec " ///
	"this file mirrors." _n _n
file write mdfile "**How to read this table:** each row is one hypothesis test. " ///
	"'H0' is the null hypothesis being tested - a low p-value (conventionally " ///
	"below 0.10) means the data are unlikely under that null, i.e. evidence " ///
	"AGAINST it. For pre-trend tests, that means evidence of a problem " ///
	"(differential pre-trend). For ATT tests, that means evidence of a " ///
	"treatment effect." _n _n

qui levelsof spec, local(allspecs)
foreach s of local allspecs {
	file write mdfile "## `s'" _n _n
	file write mdfile "| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |" _n
	file write mdfile "|---|---|---|---|---|---|---|" _n
	forvalues obs = 1/`=_N' {
		if spec[`obs'] == "`s'" {
			local tt = test_type[`obs']
			local nh = null_hypothesis[`obs']
			local co = coefficient[`obs']
			local ts = t_stat[`obs']
			local pv = p_value[`obs']
			local lo = ci_low[`obs']
			local hi = ci_high[`obs']
			local nc = n_clusters[`obs']
			local sig = ""
			if `pv' < 0.10 & `pv' != . {
				local sig = " **"
			}
			file write mdfile "| `tt' | `nh' | " %6.4f (`co') " | " %6.3f (`ts') " | " %6.4f (`pv') "`sig' | [" %6.4f (`lo') ", " %6.4f (`hi') "] | `nc' |" _n
		}
	}
	file write mdfile _n
}
file write mdfile "*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; " ///
	"check the actual magnitude and CI, not just significance.)*" _n
file close mdfile
restore

di as result "Wrote results log: $resultslog"
di as result "Wrote results summary: $resultsmd"
di as result "END OUTCOME: $outcome"

} // end foreach outcome

//------------------------------------------------------------------------------
// Runtime report
//------------------------------------------------------------------------------
timer off 99
qui timer list 99
local runtime_sec = r(t99)
local runtime_min  = floor(`runtime_sec'/60)
local runtime_rem  = `runtime_sec' - `runtime_min'*60
di as result "=========================================="
di as result "Total do-file run time: " `runtime_min' " min " %4.1f `runtime_rem' " sec"
di as result "Settings: reps=$reps, run_unweighted=$run_unweighted, outcomes=$outcome_list"
di as result "=========================================="
