/********************************************************************************
Project: JIBS Paper
File: 02_regressions.do
Authors: Joao P. Bastos, Nicolás Cachanosky, John D. Gibson
Email: ncachanosky@utep.edu
Institution: The University of Texas at El Paso
Created: 26-Nov-2025
Last Modified: 28-Nov-2025

Description:
    Main regression analysis for populism and private investment paper.
    Tests four-quadrant typology of populism (PIP vs PEP) and examines
    effects on private gross fixed capital formation.

Usage:
    do 02_regressions.do
    
Outline:
    - 1. Setup and configuration
    - 2. Load data and create variables
    - 3. Descriptive statistics
    - 4. Main regressions (contemporaneous)
    - 5. Robustness checks
    - 6. Institutional moderators
    - 7. Lagged specifications
    - 8. Export results
    
Dependencies:
    - 01_data_builder.do (must be run first)
    - estout package (for table export)
********************************************************************************/

* ==============================================================================
* 1. SETUP AND CONFIGURATION
* ==============================================================================

clear all
set more off

* Install packages
ssc install estout
ssc install boottest


* Set your working directory
global root "C:/Users/ncachanosky/OneDrive/Research/Working Papers/paper-JIBS/"
cd "$root"

global data_raw     "$root\data\raw"
global data_proc    "$root\data\processed"
global code         "$root\code\stata"
global output       "$root\output"
global figures      "$output\figures"
global tables       "$output\tables"
global logs         "$output\logs"


* ==============================================================================
* 2. LOAD DATA
* ==============================================================================
use "$data_proc/data", clear

gen q2_doll = quad_2 * dollarized
gen q3_doll = quad_3 * dollarized  
gen q4_doll = quad_4 * dollarized

gen D_PEP_z = PEP_z * dollarized
gen D_PIP_z = PIP_z * dollarized


* ==============================================================================
* 3. DESCRIPTIVE STATISTICS
* ==============================================================================

* Check for high correlation between PEP and PIP
correl PEP PIP
summarize PEP PIP

* List observations by quadrant	  
tab YEAR quadrant
tab countryname if quad_1 == 1, missing 	// Control group (no populism)
tab countryname if quad_2 == 1, missing 	// High PEP
tab countryname if quad_3 == 1, missing		// High PIP
tab countryname if quad_4 == 1, missing 	// High PEP & PIP
	
* ==============================================================================
* 4. MAIN REGRESSIONS
* ==============================================================================
* Choose a dependent variable
global Y "WDI_03" 

* ------------------------------------------------------------------------------
* Missing observations
* ------------------------------------------------------------------------------
foreach var in WDI_03 WDI_02 WDI_05 WDI_06 GFD_02 {
    quietly count if missing(`var')
    local n_miss = r(N)
    quietly count
    local n_total = r(N)
    local pct = (`n_miss'/`n_total')*100
    display "  `var': " %4.0f `n_miss' " missing (" %4.1f `pct' "%)"
}

mark complete_data
markout complete_data WDI_03 WDI_02 WDI_05 WDI_06 GFD_02
bysort countryname: egen has_complete = max(complete_data)
tab countryname if has_complete == 1    // Countries with complete observations
tab countryname if has_complete == 0    // Countries with incomplete observations

* ------------------------------------------------------------------------------
* Control variables
* ------------------------------------------------------------------------------
global trends        "time_trend"
global quads         "quad_2 quad_3 quad_4"
global L_quads       "L1.quad_2 L1.quad_3 L1.quad_4"
global pops_0        "PIP PEP"
global pops_1        "PEP_PIP"
global pops_2        "PEP_PIP"
global pops_3        "PEP_PIP"
global econ_controls "WDI_02 WDI_05 WDI_06 GFD_02"


* ------------------------------------------------------------------------------
* Regression: Quadrands
* ------------------------------------------------------------------------------
xtreg $Y $trends $quads $econ_controls, fe vce(cluster country_id)
estimates store model_q


* Bootstrap
quietly boottest quad_2, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p2 = r(p): model_q

local boot_p2 = r(p)
local boot_ci_lower2 = r(CI_lower)
local boot_ci_upper2 = r(CI_upper)

quietly boottest quad_3, bootcluster(country_id) reps(9999) seed(12345) nograph
scalar boot_p3 = r(p)

