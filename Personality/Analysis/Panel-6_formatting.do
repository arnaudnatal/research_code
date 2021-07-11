cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
July 06, 2021
-----
Formatting margins
-----
help fvvarlist
-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme plotplain
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"



********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v16"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END




*dy/dx
*margins, dydx() at(dalits=(0 1) female=(0 1)) atmeans






********** 
/*
i=1 --> at=.
i=2 --> at=1 (male) at=2 (female)
i=3 --> at=1 (middle-upper) at=2 (dalits)
i=3 --> at=1 (middle-upper male) at=2 (dalits male) at=3 (middle-upper female) at=4 (dalits female)
*/

*cap ssc inst sxpose
foreach x in indebt_indiv { // heck_DSR_indiv heck_loanamount_indiv1000 FE_loanamount_indiv1000 FE_DSR_indiv b5_indebt_indiv b5_heck_loanamount_indiv1000 b5_heck_DSR_indiv loanamount_indiv1000 DSR_indiv b5_loanamount_indiv1000 b5_DSR_indiv delta2_loanamount_indiv delta2_DSR_indiv b5_delta2_loanamount_indiv b5_delta2_DSR_indiv  {
*foreach x in FE_loanamount_indiv1000 FE_DSR_indiv {
forvalues i=1(1)4{
preserve
use"margin_`x'`i'", clear

label define cog 1"C-1" 2"C-2" 3"C-3" 4"C-4" 5"C-5" 6"Raven" 7"Numeracy" 8"Literacy", replace
label values _deriv cog
decode _deriv, gen(deriv)
tostring _at, gen(at)
replace at="1" if _at==1
replace at="2" if _at==2
replace at="3" if _at==3
replace at="4" if _at==4
keep _deriv at _margin _se _statistic _pvalue _ci_lb _ci_ub
foreach y in margin se statistic pvalue ci_lb ci_ub {
gen `y'=_`y'
}
keep _deriv at margin se statistic pvalue ci_lb ci_ub
*order _deriv at margin se statistic pvalue ci_lb ci_ub
*label var _deriv "Independent variable"
*label var at "Sample"
*label var margin "dy/dx"
*label var se "SE"
*label var statistic "t-stat"
*label var pvalue "p-value"
*label var ci_lb "[95% Conf."
*label var ci_ub "Interval]"
*export excel using "margins`i'.xlsx", sheet("`x'", replace) firstrow(varlabels)
gen margin_str=strofreal(margin, "%9.3f")
gen stat_str=strofreal(statistic, "%9.3f")
keep _deriv at margin_str stat_str
rename margin_str nstr1
rename stat_str nstr2
decode _deriv, gen(deriv)
drop _deriv
egen at_deriv=concat(at deriv), p(/)
order at_deriv, first
drop at deriv
reshape long nstr, i(at_deriv) j(num)
gen xo="("
gen xc=")"
egen nstr_t=concat(xo nstr xc) if num==2
replace nstr=nstr_t if nstr_t!=""
drop xo xc nstr_t
split at_deriv, p(/)
drop at_deriv
rename at_deriv2 deriv
rename at_deriv1 at
order at deriv num

gen nstr2=""
gen nstr3=""
gen nstr4=""

replace nstr2=nstr[_n+16]
replace nstr3=nstr[_n+32]
replace nstr4=nstr[_n+48]

gen n=_n
drop if n>16

replace deriv="" if num==2

drop at num 
dropmiss, force

save"margin_`x'`i'_new", replace
restore 
}
use"margin_`x'1_new.dta", replace
rename nstr All
merge 1:1 n using "margin_`x'2_new.dta"
drop _merge
rename nstr Male
rename nstr2 Female
merge 1:1 n using "margin_`x'3_new.dta"
drop _merge
rename nstr Midup
rename nstr2 Dalit
merge 1:1 n using "margin_`x'4_new.dta"

drop _merge
rename nstr Midup_male
rename nstr2 Dalit_male
rename nstr3 Midup_female
rename nstr4 Dalit_female
*drop n

forvalues i=1(1)3{
gen blank`i'=""
}

order deriv All blank1 Male Female blank2 Midup Dalit blank3 Midup_male Dalit_male Midup_female Dalit_female

set obs `=_N+1'
set obs `=_N+1'
set obs `=_N+1'

replace n=17-_n if n==.
sort n

replace All="(1)" if n==-2
replace Male="(2)" if n==-2
replace Midup="(3)" if n==-2
replace Midup_male="(4)" if n==-2

foreach x in All Male Female Midup Dalit Midup_male Dalit_male Midup_female Dalit_female {
replace `x'="ME/(t-stat)" if n==-1
}

replace All="All" if n==0
replace Male="Male" if n==0
replace Female="Female" if n==0
replace Midup="MUC" if n==0
replace Dalit="Dalits" if n==0
replace Midup_male="MUC male" if n==0
replace Dalit_male="Dalits male" if n==0
replace Midup_female="MUC female" if n==0
replace Dalit_female="Dalits female" if n==0



drop n
export excel using "margins.xlsx", sheet("`x'", replace) firstrow(varlabels)
}
