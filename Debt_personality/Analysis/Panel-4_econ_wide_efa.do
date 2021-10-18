cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits & debt AT INDIVIDUAL LEVEL in wide
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
global git "C:\Users\Arnaud\Documents\GitHub"
global dropbox "C:\Users\Arnaud\Dropbox"


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








****************************************
* Préparation database
****************************************
use"panel_wide_v3.dta", clear

tab debtpath

/*
********** Vérification instrument pour procédure Heckman
*** Debtor ratio
reg c.debtorratio2_2 i.indebt_indiv_2
est store indebt
reg c.debtorratio2_2 c.loanamount_indiv1000_2
est store loan
reg c.debtorratio2_2 c.DSR_indiv_2
est store dsr

esttab indebt loan dsr using "_reg.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3 3)) ///
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
export excel using "IMR_check.xlsx", sheet("IMR", replace)
restore


***Graph
set graph off
twoway (scatter debtorratio2_2 indebt_indiv_2, msize(*0.5)), xlabel(0(1)1, labsize(vsmall)) ylabel(,labsize(vsmall)) xmtick(-.5(2)1.5) ytitle("Debtor ratio", size(small)) xtitle("Indebted (=1)", size(small)) note("t-stat=-8.55", size(vsmall)) name(g_indebt1, replace)
twoway (scatter debtorratio2_2 indebt_indiv_2 if debtorratio2_2<1, msize(*0.5)), xlabel(0(1)1, labsize(vsmall)) ylabel(,labsize(vsmall)) xmtick(-.5(2)1.5) ytitle("Debtor ratio", size(small)) xtitle("Indebted (=1)", size(small)) note("If debtor ratio<1", size(vsmall)) name(g_indebt2, replace)
twoway (scatter debtorratio2_2 loanamount_indiv1000_2, msize(*0.5)), xlabel(0(400)2600, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Loan amount (1,000 INR)", size(small)) note("Correlation = -0.02, p-value=0.54", size(vsmall)) name(g_loan1, replace)
twoway (scatter debtorratio2_2 loanamount_indiv1000_2 if loanamount_indiv1000_2<400, msize(*0.5)), xlabel(0(50)400, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Loan amount (1,000 INR)", size(small)) note("If loan amount<400", size(vsmall)) name(g_loan2, replace)
twoway (scatter debtorratio2_2 DSR_indiv_2, msize(*0.5)), xlabel(0(1000)6000, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Debt service ratio", size(small)) note("Correlation = 0.01, p-value=0.72", size(vsmall)) name(g_dsr1, replace)
twoway (scatter debtorratio2_2 DSR_indiv_2 if DSR_indiv_2<500, msize(*0.5)), xlabel(0(50)500, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Debtor ratio", size(small)) xtitle("Debt service ratio", size(small)) note("If DSR<500", size(vsmall)) name(g_dsr2, replace)

graph combine g_indebt1 g_indebt2 g_loan1 g_loan2 g_dsr1 g_dsr2, col(2)
graph export "$git\RUME-NEEMSIS\Big-5\imr_check.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\imr_check.pdf", as(pdf) replace
set graph on
*/


********** Macro
global intfem fem_base_factor_imraw_1_std fem_base_factor_imraw_2_std fem_base_factor_imraw_3_std fem_base_factor_imraw_4_std fem_base_factor_imraw_5_std fem_base_raven_tt_std fem_base_num_tt_std fem_base_lit_tt_std

global intdal dal_base_factor_imraw_1_std dal_base_factor_imraw_2_std dal_base_factor_imraw_3_std dal_base_factor_imraw_4_std dal_base_factor_imraw_5_std dal_base_raven_tt_std dal_base_num_tt_std dal_base_lit_tt_std

global three threeway_base_factor_imraw_1_std threeway_base_factor_imraw_2_std threeway_base_factor_imraw_3_std threeway_base_factor_imraw_4_std threeway_base_factor_imraw_5_std threeway_base_raven_tt_std threeway_base_num_tt_std threeway_base_lit_tt_std

