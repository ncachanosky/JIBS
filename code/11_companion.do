/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
11: Companion do-file - descriptive / documentation tables for the paper
================================================================================
WHAT THIS FILE DOES
Extracts descriptive / documentation tables from master-analysis-sample.dta
(built by 08_build-analysis-sample.do) that are useful for the paper's data
section but are not themselves part of estimation. Read-only with respect
to the estimation sample used in 09_estimates-outcome-battery.do - this
file never estimates a treatment effect, it only describes the data that
file consumes. Run this AFTER 08 (which builds master-analysis-sample.dta)
and independently of 09/10 - this file does not need either to have been
run first, since it reads 08's output directly.
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
// 2. Table: Sample composition by split
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "2. Sample composition by split"
di as result "===================================================================="
tempname pf
tempfile comp
postfile `pf' str48 sample double n_treated double n_control double n_clusters ///
	str32 dominant_episode double dominant_share using "`comp'", replace

sample_stats `pf' "Baseline (full worldwide sample)" treat "1"
sample_stats `pf' "Left populists"  lpop "treat == 0 | lpop == 1"
sample_stats `pf' "Right populists" rpop "treat == 0 | rpop == 1"

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

// Scenario 2: Left populists
preserve
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui keep if treat==0 | lpop==1
foreach o of global outcomelist {
	winsorize_var `o'
}
outcome_sumstats `pf4' "Left populists" "1" "lpop==1" "Treated"
outcome_sumstats `pf4' "Left populists" "1" "treat==0" "Control"
restore

// Scenario 3: Right populists
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
foreach v in ch_at act_at act_ex_ch_at ppent_at ivaeq_at ivao_at intan_at ao_at invt_at ///
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
// 8. Table: Dataset coverage - country count and year range, by scenario
//------------------------------------------------------------------------------
capture program drop coverage_stats
program define coverage_stats
	args pfname scenario treatvar ifcond
	quietly {
		distinct iso if `treatvar' == 1 & (`ifcond')
		local ncl_t = r(ndistinct)
		distinct iso if `treatvar' == 0 & (`ifcond')
		local ncl_c = r(ndistinct)
		sum year if `treatvar' == 1 & (`ifcond')
		local ymin_t = r(min)
		local ymax_t = r(max)
		sum year if `treatvar' == 0 & (`ifcond')
		local ymin_c = r(min)
		local ymax_c = r(max)
	}
	di as result "`scenario' - Treated: `ncl_t' countries, `ymin_t'-`ymax_t' | Control: `ncl_c' countries, `ymin_c'-`ymax_c'"
	post `pfname' ("`scenario'") ("Treated") (`ncl_t') (`ymin_t') (`ymax_t')
	post `pfname' ("`scenario'") ("Control") (`ncl_c') (`ymin_c') (`ymax_c')
end

di as result "===================================================================="
di as result "8. Dataset coverage: country count and year range, by scenario"
di as result "===================================================================="
tempname pf8
tempfile coverage
postfile `pf8' str32 scenario str8 arm double n_countries double year_min double year_max using "`coverage'", replace

preserve
coverage_stats `pf8' "Wild (all)" treat "1"
restore

preserve
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left > 0 & treat==1
coverage_stats `pf8' "Left populists" lpop "treat==0 | lpop==1"
restore

preserve
coverage_stats `pf8' "Right populists" rpop "treat==0 | rpop==1"
restore

postclose `pf8'
preserve
use "`coverage'", clear
list, sep(0) noobs
export delimited using "`outpath'dataset_coverage.csv", replace
restore

//------------------------------------------------------------------------------
// Runtime
//------------------------------------------------------------------------------
timer off 98
qui timer list 98
local runtime_sec = r(t98)
di as result "11 run time: " %9.1f `runtime_sec'/60 " min"
