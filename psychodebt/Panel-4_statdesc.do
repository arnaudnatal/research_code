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








*************************************
* Stat desc
*************************************
use"base_panel_lag", clear



*** Stat desc HH
preserve
duplicates drop HHID_panel, force
tabstat HHsize assets1000 incomeHH1000 shock dummysell villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10, stat(n mean cv p50)

tabstat HHsize assets1000 incomeHH1000 shock dummysell villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 if dalits==0, stat(n mean cv p50)

tabstat HHsize assets1000 incomeHH1000 shock dummysell villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 if dalits==1, stat(n mean cv p50)
restore

*** Stat desc Indiv
tabstat dalits age dummyhead maritalstatus2 dummyedulevel cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_3 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummymultipleoccupation_indiv annualincome_indiv, stat(n mean cv p50)


tabstat dalits age dummyhead maritalstatus2 dummyedulevel cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_3 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummymultipleoccupation_indiv annualincome_indiv if female==0, stat(n mean cv p50)

tabstat dalits age dummyhead maritalstatus2 dummyedulevel cat_mainocc_occupation_indiv_1 cat_mainocc_occupation_indiv_2 cat_mainocc_occupation_indiv_3 cat_mainocc_occupation_indiv_4 cat_mainocc_occupation_indiv_5 cat_mainocc_occupation_indiv_6 cat_mainocc_occupation_indiv_7 dummymultipleoccupation_indiv annualincome_indiv if female==1, stat(n mean cv p50)


*** Stat desc Y
preserve
replace s_loanamount=. if s_loanamount==0
tabstat s_indebt2020 s_loanamount s_borrservices_none2020 s_dummyproblemtorepay2020, stat(n mean cv p50)
tabstat s_indebt2020 s_loanamount s_borrservices_none2020 s_dummyproblemtorepay2020 if female==0, stat(n mean cv p50)
tabstat s_indebt2020 s_loanamount s_borrservices_none2020 s_dummyproblemtorepay2020 if female==1, stat(n mean cv p50)
restore

*** Stat desc ptcs
set graph off
twoway ///
(kdensity base_f1_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f1_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("ES (std)") legend(order(1 "Male" 2 "Female") pos(6) col(2) off) name(gph1, replace)

twoway ///
(kdensity base_f2_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f2_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("CO (std)") name(gph2, replace)

twoway ///
(kdensity base_f3_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f3_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("OP-EX (std)") name(gph3, replace)

twoway ///
(kdensity base_f5_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_f5_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("AG (std)") name(gph4, replace)

twoway ///
(kdensity base_raven_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_raven_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Rav (std)") name(gph5, replace)

twoway ///
(kdensity base_num_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_num_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Num (std)") name(gph6, replace)

twoway ///
(kdensity base_lit_tt_std if female==0, lp(solid) lcolor(black)) ///
(kdensity base_lit_tt_std if female==1, lp(dash) lcolor(black)) ///
, ytitle("Density") xtitle("Lit (std)") name(gph7, replace)

grc1leg gph1 gph2 gph3 gph4 gph5 gph6 gph7, col(4) name(ptcs, replace)
set graph on
graph export "ptcs.pdf", as(pdf) replace


*************************************
* END
