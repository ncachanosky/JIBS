/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
Firm-level cash-holdings response to populist regime takeovers
================================================================================
WHAT THIS FILE DOES
Stacked difference-in-differences event study. Outcome: ch_at (cash / total
assets), winsorized 1%/99%. Firm fixed effects absorbed via -areg-; cohort-
year fixed effects entered as explicit i.cy dummies; event-time entered as
explicit 0/1 dummies d0..d7 (boottest cannot use factor-variable syntax like
1.treat#4.rel_year). Entropy-balance weights target each pre-period level of
ch_at (t=-4..-1) plus, where numerically identified, polity2's pre-period
levels - see the entropy-balance section below for the full rationale and
the degeneracy check that drops polity2 when it isn't identified. Inference
throughout is wild cluster bootstrap (Roodman's -boottest-, Webb weights,
null imposed, clustered by iso) rather than asymptotic clustered SEs,
because most specs below have very few clusters (countries).

FILE OUTLINE (search these section headers to jump around)
  SETUP & USER SETTINGS ..... global toggles: $reps, output verbosity
                               switches. Change these, not the code below,
                               to alter how the file runs.
  HELPER PROGRAMS ........... winsorize_ch_at, pick_balancevars,
                               run_subgroup_loop, robustness_excl
  1. Baseline ................ full worldwide sample
  2. Excluding no-treated regions
  3. Left / Right populists .. same firms, split by treating leader's ideology
  4. By continent ............ Asia / Europe (Americas/Africa/Oceania dropped,
                               see note at that section - not identified)
  5. By World Bank income group ... High / Middle income
  6. By European sub-region .. Southern vs. Eastern Europe (added to re-check
                               a regional divergence first seen under the old
                               log(ch) outcome - see note at that section)
  7. By democracy status ..... Fully Democratic sample; Transitioning sample
                               (Arm A: stays populist-only vs Arm B: also
                               exits democracy)

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
                              // ~500-1000 for exploratory runs - cuts total
                              // runtime roughly 10x-20x; raise back to 9999
                              // for the version that produces paper output.

global run_unweighted 0      // 1 = also run each spec without entropy-
                              // balance weights, as a sanity check that
                              // weighting isn't driving the result. 0 =
                              // skip (weight diagnostics - Kish effective N,
                              // weight ratio - still print either way).

global include_polity 0      // 1 = add polity2's four level lags to the
                              // entropy-balance target, alongside ch_at's
                              // own (subject to the degeneracy guard just
                              // below - polity2 is still dropped for any
                              // spec where it isn't numerically identified,
                              // even with this set to 1). 0 (default) =
                              // target ch_at's level lags only. See header
                              // for why this defaults to off: targeting
                              // both jointly (up to 8 exact-match moments)
                              // is the configuration that produced
                              // catastrophic weight concentration in one
                              // earlier run of this file. Flip to 1 for a
                              // one-off robustness pass if you need to
                              // check whether that still happens under the
                              // current data/sample; nothing else in the
                              // file needs to change.

global polity_sd_min 0.5     // Minimum treated-group sd of polity2's level
                              // lags required for polity2 to enter the
                              // entropy-balance target (only relevant when
                              // $include_polity is 1). Below this, polity2
                              // is numerically unidentified for entropy
                              // balancing (near-constant within the treated
                              // group) and is dropped from the target for
                              // that spec, falling back to ch_at's own
                              // level lags alone - see header for why this
                              // guard is not optional whenever polity2 is
                              // included at all.

local target_label  "Level-Lag Ebalance"
local target_suffix "level"

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta"
global plotpath "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/plots"
global resultslog "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/results-log--`target_suffix'.csv"
global resultsmd  "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/results-summary--`target_suffix'.md"

timer clear 99
timer on 99

//------------------------------------------------------------------------------
// RESULTS LOGGING (readable CSV + Markdown output, alongside the console log)
//------------------------------------------------------------------------------
// HOW IT WORKS: log_test is called by hand, right after each boottest, with
// enough context (spec label, test type, plain-English null hypothesis) to
// describe that result on its own. It pulls the coefficient (if the
// hypothesis is a single dummy like `d0' or `post') and the test's p-value/
// t-stat/CI from the boottest call that was JUST run, then appends one row
// to $resultslog. This has to be called immediately after each boottest -
// r() is overwritten by the next Stata command, so there is no "collect
// everything at the end" option here.
//
// IMPORTANT: boottest {d0} {d1} {d2} tests THREE INDEPENDENT hypotheses in
// one call, and stores results with suffixes r(p_1)/r(t_1)/r(CI_1) for the
// first, r(p_2)/... for the second, etc. (per boottest.sthlp's "Stored
// results" section: unsuffixed r(p)/r(t)/r(CI) are populated only when a
// SINGLE hypothesis is tested). A one-hypothesis call like boottest {post}
// DOES populate the unsuffixed r(p)/r(t)/r(CI) directly. log_test's
// `hypindex' argument controls which: pass "" for a single-hypothesis
// call, or 1/2/3 to pull that hypothesis's suffixed results from a multi-
// hypothesis call. This matters because getting it wrong doesn't error -
// Stata silently returns missing for a suffix that isn't populated - so
// every call site below was written against this documented behavior
// deliberately, not discovered by a missing-value bug after the fact.
//
//   spec       : which specification (e.g. "Baseline", "Asia")
//   testtype   : short tag - "pretrend", "att", "robustness_pretrend",
//                "robustness_att", "arm_equality"
//   nullhyp    : plain-English null hypothesis, written out for the reader
//   dummyname  : coefficient name to pull with _b[] (e.g. "d0", "post"), or
//                "" if none applies (e.g. an Arm A=Arm B equality test has
//                no single coefficient - the test IS the comparison)
//   nclusters  : number of clusters (pass the `ncl' local already computed
//                by the caller)
//   hypindex   : "" for a single-hypothesis boottest call; 1/2/3 to pull
//                the Nth hypothesis's suffixed results from a multi-
//                hypothesis call
//
// Usage at each call site (see below for the exact pattern used
// throughout this file):
//   global LT_spec      "Baseline"
//   global LT_testtype  "pretrend"
//   global LT_nullhyp   "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
//   global LT_dummyname "d0"
//   log_test `ncl' 1
// (the two arguments still passed positionally to log_test are both
// pure numbers - a cluster count and a hypothesis index - which is
// exactly the kind of simple, space-free content `args' handles fine)
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
	// file write's native (exp) argument syntax evaluates the expression
	// and writes the result directly - (char(34)) writes one literal
	// double-quote character. See prior fix note history if this ever
	// needs revisiting: `=char(34)' (macro extended-function substitution)
	// is a DIFFERENT mechanism and is not the right tool here.
	file open reslog using "$resultslog", write append
	file write reslog (char(34)) "$LT_spec" (char(34)) "," ///
		(char(34)) "$LT_testtype" (char(34)) "," ///
		(char(34)) "$LT_nullhyp" (char(34)) "," ///
		%9.0g (`coef') "," %9.4f (`tstat') "," %9.4f (`pval') "," ///
		%9.0g (`ci_lo') "," %9.0g (`ci_hi') "," (`nclusters') "," ///
		"$target_suffix" "," "$reps" _n
	file close reslog
end

// results_log_init: (re)creates $resultslog with a header row. Call once,
// at the very top of the do-file, before any spec runs - every log_test
// call after that appends.
capture program drop results_log_init
program define results_log_init
	capture erase "$resultslog"
	file open reslog using "$resultslog", write replace
	file write reslog "spec,test_type,null_hypothesis,coefficient,t_stat,p_value,ci_low,ci_high,n_clusters,ebal_target,reps" _n
	file close reslog
end

// winsorize_ch_at: caps ch_at at its own 1st/99th percentile IN THE CURRENT
// WORKING SAMPLE. Called fresh after each section's `use', so a regional
// subsample winsorizes against its own distribution rather than inheriting
// cutpoints from the full worldwide panel.
capture program drop winsorize_ch_at
program define winsorize_ch_at
	qui centile ch_at, centile(1 99)
	local p1 = r(c_1)
	local p99 = r(c_2)
	qui replace ch_at = `p1'  if ch_at < `p1'  & !missing(ch_at)
	qui replace ch_at = `p99' if ch_at > `p99' & !missing(ch_at)
end

// pick_balancevars: sets `balancevars' (via c_local, so it's visible in the
// CALLER's scope) to ch_at's four level lags, plus polity2's four level
// lags IF $include_polity is 1 AND polity2 is numerically identified for
// this spec's treated group (sd of its level lags >= $polity_sd_min - see
// header for why this guard exists and is not optional whenever polity2 is
// included at all). `label' is used only for the diagnostic message
// printed when polity2 is dropped, so a caller can tell which spec it
// happened in; `ifcond' restricts the sd check to the relevant treated
// group (e.g. "relative_year==0 & treat==1", or the lpop/rpop equivalent
// for the Left/Right populists split).
capture program drop pick_balancevars
program define pick_balancevars
	args label ifcond
	if !$include_polity {
		c_local balancevars "ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4"
		exit
	}
	qui sum polity2_l1 if `ifcond'
	if r(sd) < $polity_sd_min {
		c_local balancevars "ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4"
		di as error "`label': polity2 dropped from ebalance target (treated-group sd of polity2 level = " %5.3f r(sd) " < $polity_sd_min)"
	}
	else {
		c_local balancevars "ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4 polity2_l1 polity2_l2 polity2_l3 polity2_l4"
	}
