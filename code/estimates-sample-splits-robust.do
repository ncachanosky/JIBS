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
// 1. Stacked DID Event Study - Baseline
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

gen log_ch = log(ch)

gen rel_year = relative_year + 4

// Equal Weights 
reghdfe log_ch treat##b3.rel_year, ///
	absorb(i.firm_id i.cohort#i.year) ///
	vce(robust)
	
	distinct firm_id if treat==1
	local nt = r(ndistinct)

	distinct firm_id if treat==0
	local nc = r(ndistinct)

estimates store e1

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (e1, ///
		keep(1.treat#0.rel_year 1.treat#1.rel_year ///
		1.treat#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (e1, ///
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
	name(e1, replace) ///
	subtitle("Baseline", justification(center) size(small)) ///
	nodraw
	
	
//------------------------------------------------------------------------------
// 2. Stacked DID Event Study - Excluding regions with no treated cases
//------------------------------------------------------------------------------
	
use "$path/JIBS/data/master-stacked-firm.dta", clear

drop if region == "Northern Europe" ///
	| region == "Western Europe" ///
	| region == "Northern Africa" ///
	| region=="Australia and New Zealand"

gen log_ch = log(ch)

gen rel_year = relative_year + 4

	distinct firm_id if treat==1
	local nt = r(ndistinct)

	distinct firm_id if treat==0
	local nc = r(ndistinct)

// Equal Weights 
reghdfe log_ch treat##b3.rel_year, ///
	absorb(i.firm_id i.cohort#i.year) ///
	vce(robust)

estimates store e2

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (e2, ///
		keep(1.treat#0.rel_year 1.treat#1.rel_year ///
		1.treat#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (e2, ///
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
	name(e2, replace) ///
	subtitle("Excluding regions with no treated", ///
		justification(center) size(small)) ///
	nodraw
	
//------------------------------------------------------------------------------
// 3. Stacked DID Event Study - Left 
//------------------------------------------------------------------------------
	
use "$path/JIBS/data/master-stacked-firm.dta", clear

drop if region == "Northern Europe" ///
	| region == "Western Europe" ///
	| region == "Northern Africa" ///
	| region=="Australia and New Zealand"
	
egen tag_left = total(lpop) if treat==1, by(firm_id)
egen tag_right = total(rpop) if treat==1, by(firm_id)

replace lpop = 1 if tag_left > 0 & treat==1 & tag_right==0
replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0

tab lpop relative_year if treat==0 | lpop==1
tab rpop relative_year if treat==0 | rpop==1

gen log_ch = log(ch)

gen rel_year = relative_year + 4

distinct firm_id if treat==0
local nc = r(ndistinct)

distinct firm_id if lpop==1
local nt = r(ndistinct)

// Equal Weights 
reghdfe log_ch lpop##b3.rel_year if treat==0 | lpop==1, ///
	absorb(i.firm_id i.cohort#i.year) ///
	vce(robust)

estimates store e3

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (e3, ///
		keep(1.lpop#0.rel_year 1.lpop#1.rel_year ///
		1.lpop#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (e3, ///
	  keep(1.lpop#4.rel_year 1.lpop#5.rel_year ///
		   1.lpop#6.rel_year 1.lpop#7.rel_year) ///
		 mcolor(cranberry) ciopts(recast(rcap) color(cranberry))), ///	 
	addplot(scatteri 0 4, msymbol(O) mcolor(navy) msize(medsmall)) ///
	relocate( ///
	1.lpop#4.rel_year = 5 ///
	1.lpop#5.rel_year = 6 ///
	1.lpop#6.rel_year = 7 ///
	1.lpop#7.rel_year = 8) ///
	vertical ///
	yline(0, lcolor(black)) ///
	xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Left-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	levels(90) ///
	legend(off) ///
	name(e3, replace) ///
	subtitle("Left Populists: Excluding regions with no treated", ///
		justification(center) size(small)) ///
		note("N(T) `nt' | N(C): `nc'" ///
		"Robust standard errors", ///
			justification(center) size(vsmall)) ///
	nodraw
	
//------------------------------------------------------------------------------
// 4. Stacked DID Event Study - Right
//------------------------------------------------------------------------------
	
distinct firm_id if treat==0
	local nc = r(ndistinct)

distinct firm_id if rpop==1
	local nt = r(ndistinct)
	
// Equal Weights 
reghdfe log_ch rpop##b3.rel_year if treat==0 | rpop==1, ///
	absorb(i.firm_id i.cohort#i.year) ///
	vce(robust)

estimates store e4

// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
// Omitted reference t=−1 added at at x=4, y=0.
coefplot (e4, ///
		keep(1.rpop#0.rel_year 1.rpop#1.rel_year ///
		1.rpop#2.rel_year) ///
		mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
	  (e4, ///
	  keep(1.rpop#4.rel_year 1.rpop#5.rel_year ///
		   1.rpop#6.rel_year 1.rpop#7.rel_year) ///
		 mcolor(cranberry) ciopts(recast(rcap) color(cranberry))), ///	 
	addplot(scatteri 0 4, msymbol(O) mcolor(navy) msize(medsmall)) ///
	relocate( ///
	1.rpop#4.rel_year = 5 ///
	1.rpop#5.rel_year = 6 ///
	1.rpop#6.rel_year = 7 ///
	1.rpop#7.rel_year = 8) ///
	vertical ///
	yline(0, lcolor(black)) ///
	xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Right-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	levels(90) ///
	legend(off) ///
	name(e4, replace) ///
	subtitle("Right Populists: Excluding regions with no treated", ///
		justification(center) size(small)) ///
	note("N(T) `nt' | N(C): `nc'" ///
		"Robust standard errors", ///
			justification(center) size(vsmall)) ///
		nodraw
	
graph combine e1 e2 e3 e4, xcommon rows(2)

graph export "$path/JIBS/output/plots/robust-baseline-left-right.png", replace


//------------------------------------------------------------------------------
// By Geographical Region:
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

keep if inlist(region, "Eastern Asia", "Eastern Europe", "South-eastern Asia", "Southern Europe") 

replace region = "Southeastern Asia" if region=="South-eastern Asia"

gen log_ch = log(ch)
gen rel_year = relative_year + 4

levelsof region, local(regions)

foreach region of local regions {
	
	preserve 
	
	keep if region=="`region'"
	
	cap drop  log_ch_l* _ebal ebal
	
	tsset firm_id relative_year
	sort firm_id relative_year

	bysort firm_id (relative_year): gen log_ch_l1 = L1.log_ch
	bysort firm_id (relative_year): gen log_ch_l2 = L2.log_ch
	bysort firm_id (relative_year): gen log_ch_l3 = L3.log_ch
	bysort firm_id (relative_year): gen log_ch_l4 = L4.log_ch

		
	// Calculate Entropy Balance weights 
	ebalance treat log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 /// 
			if relative_year == 0, gen(_ebal)
			 
	egen ebal = mean(_ebal), by(firm_id)
	
	sum ebal

	local r = subinstr("`region'", " ", "", .)
	
	distinct firm_id if treat==1
	local nt = r(ndistinct)

	distinct firm_id if treat==0
	local nc = r(ndistinct)

	// Equal Weights 
	qui reghdfe log_ch treat##b3.rel_year [aweight=ebal], ///
		absorb(i.firm_id i.cohort#i.year) ///
		vce(robust)

	estimates store e`r'

	// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
	//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
	// Omitted reference t=−1 added at at x=4, y=0.
	coefplot (e`r', ///
			keep(1.treat#0.rel_year 1.treat#1.rel_year ///
			1.treat#2.rel_year) ///
			mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
		  (e`r', ///
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
		name(e`r', replace) ///
		subtitle("`region' Sample", ///
			justification(center) size(small)) ///
		note("N(T) `nt' | N(C): `nc'" ///
		"Robust standard errors", ///
			justification(center) size(vsmall)) ///
		nodraw
		
		restore
}

graph combine eEasternAsia eEasternEurope eSoutheasternAsia eSouthernEurope, ///
	xcommon rows(2)

graph export "$path/JIBS/output/plots/robust-by-region.png", replace

//------------------------------------------------------------------------------
// By World Bank Region:
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

gen log_ch = log(ch)
gen rel_year = relative_year + 4

levelsof wb_region, local(wb_regions)

foreach region of local wb_regions {
	
	preserve 
	
	keep if wb_region=="`region'"
	
	cap drop  log_ch_l* _ebal ebal
	
	tsset firm_id relative_year
	sort firm_id relative_year

	bysort firm_id (relative_year): gen log_ch_l1 = L1.log_ch
	bysort firm_id (relative_year): gen log_ch_l2 = L2.log_ch
	bysort firm_id (relative_year): gen log_ch_l3 = L3.log_ch
	bysort firm_id (relative_year): gen log_ch_l4 = L4.log_ch

		
	// Calculate Entropy Balance weights 
	ebalance treat log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 /// 
			if relative_year == 0, gen(_ebal)
			 
	egen ebal = mean(_ebal), by(firm_id)

	local r = subinstr("`region'", " ", "", .)
	
	distinct firm_id if treat==1
	local nt = r(ndistinct)

	distinct firm_id if treat==0
	local nc = r(ndistinct)

	// Equal Weights 
	qui reghdfe log_ch treat##b3.rel_year [aweight=ebal], ///
		absorb(i.firm_id i.cohort#i.year) ///
		vce(robust)

	estimates store e`r'

	// Plot: pre-treatment blue (rel_year 0–2 = t −4 to −2),
	//       post-treatment cranberry (rel_year 4–7 = t 0 to +3).
	// Omitted reference t=−1 added at at x=4, y=0.
	coefplot (e`r', ///
			keep(1.treat#0.rel_year 1.treat#1.rel_year ///
			1.treat#2.rel_year) ///
			mcolor(midblue) ciopts(recast(rcap) color(midblue))) ///
		  (e`r', ///
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
		name(e`r', replace) ///
		subtitle("World Bank `region' Sample", ///
			justification(center) size(small)) ///
		note("N(T) `nt' | N(C): `nc'" ///
		"Robust standard errors", ///
			justification(center) size(vsmall)) ///
		nodraw
		
		restore
}

graph combine eHighincome eLowermiddleincome eUppermiddleincome, ///
	xcommon rows(2)

graph export "$path/JIBS/output/plots/robust-by-wb-region.png", replace







