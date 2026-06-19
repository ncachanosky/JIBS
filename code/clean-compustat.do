/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Clean COMPUSTAT
==============================================================================*/

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------

clear all
set more off

// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:/Users/ncachanosky/OneDrive/Research/Working Papers/paper-JIBS"
}


//------------------------------------------------------------------------------
// Load raw COMPUSTAT data and clean 
//------------------------------------------------------------------------------

use "$path/JIBS/data/raw/compustat.dta", clear

// No variance | count if consol!="C" | county!="" -> 0
drop consol county 

// Fix data formats 
cap destring gvkey, replace
cap destring sic, replace

// Main Location variable
encode loc, gen(iso)

local after "loc"
foreach v in fic costat datafmt indfmt isin {
	rename `v' `v'_tmp
	encode `v'_tmp, gen(`v')
	drop `v'_tmp
	
	if "`v'" == "loc" {
		order `v', first
	}
	else {
		order `v', after(`after')
		local after "`v'" // update the local 
	}	
}

// If incorporation is in a different country than headquarters
gen foreign = (iso != fic)

// Clean and gen vars 
cap gen active = (costat=="A")
drop costat

// 
tab curcd if loc=="USA"

// Dates are always last day of a given month/year, so we can ignore day
gen month = month(datadate)
gen year = year(datadate)
rename datadate date
order month year, after(date)

// Keep only obs with AT LEAST the outcome var
keep if ch!=.

// This will serve as count / number of obs by country
gen firms = 1

// Export Firm-level data
//------------------------------------------------------------------------------
save "$path/JIBS/data/compustat-firm-clean.dta", replace

//------------------------------------------------------------------------------
// Collapse and save country-level data
//------------------------------------------------------------------------------

collapse (mean) aco ch che cheb chech chee chefs chenfd cmp dcsfd dd1 dvc dvp /// 
	dvpdp dvt emp fca icapt lco opprft pi revt foreign (sum) firms, by(iso year)
	
save "$path/JIBS/data/compustat-country-clean.dta", replace
	
	