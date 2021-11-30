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
****************************************
* END







****************************************
* Loans
****************************************
use"$loan", clear

dis 12*4
tab loanduration_month
* 97.5% of loans to keep



********** Only keep loan contract after the measure of personality traits
drop if loanduration_month>48
drop if loansettled==1

preserve
keep if mainloanname!=""
bysort HHID_panel INDID_panel: egen sum_dummyproblemtorepay=sum(dummyproblemtorepay)
keep HHID_panel INDID_panel egoid sex sum_dummyproblemtorepay
drop if egoid==0
ta egoid sex

ta sum_dummyproblemtorepay sex, col nofreq
recode sum_dummyproblemtorepay (2=1) (3=1)
ta sum_dummyproblemtorepay sex
ta sum_dummyproblemtorepay sex, col nofreq
restore

save"NEEMSIS2-newloans_v1.dta", replace
****************************************
* END








****************************************
* Loans
****************************************
use"NEEMSIS2-newloans_v1", clear
fre loanlender
fre lender4
fre loanreasongiven


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

********** Good debt
gen loanamount_good=.
replace loanamount_good=loanamount if typeofdebt==0
gen loan_good=1 if typeofdebt==0

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


********** Bad debt
gen loanamount_bad=.
replace loanamount_bad=loanamount if typeofdebt==1
gen loan_bad=1 if typeofdebt==1

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

********** Test
tabstat loanamount_good loanamount_bad loanamount, stat(n)


********** All loans
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



save"NEEMSIS2-newloans_v2.dta", replace
****************************************
* END








****************************************
* IMPUTATION
****************************************
use"NEEMSIS2-newloans_v2.dta", clear

gen totalrepaid2=totalrepaid
gen interestpaid2=interestpaid

merge m:1 HHID_panel INDID_panel using "$wave3", keepusing(annualincome_indiv annualincome_HH) 
drop if _merge==2
drop _merge
tab loansettled
tab householdid2020

********** Debt service pour ML
*** All
gen debt_service=.
replace debt_service=totalrepaid2 if loanduration<=365
replace debt_service=totalrepaid2*365/loanduration if loanduration>365
replace debt_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.

*** Good
gen debt_service_good=.
replace debt_service_good=totalrepaid2 if loanduration<=365 & typeofdebt==0
replace debt_service_good=totalrepaid2*365/loanduration if loanduration>365 & typeofdebt==0
replace debt_service_good=0 if typeofdebt==0 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)

*** Bad
gen debt_service_bad=.
replace debt_service_bad=totalrepaid2 if loanduration<=365 & typeofdebt==1
replace debt_service_bad=totalrepaid2*365/loanduration if loanduration>365 & typeofdebt==1
replace debt_service_bad=0 if typeofdebt==1 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)





********** Interest service pour ML
*** All
gen interest_service=.
replace interest_service=interestpaid2 if loanduration<=365
replace interest_service=interestpaid2*365/loanduration if loanduration>365
replace interest_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.
replace interest_service=0 if dummyinterest==0 & interestpaid2==0 | dummyinterest==0 & interestpaid2==.

*** Good
gen interest_service_good=.
replace interest_service_good=interestpaid2 if loanduration<=365 & typeofdebt==0
replace interest_service_good=interestpaid2*365/loanduration if loanduration>365 & typeofdebt==0
replace interest_service_good=0 if typeofdebt==0 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)
replace interest_service_good=0 if typeofdebt==0 & (dummyinterest==0 & interestpaid2==0) | (dummyinterest==0 & interestpaid2==.)

*** Bad
gen interest_service_bad=.
replace interest_service_bad=interestpaid2 if loanduration<=365 & typeofdebt==1
replace interest_service_bad=interestpaid2*365/loanduration if loanduration>365 & typeofdebt==1
replace interest_service_bad=0 if typeofdebt==1 & (loanduration==0 & totalrepaid2==0) | (loanduration==0 & totalrepaid2==.)
replace interest_service_bad=0 if typeofdebt==1 & (dummyinterest==0 & interestpaid2==0) | (dummyinterest==0 & interestpaid2==.)




********** Imputation du principal
*** All
gen imp_principal=.
replace imp_principal=loanamount-loanbalance if loanduration<=365 & debt_service==.
replace imp_principal=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service==.

