********************************************************************************
* Project: Latin American Left-Leaning Populism and Business Outcomes
* Purpose: Download World Bank data (WDI & GFD) for Latin American countries
* Author: [Your Name]
* Date: November 26, 2025
********************************************************************************

clear all
set more off

* Set your working directory
* cd "C:/Users/YourName/Documents/JIBS_Paper"

********************************************************************************
* 1. INSTALL WBOPENDATA COMMAND
********************************************************************************

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
* 2. DEFINE LATIN AMERICAN COUNTRIES
********************************************************************************

* ISO 3-letter country codes for Latin America
* Includes South America, Central America, and Mexico
local latam_countries "ARG BLZ BOL BRA CHL COL CRI DOM ECU SLV GTM HND MEX NIC PAN PRY PER URY VEN"

* Note: You can add Caribbean countries if needed:
* CUB (Cuba), HTI (Haiti), JAM (Jamaica), etc.

********************************************************************************
* 3. DOWNLOAD DATA FROM WORLD BANK
********************************************************************************

* Download all indicators in one command
* This approach is more efficient than separate downloads

wbopendata, country(`latam_countries') indicator( ///
    GFDD.DM.13 ///         // GFD: Depth - Stock market cap to GDP
    GFDD.OI.02 ///         // GFD: Stock price volatility
    GFDD.OI.06 ///         // GFD: Stock market turnover ratio
    GFDD.SI.01 ///         // GFD: Stability - Bank Z-score
    GFDD.SI.04 ///         // GFD: Stability - Bank NPLs to gross loans
    FB.BNK.CAPA.ZS ///     // WDI: Bank capital to assets ratio
    FS.AST.PRVT.GD.ZS ///  // WDI: Domestic credit to private sector
    NE.GDI.FPRV.ZS ///     // WDI: Private gross fixed capital formation
) clear long

********************************************************************************
* 4. CLEAN AND STRUCTURE THE DATA
********************************************************************************

* Rename variables for easier use
rename gfdd_dm_13 stock_mkt_cap_gdp
rename gfdd_oi_02 stock_price_volatility
rename gfdd_oi_06 stock_turnover_ratio
rename gfdd_si_01 bank_zscore
rename gfdd_si_04 bank_npl_ratio
rename fb_bnk_capa_zs bank_capital_assets
rename fs_ast_prvt_gd_zs credit_private_gdp
rename ne_gdi_fprv_zs private_investment_gdp

* Keep only relevant variables
keep countrycode countryname year stock_mkt_cap_gdp stock_price_volatility ///
     stock_turnover_ratio bank_zscore bank_npl_ratio bank_capital_assets ///
     credit_private_gdp private_investment_gdp

* Label variables
label variable countrycode "ISO 3-letter country code"
label variable countryname "Country name"
label variable year "Year"
label variable stock_mkt_cap_gdp "Stock market cap to GDP (%)"
label variable stock_price_volatility "Stock price volatility"
label variable stock_turnover_ratio "Stock market turnover ratio (%)"
label variable bank_zscore "Bank Z-score (stability)"
label variable bank_npl_ratio "NPLs to gross loans (%)"
label variable bank_capital_assets "Bank capital to assets (%)"
label variable credit_private_gdp "Domestic credit to private sector (% GDP)"
label variable private_investment_gdp "Private GFCF (% GDP)"

* Sort data
sort countrycode year

* Generate a numeric country identifier (useful for panel commands)
encode countrycode, gen(country_id)
order country_id countrycode countryname year

********************************************************************************
* 5. DATA QUALITY CHECKS
********************************************************************************

* Display summary statistics
summarize

* Check for missing data by country
by countrycode: egen total_obs = count(year)
by countrycode: egen missing_stock = count(stock_mkt_cap_gdp)
gen pct_stock_available = (missing_stock / total_obs) * 100

list countrycode total_obs missing_stock pct_stock_available, ///
    sepby(countrycode) noobs

drop total_obs missing_stock pct_stock_available

* Display year range
summarize year

********************************************************************************
* 6. SAVE THE DATA
********************************************************************************

* Declare panel structure
xtset country_id year

* Save as STATA dataset
save "worldbank_latam_data.dta", replace

* Optional: Export to CSV for inspection
export delimited using "worldbank_latam_data.csv", replace

display "Data downloaded and saved successfully!"
display "Countries included: `latam_countries'"
display "Total observations: " _N

********************************************************************************
* 7. NEXT STEPS
********************************************************************************

* You can now merge this dataset with your LALLPI data using:
* merge 1:1 countrycode year using "your_lallpi_data.dta"

********************************************************************************
* END OF DO-FILE
********************************************************************************