end

// robustness_excl: reruns a spec's joint pre-trend test and pooled ATT
// after dropping one country's treated firms, to check whether a result is
// really one dominant country-episode wearing the sub-sample's name (e.g.
// Thailand 2001 is 40-80%+ of the treated mass in several specs below).
// Must be called BEFORE the caller swaps its working dataset for the tiny
// plot-results file, since this needs the full micro-level data.
capture program drop robustness_excl
program define robustness_excl
	args label exclcountry
	di as result "=== `label': leave-`exclcountry'-out robustness check ==="
	cap drop _ebalX ebalX post_x dX0 dX1 dX2 dX4 dX5 dX6 dX7
	qui count if treat==1
	local nt_before = r(N)
	qui drop if treat==1 & country=="`exclcountry'"
	qui count if treat==1
	di as result "`label' (excl. `exclcountry'): treated firms = " r(N) " (was `nt_before')"
	pick_balancevars "`label' (excl. `exclcountry')" "relative_year==0 & treat==1"
	capture noisily ebalance treat `balancevars' if relative_year==0, gen(_ebalX)
	capture confirm variable _ebalX
	if _rc != 0 {
		di as error "`label' (excl. `exclcountry'): ebalance failed to converge"
		exit
	}
	qui egen ebalX = mean(_ebalX), by(firm_id)
	qui distinct iso
	local ncl = r(ndistinct)
	qui forvalues r = 0/7 {
		if `r' != 3 gen byte dX`r' = (treat==1 & rel_year==`r')
	}
	qui areg ch_at dX0 dX1 dX2 dX4 dX5 dX6 dX7 i.cy [aweight=ebalX], ///
		absorb(firm_id) cluster(iso)
	di as result "`label' (excl. `exclcountry'): joint pre-trend test"
	boottest {dX0} {dX1} {dX2}, weighttype(webb) nograph reps($reps) level(90)
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_pretrend"
	global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on dX0 = 0)"
	global LT_dummyname "dX0"
	log_test `ncl' 1
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_pretrend"
	global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on dX1 = 0)"
	global LT_dummyname "dX1"
	log_test `ncl' 2
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_pretrend"
	global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on dX2 = 0)"
	global LT_dummyname "dX2"
	log_test `ncl' 3
	qui gen byte post_x = (treat==1 & rel_year>=4)
	qui areg ch_at dX0 dX1 dX2 post_x i.cy [aweight=ebalX], ///
		absorb(firm_id) cluster(iso)
	di as result "`label' (excl. `exclcountry'): pooled post-treatment ATT"
	boottest {post_x}, weighttype(webb) nograph reps($reps) level(90)
	global LT_spec "`label' (excl. `exclcountry')"
	global LT_testtype "robustness_att"
	global LT_nullhyp "no average treatment effect in periods 0-3, excluding `exclcountry' (H0: coefficient on post_x = 0)"
	global LT_dummyname "post_x"
	log_test `ncl' ""
end

// run_subgroup_loop: the shared engine behind the continent / WB-region /
// European-subregion splits (sections 4-6). For each distinct value of
// `groupvar' in the current sample, restricts to that group, builds ch_at/
// polity2 level lags, entropy-balances, runs the joint pre-trend test and
// pooled ATT, always builds that group's event-study plot data (plus an
// optional unweighted companion per $run_unweighted), and appends a
// combined small-multiples plot at the end.
//   groupvar     : the variable defining the split (e.g. continent)
//   plot_prefix  : short tag for graph names (e.g. "cont") - must be
//                  unique across calls in the same do-file run, since Stata
//                  graph names are global
//   title_prefix : text prepended to each panel's subtitle
//   exclpairs    : optional "group1:country1;group2:country2;..." list -
//                  SEMICOLON-separated between pairs (not space - group and
//                  country names themselves can contain spaces, e.g. "High
//                  Income" or "United States", so space-splitting would
//                  break those apart). For any group matching group_N, runs
//                  robustness_excl against country_N right before that
//                  group's plot panel is finalized. Pass "" for none.
//   export_name  : filename (no path/extension) for the combined graph
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
		foreach v in ch_at polity2 {
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
			di as error "ebalance failed to converge (no _ebal created) for group: `grp'"
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

		di as result "`grp': treated firms by country/year"
		tab country year if treat==1 & relative_year==0

		// weight-concentration diagnostic - always on, it's cheap (no
		// bootstrap) and is the main early-warning sign of a spec worth
		// distrusting (see header note on the polity2 weight-collapse case)
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
		di as result "`grp': control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
		di as result "`grp': Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"

		qui forvalues k = 0/7 {
			if `k' != 3 gen byte d`k' = (treat==1 & rel_year==`k')
		}
		qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
		di as result "`grp': joint pre-trend test"
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
		qui areg ch_at d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
		di as result "`grp': pooled post-treatment ATT"
		boottest {post}, weighttype(webb) nograph reps($reps) level(90)
		global LT_spec "`grp'"
		global LT_testtype "att"
		global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
		global LT_dummyname "post"
		log_test `ncl' ""
		if $run_unweighted {
			qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy, absorb(firm_id) cluster(iso)
			di as result "`grp': unweighted joint pre-trend test"
			boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
			qui areg ch_at d0 d1 d2 post i.cy, absorb(firm_id) cluster(iso)
			di as result "`grp': unweighted pooled post-treatment ATT"
			boottest {post}, weighttype(webb) nograph reps($reps) level(90)
		}

		// dominant-episode robustness check, if this group is listed in exclpairs
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

		// NC: re-estimate the full d0-d7 model here rather than reuse
		// whatever was last estimated - by this point the last model
		// could be the pooled-ATT spec (post, not d4-d7) or, if this
		// group triggered a robustness_excl call above, that
		// program's own dX-prefixed model on a further-restricted
		// sample. Either way _b[d4] etc. below would silently pull
		// from the wrong regression (or error "not found") without
		// this re-estimation.
		qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
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
			ytitle("Cash / Total Assets", size(small)) ///
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
		graph export "$plotpath/`export_name'--`target_suffix'.png", replace
	}
