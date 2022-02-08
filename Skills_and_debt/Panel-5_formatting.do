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
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Documents\Dropbox\Arnaud\Thesis_Debt_skills\INPUT"

***
set scheme plotplain
cd"$directory"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

/*
Pour avoir un box plot en colonne et 1 en ligne pour un nuage de points:
graph7 mpg weight, twoway oneway box xla yla
*/

*stripplot

****************************************
* END







****************************************
* Y
****************************************
********** To check
global quali indebt_indiv_2 otherlenderservices_finansupp
 
global qualiml borrowerservices_none plantorepay_borr dummyproblemtorepay

global quanti loanamount_indiv ISR_indiv


********** Auto
global varquali $quali $qualiml
global varquanti $quanti
****************************************
* END













****************************************
* Quali
****************************************
foreach x in $varquali {

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
gen star1="\sym{*}"
gen star2="\sym{**}"
gen star3="\sym{***}"
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


replace deriv="ES (std)" if deriv=="A1"
replace deriv="CO (std)" if deriv=="A2"
replace deriv="OP-EX (std)" if deriv=="A3"
replace deriv="AG (std)" if deriv=="A5"


drop n
export excel using "margins_probit.xlsx", sheet("`x'", replace) //firstrow(varlabels)
*}

*foreach x in $varquali {
********** Tex
import excel "margins_probit.xlsx", sheet("`x'") all clear
*import excel "margins_probit.xlsx", sheet("indebt_indiv_2") all clear


preserve
import excel "Probit_indebt.xlsx", sheet("`x'") clear
*import excel "Probit_indebt.xlsx", sheet("indebt_indiv_2") clear

gen tokeep=0
replace tokeep=1 if A=="Observations"
replace tokeep=1 if strpos(A,"Pseudo")
replace tokeep=1 if A=="Log-likelihood"
replace tokeep=1 if A=="$\upchi^2$"
replace tokeep=1 if A=="p-value"
keep if tokeep==1
drop tokeep

gen sp1=""
gen sp2=""
gen sp3=""
gen sp4=""
gen sp5=""
gen sp6=""
gen sp7=""
gen sp8=""

order A B sp1 C sp2 sp3 D sp4 sp5 E sp6 sp7 sp8
rename sp8 M
rename sp7 L
rename sp6 K
rename E J
rename sp5 I
rename sp4 H
rename D G
rename sp3 F
rename sp2 E
rename C D
rename sp1 C

save "_temp_`x'.dta", replace
*save "_temp_indebt_indiv_2.dta", replace
restore

append using "_temp_`x'.dta"
*append using "_temp_indebt_indiv_2.dta"
foreach let in A B C D E F G H I J K L M {
replace `let'=" "+`let'+" "
}

export delimited using "_temp_`x'.txt", delimiter("&") replace
*export delimited using "_temp_indebt_indiv_2.txt", delimiter("&") replace

********** Table format
import delimited "_temp_`x'.txt", clear 
*import delimited "_temp_indebt_indiv_2.txt", clear 
gen n=_n
drop if n==1
drop n 

*** Top of table
gen n=1/_n
sort n
set obs `=_N+1'
replace v1="\toprule" if v1==""
set obs `=_N+1'
replace v1="\begin{tabular}{lcccccccccccc}" if v1==""
set obs `=_N+1'
replace v1="\resizebox{\columnwidth}{!}{%" if v1==""
set obs `=_N+1'
replace v1="\caption{\detokenize{`x'}}" if v1==""
set obs `=_N+1'
replace v1="\raggedright" if v1==""
set obs `=_N+1'
replace v1="\begin{table}[!h]" if v1==""
drop n
gen n=1/_n
sort n
drop n

*** Bottom of table
gen n=_n
sort n
set obs `=_N+1'
replace v1="\bottomrule" if v1==""
set obs `=_N+1'
replace v1="\end{tabular}" if v1==""
set obs `=_N+1'
replace v1="}" if v1==""
set obs `=_N+1'
replace v1="\label{tab:ame_`x'}" if v1==""
set obs `=_N+1'
replace v1="\fignote{ME/(Std Err.). *p<0.1~ **p<0.05~ ***p<0.01.}" if v1==""
set obs `=_N+1'
replace v1="\figsource{NEEMSIS-1 (2016-17) \& NEEMSIS-2 (2020-21); author's calculations.}" if v1==""
set obs `=_N+1'
replace v1="\end{table}"  if v1==""
drop n
gen n=_n
sort n


*** Midrule
replace v1="\cmidrule{2-2}\cmidrule{4-5}\cmidrule{7-8}\cmidrule{10-13}" if n==8
set obs `=_N+1'
replace n=9.5 if n==.
sort n
replace v1="\midrule" if v1==""
set obs `=_N+1'
replace n=23.5 if n==.
sort n
replace v1="\cmidrule{1-2}\cmidrule{4-5}\cmidrule{7-8}\cmidrule{10-13}" if v1==""
drop n
gen n=_n

* Line break
gen lb=""
replace lb="\\" if ///
n==7 | ///
n==9 | ///
(n>=11 & n<=24) | ///
(n>=26 & n<=30)

* Order
egen tab=concat(v1 lb), p("")
drop v1 lb
drop n

export delimited using "$dropbox/ame_`x'.tex", delimiter("") novarnames  replace
}
****************************************
* END


















