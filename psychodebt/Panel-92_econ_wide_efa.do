*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*Econ
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------




****************************************
* Recourse
****************************************
use"panel_wide_v4.dta", clear


********** Macro
global indivcontrol c.age_1##c.age_1 dummyhead_1 ib(3).mainocc_occupation_indiv_1 dummyedulevel maritalstatus2_1

global hhcontrol assets1000_1 hhsize_1 incomeHH1000_1 shock_1 i.villageid
*covsell


********** No int
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
est store res_1

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_indebt_indiv_21, replace)



********** Sex
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
est store res_2

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_indebt_indiv_22, replace)



********** Dalits
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
est store res_3

*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_indebt_indiv_23, replace)



********** Three
probit indebt_indiv_2 indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
est store res_4

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_indebt_indiv_24, replace)



********** Table
esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
estimates clear

preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("recourse", replace)
restore

****************************************
* END
















****************************************
* Negotiation
****************************************
use"panel_wide_v4.dta", clear


********** Macro
global indivcontrol c.age_1##c.age_1 dummyhead_1 ib(3).mainocc_occupation_indiv_1 dummyedulevel maritalstatus2_1
*c.share_nb_samesex c.share_nb_samecaste

global hhcontrol assets1000_1 hhsize_1 incomeHH1000_1 shock_1 i.villageid
*covsell


********** No int
probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
est store res_1

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_borrowerservices_none1, replace)



********** Sex
probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
est store res_2

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_borrowerservices_none2, replace)



********** Dalits
probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
est store res_3

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_borrowerservices_none3, replace)



********** Three
probit borrowerservices_none indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
est store res_4

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_borrowerservices_none4, replace)




********** Table
esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
estimates clear

preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("negotiation", replace)
restore

****************************************
* END










****************************************
* Management
****************************************
use"panel_wide_v4.dta", clear


********** Macro
global indivcontrol c.age_1##c.age_1 dummyhead_1 ib(3).mainocc_occupation_indiv_1 dummyedulevel maritalstatus2_1
*c.loanamount_indiv

global hhcontrol assets1000_1 hhsize_1 incomeHH1000_1 shock_1 i.villageid
*covsell


********** No int
probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
est store res_1

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_dummyproblemtorepay1, replace)



********** Sex
probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
est store res_2

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_dummyproblemtorepay2, replace)



********** Dalits
probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
est store res_3

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_dummyproblemtorepay3, replace)



********** Three
probit dummyproblemtorepay indebt_indiv_1 $indivcontrol $hhcontrol c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
est store res_4

*dy/dx
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_dummyproblemtorepay4, replace)



********** Table
esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	
estimates clear

preserve
import delimited "_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "Probit_indebt.xlsx", sheet("management", replace)
restore


****************************************
* END














****************************************
* Format magins
****************************************
foreach x in $yvar {

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

replace All="Average individual" if n==0
replace Male="Average male" if n==0
replace Female="Average female" if n==0
replace Midup="Average non-Dalit" if n==0
replace Dalit="Average Dalit" if n==0
replace Midup_male="Average non-Dalit male" if n==0
replace Dalit_male="Average Dalit male" if n==0
replace Midup_female="Average non-Dalit female" if n==0
replace Dalit_female="Average Dalit female" if n==0

replace deriv="ES (std)" if deriv=="A1"
replace deriv="CO (std)" if deriv=="A2"
replace deriv="OP-EX (std)" if deriv=="A3"
replace deriv="AG (std)" if deriv=="A5"

drop n
export excel using "Margins_probit.xlsx", sheet("`x'", replace) 
}
****************************************
* END







****************************************
* Clean dta file
****************************************

filelist, dir("$directory") pattern(*.dta)
split filename, p(_)
keep if ///
filename1=="margin" | ///
filename2=="temp"
drop filename1 filename2 filename3 filename4

egen file=concat(dirname filename), p(\)
keep file

tempfile myfiles
save "`myfiles'"
local obs=_N
forvalues i=1/`obs' {
	use "`myfiles'" in `i', clear
	local f=file
	erase "`f'"
}

****************************************
* END