end

results_log_init

//------------------------------------------------------------------------------
// 1. Baseline: full worldwide sample
//------------------------------------------------------------------------------
// Every treated firm, every episode, every control firm. Everything else in
// this file is a restriction of, or a split of, this sample.
use "$datafile", clear
quietly {
winsorize_ch_at
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at polity2 {
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
di as result "Baseline: treated firms by country/year"
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
di as result "Baseline: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Baseline: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Baseline: joint pre-trend test (H0: d0=d1=d2=0)"
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
qui areg ch_at d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Baseline: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Baseline"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy, absorb(firm_id) cluster(iso)
	di as result "Baseline: unweighted joint pre-trend test (H0: d0=d1=d2=0)"
	boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
}
local notearg1 `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
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
	ytitle("Cash / Total Assets", size(small)) ///
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
// Drops Northern/Western Europe, Northern Africa, and Australia/New Zealand
// - none of these regions ever has a populist episode, so keeping them only
// adds control-pool mass without changing identification. This spec checks
// that dropping them doesn't change the Baseline result (it shouldn't, and
// didn't in prior runs) - a sanity check on control-pool composition, not a
// separate hypothesis.
use "$datafile", clear
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
quietly {
winsorize_ch_at
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at polity2 {
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
di as result "Excluding no-treated regions: treated firms by country/year"
tab country year if treat==1 & relative_year==0
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions: joint pre-trend test"
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
qui areg ch_at d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Excluding no-treated regions"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy, absorb(firm_id) cluster(iso)
	di as result "Excluding no-treated regions: unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
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
	ytitle("Cash / Total Assets", size(small)) ///
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
// Same worldwide control pool as Baseline. Splits treated firms by the
// ideology of the populist leader that treated them (lpop/rpop, mutually
// exclusive by construction below). Tests whether the precautionary-cash
// channel (uncertainty -> cash up) and the inflation-risk channel
// (inflation expectations -> cash down) - which theory predicts operate
// differently for left- vs. right-wing populism - actually diverge in the
// data.
use "$datafile", clear
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
// left un-quieted on purpose - sanity check that lpop/rpop partition the
// treated sample as intended (every relative_year should show the same
// firm count within each arm)
tab lpop relative_year if treat==0 | lpop==1
tab rpop relative_year if treat==0 | rpop==1
quietly {
winsorize_ch_at
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at polity2 {
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
di as result "Left populists: treated firms by country/year"
tab country year if lpop==1 & relative_year==0
qui forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (lpop == 1 & rel_year == `r')
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Left populists: joint pre-trend test"
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
qui areg ch_at d0 d1 d2 post i.cy if treat==0 | lpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Left populists: pooled post-treatment ATT"
boottest {post}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Left populists"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1, absorb(firm_id) cluster(iso)
	di as result "Left populists: unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
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
	ytitle("Cash / Total Assets", size(small)) ///
	xtitle("Periods Since Left-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Left Populists: `target_label'", justification(center) size(small)) ///
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
di as result "Right populists: treated firms by country/year"
tab country year if rpop==1 & relative_year==0
qui forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (rpop == 1 & rel_year == `r')
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Right populists: joint pre-trend test"
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
qui areg ch_at d0 d1 d2 post i.cy if treat==0 | rpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Right populists: pooled post-treatment ATT"
boottest {post}, weighttype(webb) reps($reps) level(90) nograph
global LT_spec "Right populists"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
if $run_unweighted {
	qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1, absorb(firm_id) cluster(iso)
	di as result "Right populists: unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1 [aweight=ebal], absorb(firm_id) cluster(iso)
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
	ytitle("Cash / Total Assets", size(small)) ///
	xtitle("Periods Since Right-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Right Populists: `target_label'", justification(center) size(small)) ///
	note(`notearg4', justification(left) size(vsmall)) ///
	name(e4, replace) nodraw
}
restore
graph combine e1 e2 e3 e4, xcommon rows(2)
graph export "$plotpath/wild-baseline-left-right-polity--`target_suffix'.png", replace

//------------------------------------------------------------------------------
// 4. By continent
//------------------------------------------------------------------------------
// Americas, Africa, and Oceania are dropped before the loop, not inside it:
// Americas' pooled ATT was ~97% driven by the single US 2017 episode
// (redundant with the WB High-Income leave-US-out check in section 5);
// Africa has 12 treated firms in one country (South Africa 2009) - a single
// cluster, so WCB CIs are unbounded; Oceania has zero treated firms under
// any configuration. None of the three are identified here regardless of
// outcome variable or ebalance target, so there's no diagnostic value in
// running them just to watch them fail.
use "$datafile", clear
qui drop if continent == "Africa" | continent == "Americas" | continent == "Oceania"
quietly winsorize_ch_at
qui gen rel_year = relative_year + 4
run_subgroup_loop continent "cont" "" "Asia:Thailand" "wild-by-continent-polity"

//------------------------------------------------------------------------------
// 5. By World Bank income group
//------------------------------------------------------------------------------
// wb_region collapses to two buckets: High income vs. everything else
// classified Lower/Upper middle income (no Low income countries have a
// populist episode in this sample, so that tier is absent by construction,
// not by an explicit drop).
use "$datafile", clear
quietly winsorize_ch_at
qui gen rel_year = relative_year + 4
qui gen _wb_region = ""
qui replace _wb_region = "High Income"   if wb_region == "High income"
qui replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
									  | wb_region == "Upper middle income"
run_subgroup_loop _wb_region "wb" "World Bank" "Middle Income:Thailand;High Income:United States" "wild-by-wb-region-polity"

//------------------------------------------------------------------------------
// 6. By European sub-region: Southern vs. Eastern
//------------------------------------------------------------------------------
// Re-checks a divergence first seen under the old log(ch) outcome: Southern
// European firms (Italy, Greece) appeared to raise cash holdings post-
// treatment, Eastern European firms (Poland, Slovakia, Bulgaria, Hungary)
// appeared to lower them - a puzzle that partly motivated exploring SDID as
// an alternative estimator. Re-run here under ch_at (currency-artifact-
// free) to see whether the divergence survives the outcome-variable fix or
// was partly an artifact of it. `region' uses the same UN-geoscheme labels
// used elsewhere in this file (see the Northern/Western Europe drop in
// section 2) - "Southern Europe" and "Eastern Europe" are exact matches.
use "$datafile", clear
qui keep if inlist(region, "Southern Europe", "Eastern Europe")
quietly winsorize_ch_at
qui gen rel_year = relative_year + 4
run_subgroup_loop region "euro" "" "" "wild-by-euro-subregion-polity"

//------------------------------------------------------------------------------
// 7. By democracy status
//------------------------------------------------------------------------------
// Two related but distinct samples:
//   (a) Fully Democratic - restricts to firms in countries that stay above
//       the polity2>5 democracy threshold for the entire 8-period window
//       (both treated and control). Tests the populism effect net of any
//       confound from a country also sliding toward autocracy.
//   (b) Transitioning - the complementary comparison: democratic controls
//       vs. treated firms split into Arm A (stays populist-only, still
//       democratic post-treatment) and Arm B (also exits democracy
//       post-treatment, i.e. ndem_post>0). Of 1,385 treated firms, 1,145
//       remain democratic all 8 periods; 240 have a democratic pre-period
//       but a non-democratic post-period (7 in Ecuador 2007, 233 in the
//       US 2017) - Arm B is small and concentrated in exactly those two
//       episodes, worth remembering when interpreting the Arm A vs B
//       contrast.
use "$datafile", clear
quietly winsorize_ch_at
qui gen rel_year = relative_year + 4
qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)

// ---- (a) Fully Democratic ----
preserve
qui keep if dem_sample==1
quietly {
tsset firm_id relative_year
foreach v in ch_at polity2 {
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
di as result "Fully Democratic Sample: treated firms by country/year"
tab country year if treat==1 & relative_year==0
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Fully Democratic Sample: joint pre-trend test"
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
qui areg ch_at d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Fully Democratic Sample: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
global LT_spec "Fully Democratic Sample"
global LT_testtype "att"
global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
global LT_dummyname "post"
log_test `ncl' ""
qui areg ch_at d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
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
	ytitle("Cash / Total Assets", size(small)) ///
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
// left un-quieted on purpose - documents the Arm A/B sample construction
tab trans_sample treat if relative_year==0
tab country year if trans_sample==1 & treat==1 & relative_year==0
qui keep if trans_sample == 1
qui cap egen cy = group(cohort year)
quietly {
tsset firm_id relative_year
foreach v in ch_at polity2 {
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
qui areg ch_at dA0 dA1 dA2 dA4 dA5 dA6 dA7 dB0 dB1 dB2 dB4 dB5 dB6 dB7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
qui distinct iso
local ncl = r(ndistinct)
di as result "Transitioning sample: Arm A vs Arm B, full profile equality"
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
di as result "Transitioning sample: Arm A vs Arm B, post-period only"
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
	ytitle("Cash / Total Assets", size(small)) ///
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
graph export "$plotpath/wild-by-democratic--`target_suffix'.png", replace
restore

//------------------------------------------------------------------------------
// Build readable Markdown summary from $resultslog
//------------------------------------------------------------------------------
// Reads $resultslog (the CSV every log_test call appended to throughout
// this run) back in and writes $resultsmd - one section per spec, one
// bullet per test, in plain English. This is meant to be read top to
// bottom without needing to cross-reference variable names against the
// do-file. Does not touch or require the working dataset from any
// estimation section above - runs on the CSV alone.
preserve
import delimited "$resultslog", clear varnames(1) case(preserve) stringcols(_all)
destring t_stat p_value coefficient ci_low ci_high n_clusters, replace force

capture file close mdfile
file open mdfile using "$resultsmd", write replace
file write mdfile "# Results summary: `target_label' (`c(current_date)')" _n _n
file write mdfile "Outcome: ch_at (cash / total assets). Wild cluster bootstrap inference " ///
	"(Webb weights, null imposed, `=string($reps)' replications), clustered by country. " ///
	"See the do-file header for full method notes." _n _n
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
di as result "Settings: reps=$reps, run_unweighted=$run_unweighted"
di as result "=========================================="