*** Good
gen imp_principal_good=.
replace imp_principal_good=loanamount-loanbalance if loanduration<=365 & debt_service_good==. & typeofdebt==0
replace imp_principal_good=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service_good==. & typeofdebt==0

*** Bad
gen imp_principal_bad=.
replace imp_principal_bad=loanamount-loanbalance if loanduration<=365 & debt_service_bad==. & typeofdebt==1
replace imp_principal_bad=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service_bad==. & typeofdebt==1





********** Imputation interest for moneylenders (.17) and microcredit (.19)
*** All
gen imp1_interest=.
replace imp1_interest=0.14*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.14*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
replace imp1_interest=0.18*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.18*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.

*** Good
gen imp1_interest_good=.
replace imp1_interest_good=0.13*loanamount if lender4==6 & loanduration<=365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0.13*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0.17*loanamount if lender4==8 & loanduration<=365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0.17*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service_good==. & typeofdebt==0
replace imp1_interest_good=0 if lender4!=6 & lender4!=8 & debt_service_good==. & loandate!=. & typeofdebt==0

*** Bad
gen imp1_interest_bad=.
replace imp1_interest_bad=0.15*loanamount if lender4==6 & loanduration<=365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0.15*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0.20*loanamount if lender4==8 & loanduration<=365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0.20*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service_bad==. & typeofdebt==1
replace imp1_interest_bad=0 if lender4!=6 & lender4!=8 & debt_service_bad==. & loandate!=. & typeofdebt==1




********** Imputation total
*** All
gen imp1_totalrepaid_year=imp_principal+imp1_interest

*** Good
gen imp1_totalrepaid_year_good=imp_principal_good+imp1_interest_good & typeofdebt==0

*** Bad
gen imp1_totalrepaid_year_bad=imp_principal_bad+imp1_interest_bad & typeofdebt==0





********** Calcul service de la dette pour tout
*** All
gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.

*** Good
gen imp1_debt_service_good=debt_service_good
replace imp1_debt_service_good=imp1_totalrepaid_year_good if debt_service_good==. & typeofdebt==0

*** Bad
gen imp1_debt_service_bad=debt_service_bad
replace imp1_debt_service_bad=imp1_totalrepaid_year_bad if debt_service_bad==. & typeofdebt==1




********** Calcul service des interets pour tout
*** All
gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if interest_service==.

*** Good
gen imp1_interest_service_good=interest_service_good
replace imp1_interest_service_good=imp1_interest_good if interest_service_good==. & typeofdebt==0

*** Bad
gen imp1_interest_service_bad=interest_service_bad
replace imp1_interest_service_bad=imp1_interest_bad if interest_service_bad==. & typeofdebt==1




********** INDIV
*** All
bysort HHID_panel INDID_panel: egen imp1_ds_tot_indiv=sum(imp1_debt_service)
bysort HHID_panel INDID_panel: egen imp1_is_tot_indiv=sum(imp1_interest_service)
bysort HHID_panel INDID_panel: egen loanamount_indiv=sum(loanamount)

*** Good
bysort HHID_panel INDID_panel: egen imp1_ds_tot_good_indiv=sum(imp1_debt_service_good)
bysort HHID_panel INDID_panel: egen imp1_is_tot_good_indiv=sum(imp1_interest_service_good)
bysort HHID_panel INDID_panel: egen loanamount_good_indiv=sum(loanamount_good)

*** Bad
bysort HHID_panel INDID_panel: egen imp1_ds_tot_bad_indiv=sum(imp1_debt_service_bad)
bysort HHID_panel INDID_panel: egen imp1_is_tot_bad_indiv=sum(imp1_interest_service_bad)
bysort HHID_panel INDID_panel: egen loanamount_bad_indiv=sum(loanamount_bad)


********** HH
*** All
bysort HHID_panel: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID_panel: egen imp1_is_tot_HH=sum(imp1_interest_service)

*** Good
bysort HHID_panel: egen imp1_ds_tot_good_HH=sum(imp1_debt_service_good)
bysort HHID_panel: egen imp1_is_tot_good_HH=sum(imp1_interest_service_good)

