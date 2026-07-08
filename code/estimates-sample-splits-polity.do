/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Stacked DiD event study, few-clusters inference via WILD CLUSTER BOOTSTRAP.

  Inference uses -boottest- (Roodman), Webb weights, null imposed. boottest does
  NOT accept factor-variable interactions (e.g. 1.treat#4.rel_year), so the
  event-time terms enter as EXPLICIT 0/1 dummies d0..d7. Firm fixed effects are
  ABSORBED with -areg- (too many firm_ids to enter as i.firm_id); cohort-year
  effects enter as explicit i.cy dummies. Entropy-balance weights (ebal, on
  pre-trend lags of log_ch) are applied in every specification. The point
  estimates are identical to the factor spec  areg log_ch treat##b3.rel_year
  i.cy, absorb(firm_id)  because the treat main effect is absorbed by firm_id and
  the rel_year main effects are absorbed by cy. WCB 90% CIs come from inverting
  the bootstrap test (r(CI)); plots are drawn from a postfile of those CIs.

  See ideology-efw/docs/eb-did-few-clusters-guide.md and code/hiel-wcb.do.
==============================================================================*/

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------

clear all
set more off
set seed 20260705

global reps 9999   // wild cluster bootstrap replications

// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}

//------------------------------------------------------------------------------
// 1. Stacked DID Event Study - Baseline
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

gen log_ch = log(ch)
gen rel_year = relative_year + 4

// pre-trend lags + entropy-balance weights
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}

ebalance treat *_l1 *_l2 *_l3 *_l4 if relative_year == 0, gen(_ebal)
egen ebal = mean(_ebal), by(firm_id)

egen cy = group(cohort year)

distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)

// explicit event-time dummies (base rel_year 3 = event -1 omitted)
forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}

// areg: firm FE absorbed, cohort-year as explicit dummies, entropy weights
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)

