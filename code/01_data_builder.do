/********************************************************************************
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
********************************************************************************/

* ==============================================================================
* 1. SETUP AND CONFIGURATION
* ==============================================================================

clear all
set more off


* Set your working directory
global root "C:/Users/ncachanosky/OneDrive/Research/Working Papers/paper-JIBS/"
cd "$root"

global data_raw     "$root\data\raw"
global data_proc    "$root\data\processed"
global code         "$root\code\stata"
global output       "$root\output"
global figures      "$output\figures"
global tables       "$output\tables"
global logs         "$output\logs"


* Install wbopendata if not already installed
capture which wbopendata
if _rc != 0 {
    ssc install wbopendata
    display "wbopendata installed successfully"
}
else {
    display "wbopendata already installed"
}


********************************************************************************
* 2. DOWNLOAD DATA FROM WORLD BANK
********************************************************************************

* Download World Bank indicators
wbopendata, indicator( ///
    GFDD.DM.13;        ///   // GFD: Corporate bond issuance volume to GDP (%)
    GFDD.OI.02;        ///   // GFD: Bank deposits to GDP (%)
    GFDD.OI.06;        ///   // GFD: 5-bank asset concentration
	GFDD.OI.19; 	   ///   // GFD: Banking crisis dummy
    GFDD.SI.01;        ///   // GFD: Bank Z-score
    GFDD.SI.04;        ///   // GFD: Bank credit to bank deposits (%)
    FB.BNK.CAPA.ZS;    ///   // WDI: Bank capital to assets ratio (%)
    FS.AST.PRVT.GD.ZS; ///   // WDI: Domestic credit to private sector (% GDP)
    NE.GDI.FPRV.ZS;    ///   // WDI: Private gross fixed capital formation
	NY.GDP.MKTP.KD.ZG; ///   // WDI: GDP growth (annual %)
	FP.CPI.TOTL.ZG;    ///   // WDI: Inflation (CPI %)
	NE.TRD.GNFS.ZS;    ///   // WDI: Trade (% GDP)
	GC.DOD.TOTL.GD.ZS; ///   // WDI: Central gov. debt, total (% of GDP)
) clear long

drop if region != "LCN"
drop if year < 2002
drop admin*

* Rename variables 
rename gfdd_dm_13         GFD_01
rename gfdd_oi_02         GFD_02
rename gfdd_oi_06         GFD_03
rename gfdd_oi_19         GFD_04
rename gfdd_si_01         GFD_05
rename gfdd_si_04         GFD_06
rename fb_bnk_capa_zs     WDI_01
rename fs_ast_prvt_gd_zs  WDI_02
rename ne_gdi_fprv_zs     WDI_03
rename ny_gdp_mktp_kd_zg  WDI_04
rename fp_cpi_totl_zg     WDI_05
rename ne_trd_gnfs_zs     WDI_06
rename gc_dod_totl_gd_zs  WDI_07

* Label variables
label variable GFD_01 "Corporate bond issuance volume to GDP (%)"
label variable GFD_02 "Bank deposit to GDP (%)"
label variable GFD_03 "5-bank asset concentration"
label variable GFD_04 "Banking crisis dummy"
label variable GFD_05 "Bank Z-score"
label variable GFD_06 "Bank credit to bank deposits (%)"
label variable WDI_01 "Bank capital to asset ratio (%)"
label variable WDI_02 "Domestic credit to private sector (% GDP)"
label variable WDI_03 "Private gross capital formation"
label variable WDI_04 "GDP growth (annual %)"
label variable WDI_05 "Inflation rate (CPI)"
label variable WDI_06 "Trade (% GDP)"
label variable WDI_07 "Central Gov. Debt (% GDP)"


* Sort data
sort countrycode year

* Create time-trends
gen time_trend  = year - 2002
gen time_trend2 = time_trend^2 

label variable time_trend  "Time trend"
label variable time_trend2 "Time trend (sq.)"

* Generate a numeric country identifier (useful for panel commands)
rename countrycode ISO3
rename year YEAR
encode ISO3, gen(country_id)
order country_id ISO3 countryname YEAR


