cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits: EFA + panel
-----

-------------------------
*/

*ssc install catplot
*ssc install sencode

****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Skills_and_debt\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

set scheme plotplain 

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"



********** Name of the NEEMSIS2 questionnaire version to clean
*global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan "NEEMSIS2-all_loans"
*global loan2 "NEEMSIS2-loans"
****************************************
* END







****************************************
* Loans
****************************************
use"$loan", clear


********** Following Elena cleaning
drop loanamount
drop totalrepaid
drop interestpaid
drop principalpaid
drop loanbalance

rename loanamount3 loanamount
rename totalrepaid3 totalrepaid
rename interestpaid3 interestpaid
rename principalpaid4 principalpaid
rename loanbalance3 loanbalance

drop loanamount2
drop totalrepaid2
drop interestpaid2
drop principalpaid2 principalpaid3
drop loanbalance2

********** For 644
bysort HHID_panel INDID_panel: egen sum_loanamount=sum(loanamount)


********** Only keep loan contract after the measure of personality traits
drop if loanduration_month>48
drop if loansettled==1

********** Only loans with details
*keep if loan_database=="FINANCE"
order HHID_panel INDID_panel

********** Id for ML
gen dummymainloan=0
replace dummymainloan=1 if lenderfirsttime!=.
tab dummymainloan
/*
1630 ML
How much indiv with ML?
*/
bysort HHID_panel INDID_panel: egen dummyml_indiv=sum(dummymainloan)
replace dummyml_indiv=1 if dummyml_indiv>1
fre dummyml_indiv
preserve
duplicates drop HHID_panel INDID_panel, force
ta dummyml_indiv
restore


********** Type of debt
gen typeofdebt=.
label define typeofdebt 0"Good debt" 1"Bad debt", replace
label values typeofdebt typeofdebt

ta loanreasongiven termsofrepayment
replace typeofdebt=0 if termsofrepayment==1 & typeofdebt==.
replace typeofdebt=1 if termsofrepayment==3 & typeofdebt==.

replace typeofdebt=0 if loanreasongiven==1 & typeofdebt==.
replace typeofdebt=0 if loanreasongiven==5 & typeofdebt==.
replace typeofdebt=0 if loanreasongiven==6 & typeofdebt==.
replace typeofdebt=0 if loanreasongiven==7 & typeofdebt==.
replace typeofdebt=0 if loanreasongiven==8 & typeofdebt==.
replace typeofdebt=0 if loanreasongiven==9 & typeofdebt==.
replace typeofdebt=0 if loanreasongiven==11 & typeofdebt==.

replace typeofdebt=1 if loanreasongiven==2 & typeofdebt==.
replace typeofdebt=1 if loanreasongiven==3 & typeofdebt==.
replace typeofdebt=1 if loanreasongiven==4 & typeofdebt==.
replace typeofdebt=1 if loanreasongiven==10 & typeofdebt==.
replace typeofdebt=1 if loanreasongiven==12 & typeofdebt==.

fre typeofdebt
list loanlender loanreasongiven if typeofdebt==.
replace typeofdebt=0 if typeofdebt==.



save"NEEMSIS2-newloans_v1.dta", replace
****************************************
* END














****************************************
* DSR + ISR
****************************************
use"NEEMSIS2-newloans_v1", clear

foreach x in yratepaid monthlyinterestrate debt_service interest_service imp_principal imp1_interest imp1_totalrepaid_year imp1_debt_service imp1_interest_service imp1_ds_tot_indiv imp1_is_tot_indiv imp1_ds_tot_HH imp1_is_tot_HH loans_indiv loanamount_indiv loans_HH loanamount_HH {
rename `x' `x'_tot
}

********** YRATEPAID
*** All loans
gen yratepaid=interestpaid*100/loanamount if loanduration<=365
gen _yratepaid=interestpaid*365/loanduration if loanduration>365
gen _loanamount=loanamount*365/loanduration if loanduration>365
replace yratepaid=_yratepaid*100/_loanamount if loanduration>365
drop _loanamount _yratepaid

