/*==============================================================================
Project: JIBS Paper (Cachanosky, Bastos, Gibson)
Firm-level cash-holdings response to populist regime takeovers
================================================================================
WHAT THIS FILE DOES
Stacked difference-in-differences event study. This version tests an
EXPANDED battery of outcomes, not just cash. The original design asked
"does cash / assets fall under populism" and found yes; the follow-up
question - whether firms reallocate INTO assets a populist government
cannot easily seize (a "non-stealable assets" story, originally proxied by
a composite) - did not show up clearly in that composite, either
insignificant or itself falling. This version instead runs the identical
estimation separately for EACH balance-sheet component, on the logic that
if reallocation is happening, it should show up as a rise in at least one
component even if the average/composite effect nets out to nothing:
  ch_at      - cash / total assets (the original outcome, kept as anchor)
  act_at     - current assets / total assets (cash is one component of
               current assets, so this checks whether the current-asset
               bucket as a whole behaves differently than cash alone)
  act_ex_ch_at - current assets EXCLUDING cash / total assets (NEW - splits
               act_at into its cash and non-cash pieces, so a within-
               current-assets reallocation is visible directly rather than
               only inferable by comparing ch_at and act_at separately -
               see 02_clean-compustat.do for an important caveat on how to
               read a rise here: current-assets-ex-cash still includes
               receivables, inventory, and short-term securities, which
               fit the paper's "hiding from expropriation" story much less
               well than intangibles or foreign PP&E would)
  ppent_at   - net property, plant & equipment / total assets
  ivaeq_at   - equity investments & advances / total assets
  ivao_at    - other investments & advances / total assets
  intan_at   - intangible assets / total assets
  ao_at      - other assets / total assets
  invt_at    - inventories / total assets (NEW - a further decomposition
               alongside act_ex_ch_at, isolating inventory specifically
               since it's economically and politically different from
               receivables or short-term securities - see 02_clean-
               compustat.do for the caveat: a rise here is at least as
               consistent with defensive stockpiling or slowing sales as
               with a stealability-driven reallocation)
Every specification below (Baseline, Left/Right populists, continent,
WB-region, European sub-region, democracy status) runs its FULL battery of
tests - joint pre-trend, pooled ATT, robustness/dominant-episode checks,
event-study plot - once per outcome above, all sharing the SAME entropy-
balance weights within a given spec (see ENTROPY-BALANCE TARGET below for
why weights are not re-estimated per outcome).

COMPUSTAT VARIABLE NAMES ASSUMED FOR THE NEW COMPONENTS
The underlying .dta was too large to inspect directly while building this
version of the file, so the new components are assumed to arrive under
Compustat's standard lowercase mnemonics, following the same convention
`ch' and `at' already use in this file:
  act    - Current Assets, Total (ACT)
  ppent  - Property, Plant and Equipment, Net, Total (PPENT)
  ivaeq  - Investment & Advances, Equity (IVAEQ)
  ivao   - Investment & Advances, Other (IVAO)
  intan  - Intangible Assets, Total (INTAN)
  ao     - Assets, Other, Total (AO)
If any of these names don't match the actual file, the fix is entirely
localized to the `outcomevars' construction loop right after each
section's `use' - the variable names are not otherwise threaded through
the file. Compustat's asset decomposition implies
  at (approximately) = act + ppent + ivaeq + ivao + intan + ao
which is worth checking directly against the real data once available -
if there's a large unexplained residual between the sum of the six
components and `at', that changes how confidently "it went here, not
there" can be read across this battery, and is worth flagging in the
paper's data section regardless of what the regressions show.

WHY ch_at, NOT log(ch)  /  WHY EVERY RATIO HERE, NOT A LOG
Raw firm-level financial variables in the underlying Compustat panel are
reported in each firm's own filing currency, uncorrected. Two problems
this created for nominal or CPI-deflated levels, neither of which a
currency-blind inflation adjustment can fix: (1) national currency
redenominations (e.g. Venezuela's VEB->VEF->VES, Argentina's Austral->
Peso, Turkey's 2005 lira reform) produce firm-year-over-firm-year jumps of
100x-1,000,000x with nothing to do with the underlying quantity; (2) a
meaningful share of firms (~5.8% of firm-years in the original cash
analysis, concentrated in DEU/FRA/GBR/ITA/ESP) report in a currency other
than their home country's dominant one in some years. Every ratio-to-
assets outcome in this file cancels both problems the same way ch_at
originally did: numerator and denominator are reported in the same
currency in the same firm-year filing, so a redenomination or off-currency
year multiplies both by the same factor and the ratio is unaffected. No
CPI/inflation adjustment step is needed for any of these outcomes - a
ratio has no nominal/real distinction to correct. All outcomes are used in
levels, not logs - each is a bounded-in-practice ratio, not a skewed level
variable, so coefficients read directly as percentage points of assets.

ENTROPY-BALANCE TARGET: LEVEL LAGS OF ch_at ONLY (NOT RE-ESTIMATED PER
OUTCOME)
Entropy-balance weights within a given specification are estimated ONCE,
targeting ch_at's four pre-treatment level lags (t=-4..-1) only. Those same
weights are then reused for every outcome's regression in that spec. This
is a deliberate choice, not a simplification for convenience: the point of
entropy balancing here is to make treated and control firms look alike on
their PRE-TREATMENT CASH TREND specifically, because that is what the
original identification strategy targets and what the pre-trend tests
check. Re-estimating a fresh set of weights for each of the nine outcomes
(matching each outcome's own pre-trend instead) would mean every outcome
is being tested against a differently-selected control group, making
cross-outcome comparisons ("cash fell but intangibles rose") apples-to-
oranges rather than a read of where the same reweighted sample's assets
moved. NC: polity2 was previously an optional addition to this target
($include_polity toggle, with a numerical-identification guard) - removed
here for code simplification, at the user's request. Note this is
DIFFERENT from polity2 as used in Section 7 ("by democracy status") below,
which uses raw polity2 levels (not lags, not as a balance target) to
define the Fully Democratic / Transitioning samples - that usage is
unrelated to entropy balancing and is unaffected by this simplification.

EVENT-STUDY PLOTS ARE ALWAYS BUILT, PER OUTCOME
Every specification produces one 7-point event-study plot PER OUTCOME
(8 plots per spec, not 1) - there is no toggle to skip this, for the same
reason documented in the prior version: making plot-building unconditional
means every code path gets exercised on every run, rather than the least-
exercised branch silently accumulating bugs. Use $reps to control runtime
instead.

WHAT'S STILL OPTIONAL, AND WHY
The unweighted companion (same regression without entropy-balance weights)
remains OPTIONAL, off by default ($run_unweighted 0) - a sanity check that
weighting isn't driving a result, not a default given how much it multiplies
runtime once run across 8 outcomes.
==============================================================================*/

//------------------------------------------------------------------------------
// SETUP & USER SETTINGS
//------------------------------------------------------------------------------
quietly {
clear all
set more off
set seed 20260705
}

global reps 9999             // wild cluster bootstrap replications. Drop to
                              // ~200-500 for exploratory runs of this file -
                              // with 8 outcomes x 7 sections, runtime scales
                              // roughly 8x versus the single-outcome
                              // version, so this matters more than ever.
                              // Raise back to 9999 for paper output.

global run_unweighted 0      // 1 = also run every outcome's regression
                              // without entropy-balance weights, as a
                              // sanity check that weighting isn't driving
                              // results. 0 = skip (weight diagnostics -
                              // Kish effective N, weight ratio - still
                              // print either way, once per spec, not once
                              // per outcome, since weights don't vary by
                              // outcome - see header).

// NC: target_label/target_suffix are GLOBALS, not locals - a local defined
// here would NOT be visible inside run_subgroup_loop, a separately defined
// program that does not see the caller's locals (this was a real bug in an
// earlier version of this file - a combined-plot filename silently missing
// its suffix - fixed by making both globals). target_suffix no longer
// encodes a polity/no-polity distinction (polity2 removed from the
// entropy-balance target entirely, not toggled) - it's a fixed value now,
// kept as a global/variable rather than hardcoded inline only so every
// filename-building site below doesn't need to change if this ever needs
// to vary again for some other reason.
global target_label  "Level-Lag Ebalance"
global target_suffix "level"