********************************************************************************
* 3. ADD ARGENTINA'S CPI PRIVATE ESTIMATIONS
********************************************************************************
replace WDI_05 = 40.9   if ISO3 == "ARG" & YEAR == 2002
replace WDI_05 =  3.7   if ISO3 == "ARG" & YEAR == 2003
replace WDI_05 =  6.1   if ISO3 == "ARG" & YEAR == 2004
replace WDI_05 = 12.3   if ISO3 == "ARG" & YEAR == 2005
replace WDI_05 =  9.8   if ISO3 == "ARG" & YEAR == 2006
replace WDI_05 =  8.5   if ISO3 == "ARG" & YEAR == 2007
replace WDI_05 =  7.2   if ISO3 == "ARG" & YEAR == 2008
replace WDI_05 =  7.7   if ISO3 == "ARG" & YEAR == 2009
replace WDI_05 = 10.9   if ISO3 == "ARG" & YEAR == 2010
replace WDI_05 =  9.5   if ISO3 == "ARG" & YEAR == 2011
replace WDI_05 = 10.8   if ISO3 == "ARG" & YEAR == 2012
replace WDI_05 = 10.9   if ISO3 == "ARG" & YEAR == 2013
replace WDI_05 = 23.8   if ISO3 == "ARG" & YEAR == 2014
replace WDI_05 = 18.7   if ISO3 == "ARG" & YEAR == 2015
replace WDI_05 = 36.9   if ISO3 == "ARG" & YEAR == 2016
replace WDI_05 = 24.7   if ISO3 == "ARG" & YEAR == 2017

********************************************************************************
* 4. MERGE LALLPI
********************************************************************************
merge 1:1 ISO3 YEAR using "$data_raw/LALLPI_2025"
drop _merge index ISO2 COUNTRY REGION LDC LLDC SIDS *RANK *PERCENTILE
drop if YEAR == 2000

label variable POP   "Populism Index"
label variable PIP   "Institutional Populism"
label variable PEP   "Economic Populism"
label variable IP    "Institutional Policies"
label variable IP_1  "IP: Rule of Law"
label variable IP_2  "IP: Corruption"
label variable IP_3  "Neopatrimonialism"
label variable IP_4  "Freedom of the press"
label variable IP_5  "Clean election index"
label variable IP_6  "Property rights"
label variable EP    "Economic Policies"
label variable EP_1  "EP: Business and labor market regulations"
label variable EP_2  "Government interference"
label variable EP_3  "Monetary and financial freedom"
label variable EP_4  "Freedom of trade"
label variable POP_R "Populist Rhetoric"


* Standardize Populism indices
local vars_to_standardize "POP PIP PEP"

bysort YEAR: egen POP_z = std(POP)
bysort YEAR: egen PEP_z = std(PEP)
bysort YEAR: egen PIP_z = std(PIP)

label variable POP_z "POP (z-score)"
label variable PEP_z "PEP (z-score)"
label variable PIP_z "PIP (z-score)"

/*
foreach var of local vars_to_standardize {
    bysort YEAR: egen `var'_z = std(`var')
    label variable `var'_z "`var' (z-score, whole series)"
}
*/

* ==============================================================================
* 5. CREATE DOLLARIZATION DUMMY
* ==============================================================================
gen dollarized = 0
 * Panama: Always dollarized
replace dollarized = 1 if ISO3 == "PAN" 				// Panama
replace dollarized = 1 if ISO3 == "ECU" & YEAR >= 2000	// Ecuador	
replace dollarized = 1 if ISO3 == "SLV" & YEAR >= 2001  // El Salvador

label variable dollarized "Officilly dollarized"

* ==============================================================================
* 6. CREATE POPULIST TYPOLOGY AND CONTROL GROUP
* ==============================================================================
* Create binary indicators (using median split)
egen PIP_median = median(PIP_z)
egen PEP_median = median(PEP_z)

gen high_PIP = (PIP_z > PIP_median) if !missing(PIP_z)
gen high_PEP = (PEP_z > PEP_median) if !missing(PEP_z)

* Create four quadrants
gen quadrant = .
replace quadrant = 1 if high_PIP==0 & high_PEP==0  // Control
replace quadrant = 2 if high_PIP==0 & high_PEP==1  // PEP
replace quadrant = 3 if high_PIP==1 & high_PEP==0  // PIP
replace quadrant = 4 if high_PIP==1 & high_PEP==1  // POP

label define quad_lab 1 "Low PIP, Low PEP"  ///
					  2 "Low PIP, High PEP" ///
                      3 "High PIP, Low PEP" ///
					  4 "High PIP, High PEP"
					  
label values quadrant quad_lab

* Create dummies (omit quadrant 1 as reference)
tab quadrant, gen(quad_)

drop high* *_median


********************************************************************************
* 7. SAVE THE DATA
********************************************************************************
* Declare panel structure
xtset country_id YEAR

* Save as STATA dataset
save "$data_proc/data.dta", replace

* Optional: Export to CSV for inspection
export delimited using "$data_proc/data.csv", replace


********************************************************************************
* 8. THE END
********************************************************************************