// per event dummy: point estimate + wild cluster bootstrap 90% CI (Webb weights)
tempname pf1
tempfile res1
postfile `pf1' double xpos double b double lo double hi byte phase using "`res1'", replace
foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf1' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
postclose `pf1'

local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
use "`res1'", clear
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Baseline", justification(center) size(small)) ///
	note(`notearg', justification(left) size(vsmall)) ///
	name(e1, replace) nodraw
restore

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

tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
ebalance treat *_l1 *_l2 *_l3 *_l4 if relative_year == 0, gen(_ebal)
egen ebal = mean(_ebal), by(firm_id)

egen cy = group(cohort year)

distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)

forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}

qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)

tempname pf2
tempfile res2
postfile `pf2' double xpos double b double lo double hi byte phase using "`res2'", replace
foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf2' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
postclose `pf2'

local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
use "`res2'", clear
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Excluding regions with no treated", justification(center) size(small)) ///
	note(`notearg', justification(left) size(vsmall)) ///
	name(e2, replace) nodraw
restore

//------------------------------------------------------------------------------
// 3. Stacked DID Event Study - Left / Right populists
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

tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)

// ---- Left populists ----
cap drop _ebal ebal
ebalance lpop *_l1 *_l2 *_l3 *_l4 ///
	if relative_year == 0 & (treat==0 | lpop==1), gen(_ebal)
egen ebal = mean(_ebal), by(firm_id)

distinct iso if treat==0 | lpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if lpop==1
local nt = r(ndistinct)

forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (lpop == 1 & rel_year == `r')
}

qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1 [aweight=ebal], ///
	absorb(firm_id) cluster(iso)

tempname pf3
tempfile res3
postfile `pf3' double xpos double b double lo double hi byte phase using "`res3'", replace
foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf3' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
postclose `pf3'

local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
use "`res3'", clear
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Left-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Left Populists: Excluding regions with no treated", justification(center) size(small)) ///
	note(`notearg', justification(left) size(vsmall)) ///
	name(e3, replace) nodraw
restore

// ---- Right populists ----
cap drop _ebal ebal
ebalance rpop *_l1 *_l2 *_l3 *_l4 ///
	if relative_year == 0 & (treat==0 | rpop==1), gen(_ebal)
egen ebal = mean(_ebal), by(firm_id)

distinct iso if treat==0 | rpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if rpop==1
local nt = r(ndistinct)

forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (rpop == 1 & rel_year == `r')
}

qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1 [aweight=ebal], ///
	absorb(firm_id) cluster(iso)

tempname pf4
tempfile res4
postfile `pf4' double xpos double b double lo double hi byte phase using "`res4'", replace
foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf4' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
postclose `pf4'

local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
use "`res4'", clear
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Right-Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Right Populists: Excluding regions with no treated", justification(center) size(small)) ///
	note(`notearg', justification(left) size(vsmall)) ///
	name(e4, replace) nodraw
restore

graph combine e1 e2 e3 e4, xcommon rows(2)
graph export "$path/JIBS/output/plots/wild-baseline-left-right-polity.png", replace

//------------------------------------------------------------------------------
// By Geographical Region:
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

drop if region == "Northern Europe" ///
	| region == "Western Europe" ///
	| continent == "Africa" ///
	| region=="Australia and New Zealand"

gen log_ch = log(ch)
gen rel_year = relative_year + 4

levelsof continent, local(regions)

egen cy = group(cohort year)

foreach region of local regions {

	preserve

	keep if continent=="`region'"

	cap drop  `v'_l* _ebal ebal

	tsset firm_id relative_year
	foreach v in log_ch polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
	}
	
	if "`region'"=="Americas"{
		local tolerance = "tolerance(3.07866715)"
	} 
	else local tolerance ""
	
	// entropy-balance weights
	ebalance treat *_l1 *_l2 *_l3 *_l4 ///
		if relative_year == 0, gen(_ebal) `tolerance'
	egen ebal = mean(_ebal), by(firm_id)

	local r = subinstr("`region'", " ", "", .)

	distinct iso
	local ncl = r(ndistinct)
	distinct firm_id if treat==1
	local nt = r(ndistinct)
	distinct firm_id if treat==0
	local nc = r(ndistinct)

	forvalues k = 0/7 {
		if `k' != 3 gen byte d`k' = (treat == 1 & rel_year == `k')
	}

	qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)

	tempname pf
	tempfile res
	postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
	foreach k of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`k']
		boottest d`k', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`k' >= 4)
		post `pf' (`k' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
	}
	postclose `pf'

	local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
	use "`res'", clear
	twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
	       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
	       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
	       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
	       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
		yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("Log Cash Holdings", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
		xscale(range(0.5 8.5)) legend(off) ///
		subtitle("`region' Sample", justification(center) size(small)) ///
		note(`notearg', justification(left) size(vsmall)) ///
		name(e`r', replace) nodraw

	restore
}

graph combine eAmericas eEurope eAsia, ///
	xcommon ycommon rows(1)
graph export "$path/JIBS/output/plots/wild-by-continent-polity.png", replace

//------------------------------------------------------------------------------
// By World Bank Region:
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

gen log_ch = log(ch)
gen rel_year = relative_year + 4

gen _wb_region = ""
replace _wb_region = "High Income" if wb_region == "High income"
replace _wb_region = "Middle Income" if wb_region=="Lower middle income" ///
									  | wb_region=="Upper middle income"

levelsof _wb_region, local(wb_regions)

egen cy = group(cohort year)

foreach region of local wb_regions {

	preserve

	keep if _wb_region=="`region'"

	cap drop  `v'_l* _ebal ebal

	tsset firm_id relative_year
	foreach v in log_ch polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
	}

	// entropy-balance weights
	ebalance treat *_l1 *_l2 *_l3 *_l4 ///
		if relative_year == 0, gen(_ebal)
	egen ebal = mean(_ebal), by(firm_id)

	local r = subinstr("`region'", " ", "", .)

	distinct iso
	local ncl = r(ndistinct)
	distinct firm_id if treat==1
	local nt = r(ndistinct)
	distinct firm_id if treat==0
	local nc = r(ndistinct)

	forvalues k = 0/7 {
		if `k' != 3 gen byte d`k' = (treat == 1 & rel_year == `k')
	}

	qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)

	tempname pf
	tempfile res
	postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
	foreach k of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`k']
		qui boottest d`k', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`k' >= 4)
		post `pf' (`k' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
	}
	postclose `pf'

	local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
	use "`res'", clear
	twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
	       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
	       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
	       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
	       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
		yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("Log Cash Holdings", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
		xscale(range(0.5 8.5)) legend(off) ///
		subtitle("World Bank `region' Sample", justification(center) size(small)) ///
		note(`notearg', justification(left) size(vsmall)) ///
		name(e`r', replace) nodraw

	restore
}

graph combine eHighIncome eMiddleIncome, ///
	xcommon ycommon rows(1)
graph export "$path/JIBS/output/plots/wild-by-wb-region-polity.png", replace


//------------------------------------------------------------------------------
// By Democracy/Autocracy
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

gen log_ch = log(ch)
gen rel_year = relative_year + 4

// None of the countries that remain non-democracies or autocracies for 8 years
// Have treated cases, so no point.
* egen ndem_count = total(polity2<=5), by(firm_id)
* egen aut_count = total(polity2<-5), by(firm_id) // only 2,032 firms here

// Always using relative_year==0 to count firms, not obs
// Full sample, we have 90k Control and 1,384 treat firms (in 18 countries)
tab treat if relative_year==0

// So let's do: 
// 1. Countries that stay as democracies for 8 years:
egen dem_count = total(polity2>5), by(firm_id) 
gen dem_sample = (dem_count==8)

keep if dem_sample==1

// pre-trend lags + entropy-balance weights
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}

