/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
Randomization inference (RI) for the FEW-CLUSTER sample splits.

Why RI here: the sub-region and World-Bank-income splits have only 2-7 countries
(clusters). With so few clusters the wild cluster bootstrap cannot form a
confidence interval, so we use randomization inference instead.

The randomization: within each cohort we keep the OBSERVED number of treated
countries but randomly choose WHICH countries are treated, then switch on every
firm in the chosen countries. Because whole countries (all their firms) are
turned on/off, the permutation distribution absorbs the variance coming from
unequal cluster (country) sizes.

For each draw we recompute the entropy-balance weights on the placebo-treated
group and refit the areg event study, collecting the 7 event-time coefficients.

This file ONLY estimates and STORES the effect sizes (one .dta per split in
results/tables/rand-inference/). Graphing is kept completely separate — a
template is provided, commented out, at the very bottom, so the plots can be
built/restyled later WITHOUT re-running the permutation.
==============================================================================*/

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------

clear all
set more off
set seed 20260705                 // reproducible permutations

local reps 1000                   // number of permutation draws

// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}

// output folders
cap mkdir "$path/JIBS/results"
cap mkdir "$path/JIBS/results/tables"
cap mkdir "$path/JIBS/results/tables/rand-inference"
cap mkdir "$path/JIBS/output"
cap mkdir "$path/JIBS/output/plots"

//------------------------------------------------------------------------------
// RI engine (COMPUTE ONLY — no graphing): run randomization inference on the
// subsample currently in memory and save the effect sizes to disk.
//   Call as:  ri_eventstudy <reps> "<label>"
//   Needs in memory: ch relative_year treat firm_id iso cohort year
//   Saves: results/tables/rand-inference/ri-<label>.dta with variables
//          draw  (0 = observed, 1..reps = placebo)
//          event (event time: -4..-2, 0..3)
//          b     (coefficient)
//          obs   (1 = observed estimate, 0 = placebo draw)
//------------------------------------------------------------------------------

