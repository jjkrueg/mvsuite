/*
Missingness Analysis Graphs

mvdesc Version 1

Date: 04/11/2024

Jan Jakob Krüger - info@jjkrueger.de

Uses the mvdesc command and offers different types of visualisation for missing 
values in bar and pie charts. 

*/

********************************************************************************
********************************************************************************

cap qui program drop mvplot
program mvplot, rclass byable(recall)
version 18
    syntax [varlist] [if] [in] [, wv(string) type(string) LABels title(string)]

local nvars : word count `varlist'
// this just counts the number of variables for which we do the missingness analysis

local nvars_weight: word count `wv'
// counts the number of weighting variables

	local weight_var = "`wv'"
	
	local wvar_1 = "`=word("`weight_var'", 1)'"
	local wvar_2 = "`=word("`weight_var'", 2)'"
	local wvar_3 = "`=word("`weight_var'", 3)'"


	********************
	* Create the plots *
	********************
	
	cap frame drop graphing_mvplot
	frame create graphing_mvplot
	frame change graphing_mvplot
	
		*************
		* Pie Chart *
		*************
	
	if "`type'" == "pie" {
	
	* Create dataset
	qui set obs 1
	
	foreach var of local varlist {
		
			qui gen w0miss_`var'  = r(miss_`var')
			qui gen w0nmiss_`var' = r(total_`var') - r(miss_`var')
			
			foreach wvar of local wv {
				
				qui gen w`wvar'miss_`var'  = r(w`wvar'_shmiss_`var')
				qui gen w`wvar'nmiss_`var' = 100 - w`wvar'miss_`var'
				
			}	
	}
	
	* Create graphs	
	foreach var of local varlist {
		
			if `nvars_weight' == 0 {
				graph pie w0miss_`var' w0nmiss_`var', ///
				legend(off) ///
				plabel( _all per, for(%9.2f) size(medlarge)) ///
				name(gun, replace) nodraw
			}
			else {
				graph pie w0miss_`var' w0nmiss_`var', ///
				legend(off) title("unweighted", size(medium)) ///
				plabel( _all per, for(%9.2f) size(medlarge)) ///
				name(gun, replace) nodraw
			}
			if `nvars_weight' > 0 {
				foreach wvar of local wv {
						graph pie w`wvar'miss_`var' w`wvar'nmiss_`var', ///
						legend(off) title("weighted by:" "`wvar'", size(medium)) ///
						plabel( _all per, for(%9.2f) size(medlarge)) ///
						name(`wvar', replace) nodraw
					}
			}
			
		if `nvars_weight' == 0 {
			qui graph combine gun, title(`var') name(`var', replace) nodraw
		}
		else if `nvars_weight' != 0 {
			qui graph combine gun `wv', title(`var') name(`var', replace) nodraw  rows(1)
		}
	}
	
	if `nvars' <= 5 & `nvars_weight' == 0 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(1) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))	
	} 
	else if `nvars' > 5 & `nvars_weight' == 0 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(2) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' <= 2 & `nvars_weight' == 1 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(1) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' >= 3 & `nvars' < 5 & `nvars_weight' == 1 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(2) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' >= 5 & `nvars' < 10 & `nvars_weight' == 1 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(3) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' < 2 & `nvars_weight' == 2 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(1) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' > 1 & `nvars' < 5 & `nvars_weight' == 2 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(2) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' > 4 & `nvars_weight' == 2 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(3) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' < 2 & `nvars_weight' == 3 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(1) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' > 1 & `nvars' < 5 & `nvars_weight' == 3 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(2) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}
	else if `nvars' > 4 & `nvars_weight' == 3 {
		graph combine `varlist', ///
		title("Share of Missing values") rows(3) ///
		note("Note: blue sections indicate missing values", size(small) color(gs8))			
	}

	} 
	
		*************
		* Bar Chart *
		*************
	
	else {
		
	* Create dataset
	qui set obs `nvars'
	
	qui gen name    = ""
	qui gen wvar	= ""
	qui gen miss    = .
	qui gen nmiss   = .

	qui gen index = _n
	local counter = 1
	
	foreach var of local varlist {
	
			qui replace name    = "`var'" if index == `counter'
			qui replace miss    = r(miss_`var') if index == `counter'
			qui replace nmiss   = r(total_`var') - r(miss_`var') if index == `counter'
			
		local counter = `counter' + 1
		
	}
	
	qui tempfile unweighted 
	qui save `unweighted', replace
	
	
	if `nvars_weight' != 0 {
		
		cap frame drop weights
		frame create weights
		frame change weights
		
		qui set obs 1000
		
		local counter = 1
		qui gen name = ""
		qui gen wvar = ""
		qui gen miss = .
		qui gen index = _n
		
		foreach var of local varlist {
			foreach wvar of local wv {
	
				qui replace name = "`var'"  if index == `counter'
				qui replace wvar = "`wvar'" if index == `counter'
				local val = r(w`wvar'_shmiss_`var')
				qui replace miss = `val' if index == `counter'
				
				local counter = `counter' + 1
				
			}
	
		}
		
		qui gen nmiss = 100 - miss
		qui drop index
		qui drop if missing(miss)
		append using `unweighted'
		qui replace wvar = "unweighted" if missing(wvar)
		qui drop index
		
	}
	
	
	* Create graphs
	if `nvars_weight' == 0 {
		
		use `unweighted', clear
		
		if !missing("`labels'") {
			graph bar (sum) miss nmiss, over(name) stack percentages ///
					note("Missing values in blue", size(vsmall) color(gs8)) ///
					ytitle("") legend(off) ylabel(0(10)100) ///
					ytitle("Share of Missing Values (in %)") ///
					blabel(bar, position(base) format(%8.2f) size(vsmall))
		}
		if missing("`labels'") {
			graph bar (sum) miss nmiss, over(name) stack percentages ///
					note("Missing values in blue", size(vsmall) color(gs8)) ///
					ytitle("") legend(off) ylabel(0(10)100) ///
					ytitle("Share of Missing Values (in %)")
		}

	} 
	else {
		if !missing("`labels'") {
			graph bar (sum) miss nmiss, over(wvar, label(labsize(vsmall) angle(30))) ///
					over(name) stack percentages ///
					note("Missing values in blue", size(vsmall) color(gs8)) ///
					ytitle("") legend(off) ytitle("Share of Missing Values (in %)") /// 
					blabel(bar, position(base) format(%8.2f) size(vsmall)) ///
					ylabel(0(10)100) 
		}
		if missing("`labels'") {
			graph bar (sum) miss nmiss, over(wvar, label(labsize(vsmall) angle(30))) ///
					over(name) stack percentages ///
					note("Missing values in blue", size(vsmall) color(gs8)) ///
					ytitle("") legend(off) ytitle("Share of Missing Values (in %)") /// 
					ylabel(0(10)100) 
		}
					
		}
		
	}
	
	frame change default
	
end






