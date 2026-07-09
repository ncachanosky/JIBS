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
  Diagnostics added throughout (NC):
  - joint pre-trend test {d0}{d1}{d2} per specification
  - unweighted companion spec (no entropy-balance weights) per specification
  - pooled post-treatment ATT (single `post' dummy replacing d4-d7) per specification
  - ebal weight-distribution check (max/min ratio, Kish effective N among
    control firms) per specification, to flag when entropy balance is
    relying on a small subset of extreme-weight controls

  NC: log-cleanup pass - all mechanical/bookkeeping output (variable generation
  notes, tsset confirmations, drop/keep counts, distinct/tab tables used only to
  populate locals, ebalance iteration logs and balance tables, and full areg
  coefficient tables) is now wrapped in quiet/quietly. Only the labeled
  "di as result"/"di as error" diagnostic lines and the actual boottest results
  print. Seven `areg`/`boottest` calls were missing their `qui` prefix (one in
  the continent loop's pooled-ATT and per-event boottest, three in the
  WB-region loop, one in Fully Democratic Sample, one in Transitioning Arm A/B)
  - those were the source of most of the giant coefficient tables in the raw
  log; fixed here. Two `tab` blocks (Left/Right populist panel checks and the
  Transitioning-sample construction checks) are left visible on purpose since
  the surrounding comments document and rely on those printed numbers - quiet
  them too if you want an even shorter log.
  See ideology-efw/docs/eb-did-few-clusters-guide.md and code/hiel-wcb.do.
==============================================================================*/
//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
quietly{
clear all
set more off
set seed 20260705
global reps 9999            // wild cluster bootstrap replications
global polity_sd_min 0.5    // min treated-group sd(polity2_l1) required for polity2
                            // lags to enter the ebalance target; below this it is
                            // numerically unidentified and is dropped (generalizes
                            // the Americas-only fix to every specification)
timer clear 99
timer on 99                 // NC: overall runtime timer, reported at end of do-file
}
quietly{
// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
}
//------------------------------------------------------------------------------
// 1. Stacked DID Event Study - Baseline
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
quietly {
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
}
// --- Entropy-balance covariate selection ---
// polity2 lags are dropped from the balance target when they have near-zero
// variance in the treated group (numerically unidentified for entropy
// balancing; generalizes the Americas-only fix from the continent loop).
qui sum polity2_l1 if relative_year==0 & treat==1
if r(sd) < $polity_sd_min {
	local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	di as error "Baseline: polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
}
else {
	local balancevars "*_l1 *_l2 *_l3 *_l4"
}
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
egen cy = group(cohort year)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
// --- Diagnostic: ebal weight distribution (control firms) ---
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Baseline: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Baseline: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
// explicit event-time dummies (base rel_year 3 = event -1 omitted)
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
// areg: firm FE absorbed, cohort-year as explicit dummies, entropy weights
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Baseline: joint pre-trend test (H0: d0=d1=d2=0)"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
// per event dummy: point estimate + wild cluster bootstrap 90% CI (Webb weights)
tempname pf1
tempfile res1
qui postfile `pf1' double xpos double b double lo double hi byte phase using "`res1'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf1' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf1'
local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
qui use "`res1'", clear
quietly{
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
}
restore
// --- Diagnostic: same spec, no entropy-balance weights ---
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy, ///
	absorb(firm_id) cluster(iso)
di as result "Baseline: unweighted joint pre-trend test (H0: d0=d1=d2=0)"
boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
// --- Diagnostic: pooled post-treatment ATT (same reference period, tighter CI) ---
qui cap drop post
qui gen byte post = (treat == 1 & rel_year >= 4)
qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Baseline: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
//------------------------------------------------------------------------------
// 2. Stacked DID Event Study - Excluding regions with no treated cases
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
qui drop if region == "Northern Europe" ///
	  | region == "Western Europe"  ///
	  | region == "Northern Africa" ///
	  | region == "Australia and New Zealand"
quietly {
gen log_ch = log(ch)
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
}
// --- Entropy-balance covariate selection ---
// polity2 lags are dropped from the balance target when they have near-zero
// variance in the treated group (numerically unidentified for entropy
// balancing; generalizes the Americas-only fix from the continent loop).
qui sum polity2_l1 if relative_year==0 & treat==1
if r(sd) < $polity_sd_min {
	local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	di as error "Excluding no-treated regions: polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
}
else {
	local balancevars "*_l1 *_l2 *_l3 *_l4"
}
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
egen cy = group(cohort year)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
// --- Diagnostic: ebal weight distribution (control firms) ---
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Excluding no-treated regions: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Excluding no-treated regions: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
tempname pf2
tempfile res2
qui postfile `pf2' double xpos double b double lo double hi byte phase using "`res2'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf2' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf2'
local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
qui use "`res2'", clear
quietly{
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
}
restore
// --- Diagnostic: same spec, no entropy-balance weights ---
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy, ///
	absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions: unweighted joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90)
