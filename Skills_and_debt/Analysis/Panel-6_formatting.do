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
*global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END


global quali indebt_indiv_2 dummy_good dummy_bad dichotomyinterest_indiv_2 dummypbrepay otherlenderservices_finansupp otherlenderservices_generainf borrowerservices_suppwhenever borrowerservices_none guarantee_doc guarantee_perso guarantee_none plantorepay_work plantorepay_inco plantorepay_borr settleloanstrat_inco settleloanstrat_borr settleloanstrat_work loanproductpledge_gold loanproductpledge_furnit

global quanti loanamount_indiv1000_2 loanamount_good_indiv loanamount_bad_indiv DSR_indiv_2 DSR_good_indiv DSR_bad_indiv ISR_indiv_2 ISR_good_indiv ISR_bad_indiv imp1_is_tot_indiv1000_2 imp1_is_tot_good_indiv imp1_is_tot_bad_indiv


global dependent $quali $quanti




********** Quali
foreach x in $quali {

forvalues i=1(1)4{
*****
*****
preserve
use"margin_`x'`i'", clear

label define cog 1"A1" 2"A2" 3"A3" 4"A5" 5"Raven (std)" 6"Numeracy (std)" 7"Literacy (std)", replace
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

********** Format
gen margin_str=strofreal(margin, "%9.2f")
gen stat_str=strofreal(statistic, "%9.2f")
gen se_str=strofreal(se, "%9.2f")
keep _deriv at margin_str stat_str pvalue se_str
rename margin_str nstr1
rename stat_str nstr2
decode _deriv, gen(deriv)
drop _deriv
egen at_deriv=concat(at deriv), p(/)
order at_deriv, first
drop at deriv

*** Star
gen star1="*"
gen star2="**"
gen star3="***"
egen nstr1_s1=concat(nstr1 star3) if pvalue<=.01
egen nstr1_s2=concat(nstr1 star2) if pvalue>.01 & pvalue<=.05
egen nstr1_s3=concat(nstr1 star1) if pvalue>.05 & pvalue<=.1
gen nstr1_s=""
replace nstr1_s=nstr1_s1 if nstr1_s1!=""
replace nstr1_s=nstr1_s2 if nstr1_s2!=""
replace nstr1_s=nstr1_s3 if nstr1_s3!=""
drop star1 star2 star3 nstr1_s1 nstr1_s2 nstr1_s3
replace nstr1=nstr1_s if nstr1_s!=""
drop nstr1_s pvalue

*** Brackets
drop nstr2
rename se_str nstr2
gen xo="("
gen xc=")"
egen nstr2_p=concat(xo nstr2 xc)
drop nstr2 xo xc
rename nstr2_p nstr2

*** Reshape
reshape long nstr, i(at_deriv) j(num)

split at_deriv, p(/)
drop at_deriv
rename at_deriv2 deriv
rename at_deriv1 at
order at deriv num

gen nstr2=""
gen nstr3=""
gen nstr4=""

replace nstr2=nstr[_n+14]
replace nstr3=nstr[_n+28]
replace nstr4=nstr[_n+42]

gen n=_n
drop if n>14

replace deriv="" if num==2

drop at num 
dropmiss, force

save"margin_`x'`i'_new", replace
restore 
*****
*****
}
*}

