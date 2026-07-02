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
// 1. Naive TWFE - Country Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-funke-ple-country.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

// Equal Weights
reg log_ch pop i.iso i.year, clust(iso)
estimates store m1

// Weighted by Firm Obs
reg log_ch pop i.iso i.year [aweight=firms], clust(iso)
estimates store m1w

//------------------------------------------------------------------------------
// 2. Naive TWFE - Country Level, V-Party Data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-vparty-country.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

// Equal Weights
reg log_ch v2xpa_popul i.iso i.year, clust(iso)
estimates store m2

// Weighted by Firm Obs
reg log_ch v2xpa_popul i.iso i.year [aweight=firms], clust(iso)
estimates store m2w


//------------------------------------------------------------------------------
// 3. Naive TWFE - Firm Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-funke-ple-firm.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

// Country + Year FE
reg log_ch pop i.iso i.year, clust(iso)
estimates store m3a

// Firm + Year FE
reghdfe log_ch pop i.year, absorb(i.gvkey) clust(iso)
estimates store m3b

//------------------------------------------------------------------------------
// 4. Naive TWFE - Firm Level, V-Party Data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-vparty-firm.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

// Country + Year FE
reg log_ch v2xpa_popul i.iso i.year, clust(iso)
estimates store m4a

// Firm + Year FE
reghdfe log_ch v2xpa_popul i.year, absorb(i.gvkey) clust(iso)
estimates store m4b

//------------------------------------------------------------------------------
// 5. Clean TWFE - Country Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-twfe-country.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

// Equal Weights
reg log_ch pop i.iso i.year, clust(iso)
estimates store m5a

// Weighted by Firm Obs
reg log_ch pop i.iso i.year [aweight=firms], clust(iso)
estimates store m5b

//------------------------------------------------------------------------------
// 5b. Populism coefficient across naive/clean TWFE specs (Sections 1-5)
//------------------------------------------------------------------------------
// Country-level specs (left) vs firm-level specs (right). Weighting applies at
// the country level only (each country-year weighted by its firm count); firm-
// level specs are unweighted (each firm-year = one obs).
// NOTE: PLE models use the binary populist-leader dummy `pop`; V-Party models
// use the continuous index `v2xpa_popul`. The two are on different scales, so
// magnitudes are NOT directly comparable across the dummy and index rows.

// LEFT: country level (Country+Year FE), unweighted vs firm-weighted
coefplot ///
	(m1,  keep(pop)         rename(pop = "Naive PLE - unweighted")) ///
	(m1w, keep(pop)         rename(pop = "Naive PLE - firm-weighted")) ///
	(m2,  keep(v2xpa_popul) rename(v2xpa_popul = "Naive V-Party - unweighted")) ///
	(m2w, keep(v2xpa_popul) rename(v2xpa_popul = "Naive V-Party - firm-weighted")) ///
	(m5a, keep(pop)         rename(pop = "Clean PLE - unweighted")) ///
	(m5b, keep(pop)         rename(pop = "Clean PLE - firm-weighted")), ///
	horizontal ///
	xline(0, lcolor(black)) ///
	levels(90) ///
	mcolor(navy) ciopts(recast(rcap) color(navy)) ///
	xtitle("Populism coef. on log cash (90% CI)", size(small)) ///
	legend(off) ///
	name(country_panel, replace) ///
	subtitle("Country level", justification(center) size(small))

// RIGHT: firm level, unweighted
coefplot ///
	(m3a, keep(pop)         rename(pop = "PLE - Country+Year FE")) ///
	(m3b, keep(pop)         rename(pop = "PLE - Firm+Year FE")) ///
	(m4a, keep(v2xpa_popul) rename(v2xpa_popul = "V-Party - Country+Year FE")) ///
	(m4b, keep(v2xpa_popul) rename(v2xpa_popul = "V-Party - Firm+Year FE")), ///
	horizontal ///
	xline(0, lcolor(black)) ///
	levels(90) ///
	mcolor(cranberry) ciopts(recast(rcap) color(cranberry)) ///
	xtitle("Populism coef. on log cash (90% CI)", size(small)) ///
	legend(off) ///
	name(firm_panel, replace) ///
	subtitle("Firm level", justification(center) size(small))

// Combine: country on the left, firm on the right
graph combine country_panel firm_panel, ///
	xcommon rows(2) ///
	name(pop_twfe_compare, replace)

//------------------------------------------------------------------------------
// 6. TWFE DID Event Study - Country Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-twfe-country.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

/// Create indicators for relative_year between -4 and +4 
gen lead4 =(relative_year == -4 & treat==1)
gen lead3 =(relative_year == -3 & treat==1)
gen lead2 =(relative_year == -2 & treat==1)

gen lag0 =(relative_year == 0 & treat==1)
gen lag1 =(relative_year == 1 & treat==1) 
gen lag2 =(relative_year == 2 & treat==1)
gen lag3 =(relative_year == 3 & treat==1)

