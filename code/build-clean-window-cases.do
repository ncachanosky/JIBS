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
// 1. Preparation
//------------------------------------------------------------------------------

use "$path/JIBS/data/funke-ple-clean.dta", clear

// Set panel vars 
xtset iso year

// Set panel obs:
global pvars "continent region subregion country year independent pop lpop rpop iso"

// Merge firm observation counts:
merge 1:1 iso year using "$path/JIBS/data/compustat-country-clean.dta"

keep if _merge==3

// Keep only country-years in Compustat data
keep $pvars firms
keep if firms>=1 
drop firms

sort iso year 

// Treated dummy == 1 if there's a switch to a populist leader
// Requires that leader in the last four years is not populist
gen treat_pop = (pop == 1 & ///
				L1.pop == 0 & ///
				L2.pop == 0 & ///
				L3.pop == 0 & ///
				L4.pop == 0)

// This command carries the treatment forward from the initial year.
// It checks if the country was treated in the prior year (treat[_n-1]==1)
// AND if the leader is still populist in the current year (pop==1).
bysort iso (year): replace treat_pop = 1 if pop[_n-1] == 1 & pop == 1

// Identify each case of a transition 

cap drop case_start case_chronological_count start_id

xtset iso year

// Step 1: Create a dummy variable for the start of a valid case.
// This requires 4 years of non-leftist govt (0) followed by 4 years of leftist govt (1).
gen byte case_start = pop==0 & ///
						F1.pop==0 & ///
						F2.pop==0 & ///
						F3.pop==0 & ///
						F4.pop==1 & ///
						F5.pop==1 & ///
						F6.pop==1 & ///
						F7.pop==1 

// Step 2: Create a running count of all cases found so far.
// First, sort by year to ensure the count is chronological.
sort year iso

// Next, generate the running sum. This variable, 'case_chronological_count',
// will hold 1 for all rows after the first case starts, 2 after the second, and so on.
gen long case_chronological_count = sum(case_start)

// Step 3: Pull that count onto the starting year to create a unique ID.
// This new 'start_id' variable will now contain the unique ID (1, 2, 3...)
// but *only* on the specific year each case begins. It will be missing everywhere else.
gen long start_id = case_chronological_count if case_start == 1

// Sort the data back to the order required by xtset
sort iso year

// Step 4: Propagate the ID across the entire 8-year window for each case.
// A year's case ID is the most recent 'start_id' seen in the last 8 years.
// The max() function finds the one non-missing ID in that 8-year moving window.
gen long case_id = max(start_id, L1.start_id, L2.start_id, L3.start_id, ///
	L4.start_id, L5.start_id, L6.start_id, L7.start_id)

// Clean up intermediate variables
drop case_start case_chronological_count start_id

// Save a clean copy of the current data to use as a source
save "$path/JIBS/data/prep-stacked.dta", replace

//------------------------------------------------------------------------------
// 2. Loop through each case and append to temp file
//------------------------------------------------------------------------------

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

    // IMPORTANT: Create a new ID to track which case these observations belong to.
    gen long cohort = `treat_year'
	
	// Clean-up 
	drop tag_*
	drop if cohort==.

    // Append this group (the treated unit + its controls) to the results file.
    append using `stacked_results'
    save `stacked_results', replace
}

//------------------------------------------------------------------------------
// 3. Finalization
//------------------------------------------------------------------------------

// Load the final, stacked dataset.
use `stacked_results', clear

// Just to be sure
drop if cohort==.
duplicates drop iso year cohort, force

// Inspect treated and control
gen treat = (case_id!=.)

bysort cohort: tab country if treat==1
bysort cohort: tab country if treat==0

// Create cohort-specific information
egen id = group(iso cohort)
bysort id (year): gen relative_year = _n - 5
tab relative_year // check 

// Save -4 to 4 panel 
save "$path/JIBS/data/clean-window-cases.dta", replace