// outcome_choice: pick which outcome(s) to run. This is the main lever for
// the time-savings this file was restructured around - each outcome's
// full battery (pretrend test, pooled ATT, event-study plot, per spec) is
// the expensive part, not the entropy-balance weight estimation, which
// happens once per spec regardless of how many outcomes are selected
// below. Picking one outcome instead of "all" skips the areg/boottest/plot
// work for the other six, which is where most of the per-outcome runtime
// actually is.
//   1 = ch_at        (Cash / Assets - the original outcome)
//   2 = act_at       (Current Assets / Assets)
//   3 = act_ex_ch_at (Current Assets excluding Cash / Assets - NEW, splits
//                     act_at into its cash and non-cash pieces so a
//                     within-current-assets reallocation is visible
//                     directly rather than only inferable by comparing
//                     ch_at and act_at separately - see 02_clean-
//                     compustat.do for the important caveat on how to
//                     read a rise here)
//   4 = ppent_at     (Net PP&E / Assets)
//   5 = ivaeq_at     (Equity Investments / Assets)
//   6 = ivao_at      (Other Investments / Assets)
//   7 = intan_at     (Intangibles / Assets)
//   8 = ao_at        (Other Assets / Assets)
//   9 = invt_at       (Inventories / Assets - NEW, a further decomposition
//                     of current assets alongside act_ex_ch_at: isolates
//                     inventory specifically, since it's economically and
//                     politically different from receivables or short-
//                     term securities - see 02_clean-compustat.do for the
//                     caveat on how to read a rise here, e.g. deliberate
//                     stockpiling vs. slowing sales are both plausible
//                     readings and this outcome doesn't distinguish them)
//   10 = ALL of the above
global outcome_choice 9

// outcomelist: built from $outcome_choice above - the order here (1-10)
// matches the numbering in that comment block exactly, so if the numbering
// above ever changes, this dispatch must change with it. Adding or
// removing an outcome from the battery entirely (not just changing which
// one is selected for a given run) is a three-place change: this dispatch,
// the matching outcomelabel_X global below, and the outcome construction
// in 02_clean-compustat.do (this file no longer builds outcomes itself,
// see build_outcomevars below) - no other section of this file references
// outcome names directly, they all loop over $outcomelist.
if $outcome_choice == 1 {
	global outcomelist "ch_at"
}
else if $outcome_choice == 2 {
	global outcomelist "act_at"
}
else if $outcome_choice == 3 {
	global outcomelist "act_ex_ch_at"
}
else if $outcome_choice == 4 {
	global outcomelist "ppent_at"
}
else if $outcome_choice == 5 {
	global outcomelist "ivaeq_at"
}
else if $outcome_choice == 6 {
	global outcomelist "ivao_at"
}
else if $outcome_choice == 7 {
	global outcomelist "intan_at"
}
else if $outcome_choice == 8 {
	global outcomelist "ao_at"
}
else if $outcome_choice == 9 {
	global outcomelist "invt_at"
}
else if $outcome_choice == 10 {
	global outcomelist "ch_at act_at act_ex_ch_at ppent_at ivaeq_at ivao_at intan_at ao_at invt_at"
}
else {
	di as error "outcome_choice must be 1-10 -- got: $outcome_choice"
	exit 198
}

// $filetag: a short, filename-safe descriptor of which outcome(s) this
// run covers, used by every combined-figure export below (Baseline,
// Excluding, Fully Democratic, Transitioning Arms A/B) that produces ONE
// figure containing all of $outcomelist side by side. NC: FIXED - these
// five exports previously used a fixed filename with no outcome-specific
// component at all (e.g. "wild-baseline-allvars--level.png" every time,
// regardless of $outcome_choice) - correct and harmless when
// outcome_choice was always the "all" setting (one combined run, one
// figure, done), but once single-outcome runs became the normal way to
// use this file, each run's combined figure silently overwrote the
// previous run's, for any of these five files, with no warning. Confirmed
// by the user: after running several single-outcome passes, only the
// continent/WB-region/euro-subregion/left-right plots (which already had
// a per-outcome filename, built inside run_subgroup_loop) survived on
// disk - Baseline, Excluding, Fully Democratic, and both Transitioning
// arms were each down to whichever outcome happened to run last. Set
// here, once, so every combined-figure filename below reflects what's
// actually inside it: "allvars" only for the true full-battery run
// (outcome_choice==10), the single outcome's own name otherwise.
if $outcome_choice == 10 {
	global filetag "allvars"
}
else {
	global filetag "$outcomelist"
}

// outcomelabel_X: human-readable label for outcome X, used in plot titles
// and the Markdown summary. One global per outcome rather than a lookup
// table, since Stata has no native associative array and this is simpler
// to read/edit than simulating one. All nine are always defined,
// regardless of $outcome_choice, since $outcomelabel_<outcome> is looked
// up dynamically inside run_outcome_battery for whichever outcome(s) end
// up in $outcomelist.
global outcomelabel_ch_at       "Cash / Assets"
global outcomelabel_act_at      "Current Assets / Assets"
global outcomelabel_act_ex_ch_at "Current Assets ex. Cash / Assets"
global outcomelabel_ppent_at    "Net PP&E / Assets"
global outcomelabel_ivaeq_at    "Equity Investments / Assets"
global outcomelabel_ivao_at     "Other Investments / Assets"
global outcomelabel_intan_at    "Intangibles / Assets"
global outcomelabel_ao_at       "Other Assets / Assets"
global outcomelabel_invt_at     "Inventories / Assets"

if "`c(username)'" == "jpmvbastos" {
	global path "/Users/jpmvbastos/Documents/GitHub"
}
if "`c(username)'" == "ncachosnky" {
	global path "C:\Users\ncachanosky\OneDrive\Research\GitHub"
}
global datafile "C:\Users\ncachanosky\OneDrive\Research\Working_Papers\paper-JIBS\data\master-stacked-firm.dta"
global plotpath "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/plots"
// NC: FIXED - same bug and same fix as the five combined-figure plot
// exports (see the $filetag note above). $resultslog/$resultsmd were
// built from $target_suffix alone, a fixed string that never varied with
// $outcome_choice - every run, regardless of which outcome(s) it covered,
// wrote to the exact same two files. This was WORSE than the plot bug:
// results_log_init does `capture erase "$resultslog"' then recreates it
// fresh at the start of EVERY run, so each run didn't just overwrite
// overlapping content, it erased the previous run's results entirely
// before writing its own. Fixed the same way as the plots: $filetag
// (already built above for exactly this purpose) is now part of the
// filename, so results-log--ch_at--level.csv, results-log--ppent_at--
// level.csv, results-log--allvars--level.csv, etc. all coexist.
global resultslog "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-log--$filetag--$target_suffix.csv"
global resultsmd  "C:/Users/ncachanosky/OneDrive/Research/Working_Papers/paper-JIBS/output/results-summary--$filetag--$target_suffix.md"

timer clear 99
timer on 99

