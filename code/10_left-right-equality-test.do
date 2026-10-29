/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
Left vs. Right populists: formal equality test across the outcome battery
================================================================================
WHAT THIS FILE DOES
The main outcome-battery file (09_estimates-outcome-battery.do) estimates Left
and Right populists as two SEPARATE specifications, each against the full
worldwide control pool, each with its OWN entropy-balance weights. That
design answers "does Left populism affect outcome X" and "does Right
populism affect outcome X" independently, but it cannot answer "does Left
populism's effect on X differ from Right's" - comparing two point estimates
from two separate regressions is not a test, and reporting "Left's
coefficient is roughly double Right's" without a formal comparison is
exactly the kind of claim a referee will ask to see tested properly.

This file exists to run that test directly, for every outcome in the
battery: Left- and Right-populist-treated firms are pooled into ONE
regression against a SHARED control pool, with separate event-time dummy
sets for each arm (dL0-dL7 for Left, dR0-dR7 for Right), and a wild cluster
bootstrap equality test on the pooled post-treatment effect (H0: Left's ATT
= Right's ATT) for every outcome. This mirrors exactly the design already
used for the Transitioning Arm A vs Arm B contrast in the main file - same
mechanics, same inference approach, different pair of arms.
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
                              // ~200-500 for exploratory runs.

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

global target_label  "Level-Lag Ebalance"
global target_suffix "level"

// log_test overrides - empty by default, set only around the tests that
// need them (see log_test)
global LT_coef ""
global LT_ciscale ""

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-stacked-firm.dta"
global plotpath "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/plots"
global resultslog "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-log--leftright-equality--$target_suffix.csv"
global resultsmd  "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-summary--leftright-equality--$target_suffix.md"

timer clear 99
timer on 99

//------------------------------------------------------------------------------
// RESULTS LOGGING (readable CSV + Markdown output, alongside the console log)
//------------------------------------------------------------------------------
// Same mechanism as 09_estimates-outcome-battery.do - see that file's header
// for the full explanation of hypindex/multi-hypothesis boottest results.
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
	if "$LT_ciscale" != "" {
		local ci_lo = `ci_lo' / $LT_ciscale
		local ci_hi = `ci_hi' / $LT_ciscale
	}
	local coef = .
	if "$LT_dummyname" != "" {
		capture local coef = _b[$LT_dummyname]
	}
	if "$LT_coef" != "" {
		local coef = $LT_coef
	}
	local nobs = .
	capture local nobs = e(N)
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

// build_outcomevars: primary source is master-stacked-firm.dta's own
// columns (built upstream) - see this file's header. Fallback gen only
// fires if a column is genuinely missing.
capture program drop build_outcomevars
program define build_outcomevars
	quietly {
	capture confirm variable ch_at
	if _rc != 0 {
		gen ch_at = ch / at if at > 0
	}
	capture confirm variable act_at
	if _rc != 0 {
		gen act_at = act / at if at > 0
	}
	capture confirm variable act_ex_ch_at
	if _rc != 0 {
		gen act_ex_ch_at = (act - ch) / at if at > 0
	}
	capture confirm variable ppent_at
	if _rc != 0 {
		gen ppent_at = ppent / at if at > 0
	}
	capture confirm variable ivaeq_at
	if _rc != 0 {
		gen ivaeq_at = ivaeq / at if at > 0
	}
	capture confirm variable ivao_at
	if _rc != 0 {
		gen ivao_at = ivao / at if at > 0
	}
	capture confirm variable intan_at
	if _rc != 0 {
		gen intan_at = intan / at if at > 0
	}
	capture confirm variable ao_at
	if _rc != 0 {
		gen ao_at = ao / at if at > 0
	}
	capture confirm variable invt_at
	if _rc != 0 {
		gen invt_at = invt / at if at > 0
	}
	}
	foreach v of global outcomelist {
		winsorize_var `v'
	}
end

results_log_init

//------------------------------------------------------------------------------
// Left vs. Right populists: pooled sample, shared weights, formal equality test
//------------------------------------------------------------------------------
// Sample: control firms (treat==0) plus BOTH Left- and Right-populist-
// treated firms, in one dataset. lpop/rpop are rebuilt exactly as in
// 09_estimates-outcome-battery.do (mutually exclusive by construction, tagged
// at the firm level so every relative_year for a treated firm carries the
// same arm assignment).
use "$datafile", clear
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
qui keep if treat==0 | lpop==1 | rpop==1

// left un-quieted on purpose - confirms the pooled sample's arm
// composition before any estimation runs
di as result "Left vs Right pooled sample: firm counts by arm"
tab lpop rpop if relative_year==0, missing

quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
bysort firm_id (relative_year): gen ch_at_l1 = L1.ch_at
bysort firm_id (relative_year): gen ch_at_l2 = L2.ch_at
bysort firm_id (relative_year): gen ch_at_l3 = L3.ch_at
bysort firm_id (relative_year): gen ch_at_l4 = L4.ch_at
egen cy = group(cohort year)
}

// ---- Entropy balance: ONE set of weights, targeting the COMBINED
// Left+Right treated group's ch_at pre-trend (see header for why this is
// deliberately different from the main file's separately-weighted
// Left-only and Right-only sections) ----
qui gen byte treated_either = (lpop==1 | rpop==1)
qui ebalance treated_either ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4 if relative_year==0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if lpop==1
local ntL = r(ndistinct)
distinct firm_id if rpop==1
local ntR = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Left vs Right pooled: `ntL' Left-treated, `ntR' Right-treated, `nc' control firms, `ncl' clusters"

// weight-concentration diagnostic - same check used throughout
// 09_estimates-outcome-battery.do
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
di as result "Left vs Right pooled: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Left vs Right pooled: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"

// ---- dL/dR dummy sets, one pair per relative year (mirrors Transitioning
// Arm A/B's dA/dB structure exactly) ----
qui forvalues k = 0/7 {
	if `k' != 3 {
		cap drop dL`k' dR`k'
		gen byte dL`k' = (lpop==1 & rel_year==`k')
		gen byte dR`k' = (rpop==1 & rel_year==`k')
	}
}
qui gen byte postL = (lpop==1 & rel_year>=4)
qui gen byte postR = (rpop==1 & rel_year>=4)

local plotlist ""
foreach outcome of global outcomelist {
	local outcomelabel "${outcomelabel_`outcome'}"

	// full event-time regression, both arms - needed for the full-profile
	// equality test and for the per-dummy plot points below
	qui areg `outcome' dL0 dL1 dL2 dL4 dL5 dL6 dL7 dR0 dR1 dR2 dR4 dR5 dR6 dR7 i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)

	di as result "`outcome': Left vs Right, full profile equality"
	boottest {dL0=dR0} {dL1=dR1} {dL2=dR2} {dL4=dR4} {dL5=dR5} {dL6=dR6} {dL7=dR7}, ///
		weighttype(webb) reps($reps) level(90) nograph
	global LT_outcome "`outcome'"
	global LT_spec "Left vs Right populists"
	global LT_testtype "arm_equality"
	global LT_dummyname ""
	global LT_nullhyp "Left and Right populists have the same effect at t=-4 (H0: dL0 = dR0)"
	log_test `ncl' 1
	global LT_nullhyp "Left and Right populists have the same effect at t=-3 (H0: dL1 = dR1)"
	log_test `ncl' 2
	global LT_nullhyp "Left and Right populists have the same effect at t=-2 (H0: dL2 = dR2)"
	log_test `ncl' 3
	global LT_nullhyp "Left and Right populists have the same effect at t=0 (H0: dL4 = dR4)"
	log_test `ncl' 4
	global LT_nullhyp "Left and Right populists have the same effect at t=1 (H0: dL5 = dR5)"
	log_test `ncl' 5
	global LT_nullhyp "Left and Right populists have the same effect at t=2 (H0: dL6 = dR6)"
	log_test `ncl' 6
	global LT_nullhyp "Left and Right populists have the same effect at t=3 (H0: dL7 = dR7)"
	log_test `ncl' 7

	// NC (2026-10-29): joint pre-trend test for each arm, same full
	// event-time regression (still in e()). One constraint list, no
	// braces = one joint Wald test.
	di as result "`outcome': Left populists, joint pre-trend test (H0: dL0 = dL1 = dL2 = 0)"
	boottest dL0 dL1 dL2, weighttype(webb) reps($reps) nograph
	global LT_testtype "pretrend_joint_left"
	global LT_nullhyp "no differential Left-populist pre-trend, joint (H0: dL0 = dL1 = dL2 = 0; t_stat column holds the Wald F)"
	global LT_dummyname ""
	log_test `ncl' ""

	di as result "`outcome': Right populists, joint pre-trend test (H0: dR0 = dR1 = dR2 = 0)"
	boottest dR0 dR1 dR2, weighttype(webb) reps($reps) nograph
	global LT_testtype "pretrend_joint_right"
	global LT_nullhyp "no differential Right-populist pre-trend, joint (H0: dR0 = dR1 = dR2 = 0; t_stat column holds the Wald F)"
	global LT_dummyname ""
	log_test `ncl' ""

	// ---- the headline test: pooled post-treatment ATT equality ----
	qui areg `outcome' dL0 dL1 dL2 postL dR0 dR1 dR2 postR i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)
	di as result "`outcome': Left vs Right, pooled post-treatment ATT equality (H0: Left ATT = Right ATT)"
	boottest {postL=postR}, weighttype(webb) reps($reps) level(90) nograph
	global LT_testtype "arm_equality_att"
	global LT_nullhyp "Left and Right populists have the same pooled post-treatment ATT (H0: postL = postR)"
	log_test `ncl' ""

	// Left-only and Right-only ATTs from THIS pooled/shared-weight
	// regression, reported alongside the equality test as reference points
	// - NOTE these will not exactly match 09_estimates-outcome-battery.do's
	// separate Left-only/Right-only sections, since weights differ by
	// design (see header).
	di as result "`outcome': Left populists ATT (pooled-weight regression, for reference)"
	boottest {postL}, weighttype(webb) reps($reps) level(90) nograph
	global LT_testtype "att_pooledweight"
	global LT_nullhyp "no average Left-populist treatment effect in periods 0-3, pooled-weight regression (H0: postL = 0)"
	global LT_dummyname "postL"
	log_test `ncl' ""

	di as result "`outcome': Right populists ATT (pooled-weight regression, for reference)"
	boottest {postR}, weighttype(webb) reps($reps) level(90) nograph
	global LT_testtype "att_pooledweight"
	global LT_nullhyp "no average Right-populist treatment effect in periods 0-3, pooled-weight regression (H0: postR = 0)"
	global LT_dummyname "postR"
	log_test `ncl' ""

	foreach arm in L R {
		local armname = cond("`arm'"=="L", "Left", "Right")
		local armlow  = cond("`arm'"=="L", "left", "right")
		qui lincom post`arm' - (d`arm'0 + d`arm'1 + d`arm'2)/4
		global LT_coef = r(estimate)
		di as result "`outcome': `armname' populists ATT re-baselined to pre-period mean (H0: post`arm' - (d`arm'0+d`arm'1+d`arm'2)/4 = 0)"
		boottest {4*post`arm' - d`arm'0 - d`arm'1 - d`arm'2 = 0}, weighttype(webb) reps($reps) level(90) nograph
		global LT_ciscale 4
		global LT_testtype "att_rebaselined_`armlow'"
		global LT_nullhyp "no average `armname'-populist effect in periods 0-3 relative to the mean of periods -4..-1, pooled-weight regression"
		global LT_dummyname ""
		log_test `ncl' ""
		global LT_coef ""
		global LT_ciscale ""
	}

	// ---- event-study plot: Left vs Right side by side, one panel per
	// outcome, same visual design as Transitioning Arm A/B's plot ----
	qui areg `outcome' dL0 dL1 dL2 dL4 dL5 dL6 dL7 dR0 dR1 dR2 dR4 dR5 dR6 dR7 i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)
	tempname pf
	tempfile res
	qui postfile `pf' double xpos double b double lo double hi byte arm byte phase using "`res'", replace
	qui foreach arm in L R {
		local off = cond("`arm'"=="L", -0.12, 0.12)
		local armnum = cond("`arm'"=="L", 1, 2)
		foreach k of numlist 0 1 2 4 5 6 7 {
			local b = _b[d`arm'`k']
			qui boottest d`arm'`k', weighttype(webb) reps($reps) level(90) nograph
			matrix ci = r(CI)
			local phase = (`k' >= 4)
			post `pf' (`k' + 1 + `off') (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`armnum') (`phase')
		}
	}
	qui postclose `pf'
	local notearg `""`ntL' Left-treated, `ntR' Right-treated, `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters. Weights shared across arms - see file header.""'
	tempfile outcomedata_snapshot
	qui save "`outcomedata_snapshot'"
	qui use "`res'", clear
	quietly {
	twoway (rcap hi lo xpos if arm==1, lcolor(midblue)) ///
	       (scatter b xpos if arm==1, mcolor(midblue) msymbol(O)) ///
	       (rcap hi lo xpos if arm==2, lcolor(cranberry)) ///
	       (scatter b xpos if arm==2, mcolor(cranberry) msymbol(Oh)) ///
	       (scatteri 0 4, mcolor(navy) msymbol(D) msize(medsmall)), ///
		yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("`outcomelabel'", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
		xscale(range(0.5 8.5)) ///
		legend(order(2 "Left populists" 4 "Right populists" 5 "Reference (t=-1)") ///
		       rows(1) size(vsmall) position(6)) ///
		subtitle("Left vs Right: `outcomelabel'", justification(center) size(small)) ///
		note(`notearg', justification(left) size(vsmall)) ///
		name(lr_`outcome', replace) nodraw
	}
	qui use "`outcomedata_snapshot'", clear
	local plotlist "`plotlist' lr_`outcome'"
}

graph combine `plotlist', xcommon rows(3)
graph export "$plotpath/wild-left-right-equality-allvars--$target_suffix.png", replace

//------------------------------------------------------------------------------
// Build readable Markdown summary from $resultslog
//------------------------------------------------------------------------------
preserve
import delimited "$resultslog", clear varnames(1) case(preserve) stringcols(_all)
destring t_stat p_value coefficient ci_low ci_high n_clusters n_obs, replace force

capture file close mdfile
file open mdfile using "$resultsmd", write replace
file write mdfile "# Left vs. Right Populists: Formal Equality Test (`c(current_date)')" _n _n
file write mdfile "Wild cluster bootstrap inference (Webb weights, null imposed, " ///
	"`=string($reps)' replications), clustered by country. ONE shared set of " ///
	"entropy-balance weights, targeting the combined Left+Right treated group's " ///
	"ch_at pre-trend - see the do-file header for why this differs from " ///
	"09_estimates-outcome-battery.do's separately-weighted Left-only/Right-only " ///
	"sections. " _n _n
file write mdfile "**How to read this table:** 'arm_equality'/'arm_equality_att' rows test " ///
	"whether Left's and Right's effects DIFFER (H0: they're equal) - a low " ///
	"p-value here is evidence Left and Right populists have genuinely different " ///
	"effects, not just different point estimates. 'att_pooledweight' rows are " ///
	"each arm's own ATT under the shared weighting scheme, included as a " ///
	"reference point, not a headline result." _n _n

qui levelsof outcome, local(alloutcomes)
foreach o of local alloutcomes {
	local olabel "${outcomelabel_`o'}"
	file write mdfile "# `o' (`olabel')" _n _n
	file write mdfile "| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters | N |" _n
	file write mdfile "|---|---|---|---|---|---|---|---|" _n
	forvalues obs = 1/`=_N' {
		if outcome[`obs'] == "`o'" {
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
file write mdfile "*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance.)*" _n
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
di as result "Settings: reps=$reps"
di as result "=========================================="