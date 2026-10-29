/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Clean COMPUSTAT
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
if "`c(username)'" == "ncachanosky" {
	global path "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS"
}                



//------------------------------------------------------------------------------
// Load raw COMPUSTAT data and clean 
//------------------------------------------------------------------------------

use "$path/data/raw/compustat.dta", clear
*use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\raw\compustat.dta", clear

* Create dependent variable
* NC: added `if at > 0' guard - the original line here was `gen ch_at = ch
* / at' with no guard, which would produce a nonsensical or missing value
* differently than intended whenever at<=0 or missing (Stata's own
* division-by-zero/missing handling doesn't automatically give you a
* controlled missing the way an explicit `if' condition does). Matched to
* the same guard already used consistently in the estimation file's
* build_outcomevars for all seven outcomes, so this file and that one
* agree - important now that this file is the authoritative construction
* point and the estimation file is meant to just consume these columns.
gen ch_at = ch / at if at > 0

* NC: outcome-battery ratios, built here alongside ch_at rather than in the
* estimation do-file. Originally these were (re)built inside
* estimates-outcome-battery.do's build_outcomevars program, on the
* assumption the source .dta didn't already carry them - that assumption
* was wrong for ch_at specifically (this file already built it, right
* here, before build_outcomevars ever ran), which caused a real "variable
* already defined" collision the first time a run selected an outcome
* other than ch_at and build_outcomevars tried to re-gen it. Rather than
* keep defensively working around that collision inside the estimation
* file (which only ever treats the symptom, one outcome at a time, as
* each one gets selected), the fix belongs here: every outcome the battery
* uses is now built ONCE, at the same point and by the same logic as
* ch_at always was. The estimation file's build_outcomevars should be
* simplified to just consume these columns (with a cap drop/gen fallback
* only as a defensive no-op, not as the primary construction path) once
* this version of the file has been re-run and master-stacked-firm.dta
* rebuilt.
* Assumed Compustat mnemonics for the raw components (see the estimation
* file's own header for the same assumption, stated there for the reader
* who starts from that file instead of this one):
*   act   - Current Assets, Total (ACT)
*   ppent - Property, Plant and Equipment, Net, Total (PPENT)
*   ivaeq - Investment & Advances, Equity (IVAEQ)
*   ivao  - Investment & Advances, Other (IVAO)
*   intan - Intangible Assets, Total (INTAN)
*   ao    - Assets, Other, Total (AO)
*   invt  - Inventories, Total (INVT)
* If any of these names don't match the actual raw file, this is the
* single place to fix them - everything downstream (both this file's own
* collapse below, and every do-file after it) refers only to the
* resulting _at-suffixed ratio names, never to the raw component names
* directly.
gen act_at   = act   / at if at > 0
gen ppent_at = ppent / at if at > 0
gen ivaeq_at = ivaeq / at if at > 0
gen ivao_at  = ivao  / at if at > 0
gen intan_at = intan / at if at > 0
gen ao_at    = ao    / at if at > 0

* NC: invt_at - inventories / total assets. Added as a further
* decomposition of current assets, alongside act_ex_ch_at: the
* act_ex_ch_at comment above already flags inventory as one of the things
* hiding inside "current assets excluding cash" that makes that outcome
* hard to interpret cleanly (inventory is a very different kind of asset,
* both economically and in terms of expropriation risk, than receivables
* or short-term securities). Isolating it directly lets a rise or fall in
* inventories be read on its own terms rather than folded into a broader
* current-assets bucket. Worth the same interpretive caution as the other
* non-cash components: an inventory build-up under populism could reflect
* deliberate stockpiling (e.g. against expected import restrictions or
* supply disruption - a defensive/precautionary read) just as plausibly
* as a stealability-driven reallocation, and could equally reflect
* slowing sales (unsold inventory accumulating) rather than any
* deliberate portfolio choice at all - inventory changes are read
* differently in the working-capital/operations literature than in a
* portfolio-reallocation frame, and this outcome doesn't by itself
* distinguish between those stories.
gen invt_at  = invt  / at if at > 0

* NC: act_ex_ch_at - current assets EXCLUDING cash, over total assets.
* Added because act_at (current assets / assets) already CONTAINS ch_at
* (cash / assets) as a component - if cash is falling and current assets
* overall is flat or rising, that difference is a within-current-assets
* reallocation that act_at alone can't show directly, only imply. This
* splits it apart explicitly: act - ch, not act alone, so a rise here can
* be read as "the non-cash portion of current assets" moving on its own
* terms, separate from cash's own movement (which ch_at already covers).
* Worth being honest about what this outcome CAN'T distinguish: current
* assets excluding cash still includes receivables, inventory, and
* short-term marketable securities - a reallocation from cash into any of
* those is a much weaker fit for the paper's "hiding assets from
* expropriation" story than a move into intangibles or PP&E abroad would
* be (receivables and short-term securities are still fairly liquid and
* fairly visible to a government looking to seize assets). A rise in
* act_ex_ch_at is at least as consistent with ordinary working-capital or
* precautionary-liquidity behavior (avoiding zero-yield cash specifically
* under inflation/uncertainty, while staying liquid some other way) as it
* is with a stealability-driven reallocation - this outcome doesn't by
* itself resolve which story is right, it just makes the within-current-
* assets movement visible instead of hidden inside act_at's total.
gen act_ex_ch_at = (act - ch) / at if at > 0


// No variance | count if consol!="C" | county!="" -> 0
drop consol county 

// Fix data formats 
cap destring gvkey, replace
cap destring sic, replace

// Main Location variable
encode loc, gen(iso)

local after "loc"
foreach v in fic costat datafmt indfmt isin {
	rename `v' `v'_tmp
	encode `v'_tmp, gen(`v')
	drop `v'_tmp
	
	if "`v'" == "loc" {
		order `v', first
	}
	else {
		order `v', after(`after')
		local after "`v'" // update the local 
	}	
}

