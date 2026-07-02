/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Clean Funke et al. "Populist Leaders and the Economy" AER data
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
// Load region ids 
//------------------------------------------------------------------------------
import excel "$path/JIBS/data/raw/UNSD-WB.xlsx", firstrow clear

rename ISOalpha3Code iso
rename WBIncomeGroup wb_region

drop *Code Global* Country*

rename RegionName continent
rename SubregionName region
rename IntermediateRegionName subregion 

order iso continent region subregion wb_region

//------------------------------------------------------------------------------
// Merge opulism data and create treatment indicators
//------------------------------------------------------------------------------

merge 1:m iso using "$path/JIBS/data/raw/PLE_panel2.dta", ///
	keep(match using) nogen

// Fix Taiwan
replace continent = "Asia" if country=="Taiwan"
replace region = "Eastern Asia" if country=="Taiwan"

sort iso year

// COMPUSTAT coverage
keep if year>=1987

rename iso _iso
encode _iso, gen(iso)
drop _iso

save "$path/JIBS/data/funke-ple-clean.dta", replace