*** Bad
bysort HHID_panel: egen imp1_ds_tot_bad_HH=sum(imp1_debt_service_bad)
bysort HHID_panel: egen imp1_is_tot_bad_HH=sum(imp1_interest_service_bad)


********** Indiv
preserve
gen DSR_indiv=imp1_ds_tot_indiv*100/annualincome_indiv
gen ISR_indiv=imp1_is_tot_indiv*100/annualincome_indiv

gen DSR_good_indiv=imp1_ds_tot_good_indiv*100/annualincome_indiv
gen ISR_good_indiv=imp1_is_tot_good_indiv*100/annualincome_indiv

gen DSR_bad_indiv=imp1_ds_tot_bad_indiv*100/annualincome_indiv
gen ISR_bad_indiv=imp1_is_tot_bad_indiv*100/annualincome_indiv

duplicates drop HHID_panel INDID_panel, force
tabstat DSR_indiv ISR_indiv DSR_good_indiv ISR_good_indiv DSR_bad_indiv ISR_bad_indiv, stat(n mean sd q min max) long
restore
/*
   stats |  DSR_in~v  ISR_in~v  DSR_go~v  ISR_go~v  DSR_ba~v  ISR_ba~v
---------+------------------------------------------------------------
       N |      1091      1091       417       417       673       673
    mean |  1212.108   1030.76  225.4149  52.38447  1670.883  1619.216
      sd |  32422.26  32418.01  1121.754   368.492  41273.15  41275.03
     p25 |  2.274143         0  .0012195         0         0         0
     p50 |  22.63864  1.111111  15.55556  .7058824  1.410935         0
     p75 |   166.181  16.66667  140.2591  14.80504        35  6.635358
     min |         0         0         0         0         0         0
     max |   1070780   1070780  21405.64  7083.333   1070780   1070780
----------------------------------------------------------------------
*/



********** HH
preserve
gen DSR_HH=imp1_ds_tot_HH*100/annualincome_HH
gen ISR_HH=imp1_is_tot_HH*100/annualincome_HH

gen DSR_good_HH=imp1_ds_tot_good_HH*100/annualincome_HH
gen ISR_good_HH=imp1_is_tot_good_HH*100/annualincome_HH

gen DSR_bad_HH=imp1_ds_tot_bad_HH*100/annualincome_HH
gen ISR_bad_HH=imp1_is_tot_bad_HH*100/annualincome_HH

duplicates drop HHID_panel, force
tabstat DSR_HH ISR_HH DSR_good_HH ISR_good_HH DSR_bad_HH ISR_bad_HH, stat(n mean sd q min max) long
restore
/*
   stats |    DSR_HH    ISR_HH  DSR_go~H  ISR_go~H  DSR_ba~H  ISR_ba~H
---------+------------------------------------------------------------
       N |       605       605       224       224       381       381
    mean |  78.37734  16.10112  55.75575  14.39655  37.24753  9.001207
      sd |  196.2883  42.33344  142.5511  35.97805   145.905  28.55169
     p25 |  8.672733  .3421997  2.323161         0         0         0
     p50 |  22.60806  4.331246  13.06047  3.196387   5.28169  1.265198
     p75 |  59.96151  12.96795   39.8242  13.46572  21.85801  6.787866
     min |         0         0         0         0         0         0
     max |  2270.937  553.2609  1352.542  352.6764      1890  285.7143
----------------------------------------------------------------------
*/




save"NEEMSIS2-newloans_v3.dta", replace
*************************************
* END













****************************************
* Services + problem + help + interest
****************************************
use"NEEMSIS2-newloans_v3.dta", clear
order HHID_panel INDID_panel

********** Id for ML
gen dummymainloan=0
replace dummymainloan=1 if lenderfirsttime!=.
tab dummymainloan


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





