/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
11: Companion do-file - descriptive / documentation tables for the paper
================================================================================
WHAT THIS FILE DOES
Extracts descriptive / documentation tables from master-analysis-sample.dta
(built by 08_build-analysis-sample.do) that are useful for the paper's data
section but are not themselves part of estimation. Read-only with respect
to the estimation sample used in 10_estimates-outcome-battery.do - this
file never estimates a treatment effect, it only describes the data that
file consumes. Run this AFTER 08 (which builds master-analysis-sample.dta)
and independently of 10 - this file does not need 10 to have been run
first, since it reads 08's output directly, not 10's.

WHY THIS VERSION LOOKS DIFFERENT FROM THE PRIOR companion.do
The prior version of this file (companion.do, no number) was built against
master-stacked-firm-real.dta and log_ch, i.e. the CPI-deflated real-cash
outcome and the slope-vs-level dual ebalance-target comparison - both
retired earlier in this project in favor of ch_at (a currency-artifact-free
ratio, no deflation needed) and a single level-lag target with polity2
removed from the balance target entirely (though NOT removed from the
Fully-Democratic/Transitioning sample construction, which is a genuinely
different, still-current use of polity2 - see 10's header for that
distinction). This version:
  - reads master-analysis-sample.dta (08's output) instead of rebuilding
    rel_year/lpop/rpop/_wb_region itself - see 08's header for why
  - drops the log_ch/real_ch approach entirely; the outcome battery is the
    eight ch_at-style ratios currently in $outcomelist across 08/10
  - drops the slope-target balance columns and the polity2 balance-target
    rows from section 5 (Balance table) - reflects the current level-only,
    polity2-out-of-target design
  - runs sections 4 (outcome summary statistics) and 5 (balance table) per
    SCENARIO (Wild/all, Wild excl. non-treated, Left populists, Right
    populists - Left and Right kept as SEPARATE scenarios throughout, not
    pooled, since they're estimated as separate specs with separate
    entropy-balance weights in 10 - a pooled descriptive table wouldn't
    correspond to any actual estimation spec)
  - covers all eight outcomes in $outcomelist, not one

Produces, in output/tables/:
  1. episode_list.csv         - one row per populist-takeover episode
                                 (country, cohort year, ideology, region,
                                 # treated firms). leader_name/party columns
                                 are present but empty, with a note - not
                                 available in the pipeline yet, added here
                                 as placeholders so the table schema doesn't
                                 need to change again once that data exists.
  2. sample_composition.csv   - N's (treated/control firms, clusters,
                                 dominant-episode share) for EVERY sample
                                 split used in 10_estimates-outcome-
                                 battery.do (Baseline, Excluding, Left,
                                 Right, each continent, each WB income
                                 group, Fully Democratic, Transitioning
                                 Arms A/B) - not just the three headline
                                 scenarios, since this table is cheap and
                                 completeness here is more useful than
                                 curation.
  3. event_time_coverage.csv  - obs count by relative_year x treat, to
                                 confirm the panel is balanced (8
                                 periods/firm) as built. Global, not
                                 per-scenario.
  4. outcome_summary_stats.csv - mean/sd/min/max for all eight outcomes,
                                 treated vs. control, PRE-TREATMENT
                                 (relative_year<0) only, for each of the
                                 four scenarios (Wild all, Wild excl.
                                 non-treated, Left, Right).
  5. balance_table.csv        - raw (pre-ebalance) vs. entropy-balanced
                                 treated/control means for ch_at's four
                                 level lags, for each of the four scenarios
                                 - motivates why entropy balancing is
                                 needed and confirms it's doing its job,
                                 same purpose as the prior version's
                                 section 4, updated for the current
                                 level-only design.
  6. missingness_by_variable.csv - % missing for every outcome and every
                                 balance-relevant variable, global (not
                                 per-scenario) - for the data appendix.
  7. polity2_coverage.csv     - country-level Polity2 merge coverage.
                                 Kept from the prior version: polity2 still
                                 gates the Fully Democratic/Transitioning
                                 sample construction even though it's out
                                 of the entropy-balance target, so this
                                 coverage gap is still live and worth
                                 documenting.
==============================================================================*/

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
quietly {
clear all
set more off
}

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-analysis-sample.dta"
local outpath "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\output\tables\"

global outcomelist "ch_at act_at act_ex_ch_at ppent_at ivaeq_at ivao_at intan_at ao_at"
global outcomelabel_ch_at        "Cash / Assets"
global outcomelabel_act_at       "Current Assets / Assets"
global outcomelabel_act_ex_ch_at "Current Assets ex. Cash / Assets"
global outcomelabel_ppent_at     "Net PP&E / Assets"
global outcomelabel_ivaeq_at     "Equity Investments / Assets"
global outcomelabel_ivao_at      "Other Investments / Assets"
global outcomelabel_intan_at     "Intangibles / Assets"
global outcomelabel_ao_at        "Other Assets / Assets"

timer clear 98
timer on 98

use "$datafile", clear

//------------------------------------------------------------------------------
// Helper program: winsorize_var - same logic as 10_estimates-outcome-
// battery.do, reproduced here since this file doesn't share a running
// Stata session with that one. Called fresh within each scenario's own
// preserve block, so each scenario's outcomes are capped at ITS OWN 1st/
// 99th percentile, not the full sample's - see 08's header for why
// winsorization isn't done once centrally.
//------------------------------------------------------------------------------
capture program drop winsorize_var
program define winsorize_var
	args varname
	qui centile `varname', centile(1 99)
	local p1 = r(c_1)
	local p99 = r(c_2)
	qui replace `varname' = `p1'  if `varname' < `p1'  & !missing(`varname')
	qui replace `varname' = `p99' if `varname' > `p99' & !missing(`varname')
