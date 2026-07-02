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
// 2. Loop through each case and append to temp file
//------------------------------------------------------------------------------

use "$path/JIBS/data/prep-stacked.dta", clear

// Get a list of all unique treatment case IDs to loop over.
levelsof case_id, local(cases)

// Create a temporary, empty dataset to store the stacked results.
tempfile stacked_results
save `stacked_results', emptyok

// Now, loop through each case ID you just stored in the local macro `cases`.
foreach case of local cases {
    // In each iteration, start with a fresh copy of the original data.
    use "$path/JIBS/data/prep-stacked.dta", clear

    // Find the start and end year for the current case.
    qui summarize year if case_id == `case'
    local start_y = r(min)
    local end_y = r(max)
	local treat_year = r(min) + 4
	
    // Keep only the data within that case's 8-year time window.
    keep if year >= `start_y' & year <= `end_y'

    // Tag potential controls: for each country, find the mean of pop.
    // If the mean is 0, the country was non-populist for the entire 8-year period.
    egen tag_control = mean(pop), by(iso)
	// But let's also remove the pre-treatment of treated countries
	egen tag_case_id = total(case_id), by(iso)
	// Assure eight obs per country 
	egen tag_obs = count(iso), by(iso)
	
	gen control = (tag_control == 0 & tag_case_id==0 & tag_obs==8)

    // Keep two groups: the treated country itself AND all valid control countries.
    keep if control==1 | case_id == `case'

    // IMPORTANT: Create ID to track which cohort observations belong to.
    gen long cohort = `treat_year'
	
	// Clean-up 
	drop tag_*
	drop if cohort==.
	
	gen relative_year = year - `treat_year'

	
	//--------------------------------------------------------------------------
	// Merge Compustat for that cohort
	//--------------------------------------------------------------------------
	
	merge 1:m iso year using "$path/JIBS/data/compustat-firm-clean.dta", ///
		keep(match) nogen
	
	egen obs_firm = count(gvkey), by(gvkey iso)
	
	keep if obs_firm==8

    // Append this group (the treated unit + its controls) to the results file.
    append using `stacked_results'
    save `stacked_results', replace
}

duplicates drop gvkey iso year cohort, force

//------------------------------------------------------------------------------
// OPTIONAL: Loop again to get country and firm insights
//------------------------------------------------------------------------------

// Get a list of all unique treatment case IDs to loop over.
/*
levelsof cohort, local(cohorts)

foreach cohort of local cohorts {
	
	di "For the `cohort' cohort:"
	
	di "Treated countries:"
	tab country if treat==1 & cohort==`cohort'
	
	levelsof country if treat==1 & cohort==`cohort', local(treated)
	
	foreach country of local treated {
		qui distinct year if country=="`country'" & cohort==`cohort'
		
		if r(ndistinct) != 8 {
			
		// Assure complete panel 
		di "We have missing years for `country'"
		break
		}
		
		// Count # Firms 
		qui distinct gvkey if  country=="`country'" & cohort==`cohort'
		qui local firms = r(ndistinct)
		
		// Flag if any firm has 
		if r(N) / r(ndistinct) != 8 {
		di "We have a problem with `country' in cohort `cohort'"
		break
		}
	}
	
	di "Controls countries:"
	tab country if treat==0 & cohort==`cohort'
	
	qui levelsof country if treat==0 & cohort==`cohort', local(controls)
	
	foreach country of local controls {
		
		// Assure complete panel 
		qui distinct year if country=="`country'" & cohort==`cohort'
		
		if r(ndistinct) != 8 {
		di "We have missing years for `country'"
		break
		}
		
		// Count # Firms 
		qui distinct gvkey if country=="`country'" & cohort==`cohort'
		local firms = r(ndistinct)
		
		if r(N) / r(ndistinct) != 8 {
		di "We have a problem with `country' in cohort `cohort'"
		break
		}
	}
}
*/
//------------------------------------------------------------------------------
// 3. Finalization
//------------------------------------------------------------------------------

// Load the final, stacked dataset.
use `stacked_results', clear

// Just to be sure
drop if cohort==.
duplicates drop gvkey iso year cohort, force

// Create cohort-specific information
egen id = group(iso cohort)
egen firm_id = group(gvkey iso cohort)

// Final Checks 
egen firm_check = count(gvkey), by(firm_id)
tab firm_check
tab relative_year

drop firm_check

gen treat = (case_id!=.)

// Save -4 to 4 panel 
save "$path/JIBS/data/master-stacked-firm.dta", replace

//------------------------------------------------------------------------------
// 4. Finalization for TWFE Panel 
//------------------------------------------------------------------------------

duplicates drop gvkey iso year, force // Avoid repeated controls

egen firm_check = count(gvkey), by(gvkey iso year)
save "$path/JIBS/data/master-clean-twfe-firm.dta", replace