*foreach x in indebt_indiv heck_DSR_indiv heck_loanamount_indiv1000 FE_loanamount_indiv1000 FE_DSR_indiv { 
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

replace n=15-_n if n==.
sort n

replace All="(1)" if n==-2
replace Male="(2)" if n==-2
replace Midup="(3)" if n==-2
replace Midup_male="(4)" if n==-2

foreach var in All Male Female Midup Dalit Midup_male Dalit_male Midup_female Dalit_female {
replace `var'="ME/(Std Err.)" if n==-1
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

/*
replace deriv="OP cor (std)" if deriv=="C-1" & strpos("`x'", "b5")  
replace deriv="CO cor (std)" if deriv=="C-2" & strpos("`x'", "b5")  
replace deriv="EX cor (std)" if deriv=="C-3" & strpos("`x'", "b5")  
replace deriv="AG cor (std)" if deriv=="C-4" & strpos("`x'", "b5")  
replace deriv="ES cor (std)" if deriv=="C-5" & strpos("`x'", "b5")  

replace deriv="OP (std)" if deriv=="C-1" & strpos("`x'", "FE")  
replace deriv="CO (std)" if deriv=="C-2" & strpos("`x'", "FE")  
replace deriv="EX (std)" if deriv=="C-3" & strpos("`x'", "FE")  
replace deriv="AG (std)" if deriv=="C-4" & strpos("`x'", "FE")  
replace deriv="ES (std)" if deriv=="C-5" & strpos("`x'", "FE") 
*/
replace deriv="ES (std)" if deriv=="A1"
replace deriv="CO (std)" if deriv=="A2"
replace deriv="OP-EX (std)" if deriv=="A3"
replace deriv="AG (std)" if deriv=="A5"


drop n
export excel using "margins_probit.xlsx", sheet("`x'", replace) //firstrow(varlabels)
*export excel using "margins_`x'.xlsx", sheet("`x'", replace) firstrow(varlabels)
*export delimited using "margins_`x'.csv"
}






********** Quanti
foreach x in $quanti {

forvalues i=1(1)4{
*****
*****
preserve
use"margin_`x'`i'", clear

label define cog 1"A1" 2"A2" 3"A3" 4"A5" 5"Raven (std)" 6"Numeracy (std)" 7"Literacy (std)", replace
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

********** Format
gen margin_str=strofreal(margin, "%9.2f")
gen stat_str=strofreal(statistic, "%9.2f")
gen se_str=strofreal(se, "%9.2f")
keep _deriv at margin_str stat_str pvalue se_str
rename margin_str nstr1
rename stat_str nstr2
decode _deriv, gen(deriv)
drop _deriv
egen at_deriv=concat(at deriv), p(/)
order at_deriv, first
drop at deriv

*** Star
gen star1="*"
gen star2="**"
gen star3="***"
egen nstr1_s1=concat(nstr1 star3) if pvalue<=.01
egen nstr1_s2=concat(nstr1 star2) if pvalue>.01 & pvalue<=.05
egen nstr1_s3=concat(nstr1 star1) if pvalue>.05 & pvalue<=.1
gen nstr1_s=""
replace nstr1_s=nstr1_s1 if nstr1_s1!=""
replace nstr1_s=nstr1_s2 if nstr1_s2!=""
replace nstr1_s=nstr1_s3 if nstr1_s3!=""
drop star1 star2 star3 nstr1_s1 nstr1_s2 nstr1_s3
replace nstr1=nstr1_s if nstr1_s!=""
drop nstr1_s pvalue

*** Brackets
drop nstr2
rename se_str nstr2
gen xo="("
gen xc=")"
egen nstr2_p=concat(xo nstr2 xc)
drop nstr2 xo xc
rename nstr2_p nstr2

*** Reshape
reshape long nstr, i(at_deriv) j(num)

split at_deriv, p(/)
drop at_deriv
rename at_deriv2 deriv
rename at_deriv1 at
order at deriv num

gen nstr2=""
gen nstr3=""
gen nstr4=""

replace nstr2=nstr[_n+14]
replace nstr3=nstr[_n+28]
replace nstr4=nstr[_n+42]

gen n=_n
drop if n>14

replace deriv="" if num==2

drop at num 
dropmiss, force

save"margin_`x'`i'_new", replace
restore 
*****
*****
}
*}

*foreach x in indebt_indiv heck_DSR_indiv heck_loanamount_indiv1000 FE_loanamount_indiv1000 FE_DSR_indiv { 
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

replace n=15-_n if n==.
sort n

replace All="(1)" if n==-2
replace Male="(2)" if n==-2
replace Midup="(3)" if n==-2
replace Midup_male="(4)" if n==-2

foreach var in All Male Female Midup Dalit Midup_male Dalit_male Midup_female Dalit_female {
replace `var'="ME/(t-stat)" if n==-1
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

/*
replace deriv="OP cor (std)" if deriv=="C-1" & strpos("`x'", "b5")  
replace deriv="CO cor (std)" if deriv=="C-2" & strpos("`x'", "b5")  
replace deriv="EX cor (std)" if deriv=="C-3" & strpos("`x'", "b5")  
replace deriv="AG cor (std)" if deriv=="C-4" & strpos("`x'", "b5")  
replace deriv="ES cor (std)" if deriv=="C-5" & strpos("`x'", "b5")  

replace deriv="OP (std)" if deriv=="C-1" & strpos("`x'", "FE")  
replace deriv="CO (std)" if deriv=="C-2" & strpos("`x'", "FE")  
replace deriv="EX (std)" if deriv=="C-3" & strpos("`x'", "FE")  
replace deriv="AG (std)" if deriv=="C-4" & strpos("`x'", "FE")  
replace deriv="ES (std)" if deriv=="C-5" & strpos("`x'", "FE") 
*/
replace deriv="ES (std)" if deriv=="A1"
replace deriv="CO (std)" if deriv=="A2"
replace deriv="OP-EX (std)" if deriv=="A3"
replace deriv="AG (std)" if deriv=="A5"


drop n
export excel using "margins_ols.xlsx", sheet("`x'", replace) //firstrow(varlabels)
*export excel using "margins_`x'.xlsx", sheet("`x'", replace) firstrow(varlabels)
*export delimited using "margins_`x'.csv"
}
























/*




***QREG
foreach x in loanamount_indiv1000 DSR_indiv { //b5_loanamount_indiv1000 b5_DSR_indiv {
foreach i in 10 25 50 75 90{
*****
*****
preserve
use"margin_qreg_`i'_`x'", clear

label define cog 1"C-1" 2"C-2" 3"C-3" 4"C-4" 5"C-5" 6"Raven (std)" 7"Numeracy (std)" 8"Literacy (std)", replace
label values _deriv cog
decode _deriv, gen(deriv)
keep _deriv _margin _se _statistic _pvalue _ci_lb _ci_ub
foreach y in margin se statistic pvalue ci_lb ci_ub {
gen `y'=_`y'
}
keep _deriv margin se statistic pvalue ci_lb ci_ub

gen margin_str=strofreal(margin, "%9.2f")
gen stat_str=strofreal(statistic, "%9.2f")
keep _deriv margin_str stat_str
rename margin_str nstr1
rename stat_str nstr2
decode _deriv, gen(deriv)
drop _deriv
order deriv, first
reshape long nstr, i(deriv) j(num)
gen xo="("
gen xc=")"
egen nstr_t=concat(xo nstr xc) if num==2
replace nstr=nstr_t if nstr_t!=""
drop xo xc nstr_t
order deriv num

replace deriv="" if num==2

drop num 
dropmiss, force

gen n=_n

save"margin_qreg_`i'_`x'_new", replace
restore 
}
*****
*****
use"margin_qreg_10_`x'_new.dta", replace
rename nstr P10
merge 1:1 n using "margin_qreg_25_`x'_new.dta"
drop _merge
rename nstr P25
merge 1:1 n using "margin_qreg_50_`x'_new.dta"
drop _merge
rename nstr P50
merge 1:1 n using "margin_qreg_75_`x'_new.dta"
drop _merge
rename nstr P75
merge 1:1 n using "margin_qreg_90_`x'_new.dta"
drop _merge
rename nstr P90

set obs `=_N+1'
set obs `=_N+1'
set obs `=_N+1'

replace n=17-_n if n==.
sort n

replace P10="(1)" if n==-2
replace P25="(2)" if n==-2
replace P50="(3)" if n==-2
replace P75="(4)" if n==-2
replace P90="(5)" if n==-2

foreach var in P10 P25 P50 P75 P90{
replace `var'="ME/(t-stat)" if n==-1
}

foreach var in P10 P25 P50 P75 P90{
replace `var'="`var'" if n==0
}
drop n

replace deriv="OP cor (std)" if deriv=="C-1" & strpos("`x'", "b5")  
replace deriv="CO cor (std)" if deriv=="C-2" & strpos("`x'", "b5")  
replace deriv="EX cor (std)" if deriv=="C-3" & strpos("`x'", "b5")  
replace deriv="AG cor (std)" if deriv=="C-4" & strpos("`x'", "b5")  
replace deriv="ES cor (std)" if deriv=="C-5" & strpos("`x'", "b5")  

replace deriv="F1 - OP-EX (std)" if deriv=="C-1"
replace deriv="F2 - CO (std)" if deriv=="C-2"
replace deriv="F3 - Porupillatavan (std)" if deriv=="C-3"
replace deriv="F4 - ES (std)" if deriv=="C-4"
replace deriv="F5 - AG (std)" if deriv=="C-5"

export excel using "margins.xlsx", sheet("qreg_`x'", replace) firstrow(varlabels)
*export excel using "margins_`x'.xlsx", sheet("`x'", replace) firstrow(varlabels)
*export delimited using "margins_`x'.csv"
}






/*


******* Debtpath
foreach x in debtpath b5_debtpath { 
forvalues i=1(1)4{
*****
*****
preserve
use"margin_`x'`i'", clear

label define cog 1"C-1" 2"C-2" 3"C-3" 4"C-4" 5"C-5" 6"Raven (std)" 7"Numeracy (std)" 8"Literacy (std)", replace
label values _deriv cog

label define pred 1"Never in debt" 2"Out of debt" 3"Became in debt" 4"Always in debt"
label values _predict pred


decode _deriv, gen(deriv)
tostring _at, gen(at)
replace at="1" if _at==1
replace at="2" if _at==2
replace at="3" if _at==3
replace at="4" if _at==4

drop _at1 _at2 _at3 _at4 _at5 _at6 _at7 _at8 _at9 _at10

keep _deriv _predict at _margin _se _statistic _pvalue _ci_lb _ci_ub
foreach y in margin se statistic pvalue ci_lb ci_ub predict {
gen `y'=_`y'
}
keep _deriv at margin se statistic pvalue ci_lb ci_ub predict

gen margin_str=strofreal(margin, "%9.3f")
gen stat_str=strofreal(statistic, "%9.3f")
keep _deriv at margin_str stat_str predict
rename margin_str nstr1
rename stat_str nstr2
decode _deriv, gen(deriv)
drop _deriv
egen predict_at_deriv=concat(predict at deriv), p(/)
order predict_at_deriv, first
drop at deriv predict
reshape long nstr, i(predict_at_deriv) j(num)
gen xo="("
gen xc=")"
egen nstr_t=concat(xo nstr xc) if num==2
replace nstr=nstr_t if nstr_t!=""
drop xo xc nstr_t
split predict_at_deriv, p(/)
drop predict_at_deriv

rename predict_at_deriv1 predict
rename predict_at_deriv2 at
rename predict_at_deriv3 deriv
order predict at deriv num

gen nstr2=""
gen nstr3=""
gen nstr4=""

sort at predict deriv num

replace nstr2=nstr[_n+64]
replace nstr3=nstr[_n+128]
replace nstr4=nstr[_n+192]

gen n=_n
drop if n>64

replace deriv="" if num==2

drop at num 
dropmiss, force

replace predict="Never in debt" if predict=="1"
replace predict="Out of debt" if predict=="2"
replace predict="Became in debt" if predict=="3"
replace predict="Always in debt" if predict=="4"

save"margin_`x'`i'_new", replace
restore 
*****
*****
}
*}
*foreach x in debtpath { 
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
*}

forvalues i=1(1)3{
gen blank`i'=""
}

order predict deriv All blank1 Male Female blank2 Midup Dalit blank3 Midup_male Dalit_male Midup_female Dalit_female

set obs `=_N+1'
set obs `=_N+1'
set obs `=_N+1'

replace n=65-_n if n==.
sort n

replace All="(1)" if n==-2
replace Male="(2)" if n==-2
replace Midup="(3)" if n==-2
replace Midup_male="(4)" if n==-2

foreach var in All Male Female Midup Dalit Midup_male Dalit_male Midup_female Dalit_female {
replace `var'="ME/(t-stat)" if n==-1
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

replace deriv="OP cor (std)" if deriv=="C-1" & strpos("`x'", "b5")  
replace deriv="CO cor (std)" if deriv=="C-2" & strpos("`x'", "b5")  
replace deriv="EX cor (std)" if deriv=="C-3" & strpos("`x'", "b5")  
replace deriv="AG cor (std)" if deriv=="C-4" & strpos("`x'", "b5")  
replace deriv="ES cor (std)" if deriv=="C-5" & strpos("`x'", "b5")  

replace deriv="F1 - OP-EX (std)" if deriv=="C-1"
replace deriv="F2 - CO (std)" if deriv=="C-2"
replace deriv="F3 - Porupillatavan (std)" if deriv=="C-3"
replace deriv="F4 - ES (std)" if deriv=="C-4"
replace deriv="F5 - AG (std)" if deriv=="C-5"

replace predict="" if deriv!="C-1"

drop n
export excel using "margins.xlsx", sheet("`x'", replace) firstrow(varlabels)
*export excel using "margins_`x'.xlsx", sheet("`x'", replace) firstrow(varlabels)
*export delimited using "margins_`x'.csv"
}