global efa base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std

global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1

global indivcontrol2 age_1 agesq_1 dummyhead_1 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 cat_mainoccupation_indiv_1_5 edulevel_1 maritalstatus2_1 dummymultipleoccupation_indiv_1

global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1

global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai

global big5 base_cr_OP_std base_cr_CO_std base_cr_EX_std base_cr_AG_std base_cr_ES_std



********** Label
forvalues i=1(1)5{
label var fem_base_factor_imraw_`i'_std "Female X F`i' (std)"
label var dal_base_factor_imraw_`i'_std "Dalit X F`i' (std)"
label var threeway_base_factor_imraw_`i'_std "Dalit X Female X F`i' (std)"
}
label var fem_base_raven_tt_std "Female X Raven (std)"
label var dal_base_raven_tt_std "Dalit X Raven (std)"
label var threeway_base_raven_tt_std "Dalit X Female X Raven (std)"
label var fem_base_num_tt_std "Female X Numeracy (std)"
label var dal_base_num_tt_std "Dalit X Numeracy (std)"
label var threeway_base_num_tt_std "Dalit X Female X Numeracy (std)"
label var fem_base_lit_tt_std "Female X Literacy (std)"
label var dal_base_lit_tt_std "Dalit X Literacy (std)"
label var threeway_base_lit_tt_std "Dalit X Female X Literacy (std)"
label var femXdal "Female X Dalit"
label var debtorratio2_1 "Debtor ratio in 2016-17"
label var indebt_indiv_1 "Indebted (=1) in 2016-17"

label var base_factor_imraw_1_std "F1 - OP-EX (std)"
label var base_factor_imraw_2_std "F2 - CO (std)"
label var base_factor_imraw_3_std "F3 - Porupillatavan (std)"
label var base_factor_imraw_4_std "F4 - ES (std)"
label var base_factor_imraw_5_std "F5 - AG (std)"


********** ER test
*Distance
tab mainoccupation_distance_indiv_1
recode mainoccupation_distance_indiv_1 (-5=0)

*Debtor
tab debtorratio2_1

*Network size
fre nbercontactphone_1 nbercontactphone_2

tab nbercontactphone_1 indebt_indiv_2, col nofreq
tab nbercontactphone_2 indebt_indiv_2, col nofreq

recode nbercontactphone_1 (9=7) (.=7)
fre nbercontactphone_1 
gen dummyphone=nbercontactphone_1
recode dummyphone (7=0) (2=1) (3=1) (4=1) (5=1) (6=1)
tab dummyphone
fre nbercontactphone_1
clonevar nbercontact=nbercontactphone_1
recode nbercontact (2=1) (5=4) (6=4)
tab nbercontact

fre sum_ext_HH_1
clonevar dummy_ext_HH_1=sum_ext_HH_1
replace dummy_ext_HH_1=1 if dummy_ext_HH_1>1
tab dummy_ext_HH_1

*Contactlist
egen nb_contact_impt=rowtotal(nbcontact_headbusiness_1 nbcontact_policeman_1 nbcontact_civilserv_1 nbcontact_bankemployee_1 nbcontact_panchayatcommittee_1 nbcontact_peoplecouncil_1 nbcontact_recruiter_1 nbcontact_headunion_1)

