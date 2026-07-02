/*==============================================================================
Project: JIBS Paper
File: data_builder.do
Authors: Joao P. Bastos, Nicolás Cachanosky, John D. Gibson
Email: ncachanosky@utep.edu
Institution: The University of Texas at El Paso
Created: 26-Nov-2025
Last Modified: 26-Nov-2025

Description:
    Clean and create dataset

Usage:
    do data_builder.do
    
Outline:
    - 1. Setup and configuration
    - 2. Downlad data from World Bank
	- 3. Add Argentina's CPI private estimates data
	- 4. Merge LALLPI
	- 5. Create dollarization dummy
	- 6. Create populist typology and control group
	- 7. Save the data
	- 8. The End
==============================================================================*/

clear all
set more off

// Set CWD
if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:/Users/ncachanosky/OneDrive/Research/Working Papers/paper-JIBS"
}

//==============================================================================
// V-Party Data
//==============================================================================

// Load V-Party Data
use "$path/JIBS/data/raw/V-Dem-CPD-Party-V2.dta", clear

keep v2paenname v2paorname v2pashname v2paid pf_party_id country_name histname ///
country_id country_text_id year gapstart gapend codingend ///
COWcode gap_index v2xpa_popul v2pavote v2paseatshare

// Merging keys
rename COWcode cow_code 
gen leader_party_id = pf_party_id

// Get most-voted party and party with most seats
egen max_votes = max(v2pavote), by(country_id year)
egen max_seats = max(v2paseatshare), by(country_id year)

// Party name and populism score for the most-voted party
gen leader_vote = v2paenname if max_votes == v2pavote
gen leader_populism_vote = v2xpa_popul if max_votes == v2pavote

// Party name and populism score for the most-voted party
gen leader_seat = v2paenname if max_seats == v2paseatshare
gen leader_populism_seat = v2xpa_popul if max_seats == v2paseatshare

// Mean populism score (weight by [vote/seat] share after collapse)
gen avg_populism_vote = v2xpa_popul * (v2pavote/100)  // Vote Share
gen avg_populism_seat = v2xpa_popul * (v2paseatshare/100) // Seat Share

// We are not indexing leader_* vars: ties are averaged
collapse (mean) v2xpa_popul avg_populism*, ///
	by(cow_code country_text_id year)
	
// Drops territories without COW code
duplicates tag cow_code year, gen(dup)
drop if dup==1 // 2 obs 
drop dup

save "$path/JIBS/data/v-party-country-clean.dta", replace

// Load V-Party Data again
use "$path/JIBS/data/raw/V-Dem-CPD-Party-V2.dta", clear

// Leaner version to get only score for leader party
keep pf_party_id year v2xpa_popul COWcode country_text_id

rename COWcode cow_code 
rename pf_party_id leader_party_id

// Some parties at V-Party level share PartyFacts IDs
// Mostly are in countries without COMPUSTAT coverage anyway, but we aren't
// able to resolve the issues, so we chose to drop.
duplicates tag cow_code leader_party_id year, gen(dup)
drop if dup!=0
drop dup

save "$path/JIBS/data/v-party-leader-clean.dta", replace


//==============================================================================
//  Clean Global Leader Ideology Data and Merge V-Party Data
/*==============================================================================

- Create a panel of leader/years 
- Merge data from V-Party with populism score for leader's party
	- "data/v-party-leader-clean.dta", replace
- Merge alternative measurement: data from V-Party for populism in parliament 
	- "data/v-party-country-clean.dta", replace

==============================================================================*/

use "$path/trade-ideology/data/raw/global_leader_ideologies.dta", clear

keep if year >= 1985

keep country_name cow_code year /// Country indexer
	leader leader_ideology leader_party_eng leader_party_id // Leader indexer

// DUPLICATES 
drop if leader_party_id==.

// Merge information about leader's party
merge 1:1 leader_party_id cow_code year ///
	using "$path/JIBS/data/v-party-leader-clean.dta"
	
// keep==1: We don't have party info, but still may have country info
// drop==2: Parties other than the leader's party
// keep==3: Matched 
keep if _merge==1 | _merge==3  
drop _merge

// Merge broader information about country / parliament 
merge 1:1 cow_code year using "$path/JIBS/data/v-party-country-clean.dta"

// keep==1: Off-election years, we'll extend the data
// Drop==2: nothing we can do
// Keep==3: matched 
keep if _merge==1 | _merge==3  
drop _merge

// Election year dummy: 
cap gen election_year = (country_text_id!="")

// Extend data forward to non-election years
tsset cow_code year 

// Extend ISO codes forward/backward
cap encode country_text_id, gen(iso)
cap egen code = mean(iso), by(country_name)
replace iso = code if iso==.
drop code

// Drop countries with data missing for ALL years
cap egen obs = count(country_text_id), by(country_name)
drop if obs == 0

// Populism shocks 
//==============================================================================

// Sample standard deviation of populist score for the leader 
egen std_pop_leader_full = sd(v2xpa_popul) // Time invariant

egen std_pop_leader = sd(v2xpa_popul), by(cow_code) // Time invariant

// Get Standard deviation of populism by decade

