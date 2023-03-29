*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 13, 2021
*-----
gl link = "psychodebt"
*New var
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------






/*
Rob4:
Multicolineraty
Overfit
*/






*************************************
* Multicolinearity
*************************************
use"panel_wide_v3", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits




********** Reco
qui reg s_indebt2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
vif
qui reg s_indebt2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
vif
qui reg s_indebt2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
vif
qui reg s_indebt2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
vif
qui reg s_indebt2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
vif


********** Nego
qui reg s_borrservices_none2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest , cluster(HHID)
vif
qui reg s_borrservices_none2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
vif
qui reg s_borrservices_none2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
vif
qui reg s_borrservices_none2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
vif
qui reg s_borrservices_none2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
vif


********** Mana
qui reg s_dummyproblemtorepay2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
vif

qui reg s_dummyproblemtorepay2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
vif

qui reg s_dummyproblemtorepay2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
vif

qui reg s_dummyproblemtorepay2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
vif

qui reg s_dummyproblemtorepay2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
vif

*************************************
* END













*************************************
* Overfit
*************************************
use"panel_wide_v3", clear


*** Macro
global PTCS base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std i.female i.dalits

global PTCSma base_f1_std base_f2_std base_f3_std base_f5_std base_raven_tt_std base_num_tt_std base_lit_tt_std

global XIndiv age dummyhead cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummyedulevel maritalstatus2

global XHH assets1000 HHsize incomeHH1000

global Xrest villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 shock

global intfem c.base_f1_std##i.female c.base_f2_std##i.female c.base_f3_std##i.female c.base_f5_std##i.female c.base_raven_tt_std##i.female c.base_num_tt_std##i.female c.base_lit_tt_std##i.female i.dalits

global intdal c.base_f1_std##i.dalits c.base_f2_std##i.dalits c.base_f3_std##i.dalits c.base_f5_std##i.dalits c.base_raven_tt_std##i.dalits c.base_num_tt_std##i.dalits c.base_lit_tt_std##i.dalits i.female

global inttot c.base_f1_std##i.female##i.dalits c.base_f2_std##i.female##i.dalits c.base_f3_std##i.female##i.dalits c.base_f5_std##i.female##i.dalits c.base_raven_tt_std##i.female##i.dalits c.base_num_tt_std##i.female##i.dalits c.base_lit_tt_std##i.female##i.dalits


cls
********** Reco
overfit: probit s_indebt2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
overfit: probit s_indebt2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_indebt2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_indebt2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_indebt2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 


********** Nego
overfit: probit s_borrservices_none2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
overfit: probit s_borrservices_none2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_borrservices_none2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_borrservices_none2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_borrservices_none2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 

********** Mana
overfit: probit s_dummyproblemtorepay2020 indebt_indiv i.female i.dalits $XIndiv $XHH $Xrest, cluster(HHID)
overfit: probit s_dummyproblemtorepay2020 indebt_indiv $PTCS $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_dummyproblemtorepay2020 indebt_indiv $intfem $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_dummyproblemtorepay2020 indebt_indiv $intdal $XIndiv $XHH $Xrest, cluster(HHID) 
overfit: probit s_dummyproblemtorepay2020 indebt_indiv $inttot $XIndiv $XHH $Xrest, cluster(HHID) 
*************************************
* END
