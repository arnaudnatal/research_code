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
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\Analysis"
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
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"

global loan "NEEMSIS2-loans_v14"
global loan2 "NEEMSIS2-loans"
****************************************
* END







****************************************
* Loans
****************************************
use"$loan", clear



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


********** YRATEPAID
*** Good debt
gen yratepaid_good=interestpaid*100/loanamount if loanduration<=365 & typeofdebt==0
gen _yratepaid_good=interestpaid*365/loanduration if loanduration>365 & typeofdebt==0
gen _loanamount_good=loanamount*365/loanduration if loanduration>365 & typeofdebt==0
replace yratepaid_good=_yratepaid_good*100/_loanamount_good if loanduration>365 & typeofdebt==0
drop _loanamount_good _yratepaid_good

tab yratepaid_good
sort yratepaid_good

tabstat yratepaid_good if interestpaid>0 & interestpaid!=. & typeofdebt==0, by(lender4) stat(n mean p50 min max)
gen monthlyinterestrate_good=.
replace monthlyinterestrate_good=yratepaid_good if loanduration<=30.4167 & typeofdebt==0
replace monthlyinterestrate_good=(yratepaid_good/loanduration)*30.4167 if loanduration>30.4167 & typeofdebt==0

/*
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       106  32.42069        30  .8333333       100
   Relatives |        24  32.49625      24.5         3       144
      Labour |        41  21.68293        16       2.4       108
 Shop keeper |         1  .9212121  .9212121  .9212121  .9212121
Moneylenders |        15   12.5068        10  .7272727        40
     Friends |       182  25.53982  16.33333        .5       240
 Microcredit |        42  16.44193        10   .007875       120
        Bank |        68  16.10592  11.56467      .832  86.66667
     Thandal |        40  11.61969        10      2.24        60
-------------+--------------------------------------------------
       Total |       519  23.49292        15   .007875       240
----------------------------------------------------------------
*/


*** Bad debt
gen yratepaid_bad=interestpaid*100/loanamount if loanduration<=365 & typeofdebt==1
gen _yratepaid_bad=interestpaid*365/loanduration if loanduration>365 & typeofdebt==1
gen _loanamount_bad=loanamount*365/loanduration if loanduration>365 & typeofdebt==1
replace yratepaid_bad=_yratepaid_bad*100/_loanamount_bad if loanduration>365 & typeofdebt==1
drop _loanamount_bad _yratepaid_bad

tab yratepaid_bad
sort yratepaid_bad

tabstat yratepaid_bad if interestpaid>0 & interestpaid!=. & typeofdebt==1, by(lender4) stat(n mean p50 min max)
gen monthlyinterestrate_bad=.
replace monthlyinterestrate_bad=yratepaid_bad if loanduration<=30.4167 & typeofdebt==1
replace monthlyinterestrate_bad=(yratepaid_bad/loanduration)*30.4167 if loanduration>30.4167 & typeofdebt==1

/*
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       128  45.49089        36         2       600
   Relatives |        18  27.10741        25         2        96
      Labour |        51  25.58497        20         4       100
 Shop keeper |         3  25.33333        30        10        36
Moneylenders |        11  14.89285     13.32  3.055556        30
     Friends |       238  22.82115        18  .0057143       144
 Microcredit |        20   20.3919     13.75       1.5        80
        Bank |        40  21.80919     14.95       .21       100
     Thandal |        43  10.34119        10         2        25
-------------+--------------------------------------------------
       Total |       552  27.19517        20  .0057143       600
----------------------------------------------------------------
*/


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
         WKP |       234   39.5702        30  .8333333       600
   Relatives |        42  30.18675        25         2       144
      Labour |        92  23.84601        20       2.4       108
 Shop keeper |         4   19.2303        20  .9212121        36
Moneylenders |        26  13.51629      12.5  .7272727        40
     Friends |       420  23.99924        18  .0057143       240
 Microcredit |        62  17.71611        10   .007875       120
        Bank |       108  18.21824   12.9575       .21       100
     Thandal |        83  10.95734        10         2        60
-------------+--------------------------------------------------
       Total |      1071  25.40108        18  .0057143       600
----------------------------------------------------------------
*/






********** IMPUTATION of DS and IS
gen totalrepaid2=totalrepaid
gen interestpaid2=interestpaid

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
replace imp1_interest=0.14*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.14*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
replace imp1_interest=0.18*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.18*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.

gen imp1_totalrepaid_year=imp_principal+imp1_interest

gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.

gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if interest_service==.

bysort HHID_panel INDID_panel: egen imp1_ds_tot_indiv=sum(imp1_debt_service)
bysort HHID_panel INDID_panel: egen imp1_is_tot_indiv=sum(imp1_interest_service)