********** Borrower services
tab borrowerservices
gen borrowerservices_freeserv=0 if dummymainloan==1
gen borrowerservices_worklesswage=0 if dummymainloan==1
gen borrowerservices_suppwhenever=0 if dummymainloan==1
gen borrowerservices_none=0 if dummymainloan==1
gen borrowerservices_other=0 if dummymainloan==1
replace borrowerservices_freeserv=1 if strpos(borrowerservices,"1") & dummymainloan==1
replace borrowerservices_worklesswage=1 if strpos(borrowerservices,"2") & dummymainloan==1
replace borrowerservices_suppwhenever=1 if strpos(borrowerservices,"3") & dummymainloan==1
replace borrowerservices_none=1 if strpos(borrowerservices,"4") & dummymainloan==1
replace borrowerservices_other=1 if strpos(borrowerservices,"77") & dummymainloan==1

tab1 borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other




********** Guarantee
ta guarantee
gen guarantee_doc=0
gen guarantee_chittu=0
gen guarantee_shg=0
gen guarantee_perso=0
gen guarantee_jewel=0
gen guarantee_none=0
gen guarantee_other=0

replace guarantee_doc=1 if strpos(guarantee,"1") & dummymainloan==1
replace guarantee_chittu=1 if strpos(guarantee,"2") & dummymainloan==1
replace guarantee_shg=1 if strpos(guarantee,"3") & dummymainloan==1
replace guarantee_perso=1 if strpos(guarantee,"4") & dummymainloan==1
replace guarantee_jewel=1 if strpos(guarantee,"5") & dummymainloan==1
replace guarantee_none=1 if strpos(guarantee,"6") & dummymainloan==1
replace guarantee_other=1 if strpos(guarantee,"77") & dummymainloan==1



********** Plan to repay
ta plantorepay
gen plantorepay_chit=0
gen plantorepay_work=0
gen plantorepay_migr=0
gen plantorepay_asse=0
gen plantorepay_inco=0
gen plantorepay_borr=0
gen plantorepay_othe=0

replace plantorepay_chit=1 if strpos(plantorepay,"1") & dummymainloan==1
replace plantorepay_work=1 if strpos(plantorepay,"2") & dummymainloan==1
replace plantorepay_migr=1 if strpos(plantorepay,"3") & dummymainloan==1
replace plantorepay_asse=1 if strpos(plantorepay,"4") & dummymainloan==1
replace plantorepay_inco=1 if strpos(plantorepay,"5") & dummymainloan==1
replace plantorepay_borr=1 if strpos(plantorepay,"6") & dummymainloan==1
replace plantorepay_othe=1 if strpos(plantorepay,"77") & dummymainloan==1



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

replace settleloanstrat_inco=1 if strpos(settleloanstrategy,"1") & dummymainloan==1
replace settleloanstrat_sche=1 if strpos(settleloanstrategy,"2") & dummymainloan==1
replace settleloanstrat_borr=1 if strpos(settleloanstrategy,"3") & dummymainloan==1
replace settleloanstrat_sell=1 if strpos(settleloanstrategy,"4") & dummymainloan==1
replace settleloanstrat_land=1 if strpos(settleloanstrategy,"5") & dummymainloan==1
replace settleloanstrat_cons=1 if strpos(settleloanstrategy,"6") & dummymainloan==1
replace settleloanstrat_addi=1 if strpos(settleloanstrategy,"7") & dummymainloan==1
replace settleloanstrat_work=1 if strpos(settleloanstrategy,"8") & dummymainloan==1
replace settleloanstrat_supp=1 if strpos(settleloanstrategy,"9") & dummymainloan==1
replace settleloanstrat_harv=1 if strpos(settleloanstrategy,"10") & dummymainloan==1
replace settleloanstrat_othe=1 if strpos(settleloanstrategy,"77") & dummymainloan==1


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