// --- Diagnostic: pooled post-treatment ATT (same reference period, tighter CI) ---
qui cap drop post
qui gen byte post = (treat == 1 & rel_year >= 4)
qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Excluding no-treated regions: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
//------------------------------------------------------------------------------
// 3. Stacked DID Event Study - Left / Right populists
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
qui drop if region == "Northern Europe" ///
	  | region == "Western Europe"  ///
	  | region == "Northern Africa" ///
	  | region == "Australia and New Zealand"
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
// NC: left visible on purpose - sanity check on panel composition for the two arms
tab lpop relative_year if treat==0 | lpop==1
tab rpop relative_year if treat==0 | rpop==1
quietly {
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
}
// ---- Left populists ----
qui cap drop _ebal ebal
// --- Entropy-balance covariate selection ---
// polity2 lags are dropped from the balance target when they have near-zero
// variance in the lpop-treated group (numerically unidentified for entropy
// balancing; generalizes the Americas-only fix from the continent loop).
qui sum polity2_l1 if relative_year==0 & lpop==1
if r(sd) < $polity_sd_min {
	local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	di as error "Left populists: polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
}
else {
	local balancevars "*_l1 *_l2 *_l3 *_l4"
}
qui ebalance lpop `balancevars' ///
	if relative_year == 0 & (treat==0 | lpop==1), gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso if treat==0 | lpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if lpop==1
local nt = r(ndistinct)
}
// --- Diagnostic: ebal weight distribution (control firms) ---
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Left populists: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Left populists: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
qui forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (lpop == 1 & rel_year == `r')
}
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1 [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Left populists: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
tempname pf3
tempfile res3
qui postfile `pf3' double xpos double b double lo double hi byte phase using "`res3'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf3' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf3'
local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
qui use "`res3'", clear
quietly{
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
}
restore
// --- Diagnostic: same spec, no entropy-balance weights ---
// NC: fixed - was missing the "if treat==0 | lpop==1" sample restriction
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | lpop==1, ///
	absorb(firm_id) cluster(iso)
di as result "Left populists: unweighted joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90)
// --- Diagnostic: pooled post-treatment ATT (same reference period, tighter CI) ---
// NC: fixed - was using `treat' instead of `lpop', and missing the sample restriction
qui cap drop post
qui gen byte post = (lpop == 1 & rel_year >= 4)
qui areg log_ch d0 d1 d2 post i.cy if treat==0 | lpop==1 [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Left populists: pooled post-treatment ATT"
boottest {post}, weighttype(webb) reps($reps) level(90)
// ---- Right populists ----
qui cap drop _ebal ebal
// --- Entropy-balance covariate selection ---
// polity2 lags are dropped from the balance target when they have near-zero
// variance in the rpop-treated group (numerically unidentified for entropy
// balancing; generalizes the Americas-only fix from the continent loop).
qui sum polity2_l1 if relative_year==0 & rpop==1
if r(sd) < $polity_sd_min {
	local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	di as error "Right populists: polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
}
else {
	local balancevars "*_l1 *_l2 *_l3 *_l4"
}
qui ebalance rpop `balancevars' ///
	if relative_year == 0 & (treat==0 | rpop==1), gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso if treat==0 | rpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if rpop==1
local nt = r(ndistinct)
}
// --- Diagnostic: ebal weight distribution (control firms) ---
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Right populists: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Right populists: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
qui forvalues r = 0/7 {
	cap drop d`r'
	if `r' != 3 gen byte d`r' = (rpop == 1 & rel_year == `r')
}
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1 [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Right populists: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90) nograph
tempname pf4
tempfile res4
qui postfile `pf4' double xpos double b double lo double hi byte phase using "`res4'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf4' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf4'
local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
qui use "`res4'", clear
quietly{
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
}
restore
// --- Diagnostic: same spec, no entropy-balance weights ---
// NC: fixed - was missing the "if treat==0 | rpop==1" sample restriction
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy if treat==0 | rpop==1, ///
	absorb(firm_id) cluster(iso)