*** Good
gen debt_service_good=.
replace debt_service_good=totalrepaid2 if loanduration<=365 & typeofdebt==0
replace debt_service_good=totalrepaid2*365/loanduration if loanduration>365 & typeofdebt==0
replace debt_service_good=0 if typeofdebt==0 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)

gen interest_service_good=.
replace interest_service_good=interestpaid2 if loanduration<=365 & typeofdebt==0
replace interest_service_good=interestpaid2*365/loanduration if loanduration>365 & typeofdebt==0
replace interest_service_good=0 if typeofdebt==0 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)
replace interest_service_good=0 if typeofdebt==0 & (dummyinterest==0 & interestpaid2==0) | (dummyinterest==0 & interestpaid2==.)

gen imp_principal_good=.
replace imp_principal_good=loanamount-loanbalance if loanduration<=365 & debt_service_good==. & typeofdebt==0
replace imp_principal_good=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service_good==. & typeofdebt==0

gen imp1_interest_good=.
replace imp1_interest_good=0.13*loanamount if lender4==6 & loanduration<=365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0.13*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0.17*loanamount if lender4==8 & loanduration<=365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0.17*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0 if lender4!=6 & lender4!=8 & debt_service_good==. & loandate!=. & typeofdebt==0

gen imp1_totalrepaid_year_good=imp_principal_good+imp1_interest_good & typeofdebt==0

gen imp1_debt_service_good=debt_service_good
replace imp1_debt_service_good=imp1_totalrepaid_year_good if debt_service_good==. & typeofdebt==0

gen imp1_interest_service_good=interest_service_good
replace imp1_interest_service_good=imp1_interest_good if interest_service_good==. & typeofdebt==0

bysort HHID_panel INDID_panel: egen imp1_ds_tot_good_indiv=sum(imp1_debt_service_good)
bysort HHID_panel INDID_panel: egen imp1_is_tot_good_indiv=sum(imp1_interest_service_good)






*** Bad
gen debt_service_bad=.
replace debt_service_bad=totalrepaid2 if loanduration<=365 & typeofdebt==1
replace debt_service_bad=totalrepaid2*365/loanduration if loanduration>365 & typeofdebt==1
replace debt_service_bad=0 if typeofdebt==1 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)

gen interest_service_bad=.
replace interest_service_bad=interestpaid2 if loanduration<=365 & typeofdebt==1
replace interest_service_bad=interestpaid2*365/loanduration if loanduration>365 & typeofdebt==1
replace interest_service_bad=0 if typeofdebt==1 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)
replace interest_service_bad=0 if typeofdebt==1 & (dummyinterest==0 & interestpaid2==0) | (dummyinterest==0 & interestpaid2==.)

gen imp_principal_bad=.
replace imp_principal_bad=loanamount-loanbalance if loanduration<=365 & debt_service_bad==. & typeofdebt==1
replace imp_principal_bad=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service_bad==. & typeofdebt==1

gen imp1_interest_bad=.
replace imp1_interest_bad=0.15*loanamount if lender4==6 & loanduration<=365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0.15*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0.20*loanamount if lender4==8 & loanduration<=365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0.20*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0 if lender4!=6 & lender4!=8 & debt_service_bad==. & loandate!=. & typeofdebt==1

gen imp1_totalrepaid_year_bad=imp_principal_bad+imp1_interest_bad & typeofdebt==0

gen imp1_debt_service_bad=debt_service_bad
replace imp1_debt_service_bad=imp1_totalrepaid_year_bad if debt_service_bad==. & typeofdebt==1

gen imp1_interest_service_bad=interest_service_bad
replace imp1_interest_service_bad=imp1_interest_bad if interest_service_bad==. & typeofdebt==1

bysort HHID_panel INDID_panel: egen imp1_ds_tot_bad_indiv=sum(imp1_debt_service_bad)
bysort HHID_panel INDID_panel: egen imp1_is_tot_bad_indiv=sum(imp1_interest_service_bad)


save"NEEMSIS2-newloans_v2.dta", replace
****************************************
* END











****************************************
* Continuous
****************************************
use"NEEMSIS2-newloans_v2.dta", clear


********** Amount of loan
gen loanamount_good=.
replace loanamount_good=loanamount if typeofdebt==0
gen loanamount_bad=.
replace loanamount_bad=loanamount if typeofdebt==1
bysort HHID_panel INDID_panel: egen loanamount_good_indiv=sum(loanamount_good)
bysort HHID_panel INDID_panel: egen loanamount_indiv=sum(loanamount)
bysort HHID_panel INDID_panel: egen loanamount_bad_indiv=sum(loanamount_bad)
drop loanamount_good loanamount_bad



