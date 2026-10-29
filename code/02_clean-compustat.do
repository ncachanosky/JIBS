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
gen ch_at = ch / at if at > 0

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
gen act_at       = act   / at if at > 0
gen ppent_at     = ppent / at if at > 0
gen ivaeq_at     = ivaeq / at if at > 0
gen ivao_at      = ivao  / at if at > 0
gen intan_at     = intan / at if at > 0
gen ao_at        = ao    / at if at > 0
gen invt_at      = invt  / at if at > 0
gen act_ex_ch_at = (act - ch) / at if at > 0  // Current assets excluding cash


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
	
	