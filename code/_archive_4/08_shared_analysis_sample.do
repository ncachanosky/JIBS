/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
08: Build the shared analysis sample
================================================================================
WHAT THIS FILE DOES
Builds master-analysis-sample.dta from master-stacked-firm.dta - one shared,
fully-prepared dataset that BOTH the estimation file (10_estimates-outcome-
battery.do) and the companion/descriptives file (11_companion.do) read,
instead of each independently re-deriving the same derived variables from
scratch. This file does NOT estimate anything and does NOT winsorize
anything - it only constructs variables that are safe to compute once, the
same way, regardless of which downstream file or which subsample eventually
uses them.

WHY THIS FILE EXISTS (AND WHY IT'S NEW)
Before this file, the estimation file and the companion file each
independently rebuilt rel_year, the lpop/rpop ideology tags, and the
_wb_region income-group bucket - three variables where a silent disagreement
between the two files (e.g. one using treat==1 to gate a tag, the other
not) would be very easy to introduce and very hard to notice, since both
files would still run without error, just describe slightly different
samples. Building these ONCE here and having both downstream files use the
same saved file removes that entire class of risk.

WHAT'S DELIBERATELY NOT DONE HERE
- NOT winsorized. Winsorization percentiles depend on which sample they're
  computed against - winsorizing once here, then having a downstream file
  further restrict the sample (e.g. Left populists only), would mean that
  subsample's outcomes are capped at the FULL sample's 1st/99th percentiles,
  not its own. Both 10 and 11 winsorize independently, against whatever
  working sample they actually have in memory at the time - see their own
  headers.
- NOT estimated. No areg, no ebalance, no boottest. This file's only job is
  to prepare data; anything resembling an estimate belongs in 10, and any
  purely descriptive table belongs in 11.

OUTCOME CONSTRUCTION / COMPUSTAT VARIABLE NAMES ASSUMED
All nine outcome ratios (ch_at, act_at, act_ex_ch_at, ppent_at, ivaeq_at,
ivao_at, intan_at, ao_at, invt_at) are expected to already exist as columns
in master-stacked-firm.dta, built upstream in 02_clean-compustat.do - see
that file's header for the underlying Compustat mnemonics assumed
(act/ppent/ivaeq/ivao/intan/ao/invt, alongside the original ch/at). A
defensive fallback (capture-confirm/gen) is included below in case any are
missing, consistent with how 09_estimates-outcome-battery.do already
handles the same situation - if this fallback ever fires, treat it as a
signal that
02_clean-compustat.do needs to be re-run, not as a normal code path.

WHAT GETS SAVED
master-analysis-sample.dta, at the firm-relative_year level, containing:
  - every original column from master-stacked-firm.dta, unchanged
  - all nine _at-suffixed outcome ratios (unwinsorized)
  - rel_year (relative_year + 4, the 0-7 indexing used throughout
    estimation and diagnostics)
  - cy (cohort x year group, used for cohort-year fixed effects)
  - ch_at's four level lags (ch_at_l1-l4) - the entropy-balance target
    variable in every spec across 09_estimates-outcome-battery.do
  - lpop/rpop resolved to a CONSTANT firm-level ideology tag (a treated
    firm's ideology doesn't vary across its own relative_year rows - this
    matches exactly the tagging logic already used in both the estimation
    file and the prior companion file, reproduced here as the single
    authoritative version)
  - _wb_region, a two-bucket collapse of wb_region ("High Income" /
    "Middle Income" / missing) - same collapse already used in both
    downstream files
==============================================================================*/

//------------------------------------------------------------------------------
// Setup
//------------------------------------------------------------------------------
quietly {
clear all
set more off
}

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile_in  "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-stacked-firm.dta"
global datafile_out "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-analysis-sample.dta"

timer clear 97
timer on 97

use "$datafile_in", clear

//------------------------------------------------------------------------------
// Outcome ratios (unwinsorized - see header for why)
//------------------------------------------------------------------------------
quietly {
capture confirm variable ch_at
if _rc != 0 {
	di as error "08: ch_at not found in source data - building from ch/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen ch_at = ch / at if at > 0
}
capture confirm variable act_at
if _rc != 0 {
	di as error "08: act_at not found in source data - building from act/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen act_at = act / at if at > 0
}
capture confirm variable act_ex_ch_at
if _rc != 0 {
	di as error "08: act_ex_ch_at not found in source data - building from (act-ch)/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen act_ex_ch_at = (act - ch) / at if at > 0
}
capture confirm variable ppent_at
if _rc != 0 {
	di as error "08: ppent_at not found in source data - building from ppent/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen ppent_at = ppent / at if at > 0
}
capture confirm variable ivaeq_at
if _rc != 0 {
	di as error "08: ivaeq_at not found in source data - building from ivaeq/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen ivaeq_at = ivaeq / at if at > 0
}
capture confirm variable ivao_at
if _rc != 0 {
	di as error "08: ivao_at not found in source data - building from ivao/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen ivao_at = ivao / at if at > 0
}
capture confirm variable intan_at
if _rc != 0 {
	di as error "08: intan_at not found in source data - building from intan/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen intan_at = intan / at if at > 0
}
capture confirm variable ao_at
if _rc != 0 {
	di as error "08: ao_at not found in source data - building from ao/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen ao_at = ao / at if at > 0
}
capture confirm variable invt_at
if _rc != 0 {
	di as error "08: invt_at not found in source data - building from invt/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
	gen invt_at = invt / at if at > 0
}
}

//------------------------------------------------------------------------------
// Event-time indexing, cohort-year group, ch_at lags
//------------------------------------------------------------------------------
quietly {
gen rel_year = relative_year + 4
tsset firm_id relative_year
bysort firm_id (relative_year): gen ch_at_l1 = L1.ch_at
bysort firm_id (relative_year): gen ch_at_l2 = L2.ch_at
bysort firm_id (relative_year): gen ch_at_l3 = L3.ch_at
bysort firm_id (relative_year): gen ch_at_l4 = L4.ch_at
egen cy = group(cohort year)
}

//------------------------------------------------------------------------------
// Ideology tag (lpop/rpop resolved to a constant firm-level value) and WB
// income-group bucket - single authoritative version, reproduced from the
// logic already used identically in both 09_estimates-outcome-battery.do
// and the prior companion file, so nothing downstream needs to redo this.
//------------------------------------------------------------------------------
quietly {
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
// Sanity checks before saving - cheap, always-on, catch a bad upstream
// rebuild before it silently propagates into both downstream files
//------------------------------------------------------------------------------
di as result "===================================================================="
di as result "08: sanity checks on master-analysis-sample.dta before saving"
di as result "===================================================================="

qui count
di as result "Total firm-relative_year observations: " r(N)

qui distinct firm_id
di as result "Distinct firms: " r(ndistinct)

qui count if treat==1 & lpop!=1 & rpop!=1
if r(N) > 0 {
	di as error "WARNING: " r(N) " treated firm-years have neither lpop nor rpop set - check the Funke PLE ideology merge upstream."
}

qui count if treat==1 & lpop==1 & rpop==1
if r(N) > 0 {
	di as error "WARNING: " r(N) " treated firm-years have BOTH lpop and rpop set - ideology tagging should be mutually exclusive by construction."
}

foreach v in ch_at act_at act_ex_ch_at ppent_at ivaeq_at ivao_at intan_at ao_at invt_at {
	qui count if missing(`v')
	local nmiss = r(N)
	qui count
	local ntot = r(N)
	di as result "`v': " %6.2f (`nmiss'/`ntot'*100) "% missing (" `nmiss' " of " `ntot' ")"
}

tab relative_year, missing

//------------------------------------------------------------------------------
// Save
//------------------------------------------------------------------------------
save "$datafile_out", replace
di as result "Saved: $datafile_out"

//------------------------------------------------------------------------------
// Runtime
//------------------------------------------------------------------------------
timer off 97
qui timer list 97
local runtime_sec = r(t97)
di as result "09 run time: " %9.1f `runtime_sec'/60 " min"
