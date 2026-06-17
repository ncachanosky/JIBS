/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Build V-Party Datasets
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
// 1. Load clean COMPUSTAT firm-level data and merge
//------------------------------------------------------------------------------

use "$path/JIBS/data/compustat-firm-clean.dta", clear 

// Merge 
merge m:1 iso year using "$path/JIBS/data/v-party-clean.dta"
keep if _merge==3
drop _merge

save "$path/JIBS/data/master-vparty-firm.dta", replace

//------------------------------------------------------------------------------
// Load clean COMPUSTAT firm-level data and merge
//------------------------------------------------------------------------------

use "$path/JIBS/data/compustat-country-clean.dta", clear 

// Merge 
merge 1:1 iso year using "$path/JIBS/data/v-party-clean.dta"
keep if _merge==3
drop _merge

save "$path/JIBS/data/master-vparty-country.dta", replace
