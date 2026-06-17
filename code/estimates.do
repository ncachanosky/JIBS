/*==============================================================================
Project: JIBS Paper
File: data_builder.do
Authors: Joao P. Bastos, Nicolás Cachanosky, John D. Gibson
Email: ncachanosky@utep.edu
Institution: The University of Texas at El Paso
Created: 26-Nov-2025
Last Modified: 26-Nov-2025

Description:
    Clean and create dataset

Usage:
    do data_builder.do
==============================================================================*/

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------

// Required Packages
*ssc install reghdfe, replace

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
// Estimates
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked.dta", clear

gen log_ch = log(ch)

// factor vars don't accept negative values
// With +4: rel_year 0–7 maps to relative_year −4 to +3; base b3 = relative_year −1
gen rel_year = relative_year + 4

// Define the mapping from the new values back to the old ones
label define rel_year_lbl 0 "-4" 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3"

// Apply these labels to our new categorical variable
label values relative_year rel_year_lbl

/* levelsof cohort, local(cohorts)

cap gen weights = . 

foreach c of local cohorts {
	
	qui count if treat==1 & cohort==`c'
	local NT = r(N)
	
	qui count if treat==0 & cohort==`c'
	local NC = r(N)

	// Assure obs in both treat AND control
	if `NT' > 0 & `NC' > 0 {
		
		qui cap ebalance treat ch if relative_year==-1 & cohort==`c', gen(_w`c')
		
		cap egen _weights_`c' = mean(_w`c'), by(cohort)
		
		cap replace weights = _weights_`c' if cohort==`c'
		
	}
	
	else continue 
	
}

drop _*
*/

foreach v in id gvkey {
reghdfe log_ch i.treat##b3.rel_year, ///
	absorb(i.id) /// 
	vce(cluster `v') 
	
	if "`v'" == "id"{
		local note "country level"
	}
	else {
		local note "firm level"
	}

estimates store ch_`v'

coefplot (ch_`v', ///
			keep(1.treat#0.rel_year 1.treat#1.rel_year ///
			1.treat#2.rel_year) ///
	        mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
		  (ch_`v', ///
		  keep(1.treat#4.rel_year 1.treat#5.rel_year ///
			   1.treat#6.rel_year 1.treat#7.rel_year) ///
	         mcolor(cranberry) ciopts(recast(rcap) color(cranberry))), ///	 
		addplot(scatteri 0 4, msymbol(O) mcolor(navy) msize(medsmall)) ///
		relocate( ///
		1.treat#4.rel_year = 5 ///
		1.treat#5.rel_year = 6 ///
		1.treat#6.rel_year = 7 ///
		1.treat#7.rel_year = 8) ///
	    vertical ///
	    yline(0, lcolor(black)) ///
	    xline(4.5, lcolor(gs8) lpattern(dash)) ///
	    ytitle("Log Cash Holdings", size(small)) ///
	    xtitle("Periods Since Populist Leader", size(small)) ///
	    xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	    levels(90) ///
	    legend(off) ///
	    name(ch_`v', replace) ///
	    subtitle("Using unbalanced panel of firms, clustered at `note'", ///
		justification(center) size(small)) 
}

graph combine ch_id ch_gvkey, ycommon
		

		
		
//------------------------------------------------------------------------------
// Estimates
//------------------------------------------------------------------------------

use "$path/JIBS/data/complete-stacked.dta", clear

gen log_ch = log(ch)

// factor vars don't accept negative values
// With +4: rel_year 0–7 maps to relative_year −4 to +3; base b3 = relative_year −1
gen rel_year = relative_year + 4

// Define the mapping from the new values back to the old ones
label define rel_year_lbl 0 "-4" 1 "-3" 2 "-2" 3 "-1" 4 "0" 5 "1" 6 "2" 7 "3"

// Apply these labels to our new categorical variable
label values relative_year rel_year_lbl


reghdfe log_ch i.treat##b3.rel_year, ///
	absorb(i.iso) ///
	vce(cluster gvkey) 

estimates store ch_comp

coefplot (ch_comp, ///
			keep(1.treat#0.rel_year 1.treat#1.rel_year ///
			1.treat#2.rel_year) ///
	        mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
		  (ch_comp, ///
		  keep(1.treat#4.rel_year 1.treat#5.rel_year ///
			   1.treat#6.rel_year 1.treat#7.rel_year) ///
	         mcolor(cranberry) ciopts(recast(rcap) color(cranberry))), ///	 
		addplot(scatteri 0 4, msymbol(O) mcolor(navy) msize(medsmall)) ///
		relocate( ///
		1.treat#4.rel_year = 5 ///
		1.treat#5.rel_year = 6 ///
		1.treat#6.rel_year = 7 ///
		1.treat#7.rel_year = 8) ///
	    vertical ///
	    yline(0, lcolor(black)) ///
	    xline(4.5, lcolor(gs8) lpattern(dash)) ///
	    ytitle("Cash Holdings", size(small)) ///
	    xtitle("Periods Since Populist Leader", size(small)) ///
	    xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	    levels(90) ///
	    legend(off) ///
	    name(ch_comp, replace) ///
	    subtitle("Using complete panel of firms", justification(center) size(small)) 
		
		
graph combine ch_unb ch_comp

