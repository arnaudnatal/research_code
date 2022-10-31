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

********** Macro for merging
global intfem fem_base_f1_std fem_base_f2_std fem_base_f3_std fem_base_f5_std fem_base_raven_tt_std fem_base_lit_tt_std fem_base_num_tt_std

global intdal dal_base_f1_std dal_base_f2_std dal_base_f3_std dal_base_f5_std dal_base_raven_tt_std dal_base_lit_tt_std dal_base_num_tt_std

global three thr_base_f1_std thr_base_f2_std thr_base_f3_std thr_base_f5_std thr_base_raven_tt_std thr_base_lit_tt_std thr_base_num_tt_std

global efa base_f1_std base_f2_std base_f3_std base_f5_std

global cog base_raven_tt_std base_num_tt_std base_lit_tt_std

global indivcontrol age_1 agesq_1 dummyhead_1 cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyedulevel maritalstatus2_1

global hhcontrol4 assets1000_1 hhsize_1 shock_1 covsell incomeHH1000_1

global villagesFE villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10



********** Open loan database
use"NEEMSIS2-newloans_v5.dta", clear

drop version_HH sex caste jatis edulevel egoid borrowerid year


********** Merge Control var and PTCS
merge m:1 HHID_panel INDID_panel using "panel_wide_v4", keepusing($intfem $intdal $three $efa $cog $indivcontrol $hhcontrol4 $villagesFE female dalit femXdal indebt_indiv_1)

keep if _merge==3
drop _merge


********** Check nb of obs
bysort HHID_panel INDID_panel: gen count=_n
replace count=. if count>1
ta count
drop count

bysort HHID_panel: gen count=_n
replace count=. if count>1
ta count
drop count


save"NEEMSIS2-loans_PTCS_v1.dta", replace
****************************************
* END












****************************************
* Loandata base --> keep informal loans and new var
****************************************
use"NEEMSIS2-loans_PTCS_v1.dta", clear


********** Informal loan
fre loanlender
fre lender_cat
ta loanlender loan_database, m
*replace loanlender=6 if loanlender==. & loan_database=="GOLD"

fre lender4
ta lender4 loan_database, m
*replace lender4=5 if lender4==. & loan_database=="GOLD"

tab loanlender lender_cat
tab lender4 lender_cat

drop if lender_cat==3


********** HHINDID unique
egen HHINDID_panel=concat(HHID_panel INDID_panel), p(/)
fre HHINDID_panel
encode HHINDID_panel, gen(HHINDID)



********** Charact of the lender: is the same caste? same sex?
gen dummyssex=0
replace dummyssex=1 if lendersex==1 & female==0
replace dummyssex=1 if lendersex==2 & female==1

gen dummyscaste=0
replace dummyscaste=1 if 



********** Test effectif
fre borrowerservices_none
fre dummyproblemtorepay

ta borrowerservices_none loan_database, m

drop if borrowerservices_none==.

fre borrowerservices_none
fre dummyproblemtorepay


save"NEEMSIS2-loans_PTCS_v2.dta", replace
****************************************
* END










****************************************
* ECONO
****************************************
use"NEEMSIS2-loans_PTCS_v2.dta", clear



********** XT
xtset HHINDID

xtprobit borrowerservices_none base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std dummyscaste female age_1 indebt_indiv_1 dummyedulevel cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyhead_1 maritalstatus2_1  dummyssex loanamount hhsize_1 shock_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 assets1000_1 incomeHH1000_1 dalits, vce(cluster HHID_panel)




********** Probit
probit borrowerservices_none base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std dummyscaste female age_1 indebt_indiv_1 dummyedulevel cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyhead_1 maritalstatus2_1  dummyssex loanamount hhsize_1 shock_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 assets1000_1 incomeHH1000_1 dalits, vce(cluster HHINDID)






********** Multilevel model
meprobit borrowerservices_none dummyssex loanamount || HHINDID_panel: base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std dummyscaste female age_1 indebt_indiv_1 dummyedulevel cat_mainocc_occupation_indiv_1_1 cat_mainocc_occupation_indiv_1_2 cat_mainocc_occupation_indiv_1_4 cat_mainocc_occupation_indiv_1_5 cat_mainocc_occupation_indiv_1_6 cat_mainocc_occupation_indiv_1_7 dummyhead_1 maritalstatus2_1





cls
foreach x in otherlenderservices_none borrowerservices_none dummyproblemtorepay dummyhelptosettleloan guarantee_none {

qui probit `x' indebt_indiv_1 loanamount i.reason_cat $indivcontrol $hhcontrol4 $villagesFE ///
c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits ///
, vce(cluster HHINDID)

margins, dydx(base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std) at(dalits=(0 1) female=(0 1)) atmeans
}


********** Negotiation
probit borrowerservices_none indebt_indiv_1 loanamount i.reason_cat $indivcontrol $hhcontrol4 $villagesFE ///
c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits ///
, vce(cluster HHINDID)

overfit: probit borrowerservices_none indebt_indiv_1 loanamount i.reason_cat $indivcontrol $hhcontrol4 $villagesFE ///
c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits ///
, vce(cluster HHINDID)








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