tab yratepaid
sort yratepaid

tabstat yratepaid if interestpaid>0 & interestpaid!=., by(lender4) stat(n mean p50 min max)
gen monthlyinterestrate=.
replace monthlyinterestrate=yratepaid if loanduration<=30.4167
replace monthlyinterestrate=(yratepaid/loanduration)*30.4167 if loanduration>30.4167

/*
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       291  37.15597        30  .8333333       600
   Relatives |        47  30.12433        25         2       144
      Labour |        94  22.58865        19       2.4       108
 Pawn broker |        11  32.16755  29.26829         3       100
Moneylenders |         5  30.46996        30  .9212121  75.42857
     Friends |       453  26.46605        18        .5       950
 Microcredit |       653  24.51787        20       .21  133.3333
        Bank |        90  21.36998  13.80952   .007875       100
     Thandal |        99  11.36322        10         2        65
-------------+--------------------------------------------------
       Total |      1743  26.33695        20   .007875       950
----------------------------------------------------------------

*/



********** IMPUTATION of DS and IS
gen totalrepaid2=totalrepaid
gen interestpaid2=interestpaid


********** Moneylender (.305) and microcredit (0.245)
*** All
gen debt_service=.
replace debt_service=totalrepaid2 if loanduration<=365
replace debt_service=totalrepaid2*365/loanduration if loanduration>365
replace debt_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.

gen interest_service=.
replace interest_service=interestpaid2 if loanduration<=365
replace interest_service=interestpaid2*365/loanduration if loanduration>365
replace interest_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.
replace interest_service=0 if dummyinterest==0 & interestpaid2==0 | dummyinterest==0 & interestpaid2==.

gen imp_principal=.
replace imp_principal=loanamount-loanbalance if loanduration<=365 & debt_service==.
replace imp_principal=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service==.

gen imp1_interest=.
*** Moneylender
replace imp1_interest=0.305*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.305*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
*** Microcredit
replace imp1_interest=0.245*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.245*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
*** Autres
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.

gen imp1_totalrepaid_year=imp_principal+imp1_interest

gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.

gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if interest_service==.

bysort HHID_panel INDID_panel: egen imp1_ds_tot_indiv=sum(imp1_debt_service)
bysort HHID_panel INDID_panel: egen imp1_is_tot_indiv=sum(imp1_interest_service)


save"NEEMSIS2-newloans_v2.dta", replace
****************************************
* END











****************************************
* Continuous
****************************************
use"NEEMSIS2-newloans_v2.dta", clear


********** Amount of loan
bysort HHID_panel INDID_panel: egen loanamount_indiv=sum(loanamount)

*+for caste and sex
gen loanamountcaste=loanamount
replace loanamountcaste=. if lenderscaste==.
bysort HHID_panel INDID_panel: egen sum_loanamountcaste=sum(loanamountcaste)

gen loanamountsex=loanamount
replace loanamountsex=. if lendersex==.
bysort HHID_panel INDID_panel: egen sum_loanamountsex=sum(loanamountsex)


********** Number of loans
bysort HHID_panel INDID_panel: egen nbloan=sum(1)

*+for caste and sex
gen loancaste=1
replace loancaste=. if lenderscaste==.
bysort HHID_panel INDID_panel: egen sum_loancaste=sum(loancaste)

gen loansex=1
replace loansex=. if lendersex==.
bysort HHID_panel INDID_panel: egen sum_loansex=sum(loansex)



********** Nb interest
fre dummyinterest
ta interestpaid dummyinterest, m
gen interestok=1 if interestpaid!=.
bysort HHID_panel INDID_panel: egen indiv_interest=sum(interestok)
replace indiv_interest=1 if indiv_interest>1
preserve
duplicates drop HHID_panel INDID_panel, force
ta indiv_interest
*559
restore
drop interestok


