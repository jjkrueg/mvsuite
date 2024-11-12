/*
String adjustments

*/


********************************************************************************
********************************************************************************

cap qui program drop mvdist
program mvplot, rclass byable(recall)
version 18
    syntax [varlist] [if] [in] [, wv(string) type(string) LABels title(string)]

local nvars : word count `varlist'
// this just counts the number of variables for which we do the missingness analysis

local nvars_weight: word count `wv'
// counts the number of weighting variables

end
