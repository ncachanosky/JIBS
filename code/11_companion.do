/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
Companion do-file: extracts descriptive / documentation tables from
master-stacked-firm-real.dta (real, CPI-deflated cash; see STEP 0 of
estimates-sample-splits-polity--ebalance.do for construction) that are
useful for the paper's data section but are not themselves part of the
estimation. Read-only with respect to the estimation sample used in
estimates-sample-splits-polity--ebalance.do -- this file never estimates
anything, it only describes the data that file consumes.

NC (2026-07-10): switched from master-stacked-firm.dta/ch to
master-stacked-firm-real.dta/real_ch for the balance table (section 4) and
polity2 coverage (section 5), for consistency with the estimation sample --
the balance table is a diagnostic on whether entropy balancing achieved
covariate balance, and it should check balance on the same variable
ebalance actually targets (real_ch), not a variable the paper no longer
estimates on. As a side effect this also drops Venezuela/Taiwan from every
table here, matching their by-design exclusion from real_ch (see STEP 0
comments in the estimation file) -- episode_list.csv and
sample_composition.csv will therefore also stop listing their episodes.
Run this file AFTER the estimation do-file so master-stacked-firm-real.dta
exists (STEP 0 there builds and saves it); this file does not rebuild it
itself, to avoid maintaining the CPI merge logic in two places.

Produces, in output/tables/:
  1. episode_list.csv        - one row per populist-takeover episode (country,
                                cohort year, ideology, region, # treated firms)
  2. sample_composition.csv  - N's (treated/control firms, clusters, dominant-
                                episode share) for every sample split used
                                across the two estimation files (baseline,
                                left/right populists, each continent, each WB
                                income group) -- consolidates diagnostics that
                                are currently scattered as printed di/tab
                                output across both estimation do-files into one
                                table, and includes the continents/regions that
                                get dropped from estimation (Africa, Americas,
                                Oceania) so the drop is documented, not just
                                asserted in a comment.
  3. event_time_coverage.csv - obs count by relative_year x treat, to confirm
                                the panel is balanced (8 periods/firm) as built.
  4. balance_table.csv       - raw (pre-ebalance) treated vs. control means/sd
                                for log_ch, polity2, and their lags at
                                relative_year==0 -- motivates why entropy
                                balancing is needed in the first place.
  5. polity2_coverage.csv    - country-level Polity2 merge coverage, i.e. the
                                automated version of the Iceland/Malta gap
                                already documented by hand in NOTES.md.

Run this after any rebuild of master-stacked-firm.dta or master-stacked-firm-
real.dta, and again whenever the episode/region composition or inflation.csv
coverage changes (new case added, region dropped, VEN/TWN handling revisited,
etc.), so the paper's data-description tables stay in sync with what's
actually in the estimation sample.
==============================================================================*/
//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
quietly{
clear all
set more off

// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global polity_sd_min 0.5    // same degeneracy threshold used in both estimation
                            // do-files - see their headers for rationale.
timer clear 98
timer on 98
}
// Output folder for the tables this file produces. Adjust alongside the
// $path / hardcoded-path pattern used in the estimation do-files.
local outpath "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\output\tables\"

* use "$path/JIBS/data/master-stacked-firm-real.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm-real.dta", clear

quietly{
gen log_ch = log(real_ch)
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in log_ch polity2 {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
	gen `v'_slope = 0.3*`v'_l1 + 0.1*`v'_l2 - 0.1*`v'_l3 - 0.3*`v'_l4
}
// Fill lpop/rpop to a constant firm-level ideology tag, same logic used in
// the Left/Right populist split in both estimation do-files, so the episode
// list and sample-composition table classify each treated firm consistently
// with what estimation actually uses.
egen tag_left  = total(lpop) if treat==1, by(firm_id)
egen tag_right = total(rpop) if treat==1, by(firm_id)
replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
drop tag_left tag_right
gen _wb_region = ""
replace _wb_region = "High Income"   if wb_region == "High income"
replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
                                      | wb_region == "Upper middle income"
}