********** Add relation with lender
*** Nb of loans
* Sex
gen same_sex_nb=0 if lendersex!=.
replace same_sex_nb=1 if sex==lendersex & lendersex!=.
ta same_sex_nb
bysort HHID_panel INDID_panel: egen sum_same_sex_nb=sum(same_sex_nb)

* Caste
codebook jatis lenderscaste
label list caste casteemployer
ta jatis caste
fre jatis
clonevar lenderscastecat=lenderscaste
recode lenderscastecat (2=1) (3=1) (1=2) (7=2) (8=2) (10=2) (12=2) (15=2) (16=2) (4=3) (6=3) (11=3) (13=3) (17=3) (5=3) (9=3) (14=3)
label values lenderscastecat castecat
ta lenderscaste lenderscastecat
ta caste lenderscastecat
ta jatis lenderscaste
gen same_caste_nb=0 if lenderscastecat!=.
replace same_caste_nb=1 if caste==lenderscastecat
bysort HHID_panel INDID_panel: egen sum_same_caste_nb=sum(same_caste_nb)
ta same_caste_nb
ta sum_same_caste_nb

*** Loanamount
* Sex
gen same_sex_amt=0
replace same_sex_amt=loanamount if sex==lendersex & lendersex!=.
bysort HHID_panel INDID_panel: egen sum_same_sex_amt=sum(same_sex_amt)

* Caste
gen same_caste_amt=0
replace same_caste_amt=loanamount if caste==lenderscastecat & lenderscastecat!=.
bysort HHID_panel INDID_panel: egen sum_same_caste_amt=sum(same_caste_amt)


*** Share
gen share_nb_samesex=sum_same_sex_nb/sum_loansex
gen share_nb_samecaste=sum_same_caste_nb/sum_loancaste

gen share_amt_samesex=sum_same_sex_amt/sum_loanamountsex
gen share_amt_samecaste=sum_same_caste_amt/sum_loanamountcaste

sum share_nb_samesex share_nb_samecaste share_amt_samesex share_amt_samecaste


*** Croisons
ta caste lenderscastecat


save"NEEMSIS2-newloans_v3.dta", replace
****************************************
* END











****************************************
* Adding dummies ALL LOANS
****************************************
use"NEEMSIS2-newloans_v3.dta", clear

********** Lender service
tab otherlenderservices
gen otherlenderservices_politsupp=0
gen otherlenderservices_finansupp=0
gen otherlenderservices_guarantor=0
gen otherlenderservices_generainf=0
gen otherlenderservices_none=0
gen otherlenderservices_other=0
replace otherlenderservices_politsupp=1 if strpos(otherlenderservices,"1")
replace otherlenderservices_finansupp=1 if strpos(otherlenderservices,"2")
replace otherlenderservices_guarantor=1 if strpos(otherlenderservices,"3")
replace otherlenderservices_generainf=1 if strpos(otherlenderservices,"4")
replace otherlenderservices_none=1 if strpos(otherlenderservices,"5")
replace otherlenderservices_other=1 if strpos(otherlenderservices,"77")



********** Guarantee
ta guarantee
gen guarantee_doc=0
gen guarantee_chittu=0
gen guarantee_shg=0
gen guarantee_perso=0
gen guarantee_jewel=0
gen guarantee_none=0
gen guarantee_other=0

replace guarantee_doc=1 if strpos(guarantee,"1")
replace guarantee_chittu=1 if strpos(guarantee,"2")
replace guarantee_shg=1 if strpos(guarantee,"3")
replace guarantee_perso=1 if strpos(guarantee,"4")
replace guarantee_jewel=1 if strpos(guarantee,"5")
replace guarantee_none=1 if strpos(guarantee,"6")
replace guarantee_other=1 if strpos(guarantee,"77")
fre guarantee_doc guarantee_chittu guarantee_shg guarantee_perso guarantee_jewel guarantee_none guarantee_other