end

//------------------------------------------------------------------------------
// Helper program: sample composition stats for one treatment/sample split
//------------------------------------------------------------------------------
// Posts one row to the open postfile `pfname': label, N treated firms, N
// control firms, N clusters (iso), and the dominant-episode share.
// NC: FIXED before this ever ran - sample_stats is called from MULTIPLE
// places in section 2 that are themselves already inside an open
// `preserve' (the continent loop, the Fully Democratic/Transitioning
// block). This program's own dominant-episode lookup used to do its own
// internal `preserve'/`restore', which would nest inside whatever the
// caller already had open - the exact bug class already found and fixed
// twice elsewhere in this project (a prior version of the Transitioning
// section, and run_outcome_battery). Caught here by checking every call
// site's surrounding context before this file was shipped, not by
// waiting for the r(621) "already preserved" error to surface. Fixed the
// same way as those two prior fixes: a manual tempfile save/reload
// instead of preserve/restore, so this program never touches Stata's
// preserve stack regardless of how deeply nested the caller already is.
capture program drop sample_stats
program define sample_stats
	args pfname label treatvar ifcond
	quietly {
		distinct firm_id if `treatvar' == 1 & relative_year == 0 & (`ifcond')
		local nt = r(ndistinct)
		distinct firm_id if `treatvar' == 0 & relative_year == 0 & (`ifcond')
		local nc = r(ndistinct)
		distinct iso if relative_year == 0 & (`ifcond') & !missing(`treatvar')
		local ncl = r(ndistinct)
		local dom_country = ""
		local dom_share = .
		if `nt' > 0 {
			tempfile sample_stats_snapshot
			save "`sample_stats_snapshot'"
			keep if `treatvar' == 1 & relative_year == 0 & (`ifcond')
			egen firm_tag = tag(firm_id)
			keep if firm_tag == 1
			contract country
			gsort -_freq
			local dom_country = country[1]
			local dom_share = _freq[1] / `nt' * 100
			use "`sample_stats_snapshot'", clear
		}
	}
	di as result "`label': `nt' treated firms, `nc' control firms, `ncl' clusters (iso), dominant episode = `dom_country' (" %4.1f `dom_share' "%)"
	post `pfname' ("`label'") (`nt') (`nc') (`ncl') ("`dom_country'") (`dom_share')
end

//------------------------------------------------------------------------------
// 1. Table: Populist takeover episodes
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "1. Populist takeover episodes"
di as result "===================================================================="
preserve
quietly {
	keep if treat == 1 & relative_year == 0
	gen ideology = "Unclassified"
	replace ideology = "Left"  if lpop == 1
	replace ideology = "Right" if rpop == 1
	// NC: leader_name/party not available in the pipeline yet - placeholder
	// columns so the schema doesn't need to change once that data exists.
	gen leader_name = ""
	gen party_name = ""
	collapse (first) country continent region subregion _wb_region ideology ///
	         leader_name party_name (count) n_treated_firms = firm_id, by(iso cohort)
	rename cohort takeover_year
	rename _wb_region wb_income_group
	order iso country continent region subregion wb_income_group ///
	      takeover_year ideology leader_name party_name n_treated_firms
}
list, sep(0) noobs
export delimited using "`outpath'episode_list.csv", replace
restore

//------------------------------------------------------------------------------
// 2. Table: Sample composition by split (every spec used in 10)
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "2. Sample composition by split"
di as result "===================================================================="
tempname pf
tempfile comp
postfile `pf' str48 sample double n_treated double n_control double n_clusters ///
	str32 dominant_episode double dominant_share using "`comp'", replace