replace loanproductpledge_gold=1 if strpos(loanproductpledge,"1") & dummymainloan==1
replace loanproductpledge_land=1 if strpos(loanproductpledge,"2") & dummymainloan==1
replace loanproductpledge_car=1 if strpos(loanproductpledge,"3") & dummymainloan==1
replace loanproductpledge_bike=1 if strpos(loanproductpledge,"4") & dummymainloan==1
replace loanproductpledge_fridge=1 if strpos(loanproductpledge,"5") & dummymainloan==1
replace loanproductpledge_furnit=1 if strpos(loanproductpledge,"6") & dummymainloan==1
replace loanproductpledge_tailor=1 if strpos(loanproductpledge,"7") & dummymainloan==1
replace loanproductpledge_cell=1 if strpos(loanproductpledge,"8") & dummymainloan==1
replace loanproductpledge_line=1 if strpos(loanproductpledge,"9") & dummymainloan==1
replace loanproductpledge_dvd=1 if strpos(loanproductpledge,"10") & dummymainloan==1
replace loanproductpledge_camera=1 if strpos(loanproductpledge,"11") & dummymainloan==1
replace loanproductpledge_gas=1 if strpos(loanproductpledge,"12") & dummymainloan==1
replace loanproductpledge_computer=1 if strpos(loanproductpledge,"13") & dummymainloan==1
replace loanproductpledge_dish=1 if strpos(loanproductpledge,"14") & dummymainloan==1
replace loanproductpledge_none=1 if strpos(loanproductpledge,"15") & dummymainloan==1
replace loanproductpledge_other=1 if strpos(loanproductpledge,"77") & dummymainloan==1




********** New Y
foreach x in otherlenderservices_politsupp otherlenderservices_finansupp otherlenderservices_guarantor otherlenderservices_generainf otherlenderservices_none otherlenderservices_other borrowerservices_freeserv borrowerservices_worklesswage borrowerservices_suppwhenever borrowerservices_none borrowerservices_other guarantee_doc guarantee_chittu guarantee_shg guarantee_perso guarantee_jewel guarantee_none guarantee_other plantorepay_chit plantorepay_work plantorepay_migr plantorepay_asse plantorepay_inco plantorepay_borr plantorepay_othe settleloanstrat_inco settleloanstrat_sche settleloanstrat_borr settleloanstrat_sell settleloanstrat_land settleloanstrat_cons settleloanstrat_addi settleloanstrat_work settleloanstrat_supp settleloanstrat_harv settleloanstrat_othe loanproductpledge_gold loanproductpledge_land loanproductpledge_car loanproductpledge_bike loanproductpledge_fridge loanproductpledge_furnit loanproductpledge_tailor loanproductpledge_cell loanproductpledge_line loanproductpledge_dvd loanproductpledge_camera loanproductpledge_gas loanproductpledge_computer loanproductpledge_dish loanproductpledge_none loanproductpledge_other {
bysort HHID_panel INDID_panel: egen s_`x'=sum(`x')
}





save"NEEMSIS2-newloans_v4.dta", replace
*************************************
* END









*************************************
* To keep
*************************************
use"NEEMSIS2-newloans_v4.dta", clear

bysort HHID_panel INDID_panel: egen s_dummymainloan=sum(dummymainloan)
fre s_dummymainloan

global psycho s_otherlenderservices_politsupp s_otherlenderservices_finansupp s_otherlenderservices_guarantor s_otherlenderservices_generainf s_otherlenderservices_none s_otherlenderservices_other s_borrowerservices_freeserv s_borrowerservices_worklesswage s_borrowerservices_suppwhenever s_borrowerservices_none s_borrowerservices_other s_guarantee_doc s_guarantee_chittu s_guarantee_shg s_guarantee_perso s_guarantee_jewel s_guarantee_none s_guarantee_other s_plantorepay_chit s_plantorepay_work s_plantorepay_migr s_plantorepay_asse s_plantorepay_inco s_plantorepay_borr s_plantorepay_othe s_settleloanstrat_inco s_settleloanstrat_sche s_settleloanstrat_borr s_settleloanstrat_sell s_settleloanstrat_land s_settleloanstrat_cons s_settleloanstrat_addi s_settleloanstrat_work s_settleloanstrat_supp s_settleloanstrat_harv s_settleloanstrat_othe s_loanproductpledge_gold s_loanproductpledge_land s_loanproductpledge_car s_loanproductpledge_bike s_loanproductpledge_fridge s_loanproductpledge_furnit s_loanproductpledge_tailor s_loanproductpledge_cell s_loanproductpledge_line s_loanproductpledge_dvd s_loanproductpledge_camera s_loanproductpledge_gas s_loanproductpledge_computer s_loanproductpledge_dish s_loanproductpledge_none s_loanproductpledge_other s_dummymainloan

