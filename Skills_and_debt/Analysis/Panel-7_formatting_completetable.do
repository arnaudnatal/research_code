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
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
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







****************************************
* Y
****************************************
********** To check
global quali indebt_indiv_2 indiv_interest otherlenderservices_finansupp guarantee_none
 
global qualiml borrowerservices_none plantorepay_borr settleloanstrat_addi dummyproblemtorepay

global quanti DSR_indiv loanamount_indiv ISR_indiv


********** Auto
global varquali $quali $qualiml
global varquanti $quanti
****************************************
* END













****************************************
* Quali
****************************************
foreach var in $varquali {

import excel "Probit_indebt.xlsx", sheet("`var'") clear
*import excel "Probit_indebt.xlsx", sheet("indebt_indiv_2") clear
gen n=_n
drop if n==4
drop n
gen n=_n

foreach x in B C D E {
replace `x'="$\upbeta$/(Std Err.)" if `x'=="b/se"

replace `x'="Pr(In debt)" if `x'=="indebt_indiv_2"
replace `x'="Pr(Interest)" if `x'=="indiv_interest"
replace `x'="Pr(Finan. supp.)" if `x'=="otherlenderservices_finansupp"
replace `x'="Pr(No guaran.)" if `x'=="guarantee_none"
replace `x'="Pr(No serv.)" if `x'=="borrowerservices_none"
replace `x'="Pr(Borrowing)" if `x'=="plantorepay_borr"
replace `x'="Pr(Additional)" if `x'=="settleloanstrat_addi"
replace `x'="Pr(Pb to repay)" if `x'=="dummyproblemtorepay"
}

drop if A=="* p<0.05, ** p<0.01, *** p<0.001"
drop if A=="* p<0.10, ** p<0.05, *** p<0.01"
replace A="Constant" if A=="constant"

*Star
foreach x in B C D E {
gen `x'n=subinstr(`x',"***","\sym{***}",.)
gen `x'n2=subinstr(`x',"**","\sym{**}",.)
replace `x'n2="" if substr(`x'n2,strlen(`x'n2),1)=="*"
replace `x'n=`x'n2 if `x'n2!=""
drop `x'n2

gen `x'n1=subinstr(`x',"*","\sym{*}",.)
replace `x'n=`x'n1 if substr(`x'n,strlen(`x'n),1)=="*"
drop `x'n1 `x'
rename `x'n `x'
}

gen gui=" & "
gen end=" \\"
*replace end="" if n==1
*replace end="" if n==2
*replace end="" if n==3


egen v1=concat(A gui B gui C gui D gui E end)
keep v1

*** Top of table
gen n=1/_n
sort n
set obs `=_N+1'
replace v1="\toprule" if v1==""
set obs `=_N+1'
replace v1="\label{tab:ame_`var'}" if v1==""
set obs `=_N+1'
replace v1="\caption{\detokenize{`var'}}" if v1==""
set obs `=_N+1'
replace v1="\begin{longtable}{@{}lcccc@{}}" if v1==""
drop n
gen n=1/_n
sort n
drop n

*** Bottom of table
gen n=_n
sort n
set obs `=_N+1'
replace v1="\end{longtable}" if v1==""
/*
set obs `=_N+1'
replace v1="\end{tabular}" if v1==""
set obs `=_N+1'
replace v1="}" if v1==""
set obs `=_N+1'
replace v1="\label{tab:ame_`var'}" if v1==""
set obs `=_N+1'
replace v1=`"\notetab{*p<0.1~ **p<0.05~ ***p<0.01.}"' if v1==""
set obs `=_N+1'
replace v1="\sourcetab{NEEMSIS-1 (2016-17) \& NEEMSIS-2 (2020-21); author's calculations.}" if v1==""
set obs `=_N+1'
replace v1="\end{table}"  if v1==""
*/
drop n
gen n=_n
sort n

*`"""'

*** Midrule
set obs `=_N+1'
replace n=5.5 if n==.
sort n
replace v1="\endfirsthead" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=6.5 if n==.
sort n
replace v1="%" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=7.5 if n==.
sort n
replace v1="\endhead" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=8.5 if n==.
sort n
replace v1="%" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=9.5 if n==.
sort n
replace v1="\bottomrule" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=10.5 if n==.
sort n
replace v1="\endfoot" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=11.5 if n==.
sort n
replace v1="%" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=12.5 if n==.
sort n
replace v1="\endlastfoot" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=13.5 if n==.
sort n
replace v1="%" if v1==""
drop n

