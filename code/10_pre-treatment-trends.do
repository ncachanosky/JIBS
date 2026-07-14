/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolas Cachanosky, John D. Gibson
================================================================================
Diagnostic (not an estimation file): plots the RAW, UNWEIGHTED mean of ch_at
by relative_year, separately for treated and control firms, for every
sub-sample used in estimates-sample-splits-polity--ebalance.do. Purpose: see
directly whether each spec's pre-treatment path (relative_year -4..-1) looks
linear (favors the "slope" ebalance target, which only matches the linear
trend) or has a kink/level-shift (favors "level", which matches each
pre-period separately) - this is the visual counterpart to the slope-vs-level
disagreement found in the regression results (see chat log: Right populists'
pooled ATT flips sign between targets even after removing polity2 from the
balance target, which rules out weight-concentration as the explanation and
points to a genuine difference in what each target assumes about the shape
of the pre-trend).

No ebalance, no boottest, no fixed effects here on purpose - this is pure
description of the data as-is, so it runs in seconds rather than the 25+
minutes the estimation file takes, and so it cannot be accused of showing a
"balanced" picture - it's what the data looks like BEFORE any reweighting.

Uses ch_at winsorized at 1%/99% (same rule as the estimation file), so the
picture is comparable to what actually enters the regressions - but takes no
other position on functional form, weighting, or fixed effects.
==============================================================================*/

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

capture program drop winsorize_ch_at
program define winsorize_ch_at
	qui centile ch_at, centile(1 99)
	local p1 = r(c_1)
	local p99 = r(c_2)
	qui replace ch_at = `p1'  if ch_at < `p1'  & !missing(ch_at)
	qui replace ch_at = `p99' if ch_at > `p99' & !missing(ch_at)
end

// ------------------------------------------------------------------------
// Helper: collapse to mean ch_at by relative_year x group, for a given
// treated-group indicator and label, and APPEND the result directly into
// the running `stacked' tempfile (passed in as a global filename so it
// survives across calls - see note below on why per-call tempfiles don't
// work here).
// ------------------------------------------------------------------------
// NC: an earlier version of this program tried to `tempfile out_`spec_tag''
// inside the program and collect the filenames into a local for a later
// stacking pass. That does not work: Stata's tempfile allocation is scoped
// such that repeated calls to this program reuse the same underlying temp
// slot regardless of the macro name used to hold it, so every call
// silently overwrote the previous spec's saved file, and by the time the
// stacking loop ran, only the last spec's file still existed (confirmed by
// the log: every "file ... saved as" line pointed at the identical
// ST_..._000003.tmp path). Fixed by writing each spec's result straight
// into a single accumulating dataset on disk ($stackpath) via append,
// rather than trying to keep N separate tempfiles alive across calls.
capture program drop pretrend_means
program define pretrend_means
	args treatvar label spec_tag ifcond

	preserve
	if `"`ifcond'"' != "" {
		qui keep if `ifcond'
	}
	qui keep if inrange(relative_year, -4, -1)
	qui gen byte grp = `treatvar'
	collapse (mean) ch_at (semean) se_ch_at = ch_at (count) n = ch_at, ///
		by(relative_year grp)
	qui gen str40 spec = "`spec_tag'"
	qui gen hi = ch_at + 1.645*se_ch_at
	qui gen lo = ch_at - 1.645*se_ch_at

	capture confirm file "$stackpath"
	if _rc {
		qui save "$stackpath"
	}
	else {
		tempfile thisspec
		qui save "`thisspec'"
		qui use "$stackpath", clear
		qui append using "`thisspec'"
		qui save "$stackpath", replace
	}
	restore
end

// ------------------------------------------------------------------------
// Load once, build everything needed by every spec below (mirrors the
// variable construction in the estimation file, minus lags/ebalance)
// ------------------------------------------------------------------------
* use "$path/JIBS/data/master-stacked-firm.dta", clear
use "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\master-stacked-firm.dta", clear
quietly winsorize_ch_at

qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0

qui gen _wb_region = ""
qui replace _wb_region = "High Income"   if wb_region == "High income"
qui replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
                                      | wb_region == "Upper middle income"

qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)
qui egen ndem_post = total(polity2<=5 & relative_year>0), by(firm_id)
qui egen dem_pre = total(polity2>5 & relative_year<0), by(firm_id)
qui gen trans_sample = . if treat==1 & relative_year==0
qui replace trans_sample = 1 if dem_sample==1 & treat==0
qui replace trans_sample = 1 if dem_sample==1 & treat==1
qui replace trans_sample = 1 if dem_pre==4 & ndem_post > 0 & treat==1
qui bysort firm_id: egen trans_sample_firm = max(trans_sample)

tempfile fullpanel
save "`fullpanel'"