****************************************
* Quanti
****************************************
foreach x in $varquanti {

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
gen star1="\sym{*}"
gen star2="\sym{***}"
gen star3="\sym{***}"
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


replace deriv="ES (std)" if deriv=="A1"
replace deriv="CO (std)" if deriv=="A2"
replace deriv="OP-EX (std)" if deriv=="A3"
replace deriv="AG (std)" if deriv=="A5"


drop n
export excel using "margins_ols.xlsx", sheet("`x'", replace) //firstrow(varlabels)
}

foreach x in $varquanti {

********** Tex
import excel "margins_OLS.xlsx", sheet("`x'") all clear
*import excel "margins_OLS.xlsx", sheet("DSR_indiv") all clear

preserve
import excel "OLS_indebt.xlsx", sheet("`x'") clear

gen tokeep=0
replace tokeep=1 if A=="Observations"
replace tokeep=1 if strpos(A,"R^2")
replace tokeep=1 if A=="F-stat"
replace tokeep=1 if A=="p-value"
keep if tokeep==1
drop tokeep

gen sp1=""
gen sp2=""
gen sp3=""
gen sp4=""
gen sp5=""
gen sp6=""
gen sp7=""
gen sp8=""

order A B sp1 C sp2 sp3 D sp4 sp5 E sp6 sp7 sp8
rename sp8 M
rename sp7 L
rename sp6 K
rename E J
rename sp5 I
rename sp4 H
rename D G
rename sp3 F
rename sp2 E
rename C D
rename sp1 C

save "_temp_`x'.dta", replace
restore

append using "_temp_`x'.dta"
foreach let in A B C D E F G H I J K L M {
replace `let'=" "+`let'+" "
}

export delimited using "_temp_`x'.txt", delimiter("&") replace

********** Table format
import delimited "_temp_`x'.txt", clear 
gen n=_n
drop if n==1
drop n 

*** Top of table
gen n=1/_n
sort n
set obs `=_N+1'
replace v1="\toprule" if v1==""
set obs `=_N+1'
replace v1="\begin{tabular}{lcccccccccccc}" if v1==""
set obs `=_N+1'
replace v1="\resizebox{\columnwidth}{!}{%" if v1==""
set obs `=_N+1'
replace v1="\caption{\detokenize{`x'}}" if v1==""
set obs `=_N+1'
replace v1="\raggedright" if v1==""
set obs `=_N+1'
replace v1="\begin{table}[!h]" if v1==""
drop n
gen n=1/_n
sort n
drop n

*** Bottom of table
gen n=_n
sort n
set obs `=_N+1'
replace v1="\bottomrule" if v1==""
set obs `=_N+1'
replace v1="\end{tabular}" if v1==""
set obs `=_N+1'
replace v1="}" if v1==""
set obs `=_N+1'
replace v1="\label{tab:ame_`x'}" if v1==""
set obs `=_N+1'
replace v1="\fignote{ME/(Std Err.). *p<0.1~ **p<0.05~ ***p<0.01.}" if v1==""
set obs `=_N+1'
replace v1="\figsource{NEEMSIS-1 (2016-17) \& NEEMSIS-2 (2020-21); author's calculations.}" if v1==""
set obs `=_N+1'
replace v1="\end{table}"  if v1==""
drop n
gen n=_n
sort n


*** Midrule
replace v1="\cmidrule{2-2}\cmidrule{4-5}\cmidrule{7-8}\cmidrule{10-13}" if n==8
set obs `=_N+1'
replace n=9.5 if n==.
sort n
replace v1="\midrule" if v1==""
set obs `=_N+1'
replace n=23.5 if n==.
sort n
replace v1="\cmidrule{1-2}\cmidrule{4-5}\cmidrule{7-8}\cmidrule{10-13}" if v1==""
drop n
gen n=_n

* Line break
gen lb=""
replace lb="\\" if ///
n==7 | ///
n==9 | ///
(n>=11 & n<=24) | ///
(n>=26 & n<=30)

* Order
egen tab=concat(v1 lb), p("")
drop v1 lb
drop n

export delimited using "$dropbox/ame_`x'.tex", delimiter("") novarnames  replace
}
****************************************
* END












****************************************
* Clean file
****************************************
********** .dta
filelist, dir("$directory") pattern(*.dta)
split filename, p(_)
keep if ///
filename1=="margin" | ///
filename2=="temp"
drop filename1 filename2 filename3 filename4 filename5

egen file=concat(dirname filename), p(\)
keep file

tempfile myfiles
save "`myfiles'"
local obs=_N
forvalues i=1/`obs' {
	*set trace on
	use "`myfiles'" in `i', clear
	local f=file
	erase "`f'"
}


********** .txt
filelist, dir("$directory") pattern(*.txt)
split filename, p(_)
keep if ///
filename1=="margin" | ///
filename2=="temp"
drop filename1 filename2 filename3 filename4 filename5

egen file=concat(dirname filename), p(\)
keep file

tempfile myfiles
save "`myfiles'"
local obs=_N
forvalues i=1/`obs' {
	*set trace on
	use "`myfiles'" in `i', clear
	local f=file
	erase "`f'"
}

****************************************
* END