capture program drop ri_eventstudy
program define ri_eventstudy
	args reps label

	local events 0 1 2 4 5 6 7                       // event dummies kept (rel_year 3 = event -1 is the base)

	// --- basic transforms ---
	gen log_ch  = log(ch)                            // outcome
	gen rel_year = relative_year + 4                 // shift so rel_year 3 = event time -1

	// --- pre-trend lags used by entropy balancing ---
	tsset firm_id relative_year                      // firm_id = gvkey x iso x cohort, one firm per stack
	bysort firm_id (relative_year): gen log_ch_l1 = L1.log_ch
	bysort firm_id (relative_year): gen log_ch_l2 = L2.log_ch
	bysort firm_id (relative_year): gen log_ch_l3 = L3.log_ch
	bysort firm_id (relative_year): gen log_ch_l4 = L4.log_ch

	egen cy = group(cohort year)                     // cohort-by-year fixed effects (entered as i.cy)

	// --- treatment assignment structure (treatment is a country x cohort property) ---
	egen cc_tag = tag(iso cohort)                    // one marker row per country-cohort
	bysort cohort: egen k_c = total(cc_tag * treat)  // observed number of treated countries in each cohort (held fixed)

	// --- open the per-split output file ---
	local fn = subinstr("`label'", " ", "", .)       // filename-safe label
	tempname P
	postfile `P' int draw int event double b byte obs ///
		using "$path/JIBS/results/tables/rand-inference/ri-`fn'.dta", replace

	//--------------------------------------------------------------------------
	// (1) OBSERVED event study (real treatment) -> saved as draw 0
	//--------------------------------------------------------------------------
	foreach k of local events {
		gen byte d`k' = (treat == 1 & rel_year == `k')   // real event-time dummies
	}

	capture drop _ebal ebal
	capture quietly ebalance treat log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 if relative_year == 0, gen(_ebal)
	if _rc gen double _ebal = cond(relative_year == 0, 1, .)   // fallback: uniform weights if EB fails
	egen double ebal = mean(_ebal), by(firm_id)               // spread the rel_year-0 weight to all firm rows

	qui areg log_ch d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
	foreach k of local events {
		post `P' (0) (`k' - 4) (_b[d`k']) (1)        // observed coefficient per event
	}

	//--------------------------------------------------------------------------
	// (2) PERMUTATION draws -> reassign treated countries within each cohort
	//--------------------------------------------------------------------------
	local nfail 0                                    // count draws where EB fell back to uniform

	forvalues r = 1/`reps' {

		// draw one random key per country-cohort, then broadcast to its firms
		capture drop u rank ptreat pd0 pd1 pd2 pd4 pd5 pd6 pd7 _pebal pebal
		bysort iso cohort: gen double u = runiform() if _n == 1
		bysort iso cohort: replace u = u[1]

		// within each cohort, rank countries by their draw and treat the k_c lowest
		sort cohort u
		by cohort: gen long rank = sum(u != u[_n-1])         // 1,2,3,... per country within the cohort
		gen byte ptreat = (rank <= k_c)                      // placebo-treated = k_c randomly chosen countries

		// recompute entropy-balance weights on the PLACEBO group (with uniform fallback)
		capture quietly ebalance ptreat log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 if relative_year == 0, gen(_pebal)
		if _rc {
			gen double _pebal = cond(relative_year == 0, 1, .)
			local nfail = `nfail' + 1
		}
		egen double pebal = mean(_pebal), by(firm_id)

		// placebo event-time dummies and the refit event study
		foreach k of local events {
			gen byte pd`k' = (ptreat == 1 & rel_year == `k')
		}
		qui areg log_ch pd0 pd1 pd2 pd4 pd5 pd6 pd7 i.cy [aweight=pebal], absorb(firm_id) cluster(iso)

		// save the 7 placebo coefficients from this draw
		foreach k of local events {
			post `P' (`r') (`k' - 4) (_b[pd`k']) (0)
		}

		if mod(`r', 100) == 0 di as txt "    `label': draw `r' / `reps'"
	}

	postclose `P'                                    // finalise the .dta
	if `nfail' > 0 di as error "    NOTE: EB fell back to uniform weights in `nfail' of `reps' draws (`label')"
end

//------------------------------------------------------------------------------
// 1. Sub-region splits (Eastern Asia, Eastern Europe, Southeastern Asia, Southern Europe)
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

keep if inlist(region, "Eastern Asia", "Eastern Europe", "South-eastern Asia", "Southern Europe")
replace region = "Southeastern Asia" if region == "South-eastern Asia"

levelsof region, local(regions)                      // iterate over the sub-regions

foreach reg of local regions {
	preserve
	keep if region == "`reg'"                        // one sub-region at a time
	ri_eventstudy `reps' "`reg'"                      // run RI on this split, save its .dta
	restore
}

//------------------------------------------------------------------------------
// 2. World Bank income-group splits
//------------------------------------------------------------------------------

use "$path/JIBS/data/master-stacked-firm.dta", clear

levelsof wb_region, local(wbs)                        // iterate over the WB income groups

foreach wb of local wbs {
	preserve
	keep if wb_region == "`wb'"                       // one income group at a time
	ri_eventstudy `reps' "`wb'"                       // run RI on this split, save its .dta
	restore
}

//==============================================================================
// GRAPHING TEMPLATE (NOT RUN). Reads the stored per-split effect sizes and draws
// the event study with a placebo null band (5th/95th percentile of the placebo
// coefficients). Uncomment to use AFTER the results are stored — you can restyle
// freely here without ever re-running the permutation above.
//==============================================================================

/*
local ridir "$path/JIBS/results/tables/rand-inference"
local files : dir "`ridir'" files "ri-*.dta"          // one saved file per split

foreach f of local files {

	use "`ridir'/`f'", clear
	local nm = subinstr("`f'", "ri-", "", .)          // split label from filename
	local nm = subinstr("`nm'", ".dta", "", .)

	// observed estimate per event
	preserve
		keep if obs == 1
		keep event b
		rename b bobs
		tempfile obsd
		save `obsd'
	restore

	// placebo null band = 5th/95th percentile of placebo coefficients per event
	keep if obs == 0
	collapse (p5) lo = b (p95) hi = b, by(event)
	merge 1:1 event using `obsd', nogenerate
	gen byte pre = (event < 0)                        // colour pre vs post

	twoway (rarea lo hi event, color(gs13)) ///                        // placebo null band
	       (scatter bobs event if pre==1, mcolor(midblue)  msymbol(O)) ///  // observed pre
	       (scatter bobs event if pre==0, mcolor(cranberry) msymbol(O)) /// // observed post
	       (scatteri 0 -1, mcolor(navy) msymbol(O) msize(medsmall)), ///    // base (event -1)
		yline(0, lcolor(black)) xline(-0.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("Log Cash Holdings", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(-4(1)3) ///
		legend(order(1 "Placebo 5-95 pct" 2 "Pre" 3 "Post") size(vsmall)) ///
		subtitle("`nm'", size(small)) name(g_`nm', replace)

	graph export "$path/JIBS/output/plots/ri-`nm'.png", replace
}
*/