keep HHID_panel INDID_panel imp1_ds_tot_indiv imp1_is_tot_indiv imp1_ds_tot_good_indiv imp1_is_tot_good_indiv imp1_ds_tot_bad_indiv imp1_is_tot_bad_indiv loanamount_indiv loanamount_good_indiv loanamount_bad_indiv $psycho sex egoid

duplicates drop


cls
tab1 $psycho

foreach x in $psycho {
clonevar d`x'=`x'
}
foreach x in $psycho {
replace d`x'=1 if `x'>1
}

cls
foreach x in $psycho {
tab1 d`x'
}

global tokeep ds_otherlenderservices_finansupp ds_otherlenderservices_generainf ds_borrowerservices_suppwhenever ds_borrowerservices_none ds_guarantee_doc ds_guarantee_perso ds_guarantee_none ds_plantorepay_work ds_plantorepay_inco ds_plantorepay_borr ds_settleloanstrat_inco ds_settleloanstrat_borr ds_settleloanstrat_work ds_loanproductpledge_gold ds_loanproductpledge_furnit ds_dummymainloan


keep HHID_panel INDID_panel imp1_ds_tot_indiv imp1_is_tot_indiv imp1_ds_tot_good_indiv imp1_is_tot_good_indiv imp1_ds_tot_bad_indiv imp1_is_tot_bad_indiv loanamount_indiv loanamount_good_indiv loanamount_bad_indiv $tokeep

foreach x in $tokeep {
local new=substr("`x'",4,99)
rename `x' `new'
}

rename dummymainloan dummyml_indiv

save"NEEMSIS2_newvar.dta", replace
*************************************
* END










*************************************
* To keep
*************************************
use"panel_wide_v2", clear
fre _merge
drop _merge

merge 1:1 HHID_panel INDID_panel using "NEEMSIS2_newvar.dta"
drop if _merge==2
drop _merge

ta dummyproblemtorepay_indiv_2 sex_2
recode dummyproblemtorepay_indiv_2 (3=1) (2=1)
ta dummyproblemtorepay_indiv_2 sex_2, col nofreq

fre loanamount_indiv loanamount_good_indiv loanamount_bad_indiv


*Clonevar
fre dummyproblemtorepay_indiv_2
clonevar n_dummyproblemtorepay_indiv_2=dummyproblemtorepay_indiv_2
recode n_dummyproblemtorepay_indiv_2 (.=0)



*Gen dummy for interest
tab1 dummyinterest_indiv_2
gen dichotomyinterest_indiv_2=0 if indebt_indiv_2==1
replace dichotomyinterest_indiv_2=1 if indebt_indiv_2==1 & dummyinterest_indiv_2>0


********** DSR good and bad
foreach x in good bad {
gen DSR_`x'_indiv=imp1_ds_tot_`x'_indiv*100/totalincome_indiv_2
gen ISR_`x'_indiv=imp1_is_tot_`x'_indiv*100/totalincome_indiv_2
}


********** proba good
gen dummy_good=0
gen dummy_bad=0

replace dummy_good=1 if loanamount_good>0 & loanamount_good!=.
replace dummy_bad=1 if loanamount_bad>0 & loanamount_bad!=.

fre dummy_good dummy_bad

gen dummy_debt=dummy_good+dummy_bad
replace dummy_debt=1 if dummy_debt>1
gen test=dummy_debt-indebt_indiv_2
ta test
order dummy_good dummy_bad dummy_debt indebt_indiv_2 test loanamount_indiv_2 loanamount_indiv loanamount_good_indiv loanamount_bad_indiv
sort test


********** Deflate
foreach x in loanamount_indiv loanamount_good_indiv loanamount_bad_indiv imp1_is_tot_good_indiv imp1_is_tot_bad_indiv{
replace `x'=(`x'*(155/180))/1000
}

/*
HHID_panel	INDID_panel
MANAM47	Ind_4
KAR50	Ind_2
SEM18	Ind_1
KAR4	Ind_2
NAT28	Ind_4
*/


********** Pb to repay
fre dummyproblemtorepay_indiv_2
clonevar dummypbrepay=dummyproblemtorepay_indiv_2
recode dummypbrepay (3=1) (2=1)
fre dummypbrepay



********** Loan amount
fre loanamount_good_indiv loanamount_bad_indiv


save"panel_wide_v3", replace
****************************************
* END