//------------------------------------------------------------------------------
// RESULTS LOGGING (readable CSV + Markdown output, alongside the console log)
//------------------------------------------------------------------------------
// Same mechanism as the single-outcome version of this file, with one
// addition: every logged row now also records WHICH OUTCOME it's from
// ($LT_outcome), since a given spec now produces up to 8x as many rows.
//
// IMPORTANT: boottest {d0} {d1} {d2} tests THREE INDEPENDENT hypotheses in
// one call, and stores results with suffixes r(p_1)/r(t_1)/r(CI_1) for the
// first, r(p_2)/... for the second, etc. (unsuffixed r(p)/r(t)/r(CI) are
// populated only when a SINGLE hypothesis is tested). log_test's
// `hypindex' argument controls which - pass "" for a single-hypothesis
// call (e.g. boottest {post}), or 1/2/3 for a multi-hypothesis call.
capture program drop log_test
program define log_test
	args nclusters hypindex
	if "`hypindex'" == "" {
		local pval = r(p)
		local tstat = r(t)
	}
	else {
		local pval = r(p_`hypindex')
		local tstat = r(t_`hypindex')
	}
	local ci_lo = .
	local ci_hi = .
	if "`hypindex'" == "" {
		capture matrix ci_tmp = r(CI)
	}
	else {
		capture matrix ci_tmp = r(CI_`hypindex')
	}
	if _rc == 0 {
		local ci_lo = ci_tmp[1,1]
		local ci_hi = ci_tmp[rowsof(ci_tmp), colsof(ci_tmp)]
	}
	local coef = .
	if "$LT_dummyname" != "" {
		capture local coef = _b[$LT_dummyname]
	}
	// file write's native (exp) argument syntax evaluates the expression
	// and writes the result directly - (char(34)) writes one literal
	// double-quote character. `=char(34)' (macro extended-function
	// substitution) is a DIFFERENT mechanism and is NOT the right tool
	// here - see prior version's fix-history comments if this ever
	// regresses.
	file open reslog using "$resultslog", write append
	file write reslog (char(34)) "$LT_outcome" (char(34)) "," ///
		(char(34)) "$LT_spec" (char(34)) "," ///
		(char(34)) "$LT_testtype" (char(34)) "," ///
		(char(34)) "$LT_nullhyp" (char(34)) "," ///
		%9.0g (`coef') "," %9.4f (`tstat') "," %9.4f (`pval') "," ///
		%9.0g (`ci_lo') "," %9.0g (`ci_hi') "," (`nclusters') "," ///
		"$target_suffix" "," "$reps" _n
	file close reslog
end

// results_log_init: (re)creates $resultslog with a header row. Call once,
// at the very top of the do-file, before any spec runs.
capture program drop results_log_init
program define results_log_init
	capture erase "$resultslog"
	file open reslog using "$resultslog", write replace
	file write reslog "outcome,spec,test_type,null_hypothesis,coefficient,t_stat,p_value,ci_low,ci_high,n_clusters,ebal_target,reps" _n
	file close reslog
end

// winsorize_var: caps a named variable at its own 1st/99th percentile IN
// THE CURRENT WORKING SAMPLE. Called once per outcome, right after each
// section's `use', so a regional subsample winsorizes each outcome against
// its own distribution rather than inheriting cutpoints from the full
// worldwide panel or from a different outcome's tails.
capture program drop winsorize_var
program define winsorize_var
	args varname
	qui centile `varname', centile(1 99)
	local p1 = r(c_1)
	local p99 = r(c_2)
	qui replace `varname' = `p1'  if `varname' < `p1'  & !missing(`varname')
	qui replace `varname' = `p99' if `varname' > `p99' & !missing(`varname')
end

// build_outcomevars: as of the upstream fix to 02_clean-compustat.do, all
// nine $outcomelist ratios (ch_at, act_at, act_ex_ch_at, ppent_at,
// ivaeq_at, ivao_at, intan_at, ao_at, invt_at) are built ONCE upstream, at
// the same point and by the same logic, and should already be present as
// columns in master-stacked-firm.dta by the time this program runs. This
// program's job is now just to winsorize whichever ones are in
// $outcomelist - construction is no longer its primary job.
//
// NC: history worth keeping in mind if this ever needs revisiting - an
// earlier version of this program unconditionally rebuilt all seven (at
// the time) ratios from raw components (ch/at, act/at, etc.) every time
// it ran, on the assumption the source .dta never had them. That
// assumption was wrong: master-stacked-firm.dta already carried ch_at
// (built far upstream), so the unconditional `gen ch_at = ...' collided
// with r(110) "variable already defined" the moment a run actually
// exercised that code path. The fix belongs upstream (02_clean-
// compustat.do now builds every outcome consistently, not just ch_at),
// not here - patching this program to defensively drop-and-regen was
// treating the symptom one outcome at a time as each got selected, not
// the actual cause.
//
// The capture-confirm/fallback-gen block below is a SAFETY NET, not the
// primary path: it only fires for an outcome that's missing entirely
// (e.g. someone runs this file against an older master-stacked-firm.dta,
// built before the upstream fix). If the upstream fix is in place, this
// block does nothing on every outcome and the whole program is just the
// winsorize loop at the bottom.
capture program drop build_outcomevars
program define build_outcomevars
	quietly {
	capture confirm variable ch_at
	if _rc != 0 & strpos(" $outcomelist ", " ch_at ") {
		di as error "build_outcomevars: ch_at not found in source data - building from ch/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ch_at     = ch     / at if at > 0
	}
	capture confirm variable act_at
	if _rc != 0 & strpos(" $outcomelist ", " act_at ") {
		di as error "build_outcomevars: act_at not found in source data - building from act/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen act_at    = act    / at if at > 0
	}
	capture confirm variable act_ex_ch_at
	if _rc != 0 & strpos(" $outcomelist ", " act_ex_ch_at ") {
		di as error "build_outcomevars: act_ex_ch_at not found in source data - building from (act-ch)/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen act_ex_ch_at = (act - ch) / at if at > 0
	}
	capture confirm variable ppent_at
	if _rc != 0 & strpos(" $outcomelist ", " ppent_at ") {
		di as error "build_outcomevars: ppent_at not found in source data - building from ppent/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ppent_at  = ppent  / at if at > 0
	}
	capture confirm variable ivaeq_at
	if _rc != 0 & strpos(" $outcomelist ", " ivaeq_at ") {
		di as error "build_outcomevars: ivaeq_at not found in source data - building from ivaeq/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ivaeq_at  = ivaeq  / at if at > 0
	}
	capture confirm variable ivao_at
	if _rc != 0 & strpos(" $outcomelist ", " ivao_at ") {
		di as error "build_outcomevars: ivao_at not found in source data - building from ivao/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ivao_at   = ivao   / at if at > 0
	}
	capture confirm variable intan_at
	if _rc != 0 & strpos(" $outcomelist ", " intan_at ") {
		di as error "build_outcomevars: intan_at not found in source data - building from intan/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen intan_at  = intan  / at if at > 0
	}
	capture confirm variable ao_at
	if _rc != 0 & strpos(" $outcomelist ", " ao_at ") {
		di as error "build_outcomevars: ao_at not found in source data - building from ao/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen ao_at     = ao     / at if at > 0
	}
	capture confirm variable invt_at
	if _rc != 0 & strpos(" $outcomelist ", " invt_at ") {
		di as error "build_outcomevars: invt_at not found in source data - building from invt/at as a fallback. Re-run 02_clean-compustat.do to build it upstream instead."
		gen invt_at   = invt   / at if at > 0
	}
	}
	foreach v of global outcomelist {
		winsorize_var `v'
	}
end

// pick_balancevars: sets `balancevars' (via c_local, so it's visible in the
// CALLER's scope) to ch_at's four level lags. This ALWAYS targets ch_at
// specifically (never any other outcome) - see header for why entropy-
// balance weights are estimated once per spec, on ch_at's pre-trend, and
// then reused for every outcome's regression. NC: this program used to
// also conditionally add polity2's level lags to the target
// ($include_polity toggle + a numerical-identification guard); removed
// for code simplification at the user's request - see header for the
// distinction between this removed usage and polity2's continued,
// unrelated use in Section 7's democracy-status sample construction.
// `label'/`ifcond' are no longer used inside this program but are kept in
// the call signature unchanged, so no call site below needs to change.
capture program drop pick_balancevars
program define pick_balancevars
	args label ifcond
	c_local balancevars "ch_at_l1 ch_at_l2 ch_at_l3 ch_at_l4"
end

// run_outcome_battery: the core new piece of this version of the file.
// Given an outcome variable name, a spec label, cluster/firm counts, and
// an already-estimated ebal weight variable IN MEMORY, runs that outcome's
// full test suite for the CURRENT WORKING SAMPLE - joint pre-trend test,
// pooled ATT, optional unweighted companion, and a 7-point event-study
// plot - exactly the block that used to be hand-written once per section
// for ch_at alone. Called once per outcome, inside every section below,
// so a section that used to contain ~150 lines of ch_at-specific code now
// contains one `foreach outcome of global outcomelist { run_outcome_battery ... }'
// loop instead.
//   outcomevar   : which outcome to regress (e.g. "ch_at", "intan_at")
//   spec         : spec label for logging/diagnostics (e.g. "Baseline")
//   ifcond       : sample restriction beyond rel_year/relative_year that
//                  must ALSO be true for a row to enter the dN dummies and
//                  the areg/boottest calls (e.g. "treat==0 | lpop==1" for
//                  Left populists, "treat==1" for a plain single-arm spec)
//   treatedcond  : the condition that defines "this row is the treated
//                  arm at this relative year" - e.g. "treat==1" for a
//                  plain single-arm spec, "lpop==1" for Left populists,
//                  "groupA==1" for Transitioning Arm A. Used to gate the
//                  dN dummy construction, so control-arm rows never get
//                  counted as treated at some relative year.
//   samplecond   : the estimation-sample restriction for areg/boottest -
//                  e.g. "treat==0 | lpop==1" for Left populists (control
//                  pool plus Left-populist-treated firms only, excluding
//                  Right-populist-treated firms from that regression). For
//                  a spec where the working sample in memory is ALREADY
//                  restricted to exactly the right rows (e.g. inside
//                  run_subgroup_loop, or plain Baseline/Excluding/Fully-
//                  Democratic where treat==0 or treat==1 covers everyone
//                  in memory), pass "" - no additional restriction needed.
//   ncl / nt / nc: cluster count / treated firm count / control firm count,
//                  already computed by the caller (these don't vary by
//                  outcome, only the regression coefficients do)
//   plotname     : Stata graph name for this outcome's plot (must be
//                  globally unique across the whole do-file run)
//   plottitle    : subtitle text for the plot (spec label; the outcome's
//                  own label from $outcomelabel_<outcomevar> is appended
//                  automatically)
//   testtypeprefix : optional prefix added to the logged test_type (e.g.
//                  "robustness" produces "robustness_pretrend" /
//                  "robustness_att" instead of plain "pretrend"/"att") -
//                  pass "" for a normal main-spec call; robustness_excl
//                  passes "robustness" so its rows are distinguishable in
//                  $resultslog/$resultsmd from the main battery's rows
//   panelgphpath : if non-empty, saves the panel plot to this exact
//                  filepath as a .gph file, in addition to building it as
//                  an in-memory named graph. MUST be a real filepath the
//                  CALLER already holds (e.g. via its own `tempfile' local
//                  declared before calling this program) - do NOT declare
//                  a tempfile inside this program for this purpose, since
//                  a tempfile's underlying file is automatically erased
//                  the moment the program that declared it returns, which
//                  would make the saved file already gone by the time a
//                  caller tries to use it afterward. Pass "" to skip
//                  saving (the normal case for callers that combine
//                  straight from in-memory graph names and have never hit
//                  the graph-combine crash this parameter exists to work
//                  around - see the FIXED comment inside this program).
capture program drop run_outcome_battery
program define run_outcome_battery
	args outcomevar spec treatedcond samplecond ncl nt nc plotname plottitle testtypeprefix panelgphpath

	local outcomelabel "${outcomelabel_`outcomevar'}"
	local ttprefix ""
	if `"`testtypeprefix'"' != "" {
		local ttprefix "`testtypeprefix'_"
	}

	local sampleclause ""
	if `"`samplecond'"' != "" {
		local sampleclause "if `samplecond'"
	}

	// NC: FIXED - an earlier version of this program used ONE `ifcond'
	// argument for both the dummy-gating condition AND the estimation-
	// sample restriction. Those are genuinely different things: the
	// sample restriction (e.g. "treat==0 | lpop==1") is a tautology like
	// "treat==1 | treat==0" for a plain single-arm spec, which is TRUE for
	// every row including control firms - using that same condition to
	// gate "is this row treated at this relative year" would have set
	// d0..d7 to 1 for control firms too, corrupting every single-arm
	// section's dummies. Caught before this was ever run, by re-reading
	// this program against exactly what the single-outcome predecessor's
	// dummy lines did (treat==1 & rel_year==`r', not just rel_year==`r').
	// Fixed by splitting into `treatedcond' (gates the dummy) and
	// `samplecond' (restricts the areg/boottest sample) as two separate
	// arguments.
	qui forvalues r = 0/7 {
		cap drop d`r'
		if `r' != 3 gen byte d`r' = (`treatedcond' & rel_year == `r')
	}

	qui areg `outcomevar' d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal] `sampleclause', absorb(firm_id) cluster(iso)
	di as result "`spec' (`outcomevar'): joint pre-trend test"
	boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
	global LT_outcome "`outcomevar'"
	global LT_spec "`spec'"
	global LT_testtype "`ttprefix'pretrend"
	global LT_nullhyp "no differential pre-trend at t=-4 (H0: coefficient on d0 = 0)"
	global LT_dummyname "d0"
	log_test `ncl' 1
	global LT_nullhyp "no differential pre-trend at t=-3 (H0: coefficient on d1 = 0)"
	global LT_dummyname "d1"
	log_test `ncl' 2
	global LT_nullhyp "no differential pre-trend at t=-2 (H0: coefficient on d2 = 0)"
	global LT_dummyname "d2"
	log_test `ncl' 3

	qui cap drop post
	qui gen byte post = (`treatedcond' & rel_year >= 4)
	qui areg `outcomevar' d0 d1 d2 post i.cy [aweight=ebal] `sampleclause', absorb(firm_id) cluster(iso)
	di as result "`spec' (`outcomevar'): pooled post-treatment ATT"
	boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	global LT_testtype "`ttprefix'att"
	global LT_nullhyp "no average treatment effect in periods 0-3 (H0: coefficient on post = 0)"
	global LT_dummyname "post"
	log_test `ncl' ""

	if $run_unweighted {
		qui areg `outcomevar' d0 d1 d2 d4 d5 d6 d7 i.cy `sampleclause', absorb(firm_id) cluster(iso)
		di as result "`spec' (`outcomevar'): unweighted joint pre-trend test"
		boottest {d0} {d1} {d2}, weighttype(webb) nograph reps($reps) level(90)
		qui areg `outcomevar' d0 d1 d2 post i.cy `sampleclause', absorb(firm_id) cluster(iso)
		di as result "`spec' (`outcomevar'): unweighted pooled post-treatment ATT"
		boottest {post}, weighttype(webb) nograph reps($reps) level(90)
	}

	local notearg `""`nt' treated and `nc' control firms" "Wild cluster bootstrap standard errors adjusted for `ncl' clusters.""'

	// re-estimate the full d0-d7 model right before pulling per-dummy
	// coefficients for the plot - the pooled-ATT areg just above replaces
	// d4-d7 with a single `post' dummy, so the last-estimated model at
	// this point does NOT contain d4/d5/d6/d7, and _b[d4] etc. would
	// error "not found" (or silently pull from the wrong model) without
	// this re-estimation.
	qui areg `outcomevar' d0 d1 d2 d4 d5 d6 d7 i.cy [aweight=ebal] `sampleclause', absorb(firm_id) cluster(iso)
	tempname pf
	tempfile res
	qui postfile `pf' double xpos double b double lo double hi byte phase using "`res'", replace
	qui foreach r of numlist 0 1 2 4 5 6 7 {
		local b = _b[d`r']
		qui boottest d`r', weighttype(webb) reps($reps) level(90) nograph
		matrix ci = r(CI)
		local phase = (`r' >= 4)
		post `pf' (`r' + 1) (`b') (ci[1,1]) (ci[rowsof(ci),colsof(ci)]) (`phase')
	}
	qui postclose `pf'
	// NC: FIXED - this used to be `preserve' / `restore' around the
	// plot-data swap below, but run_outcome_battery is called from
	// INSIDE an already-open `preserve' whenever the caller is
	// run_subgroup_loop or robustness_excl (both open their own
	// `preserve' before calling this program, and don't `restore' until
	// well after it returns). Stata does not allow nested preserve - this
	// is the SAME failure mode already fixed once before in this file's
	// history (the Transitioning-sample section, in an earlier version),
	// just not caught here because it doesn't throw its documented error
	// (r(621) "already preserved") immediately - instead it silently
	// succeeds on the surface but appears to corrupt Stata's internal
	// bookkeeping in a way that only breaks later, specifically inside
	// graph combine's own internal machinery once enough plot objects
	// have been built this way (confirmed by set trace: the crash traced
	// to Stata's own combinegraph_g class, not to any Stata-language line
	// in this file, and only ever happens on calls into this program from
	// run_subgroup_loop - Baseline/Excluding/Left/Right, which call this
	// program with no outer preserve open, never hit it). Fixed the same
	// way as the earlier Transitioning-section case: a manual tempfile
	// save/reload instead of preserve/restore, so this program never
	// touches Stata's preserve stack at all.
	tempfile outcomedata_snapshot
	qui save "`outcomedata_snapshot'"
	qui use "`res'", clear
	quietly {
	twoway (rcap hi lo xpos if phase==0, lcolor(midblue)) ///
	       (scatter b xpos if phase==0, mcolor(midblue) msymbol(O)) ///
	       (rcap hi lo xpos if phase==1, lcolor(cranberry)) ///
	       (scatter b xpos if phase==1, mcolor(cranberry) msymbol(O)) ///
	       (scatteri 0 4, mcolor(navy) msymbol(O) msize(medsmall)), ///
		yline(0, lcolor(black)) xline(4.5, lcolor(gs8) lpattern(dash)) ///
		ytitle("`outcomelabel'", size(small)) ///
		xtitle("Periods Since Populist Leader", size(small)) ///
		xlabel(1 "-4" 2 "-3" 3 "-2" 4 "-1" 5 "0" 6 "1" 7 "2" 8 "3") ///
		xscale(range(0.5 8.5)) legend(off) ///
		subtitle("`plottitle': `outcomelabel'", justification(center) size(small)) ///
		note(`notearg', justification(left) size(vsmall)) ///
		name(`plotname', replace) nodraw
	}
	// NC: CHANGED APPROACH (2026-07-11, second attempt at this bug) - the
	// nested-preserve fix above (manual tempfile snapshot instead of
	// preserve/restore) did NOT resolve the r(199) crash inside Stata's
	// graph-combining internals; the exact same failure recurred at the
	// exact same call site on the next run. Rather than keep guessing at
	// Stata's internal graph-memory mechanics for a third time, this
	// switches to a fundamentally different, more robust handoff: instead
	// of keeping named graph objects alive in memory across the many
	// preserve/restore and dataset-swap operations this file does (the
	// one thing genuinely unique to run_subgroup_loop's callers vs. the
	// specs that never hit this bug), each panel is saved to its own .gph
	// FILE ON DISK right here, immediately after it's built. A saved .gph
	// file is self-contained and independent of Stata's in-memory dataset
	// state, sidestepping the problem regardless of the exact mechanism.
	// `panelgphpath' is the full path to save to - it must be supplied by
	// the CALLER (not declared as a `tempfile' inside this program): a
	// tempfile's underlying file is automatically erased the moment the
	// program that declared it returns, so a tempfile declared HERE would
	// already be gone by the time run_subgroup_loop tries to combine from
	// it afterward. Passing "" skips saving (used by callers - Baseline,
	// Excluding, Left/Right - that still combine from in-memory graph
	// names directly and have never hit this bug).
	if `"`panelgphpath'"' != "" {
		qui graph save `plotname' "`panelgphpath'", replace
	}
	qui use "`outcomedata_snapshot'", clear
end

// robustness_excl: reruns EVERY outcome's joint pre-trend test and pooled
// ATT after dropping one country's treated firms, to check whether a
// result is really one dominant country-episode wearing the sub-sample's
// name (e.g. Thailand 2001 is 40-80%+ of the treated mass in several
// specs below). Must be called BEFORE the caller swaps its working
// dataset for a plot-results file, since this needs the full micro-level
// data. Loops $outcomelist internally (unlike the single-outcome
// predecessor, which only ever had one outcome to check).
capture program drop robustness_excl
program define robustness_excl
	args label exclcountry
	di as result "=== `label': leave-`exclcountry'-out robustness check ==="
	cap drop _ebalX ebalX
	qui count if treat==1
	local nt_before = r(N)
	qui drop if treat==1 & country=="`exclcountry'"
	qui count if treat==1
	di as result "`label' (excl. `exclcountry'): treated firms = " r(N) " (was `nt_before')"
	pick_balancevars "`label' (excl. `exclcountry')" "relative_year==0 & treat==1"
	capture noisily ebalance treat `balancevars' if relative_year==0, gen(_ebalX)
	capture confirm variable _ebalX
	if _rc != 0 {
		di as error "`label' (excl. `exclcountry'): ebalance failed to converge"
		exit
	}
	qui egen ebalX = mean(_ebalX), by(firm_id)
	qui distinct iso
	local ncl = r(ndistinct)
	qui distinct firm_id if treat==1
	local nt = r(ndistinct)
	qui distinct firm_id if treat==0
	local nc = r(ndistinct)
	// swap in ebalX as the weight variable run_outcome_battery expects
	// (named `ebal') for the duration of this check only
	cap drop ebal_saved
	qui gen double ebal_saved = ebal
	qui replace ebal = ebalX
	foreach outcome of global outcomelist {
		run_outcome_battery "`outcome'" "`label' (excl. `exclcountry')" "treat==1" "" `ncl' `nt' `nc' ///
			"robX_`outcome'" "`label' (excl. `exclcountry')" "robustness"
	}
	qui replace ebal = ebal_saved
	drop ebal_saved
end

// run_subgroup_loop: the shared engine behind the continent / WB-region /
// European-subregion splits. For each distinct value of `groupvar' in the
// current sample, restricts to that group, builds ch_at/polity2 level
// lags, entropy-balances ONCE (on ch_at's pre-trend - see header), then
// runs the FULL OUTCOME BATTERY (every outcome in $outcomelist) for that
// group via run_outcome_battery, and appends one combined small-multiples
// plot PER OUTCOME at the end (so this produces up to 8 combined plots per
// call, not 1).
//   groupvar     : the variable defining the split (e.g. continent)
//   plot_prefix  : short tag for graph names (e.g. "cont") - must be
//                  unique across calls in the same do-file run
//   title_prefix : text prepended to each panel's subtitle
//   exclpairs    : optional "group1:country1;group2:country2;..." list -
//                  SEMICOLON-separated between pairs (group/country names
//                  can contain spaces). For any group matching group_N,
//                  runs robustness_excl (all outcomes) against country_N
//                  right before that group's plot panels are finalized.
//                  Pass "" for none.
//   export_name  : filename stem (no path/extension/outcome-suffix) for
//                  the combined graphs - actual files are
//                  `export_name'--<outcome>--$target_suffix.png
capture program drop run_subgroup_loop
program define run_subgroup_loop
	args groupvar plot_prefix title_prefix exclpairs export_name

	qui levelsof `groupvar', local(groups)
	qui cap egen cy = group(cohort year)
	// ok_panels_<outcome>: one accumulator local per outcome, since each
	// outcome gets its own combined plot at the end
	foreach outcome of global outcomelist {
		local ok_panels_`outcome' ""
	}

	foreach grp of local groups {
		preserve
		quietly keep if `groupvar' == "`grp'"
		quietly {
		cap drop `v'_l* _ebal ebal
		tsset firm_id relative_year
		foreach v in ch_at {
			bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
			bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
			bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
			bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
		}
		}

		pick_balancevars "`grp'" "relative_year==0 & treat==1"
		capture noisily ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
		capture confirm variable _ebal
		if _rc != 0 {
			di as error "ebalance failed to converge (no _ebal created) for group: `grp'"
			restore
			continue
		}
		quietly egen ebal = mean(_ebal), by(firm_id)

		local tag = subinstr("`grp'", " ", "", .)
		quietly {
		distinct iso
		local ncl = r(ndistinct)
		distinct firm_id if treat==1
		local nt = r(ndistinct)
		distinct firm_id if treat==0
		local nc = r(ndistinct)
		}

		di as result "`grp': treated firms by country/year"
		tab country year if treat==1 & relative_year==0

		// weight-concentration diagnostic - printed ONCE per group (not
		// once per outcome, since weights don't vary by outcome)
		qui count if relative_year==0 & treat==0 & !missing(ebal)
		local ncw = r(N)
		qui sum ebal if relative_year==0 & treat==0 & !missing(ebal), detail
		local wmax = r(max)
		local wmin = r(min)
		qui gen double w2 = ebal^2 if relative_year==0 & treat==0 & !missing(ebal)
		qui sum ebal if relative_year==0 & treat==0 & !missing(ebal)
		local sumw = r(sum)
		qui sum w2 if relative_year==0 & treat==0 & !missing(ebal)
		local sumw2 = r(sum)
		local effN = (`sumw')^2 / `sumw2'
		cap drop w2
		di as result "`grp': control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
		di as result "`grp': Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"

		// NC: FIXED - a local macro name built as panelgph_`tag'_`outcome''
		// (e.g. panelgph_SouthernEurope_ppent_at, 32 characters) exceeded
		// Stata's hard 31-character limit on local macro names the first
		// time a long group name (Southern Europe) combined with a long
		// outcome name (ppent_at/ivaeq_at/ivao_at/intan_at, all 8 chars) -
		// r(198) "invalid name" on that exact macro name is Stata's own
		// diagnostic for this, not a data or estimation problem (the
		// entropy-balance diagnostics printed just before the crash in
        // the log that surfaced this were completely normal - Southern
		// Europe has 67 treated firms and ebalance converged fine).
		// ch_at (5 chars) and act_at (6 chars) never hit this because
		// even the longest group name plus those short outcome names
		// stayed under 31; ppent_at (8 chars) was the first outcome long
		// enough to cross the line with a long enough group name.
		// Fixed by using a short, FIXED-length prefix plus a running
		// counter instead of embedding the actual group/outcome text in
		// the macro name at all - this is now safe regardless of how
		// long any future group or outcome name is, not just a fix for
		// today's specific names.
		local panelctr = 0
		foreach outcome of global outcomelist {
			local panelctr = `panelctr' + 1
			tempfile pgph`panelctr'
			// NC: plotname is ALSO kept short/counter-based here (p`tag_short'`panelctr'),
			// not built from the full group/outcome text - graph names
			// aren't documented with the exact same 31-char limit as
			// local macros, but the same failure mode is plausible and
			// not worth risking for a name that's purely internal
			// bookkeeping (never shown to the reader - plot TITLES,
			// which are what's actually visible on the exported PNG, are
			// built separately via `plottitle'/$outcomelabel_X and are
			// not subject to this constraint at all).
			run_outcome_battery "`outcome'" "`grp'" "treat==1" "" `ncl' `nt' `nc' ///
				"p`plot_prefix'`panelctr'" "`title_prefix' `grp'" "" "`pgph`panelctr''"
			local ok_panels_`outcome' `"`ok_panels_`outcome'' "`pgph`panelctr''""'
		}

		// dominant-episode robustness check (all outcomes), if this group
		// is listed in exclpairs
		if `"`exclpairs'"' != "" {
			local remaining `"`exclpairs'"'
			while `"`remaining'"' != "" {
				local semipos = strpos(`"`remaining'"', ";")
				if `semipos' == 0 {
					local pair `"`remaining'"'
					local remaining ""
				}
				else {
					local pair = substr(`"`remaining'"', 1, `semipos' - 1)
					local remaining = substr(`"`remaining'"', `semipos' + 1, .)
				}
				local colonpos = strpos("`pair'", ":")
				local pairgroup = substr("`pair'", 1, `colonpos' - 1)
				local paircountry = substr("`pair'", `colonpos' + 1, .)
				if "`grp'" == "`pairgroup'" {
					robustness_excl "`grp'" "`paircountry'"
				}
			}
		}
		restore
	}

	foreach outcome of global outcomelist {
		if `"`ok_panels_`outcome''"' != "" {
			// NC: `ok_panels_`outcome'' now holds a space-separated list of
			// QUOTED .gph FILE PATHS (e.g. `"path1" "path2"'), not
			// in-memory graph names - see the FIXED comment inside
			// run_outcome_battery for why. `graph combine "path1"
			// "path2", ...' is Stata's own documented syntax for
			// combining saved graphs from disk (see graph combine's
			// manual entry, "Typical use" section).
			graph combine `ok_panels_`outcome'', xcommon ycommon rows(1)
			graph export "$plotpath/`export_name'--`outcome'--$target_suffix.png", replace
			// harmless no-op safety net now that panels are combined
			// from disk rather than kept as named in-memory graphs -
			// kept in case any combined-graph object itself lingers.
			graph drop _all
		}
	}
end

results_log_init

//------------------------------------------------------------------------------
// 1. Baseline: full worldwide sample
//------------------------------------------------------------------------------
// Every treated firm, every episode, every control firm. Everything else in
// this file is a restriction of, or a split of, this sample. Entropy
// balance is estimated once here (on ch_at's pre-trend); every outcome in
// $outcomelist is then regressed against that same reweighted sample.
use "$datafile", clear
quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
pick_balancevars "Baseline" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Baseline: treated firms by country/year"
tab country year if treat==1 & relative_year==0
preserve
quietly keep if relative_year == 0 & treat == 0 & !missing(ebal)
qui count
local ncw = r(N)
qui sum ebal, detail
local wmax = r(max)
local wmin = r(min)
qui gen double w2 = ebal^2
qui sum ebal
local sumw = r(sum)
qui sum w2
local sumw2 = r(sum)
local effN = (`sumw')^2 / `sumw2'
di as result "Baseline: control ebal weight ratio (max/min) = " %9.1f `wmax'/`wmin'
di as result "Baseline: Kish effective N = " %9.1f `effN' " out of " `ncw' " control firms"
restore

local plotlist1 ""
foreach outcome of global outcomelist {
	run_outcome_battery "`outcome'" "Baseline" "treat==1" "" `ncl' `nt' `nc' "base_`outcome'" "Baseline"
	local plotlist1 "`plotlist1' base_`outcome'"
}
graph combine `plotlist1', xcommon rows(3)
graph export "$plotpath/wild-baseline-$filetag--$target_suffix.png", replace
graph drop _all

//------------------------------------------------------------------------------
// 2. Excluding regions with no treated cases
//------------------------------------------------------------------------------
// Drops Northern/Western Europe, Northern Africa, and Australia/New Zealand
// - none of these regions ever has a populist episode, so keeping them only
// adds control-pool mass without changing identification. Sanity check on
// control-pool composition, not a separate hypothesis - the full battery
// here should look like Baseline's, not different from it.
use "$datafile", clear
qui drop if region == "Northern Europe" | region == "Western Europe" ///
	| region == "Northern Africa" | region == "Australia and New Zealand"
quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
pick_balancevars "Excluding no-treated regions" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Excluding no-treated regions: treated firms by country/year"
tab country year if treat==1 & relative_year==0

local plotlist2 ""
foreach outcome of global outcomelist {
	run_outcome_battery "`outcome'" "Excluding no-treated regions" "treat==1" "" `ncl' `nt' `nc' "excl_`outcome'" "Excluding no-treated regions"
	local plotlist2 "`plotlist2' excl_`outcome'"
}
graph combine `plotlist2', xcommon rows(3)
graph export "$plotpath/wild-excl-notreated-$filetag--$target_suffix.png", replace
graph drop _all

//------------------------------------------------------------------------------
// 3. Left / Right populists
//------------------------------------------------------------------------------
// Same worldwide control pool as Baseline. Splits treated firms by the
// ideology of the populist leader that treated them (lpop/rpop, mutually
// exclusive by construction below). Tests whether the precautionary-cash
// channel and the inflation-risk channel - which theory predicts operate
// differently for left- vs. right-wing populism - actually diverge across
// the whole asset-composition battery, not just cash.
use "$datafile", clear
qui egen tag_left  = total(lpop) if treat==1, by(firm_id)
qui egen tag_right = total(rpop) if treat==1, by(firm_id)
qui replace lpop = 1 if tag_left  > 0 & treat==1 & tag_right==0
qui replace rpop = 1 if tag_right > 0 & treat==1 & tag_left==0
// left un-quieted on purpose - sanity check that lpop/rpop partition the
// treated sample as intended
tab lpop relative_year if treat==0 | lpop==1
tab rpop relative_year if treat==0 | rpop==1
quietly {
build_outcomevars
gen rel_year = relative_year + 4
tsset firm_id relative_year
foreach v in ch_at {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}

// ---- Left populists ----
qui cap drop _ebal ebal
pick_balancevars "Left populists" "relative_year==0 & lpop==1"
qui ebalance lpop `balancevars' if relative_year == 0 & (treat==0 | lpop==1), gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso if treat==0 | lpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if lpop==1
local nt = r(ndistinct)
}
di as result "Left populists: treated firms by country/year"
tab country year if lpop==1 & relative_year==0

local plotlist3l ""
foreach outcome of global outcomelist {
	run_outcome_battery "`outcome'" "Left populists" "lpop==1" "treat==0 | lpop==1" `ncl' `nt' `nc' "left_`outcome'" "Left Populists"
	local plotlist3l "`plotlist3l' left_`outcome'"
}

// ---- Right populists ----
qui cap drop _ebal ebal
pick_balancevars "Right populists" "relative_year==0 & rpop==1"
qui ebalance rpop `balancevars' if relative_year == 0 & (treat==0 | rpop==1), gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso if treat==0 | rpop==1
local ncl = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
distinct firm_id if rpop==1
local nt = r(ndistinct)
}
di as result "Right populists: treated firms by country/year"
tab country year if rpop==1 & relative_year==0

local plotlist3r ""
foreach outcome of global outcomelist {
	run_outcome_battery "`outcome'" "Right populists" "rpop==1" "treat==0 | rpop==1" `ncl' `nt' `nc' "right_`outcome'" "Right Populists"
	local plotlist3r "`plotlist3r' right_`outcome'"
}

// combined plot per outcome: left panel + right panel side by side
foreach outcome of global outcomelist {
	graph combine left_`outcome' right_`outcome', xcommon rows(1)
	graph export "$plotpath/wild-left-right-`outcome'--$target_suffix.png", replace
	graph drop _all
}

//------------------------------------------------------------------------------
// 4. By continent
//------------------------------------------------------------------------------
// Americas, Africa, and Oceania are dropped before the loop, not inside it:
// Americas' pooled ATT was ~97% driven by the single US 2017 episode
// (redundant with the WB High-Income leave-US-out check in section 5);
// Africa has 12 treated firms in one country (South Africa 2009) - a single
// cluster, so WCB CIs are unbounded; Oceania has zero treated firms under
// any configuration. None of the three are identified here regardless of
// outcome, so there's no diagnostic value in running them just to watch
// them fail.
use "$datafile", clear
qui drop if continent == "Africa" | continent == "Americas" | continent == "Oceania"
quietly build_outcomevars
qui gen rel_year = relative_year + 4
run_subgroup_loop continent "cont" "" "Asia:Thailand" "wild-by-continent"

//------------------------------------------------------------------------------
// 5. By World Bank income group
//------------------------------------------------------------------------------
// wb_region collapses to two buckets: High income vs. everything else
// classified Lower/Upper middle income (no Low income countries have a
// populist episode in this sample, so that tier is absent by construction).
use "$datafile", clear
quietly build_outcomevars
qui gen rel_year = relative_year + 4
qui gen _wb_region = ""
qui replace _wb_region = "High Income"   if wb_region == "High income"
qui replace _wb_region = "Middle Income" if wb_region == "Lower middle income" ///
									  | wb_region == "Upper middle income"
run_subgroup_loop _wb_region "wb" "World Bank" "Middle Income:Thailand;High Income:United States" "wild-by-wb-region"

//------------------------------------------------------------------------------
// 6. By European sub-region: Southern vs. Eastern
//------------------------------------------------------------------------------
// Re-checks a divergence first seen under the old log(ch) outcome: Southern
// European firms (Italy, Greece) appeared to raise cash holdings post-
// treatment, Eastern European firms (Poland, Slovakia, Bulgaria, Hungary)
// appeared to lower them. Now checked across the full asset-composition
// battery, not just cash - if this is a genuine reallocation story rather
// than a cash-specific one, it should show up as offsetting signs in a
// non-cash component too. `region' uses the same UN-geoscheme labels used
// elsewhere in this file - "Southern Europe" and "Eastern Europe" are
// exact matches.
use "$datafile", clear
qui keep if inlist(region, "Southern Europe", "Eastern Europe")
quietly build_outcomevars
qui gen rel_year = relative_year + 4
run_subgroup_loop region "euro" "" "" "wild-by-euro-subregion"

//------------------------------------------------------------------------------
// 7. By democracy status
//------------------------------------------------------------------------------
// Two related but distinct samples:
//   (a) Fully Democratic - restricts to firms in countries that stay above
//       the polity2>5 democracy threshold for the entire 8-period window
//       (both treated and control).
//   (b) Transitioning - democratic controls vs. treated firms split into
//       Arm A (stays populist-only, still democratic post-treatment) and
//       Arm B (also exits democracy post-treatment). Of 1,385 treated
//       firms, 1,145 remain democratic all 8 periods; 240 have a
//       democratic pre-period but non-democratic post-period (7 in
//       Ecuador 2007, 233 in the US 2017) - Arm B is small and
//       concentrated in exactly those two episodes.
// NC: the Arm A vs Arm B EQUALITY contrast (does the effect differ between
// arms) is not, on reflection, something that generalizes cleanly to the
// full outcome battery without a lot of added complexity (it would need a
// dA/dB pair of dummy sets PER outcome, i.e. 8x the equality-test code of
// the single-outcome predecessor, for a comparison that was already the
// most exploratory part of that file). Kept the Arm A vs Arm B contrast
// EXACTLY as in the single-outcome predecessor (ch_at only), and added the
// full battery as each arm's OWN pooled ATT against the democratic-control
// pool (i.e. run_outcome_battery for groupA and groupB separately, same
// pattern as every other section) - this answers "does the reallocation
// story look different depending on whether the country stayed democratic
// or not," which is the substantive question, without doubling the most
// complex block in the file for a full battery of two-arm equality tests.
use "$datafile", clear
quietly build_outcomevars
qui gen rel_year = relative_year + 4
qui egen dem_count = total(polity2>5), by(firm_id)
qui gen dem_sample = (dem_count==8)

// ---- (a) Fully Democratic ----
preserve
qui keep if dem_sample==1
quietly {
tsset firm_id relative_year
foreach v in ch_at {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
egen cy = group(cohort year)
}
pick_balancevars "Fully Democratic Sample" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
quietly {
egen ebal = mean(_ebal), by(firm_id)
distinct iso
local ncl = r(ndistinct)
distinct firm_id if treat==1
local nt = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
di as result "Fully Democratic Sample: treated firms by country/year"
tab country year if treat==1 & relative_year==0

local plotlist7a ""
foreach outcome of global outcomelist {
	run_outcome_battery "`outcome'" "Fully Democratic Sample" "treat==1" "" `ncl' `nt' `nc' "dem_`outcome'" "Fully Democratic"
	local plotlist7a "`plotlist7a' dem_`outcome'"
}
graph combine `plotlist7a', xcommon rows(3)
graph export "$plotpath/wild-fullydemocratic-$filetag--$target_suffix.png", replace
graph drop _all
restore

// ---- (b) Transitioning: Arm A (populist-only) vs Arm B (also exits democracy) ----
preserve
qui egen ndem_post = total(polity2<=5 & relative_year>0), by(firm_id)
qui egen dem_pre = total(polity2>5 & relative_year<0), by(firm_id)
qui gen trans_sample = . if treat==1 & relative_year==0
qui replace trans_sample = 1 if dem_sample==1 & treat==0
qui replace trans_sample = 1 if dem_sample==1 & treat==1
qui replace trans_sample = 1 if dem_pre==4 & ndem_post > 0 & treat==1
// left un-quieted on purpose - documents the Arm A/B sample construction
tab trans_sample treat if relative_year==0
tab country year if trans_sample==1 & treat==1 & relative_year==0
qui keep if trans_sample == 1
qui cap egen cy = group(cohort year)
quietly {
tsset firm_id relative_year
foreach v in ch_at {
	bysort firm_id (relative_year): gen `v'_l1 = L1.`v'
	bysort firm_id (relative_year): gen `v'_l2 = L2.`v'
	bysort firm_id (relative_year): gen `v'_l3 = L3.`v'
	bysort firm_id (relative_year): gen `v'_l4 = L4.`v'
}
}
pick_balancevars "Transitioning sample" "relative_year==0 & treat==1"
qui ebalance treat `balancevars' if relative_year == 0, gen(_ebal)
qui egen ebal = mean(_ebal), by(firm_id)

qui gen byte groupA = (treat == 1 & ndem_post == 0)
qui gen byte groupB = (treat == 1 & ndem_post > 0)

// --- ch_at-only Arm A vs Arm B equality contrast, exactly as in the
// single-outcome predecessor ---
qui forvalues k = 0/7 {
	if `k' != 3 {
		cap drop dA`k' dB`k'
		gen byte dA`k' = (groupA == 1 & rel_year == `k')
		gen byte dB`k' = (groupB == 1 & rel_year == `k')
	}
}
qui areg ch_at dA0 dA1 dA2 dA4 dA5 dA6 dA7 dB0 dB1 dB2 dB4 dB5 dB6 dB7 i.cy [aweight=ebal], ///
	absorb(firm_id) cluster(iso)
