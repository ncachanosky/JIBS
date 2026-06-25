/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Build stacked dataset 
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
// 1. Create Country-Level Clean Window Panel
//------------------------------------------------------------------------------

use "$path/JIBS/data/clean-window-cases.dta", clear

// Merge firm observation counts:
merge m:1 iso year using "$path/JIBS/data/compustat-country-clean.dta", ///
    keep(match) nogen

save "$path/JIBS/data/master-stacked-country.dta", replace

//------------------------------------------------------------------------------
// 1. Create Country-Level Stacked Panel
//------------------------------------------------------------------------------

duplicates drop iso year, force

save "$path/JIBS/data/master-twfe-country.dta", replace