// Equal Weights 
reghdfe log_ch treat lead* lag0-lag3, absorb(i.iso i.year) clust(iso)

estimates store twfe_event

// Plot: pre-treatment blue (rel_year 0–3 = t −5 to −2),
//       post-treatment cranberry (rel_year 5–10 = t 0 to +5).
// Omitted reference t=−1 added as solid circle at x=5, y=0.
coefplot (twfe_event, ///
		keep(lead4 lead3 lead2) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (twfe_event, ///
	  keep(lag0 lag1 lag2 lag3) ///
		 mcolor(cranberry) ciopts(recast(rcap) color(cranberry))), ///
	addplot(scatteri 0 4, msymbol(O) mcolor(navy) msize(medsmall)) ///
	relocate( ///
	lag0  = 5  ///
	lag1  = 6 ///
	lag2  = 7 ///
	lag3 = 8) ///
	vertical ///
	yline(0, lcolor(black)) ///
	xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	levels(90) ///
	legend(off) ///
	name(twfe_event, replace) ///
	subtitle("TWFE DID", justification(center) size(small))


//------------------------------------------------------------------------------
// 7. Stacked DID Event Study - Country Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-country.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

gen rel_year = relative_year + 4

// Equal Weights 
reghdfe log_ch treat##b3.rel_year, absorb(i.id i.cohort#i.year) clust(iso)

estimates store stacked

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (stacked, ///
		keep(1.treat#0.rel_year 1.treat#1.rel_year ///
		1.treat#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (stacked, ///
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
	name(stacked, replace) ///
	subtitle("Stacked DID", justification(center) size(small))
	
//------------------------------------------------------------------------------
// 8. Stacked DID Event Study - Firm Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)

gen rel_year = relative_year + 4

// Equal Weights 
reghdfe log_ch treat##b3.rel_year, ///
	absorb(i.firm_id i.cohort#i.year) ///
	vce(cluster iso)

estimates store stacked_firm

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (stacked_firm, ///
		keep(1.treat#0.rel_year 1.treat#1.rel_year ///
		1.treat#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (stacked_firm, ///
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
	name(stacked_firm, replace) ///
	subtitle("Stacked DID - Firm Level", justification(center) size(small))

//------------------------------------------------------------------------------
// 9. EB Stacked DID Event Study - Firm Level, Funke et al. PLE data
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

drop if region == "Northern Europe" | region == "Western Europe" | region == "Northern Africa" | region=="Australia and New Zealand"

gen log_ch = log(ch)
gen rel_year = relative_year + 4

tsset firm_id relative_year
sort firm_id relative_year

cap drop  log_ch_l* _*

bysort firm_id (relative_year): gen log_ch_l1 = L1.log_ch
bysort firm_id (relative_year): gen log_ch_l2 = L2.log_ch
bysort firm_id (relative_year): gen log_ch_l3 = L3.log_ch
bysort firm_id (relative_year): gen log_ch_l4 = L4.log_ch

levelsof cohort, local(cohorts)

// Create variable to store weights
gen _aw = .
gen _ebal = .

// Get total weights
count if treat 
scalar total_treat = r(N)

foreach y of local cohorts {
	 
	cap drop _webal
	
	// Calculate Entropy Balance weights for each cohort 
	qui ebalance treat log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 /// 
		if relative_year == 0 & cohort==`y'
	
	// Store in ebal variable (this one is just for comparison purposes)
	replace _ebal = _webal if cohort == `y'
		 
	// Store in aw variable (this one will store the doubly-weighted)
	replace _aw = _webal if cohort == `y'
    
	// Calculate sample weights 
	count if treat == 1 & cohort == `y'
    scalar share_`y' = r(N) / total_treat
    display share_`y'
	
	// Divide the entropy weights by the sample weights
	replace _aw = _aw * share_`y' if cohort==`y'
}

// Extend the weights by firm
egen aw = mean(_aw), by(firm_id)
egen ebal = mean(_ebal), by(firm_id)

/* Match on trends
cap drop ebal weights
ebalance treat log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 ///
	if relative_year==0, gen(ebal)

// Extend weights in t-1 to all observations
egen weights = mean(ebal), by(firm_id)
*/

reghdfe log_ch treat##b3.rel_year [aweight=aw], ///
	absorb(i.firm_id i.cohort#i.year) ///
	vce(cluster iso)

estimates store eb_stacked_firm

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (eb_stacked_firm, ///
		keep(1.treat#0.rel_year 1.treat#1.rel_year ///
		1.treat#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (eb_stacked_firm, ///
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
	name(eb_stacked_firm, replace) ///
	subtitle("EB Stacked DID - Firm Level", justification(center) size(small))
	
graph combine twfe_event stacked stacked_firm eb_stacked_firm, ///
	rows(2) ycommon xcommon