qui distinct iso
local ncl = r(ndistinct)
di as result "Transitioning sample: Arm A vs Arm B, full profile equality (ch_at only)"
boottest {dA0=dB0} {dA1=dB1} {dA2=dB2} {dA4=dB4} {dA5=dB5} {dA6=dB6} {dA7=dB7}, ///
	weighttype(webb) reps($reps) level(90) nograph
global LT_outcome "ch_at"
global LT_spec "Transitioning sample"
global LT_testtype "arm_equality"
global LT_nullhyp "Arm A (populist-only) and Arm B (also exits democracy) have the same effect at t=-4 (H0: dA0 = dB0)"
global LT_dummyname ""
log_test `ncl' 1
global LT_nullhyp "Arm A and Arm B have the same effect at t=-3 (H0: dA1 = dB1)"
log_test `ncl' 2
global LT_nullhyp "Arm A and Arm B have the same effect at t=-2 (H0: dA2 = dB2)"
log_test `ncl' 3
global LT_nullhyp "Arm A and Arm B have the same effect at t=0 (H0: dA4 = dB4)"
log_test `ncl' 4
global LT_nullhyp "Arm A and Arm B have the same effect at t=1 (H0: dA5 = dB5)"
log_test `ncl' 5
global LT_nullhyp "Arm A and Arm B have the same effect at t=2 (H0: dA6 = dB6)"
log_test `ncl' 6
global LT_nullhyp "Arm A and Arm B have the same effect at t=3 (H0: dA7 = dB7)"
log_test `ncl' 7
di as result "Transitioning sample: Arm A vs Arm B, post-period only (ch_at only)"
boottest {dA4=dB4} {dA5=dB5} {dA6=dB6} {dA7=dB7}, weighttype(webb) reps($reps) level(90) nograph
global LT_testtype "arm_equality_postonly"
global LT_nullhyp "Arm A and Arm B have the same effect at t=0, post-period-only test (H0: dA4 = dB4)"
log_test `ncl' 1
global LT_nullhyp "Arm A and Arm B have the same effect at t=1, post-period-only test (H0: dA5 = dB5)"
log_test `ncl' 2
global LT_nullhyp "Arm A and Arm B have the same effect at t=2, post-period-only test (H0: dA6 = dB6)"
log_test `ncl' 3
global LT_nullhyp "Arm A and Arm B have the same effect at t=3, post-period-only test (H0: dA7 = dB7)"
log_test `ncl' 4

// --- Full outcome battery, each arm separately vs the democratic control
// pool (answers "does the reallocation picture differ if the country also
// exits democracy," without doubling the equality-contrast machinery
// above for all 8 outcomes) ---
quietly {
distinct firm_id if groupA==1
local ntA = r(ndistinct)
distinct firm_id if groupB==1
local ntB = r(ndistinct)
distinct firm_id if treat==0
local nc = r(ndistinct)
}
local plotlistA ""
local plotlistB ""
foreach outcome of global outcomelist {
	run_outcome_battery "`outcome'" "Transitioning: Arm A (populist-only)" "groupA==1" "groupA==1 | treat==0" `ncl' `ntA' `nc' "transA_`outcome'" "Transitioning: Arm A"
	local plotlistA "`plotlistA' transA_`outcome'"
	run_outcome_battery "`outcome'" "Transitioning: Arm B (exits democracy)" "groupB==1" "groupB==1 | treat==0" `ncl' `ntB' `nc' "transB_`outcome'" "Transitioning: Arm B"
	local plotlistB "`plotlistB' transB_`outcome'"
}
graph combine `plotlistA', xcommon rows(3)
graph export "$plotpath/wild-transitioning-armA-$filetag--$target_suffix.png", replace
graph combine `plotlistB', xcommon rows(3)
graph export "$plotpath/wild-transitioning-armB-$filetag--$target_suffix.png", replace
graph drop _all