di as result "Right populists: unweighted joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90)
// --- Diagnostic: pooled post-treatment ATT (same reference period, tighter CI) ---
// NC: fixed - was "gen byte post" with no cap drop, causing "variable post already
// defined" crash (post was created in the Left populists block above); also was
// using `treat' instead of `rpop', and missing the sample restriction
qui cap drop post
qui gen byte post = (rpop == 1 & rel_year >= 4)
qui areg log_ch d0 d1 d2 post i.cy if treat==0 | rpop==1 [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
di as result "Right populists: pooled post-treatment ATT"
boottest {post}, weighttype(webb) reps($reps) level(90)
graph combine e1 e2 e3 e4, xcommon rows(2)
* graph export "$path/JIBS/output/plots/wild-baseline-left-right-polity.png", replace
graph export "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/plots/wild-baseline-left-right-polity.png", replace
//------------------------------------------------------------------------------
// By Geographical Region:
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
qui drop if region    == "Northern Europe" ///
	  | region    == "Western Europe"  ///
	  | continent == "Africa"          ///
	  | region    == "Australia and New Zealand"
qui gen log_ch = log(ch)
qui gen rel_year = relative_year + 4
qui levelsof continent, local(regions)
qui egen cy = group(cohort year)
local ok_regions ""
foreach region of local regions {
	preserve
	quietly keep if continent=="`region'"
	quietly {
	cap drop  `v'_l* _ebal ebal
	tsset firm_id relative_year
	foreach v in log_ch polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
	}
	}
	// --- Entropy-balance covariate selection ---
	// polity2 lags are dropped from the balance target when they have near-zero
	// variance in the treated group (numerically unidentified for entropy
	// balancing). NC: generalized from an Americas-only hardcode (this used to
	// be `if "`region'"=="Americas"` only) - any region's treated firms can hit
	// the same degeneracy, so the check now runs for every region.
	qui sum polity2_l1 if relative_year==0 & treat==1
	if r(sd) < $polity_sd_min {
		local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
		di as error "`region': polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
	}
	else {
		local balancevars "*_l1 *_l2 *_l3 *_l4"
	}
*	if "`region'"=="Americas"{								NC: Commented
*		local tolerance = "tolerance(3.07866715)"			NC: Commented
*	} 														NC: Commented
*	else local tolerance ""									NC: Commented
	// entropy-balance weights
	// NC: kept as "capture noisily" (not qui) - this is the fail-safe branch
	// that must stay able to surface an unexpected ebalance error; our own
	// "capture confirm variable _ebal" check below is what actually detects
	// non-convergence (ebalance's own convergence note doesn't set _rc), so
	// switching this to noisily costs nothing when it succeeds and still
	// lets a genuinely different failure be visible if one ever occurs.
	capture noisily ebalance treat `balancevars' ///
		if relative_year == 0, gen(_ebal)
*	capture noisily ebalance treat *_l1 *_l2 *_l3 *_l4 ///  NC: Commented
*		if relative_year == 0, gen(_ebal) `tolerance'		NC: Commented
	capture confirm variable _ebal
	if _rc != 0 {
		di as error "ebalance failed to converge (no _ebal created) for region: `region'"
		restore
		continue
	}
*	ebalance treat *_l1 *_l2 *_l3 *_l4 ///					NC: Commented
*		if relative_year == 0, gen(_ebal) `tolerance'		NC: Commented
	quietly {
	egen ebal = mean(_ebal), by(firm_id)
	tab treat if relative_year==0
	sum polity2_l1 if relative_year==0 & treat==1
	sum polity2_l1 if relative_year==0 & treat==0
	}
	local r = subinstr("`region'", " ", "", .)
	quietly {
	distinct iso
	local ncl = r(ndistinct)
	distinct firm_id if treat==1
	local nt = r(ndistinct)
	distinct firm_id if treat==0
	local nc = r(ndistinct)
	}
	// --- Diagnostic: ebal weight distribution (control firms) ---
	// NC: no preserve/restore here - we're already inside this loop's own
	// preserve/restore (top of the region iteration), and Stata does not
	// allow nested preserve (r(621) "already preserved"). Use if-filters
	// on count/sum instead of keep, so the working sample is untouched.
	qui count if relative_year == 0 & treat == 0 & !missing(ebal)
	local ncw = r(N)
	qui sum ebal if relative_year == 0 & treat == 0 & !missing(ebal), detail
	local wmax = r(max)
	local wmin = r(min)
	qui gen double w2 = ebal^2 if relative_year == 0 & treat == 0 & !missing(ebal)
	qui sum ebal if relative_year == 0 & treat == 0 & !missing(ebal)
	local sumw = r(sum)
	qui sum w2 if relative_year == 0 & treat == 0 & !missing(ebal)
	local sumw2 = r(sum)
	local effN = (`sumw')^2 / `sumw2'
	cap drop w2
	di as result "`region': control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
	di as result "`region': Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
	qui forvalues k = 0/7 {
		if `k' != 3 gen byte d`k' = (treat == 1 & rel_year == `k')
	}
	qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)
	di as result "`region': joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
	tempname pf
	tempfile res
	qui postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
	qui foreach k of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`k']
		qui boottest d`k', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`k' >= 4)
		post `pf' (`k' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
	}
	qui postclose `pf'
	// --- Diagnostic: pooled post-treatment ATT (same reference period, tighter CI) ---
	// NC: added for consistency with the WB-region loop below
	qui cap drop post
	qui gen byte post = (treat == 1 & rel_year >= 4)
	qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)
	di as result "`region': pooled post-treatment ATT"
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
	qui use "`res'", clear
	quietly{
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
	}
	local ok_regions "`ok_regions' e`r'"
	restore
}
graph combine `ok_regions', ///
	xcommon ycommon rows(1)
*graph export "$path/JIBS/output/plots/wild-by-continent-polity.png", replace
graph export "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/plots/wild-by-continent-polity.png", replace
//------------------------------------------------------------------------------
// By World Bank Region:
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
qui gen log_ch = log(ch)
qui gen rel_year = relative_year + 4
qui gen _wb_region = ""
qui replace _wb_region = "High Income"   if wb_region == "High income"
qui replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
									  | wb_region == "Upper middle income"
qui levelsof _wb_region, local(wb_regions)
qui egen cy = group(cohort year)
foreach region of local wb_regions {
	preserve
	quietly keep if _wb_region=="`region'"
	quietly {
	cap drop  `v'_l* _ebal ebal
	tsset firm_id relative_year
	foreach v in log_ch polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
	}
	}
	// --- Entropy-balance covariate selection ---
	// polity2 lags are dropped from the balance target when they have near-zero
	// variance in the treated group (numerically unidentified for entropy
	// balancing; generalizes the Americas-only fix from the continent loop).
	qui sum polity2_l1 if relative_year==0 & treat==1
	if r(sd) < $polity_sd_min {
		local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
		di as error "`region': polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
	}
	else {
		local balancevars "*_l1 *_l2 *_l3 *_l4"
	}
	qui ebalance treat `balancevars' ///
		if relative_year == 0, gen(_ebal)
	qui egen ebal = mean(_ebal), by(firm_id)
	local r = subinstr("`region'", " ", "", .)
	quietly {
	distinct iso
	local ncl = r(ndistinct)
	distinct firm_id if treat==1
	local nt = r(ndistinct)
	distinct firm_id if treat==0
	local nc = r(ndistinct)
	}
	// --- Diagnostic: ebal weight distribution (control firms) ---
	// NC: no preserve/restore here - we're already inside this loop's own
	// preserve/restore (top of the region iteration), and Stata does not
	// allow nested preserve (r(621) "already preserved"). Use if-filters
	// on count/sum instead of keep, so the working sample is untouched.
	qui count if relative_year == 0 & treat == 0 & !missing(ebal)
	local ncw = r(N)
	qui sum ebal if relative_year == 0 & treat == 0 & !missing(ebal), detail
	local wmax = r(max)
	local wmin = r(min)
	qui gen double w2 = ebal^2 if relative_year == 0 & treat == 0 & !missing(ebal)
	qui sum ebal if relative_year == 0 & treat == 0 & !missing(ebal)
	local sumw = r(sum)
	qui sum w2 if relative_year == 0 & treat == 0 & !missing(ebal)
	local sumw2 = r(sum)
	local effN = (`sumw')^2 / `sumw2'
	cap drop w2
	di as result "`region': control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
	di as result "`region': Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
	qui forvalues k = 0/7 {
		if `k' != 3 gen byte d`k' = (treat == 1 & rel_year == `k')
	}
	qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)
	di as result "`region': joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) reps($reps) level(90)	nograph
	tempname pf
	tempfile res
	qui postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
	qui foreach k of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`k']
		qui boottest d`k', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`k' >= 4)
		post `pf' (`k' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
	}
	qui postclose `pf'
	qui cap drop post
	qui gen byte post = (treat == 1 & rel_year >= 4)
	qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], ///
		absorb(firm_id) cluster(iso)
	di as result "`region': pooled post-treatment ATT"
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	// --- Diagnostic: same spec, no entropy-balance weights ---
	// NC: added - WB-region loop was the only spec missing the unweighted
	// companion; needed to check whether High Income's pre-trend problem
	// (and its large, significant pooled ATT) is a weighting artifact.
	qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy, ///
		absorb(firm_id) cluster(iso)
	di as result "`region': unweighted joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
	qui areg log_ch d0 d1 d2 post i.cy, ///
		absorb(firm_id) cluster(iso)
	di as result "`region': unweighted pooled post-treatment ATT"
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
	qui use "`res'", clear
	quietly{
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
	}
	restore
}
graph combine eHighIncome eMiddleIncome, ///
	xcommon ycommon rows(1)
