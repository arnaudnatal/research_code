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
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"


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
* Prepa db
****************************************
use"panel_wide_v3.dta", clear


********** Instrument for Heckman
/*
*** Debtor ratio
reg c.debtorratio2_2 i.indebt_indiv_2
est store indebt
reg c.debtorratio2_2 c.loanamount_indiv1000_2
est store loan
reg c.debtorratio2_2 c.DSR_indiv_2
est store dsr


*** Network
probit dummy_network i.indebt_indiv_2
probit dummy_asso i.indebt_indiv_2
probit dummy_chit i.indebt_indiv_2
probit dummy_shg i.indebt_indiv_2

*** Distance
tab mainoccupation_distance_indiv_1
recode mainoccupation_distance_indiv_1 (-5=0)

*** Network size
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


*** Contactlist
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


*** Associationlist
tab associationlist_1
gen dummyassociation=0 if associationlist_1=="13" & associationlist_1!=""
replace dummyassociation=1 if associationlist_1!="13" & associationlist_1!=""
recode dummyassociation (.=0)
tab dummyassociation

*** Nberevents
tab nberpersonfamilyevent_1


*** Trust
cls
fre networkhelpkinmember_1 trustneighborhood_1 trustemployees_1 networkpeoplehelping_1
recode trustneighborhood_1 trustemployees_1 networkpeoplehelping_1 networkhelpkinmember_1 (99=.)
recode networkhelpkinmember_1 trustemployees_1 trustneighborhood_1 networkpeoplehelping_1 (1=5) (2=4) (3=3) (4=2) (5=1)

egen trustreciprocity_1=rowtotal(networkhelpkinmember_1 trustemployees_1 trustneighborhood_1 networkpeoplehelping_1)
egen trustreciprocity_2=rowtotal(networkhelpkinmember_1 trustemployees_1)
egen trustreciprocity_3=rowtotal(networkhelpkinmember_1 trustneighborhood_1)
egen trustreciprocity_4=rowtotal(networkhelpkinmember_1 networkpeoplehelping_1)

tab trustreciprocity_1
*/


********** Macro
global intfem fem_base_f1_std fem_base_f2_std fem_base_f3_std fem_base_f5_std fem_base_raven_tt_std fem_base_lit_tt_std fem_base_num_tt_std

global intdal dal_base_f1_std dal_base_f2_std dal_base_f3_std dal_base_f5_std dal_base_raven_tt_std dal_base_lit_tt_std dal_base_num_tt_std

global three thr_base_f1_std thr_base_f2_std thr_base_f3_std thr_base_f5_std thr_base_raven_tt_std thr_base_lit_tt_std thr_base_num_tt_std

global efa base_f1_std base_f2_std base_f3_std base_f5_std

global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

*global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1 dummymultipleoccupation_indiv_1
global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1


*global hhcontrol4 assets1000_1 sexratiocat_1_1 sexratiocat_1_2 sexratiocat_1_3 hhsize_1 shock_1 incomeHH1000_1
global hhcontrol4 assets1000_1 hhsize_1 shock_1 incomeHH1000_1

global villagesFE near_panruti near_villupur near_tirup near_chengal near_kanchip near_chennai



********** Label

label var fem_base_f1_std "Female*ES (std)"
label var dal_base_f1_std "Dalit*ES (std)"
label var thr_base_f1_std "Dalit*Female*ES (std)"

label var fem_base_f2_std "Female*CO (std)"
label var dal_base_f2_std "Dalit*CO (std)"
label var thr_base_f2_std "Dalit*Female*CO (std)"

label var fem_base_f3_std "Female*OP-EX (std)"
label var dal_base_f3_std "Dalit*OP-EX (std)"
label var thr_base_f3_std "Dalit*Female*OP-EX (std)"

label var fem_base_f5_std "Female*AG (std)"
label var dal_base_f5_std "Dalit*AG (std)"
label var thr_base_f5_std "Dalit*Female*AG (std)"


