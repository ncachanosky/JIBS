/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
Firm-level cash-holdings response to populist regime takeovers
================================================================================
WHAT THIS FILE DOES
Stacked difference-in-differences event study, testing a battery of nine
balance-sheet outcomes (not just cash) for TWO specifications only:
  1. Baseline - the full worldwide sample
  2. Left / Right populists - the same worldwide control pool, treated
     firms split by the ideology of the populist leader that treated them

THE NINE OUTCOMES
  ch_at        - cash / total assets (the original outcome, kept as anchor)
  act_at       - current assets / total assets (cash is one component of
                 current assets, so this checks whether the current-asset
                 bucket as a whole behaves differently than cash alone)
  act_ex_ch_at - current assets EXCLUDING cash / total assets (splits
                 act_at into its cash and non-cash pieces, so a within-
                 current-assets reallocation is visible directly rather
                 than only inferable by comparing ch_at and act_at
                 separately - see 02_clean-compustat.do for an important
                 caveat on how to read a rise here: current-assets-ex-cash
                 still includes receivables, inventory, and short-term
                 securities, which fit the paper's "hiding from
                 expropriation" story much less well than intangibles or
                 foreign PP&E would)
  ppent_at     - net property, plant & equipment / total assets
  ivaeq_at     - equity investments & advances / total assets
  ivao_at      - other investments & advances / total assets
  intan_at     - intangible assets / total assets
  ao_at        - other assets / total assets
  invt_at      - inventories / total assets (a further decomposition
                 alongside act_ex_ch_at, isolating inventory specifically
                 since it's economically and politically different from
                 receivables or short-term securities - see 02_clean-
                 compustat.do for the caveat: a rise here is at least as
                 consistent with defensive stockpiling or slowing sales as
                 with a stealability-driven reallocation)
Both specifications below run the FULL battery of tests - individual and
joint pre-trend tests, pooled ATT, dominant-episode robustness check,
event-study plot - once per outcome above, all sharing the SAME entropy-
balance weights within a given spec (see ENTROPY-BALANCE TARGET below for
why weights are not re-estimated per outcome).
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
                              // ~200-500 for exploratory runs - with nine
                              // outcomes x two specs, runtime still adds
                              // up. Raise back to 9999 for paper output.

global run_unweighted 0      // 1 = also run every outcome's regression
                              // without entropy-balance weights, as a
                              // sanity check that weighting isn't driving
                              // results. 0 = skip (weight diagnostics -
                              // Kish effective N, weight ratio - still
                              // print either way, once per spec, not once
                              // per outcome, since weights don't vary by
                              // outcome - see header).

global target_label  "Level-Lag Ebalance"
global target_suffix "level"

// outcomelist: the nine outcome variables this file estimates for BOTH
// specifications below - no selector, no toggle, both specs always run
// the full battery, per the user's confirmed scope.
global outcomelist "ch_at act_at act_ex_ch_at ppent_at ivaeq_at ivao_at intan_at ao_at invt_at"

global outcomelabel_ch_at        "Cash / Assets"
global outcomelabel_act_at       "Current Assets / Assets"
global outcomelabel_act_ex_ch_at "Current Assets ex. Cash / Assets"
global outcomelabel_ppent_at     "Net PP&E / Assets"
global outcomelabel_ivaeq_at     "Equity Investments / Assets"
global outcomelabel_ivao_at      "Other Investments / Assets"
global outcomelabel_intan_at     "Intangibles / Assets"
global outcomelabel_ao_at        "Other Assets / Assets"
global outcomelabel_invt_at      "Inventories / Assets"

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-stacked-firm.dta"
global plotpath "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/plots"
global resultslog "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-log--baseline-leftright--$target_suffix.csv"
global resultsmd  "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-summary--baseline-leftright--$target_suffix.md"

timer clear 99
timer on 99