foreach v in seat vote {
	
	// Full Sample
	egen std_pop_full_`v'_85_95 = sd(avg_populism_`v') if year>= 1985 & year<1995
	egen std_pop_full_`v'_95_05 = sd(avg_populism_`v') if year>= 1995 & year<2005
	egen std_pop_full_`v'_05_15 = sd(avg_populism_`v') if year>= 2005 & year<2015
	egen std_pop_full_`v'_15_25 = sd(avg_populism_`v') if year>= 2015 & year<2025
	
	// 
	egen std_pop_full_`v' = sd(avg_populism_seat) 
	
	// Get Standard deviation by country 
	egen std_pop_`v'_85_95 = sd(avg_populism_`v') ///
		if year>= 1985 & year<1995, by(cow_code)
	egen std_pop_`v'_95_05 = sd(avg_populism_`v') ///
		if year>= 1995 & year<2005, by(cow_code) 
	egen std_pop_`v'_05_15 = sd(avg_populism_`v') ///
		if year>= 2005 & year<2015, by(cow_code) 
	egen std_pop_`v'_15_25 = sd(avg_populism_`v') ///
		if year>= 2015 & year<2025, by(cow_code)
		
	// Get Standard deviation of populism for full sample
	egen std_pop_`v' = sd(avg_populism_`v'), by(cow_code)
}

global pop_vars "v2xpa_popul avg_populism_vote avg_populism_seat"

forvalues i=1985/2020 {

	// Using [_n-1] and [_n+1] because L. and F. doesn't work with strings
    // Propagate backward
    qui replace country_text_id = country_text_id[_n-1] ///
        if country_text_id == "" & country_text_id[_n-1] != "" ///
		& iso==L1.iso // Assure we are within same country

    // Propagate forward
    qui replace country_text_id = country_text_id[_n+1] ///
        if country_text_id == "" & country_text_id[_n+1] != "" ///
		& iso==F1.iso // Assure we are within same country
		
	// Propagate while there the same leader/party is in power
	foreach v in $pop_vars {
	qui replace `v' = L1.`v' ///
		if `v'==. & L1.`v'!=. ///
		& (leader[_n-1] == leader | leader_party_eng[_n-1] == leader_party_eng)
	qui replace `v' = F1.`v' ///
		if `v'==. & F1.`v'!=. ///
		& (leader[_n+1] == leader | leader_party_eng[_n+1] == leader_party_eng)
		}
}

global std_vars "std_pop_85_95 std_pop_95_05 std_pop_05_15 std_pop_15_25 std_pop_seats"

// Extend std vars - these are time invariant and the same for all countries
foreach v in $std_vars {
	qui sum `v'
	replace `v' = r(mean)
}

// Create Treatment Variables 
//==============================================================================
// Creating after merge will cause problems because panel indexing will not be 
// a country-year anymore

duplicates drop country_text_id year, force

// Create placeholders
gen treat_leader = . // Increase in populism
gen treat_leader_top25 = . // Top quartile
gen treat_leader_top10 = . // Top decile 
gen treat_seats = .

// Lag variables
forvalues t=1/3 {
	gen l`t'_v2xpa_popul = L`t'.v2xpa_popul
	gen l`t'_avg_populism_seat = L`t'.avg_populism_seat
}
	
// Treat: (1) Election Year & (2) Increase Populism 
replace treat_leader=1 if ///
	election_year==1  &  /// Switch of government
	L1.election_year == 0 & F1.election_year==0 /// No election previous/next year
	& (v2xpa_popul > (L1.v2xpa_popul+std_pop_leader)) /// Increase in populism 
	
// Treat 
sum v2x, d 
scalar p75 = r(p75)
scalar p90 = r(p90)

replace treat_leader_top25=1 if ///
	election_year==1  &  /// New populism score
	L1.election_year == 0 & F1.election_year==0 /// No election previous/next year
	& (v2xpa_popul > p75 & L1.v2xpa_popul < p75) /// populism goes to top25
	
replace treat_leader_top10=1 if ///
	election_year==1  &  /// Switch of government
	L1.election_year == 0 & F1.election_year==0 /// No election previous/next year
	& (v2xpa_popul > p90 & L1.v2xpa_popul < p90) /// populism goes to top10
	
	
// Controls 
replace treat_leader=0 if ///
	(v2xpa_popul == L1.v2xpa_popul & v2xpa_popul == F1.v2xpa_popul) // No change
	
replace treat_leader_top25=0 if ///
	(v2xpa_popul == L1.v2xpa_popul & v2xpa_popul == F1.v2xpa_popul) // No change

replace treat_leader_top10=0 if ///
	(v2xpa_popul == L1.v2xpa_popul & v2xpa_popul == F1.v2xpa_popul) // No change

	
/*replace treat_seats=1 if ///
	election_year==1  &  /// Switch of government
	L1.election_year == 0 & F1.election_year==0 /// No election previous/next year
	(avg_populism_seat > (L1.avp_populism_seat+std_pop_seats)) /// Increase in populism 
*/	


save "$path/JIBS/data/populism-clean.dta", replace


//==============================================================================
//  COMPUSTAT Data 
/*==============================================================================
- Clean COMPUSTAT and merge populism data
==============================================================================*/

// Load COMPUSTAT data
use "$path/JIBS/data/data_clean.dta", clear

// No variance | count if consol!="C" | county!="" -> 0
drop consol county 

// Fix data formats 
cap destring gvkey, replace
cap destring sic, replace

gen country_text_id = fic 

local after "fic"
foreach v in fic costat datafmt indfmt isin loc region {
	rename `v' `v'_tmp
	encode `v'_tmp, gen(`v')
	drop `v'_tmp
	
	if "`v'" == "fic" {
		order `v', first
	}
	else {
		order `v', after(`after')
		local after "`v'" // update the local 
	}	
}


// Clean and gen vars 
cap gen active = (costat=="A")
drop costat

// Dates are always last day of a given month/year, so we can ignore day
gen month = month(datadate)
gen year = year(datadate)
rename datadate date
order month year, after(date)

// Merge 
merge m:1 country_text_id year using "$path/JIBS/data/populism-clean.dta"
keep if _merge==3
drop _merge

save "$path/JIBS/data/jibs-clean.dta", replace