sample_stats `pf' "Baseline (full worldwide sample)" treat "1"

preserve
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
sample_stats `pf' "Excluding no-treated regions" treat "1"
restore

sample_stats `pf' "Left populists"  lpop "treat == 0 | lpop == 1"
sample_stats `pf' "Right populists" rpop "treat == 0 | rpop == 1"

preserve
qui drop if continent == "Africa" | continent == "Americas" | continent == "Oceania"
quietly levelsof continent, local(continents)
foreach c of local continents {
	sample_stats `pf' "Continent: `c'" treat `"continent == "`c'""'
}
restore

quietly levelsof _wb_region, local(wbregions)
foreach r of local wbregions {
	if "`r'" != "" {
		sample_stats `pf' "WB income group: `r'" treat `"_wb_region == "`r'""'
	}
}

preserve
qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)
sample_stats `pf' "Fully Democratic Sample" treat "dem_sample==1"
qui egen ndem_post = total(polity2<=5 & relative_year>0), by(firm_id)
qui egen dem_pre = total(polity2>5 & relative_year<0), by(firm_id)
qui gen trans_sample = . if treat==1 & relative_year==0
qui replace trans_sample = 1 if dem_sample==1 & treat==0
qui replace trans_sample = 1 if dem_sample==1 & treat==1
qui replace trans_sample = 1 if dem_pre==4 & ndem_post > 0 & treat==1
qui gen byte groupA = (treat == 1 & ndem_post == 0)
qui gen byte groupB = (treat == 1 & ndem_post > 0)
sample_stats `pf' "Transitioning: Arm A (populist-only)" groupA "trans_sample==1"
sample_stats `pf' "Transitioning: Arm B (exits democracy)" groupB "trans_sample==1"
restore

postclose `pf'
preserve
use "`comp'", clear
list, sep(0) noobs
export delimited using "`outpath'sample_composition.csv", replace
restore

//------------------------------------------------------------------------------
// 3. Table: Event-time coverage (confirms the panel is balanced as built,
//    global - not per-scenario, this is a property of the panel itself)
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "3. Event-time coverage (obs by relative_year x treat)"
di as result "===================================================================="
preserve
quietly contract relative_year treat
export delimited using "`outpath'event_time_coverage.csv", replace
restore
tab relative_year treat

//------------------------------------------------------------------------------
// 4. Table: Outcome summary statistics, pre-treatment, by scenario
//------------------------------------------------------------------------------
// Mean/SD/min/max for all eight outcomes, treated vs. control,
// relative_year<0 only (pre-treatment - post-treatment means would already
// reflect any treatment effect, which is not what a descriptive table
// should be summarizing). Left and Right kept as SEPARATE scenarios - see
// file header for why pooling them wouldn't correspond to any actual
// estimation spec.
di as result "===================================================================="
di as result "4. Outcome summary statistics (pre-treatment, by scenario)"
di as result "===================================================================="
tempname pf4
tempfile sumstats
postfile `pf4' str48 scenario str16 outcome str8 arm double mean double sd ///
	double min double max double n using "`sumstats'", replace

capture program drop outcome_sumstats
program define outcome_sumstats
	args pfname scenario ifcond treatcond arm
	foreach o of global outcomelist {
		quietly sum `o' if relative_year<0 & (`ifcond') & (`treatcond'), detail
		post `pfname' ("`scenario'") ("`o'") ("`arm'") (r(mean)) (r(sd)) (r(min)) (r(max)) (r(N))
	}
end

// Scenario 1: Wild (all)
preserve
foreach o of global outcomelist {
	winsorize_var `o'
}
outcome_sumstats `pf4' "Wild (all)" "1" "treat==1" "Treated"
outcome_sumstats `pf4' "Wild (all)" "1" "treat==0" "Control"
restore

// Scenario 2: Wild (excl. non-treated regions)
preserve
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
foreach o of global outcomelist {
	winsorize_var `o'
}
outcome_sumstats `pf4' "Wild (excl. non-treated)" "1" "treat==1" "Treated"
outcome_sumstats `pf4' "Wild (excl. non-treated)" "1" "treat==0" "Control"
restore

// Scenario 3: Left populists
preserve
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui keep if treat==0 | lpop==1
foreach o of global outcomelist {
	winsorize_var `o'
}
outcome_sumstats `pf4' "Left populists" "1" "lpop==1" "Treated"
outcome_sumstats `pf4' "Left populists" "1" "treat==0" "Control"
restore