********** Individual scale
foreach x in otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other guarantee_doc guarantee_chittu guarantee_shg guarantee_perso guarantee_jewel guarantee_none guarantee_other {
bysort HHID_panel INDID_panel: egen s_`x'=sum(`x')
replace s_`x'=1 if s_`x'>1
drop `x'
rename s_`x' `x'
}
 

save"NEEMSIS2-newloans_v4.dta", replace
****************************************
* END










****************************************
* Adding dummies ML 
****************************************
use"NEEMSIS2-newloans_v4.dta", clear


********** Borrower services
tab borrowerservices
gen borrowerservices_freeserv=0
gen borrowerservices_worklesswage=0
gen borrowerservices_suppwhenever=0
gen borrowerservices_none=0
gen borrowerservices_other=0
replace borrowerservices_freeserv=1 if strpos(borrowerservices,"1")
replace borrowerservices_worklesswage=1 if strpos(borrowerservices,"2")
replace borrowerservices_suppwhenever=1 if strpos(borrowerservices,"3")
replace borrowerservices_none=1 if strpos(borrowerservices,"4")
replace borrowerservices_other=1 if strpos(borrowerservices,"77")

tab1 borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other


********** Plan to repay
ta plantorepay
gen plantorepay_chit=0
gen plantorepay_work=0
gen plantorepay_migr=0
gen plantorepay_asse=0
gen plantorepay_inco=0
gen plantorepay_borr=0
gen plantorepay_othe=0

replace plantorepay_chit=1 if strpos(plantorepay,"1")
replace plantorepay_work=1 if strpos(plantorepay,"2")
replace plantorepay_migr=1 if strpos(plantorepay,"3")
replace plantorepay_asse=1 if strpos(plantorepay,"4")
replace plantorepay_inco=1 if strpos(plantorepay,"5")
replace plantorepay_borr=1 if strpos(plantorepay,"6")
replace plantorepay_othe=1 if strpos(plantorepay,"77")


********** Settle loan strategy
ta settleloanstrategy
gen settleloanstrat_inco=0
gen settleloanstrat_sche=0
gen settleloanstrat_borr=0
gen settleloanstrat_sell=0
gen settleloanstrat_land=0
gen settleloanstrat_cons=0
gen settleloanstrat_addi=0
gen settleloanstrat_work=0
gen settleloanstrat_supp=0
gen settleloanstrat_harv=0
gen settleloanstrat_othe=0

replace settleloanstrat_inco=1 if strpos(settleloanstrategy,"1")
replace settleloanstrat_sche=1 if strpos(settleloanstrategy,"2")
replace settleloanstrat_borr=1 if strpos(settleloanstrategy,"3")
replace settleloanstrat_sell=1 if strpos(settleloanstrategy,"4")
replace settleloanstrat_land=1 if strpos(settleloanstrategy,"5")
replace settleloanstrat_cons=1 if strpos(settleloanstrategy,"6")
replace settleloanstrat_addi=1 if strpos(settleloanstrategy,"7")
replace settleloanstrat_work=1 if strpos(settleloanstrategy,"8")
replace settleloanstrat_supp=1 if strpos(settleloanstrategy,"9")
replace settleloanstrat_harv=1 if strpos(settleloanstrategy,"10")
replace settleloanstrat_othe=1 if strpos(settleloanstrategy,"77")

fre settleloanstrat_*

********** Loan product pledge
ta loanproductpledge
gen loanproductpledge_gold=0
gen loanproductpledge_land=0
gen loanproductpledge_car=0
gen loanproductpledge_bike=0
gen loanproductpledge_fridge=0
gen loanproductpledge_furnit=0
gen loanproductpledge_tailor=0
gen loanproductpledge_cell=0
gen loanproductpledge_line=0
gen loanproductpledge_dvd=0
gen loanproductpledge_camera=0
gen loanproductpledge_gas=0
gen loanproductpledge_computer=0
gen loanproductpledge_dish=0
gen loanproductpledge_none=0
gen loanproductpledge_other=0