gen n=_n
gen ru=""
replace ru="* \midrule" if n==16
replace ru="* \midrule" if n==124
replace ru="* \bottomrule" if n==129

egen v2=concat(v1 ru)
keep v2


export delimited using "tex/tab_`var'.tex",  novarnames  replace //delimiter("")
}
****************************************
* END












 


****************************************
* Quanti
****************************************
foreach var in $varquanti {

*import excel "OLS_indebt.xlsx", sheet("`var'") clear
import excel "OLS_indebt.xlsx", sheet("DSR_indiv") clear
gen n=_n

foreach x in B C D E {
replace `x'="$\upbeta$/(Std Err.)" if `x'=="b/se"

replace `x'="DSR" if `x'=="DSR_indiv"
replace `x'="Loan amount" if `x'=="loanamount_indiv"
replace `x'="ISR" if `x'=="ISR_indiv"
}

drop if A=="* p<0.05, ** p<0.01, *** p<0.001"
drop if A=="* p<0.10, ** p<0.05, *** p<0.01"
replace A="Constant" if A=="constant"

*Star
foreach x in B C D E {
gen `x'n=subinstr(`x',"***","\sym{***}",.)
gen `x'n2=subinstr(`x',"**","\sym{**}",.)
replace `x'n2="" if substr(`x'n2,strlen(`x'n2),1)=="*"
replace `x'n=`x'n2 if `x'n2!=""
drop `x'n2

gen `x'n1=subinstr(`x',"*","\sym{*}",.)
replace `x'n=`x'n1 if substr(`x'n,strlen(`x'n),1)=="*"
drop `x'n1 `x'
rename `x'n `x'
}

gen gui=" & "
gen end=" \\"
*replace end="" if n==1
*replace end="" if n==2
*replace end="" if n==3


egen v1=concat(A gui B gui C gui D gui E end)
keep v1

*** Top of table
gen n=1/_n
sort n
set obs `=_N+1'
replace v1="\toprule" if v1==""
set obs `=_N+1'
replace v1="\label{tab:ame_`var'}" if v1==""
set obs `=_N+1'
replace v1="\caption{\detokenize{`var'}}" if v1==""
set obs `=_N+1'
replace v1="\begin{longtable}{@{}lcccc@{}}" if v1==""
drop n
gen n=1/_n
sort n
drop n

*** Bottom of table
gen n=_n
sort n
set obs `=_N+1'
replace v1="\end{longtable}" if v1==""
/*
set obs `=_N+1'
replace v1="\end{tabular}" if v1==""
set obs `=_N+1'
replace v1="}" if v1==""
set obs `=_N+1'
replace v1="\label{tab:ame_`var'}" if v1==""
set obs `=_N+1'
replace v1=`"\notetab{*p<0.1~ **p<0.05~ ***p<0.01.}"' if v1==""
set obs `=_N+1'
replace v1="\sourcetab{NEEMSIS-1 (2016-17) \& NEEMSIS-2 (2020-21); author's calculations.}" if v1==""
set obs `=_N+1'
replace v1="\end{table}"  if v1==""
*/
drop n
gen n=_n
sort n

*`"""'

*** Midrule
set obs `=_N+1'
replace n=5.5 if n==.
sort n
replace v1="\endfirsthead" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=6.5 if n==.
sort n
replace v1="%" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=7.5 if n==.
sort n
replace v1="\endhead" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=8.5 if n==.
sort n
replace v1="%" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=9.5 if n==.
sort n
replace v1="\bottomrule" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=10.5 if n==.
sort n
replace v1="\endfoot" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=11.5 if n==.
sort n
replace v1="%" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=12.5 if n==.
sort n
replace v1="\endlastfoot" if v1==""
drop n
gen n=_n

set obs `=_N+1'
replace n=13.5 if n==.
sort n
replace v1="%" if v1==""
drop n

gen n=_n
gen ru=""
replace ru="* \midrule" if n==16
replace ru="* \midrule" if n==124
replace ru="* \bottomrule" if n==129

egen v2=concat(v1 ru)
keep v2

export delimited using "tex/tab_`var'.tex",  novarnames  replace //delimiter("")
}
****************************************
* END

