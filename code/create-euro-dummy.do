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
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
	
//------------------------------------------------------------------------------
// 1. Stacked DID Event Study - Baseline
//------------------------------------------------------------------------------

*use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\GitHub\JIBS\data\master-stacked-firm.dta", clear

gen log_ch = log(ch)

gen rel_year = relative_year + 4

distinct iso
local ndistinct = r(ndistinct)

distinct firm_id if treat==1
local nt = r(ndistinct)

distinct firm_id if treat==0
local nc = r(ndistinct)

egen cy = group(cohort year)



* ==============================================================================
* 2. KEEP ONLY EUROPEAN COUNTRIES
* ==============================================================================
* Broad definition of "Europe": EU27 + EFTA + UK + microstates + Balkans/EE
* Turkey and Russia are transcontinental and excluded by default -- add them
* to `europe_iso' if your definition should include them.

keep if region == "Western Europe"  | ///
		region == "Eastern Europe"  | ///
		region == "Southern Europe" | ///
		region == "Northern Europe"


* ==============================================================================
* 3. CREATE EURO (EUROZONE) DUMMY
* ==============================================================================
* Time-varying: euro == 1 starting the year of formal adoption (physical
* changeover year; use the earlier "irrevocable fixing" year -- 1999 for the
* original 11 -- if that better matches your identification strategy).

gen byte euro = 0

decode iso, gen(iso3)
replace euro = 1 if iso3 == "AUT" & year >= 1999
replace euro = 1 if iso3 == "BEL" & year >= 1999
replace euro = 1 if iso3 == "FIN" & year >= 1999
replace euro = 1 if iso3 == "FRA" & year >= 1999
replace euro = 1 if iso3 == "DEU" & year >= 1999
replace euro = 1 if iso3 == "IRL" & year >= 1999
replace euro = 1 if iso3 == "ITA" & year >= 1999
replace euro = 1 if iso3 == "LUX" & year >= 1999
replace euro = 1 if iso3 == "NLD" & year >= 1999
replace euro = 1 if iso3 == "PRT" & year >= 1999
replace euro = 1 if iso3 == "ESP" & year >= 1999
replace euro = 1 if iso3 == "GRC" & year >= 2001
replace euro = 1 if iso3 == "SVN" & year >= 2007
replace euro = 1 if iso3 == "CYP" & year >= 2008
replace euro = 1 if iso3 == "MLT" & year >= 2008
replace euro = 1 if iso3 == "SVK" & year >= 2009
replace euro = 1 if iso3 == "EST" & year >= 2011
replace euro = 1 if iso3 == "LVA" & year >= 2014
replace euro = 1 if iso3 == "LTU" & year >= 2015

label variable euro "Eurozone member (formal, time-varying)"

* Unilateral / non-member euro users -- kept separate by default
gen byte euro_unilateral = 0
replace euro_unilateral = 1 if iso3 == "MNE"                         // Montenegro (1999/2002)
replace euro_unilateral = 1 if iso3 == "XKX" & year >= 2002          // Kosovo
replace euro_unilateral = 1 if inlist(iso3, "AND","MCO","SMR","VAT") // microstate monetary agreements

label variable euro_unilateral "Uses Euro without formal ECB/Eurosystem membership"


* ==============================================================================
* 4. SAVE
* ==============================================================================
* save "$data_proc/europe_euro_sample.dta", replace