ebalance treat *_l1 *_l2 *_l3 *_l4 if relative_year == 0, gen(_ebal)
egen ebal = mean(_ebal), by(firm_id)

egen cy = group(cohort year)

distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)

// explicit event-time dummies (base rel_year 3 = event -1 omitted)
forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}

// areg: firm FE absorbed, cohort-year as explicit dummies, entropy weights
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)

// per event dummy: point estimate + wild cluster bootstrap 90% CI (Webb weights)
tempname pf1
tempfile res1
postfile `pf1' double xpos double b double lo double hi byte phase using "`res1'", replace
foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf1' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
postclose `pf1'

local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
use "`res1'", clear
twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
	yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
	ytitle("Log Cash Holdings", size(small)) ///
	xtitle("Periods Since Populist Leader", size(small)) ///
	xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
	xscale(range(0.5 8.5)) legend(off) ///
	subtitle("Fully Democratic Sample", justification(center) size(small)) ///
	note(`notearg', justification(left) size(vsmall)) ///
	name(eDem, replace) nodraw
restore


//------------------------------------------------------------------------------
// By Democracy/Autocracy
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

gen log_ch = log(ch)
gen rel_year = relative_year + 4

// None of the countries that remain non-democracies or autocracies for 8 years
// Have treated cases, so no point.
* egen ndem_count = total(polity2<=5), by(firm_id)
* egen aut_count = total(polity2<-5), by(firm_id) // only 2,032 firms here

// Always using relative_year==0 to count firms, not obs
// Full sample, we have 90k Control and 1,384 treat firms (in 18 countries)
tab treat if relative_year==0

// So let's do: 
// 1. Countries that stay as democracies for 8 years:
egen dem_count = total(polity2>5), by(firm_id) 
gen dem_sample = (dem_count==8)

// Of the 90k controls and 1,384 treated firms: 
// 66.8k controls and 1,144 treated firms are in democratic countries for all 8 years
tab treat if relative_year==0 & dem_sample == 1

// 2. Democratic Controls vs Transitioning treated
egen dem_pre = total(polity2>5 & relative_year<0), by(firm_id) 
egen ndem_post = total(polity2<=5 & relative_year>0), by(firm_id) 
egen aut_post = total(polity2<1 & relative_year>0), by(firm_id) 

gen trans_sample = .  if treat==1 & relative_year==0
// Controls that stay democratic for 8
replace trans_sample = 1 if dem_sample==1 & treat==0 
replace trans_sample = 1 if dem_sample==1 & treat==1
replace trans_sample = 1 if dem_pre==4 & ndem_post > 0 & treat==1

// Of the 1,384 treated firms, 
// 1,144 remain democratic 8 years
// 240 have democratic pre-treat and non-democratic post
// 7 are in Ecuador (2007) and 233 are in US (2017)
tab trans_sample treat if relative_year==0
tab country year if trans_sample==1 & treat==1 & relative_year==0

keep if trans_sample == 1 

cap egen cy = group(cohort year)

// pre-trend lags + entropy-balance weights
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}

*ebalance treat *_l1 *_l2 *_l3 *_l4 if relative_year == 0, gen(_ebal)
*egen ebal = mean(_ebal), by(firm_id)

* Arm A = populist only; Arm B = populist + non-democratic
gen byte groupA = (treat == 1 & ndem_post == 0)
gen byte groupB = (treat == 1 & ndem_post > 0)

forvalues k = 0/7 {
    if `k' != 3 {
        gen byte dA`k' = (groupA == 1 & rel_year == `k')
        gen byte dB`k' = (groupB == 1 & rel_year == `k')
    }
}