//------------------------------------------------------------------------------
// Helper program: sample composition stats for one treatment/sample split
//------------------------------------------------------------------------------
// Posts one row to the open postfile `pfname': label, N treated firms, N
// control firms, N clusters (iso), and the dominant-episode share (% of
// treated firms coming from the single largest country) -- the diagnostic
// that motivated dropping Africa/Americas/Oceania and running the
// leave-one-episode-out checks in the estimation files, generalized here to
// every split at once.
// NC: pfname is threaded through as an explicit argument rather than
// referenced as `pf' directly - a program cannot see a tempname local from
// the caller's scope (that's caller-local, not global), so a bare `pf'
// inside the program body is simply undefined and Stata's postfile syntax
// then reads the literal empty string as the destination, throwing the
// cryptic invalid-name r(198) the first time sample_stats is called.
capture program drop sample_stats
program define sample_stats
	args pfname label treatvar ifcond
	quietly {
		count if `treatvar' == 0 & relative_year == 0 & (`ifcond')
		local nc_obs = r(N)
		distinct firm_id if `treatvar' == 1 & relative_year == 0 & (`ifcond')
		local nt = r(ndistinct)
		distinct firm_id if `treatvar' == 0 & relative_year == 0 & (`ifcond')
		local nc = r(ndistinct)
		distinct iso if relative_year == 0 & (`ifcond') & !missing(`treatvar')
		local ncl = r(ndistinct)
		local dom_country = ""
		local dom_share = .
		if `nt' > 0 {
			preserve
			keep if `treatvar' == 1 & relative_year == 0 & (`ifcond')
			egen firm_tag = tag(firm_id)
			keep if firm_tag == 1
			contract country
			gsort -_freq
			local dom_country = country[1]
			local dom_share = _freq[1] / `nt' * 100
			restore
		}
	}
	di as result "`label': `nt' treated firms, `nc' control firms, `ncl' clusters (iso), dominant episode = `dom_country' (" %4.1f `dom_share' "%)"
	post `pfname' ("`label'") (`nt') (`nc') (`ncl') ("`dom_country'") (`dom_share')
end

//------------------------------------------------------------------------------
// 1. Table: Populist takeover episodes
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "1. Populist takeover episodes"
di as result "===================================================================="
preserve
quietly {
	keep if treat == 1 & relative_year == 0
	gen ideology = "Unclassified"
	replace ideology = "Left"  if lpop == 1
	replace ideology = "Right" if rpop == 1
	collapse (first) country continent region subregion _wb_region ideology ///
	         (count) n_treated_firms = firm_id, by(iso cohort)
	rename cohort takeover_year
	rename _wb_region wb_income_group
	order iso country continent region subregion wb_income_group ///
	      takeover_year ideology n_treated_firms
	sort continent country takeover_year
}
list iso country takeover_year ideology n_treated_firms, sep(0) noobs
export delimited using "`outpath'episode_list.csv", replace
restore

//------------------------------------------------------------------------------
// 2. Table: Sample composition across every split used in estimation
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "2. Sample composition by split"
di as result "===================================================================="
tempname pf
tempfile comp
postfile `pf' str32 sample double n_treated double n_control double n_clusters ///
	str32 dominant_episode double dominant_share using "`comp'", replace

sample_stats `pf' "Baseline (full worldwide sample)" treat "1"
sample_stats `pf' "Left populists"  lpop "treat == 0 | lpop == 1"
sample_stats `pf' "Right populists" rpop "treat == 0 | rpop == 1"

quietly levelsof continent, local(continents)
foreach c of local continents {
	sample_stats `pf' "Continent: `c'" treat `"continent == "`c'""'
}

quietly levelsof _wb_region, local(wbregions)
foreach r of local wbregions {
	if "`r'" != "" {
		sample_stats `pf' "WB income group: `r'" treat `"_wb_region == "`r'""'
	}
}

postclose `pf'
preserve
use "`comp'", clear
list, sep(0) noobs
export delimited using "`outpath'sample_composition.csv", replace
restore

//------------------------------------------------------------------------------
// 3. Table: Event-time coverage (confirms the panel is balanced as built)
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "3. Event-time coverage (obs by relative_year x treat)"
di as result "===================================================================="
preserve
quietly contract relative_year treat
export delimited using "`outpath'event_time_coverage.csv", replace
restore
tab relative_year treat

