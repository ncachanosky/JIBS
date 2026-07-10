/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
Conley-Taber (2011) / Alvarez-Ferman (2023a) placebo-in-controls inference for
the THIN splits (continent loop, Left/Right populists, Fully Democratic,
Transitioning) where the wild cluster bootstrap is known to under-reject or
return no CI at all, because validity there requires many TREATED clusters
(G1), which this design cannot grow. This file targets a different margin:
Conley-Taber validity comes from the number of CONTROL clusters (N0), which
IS large here, so it survives exactly the constraint the WCB can't. See
NOTES.md ("Inference with very few country clusters") for the full literature
review; this file operationalizes the recommended fix from that review.

METHOD. For each split, and separately within each populist-episode cohort in
that split, every CONTROL country in the cohort takes a turn standing in as
the "placebo-treated" unit (the true treated country/countries for that
cohort are dropped first, so the placebo distribution reflects pure noise,
not a diluted version of the real effect). Entropy-balance weights are
RECOMPUTED for each placebo draw exactly as for the real spec, and the same
pooled post-treatment ATT is estimated. The observed (real) ATT is then
compared against the empirical distribution of placebo ATTs: the RI p-value
is the share of placebo draws at least as extreme as the real one. Two
variants are reported per MacKinnon & Webb (2020) - RI-t (studentized by each
draw's own SE, robust to cluster-size heterogeneity, recommended) and RI-b
(raw coefficient, reference only) - plus the finest achievable p-value at
that draw count, 1/(N0+1), so a null result can be read as "not enough
placebo draws to reject" rather than mistaken for "precisely estimated
zero." The WCB 90% CI for the same spec is also reported alongside, as the
direct point of comparison this file exists to provide.

COMPUTATIONAL COST. This is much more expensive than the main estimation
file: every (cohort x control country) pair in a split gets its own
ebalance + areg call. With several cohorts and dozens of control countries
per split, that's low hundreds of extra estimations per split, times six
splits. Recommend commmenting out all but one split section on a first run
to confirm the mechanics before running the whole file unattended.

SELF-CONTAINED. Per project convention, this file loads and preps the data
itself rather than sourcing the main estimation file - see that file's
header for why the level/slope ebalance-target switch and the
pick_balancevars helper both exist; they are duplicated here unchanged.

STATA MECHANICS NOTE. The placebo loop resets the working sample between
draws via save/use on tempfile snapshots, NOT preserve/restore. Stata does
not support nested preserve (only one snapshot can be active at a time,
r(621) "already preserved" otherwise), and this loop needs to reset the
sample far more times than a single preserve/restore pair allows. Callers of
ct_placebo (below) must invoke it on a clean, non-preserved working sample -
it will not work if called from inside an open preserve block.
==============================================================================*/
//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
quietly{
clear all
set more off
set seed 20260705
global reps 9999            // wild cluster bootstrap replications (used only
                            // for the reference WCB CI reported alongside
                            // each split's RI p-value, not for the placebo
                            // draws themselves)
global polity_sd_min 0.5    // min treated-group sd of the polity2 pre-trend
                            // quantity required for polity2 to enter the
                            // ebalance target - see main estimation file.
timer clear 96
timer on 96
}
//------------------------------------------------------------------------------
// USER CHOICE: entropy-balance covariate target (matches the main estimation
// file's switch, for a like-for-like comparison)
//------------------------------------------------------------------------------
global ebal_target "slope"   // "slope" or "level" - see main estimation file.
if !inlist("$ebal_target", "slope", "level") {
	di as error `"ebal_target must be "slope" or "level" -- got: $ebal_target"'
	exit 198
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
// Load and prep data once; save as a base snapshot every split reloads from
//------------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", clear
quietly {
gen log_ch = log(ch)
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in log_ch polity2 {
bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
gen `v'_slope = 0.3*`v'_l1 + 0.1*`v'_l2 - 0.1*`v'_l3 - 0.3*`v'_l4
}
// NC: lags/slope computed once here rather than per-split like the main
// file does - safe because continent/region/ideology splits below drop
// whole firms, never partial firm-year windows, so a firm's own lag values
// are identical whether computed before or after subsetting.
egen tag_left  = total(lpop) if treat==1, by(firm_id)
egen tag_right = total(rpop) if treat==1, by(firm_id)
replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
drop tag_left tag_right
gen _wb_region = ""
replace _wb_region = "High Income"   if wb_region == "High income"
replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
                                      | wb_region == "Upper middle income"
egen cy = group(cohort year)
}
tempfile base
qui save `base'

//------------------------------------------------------------------------------
// Helper: entropy-balance covariate target selection (mirrors the main
// estimation file's pick_balancevars unchanged)
//------------------------------------------------------------------------------
capture program drop pick_balancevars
program define pick_balancevars
	args label ifcond
	if "$ebal_target" == "slope" {
		qui sum polity2_slope if `ifcond'
		if r(sd) < $polity_sd_min {
			c_local balancevars "log_ch_slope"
			di as error "`label': polity2 dropped from ebalance target (treated-group sd of polity2 slope = " %5.3f r(sd) " < $polity_sd_min)"
		}
		else {
			c_local balancevars "log_ch_slope polity2_slope"
		}
	}
	else {
		qui sum polity2_l1 if `ifcond'
		if r(sd) < $polity_sd_min {
			c_local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4"
			di as error "`label': polity2 dropped from ebalance target (treated-group sd of polity2 level = " %5.3f r(sd) " < $polity_sd_min)"
		}
		else {
			c_local balancevars "log_ch_l1 log_ch_l2 log_ch_l3 log_ch_l4 polity2_l1 polity2_l2 polity2_l3 polity2_l4"
		}
	}
