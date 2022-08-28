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
* New tests
****************************************
use"panel_wide_v4.dta", clear


global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1
global hhcontrol4 assets1000_1 hhsize_1 shock_1 covsell incomeHH1000_1
global villagesFE villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10


********** Aggregte measure of crystallised intelligence
fre num_tt_1
fre lit_tt_1
gen cryst=num_tt_1+lit_tt_1
fre cryst
egen base_cryst_std=std(cryst)


foreach x in indebt_indiv_2 borrowerservices_none guarantee_none dummyproblemtorepay dummyhelptosettleloan {
foreach i in 0 1 {
foreach j in 0 1 {
ta `x' if female==`i' & dalits==`j'
}
}
}







cls
foreach x in indebt_indiv_2 borrowerservices_none guarantee_none dummyproblemtorepay dummyhelptosettleloan {


probit `x' indebt_indiv_1 ///
$indivcontrol $hhcontrol4 $villagesFE ///
female dalits ///
, vce(cluster HHFE)

probit `x' indebt_indiv_1 ///
$indivcontrol $hhcontrol4 $villagesFE ///
female dalits ///
base_f1_std base_f2_std base_f3_std base_f5_std ///
base_raven_tt_std base_cryst_std ///
, vce(cluster HHFE)



***** Interracted variables
probit `x' indebt_indiv_1 ///
$indivcontrol $hhcontrol4 $villagesFE ///
c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits ///
c.base_raven_tt_std##i.female##i.dalits c.base_cryst_std##i.female##i.dalits ///
, vce(cluster HHFE)

margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_cryst_std) at(dalits=(0 1) female=(0 1)) atmeans





***** Subsample
foreach i in 0 1 {
foreach j in 0 1 {
qui probit `x' indebt_indiv_1 ///
$indivcontrol $hhcontrol4 $villagesFE ///
female dalits ///
base_f1_std base_f2_std base_f3_std base_f5_std ///
base_raven_tt_std base_cryst_std ///
if female==`i' & dalits==`j' ///
, vce(cluster HHFE)
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_cryst_std) atmeans
}
}


}