// Scenario 4: Right populists
preserve
qui keep if treat==0 | rpop==1
foreach o of global outcomelist {
	winsorize_var `o'
}
outcome_sumstats `pf4' "Right populists" "1" "rpop==1" "Treated"
outcome_sumstats `pf4' "Right populists" "1" "treat==0" "Control"
restore

postclose `pf4'
preserve
use "`sumstats'", clear
list, sep(0) noobs
export delimited using "`outpath'outcome_summary_stats.csv", replace
restore

//------------------------------------------------------------------------------
// 5. Table: Treated vs. control balance on ch_at's level lags, raw and
//    post-ebalance, by scenario
//------------------------------------------------------------------------------
// Motivates entropy balancing (raw columns show how far apart treated and
// control firms are before reweighting) and confirms it's doing its job.
// Level-lag target only (matches 10's current design - polity2 is NOT in
// the balance target, see 10's header; the old slope-target columns from
// the prior version of this file are dropped for the same reason).
di as result "===================================================================="
di as result "5. Treated vs. control balance on ch_at level lags (raw + post-ebalance)"
di as result "===================================================================="

capture program drop balance_stats
program define balance_stats
	args pfname scenario treatvar ifcond
	quietly {
	keep if relative_year == 0 & (`ifcond')
	capture noisily ebalance `treatvar' ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4, gen(_ebal)
	capture confirm variable _ebal
	local ebal_ok = (_rc == 0)
	if !`ebal_ok' {
		di as error "5. `scenario': ebalance failed to converge - post-ebalance columns will be missing"
	}
	}
	foreach v in ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4 {
		quietly sum `v' if `treatvar' == 0
		local mc = r(mean)
		local sc = r(sd)
		local nc = r(N)
		quietly sum `v' if `treatvar' == 1
		local mt = r(mean)
		local st = r(sd)
		local nt = r(N)
		local mce = .
		local sce = .
		if `ebal_ok' {
			quietly sum `v' [aweight = _ebal] if `treatvar' == 0
			local mce = r(mean)
			local sce = r(sd)
		}
		di as result "`scenario' - `v': control raw mean=" %6.3f `mc' " | treat mean=" %6.3f `mt' " | control ebal mean=" %6.3f `mce'
		post `pfname' ("`scenario'") ("`v'") (`mc') (`sc') (`nc') (`mt') (`st') (`nt') (`mce') (`sce')
	}
end

tempname pf5
tempfile bal
postfile `pf5' str48 scenario str16 variable ///
	double mean_control_raw double sd_control_raw double n_control ///
	double mean_treat double sd_treat double n_treat ///
	double mean_control_ebal double sd_control_ebal ///
	using "`bal'", replace

preserve
balance_stats `pf5' "Wild (all)" treat "1"
restore

preserve
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
balance_stats `pf5' "Wild (excl. non-treated)" treat "1"
restore

preserve
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left > 0 & treat==1
balance_stats `pf5' "Left populists" lpop "treat==0 | lpop==1"
restore

preserve
balance_stats `pf5' "Right populists" rpop "treat==0 | rpop==1"
restore

postclose `pf5'
preserve
use "`bal'", clear
list, sep(0) noobs
export delimited using "`outpath'balance_table.csv", replace
restore

//------------------------------------------------------------------------------
// 6. Table: Missingness by variable (global, for the data appendix)
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "6. Missingness by variable"
di as result "===================================================================="
tempname pf6
tempfile missing
postfile `pf6' str16 variable double pct_missing double n_missing double n_total using "`missing'", replace
foreach v in ch_at act_at act_ex_ch_at ppent_at ivaeq_at ivao_at intan_at ao_at ///
	ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4 polity2 {
	quietly count if missing(`v')
	local nmiss = r(N)
	quietly count
	local ntot = r(N)
	post `pf6' ("`v'") (`nmiss'/`ntot'*100) (`nmiss') (`ntot')
}
postclose `pf6'
preserve
use "`missing'", clear
list, sep(0) noobs
export delimited using "`outpath'missingness_by_variable.csv", replace
restore

//------------------------------------------------------------------------------
// 7. Table: Polity2 merge coverage by country
//------------------------------------------------------------------------------
// polity2 still gates the Fully Democratic/Transitioning sample
// construction in 10 even though it's out of the entropy-balance target -
// this coverage gap is still live and worth documenting.
di as result "===================================================================="
di as result "7. Polity2 coverage by country"
di as result "===================================================================="
preserve
quietly {
	gen polity_missing = missing(polity2)
	collapse (mean) pct_missing = polity_missing (count) n_obs = polity2, by(country)
	replace pct_missing = pct_missing * 100
	gsort -pct_missing country
}
list country pct_missing n_obs if pct_missing > 0, sep(0) noobs
export delimited using "`outpath'polity2_coverage.csv", replace
restore

//------------------------------------------------------------------------------
// Runtime
//------------------------------------------------------------------------------
timer off 98
qui timer list 98
local runtime_sec = r(t98)
di as result "11 run time: " %9.1f `runtime_sec'/60 " min"