local boot_p3 = r(p)
local boot_ci_lower3 = r(CI_lower)
local boot_ci_upper3 = r(CI_upper)

quietly boottest quad_4, bootcluster(country_id) reps(9999) seed(12345) nograph
scalar boot_p3 = r(p)

local boot_p4 = r(p)
local boot_ci_lower4 = r(CI_lower)
local boot_ci_upper4 = r(CI_upper)

display "ECONOMIC POPULISM (Quadrant 2):"
display "  Coefficient:     " %6.3f _b[quad_2]
display "  Cluster SE:      " %6.3f _se[quad_2]
display "  Cluster p-value: " %6.3f 2*ttail(e(N_g)-1, abs(_b[quad_2]/_se[quad_2]))
display "  Bootstrap p-val: " %6.3f `boot_p2'

display _newline
display "INSTITUTIONAL POPULISM (Quadrant 3):"
display "  Coefficient:     " %6.3f _b[quad_3]
display "  Cluster SE:      " %6.3f _se[quad_3]
display "  Cluster p-value: " %6.3f 2*ttail(e(N_g)-1, abs(_b[quad_3]/_se[quad_3]))
display "  Bootstrap p-val: " %6.3f `boot_p3'

display _newline
display "FULL POPULISM (Quadrant 4):"
display "  Coefficient:     " %6.3f _b[quad_4]
display "  Cluster SE:      " %6.3f _se[quad_4]
display "  Cluster p-value: " %6.3f 2*ttail(e(N_g)-1, abs(_b[quad_4]/_se[quad_4]))
display "  Bootstrap p-val: " %6.3f `boot_p4'


* Test: Is Economic Pop different from Institutional Pop?
boottest quad_2 = quad_3, bootcluster(country_id) reps(9999) seed(12345) nograph
display "H0: Economic Pop = Institutional Pop"
display "  Bootstrap p-value: " %6.3f r(p)

* Test: Is Full Pop = Economic Pop + Institutional Pop? (Additivity test)
boottest quad_4 = quad_2 + quad_3, bootcluster(country_id) reps(9999) seed(12345) nograph
display "H0: Full Pop = Economic Pop + Institutional Pop (Additivity)"
display "  Bootstrap p-value: " %6.3f r(p)

* Observations in regression
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_q.dta", replace
restore

log using "$output/model_q_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close


* ------------------------------------------------------------------------------
* Indices: t = 0 (contemporaneous)
* ------------------------------------------------------------------------------

* Regression: POP (t=0)
xtreg $Y $trends POP_z $econ_controls, fe vce(cluster country_id)
estimates store model_0_POP

boottest POP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)


* List countries per quadrant
forvalues q = 1/4 {
    
    * Count observations
    quietly count if quadrant == `q' & e(sample) == 1
    local n_q`q' = r(N)
    
    * Count countries
    quietly tab countryname if quadrant == `q' & e(sample) == 1
    local countries_q`q' = r(r)
    
    * Define quadrant labels
    if `q' == 1 local qlabel "CONTROL (Low PIP, Low PEP)"
    if `q' == 2 local qlabel "ECONOMIC POPULISM (Low PIP, High PEP)"
    if `q' == 3 local qlabel "INSTITUTIONAL POPULISM (High PIP, Low PEP)"
    if `q' == 4 local qlabel "FULL POPULISM (High PIP, High PEP)"
    
    * Display header
    display _newline(2)
    display as result "QUADRANT `q': `qlabel'"
    display as text "{hline 80}"
    display as text "Total observations: " as result `n_q`q'' as text " (of " as result e(N) as text " total)"
    display as text "Number of countries: " as result `countries_q`q''
    display _newline as text "Countries and observation counts:"
    
    * Detailed country list with observation counts
    preserve
    keep if quadrant == `q' & e(sample) == 1
    
    * Count by country
    contract countryname, freq(n_obs)
    gsort -n_obs
    
    * Calculate percentage
    gen pct = (n_obs / `n_q`q'') * 100
    
    * Display
    format pct %5.1f
    list countryname n_obs pct, noobs separator(0) abbrev(20)
    
    restore
}



quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_0_POP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_0_POP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* Regression: PEP (t=0)
xtreg $Y $trends PEP_z $econ_controls, fe vce(cluster country_id)
estimates store model_0_PEP

boottest PEP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_0_PEP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_0_PEP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* Regression: PIP (t=0)
xtreg $Y $trends PIP_z $econ_controls, fe vce(cluster country_id)
estimates store model_0_PIP

boottest PIP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_0_PIP.dta", replace
restore


* Countries in regression: .txt
log using "$output/model_0_PIP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* ------------------------------------------------------------------------------
* Indices: t = -1
* ------------------------------------------------------------------------------
* Regression: POP (t=-1)
sort country_id YEAR
xtreg $Y $trends L1.POP_z $econ_controls, fe vce(cluster country_id)
estimates store model_1_POP

boottest L1.POP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_1_POP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_1_POP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* Regression: PEP (t=-1)
xtreg $Y $trends L1.PEP_z $econ_controls, fe vce(cluster country_id)
estimates store model_1_PEP

boottest L1.PEP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_1_PEP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_1_PEP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* Regression: PIP (t=-1)
xtreg $Y $trends L1.PIP_z $econ_controls, fe vce(cluster country_id)
estimates store model_1_PIP

boottest L1.PIP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_1_PIP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_1_PIP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}
* ------------------------------------------------------------------------------
* Indices: t = -2
* ------------------------------------------------------------------------------
* Regression: POP (t=-2)
xtreg $Y $trends L2.POP_z $econ_controls, fe vce(cluster country_id)
estimates store model_2_POP

boottest L2.POP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_2_POP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_2_POP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* Regression: PEP (t=-2)
xtreg $Y $trends L2.PEP_z $econ_controls, fe vce(cluster country_id)
estimates store model_2_PEP

boottest L2.PEP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_2_PEP.dta", replace
restore

* Countries in regression: .txt
log using "$output/model_2_PEP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* Regression: PIP (t=-2)
xtreg $Y $trends L2.PIP_z $econ_controls, fe vce(cluster country_id)
estimates store model_2_PIP

boottest L2.PIP_z, bootcluster(country_id) reps(9999) seed(12345) nograph
estadd scalar boot_p = r(p)

quietly{
* Countries in regression: .dta
preserve
keep if e(sample) == 1
collapse (count) N = YEAR ///
         (min) year_min = YEAR ///
         (max) year_max = YEAR, ///
         by(countryname ISO3)
save "$data_proc/countries_model_2_PIP.dta", replace
restore

* Counitries in regression: .txt
log using "$output/model_2_PIP_countries.txt", text replace
display _newline "COUNTRIES IN REGRESSION"
display "================================="
display _newline
tab countryname if e(sample) == 1
display _newline "Summary Statistics:"
display "-------------------"
display "Total observations: " e(N)
display "Number of countries: " e(N_g)
display "Average obs per country: " e(N) / e(N_g)
log close
}

* ==============================================================================
* 5. MAIN TABLES
* ==============================================================================

global note_1 "Dependent variable: Private gross fixed capital formation (\% GDP)"
global note_2 "All models include country FE, time trend, and economic controls"
global note_3 "Standard errors clustered at country level in parentheses"

* ------------------------------------------------------------------------------
* Lag = 0 (t = 0)
* ------------------------------------------------------------------------------

global tables  "model_0_POP model_0_PEP model_0_PIP"
estout $tables, cells(b(star fmt(%9.3f)) se (par) boot_p(par)) ///
    title("Contemporaneous Effects of Populism on Investment")     ///
	mlabels("POP (t=0)" "PEP (t=0)" "PIP (t=0)")                   ///
	order(time_trend POP_z PEP_z PIP_z)                            ///
	stats(N N_g df_m r2_w r2_o r2_b aic bic,                       ///
		  labels("Sample size" "Clusters" "Degrees of freedom"     ///
		         "R2 (within)" "R2 (overall)" "R2 (between)" "AIC" "BIC")) ///
	legend label drop(_cons) ///
	postfoot("$note_1" ///
             "$note_2" ///
			 "$note_3")
            
	
* ------------------------------------------------------------------------------
* Lag = 1 (t = -1)
* ------------------------------------------------------------------------------
global tables  "model_1_POP model_1_PEP model_1_PIP"
estout $tables, cells(b(star fmt(%9.3f)) se (par)) ///
    title("One-Period Lag Effects of Populism on Investment") ///
	mlabels("POP (t=-1)" "PEP (t=-1)" "PIP (t=-1)")                ///
	order(time_trend L.POP_z L.PEP_z L.PIP_z)                      ///
	stats(N N_g df_m r2_w r2_o r2_b aic bic,                       ///
		  labels("Sample size" "Clusters" "Degrees of freedom"     ///
		         "R2 (within)" "R2 (overall)" "R2 (between)" "AIC" "BIC")) ///
	legend label drop(_cons) ///
	postfoot("$note_1" ///
             "$note_2" ///
			 "$note_3")
	
	
* ------------------------------------------------------------------------------
* Lag = 2 (t = -2)
* ------------------------------------------------------------------------------
global tables  "model_2_POP model_2_PEP model_2_PIP"
estout $tables, cells(b(star fmt(%9.3f)) se (par)) ///
    title("Two-Period Lag Effects of Populism on Investment") ///
	mlabels("POP (t=-2)" "PEP (t=-2)" "PIP (t=-2)")                ///
	order(time_trend L2.POP_z L2.PEP_z L2.PIP_z)                   ///
	stats(N N_g df_m r2_w r2_o r2_b aic bic,                       ///
		  labels("Sample size" "Clusters" "Degrees of freedom"     ///
		         "R2 (within)" "R2 (overall)" "R2 (between)" "AIC" "BIC")) ///
	legend label drop(_cons) ///
	postfoot("$note_1" ///
             "$note_2" ///
			 "$note_3")
	
	
* ------------------------------------------------------------------------------
* POP
* ------------------------------------------------------------------------------
global tables  "model_0_POP model_1_POP model_2_POP"
estout $tables, cells(b(star fmt(%9.3f)) se (par)) ///
    title("Overall Populism Effect on Investment") ///
	mlabels("POP (t=0)" "POP (t=-1)" "POP (t=-2)")                 ///
	order(time_trend POP_z L.POP_z L2.POP_z)                       ///
	stats(N N_g df_m r2_w r2_o r2_b aic bic,                       ///
		  labels("Sample size" "Clusters" "Degrees of freedom"     ///
		         "R2 (within)" "R2 (overall)" "R2 (between)" "AIC" "BIC")) ///
	legend label drop(_cons) ///
	postfoot("$note_1" ///
             "$note_2" ///
			 "$note_3")
	
	
* ------------------------------------------------------------------------------
* PEP
* ------------------------------------------------------------------------------
global tables  "model_0_PEP model_1_PEP model_2_PEP"
estout $tables, cells(b(star fmt(%9.3f)) se (par)) ///
    title("Economic Populism Effect on Investment") ///
	mlabels("PEP (t=0)" "PEP (t=-1)" "PEP (t=-2)")                 ///
	order(time_trend PEP_z L.PEP_z L2.PEP_z)                       ///
	stats(N N_g df_m r2_w r2_o r2_b aic bic,                       ///
		  labels("Sample size" "Clusters" "Degrees of freedom"     ///
		         "R2 (within)" "R2 (overall)" "R2 (between)" "AIC" "BIC")) ///
	legend label drop(_cons) ///
	postfoot("$note_1" ///
             "$note_2" ///
			 "$note_3")
	
* ------------------------------------------------------------------------------
* PIP
* ------------------------------------------------------------------------------
global tables  "model_0_PIP model_1_PIP model_2_PIP"
estout $tables, cells(b(star fmt(%9.3f)) se (par)) ///
    title("Institutional Populism Effect on Investment") ///
	mlabels("PIP (t=0)" "PIP (t=-1)" "PIP (t=-2)")                 ///
	order(time_trend PIP_z L.PIP_z L2.PIP_z)                       ///
	stats(N N_g df_m r2_w r2_o r2_b aic bic,                       ///
		  labels("Sample size" "Clusters" "Degrees of freedom"     ///
		         "R2 (within)" "R2 (overall)" "R2 (between)" "AIC" "BIC")) ///
	legend label drop(_cons) ///
	postfoot("$note_1" ///
             "$note_2" ///
			 "$note_3")