end

//------------------------------------------------------------------------------
// Helper: Conley-Taber / Alvarez-Ferman placebo-in-controls
//------------------------------------------------------------------------------
// Must be called on a clean working sample (no open preserve) already
// restricted to the split of interest. `truevar' identifies the TRUE
// treatment for this split (treat, lpop, or rpop); `b_obs'/`se_obs' are the
// already-estimated real pooled post-ATT coefficient and SE, passed in by
// the caller. Returns (via c_local) ct_ndraws, ct_p_ri_t, ct_p_ri_b,
// ct_p_floor for the caller to log into a summary table. Leaves the working
// sample as the split-restricted snapshot it started from.
capture program drop ct_placebo
program define ct_placebo
	args label truevar b_obs se_obs
	di as txt "[ct_placebo checkpoint 1] label=`label' truevar=`truevar' b_obs=`b_obs' se_obs=`se_obs'"
	local t_obs = `b_obs' / `se_obs'
	di as txt "[ct_placebo checkpoint 2] t_obs=`t_obs'"
	tempfile split_snapshot
	qui save `split_snapshot'
	di as txt "[ct_placebo checkpoint 3] split snapshot saved"
	tempname pf
	tempfile placebo_draws
	postfile `pf' str24 placebo_iso long placebo_cohort double b double se double t using "`placebo_draws'", replace
	local ndraws = 0
	qui levelsof cohort, local(cohorts)
	di as txt "[ct_placebo checkpoint 4] cohorts = `cohorts'"
	foreach coh of local cohorts {
		qui use `split_snapshot', clear
		qui keep if cohort == `coh'
		qui drop if `truevar' == 1
		qui count
		if r(N) == 0 continue
		qui levelsof iso, local(placebo_isos)
		di as txt "[ct_placebo checkpoint 5] cohort `coh': placebo_isos = `placebo_isos'"
		tempfile cohort_snapshot
		qui save `cohort_snapshot'
		foreach piso of local placebo_isos {
			qui use `cohort_snapshot', clear
			capture qui gen byte ptreat = (iso == "`piso'")
			if _rc != 0 {
				di as error "[ct_placebo] cohort `coh' piso `piso': gen ptreat failed rc=" _rc
				continue
			}
			capture qui count if ptreat == 1 & relative_year == 0
			if _rc != 0 {
				di as error "[ct_placebo] cohort `coh' piso `piso': count failed rc=" _rc
				continue
			}
			if r(N) == 0 continue
			pick_balancevars "`label' placebo `piso' (cohort `coh')" "relative_year==0 & ptreat==1"
			capture noisily ebalance ptreat `balancevars' if relative_year==0, gen(_ebalP)
			capture confirm variable _ebalP
			if _rc != 0 continue
			capture qui egen ebalP = mean(_ebalP), by(firm_id)
			if _rc != 0 {
				di as error "[ct_placebo] cohort `coh' piso `piso': egen ebalP failed rc=" _rc
				continue
			}
			capture qui gen byte post_p = (ptreat == 1 & rel_year >= 4)
			if _rc != 0 {
				di as error "[ct_placebo] cohort `coh' piso `piso': gen post_p failed rc=" _rc
				continue
			}
			capture qui areg log_ch post_p i.year [aweight=ebalP], absorb(firm_id) cluster(iso)
			if _rc == 0 {
				local bb  = _b[post_p]
				local sse = _se[post_p]
				if `sse' < . & `sse' > 0 {
					post `pf' ("`piso'") (`coh') (`bb') (`sse') (`bb'/`sse')
					local ndraws = `ndraws' + 1
				}
			}
		}
	}
	postclose `pf'
	di as result "`label': `ndraws' usable placebo draws (control country x cohort combinations)"
	qui use `split_snapshot', clear
	if `ndraws' == 0 {
		di as error "`label': no usable placebo draws -- cannot compute a placebo-based p-value"
		c_local ct_ndraws 0
		c_local ct_p_ri_t .
		c_local ct_p_ri_b .
		c_local ct_p_floor .
		exit
	}
	preserve
	qui use "`placebo_draws'", clear
	qui count if abs(t) >= abs(`t_obs')
	local n_ge_t = r(N)
	qui count if abs(b) >= abs(`b_obs')
	local n_ge_b = r(N)
	restore
	local p_ri_t    = (`n_ge_t' + 1) / (`ndraws' + 1)
	local p_ri_b    = (`n_ge_b' + 1) / (`ndraws' + 1)
	local p_floor   = 1 / (`ndraws' + 1)
	di as result "`label': observed pooled post-ATT b = " %6.4f `b_obs' ", t = " %5.2f `t_obs'
	di as result "`label': RI-t p-value (studentized, recommended) = " %5.3f `p_ri_t' " (`n_ge_t' of `ndraws' placebo draws at least as extreme)"
	di as result "`label': RI-b p-value (coefficient, reference only) = " %5.3f `p_ri_b'
	di as result "`label': finest achievable p-value at this N0 = " %5.3f `p_floor'
	c_local ct_ndraws `ndraws'
	c_local ct_p_ri_t `p_ri_t'
	c_local ct_p_ri_b `p_ri_b'
	c_local ct_p_floor `p_floor'
end

//------------------------------------------------------------------------------
// Master results table
//------------------------------------------------------------------------------
tempname rpf
tempfile results
postfile `rpf' str32 split double b_obs double se_obs double t_obs ///
	double wcb_lo double wcb_hi double n0 double p_ri_t double p_ri_b double p_floor ///
	using "`results'", replace

//------------------------------------------------------------------------------
// Continent loop: Asia, Europe
//------------------------------------------------------------------------------
// NC: hardcoded to Asia/Europe only, rather than looping over
// levelsof continent - Africa/Americas/Oceania are excluded from the main
// estimation file for non-identification reasons (1 cluster, single-episode
// dominance, zero treated firms respectively; see that file's header), and
// this file exists to fix inference on splits that ARE identified but thin,
// not to revisit the ones that aren't identified at all.
foreach reg in "Asia" "Europe" {
	qui use `base', clear
	qui keep if continent == "`reg'"
	pick_balancevars "`reg'" "relative_year==0 & treat==1"
	capture noisily ebalance treat `balancevars' if relative_year==0, gen(_ebal)
	capture confirm variable _ebal
	if _rc != 0 {
		di as error "`reg': ebalance failed to converge on the real spec -- skipping"
		continue
	}
	qui egen ebal = mean(_ebal), by(firm_id)
	qui forvalues r = 0/7 {
		if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
	}
	qui gen byte post = (treat == 1 & rel_year >= 4)
	qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
	local b_obs  = _b[post]
	local se_obs = _se[post]
	di as result "`reg': pooled post-treatment ATT (real spec) b=" %6.4f `b_obs' " se=" %6.4f `se_obs'
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	capture matrix ci = r(CI)
	if _rc == 0 {
		local wcb_lo = ci[1,1]
		local wcb_hi = ci[rowsof(ci),colsof(ci)]
	}
	else {
		di as error "`reg': could not extract WCB CI matrix (rc=" _rc ") -- wcb_lo/wcb_hi set to missing"
		local wcb_lo = .
		local wcb_hi = .
	}
	di as txt "[checkpoint] `reg': about to call ct_placebo"
	ct_placebo "`reg'" treat `b_obs' `se_obs'
	di as txt "[checkpoint] `reg': ct_placebo returned, ndraws=`ct_ndraws'"
	post `rpf' ("`reg'") (`b_obs') (`se_obs') (`b_obs'/`se_obs') (`wcb_lo') (`wcb_hi') ///
		(`ct_ndraws') (`ct_p_ri_t') (`ct_p_ri_b') (`ct_p_floor')
}

//------------------------------------------------------------------------------
// Left / Right populists
//------------------------------------------------------------------------------
foreach arm in "lpop" "rpop" {
	qui use `base', clear
	local armlabel = cond("`arm'"=="lpop", "Left populists", "Right populists")
	qui keep if treat == 0 | `arm' == 1
	pick_balancevars "`armlabel'" "relative_year==0 & `arm'==1"
	capture noisily ebalance `arm' `balancevars' if relative_year==0, gen(_ebal)
	capture confirm variable _ebal
	if _rc != 0 {
		di as error "`armlabel': ebalance failed to converge on the real spec -- skipping"
		continue
	}
	qui egen ebal = mean(_ebal), by(firm_id)
	qui forvalues r = 0/7 {
		if `r' != 3 gen byte d`r' = (`arm' == 1 & rel_year == `r')
	}
	qui gen byte post = (`arm' == 1 & rel_year >= 4)
	qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
	local b_obs  = _b[post]
	local se_obs = _se[post]
	di as result "`armlabel': pooled post-treatment ATT (real spec) b=" %6.4f `b_obs' " se=" %6.4f `se_obs'
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	capture matrix ci = r(CI)
	if _rc == 0 {
		local wcb_lo = ci[1,1]
		local wcb_hi = ci[rowsof(ci),colsof(ci)]
	}
	else {
		di as error "`armlabel': could not extract WCB CI matrix (rc=" _rc ") -- wcb_lo/wcb_hi set to missing"
		local wcb_lo = .
		local wcb_hi = .
	}
	di as txt "[checkpoint] `armlabel': about to call ct_placebo"
	ct_placebo "`armlabel'" `arm' `b_obs' `se_obs'
	di as txt "[checkpoint] `armlabel': ct_placebo returned, ndraws=`ct_ndraws'"
	post `rpf' ("`armlabel'") (`b_obs') (`se_obs') (`b_obs'/`se_obs') (`wcb_lo') (`wcb_hi') ///
		(`ct_ndraws') (`ct_p_ri_t') (`ct_p_ri_b') (`ct_p_floor')
}

//------------------------------------------------------------------------------
// Fully Democratic Sample
//------------------------------------------------------------------------------
qui use `base', clear
qui egen dem_count = total(polity2 > 5), by(firm_id)
qui gen dem_sample = (dem_count == 8)
qui keep if dem_sample == 1
pick_balancevars "Fully Democratic Sample" "relative_year==0 & treat==1"
capture noisily ebalance treat `balancevars' if relative_year==0, gen(_ebal)
capture confirm variable _ebal
if _rc != 0 {
	di as error "Fully Democratic Sample: ebalance failed to converge on the real spec -- skipping"
}
else {
	qui egen ebal = mean(_ebal), by(firm_id)
	qui forvalues r = 0/7 {
		if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
	}
	qui gen byte post = (treat == 1 & rel_year >= 4)
	qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
	local b_obs  = _b[post]
	local se_obs = _se[post]
	di as result "Fully Democratic Sample: pooled post-treatment ATT (real spec) b=" %6.4f `b_obs' " se=" %6.4f `se_obs'
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	capture matrix ci = r(CI)
	if _rc == 0 {
		local wcb_lo = ci[1,1]
		local wcb_hi = ci[rowsof(ci),colsof(ci)]
	}
	else {
		di as error "Fully Democratic Sample: could not extract WCB CI matrix (rc=" _rc ") -- wcb_lo/wcb_hi set to missing"
		local wcb_lo = .
		local wcb_hi = .
	}
	di as txt "[checkpoint] Fully Democratic Sample: about to call ct_placebo"
	ct_placebo "Fully Democratic Sample" treat `b_obs' `se_obs'
	di as txt "[checkpoint] Fully Democratic Sample: ct_placebo returned, ndraws=`ct_ndraws'"
	post `rpf' ("Fully Democratic Sample") (`b_obs') (`se_obs') (`b_obs'/`se_obs') (`wcb_lo') (`wcb_hi') ///
		(`ct_ndraws') (`ct_p_ri_t') (`ct_p_ri_b') (`ct_p_floor')
}

//------------------------------------------------------------------------------
// Transitioning Sample (Arm A + Arm B pooled -- see main estimation file for
// the Arm A vs Arm B contrast; this file checks the overall treat effect on
// this sample the same way robustness_excl's leave-Thailand-out check does)
//------------------------------------------------------------------------------
qui use `base', clear
qui egen dem_count  = total(polity2 > 5), by(firm_id)
qui gen dem_sample   = (dem_count == 8)
qui egen dem_pre     = total(polity2 > 5 & relative_year < 0), by(firm_id)
qui egen ndem_post   = total(polity2 <= 5 & relative_year > 0), by(firm_id)
qui gen trans_sample = . if treat == 1 & relative_year == 0
qui replace trans_sample = 1 if dem_sample == 1 & treat == 0
qui replace trans_sample = 1 if dem_sample == 1 & treat == 1
qui replace trans_sample = 1 if dem_pre == 4 & ndem_post > 0 & treat == 1
qui keep if trans_sample == 1
pick_balancevars "Transitioning sample" "relative_year==0 & treat==1"
capture noisily ebalance treat `balancevars' if relative_year==0, gen(_ebal)
capture confirm variable _ebal
if _rc != 0 {
	di as error "Transitioning sample: ebalance failed to converge on the real spec -- skipping"
}
else {
	qui egen ebal = mean(_ebal), by(firm_id)
	qui forvalues r = 0/7 {
		if `r' != 3 gen byte d`r' = (treat == 1 & rel_year == `r')
	}
	qui gen byte post = (treat == 1 & rel_year >= 4)
	qui areg log_ch d0 d1 d2 post i.cy [aweight=ebal], absorb(firm_id) cluster(iso)
	local b_obs  = _b[post]
	local se_obs = _se[post]
	di as result "Transitioning sample: pooled post-treatment ATT (real spec) b=" %6.4f `b_obs' " se=" %6.4f `se_obs'
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	capture matrix ci = r(CI)
	if _rc == 0 {
		local wcb_lo = ci[1,1]
		local wcb_hi = ci[rowsof(ci),colsof(ci)]
	}
	else {
		di as error "Transitioning sample: could not extract WCB CI matrix (rc=" _rc ") -- wcb_lo/wcb_hi set to missing"
		local wcb_lo = .
		local wcb_hi = .
	}
	di as txt "[checkpoint] Transitioning sample: about to call ct_placebo"
	ct_placebo "Transitioning sample" treat `b_obs' `se_obs'
	di as txt "[checkpoint] Transitioning sample: ct_placebo returned, ndraws=`ct_ndraws'"
	post `rpf' ("Transitioning sample") (`b_obs') (`se_obs') (`b_obs'/`se_obs') (`wcb_lo') (`wcb_hi') ///
		(`ct_ndraws') (`ct_p_ri_t') (`ct_p_ri_b') (`ct_p_floor')
}

//------------------------------------------------------------------------------
// Export master results table
//------------------------------------------------------------------------------
postclose `rpf'
preserve
qui use "`results'", clear
di as result "===================================================================="
di as result "Summary: real spec (WCB) vs. Conley-Taber/Alvarez-Ferman placebo RI"
di as result "===================================================================="
list, sep(0) noobs
local outpath "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\output\tables\"
export delimited using "`outpath'ct_placebo_results.csv", replace
restore

//------------------------------------------------------------------------------
// Runtime report
//------------------------------------------------------------------------------
quietly{
timer off 96
qui timer list 96
local runtime_sec = r(t96)
}
local runtime_min = floor(`runtime_sec'/60)
local runtime_rem = `runtime_sec' - `runtime_min'*60
di as result "=========================================="
di as result "Total do-file run time: " `runtime_min' " min " %4.1f `runtime_rem' " sec"
di as result "=========================================="