tab nb_contact_impt
foreach x in nbcontact_headbusiness_1 nbcontact_policeman_1 nbcontact_civilserv_1 nbcontact_bankemployee_1 nbcontact_panchayatcommittee_1 nbcontact_peoplecouncil_1 nbcontact_recruiter_1 nbcontact_headunion_1 {
replace `x'=1 if `x'>1 & `x'!=.
recode `x' (.=0)
}
cls
tab1 nbcontact_headbusiness_1 nbcontact_policeman_1 nbcontact_civilserv_1 nbcontact_bankemployee_1 nbcontact_panchayatcommittee_1 nbcontact_peoplecouncil_1 nbcontact_recruiter_1 nbcontact_headunion_1
egen contact_impt=rowtotal(nbcontact_headbusiness_1 nbcontact_policeman_1 nbcontact_civilserv_1 nbcontact_bankemployee_1 nbcontact_panchayatcommittee_1 nbcontact_peoplecouncil_1 nbcontact_recruiter_1 nbcontact_headunion_1)
replace contact_impt=1 if contact_impt>1
tab contact_impt

*Associationlist
tab associationlist_1
gen dummyassociation=0 if associationlist_1=="13" & associationlist_1!=""
replace dummyassociation=1 if associationlist_1!="13" & associationlist_1!=""
recode dummyassociation (.=0)
tab dummyassociation

*Nberevents
tab nberpersonfamilyevent_1

*Trust
cls
fre networkhelpkinmember_1 trustneighborhood_1 trustemployees_1 networkpeoplehelping_1
recode trustneighborhood_1 trustemployees_1 networkpeoplehelping_1 networkhelpkinmember_1 (99=.)
recode networkhelpkinmember_1 trustemployees_1 trustneighborhood_1 networkpeoplehelping_1 (1=5) (2=4) (3=3) (4=2) (5=1)

egen trustreciprocity_1=rowtotal(networkhelpkinmember_1 trustemployees_1 trustneighborhood_1 networkpeoplehelping_1)
egen trustreciprocity_2=rowtotal(networkhelpkinmember_1 trustemployees_1)
egen trustreciprocity_3=rowtotal(networkhelpkinmember_1 trustneighborhood_1)
egen trustreciprocity_4=rowtotal(networkhelpkinmember_1 networkpeoplehelping_1)

tab trustreciprocity_1
****************************************
* END










****************************************
* Analysis
****************************************
********** 1.
********** Proba of being in debt, or overindebted, interest in t+1
qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
est store res_1
*predict probitxb_noint, xb
*ge pdf_noint=normalden(probitxb_noint)
*ge cdf_noint=normal(probitxb_noint)
*ge imr_noint=pdf_noint/cdf_noint

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHFE)
est store res_2
*predict probitxb_intfem, xb
*ge pdf_intfem=normalden(probitxb_intfem)
*ge cdf_intfem=normal(probitxb_intfem)
*ge imr_intfem=pdf_intfem/cdf_intfem

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHFE)
est store res_3
*predict probitxb_intdal, xb
*ge pdf_intdal=normalden(probitxb_intdal)
*ge cdf_intdal=normal(probitxb_intdal)
*ge imr_intdal=pdf_intdal/cdf_intdal

qui probit indebt_indiv_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_4
*predict probitxb_three, xb
*ge pdf_three=normalden(probitxb_three)
*ge cdf_three=normal(probitxb_three)
*ge imr_three=pdf_three/cdf_three

esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 3 3 3 3) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) /// //starlevels(* 0.10 ** 0.05 *** 0.01) ///
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
export excel using "Probit_indebt.xlsx", sheet("Indebt", replace)
restore


*********** Marges
cls
foreach x in indebt_indiv {
*** No int
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_`x'1, replace)
*marginscontplot base_factor_imraw_1_std base_factor_imraw_2_std, ci at(dalits=(0) female=(0))

*** Female
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_`x'2, replace)
*marginsplot, yline(0) level(95) xlabel(,angle(45)) name(`x'_2, replace)

*** Dalits
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_`x'3, replace)
*marginsplot, yline(0) level(95) xlabel(,angle(45)) name(`x'_3, replace)

*** Three
qui probit `x'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_`x'4, replace)
*marginsplot, yline(0) level(95) xlabel(,angle(45)) name(`x'_4, replace)
}


********** Label IMR
*label var imr_noint "IMR (no int)"
*label var imr_intfem "IMR (gender int)"
*label var imr_intdal "IMR (caste int)"
*label var imr_three "IMR (gender and caste int)"

****************************************
* END














****************************************
* Analysis
****************************************
********** 2.
********** Level of debt in t+1
cls
foreach var in loanamount_indiv1000 DSR_indiv {
qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, vce(cluster HHFE)
est store res_1

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem if indebt_indiv_2==1, vce(cluster HHFE)
est store res_2

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal if indebt_indiv_2==1, vce(cluster HHFE)
est store res_3

qui reg `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three if indebt_indiv_2==1, vce(cluster HHFE)
est store res_4

esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 3 3 3 3) labels(`"Observations"' `"\$R^2$"' `"Adjusted \$R^2$"' `"F-stat"' `"p-value"')) ///
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
export excel using "OLS_indebt.xlsx", sheet("`var'", replace)
restore

********** Margins

*** No int
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female if indebt_indiv_2==1, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_`var'1, replace)

*** Female
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits if indebt_indiv_2==1, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_`var'2, replace)

*** Dalits
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female if indebt_indiv_2==1, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_`var'3, replace)

*** Three
qui reg `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits if indebt_indiv_2==1, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_`var'4, replace)
}
****************************************
* END
















****************************************
* Analysis
****************************************
********** 4.
********** Level of debt in t+1 
cls
foreach var in loanamount_indiv1000 DSR_indiv {
foreach quant in 10 25 50 75 90 {
qui qreg2 `var'_2 indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits if indebt_indiv_2==1, cluster(HHFE) q(.`quant')
est store res_`quant'

esttab res_`quant' using "_reg_`var'.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N sum_adev sum_rdev r2, fmt(0 3 3 3) labels(`"Observations"' `"\$\sum$|Dev|"' `"\$\sum$Dev"' `"\$R^2$"')) ///
	replace
estimates clear

preserve
import delimited "_reg_`var'.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "QREG_indebt.xlsx", sheet("`var'_`quant'", replace)
restore
}

********** Margin
foreach quant in 10 25 50 75 90 {
qui qreg2 `var'_2 indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std dalits female if indebt_indiv_2==1, cluster(HHFE) q(.`quant')
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_qreg_`quant'_`var', replace)
}
}

