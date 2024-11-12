program mvplotts, rclass byable(recall)
version 18
syntax [varlist] [if] [in] [, wv(string) title(string) GRoups(string)]

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
         
      local grp_vals = r(grp_vals)
         
              ***************
              * Time Series *
              ***************
      
      * Create dataset
      local size = `nvars' * 100
         qui set obs `size'
         
      qui gen var = ""
         qui gen val = .
         qui gen shmiss = .
         qui gen index = _n
         
      foreach wvar of local wv {
                                 
              cap qui gen w`wvar'_shmiss = . 
                                 
      }
         
      local counter = 1
         
      foreach var of local varlist {
                 foreach val of local grp_vals {
                 
                      qui replace var = "`var'"
                         qui replace val = `val' if index == `counter'
                         qui replace shmiss = r(shmiss_`var'_`val') if index == `counter'
                         
                         *foreach wvar of local wv {
                         *       cap qui replace w`wvar'_shmiss =  r(w`wvar'_shmiss_`var'_`val')
                         *}
                         
                         local counter = `counter' + 1
                 }
                 
              if `nvars_weight' == 0 {
                         twoway (line shmiss val, lcolor(navy)), ///
                                 name(`var', replace) nodraw ///
                                 ytitle("Share of missing values in %", size(small)) ///
                                 xtitle("")
                 }
                 else if `nvars_weight' == 1 {
                         twoway (line shmiss val) ///
								(line w`wvar_1'_shmiss val, lpattern(dash)), ///
                                    name(`var', replace) nodraw
                 }
                 else if `nvars_weight' == 2 {
                         twoway (line shmiss val) ///
                                 (line w`wvar_1'_shmiss val, lpattern(dash)) ///
                                 (line w`wvar_2'_shmiss val, lpattern(dot)), ///
								 name(`var', replace) nodraw
                 }
                 else if `nvars_weight' == 3 {
                         twoway (line shmiss val) ///
                                 (line w`wvar_1'_shmiss val, lpattern(dash)) ///
								 (line w`wvar_2'_shmiss val, lpattern(dot)) ///
                                 (line w`wvar_3'_shmiss val, lpattern(dash_dot)), ///
                                 name(`var', replace) nodraw
                 }
                 
         }
 
         graph combine `varlist'
         
         frame change default
         cap frame drop graphing_mvplot
         
end