areg log_ch dA0 dA1 dA2 dA4 dA5 dA6 dA7 ///
                dB0 dB1 dB2 dB4 dB5 dB6 dB7 ///
                i.cy, absorb(firm_id) cluster(iso)
				
distinct firm_id if groupA==1
local ntA = r(ndistinct)
distinct firm_id if groupB==1
local ntB = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)

				
tempname pf
tempfile res
postfile `pf' double xpos double b double lo double hi byte arm byte phase using "`res'", replace

foreach arm in A B {
    local off = cond("`arm'"=="A", -0.12, 0.12)
    local armnum = cond("`arm'"=="A", 1, 2)
    foreach k of numlist 0 1 2 4 5 6 7 {
        local b = _b[d`arm'`k']
        qui boottest d`arm'`k', weighttype(webb) reps($reps) level(90) nograph
        matrix ci = r(CI)
        local phase = (`k' >= 4)
        post `pf' (`k' + 1 + `off') (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`armnum') (`phase')
    }
}
postclose `pf'

local notearg `""`ntA' populist-only, `ntB' populist+non-democratic, and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'

use "`res'", clear
twoway (rcap hi lo xpos if arm==1, lcolor(midblue)) ///
       (scatter b xpos if arm==1, mcolor(midblue) msymbol(O)) ///
       (rcap hi lo xpos if arm==2, lcolor(cranberry)) ///
       (scatter b xpos if arm==2, mcolor(cranberry) msymbol(Oh)) ///
       (scatteri 0 4, mcolor(navy) msymbol(D) msize(medsmall)), ///
    yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
    ytitle("Log Cash Holdings", size(small)) ///
    xtitle("Periods Since Populist Leader", size(small)) ///
    xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
    xscale(range(0.5 8.5)) ///
    legend(order(2 "Populist + Democratic" 4 "Populist + Non-Democratic" 5 "Reference (t=-1)") ///
           rows(1) size(vsmall) position(6)) ///
    subtitle("Transitioning Sample", justification(center) size(small)) ///
    note(`notearg', justification(left) size(vsmall)) ///
    name(eTrans, replace)

restore

graph combine eDem eTrans, rows(2) xcommon xsize(7) ysize(10)
graph export "$path/JIBS/output/plots/wild-by-democratic.png", replace