//------------------------------------------------------------------------------
// 4. Table: Treated vs. control balance at relative_year == 0 -- raw and
//    post-ebalance, under both ebalance targets used across the two
//    estimation files
//------------------------------------------------------------------------------
// Motivates entropy balancing (raw columns show how far apart treated and
// control firms are before reweighting) and confirms it's doing its job
// (ebal-weighted control columns should sit much closer to the treated
// column than the raw control column does). Scope: this runs the BASELINE
// full-worldwide-sample ebalance call from estimates-sample-splits-polity--
// ebalance.do (not every subsample-specific call -- there are ~13 of those,
// which would make this table unreadable) under both settings of that
// file's $ebal_target switch -- "slope" (parsimonious, 1-2 moments) and
// "level" (four level lags, up to 8 moments) -- so both disclosed
// robustness-pair members are represented side by side.
di as result "===================================================================="
di as result "4. Treated vs. control balance at relative_year == 0 (raw + post-ebalance)"
di as result "===================================================================="
preserve
quietly {
	keep if relative_year == 0

	// --- Slope-target ebalance (matches $ebal_target=="slope" Baseline) ---
	sum polity2_slope if treat == 1
	if r(sd) < $polity_sd_min {
		local bv_slope "log_ch_slope"
	}
	else {
		local bv_slope "log_ch_slope polity2_slope"
	}
	capture noisily ebalance treat `bv_slope', gen(_ebal_slope)
	capture confirm variable _ebal_slope
	local slope_ok = (_rc == 0)
	if !`slope_ok' {
		di as error "Section 4: slope-target ebalance failed to converge -- slope columns will be missing"
	}

	// --- Level-target ebalance (matches $ebal_target=="level" Baseline) ---
	local bv_level_base "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
	sum polity2_l1 if treat == 1
	if r(sd) < $polity_sd_min {
		local bv_level "`bv_level_base'"
	}
	else {
		local bv_level "`bv_level_base' polity2_l1 polity2_l2 polity2_l3 polity2_l4"
	}
	capture noisily ebalance treat `bv_level', gen(_ebal_level)
	capture confirm variable _ebal_level
	local level_ok = (_rc == 0)
	if !`level_ok' {
		di as error "Section 4: level-target ebalance failed to converge -- level columns will be missing"
	}
}

tempname pf2
tempfile bal
postfile `pf2' str16 variable ///
	double mean_control_raw double sd_control_raw double n_control ///
	double mean_treat double sd_treat double n_treat ///
	double mean_control_ebal_slope double sd_control_ebal_slope ///
	double mean_control_ebal_level double sd_control_ebal_level ///
	using "`bal'", replace
foreach v in log_ch log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 ///
	polity2 polity2_l1 polity2_l2 polity2_l3 polity2_l4 {
	quietly sum `v' if treat == 0
	local mc = r(mean)
	local sc = r(sd)
	local nc = r(N)
	quietly sum `v' if treat == 1
	local mt = r(mean)
	local st = r(sd)
	local nt = r(N)
	local mcs = .
	local scs = .
	if `slope_ok' {
		quietly sum `v' [aweight = _ebal_slope] if treat == 0
		local mcs = r(mean)
		local scs = r(sd)
	}
	local mcl = .
	local scl = .
	if `level_ok' {
		quietly sum `v' [aweight = _ebal_level] if treat == 0
		local mcl = r(mean)
		local scl = r(sd)
	}
	di as result "`v': control raw mean=" %6.3f `mc' " | treat mean=" %6.3f `mt' ///
		" | control ebal(slope) mean=" %6.3f `mcs' " | control ebal(level) mean=" %6.3f `mcl'
	post `pf2' ("`v'") (`mc') (`sc') (`nc') (`mt') (`st') (`nt') ///
		(`mcs') (`scs') (`mcl') (`scl')
}
postclose `pf2'
restore
preserve
use "`bal'", clear
list, sep(0) noobs
export delimited using "`outpath'balance_table.csv", replace
restore

//------------------------------------------------------------------------------
// 5. Table: Polity2 merge coverage by country
//------------------------------------------------------------------------------
// Automated version of the coverage gap already documented by hand in
// NOTES.md (Iceland/Malta entirely excluded from Polity5; a handful of edge-
// year rows unmatched elsewhere). Re-run after any Polity/merge update so
// NOTES.md and this table don't silently drift apart.
di as result "===================================================================="
di as result "5. Polity2 coverage by country"
di as result "===================================================================="
preserve
quietly {
	gen polity_missing = missing(polity2)
	collapse (mean) pct_missing = polity_missing (count) n_obs = polity2, by(country)
	replace pct_missing = pct_missing * 100
	gsort -pct_missing country
}
list country pct_missing n_obs if pct_missing > 0, sep(0) noobs
export delimited using "`outpath'polity2_coverage.csv", replace
restore

//------------------------------------------------------------------------------
// Runtime
//------------------------------------------------------------------------------
quietly{
timer off 98
qui timer list 98
local runtime_sec = r(t98)
}
di as result "Companion do-file run time: " %9.1f `runtime_sec'/60 " min"