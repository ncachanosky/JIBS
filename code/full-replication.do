/*==============================================================================
Project: JIBS Paper
Authors: J. P. Bastos, Nicolás Cachanosky, John D. Gibson
================================================================================
- Master replication file
==============================================================================*/

//==============================================================================
// SETUP
//==============================================================================

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
// CLEAN DATA
//==============================================================================

// V-Party + Global Leader Ideology Data
do "$path/code/clean-v-party.do"

// Compustat Data
do "$path/code/clean-compustat.do"

// Funke et al. "Populist Leaders and the Economy" AER data
do "$path/code/clean-funke-ple.do"


//==============================================================================
// BUILD MERGED DATASETS
//==============================================================================

// TRADITIONAL PANELS

// V-Party + Compustat Datasets (Firm-Level and Pooled Country Level)
do "$path/code/build-v-party-panels.do"

// Funke et al. PLE + Compustat Datasets (Firm-Level and Pooled Country Level)
do "$path/code/build-funke-ple-panels.do"


// STACKED PANELS