replace loanproductpledge_gold=1 if strpos(loanproductpledge,"1")
replace loanproductpledge_land=1 if strpos(loanproductpledge,"2")
replace loanproductpledge_car=1 if strpos(loanproductpledge,"3")
replace loanproductpledge_bike=1 if strpos(loanproductpledge,"4")
replace loanproductpledge_fridge=1 if strpos(loanproductpledge,"5")
replace loanproductpledge_furnit=1 if strpos(loanproductpledge,"6") 
replace loanproductpledge_tailor=1 if strpos(loanproductpledge,"7") 
replace loanproductpledge_cell=1 if strpos(loanproductpledge,"8") 
replace loanproductpledge_line=1 if strpos(loanproductpledge,"9")
replace loanproductpledge_dvd=1 if strpos(loanproductpledge,"10")
replace loanproductpledge_camera=1 if strpos(loanproductpledge,"11")
replace loanproductpledge_gas=1 if strpos(loanproductpledge,"12")
replace loanproductpledge_computer=1 if strpos(loanproductpledge,"13")
replace loanproductpledge_dish=1 if strpos(loanproductpledge,"14")
replace loanproductpledge_none=1 if strpos(loanproductpledge,"15")
replace loanproductpledge_other=1 if strpos(loanproductpledge,"77")



********** Others dummies
ta dummyproblemtorepay
ta dummyhelptosettleloan
ta dummyrecommendation
ta dummyguarantor



********** Individual scale
foreach x in borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other plantorepay_chit plantorepay_work plantorepay_migr plantorepay_asse plantorepay_inco plantorepay_borr plantorepay_othe settleloanstrat_inco settleloanstrat_sche settleloanstrat_borr settleloanstrat_sell settleloanstrat_land settleloanstrat_cons settleloanstrat_addi settleloanstrat_work settleloanstrat_supp settleloanstrat_harv settleloanstrat_othe loanproductpledge_gold loanproductpledge_land loanproductpledge_car loanproductpledge_bike loanproductpledge_fridge loanproductpledge_furnit loanproductpledge_tailor loanproductpledge_cell loanproductpledge_line loanproductpledge_dvd loanproductpledge_camera loanproductpledge_gas loanproductpledge_computer loanproductpledge_dish loanproductpledge_none loanproductpledge_other dummyproblemtorepay dummyhelptosettleloan dummyrecommendation dummyguarantor {
bysort HHID_panel INDID_panel: egen s_`x'=sum(`x')
replace s_`x'=1 if s_`x'>1 & s_`x'!=. & s_`x'!=0
drop `x'
rename s_`x' `x'
replace `x'=. if dummyml_indiv==0
}


save"NEEMSIS2-newloans_v5.dta", replace
*************************************
* END









*************************************
* To keep
*************************************
use"NEEMSIS2-newloans_v5.dta", clear

keep HHID_panel INDID_panel egoid imp1_ds_tot_indiv imp1_is_tot_indiv      loanamount_indiv nbloan indiv_interest otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other guarantee_doc guarantee_chittu guarantee_shg guarantee_perso guarantee_jewel guarantee_none guarantee_other borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other plantorepay_chit plantorepay_work plantorepay_migr plantorepay_asse plantorepay_inco plantorepay_borr plantorepay_othe settleloanstrat_inco settleloanstrat_sche settleloanstrat_borr settleloanstrat_sell settleloanstrat_land settleloanstrat_cons settleloanstrat_addi settleloanstrat_work settleloanstrat_supp settleloanstrat_harv settleloanstrat_othe loanproductpledge_gold loanproductpledge_land loanproductpledge_car loanproductpledge_bike loanproductpledge_fridge loanproductpledge_furnit loanproductpledge_tailor loanproductpledge_cell loanproductpledge_line loanproductpledge_dvd loanproductpledge_camera loanproductpledge_gas loanproductpledge_computer loanproductpledge_dish loanproductpledge_none loanproductpledge_other dummyproblemtorepay dummyhelptosettleloan dummyrecommendation dummyguarantor share_nb_samesex share_nb_samecaste share_amt_samesex share_amt_samecaste

duplicates drop

global amount imp1_ds_tot_indiv imp1_is_tot_indiv loanamount_indiv

foreach x in $amount {
replace `x'=`x'*(1/(180/155))
}