* graph export "$path/JIBS/output/plots/wild-by-wb-region-polity.png", replace
graph export "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/plots/wild-by-wb-region-polity.png", replace
//------------------------------------------------------------------------------
// By Democracy/Autocracy
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
qui gen log_ch = log(ch)
qui gen rel_year = relative_year + 4
// None of the countries that remain non-democracies or autocracies for 8 years
// Have treated cases, so no point.
* egen ndem_count = total(polity2<=5), by(firm_id)
* egen aut_count = total(polity2<-5), by(firm_id) // only 2,032 firms here
// Always using relative_year==0 to count firms, not obs
// Full sample, we have 90k Control and 1,384 treat firms (in 18 countries)
tab treat if relative_year==0
// So let's do:
// 1. Countries that stay as democracies for 8 years:
qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)
qui keep if dem_sample==1
// pre-trend lags + entropy-balance weights
quietly {
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
}
// --- Entropy-balance covariate selection ---
// polity2 lags are dropped from the balance target when they have near-zero
// variance in the treated group (numerically unidentified for entropy
// balancing; generalizes the Americas-only fix from the continent loop).
qui sum polity2_l1 if relative_year==0 & treat==1
if r(sd) < $polity_sd_min {
	local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	di as error "Fully Democratic Sample: polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
}
else {
	local balancevars "*_l1 *_l2 *_l3 *_l4"
}
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
egen cy = group(cohort year)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
// --- Diagnostic: ebal weight distribution (control firms) ---
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Fully Democratic Sample: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Fully Democratic Sample: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
// explicit event-time dummies (base rel_year 3 = event -1 omitted)
qui forvalues r = 0/7 {
	if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
}
// areg: firm FE absorbed, cohort-year as explicit dummies, entropy weights
qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
// NC: fixed - was "`region'" (undefined outside a loop); hardcoded label
di as result "Fully Democratic Sample: joint pre-trend test"
boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
// per event dummy: point estimate + wild cluster bootstrap 90% CI (Webb weights)
tempname pf1
tempfile res1
qui postfile `pf1' double xpos double b double lo double hi byte phase using "`res1'", replace
qui foreach r of numlist 0 1 2 4 5 6 7 {
	local b = _b[d`r']
	qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
	matrix ci = r(CI)
	local phase = (`r' >= 4)
	post `pf1' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
}
qui postclose `pf1'
qui cap drop post
qui gen byte post = (treat == 1 & rel_year >= 4)
qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
// NC: fixed - was "`region'" (undefined outside a loop); hardcoded label
di as result "Fully Democratic Sample: pooled post-treatment ATT"
boottest {post}, weighttype(webb) nograph reps($reps) level(90)
local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
preserve
qui use "`res1'", clear
quietly{
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
}
restore
//------------------------------------------------------------------------------
// By Democracy/Autocracy
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", replace
qui gen log_ch = log(ch)
qui gen rel_year = relative_year + 4
// None of the countries that remain non-democracies or autocracies for 8 years
// Have treated cases, so no point.
* egen ndem_count = total(polity2<=5), by(firm_id)
* egen aut_count = total(polity2<-5), by(firm_id) // only 2,032 firms here
// Always using relative_year==0 to count firms, not obs
// Full sample, we have 90k Control and 1,384 treat firms (in 18 countries)
tab treat if relative_year==0
// So let's do:
// 1. Countries that stay as democracies for 8 years:
qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)
// Of the 90k controls and 1,384 treated firms:
// 66.8k controls and 1,144 treated firms are in democratic countries for all 8 years
// NC: left visible on purpose - documents the sample split referenced in the comments below
tab treat if relative_year==0 & dem_sample == 1
// 2. Democratic Controls vs Transitioning treated
qui egen dem_pre = total(polity2>5 & relative_year<0), by(firm_id)
qui egen ndem_post = total(polity2<=5 & relative_year>0), by(firm_id)
qui egen aut_post = total(polity2<1 & relative_year>0), by(firm_id)
qui gen trans_sample = .  if treat==1 & relative_year==0
// Controls that stay democratic for 8
qui replace trans_sample = 1 if dem_sample==1 & treat==0
qui replace trans_sample = 1 if dem_sample==1 & treat==1
qui replace trans_sample = 1 if dem_pre==4 & ndem_post > 0 & treat==1
// Of the 1,384 treated firms,
// 1,144 remain democratic 8 years
// 240 have democratic pre-treat and non-democratic post
// 7 are in Ecuador (2007) and 233 are in US (2017)
// NC: left visible on purpose - documents the Arm A/Arm B sample construction
tab trans_sample treat if relative_year==0
tab country year if trans_sample==1 & treat==1 & relative_year==0
qui keep if trans_sample == 1
qui cap egen cy = group(cohort year)
// pre-trend lags + entropy-balance weights
quietly {
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
}
// --- Entropy-balance covariate selection ---
// polity2 lags are dropped from the balance target when they have near-zero
// variance in the treated group (numerically unidentified for entropy
// balancing; generalizes the Americas-only fix from the continent loop).
qui sum polity2_l1 if relative_year==0 & treat==1
if r(sd) < $polity_sd_min {
	local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	di as error "Transitioning sample: polity2 dropped from ebalance target (treated-group sd = " %5.3f r(sd) " < $polity_sd_min)"
}
else {
	local balancevars "*_l1 *_l2 *_l3 *_l4"
}
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
qui egen ebal = mean(_ebal), by(firm_id)
// --- Diagnostic: ebal weight distribution (control firms) ---
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Transitioning sample: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Transitioning sample: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore
* Arm A = populist only; Arm B = populist + non-democratic
qui gen byte groupA = (treat == 1 & ndem_post == 0)
qui gen byte groupB = (treat == 1 & ndem_post > 0)
qui forvalues k = 0/7 {
    if `k' != 3 {
        gen byte dA`k' = (groupA == 1 & rel_year == `k')
        gen byte dB`k' = (groupB == 1 & rel_year == `k')
    }
}
qui areg log_ch dA0 dA1 dA2 dA4 dA5 dA6 dA7 ///
                dB0 dB1 dB2 dB4 dB5 dB6 dB7 ///
                i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