set graph off
foreach y in loanamount_indiv1000_2 DSR_indiv_2 {
foreach x in base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std {
preserve
tempname memhold
tempfile results
postfile `memhold' q b cilow95 cihigh95 cilow90 cihigh90 using `results'
local laby="`: var label `x''"
forv i = .1(.1).9 {
qui qreg2 `y' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std dalits female if indebt_indiv_2==1, cluster(HHFE) q(`i')
	local b = _b[`x']
    local cilow90  = _b[`x']-_se[`x']*invttail(e(df_r),.05)    
    local cihigh90  = _b[`x']+_se[`x']*invttail(e(df_r),.05)    
    local cilow95  = _b[`x']-_se[`x']*invttail(e(df_r),.025)    
    local cihigh95  = _b[`x']+_se[`x']*invttail(e(df_r),.025)    
    post `memhold' (`i') (`b') (`cilow90') (`cihigh90') (`cilow95') (`cihigh95')
}
postclose `memhold'
use `results', clear
twoway ///
(rarea cihigh90 cilow90 q, fcolor(%5)) ///
(rarea cihigh95 cilow95 q, fcolor(%5)) ///
(line b q, yline(0, lcolor(black) lpattern(solid) lwidth(0.1))) ///
, xtitle("Quantile") legend(order(1 "95% cl" 2 "90% cl" 3 "Coef.") col(3) pos(6)) xlabel(.1(.1).9) title("`laby'", size(large)) aspectratio(0.5) scale(0.7) name(g_`x', replace)
restore
}
grc1leg g_base_factor_imraw_1_std g_base_factor_imraw_2_std g_base_factor_imraw_3_std g_base_factor_imraw_4_std g_base_factor_imraw_5_std g_base_raven_tt_std g_base_num_tt_std g_base_lit_tt_std, leg(g_base_factor_imraw_1_std) name(g_`y', replace) note("`y'", size(half_tiny))
graph save "qreg_`y'.gph", replace
graph export "qreg_`y'.pdf", as(pdf) replace
}
set graph on

****************************************
* END












/*


****************************************
* Analysis
****************************************
********** 3.
********** Path of debt
cls
foreach var in debtpath {

qui mprobit `var' $efa $cog $indivcontrol $hhcontrol4 female dalits, vce(cluster HHFE)
est store res_1

qui mprobit `var' $efa $cog $indivcontrol $hhcontrol4 female dalits $intfem, vce(cluster HHFE)
est store res_2

qui mprobit `var' $efa $cog $indivcontrol $hhcontrol4 female dalits $intdal, vce(cluster HHFE)
est store res_3

qui mprobit `var' $efa $cog $indivcontrol $hhcontrol4 female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_5

esttab res_1 res_2 res_3 res_5 using "_reg.csv", ///
	cells(b(fmt(3)) /// 
	t(par fmt(3))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N ll chi2 p, fmt(0 3 3 3) labels(`"Observations"' `"Log-likelihood"' `"\$\upchi^2$"' `"p-value"')) ///
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
export excel using "MProbit_indebt.xlsx", sheet("`var'", replace)
restore


********** Margins

*** No int
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_factor_imraw_1_std c.base_factor_imraw_2_std c.base_factor_imraw_3_std c.base_factor_imraw_4_std c.base_factor_imraw_5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_`var'1, replace)

*** Female
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_factor_imraw_1_std##i.female c.base_factor_imraw_2_std##i.female c.base_factor_imraw_3_std##i.female c.base_factor_imraw_4_std##i.female c.base_factor_imraw_5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_`var'2, replace)

*** Dalits
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_factor_imraw_1_std##i.dalits c.base_factor_imraw_2_std##i.dalits c.base_factor_imraw_3_std##i.dalits c.base_factor_imraw_4_std##i.dalits c.base_factor_imraw_5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_`var'3, replace)

*** Three
qui mprobit `var' $indivcontrol $hhcontrol4 c.base_factor_imraw_1_std##i.female##i.dalits c.base_factor_imraw_2_std##i.female##i.dalits c.base_factor_imraw_3_std##i.female##i.dalits c.base_factor_imraw_4_std##i.female##i.dalits c.base_factor_imraw_5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_factor_imraw_1_std base_factor_imraw_2_std base_factor_imraw_3_std base_factor_imraw_4_std base_factor_imraw_5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_`var'4, replace)

}
****************************************
* END


****************************************
* Graph mprobit
****************************************
use"margin_debtpath4", clear
set graph off
forvalues i=1(1)4{
forvalues j=1(1)8{
twoway ///
(line _margin _predict if _at==`i' & _deriv==`j') ///
(rcap _ci_ub _ci_lb _predict if _at==`i' & _deriv==`j'), name(g_`i'_x`j', replace)
}
}
set graph on
grc1leg g_1_x1 g_2_x1 g_3_x1 g_4_x1 g_1_x2 g_2_x2 g_3_x2 g_4_x2  g_1_x3 g_2_x3 g_3_x3 g_4_x3  g_1_x4 g_2_x4 g_3_x4 g_4_x4  g_1_x5 g_2_x5 g_3_x5 g_4_x5  g_1_x6 g_2_x6 g_3_x6 g_4_x6  g_1_x7 g_2_x7 g_3_x7 g_4_x7  g_1_x8 g_2_x8 g_3_x8 g_4_x8, col(4)


****************************************
* END





/*
********** Lancer les autres C:\Users\Arnaud\Documents\GitHub\Analysis\Personality\Analysis
do "$git\Analysis\Personality\Analysis\Panel-4_econ_wide_big5"
do "$git\Analysis\Personality\Analysis\Panel-5_econ_long"
do "$git\Analysis\Personality\Analysis\Panel-6_formatting"
*/
