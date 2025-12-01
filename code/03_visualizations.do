/********************************************************************************
Project: JIBS Paper
File: 03_visualizations.do
Authors: Joao P. Bastos, Nicolás Cachanosky, John D. Gibson
Email: ncachanosky@utep.edu
Institution: The University of Texas at El Paso
Created: 26-Nov-2025
Last Modified: 28-Nov-2025

Description:
    Create plots

Usage:
    do 03_visualizations.do
    
Outline:
    - 1. Setup and configuration
    - 2. Load data and create variables
    - 3. Descriptive statistics
    - 4. Main regressions (contemporaneous)
    - 5. Robustness checks
    - 6. Institutional moderators
    - 7. Lagged specifications
    - 8. Export results
    
Dependencies:
    - 01_data_builder.do (must be run first)
    - estout package (for table export)
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

use "$data_proc/data", clear


* ==============================================================================
* 2. PLOT SETTINGS
* ==============================================================================

* ------------------------------------------------------------------------------
* 2.1 General scheme and style
* ------------------------------------------------------------------------------
set scheme s1color                    // Clean, minimal base scheme
graph set window fontface "Arial"     // Professional font

* ------------------------------------------------------------------------------
* 2.2 Color palette (colorblind-friendly)
* ------------------------------------------------------------------------------
* Main colors for categorical data (Tableau 10 palette)
global color1 "31 119 180"      // Blue
global color2 "255 127 14"      // Orange
global color3 "44 160 44"       // Green
global color4 "214 39 40"       // Red
global color5 "148 103 189"     // Purple
global color6 "140 86 75"       // Brown
global color7 "227 119 194"     // Pink
global color8 "127 127 127"     // Gray
global color9 "188 189 34"      // Yellow-green
global color10 "23 190 207"     // Cyan

* Grayscale palette (for alternatives)
global gray1 "0 0 0"           // Black
global gray2 "64 64 64"        // Dark gray
global gray3 "128 128 128"     // Medium gray
global gray4 "192 192 192"     // Light gray
global gray5 "224 224 224"     // Very light gray

* Sequential palette (for heat maps or gradients)
global seq1 "255 255 204"      // Light yellow
global seq2 "161 218 180"      // Light green
global seq3 "65 182 196"       // Cyan
global seq4 "44 127 184"       // Blue
global seq5 "37 52 148"        // Dark blue

* ------------------------------------------------------------------------------
* 2.3 Export settings
* ------------------------------------------------------------------------------
global graph_width  3000           // Width in pixels (high resolution)
global graph_height 2400           // Height in pixels (4:3 aspect ratio)
global graph_format "png"          // Format: png, eps, or pdf
global graph_dpi    300            // DPI for publication quality

* Alternative for vector graphics (uncomment if needed)
* global graph_format "eps"
* global graph_replace "replace"

* ------------------------------------------------------------------------------
* 2.4 Common plotting options
* ------------------------------------------------------------------------------

* For scatter plots
global scatter_opts "msymbol(O) msize(medium)"

* For line plots
global line_opts "lwidth(medium)"

* For confidence intervals
global ci_opts "lcolor(gs10) lpattern(dash)"

* For axis labels
global axis_opts "labsize(medium) angle(0)"

* For titles and labels
global title_opts "size(medlarge) color(black)"
global subtitle_opts "size(medium) color(gs4)"
global note_opts "size(small) color(gs6)"

* Clean background
global background_opts "graphregion(color(white)) plotregion(color(white))"

* Standard text annotation settings
global text_opts "size(medium) color(black)"
global text_small "size(small) color(black)"
global text_large "size(medlarge) color(black)"

* ------------------------------------------------------------------------------
* 2.5 Complete template for quick use
* ------------------------------------------------------------------------------
* Combine all settings into one global for easy application
global plot_standard "$background_opts $legend_opts ylabel(, $axis_opts) xlabel(, $axis_opts)"

* ------------------------------------------------------------------------------
* 2.6 Helper program for consistent exports
* ------------------------------------------------------------------------------
capture program drop save_graph
program define save_graph
    syntax anything, name(string)
    graph export "$figures/`name'.$graph_format", ///
        width($graph_width) height($graph_height) replace
    display as result "Graph saved: $figures/`name'.$graph_format"
end

* ------------------------------------------------------------------------------
* 2.7 Example usage template (commented out)
* ------------------------------------------------------------------------------
/*
twoway (scatter y x, mcolor("$color1") $scatter_opts) ///
       (lfit y x, lcolor("$color2") $line_opts), ///
       $plot_standard ///
       title("Your Title", $title_opts) ///
       ytitle("Y-axis Label", $title_opts) ///
       xtitle("X-axis Label", $title_opts) ///
       legend(label(1 "Series 1") label(2 "Series 2"), $legend_opts) ///
       note("Notes: Your note here", $note_opts)
       
save_graph, name("descriptive_plot1")
*/


* ==============================================================================
* 3. SCATTTER: Z-SCORES
* ==============================================================================

twoway scatter PEP_z PIP_z, $scatter_opts mcolor("$color1") msize(vsmall) ///
    || scatter PEP_z PIP_z if ISO3 == "VEN", mcolor("$color2") msize(vsmall) ///
	   title("Economic and Institutional populism, z-Scores") ///
	   ytitle("Economic populism") ///
	   xtitle("Institutional populism") ///
	   note("Source: Latin American Left-Leaning Populism Index") ///
	   ylabel(-4(1)4, angle(0)) ///
	   xlabel(-4(1)4) ///
	   yline(0, lcolor(gs8) lwidth(thin)) ///
	   xline(0, lcolor(gs8) lwidth(thin)) ///
	   text( 3.5  3.8 "Full populism"          "n = 152", /// 
	        size(small) place(l) justification(right))    ///
	   text(-3.5  3.8 "Institutional populism" "n = 31" , ///
	        size(small) place(l) justification(right))    /// 
	   text( 3.5 -3.8 "Economic populism"      "n = 37" , ///
	        size(small) place(r) justification(left))     ///
	   text(-3.5 -3.8 "Control group"          "n = 148", ///
	        size(small) place(r) justification(left))     ///
	   legend(label (1 "Full sample") ///
	          label (2 "Venezuela")   ///
			  region(lcolor(none)))