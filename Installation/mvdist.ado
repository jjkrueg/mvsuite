/*
String adjustments

*/


********************************************************************************
********************************************************************************

cap qui program drop mvdist
program mvdist, rclass byable(recall)
version 18
    syntax [varlist] [if] [in] [, wv(string) GRaph yaxis(string)]

local nvars : word count `varlist'
// this just counts the number of variables for which we do the missingness analysis

local nvars_weight: word count `wv'
// counts the number of weighting variables

local hist_type = "`yaxis'"

	****************************************
	* Error messages and input consistency *
	****************************************
		local nvars_weight: word count `wv'
			if `nvars_weight' > 1 {
				display as error "Too many weight variables specified"
				exit 001
			}
		// Stop the program if there are too many weighting variables
			
		local weight_var = "`wv'"
		qui count if missing(`weight_var')
		local count_wv_miss = r(N)
		if `count_wv_miss' > 0 {
			display as error "`weight_var' contains missing values"
			exit 021
		}
		
		local wvar_type = substr("`: type `wv' '", 1, 3)
		if "`wvar_type'" == "str" {
			display as error "`wv' should be in numeric format"
			exit 003
		}
		// Stop the program if your weighting variable is in string format
		
		foreach var in `varlist' {
			local var_type = substr("`: type `var' '", 1, 3)
			if "`wvar_type'" == "str" {
				display as error "`var' should be in numeric format"
				exit 003		
			}	
		}
		// Stop the program if your variable of interest is in string format
		
		if "`hist_type'" != "percent"  & "`hist_type'" != "den"  & "`hist_type'" != "density"   & ///
		   "`hist_type'" != "fraction" & "`hist_type'" != "frac" & "`hist_type'" != "frequency" & ///
		   "`hist_type'" != "freq"     & "`hist_type'" != "" {
				display as error "unknown y-axis type"
				exit 004
		   }
		// Stop the program if you specified an unknown y-axis type

	**************************************
	* Formatting of STATA console output *
	**************************************
	
	display as text _n "	Variable    Weighting Variable " _column(14)"{c |}     D          P>|D|	"
	display as text  "{hline 35}{c +}{hline 23}"
	
	local c1 36 // Position of separator column for D and P>|D|
			
	****************************************************************************

foreach var of local varlist {
	
	* Display the name of the variable of interest one row offset from the weighting variable
	display as text "  `var'" _column(`c1') "{c |} "
	
	foreach wvar of local wv {
		
		cap qui frame drop distcalc
		frame put `var' `wvar', into(distcalc)
		frame change distcalc
		
		qui gen `wvar'2 = `wvar' if !missing(`var')
		
		qui drop `var'
		gsort `wvar' `wvar2'
		qui gduplicates drop `wvar', force
		
		gen count`wvar' = _n
		
		qui gen kstat`wvar' = count`wvar' / _N
		
		qui count if !missing(`wvar'2)
		local total`wvar'2 = r(N)
		qui gen total`wvar'2 = `total`wvar'2'
		
		cap qui frame drop temp_`wvar'2
		frame put `wvar'2, into(temp_`wvar'2)
		frame change temp_`wvar'2
		
		qui keep if !missing(`wvar'2) 
		qui gen count`wvar'2 = _n
		
		tempfile `wvar'2
		qui save ``wvar'2', replace
		
		frame change distcalc
		
		qui frlink m:1 `wvar'2, frame(temp_`wvar'2) gen(t1)
		
		qui fillmissing t1, with(previous)
		qui replace t1 = 0 if missing(t1)
		
		qui gen kstat`wvar'2 = t1 / total`wvar'2
		
		qui gen diff = abs(kstat`wvar' - kstat`wvar'2)
		
		qui summ diff
		local stat_`var'_`wvar' = r(max)
		return scalar kstat_`var'_`wvar' = `stat_`var'_`wvar''
		
		local total`wvar' = _N
		
		local crit_val = 1.36 * sqrt((`total`wvar'' + `total`wvar'2')/(`total`wvar'' * `total`wvar'2'))
		return scalar critval_`var'_`wvar' = `crit_val'
		

		
		* Calculate p-value
		local ks_stat = `stat_`var'_`wvar''
		local neff = (`total`wvar'' * `total`wvar'2') / (`total`wvar'' + `total`wvar'2')
		local z = sqrt(`neff') * `ks_stat'  // Calculate the value for the approximation of the CDF
		local p_value = 2 * (1 - normal(`z'))  // Calculate p-value approximation
			
		return scalar p_value_`var'_`wvar' = `p_value'
		
		display as text %27s "`wvar'" _column(`c1') "{c |}" ///
				as result %8.3f `return(kstat_`var'_`wvar')' "     " /// 
				as result %8.3f `return(p_value_`var'_`wvar')'
		
		frame change default 
		
		if !missing("`graph'") {
			twoway (hist `wvar', color(navy%40) bins(40) start(0) `hist_type') ///
				   (hist `wvar' if !missing(`var'), color(cranberry%40) bins(40) start(0) `hist_type'), ///
				    nodraw name(`wvar', replace) legend(off) ytitle("")
		}

			   
			   /* legend(pos(6) col(1) ///
			   order(1 "Distribution of `wvar'" 2 "Distribution of `wvar' where `var' is missing") size(small)) /// */
		
	}
	
	if !missing("`graph'") {
		qui graph combine `wv', ///
				title(Variable: `var') ///
				name(`var', replace) nodraw ///
				note("Comparison of distributions of the weighting variable where `var' is either missing or not" ///
					 "Distribution with missing values in blue, without in red - yaxis is type `hist_type'", ///
					 size(tiny) color(gs8))
		}
				   
	}
				   
	if !missing("`graph'") {
		graph combine `varlist', title(Comparison of distributions)
	}

end