label var fem_base_raven_tt_std "Female*Raven (std)"
label var dal_base_raven_tt_std "Dalit*Raven (std)"
label var thr_base_raven_tt_std "Dalit*Female*Raven (std)"
label var fem_base_num_tt_std "Female*Numeracy (std)"
label var dal_base_num_tt_std "Dalit*Numeracy (std)"
label var thr_base_num_tt_std "Dalit*Female*Numeracy (std)"
label var fem_base_lit_tt_std "Female*Literacy (std)"
label var dal_base_lit_tt_std "Dalit*Literacy (std)"
label var thr_base_lit_tt_std "Dalit*Female*Literacy (std)"
label var femXdal "Female*Dalit"
label var debtorratio2_1 "Debtor ratio in 2016-17"
label var indebt_indiv_1 "Indebted (=1) in 2016-17"

label var base_f1_std "ES (std)"
label var base_f2_std "CO (std)"
label var base_f3_std "OP-EX (std)"
label var base_f5_std "AG (std)"
****************************************
* END





****************************************
* Y
****************************************

global quali indebt_indiv_2 indiv_interest otherlenderservices_finansupp guarantee_none
 
global qualiml borrowerservices_none plantorepay_borr settleloanstrat_addi dummyproblemtorepay

global quanti DSR_indiv loanamount_indiv ISR_indiv


*** Desc
mdesc $quali $qualiml $quanti
****************************************
* END






****************************************
* PROBIT
****************************************
foreach x in $quali $qualiml{

qui probit `x' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
est store res_1
*predict probitxb_noint, xb
*ge pdf_noint=normalden(probitxb_noint)
*ge cdf_noint=normal(probitxb_noint)
*ge imr_noint=pdf_noint/cdf_noint

qui probit `x' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHFE)
est store res_2
*predict probitxb_intfem, xb
*ge pdf_intfem=normalden(probitxb_intfem)
*ge cdf_intfem=normal(probitxb_intfem)
*ge imr_intfem=pdf_intfem/cdf_intfem

qui probit `x' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHFE)
est store res_3
*predict probitxb_intdal, xb
*ge pdf_intdal=normalden(probitxb_intdal)
*ge cdf_intdal=normal(probitxb_intdal)
*ge imr_intdal=pdf_intdal/cdf_intdal

qui probit `x' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_4
*predict probitxb_three, xb
*ge pdf_three=normalden(probitxb_three)
*ge cdf_three=normal(probitxb_three)
*ge imr_three=pdf_three/cdf_three

esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///
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
export excel using "Probit_indebt.xlsx", sheet("`x'", replace)
restore
}




*********** Marges
cls
foreach x in $quali $qualiml {
*** No int
qui probit `x' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_`x'1, replace)

*** Female
qui probit `x' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_`x'2, replace)

*** Dalits
qui probit `x' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_`x'3, replace)

*** Three
qui probit `x' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_`x'4, replace)
}


********** Label IMR
*label var imr_noint "IMR (no int)"
*label var imr_intfem "IMR (gender int)"
*label var imr_intdal "IMR (caste int)"
*label var imr_three "IMR (gender and caste int)"

****************************************
* END














****************************************
* OLS
****************************************
cls
foreach var in $quanti {
qui reg `var' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits, vce(cluster HHFE)
est store res_1

qui reg `var' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intfem, vce(cluster HHFE)
est store res_2

qui reg `var' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits $intdal, vce(cluster HHFE)
est store res_3

qui reg `var' indebt_indiv_1 $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalits femXdal $intfem $intdal $three, vce(cluster HHFE)
est store res_4

esttab res_1 res_2 res_3 res_4 using "_reg.csv", ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 r2_a F p, fmt(0 2 2 2 2) labels(`"Observations"' `"\$R^2$"' `"Adjusted \$R^2$"' `"F-stat"' `"p-value"')) ///
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
export excel using "OLS_indebt.xlsx", sheet("`var'", replace)
restore
}


********** Margins
cls
foreach var in $quanti {
*** No int
qui reg `var' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std c.base_f2_std c.base_f3_std c.base_f5_std c.base_raven_tt_std c.base_num_tt_std c.base_lit_tt_std dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans saving(margin_`var'1, replace)

*** Female
qui reg `var' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(female=(0 1)) atmeans saving(margin_`var'2, replace)

*** Dalits
qui reg `var' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits female, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1)) atmeans saving(margin_`var'3, replace)

*** Three
qui reg `var' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits, vce(cluster HHFE)
*dy/dx
qui margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans saving(margin_`var'4, replace)
}
****************************************
* END