// ------------------------------------------------------------------------
// Run pretrend_means for each spec, matching the estimation file's samples.
// $stackpath is a REAL (non-temp) file on disk, not a Stata tempfile - it
// has to survive being use'd and save'd repeatedly across many separate
// pretrend_means calls in this do-file, which is exactly the pattern that
// broke with Stata's tempfile scoping (see note in the program above).
// Deleted and rebuilt fresh at the start of each run.
// ------------------------------------------------------------------------
global stackpath "`c(tmpdir)'pretrend_stack_working.dta"
capture erase "$stackpath"

use "`fullpanel'", clear
pretrend_means treat "Baseline" "Baseline" ""

use "`fullpanel'", clear
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
pretrend_means treat "Excluding no-treated regions" "ExclNoTreated" ""

use "`fullpanel'", clear
pretrend_means lpop "Left populists" "LeftPop" "treat==0 | lpop==1"

use "`fullpanel'", clear
pretrend_means rpop "Right populists" "RightPop" "treat==0 | rpop==1"

use "`fullpanel'", clear
qui drop if continent == "Africa" | continent == "Americas" | continent == "Oceania"
qui levelsof continent, local(continents)
foreach c of local continents {
	local ctag = subinstr("`c'", " ", "", .)
	use "`fullpanel'", clear
	qui drop if continent == "Africa" | continent == "Americas" | continent == "Oceania"
	pretrend_means treat "`c'" "Cont_`ctag'" `"continent == "`c'""'
}

use "`fullpanel'", clear
qui levelsof _wb_region, local(wbregions)
foreach r of local wbregions {
	local rtag = subinstr("`r'", " ", "", .)
	use "`fullpanel'", clear
	pretrend_means treat "WB: `r'" "WB_`rtag'" `"_wb_region == "`r'""'
}

use "`fullpanel'", clear
pretrend_means treat "Fully Democratic Sample" "FullyDem" "dem_sample==1"

use "`fullpanel'", clear
pretrend_means treat "Transitioning sample" "Transitioning" "trans_sample_firm==1"

// ------------------------------------------------------------------------
// $stackpath now holds every spec's collapsed means, appended in place by
// pretrend_means as it went - load it directly, no further stacking needed.
// ------------------------------------------------------------------------
use "$stackpath", clear

qui replace relative_year = relative_year - 0.1 if grp == 0   // small x-offset so treated/control points don't overlap
qui replace relative_year = relative_year + 0.1 if grp == 1

* save "$path/JIBS/data/pretrend_diagnostic_stacked.dta", replace
save "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\papers-JIBS\data\pretrend_diagnostic_stacked.dta", replace

di as result "Saved pretrend_diagnostic_stacked.dta with `=_N' rows across all specs."
di as result "Columns: spec, relative_year, grp (0=control,1=treated), ch_at (mean), se_ch_at, n, hi, lo"

// ------------------------------------------------------------------------
// One small-multiples-style plot per spec, saved individually and combined
// ------------------------------------------------------------------------
qui levelsof spec, local(allspecs)
local plotnames ""
foreach s of local allspecs {
	local sname = subinstr("`s'", " ", "_", .)
	local sname = subinstr("`sname'", ":", "", .)
	quietly {
	twoway (rcap hi lo relative_year if spec=="`s'" & grp==0, lcolor(midblue)) ///
	       (scatter ch_at relative_year if spec=="`s'" & grp==0, mcolor(midblue) msymbol(O) connect(l) lcolor(midblue)) ///
	       (rcap hi lo relative_year if spec=="`s'" & grp==1, lcolor(cranberry)) ///
	       (scatter ch_at relative_year if spec=="`s'" & grp==1, mcolor(cranberry) msymbol(O) connect(l) lcolor(cranberry)), ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		ytitle("Mean Cash / Total Assets", size(small)) ///
		xlabel(-4 -3 -2 -1) ///
		legend(order(2 "Control (unweighted)" 4 "Treated") rows(1) size(vsmall) position(6)) ///
		title("`s'", size(small)) ///
		name(p_`sname', replace) nodraw
	}
	local plotnames "`plotnames' p_`sname'"
}
graph combine `plotnames', xcommon rows(3)
* graph export "$path/JIBS/output/plots/pretrend-diagnostic-all-specs.png", replace
graph export "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/papers-JIBS/output/plots/pretrend-diagnostic-all-specs.png", replace

di as result "=========================================================="
di as result "Also check the underlying numbers directly if the combined"
di as result "plot is too small to read - e.g.:"
di as result `"  use "$path/pretrend_diagnostic_stacked.dta", clear"'
di as result `"  list spec relative_year grp ch_at n if grp==1, sepby(spec)"'
di as result "=========================================================="