save"NEEMSIS2_newvar.dta", replace
*************************************
* END










*************************************
* To keep
*************************************
use"panel_wide_v2", clear
fre _merge
drop _merge
drop loanamount_indiv_2

merge 1:1 HHID_panel INDID_panel using "NEEMSIS2_newvar.dta"
drop if _merge==2
drop _merge

********** New var
gen indebt_indiv_2=0
replace indebt_indiv_2=1 if nbloan>0 & nbloan!=.

/*
gen indebt_good_indiv_2=0
replace indebt_good_indiv_2=1 if nbloan_good>0 & nbloan_good!=.

gen indebt_bad_indiv_2=0
replace indebt_bad_indiv_2=1 if nbloan_bad>0 & nbloan_bad!=.
*/

********** DSR
gen DSR_indiv=imp1_ds_tot_indiv/totalincome_indiv_2
gen ISR_indiv=imp1_is_tot_indiv/totalincome_indiv_2

order DSR_indiv female imp1_ds_tot_indiv totalincome_indiv_2
sort DSR_indiv
replace DSR_indiv=10 if DSR_indiv>10 & DSR_indiv!=.

tabstat DSR_indiv, stat(n mean sd) by(female)


********** Loan amount
replace loanamount_indiv=loanamount_indiv/1000


********** Descriptive statistics for interest
tabstat totalincome_indiv_2 annualincome_indiv_2 , stat(n mean sd) by(female)

tabstat imp1_ds_tot_indiv, stat(n mean sd) by(female)

tabstat imp1_is_tot_indiv, stat(n mean sd) by(female)

tabstat ISR_indiv, stat(n mean sd) by(female)


/*
Female pay less interest because they have an absolute debt lower than male.
*/



cls
********** Y
fre otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other

fre guarantee_doc guarantee_chittu guarantee_shg guarantee_perso guarantee_jewel guarantee_none guarantee_other

fre borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other

fre plantorepay_chit plantorepay_work plantorepay_migr plantorepay_asse plantorepay_inco plantorepay_borr plantorepay_othe

fre settleloanstrat_inco settleloanstrat_sche settleloanstrat_borr settleloanstrat_sell settleloanstrat_land settleloanstrat_cons settleloanstrat_addi settleloanstrat_work settleloanstrat_supp settleloanstrat_harv settleloanstrat_othe

fre loanproductpledge_gold loanproductpledge_land loanproductpledge_car loanproductpledge_bike loanproductpledge_fridge loanproductpledge_furnit loanproductpledge_tailor loanproductpledge_cell loanproductpledge_line loanproductpledge_dvd loanproductpledge_camera loanproductpledge_gas loanproductpledge_computer loanproductpledge_dish loanproductpledge_none loanproductpledge_other 

fre dummyproblemtorepay dummyhelptosettleloan dummyrecommendation dummyguarantor


*otherlenderservices_generainf otherlenderservices_guarantor otherlenderservices_finansupp guarantee_jewel guarantee_perso guarantee_doc

*borrowerservices_suppwhenever plantorepay_borr plantorepay_work settleloanstrat_work settleloanstrat_addi settleloanstrat_cons settleloanstrat_borr dummyhelptosettleloan dummyproblemtorepay

*** Share
tabstat share_nb_samesex share_amt_samesex share_nb_samecaste share_amt_samecaste, stat(n mean sd p50) by(female)


save"panel_wide_v3", replace
****************************************
* END