// If incorporation is in a different country than headquarters
gen foreign = (iso != fic)

// Clean and gen vars 
cap gen active = (costat=="A")
drop costat

// 
tab curcd if loc=="USA"

// Dates are always last day of a given month/year, so we can ignore day
gen month = month(datadate)
gen year = year(datadate)
rename datadate date
order month year, after(date)

// Keep only obs with AT LEAST the outcome var
keep if ch!=.

//------------------------------------------------------------------------------
// Collapse and save firm-level data
//------------------------------------------------------------------------------

/// We collapse because some firms are interviewed twice within a year
///
/// at/intan/ppent/xrd/xsga/act/ivaeq/ivao/ao (raw Compustat components) and
/// ch_at/act_at/ppent_at/ivaeq_at/ivao_at/intan_at/ao_at (the ratios built
/// above) are all needed downstream by estimates-outcome-battery.do, which
/// tests where cash-holdings reductions under populism are reallocated TO,
/// not just that cash falls. Without these in the collapse statement they
/// are silently dropped here and every one of those outcomes would be
/// all-missing downstream with no error - collapse only keeps variables
/// named in its varlist. The ratios are collapsed alongside the raw
/// components (not derived from the collapsed raw components afterward)
/// so a firm-year that gets collapsed from multiple raw observations
/// (see comment above) gets a ratio that's the mean of the per-observation
/// ratios, consistent with how ch_at has always been handled here (not a
/// ratio-of-means, a mean-of-ratios - see the estimation file's header for
/// the same distinction, noted there for the country-level file).
collapse (mean) aco ch ch_at che cheb chech chee chefs chenfd cmp dcsfd dd1 dvc /// 
	dvp dvpdp dvt emp fca icapt lco opprft pi revt foreign at intan ppent xrd xsga ///
	act ivaeq ivao ao act_at ppent_at ivaeq_at ivao_at intan_at ao_at act_ex_ch_at ///
	invt invt_at, ///
	by(gvkey iso year) 

// Export Firm-level data
//------------------------------------------------------------------------------
save "$path/data/compustat-firm-clean.dta", replace

//------------------------------------------------------------------------------
// Collapse and save country-level data
//------------------------------------------------------------------------------

// This will serve as count / number of obs by country
gen firms = 1

// Same balance-sheet components and ratios added to the firm-level
// collapse above, added here too so the country-level file carries them
// as well. Same mean-of-ratios treatment as ch_at already gets here (not
// a country-level ratio-of-means - that distinction would apply if a
// ratio-of-means version is ever wanted, but this matches the existing
// pattern for ch_at exactly, not a new design choice).
collapse (mean) aco ch che cheb chech chee chefs chenfd cmp dcsfd dd1 dvc dvp /// 
	dvpdp dvt emp fca icapt lco opprft pi revt foreign at intan ppent xrd xsga ///
	act ivaeq ivao ao ch_at act_at ppent_at ivaeq_at ivao_at intan_at ao_at act_ex_ch_at ///
	invt invt_at ///
	(sum) firms, by(iso year)
	

save "$path/data/compustat-country-clean.dta", replace
	
	