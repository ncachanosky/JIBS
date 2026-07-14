/*==============================================================================
Project: JIBS Paper
File: data_builder.do
Authors: J. P. Bastos (UATX), Nicolás Cachanosky (UTEP), John D. Gibson (UTEP)
Created: May 2026
Last Modified: -

Description:
    Estimate preliminary regressions
==============================================================================*/

clear all
set more off

// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:/Users/ncachanosky/OneDrive/Research/Working Papers/paper-JIBS"
}

// Load cleaned ata
use "$path/JIBS/data/jibs-clean.dta", clear

foreach v in ch che chee {
	cap gen log_`v' = log(`v')
}

encode leader_ideology, gen(ideology)
replace leader_ideology=. if leader_ideology=="no information"

//==============================================================================
// OLS Estimates
//==============================================================================
 
// All estimates here: More Populism, Less Cash
// Except for "(chee) Cash and Cash Equivalents at End of Year"
 
 foreach v in ch che chee {
	
	// Industry, Month, Year, and Country FE
	reghdfe log_`v' v2xpa_popul, absorb(i.sic i.month i.year i.fic)
	
	// Firm, Industry, Month, Year, and Country FE
	reghdfe log_`v' v2xpa_popul, absorb(i.gvkey i.sic i.month i.year i.fic)

}

// Industry, Month, Year, and Country FE
reghdfe log_ch c.v2xpa_popul##ideology, absorb(i.sic i.month i.year i.fic)
	
// Firm, Industry, Month, Year, and Country FE
reghdfe log_ch c.v2xpa_popul##ideology, absorb(i.gvkey i.sic i.month i.year i.fic)

//==============================================================================
// Binary treatment 
//==============================================================================

cap egen clust = group(sic year iso)

global exact = "sic month year region"
global covs = "l1_* l2_* l3_*"
global outcomes = "ch che chee"

foreach v in treat_leader treat_leader_top25 treat_leader_top10 {
		
	kmatch md `v' $covs ///
    ($outcomes), ///
    att ematch($exact) nn(1) vce(cluster clust)

	// Balancing diagnostics
	kmatch summarize $covs $outcomes, att sd

}