// dominant-episode check (all outcomes): Thailand is 47% of this spec's
// treated firms
robustness_excl "Transitioning sample" "Thailand"
restore

//------------------------------------------------------------------------------
// Build readable Markdown summary from $resultslog
//------------------------------------------------------------------------------
// Reads $resultslog back in and writes $resultsmd - one top-level section
// per OUTCOME, then one sub-section per spec within that outcome, one row
// per test. Grouping by outcome first (rather than spec first) matches how
// this file is meant to be read: "here's the full cross-spec picture for
// intangibles," not "here's Baseline's results for eight different
// things" - the former is the shape of the actual research question this
// version of the file is answering.
preserve
import delimited "$resultslog", clear varnames(1) case(preserve) stringcols(_all)
destring t_stat p_value coefficient ci_low ci_high n_clusters, replace force

capture file close mdfile
file open mdfile using "$resultsmd", write replace
file write mdfile "# Results summary: $target_label (`c(current_date)')" _n _n
file write mdfile "Wild cluster bootstrap inference (Webb weights, null imposed, " ///
	"`=string($reps)' replications), clustered by country. Entropy-balance " ///
	"weights are estimated ONCE per spec (targeting ch_at's pre-trend) and " ///
	"reused for every outcome below - see the do-file header for why. " ///
	"See the do-file header for full method notes." _n _n