//------------------------------------------------------------------------------
// RESULTS LOGGING (readable CSV + Markdown output, alongside the console log)
//------------------------------------------------------------------------------
capture program drop log_test
program define log_test
	args nclusters hypindex
	if "`hypindex'" == "" {
		local pval = r(p)
		local tstat = r(t)
		if missing(`tstat') {
			local tstat = r(F)
		}
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
	local nobs = .
	capture local nobs = e(N)
	// file write's native (exp) argument syntax evaluates the expression
	// and writes the result directly - (char(34)) writes one literal
	// double-quote character. `=char(34)' (macro extended-function
	// substitution) is a DIFFERENT mechanism and is NOT the right tool
	// here.
	file open reslog using "$resultslog", write append
	file write reslog (char(34)) "$LT_outcome" (char(34)) "," ///
		(char(34)) "$LT_spec" (char(34)) "," ///
		(char(34)) "$LT_testtype" (char(34)) "," ///
		(char(34)) "$LT_nullhyp" (char(34)) "," ///
		%9.0g (`coef') "," %9.4f (`tstat') "," %9.4f (`pval') "," ///
		%9.0g (`ci_lo') "," %9.0g (`ci_hi') "," (`nclusters') "," ///
		%12.0f (`nobs') "," ///
		"$target_suffix" "," "$reps" _n
	file close reslog
end

// results_log_init: (re)creates $resultslog with a header row. Call once,
// at the very top of the do-file, before any spec runs.
capture program drop results_log_init
program define results_log_init
	capture erase "$resultslog"
	file open reslog using "$resultslog", write replace
	file write reslog "outcome,spec,test_type,null_hypothesis,coefficient,t_stat,p_value,ci_low,ci_high,n_clusters,n_obs,ebal_target,reps" _n
	file close reslog
end

capture program drop winsorize_var
program define winsorize_var
	args varname
	qui centile `varname', centile(1 99)
	local p1 = r(c_1)
	local p99 = r(c_2)
	qui replace `varname' = `p1'  if `varname' < `p1'  & !missing(`varname')
	qui replace `varname' = `p99' if `varname' > `p99' & !missing(`varname')
end

// build_outcomevars: all nine $outcomelist ratios should already be
// present as columns in master-stacked-firm.dta, built upstream in
// 02_clean-compustat.do. This program's job is just to winsorize whichever
// ones are in $outcomelist - construction is not its primary job. The
// capture-confirm/fallback-gen block below is a SAFETY NET: it only fires
// for an outcome that's missing entirely (e.g. running against an older
// master-stacked-firm.dta, built before 02 was updated to include it). If
// the upstream construction is in place, this block does nothing and the
// whole program is just the winsorize loop at the bottom.
capture program drop build_outcomevars
program define build_outcomevars
	quietly {
	capture confirm variable ch_at
	if _rc != 0 & strpos(" $outcomelist ", " ch_at ") {
		di as error "build_outcomevars: ch_at not found in source data - building from ch/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ch_at     = ch     / at if at > 0
	}
	capture confirm variable act_at
	if _rc != 0 & strpos(" $outcomelist ", " act_at ") {
		di as error "build_outcomevars: act_at not found in source data - building from act/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen act_at    = act    / at if at > 0
	}
	capture confirm variable act_ex_ch_at
	if _rc != 0 & strpos(" $outcomelist ", " act_ex_ch_at ") {
		di as error "build_outcomevars: act_ex_ch_at not found in source data - building from (act-ch)/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen act_ex_ch_at = (act - ch) / at if at > 0
	}
	capture confirm variable ppent_at
	if _rc != 0 & strpos(" $outcomelist ", " ppent_at ") {
		di as error "build_outcomevars: ppent_at not found in source data - building from ppent/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ppent_at  = ppent  / at if at > 0
	}
	capture confirm variable ivaeq_at
	if _rc != 0 & strpos(" $outcomelist ", " ivaeq_at ") {
		di as error "build_outcomevars: ivaeq_at not found in source data - building from ivaeq/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ivaeq_at  = ivaeq  / at if at > 0
	}
	capture confirm variable ivao_at
	if _rc != 0 & strpos(" $outcomelist ", " ivao_at ") {
		di as error "build_outcomevars: ivao_at not found in source data - building from ivao/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ivao_at   = ivao   / at if at > 0
	}
	capture confirm variable intan_at
	if _rc != 0 & strpos(" $outcomelist ", " intan_at ") {
		di as error "build_outcomevars: intan_at not found in source data - building from intan/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen intan_at  = intan  / at if at > 0
	}
	capture confirm variable ao_at
	if _rc != 0 & strpos(" $outcomelist ", " ao_at ") {
		di as error "build_outcomevars: ao_at not found in source data - building from ao/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ao_at     = ao     / at if at > 0
	}
	capture confirm variable invt_at
	if _rc != 0 & strpos(" $outcomelist ", " invt_at ") {
		di as error "build_outcomevars: invt_at not found in source data - building from invt/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen invt_at   = invt   / at if at > 0
	}
	}
	foreach v of global outcomelist {
		winsorize_var `v'
	}
end

// pick_balancevars: sets `balancevars' (via c_local, so it's visible in the
// CALLER's scope) to ch_at's four level lags. This ALWAYS targets ch_at
// specifically (never any other outcome, never polity2 - see header for
// why polity2 was removed entirely) - see header for why entropy-balance
// weights are estimated once per spec, on ch_at's pre-trend, and then
// reused for every outcome's regression. `label'/`ifcond' are accepted
// but unused, kept in the call signature so every call site below reads
// consistently and so this program's interface wouldn't need to change
// again if a conditional target is ever reintroduced.
capture program drop pick_balancevars
program define pick_balancevars
	args label ifcond
	c_local balancevars "ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4"
end

// run_outcome_battery: given an outcome variable name, a spec label,
// cluster/firm counts, and an already-estimated ebal weight variable IN
// MEMORY, runs that outcome's full test suite for the CURRENT WORKING
// SAMPLE - individual and joint pre-trend tests, pooled ATT, optional
// unweighted companion, and a 7-point event-study plot.
//   outcomevar   : which outcome to regress (e.g. "ch_at", "intan_at")
//   spec         : spec label for logging/diagnostics (e.g. "Baseline")
//   treatedcond  : the condition that defines "this row is the treated
//                  arm at this relative year" - e.g. "treat==1" for a
//                  plain single-arm spec, "lpop==1" for Left populists.
//                  Used to gate the dN dummy construction, so control-arm
//                  rows never get counted as treated at some relative
//                  year.
//   samplecond   : the estimation-sample restriction for areg/boottest -
//                  e.g. "treat==0 | lpop==1" for Left populists. Pass ""
//                  if the working sample in memory is ALREADY restricted
//                  to exactly the right rows.
//   ncl / nt / nc: cluster count / treated firm count / control firm count
//   plotname     : Stata graph name for this outcome's plot (must be
//                  globally unique across the whole do-file run)
//   plottitle    : subtitle text for the plot (spec label; the outcome's
//                  own label from $outcomelabel_<outcomevar> is appended
//                  automatically)
//   testtypeprefix : optional prefix added to the logged test_type (e.g.
//                  "robustness" produces "robustness_pretrend" instead
//                  of plain "pretrend") - pass "" for a normal main-spec
//                  call
//   panelgphpath : if non-empty, saves the panel plot to this exact
//                  filepath as a .gph file, in addition to building it as
//                  an in-memory named graph. MUST be a real filepath the
//                  CALLER already holds (its own `tempfile' local
//                  declared before calling this program) - a tempfile
//                  declared INSIDE this program would already be erased
//                  by the time a caller tries to use it, since Stata
//                  erases a tempfile's underlying file when the program
//                  that declared it returns. Pass "" to skip saving.
capture program drop run_outcome_battery
program define run_outcome_battery
	args outcomevar spec treatedcond samplecond ncl nt nc plotname plottitle testtypeprefix panelgphpath coefdatapath

	local outcomelabel "${outcomelabel_`outcomevar'}"
	local ttprefix ""
	if `"`testtypeprefix'"' != "" {
		local ttprefix "`testtypeprefix'_"
	}

	local sampleclause ""
	if `"`samplecond'"' != "" {
		local sampleclause "if `samplecond'"
	}

	qui forvalues r = 0/7 {
		cap drop d`r'
		if `r' != 3 gen byte d`r' = (`treatedcond' & rel_year == `r')
	}

	qui areg `outcomevar' d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal] `sampleclause', absorb(firm_id) cluster(iso)
	// individual pre-trend tests: separate braces = three SEPARATE tests
	di as result "`spec' (`outcomevar'): individual pre-trend tests"
	boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
	global LT_outcome "`outcomevar'"
	global LT_spec "`spec'"
	global LT_testtype "`ttprefix'pretrend"
	global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
	global LT_dummyname "d0"
	log_test `ncl' 1
	global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
	global LT_dummyname "d1"
	log_test `ncl' 2
	global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
	global LT_dummyname "d2"
	log_test `ncl' 3
	// NC (2026-10-28): JOINT pre-trend test - one constraint list (no
	// braces) = a single Wald test of d0 = d1 = d2 = 0. This is the test
	// the paper describes. Same areg as above (still in e()).
	di as result "`spec' (`outcomevar'): joint pre-trend test (H0: d0 = d1 = d2 = 0)"
	boottest d0 d1 d2, weighttype(webb) nograph reps($reps)
	global LT_testtype "`ttprefix'pretrend_joint"
	global LT_nullhyp "no differential pre-trend, joint (H0: d0 = d1 = d2 = 0; t_stat column holds the Wald F)"
	global LT_dummyname ""
	log_test `ncl' ""

	qui cap drop post
	qui gen byte post = (`treatedcond' & rel_year >= 4)
	qui areg `outcomevar' d0 d1 d2 post i.cy [aweight=ebal] `sampleclause', absorb(firm_id) cluster(iso)
	di as result "`spec' (`outcomevar'): pooled post-treatment ATT"
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	global LT_testtype "`ttprefix'att"
	global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
	global LT_dummyname "post"
	log_test `ncl' ""

	if $run_unweighted {
		qui areg `outcomevar' d0 d1 d2 d4 d5 d6 d7 i.cy `sampleclause', absorb(firm_id) cluster(iso)
		di as result "`spec' (`outcomevar'): unweighted joint pre-trend test"
		boottest d0 d1 d2, weighttype(webb) nograph reps($reps)
		qui areg `outcomevar' d0 d1 d2 post i.cy `sampleclause', absorb(firm_id) cluster(iso)
		di as result "`spec' (`outcomevar'): unweighted pooled post-treatment ATT"
		boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	}

	local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'

	// re-estimate the full d0-d7 model right before pulling per-dummy
	// coefficients for the plot - the pooled-ATT areg just above replaces
	// d4-d7 with a single `post' dummy, so the last-estimated model at
	// this point does NOT contain d4/d5/d6/d7, and _b[d4] etc. would
	// error "not found" (or silently pull from the wrong model) without
	// this re-estimation.
	qui areg `outcomevar' d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal] `sampleclause', absorb(firm_id) cluster(iso)
	tempname pf
	tempfile res
	qui postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
	qui foreach r of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`r']
		qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`r' >= 4)
		post `pf' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
	}
	qui postclose `pf'
	// preserve/restore is NOT used here - this program is called from
	// inside an already-open preserve whenever the caller is
	// robustness_excl (which opens its own preserve before calling this),
	// and Stata does not allow nested preserve. Uses a manual tempfile
	// snapshot instead, so this program never touches Stata's preserve
	// stack regardless of caller depth.
	tempfile outcomedata_snapshot
	qui save "`outcomedata_snapshot'"
	qui use "`res'", clear

	if `"`coefdatapath'"' != "" {
		qui save "`coefdatapath'", replace
	}
	quietly {
	twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
	       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
	       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
	       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
	       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
		yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("`outcomelabel'", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
		xscale(range(0.5 8.5)) legend(off) ///
		subtitle("`plottitle': `outcomelabel'", justification(center) size(small)) ///
		note(`notearg', justification(left) size(vsmall)) ///
		name(`plotname', replace) nodraw
	}

	if `"`panelgphpath'"' != "" {
		qui graph save `plotname' "`panelgphpath'", replace
	}
	qui use "`outcomedata_snapshot'", clear
end

// robustness_excl: reruns EVERY outcome's pre-trend tests and pooled ATT
// after dropping one country's treated firms from a given arm, to check
// whether a result is really one dominant country-episode wearing the
// sub-sample's name.
//   label       : spec label (e.g. "Left populists")
//   exclcountry : country whose TREATED firms are dropped (e.g.
//                 "Indonesia") - its firms remain eligible as controls in
//                 other cohorts, exactly as in the main specs
//   treatvar    : the arm's treatment indicator - treat (Baseline), lpop
//                 (Left populists), or rpop (Right populists)
capture program drop robustness_excl
program define robustness_excl
	args label exclcountry treatvar
	preserve
	di as result "=== `label': leave-`exclcountry'-out robustness check ==="
	local samplecond "treat==0 | `treatvar'==1"
	qui keep if `samplecond'
	qui distinct firm_id if `treatvar'==1
	local nt_before = r(ndistinct)
	qui drop if `treatvar'==1 & country=="`exclcountry'"
	qui distinct firm_id if `treatvar'==1
	di as result "`label' (excl. `exclcountry'): treated firms = " r(ndistinct) " (was `nt_before')"
	// separate drops: `drop a b' fails as a whole (dropping nothing) if
	// either variable is missing, so `cap drop _ebalX ebal' left ebal in place
	cap drop _ebalX
	cap drop ebal
	pick_balancevars "`label' (excl. `exclcountry')" "relative_year==0 & `treatvar'==1"
	capture noisily ebalance `treatvar' `balancevars' if relative_year==0, gen(_ebalX)
	capture confirm variable _ebalX
	if _rc != 0 {
		di as error "`label' (excl. `exclcountry'): ebalance failed to converge"
		restore
		exit
	}
	qui egen ebal = mean(_ebalX), by(firm_id)
	qui distinct iso
	local ncl = r(ndistinct)
	qui distinct firm_id if `treatvar'==1
	local nt = r(ndistinct)
	qui distinct firm_id if treat==0
	local nc = r(ndistinct)
	di as result "`label' (excl. `exclcountry'): clusters = `ncl', control firms = `nc'"
	foreach outcome of global outcomelist {
		run_outcome_battery "`outcome'" "`label' (excl. `exclcountry')" "`treatvar'==1" "`samplecond'" `ncl' `nt' `nc' ///
			"robX_`outcome'" "`label' (excl. `exclcountry')" "robustness" ""
	}
	restore
end

results_log_init

//------------------------------------------------------------------------------
// 1. Baseline: full worldwide sample
//------------------------------------------------------------------------------
// Every treated firm, every episode, every control firm. Entropy balance
// is estimated once here (on ch_at's pre-trend); every outcome in
// $outcomelist is then regressed against that same reweighted sample.
use "$datafile", clear
quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at {
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

local plotlist1 ""
foreach outcome of global outcomelist {
	tempfile basegph_`outcome'
	run_outcome_battery "`outcome'" "Baseline" "treat==1" "" `ncl' `nt' `nc' "base_`outcome'" "Baseline" "" "`basegph_`outcome''"
	local plotlist1 `"`plotlist1' "`basegph_`outcome''""'
	qui graph use "`basegph_`outcome''"
	graph export "$plotpath/wild-baseline-`outcome'--$target_suffix.png", replace
}
graph combine `plotlist1', xcommon rows(3)
graph export "$plotpath/wild-baseline-allvars--$target_suffix.png", replace
graph drop _all

robustness_excl "Baseline" "Thailand" treat
robustness_excl "Baseline" "Indonesia" treat
graph drop _all

//------------------------------------------------------------------------------
// 2. Left / Right populists
//------------------------------------------------------------------------------
// Same worldwide control pool as Baseline. Splits treated firms by the
// ideology of the populist leader that treated them (lpop/rpop, mutually
// exclusive by construction below). Tests whether the precautionary-cash
// channel and the inflation-risk channel - which theory predicts operate
// differently for left- vs. right-wing populism - actually diverge across
// the whole asset-composition battery, not just cash. Includes a leave-
// dominant-country-out robustness check for each arm (Indonesia for Left,
// Thailand for Right - per sample_composition.csv, Indonesia is ~42% of
// Left's treated mass and Thailand ~54% of Right's).
use "$datafile", clear
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
// left un-quieted on purpose - sanity check that lpop/rpop partition the
// treated sample as intended
tab lpop relative_year if treat==0 | lpop==1
tab rpop relative_year if treat==0 | rpop==1
quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at {
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

local plotlist2l ""
local coeflist2l ""
foreach outcome of global outcomelist {
	tempfile lrgph_left_`outcome'
	tempfile lrcoef_left_`outcome'
	run_outcome_battery "`outcome'" "Left populists" "lpop==1" "treat==0 | lpop==1" `ncl' `nt' `nc' "left_`outcome'" "Left Populists" "" "`lrgph_left_`outcome''" "`lrcoef_left_`outcome''"
	local plotlist2l `"`plotlist2l' "`lrgph_left_`outcome''""'
	local coeflist2l `"`coeflist2l' "`lrcoef_left_`outcome''""'
}

// dominant-episode check: Indonesia is Left populists' largest single
// episode. NC (2026-10-28): now a genuine Left-arm exclusion - expect
// "treated firms = 97 (was 168)" in the log.
robustness_excl "Left populists" "Indonesia" lpop
graph drop _all

// ---- Right populists ----
use "$datafile", clear
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
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

local plotlist2r ""
local coeflist2r ""
foreach outcome of global outcomelist {
	tempfile lrgph_right_`outcome'
	tempfile lrcoef_right_`outcome'
	run_outcome_battery "`outcome'" "Right populists" "rpop==1" "treat==0 | rpop==1" `ncl' `nt' `nc' "right_`outcome'" "Right Populists" "" "`lrgph_right_`outcome''" "`lrcoef_right_`outcome''"
	local plotlist2r `"`plotlist2r' "`lrgph_right_`outcome''""'
	local coeflist2r `"`coeflist2r' "`lrcoef_right_`outcome''""'
}

// dominant-episode check: Thailand is Right populists' largest single
// episode. NC (2026-10-28): now a genuine Right-arm exclusion - expect
// "treated firms = 566 (was 1218)" in the log.
robustness_excl "Right populists" "Thailand" rpop
graph drop _all

// overlay plot per outcome: Left and Right BOTH on the same axes, not
// side by side - reads each arm's saved coefficient data (xpos/b/lo/hi/
// phase, saved via coefdatapath above) and draws one twoway combining
// both series, distinguished by color and marker shape. Replaces the
// previous side-by-side graph combine version at the user's explicit
// request ("I want both types of populist estimations on the same
// plot... use different color and markers to identify each line") -
// direct visual comparison of the two trajectories was the whole point,
// which two adjacent sub-panels don't give you as directly as one shared
// axis does. x-positions are offset by +/-0.08 for each arm so the two
// series' error bars don't sit exactly on top of each other and become
// illegible - same offset technique already used for the (now-removed)
// Transitioning Arm A/B overlay earlier in this project's history.
// NOTE: these overlays plot the two STANDALONE regressions (each arm
// against its own reweighted control group), not the pooled Equation 2
// specification in 10_left-right-equality-test.do.
local outcomeidx = 0
foreach outcome of global outcomelist {
	local outcomeidx = `outcomeidx' + 1
	local leftcoefpath : word `outcomeidx' of `coeflist2l'
	local rightcoefpath : word `outcomeidx' of `coeflist2r'
	local outcomelabel "${outcomelabel_`outcome'}"

	preserve
	qui use "`leftcoefpath'", clear
	qui gen byte arm = 1
	qui replace xpos = xpos - 0.08
	tempfile lrboth_`outcome'
	qui save "`lrboth_`outcome''"
	qui use "`rightcoefpath'", clear
	qui gen byte arm = 2
	qui replace xpos = xpos + 0.08
	qui append using "`lrboth_`outcome''"

	quietly {
	twoway (rcap hi lo xpos if arm==1, lcolor(midblue)) ///
	       (scatter b xpos if arm==1, mcolor(midblue) msymbol(O) connect(l) lcolor(midblue) lpattern(solid)) ///
	       (rcap hi lo xpos if arm==2, lcolor(cranberry)) ///
	       (scatter b xpos if arm==2, mcolor(cranberry) msymbol(Dh) connect(l) lcolor(cranberry) lpattern(dash)) ///
	       (scatteri 0 4, mcolor(black) msymbol(X) msize(medsmall)), ///
		yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("`outcomelabel'", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
		xscale(range(0.5 8.5)) ///
		legend(order(2 "Left populists" 4 "Right populists" 5 "Reference (t=-1)") rows(1) size(small) position(6)) ///
		title("Left vs. Right Populists: `outcomelabel'", size(medsmall)) ///
		name(lroverlay_`outcome', replace)
	}
	graph export "$plotpath/wild-left-right-`outcome'--$target_suffix.png", replace
	graph drop _all
	restore
}

//------------------------------------------------------------------------------
// Build readable Markdown summary from $resultslog
//------------------------------------------------------------------------------
// Reads $resultslog back in and writes $resultsmd - one top-level section
// per OUTCOME, then one sub-section per spec within that outcome, one row
// per test. Grouping by outcome first (rather than spec first) matches how
// this file is meant to be read: "here's the full cross-spec picture for
// intangibles," not "here's Baseline's results for nine different
// things."
preserve
import delimited "$resultslog", clear varnames(1) case(preserve) stringcols(_all)
destring t_stat p_value coefficient ci_low ci_high n_clusters n_obs, replace force

capture file close mdfile
file open mdfile using "$resultsmd", write replace
file write mdfile "# Results summary: $target_label (`c(current_date)')" _n _n
file write mdfile "Wild cluster bootstrap inference (Webb weights, null imposed, " ///
	"`=string($reps)' replications), clustered by country. Entropy-balance " ///
	"weights are estimated ONCE per spec (targeting ch_at's pre-trend) and " ///
	"reused for every outcome below - see the do-file header for why. " ///
	"See the do-file header for full method notes." _n _n
file write mdfile "**How to read this table:** each row is one hypothesis test. " ///
	"'H0' is the null hypothesis being tested - a low p-value (conventionally " ///
	"below 0.10) means the data are unlikely under that null, i.e. evidence " ///
	"AGAINST it. For pre-trend tests, that means evidence of a problem " ///
	"(differential pre-trend); 'pretrend' rows are individual tests, the " ///
	"'pretrend_joint' row is the joint Wald test (its t-stat column holds " ///
	"the F). For ATT tests, a low p-value means evidence of a treatment " ///
	"effect. Rows starting with 'robustness_' come from the same spec " ///
	"re-estimated after dropping that spec's dominant episode (the excluded " ///
	"country is named in the spec label), not the main-spec result. N is " ///
	"the number of firm-year observations in the underlying regression." _n _n

qui levelsof outcome, local(alloutcomes)
foreach o of local alloutcomes {
	local olabel "${outcomelabel_`o'}"
	file write mdfile "# `o' (`olabel')" _n _n
	qui levelsof spec if outcome == "`o'", local(specsforoutcome)
	foreach s of local specsforoutcome {
		file write mdfile "## `s'" _n _n
		file write mdfile "| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |" _n
		file write mdfile "|---|---|---|---|---|---|---|---|" _n
		forvalues obs = 1/`=_N' {
			if outcome[`obs'] == "`o'" & spec[`obs'] == "`s'" {
				local tt = test_type[`obs']
				local nh = null_hypothesis[`obs']
				local co = coefficient[`obs']
				local ts = t_stat[`obs']
				local pv = p_value[`obs']
				local lo = ci_low[`obs']
				local hi = ci_high[`obs']
				local nc = n_clusters[`obs']
				local no = n_obs[`obs']
				local sig = ""
				if `pv' < 0.10 & `pv' != . {
					local sig = " **"
				}
				file write mdfile "| `tt' | `nh' | " %6.4f (`co') " | " %6.3f (`ts') " | " %6.4f (`pv') "`sig' | [" %6.4f (`lo') ", " %6.4f (`hi') "] | `nc' | " %9.0fc (`no') " |" _n
			}
		}
		file write mdfile _n
	}
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
di as result "Specifications: Baseline, Left populists, Right populists"
di as result "Outcomes: $outcomelist"
di as result "=========================================="