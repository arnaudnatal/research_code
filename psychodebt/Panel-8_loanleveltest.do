*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2022
*-----
gl link = "psychodebt"
*Poster
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Loandata base
****************************************


********** Macro
global intfem fem_base_f1_std fem_base_f2_std fem_base_f3_std fem_base_f5_std fem_base_raven_tt_std fem_base_lit_tt_std fem_base_num_tt_std

global intdal dal_base_f1_std dal_base_f2_std dal_base_f3_std dal_base_f5_std dal_base_raven_tt_std dal_base_lit_tt_std dal_base_num_tt_std

global three thr_base_f1_std thr_base_f2_std thr_base_f3_std thr_base_f5_std thr_base_raven_tt_std thr_base_lit_tt_std thr_base_num_tt_std

global efa base_f1_std base_f2_std base_f3_std base_f5_std

global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1

global hhcontrol4 assets1000_1 hhsize_1 shock_1 covsell incomeHH1000_1

global villagesFE villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10




use"NEEMSIS2-newloans_v5.dta", clear

drop version_HH sex caste jatis edulevel egoid loan_database borrowerid year

merge m:1 HHID_panel INDID_panel using "panel_wide_v4", keepusing($intfem $intdal $three $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalit femXdal indebt_indiv_1)

keep if _merge==3
drop _merge

preserve
duplicates drop HHID_panel INDID_panel, force
ta HHID_panel
restore

egen HHINDID_panel=concat(HHID_panel INDID_panel), p(/)
fre HHINDID_panel
encode HHINDID_panel, gen(HHINDID)


********** Sex, caste
gen dummyssex=0
replace dummyssex=1 if lendersex==1 & female==0
replace dummyssex=1 if lendersex==2 & female==1

gen dummyscaste=0
replace dummyscaste=1


********** Test econo 1


local i=0
foreach x in otherlenderservices_none borrowerservices_none dummyproblemtorepay dummyhelptosettleloan guarantee_none {
local i=`i'+1
qui probit `x' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE ///
c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits ///
, vce(cluster HHINDID)
est store m`i'
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans
}

esttab m1 m2 m3



********** Test econo 2
cls
foreach x in borrowerservices_none dummyproblemtorepay dummyhelptosettleloan guarantee_none {
foreach i in 0 1 {
foreach j in 0 1 {
qui probit `x' indebt_indiv_1 $indivcontrol $hhcontrol4 $villagesFE ///
base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std ///
if female==`i' & dalits==`j' ///
, vce(cluster HHINDID)
margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) atmeans
}
}
}




****************************************
* END