file write mdfile "**How to read this table:** each row is one hypothesis test. " ///
	"'H0' is the null hypothesis being tested - a low p-value (conventionally " ///
	"below 0.10) means the data are unlikely under that null, i.e. evidence " ///
	"AGAINST it. For pre-trend tests, that means evidence of a problem " ///
	"(differential pre-trend). For ATT tests, that means evidence of a " ///
	"treatment effect. Rows starting with 'robustness_' are dominant-episode " ///
	"leave-one-country-out checks, not the main-spec result." _n _n

qui levelsof outcome, local(alloutcomes)
foreach o of local alloutcomes {
	local olabel "${outcomelabel_`o'}"
	file write mdfile "# `o' (`olabel')" _n _n
	qui levelsof spec if outcome == "`o'", local(specsforoutcome)
	foreach s of local specsforoutcome {
		file write mdfile "## `s'" _n _n
		file write mdfile "| Test | Null hypothesis | Coefficient | t-stat | p-value | 90% CI | Clusters |" _n
		file write mdfile "|---|---|---|---|---|---|---|" _n
		forvalues obs = 1/`=_N' {
			if outcome[`obs'] == "`o'" & spec[`obs'] == "`s'" {
				local tt = test_type[`obs']
				local nh = null_hypothesis[`obs']
				local co = coefficient[`obs']
				local ts = t_stat[`obs']
				local pv = p_value[`obs']
				local lo = ci_low[`obs']
				local hi = ci_high[`obs']
				local nc = n_clusters[`obs']
				local sig = ""
				if `pv' < 0.10 & `pv' != . {
					local sig = " **"
				}
				file write mdfile "| `tt' | `nh' | " %6.4f (`co') " | " %6.3f (`ts') " | " %6.4f (`pv') "`sig' | [" %6.4f (`lo') ", " %6.4f (`hi') "] | `nc' |" _n
			}
		}
		file write mdfile _n
	}
}
file write mdfile "*(p < 0.10 flagged with \*\* - a conventional 90% threshold, not a claim of importance; " ///
	"check the actual magnitude and CI, not just significance.)*" _n
file close mdfile
restore

di as result "Wrote results log: $resultslog"
di as result "Wrote results summary: $resultsmd"

//------------------------------------------------------------------------------
// Runtime report
//------------------------------------------------------------------------------
timer off 99
qui timer list 99
local runtime_sec = r(t99)
local runtime_min  = floor(`runtime_sec'/60)
local runtime_rem  = `runtime_sec' - `runtime_min'*60
di as result "=========================================="
di as result "Total do-file run time: " `runtime_min' " min " %4.1f `runtime_rem' " sec"
di as result "Settings: reps=$reps, run_unweighted=$run_unweighted, outcome_choice=$outcome_choice"
di as result "Outcomes: $outcomelist"
di as result "=========================================="