********** Number of loans
gen gooddebt=0
gen baddebt=0
replace gooddebt=1 if typeofdebt==0
replace baddebt=1 if typeofdebt==1

bysort HHID_panel INDID_panel: egen nbloan_good=sum(gooddebt)
bysort HHID_panel INDID_panel: egen nbloan_bad=sum(baddebt)
bysort HHID_panel INDID_panel: egen nbloan=sum(1)
drop gooddebt baddebt




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



********** Interestpaid
*** Good
gen int_serv_good=interestpaid2 if typeofdebt==0
replace int_serv_good=0 if typeofdebt==0 & dummyinterest==0
bysort HHID_panel INDID_panel: egen interestpaid_good_indiv=sum(int_serv_good)
drop int_serv_good

*** Bad
gen int_serv_bad=interestpaid2 if typeofdebt==1
replace int_serv_bad=0 if typeofdebt==1 & dummyinterest==0
bysort HHID_panel INDID_panel: egen interestpaid_bad_indiv=sum(int_serv_bad)
drop int_serv_bad

*** All
bysort HHID_panel INDID_panel: egen interestpaid_indiv=sum(interestpaid)

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

tab1 otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other




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

keep HHID_panel INDID_panel egoid imp1_ds_tot_indiv imp1_is_tot_indiv imp1_ds_tot_good_indiv imp1_is_tot_good_indiv imp1_ds_tot_bad_indiv imp1_is_tot_bad_indiv loanamount_good_indiv loanamount_indiv loanamount_bad_indiv nbloan_good nbloan_bad nbloan indiv_interest interestpaid_good_indiv interestpaid_bad_indiv interestpaid_indiv otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other guarantee_doc guarantee_chittu guarantee_shg guarantee_perso guarantee_jewel guarantee_none guarantee_other borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other plantorepay_chit plantorepay_work plantorepay_migr plantorepay_asse plantorepay_inco plantorepay_borr plantorepay_othe settleloanstrat_inco settleloanstrat_sche settleloanstrat_borr settleloanstrat_sell settleloanstrat_land settleloanstrat_cons settleloanstrat_addi settleloanstrat_work settleloanstrat_supp settleloanstrat_harv settleloanstrat_othe loanproductpledge_gold loanproductpledge_land loanproductpledge_car loanproductpledge_bike loanproductpledge_fridge loanproductpledge_furnit loanproductpledge_tailor loanproductpledge_cell loanproductpledge_line loanproductpledge_dvd loanproductpledge_camera loanproductpledge_gas loanproductpledge_computer loanproductpledge_dish loanproductpledge_none loanproductpledge_other dummyproblemtorepay dummyhelptosettleloan dummyrecommendation dummyguarantor

duplicates drop

global amount imp1_ds_tot_indiv imp1_is_tot_indiv imp1_ds_tot_good_indiv imp1_is_tot_good_indiv imp1_ds_tot_bad_indiv imp1_is_tot_bad_indiv loanamount_good_indiv loanamount_indiv loanamount_bad_indiv interestpaid_good_indiv interestpaid_bad_indiv interestpaid_indiv

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

gen indebt_good_indiv_2=0
replace indebt_good_indiv_2=1 if nbloan_good>0 & nbloan_good!=.

gen indebt_bad_indiv_2=0
replace indebt_bad_indiv_2=1 if nbloan_bad>0 & nbloan_bad!=.

********** DSR good and bad
gen DSR_indiv=imp1_ds_tot_indiv/totalincome_indiv_2
gen ISR_indiv=imp1_is_tot_indiv/totalincome_indiv_2

foreach x in good bad {
gen DSR_`x'_indiv=imp1_ds_tot_`x'_indiv/totalincome_indiv_2
gen ISR_`x'_indiv=imp1_is_tot_`x'_indiv/totalincome_indiv_2
}


********** New measures of ISR
gen intamt_good=interestpaid_good_indiv/loanamount_good_indiv
gen intamt_bad=interestpaid_bad_indiv/loanamount_bad_indiv
gen intamt=interestpaid_indiv/loanamount_indiv



********** Descriptive statistics for interest
tabstat totalincome_indiv_2 annualincome_indiv_2 , stat(n mean sd) by(female)

tabstat imp1_ds_tot_indiv imp1_ds_tot_good_indiv imp1_ds_tot_bad_indiv, stat(n mean sd) by(female)

tabstat imp1_is_tot_indiv imp1_is_tot_good_indiv imp1_is_tot_bad_indiv, stat(n mean sd) by(female)

tabstat ISR_indiv ISR_good_indiv ISR_bad_indiv intamt_good intamt_bad intamt interestpaid_good_indiv interestpaid_bad_indiv interestpaid_indiv, stat(n mean sd) by(female)


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


save"panel_wide_v3", replace
****************************************
* END