di as result "Transitioning sample: Arm A vs Arm B, full profile equality"
boottest {dA0=dB0} {dA1=dB1} {dA2=dB2} {dA4=dB4} {dA5=dB5} {dA6=dB6} {dA7=dB7}, ///
	weighttype(webb) reps($reps) level(90) nograph
di as result "Transitioning sample: Arm A vs Arm B, post-period only"
boottest {dA4=dB4} {dA5=dB5} {dA6=dB6} {dA7=dB7}, ///
	weighttype(webb) reps($reps) level(90) nograph
quietly {
distinct iso
local ncl = r(ndistinct)
distinct firm_id if groupA==1
local ntA = r(ndistinct)
distinct firm_id if groupB==1
local ntB = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
tempname pf
tempfile res
qui postfile `pf' double xpos double b double lo double hi byte arm byte phase using "`res'", replace
qui foreach arm in A B {
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
qui postclose `pf'
preserve
local notearg `""`ntA' populist-only, `ntB' populist+non-democratic, and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'
qui use "`res'", clear
quietly{
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
}
restore
graph combine eDem eTrans, rows(2) xcommon xsize(7) ysize(10)
*graph export "$path/JIBS/output/plots/wild-by-democratic.png", replace
graph export "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/plots/wild-by-democratic.png", replace
//------------------------------------------------------------------------------
// Runtime report
//------------------------------------------------------------------------------
timer off 99
qui timer list 99
local runtime_sec = r(t99)
local runtime_min  = floor(`runtime_sec'/60)
local runtime_rem  = `runtime_sec' - `runtime_min'*60
di as result "=========================================="
di as result "Total do-file run time: " `runtime_min' " min " %4.1f `runtime_rem' " sec"
di as result "=========================================="