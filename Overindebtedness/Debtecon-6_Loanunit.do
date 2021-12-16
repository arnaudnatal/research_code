cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
December 09, 2021
-----
Panel for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"

global loan1 "RUME-loans_v8"
global loan2 "NEEMSIS1-loans_v6"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020



****************************************
* END









****************************************
* ALL LOANS in same db
****************************************

********** Cleaning loans before append
*2010
use"$loan1", clear
ta dummyproblemtorepay
rename dummyproblemtorepay problemtorepay
gen dummyproblemtorepay=.
replace dummyproblemtorepay=0 if problemtorepay==9
replace dummyproblemtorepay=1 if problemtorepay!=9 & problemtorepay!=.

ta problemtorepay dummyproblemtorepay, m

preserve
use"$wave1", clear
keep HHID_panel caste HHID2010
duplicates drop
ta caste
save"$wave1~_temp2", replace
restore
merge m:1 HHID2010 using "$wave1~_temp2"
drop if _merge==2
drop _merge
rename loaneffectivereason loaneffectivereason2010
rename guarantorloanrelation guarantorloanrelation2010
rename lenderrelation lenderrelation2010
tab loansettled // 156
save"$loan1~_2", replace

*2016
use"$loan2", clear
drop caste
*rename parent_key HHID2016
preserve
use"$wave2", clear
keep HHID_panel caste HHID2016
duplicates drop
ta caste
save"$wave2~_temp2", replace
restore
merge m:1 HHID2016 using "$wave2~_temp2"
drop if _merge==2
drop _merge
rename loaneffectivereason loaneffectivereason2016
rename guarantorloanrelation guarantorloanrelation2016
rename lenderrelation lenderrelation2016
tab loansettled  // 15
save"$loan2~_2", replace

*2020
use"$loan3", clear

preserve
use"$wave3", clear
keep HHID_panel caste
duplicates drop
ta caste
save"$wave3~_temp2", replace
restore
merge m:1 HHID_panel using "$wave3~_temp2"
drop if _merge==2
drop _merge
rename loaneffectivereason loaneffectivereason2020
rename guarantorloanrelation guarantorloanrelation2020
rename lenderrelation lenderrelation2020
tab loansettled 
ta loanlender
ta loanlender_rec
drop loanlender
rename loanlender_rec loanlender
ta loanlender
save"$loan3~_2", replace

ta caste

********** Append
use"$loan3~_2", clear
append using "$loan2~_2"
append using "$loan1~_2"

tab HHID_panel, m
keep if loanamount!=.

save"panel_loan", replace
****************************************
* END












****************************************
* ALL LOANS in same db
****************************************
*2010
use"$loan1", clear
*Merge sex, caste, nom, village, age
*Add dummy main loan to be sure

drop loanduration informal semiformal formal economic current humancap social house incomegen noincomegen economic_amount current_amount humancap_amount social_amount house_amount incomegen_amount noincomegen_amount informal_amount formal_amount semiformal_amount lender2 lender3 lender4 totalrepaid totalrepaid2 interestpaid2 principalpaid2 yratepaid monthlyinterestrate

rename repayduration22 repayduration2

gen dummymainloan=0
replace dummymainloan=1 if lendername!="." & lendername!=""
order dummymainloan, before(lendername)
sort dummymainloan


*** Label
destring loanreasongiven, replace
label define loanreasongiven 1"Agri" 2"Family" 3"Health" 4"Repay" 5"House" 6"Investment" 7"Ceremonies" 8"Marriage" 9"Education" 10"Relatives" 11"Death" 66"Irr" 77"Oth" 88"D/K" 99"N/R"
label values loanreasongiven loanreasongiven

destring loanlender, replace
label define loanlender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Pawn broker" 7"Shop keeper" 8"Finance" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 13"Sugar mill loan" 14"Nobody" 66"Irr" 77"Oth" 88"D/K" 99"N/R"
label values loanlender loanlender

destring relativerelation, replace
label define relativerelation 1"Maternal uncle" 2"Brother" 3"Paternal uncle" 4"Cousin" 5"Nephew" 6"Father/mother-in-law" 7"Brother-in-law" 8"Wife relatives" 9"Father brother" 10"No relation" 11"Father" 66"Irr" 77"Oth" 88"D/K" 99"N/R"
label values relativerelation relativerelation

destring lenderscaste, replace
label define lenderscaste 1"Vanniyar" 2"SC" 3"Arunthatthiyar" 4"Rediyar" 5"Gramani" 6"Naidu" 7"Navithar" 8"Asarai" 9"Settu" 10"Nattar" 12"Muthaliyar" 13"Kulalar" 66"Irr" 77"Oth" 88"D/K" 99"N/R"
label values lenderscaste lenderscaste

destring lendernativevillage, replace
label define lendernativevillage 1"Inside the village" 2"Outside the village"
label values lendernativevillage lendernativevillage

destring otherlenderservices, replace
label define otherlenderservices 1"Political support" 2"Financial support" 3"Guarantor" 4"General informant" 5"Other" 6"None"
label values otherlenderservices otherlenderservices
label values otherlenderservices otherlenderservices2

destring borrowerservices, replace
label define borrowerservices 1"Free service" 2"Work for less wage" 3"Provide support whenever he need" 4"Other"
label values borrowerservices borrowerservices

destring interestfrequency, replace
label define interestfrequency 1"Monthly" 2"Weekly" 3"Yearly" 4"Once in six months" 5"Pay whenever have money" 6"Other"
label values interestfrequency interestfrequency

destring repayduration1, replace
label define repayduration1 1"Monthly" 2"Weekly" 3"Yearly" 4"Once in six months" 5"Pay whenever have money" 6"Other"
label values repayduration1 repayduration1

destring repaydecide, replace
label define repaydecide 1"Myself" 2"Lender"
label values repaydecide repaydecide

destring termsofrepayment, replace
label define termsofrepayment 1"Fixed duration" 2"Repay when have money" 3"Repay when asked by the lender"
label values termsofrepayment termsofrepayment

export excel "RUME-loans.xlsx", replace firstrow(variables)


*2016
use"NEEMSIS1-loans_v6.dta", clear
ta loan_database
drop num HHID2016 HHID2010 dummynewHH dummydemonetisation INDID2016 villageid villageareaid householdid egoid year submissiondate_o loanduration informal semiformal formal economic current humancap social house incomegen noincomegen economic_amount current_amount humancap_amount social_amount house_amount incomegen_amount noincomegen_amount informal_amount formal_amount semiformal_amount loan_id
keep if loan_database=="FINANCE"
drop loan_database
order dummymainloan, before(lendername)
sort dummymainloan

label define loanlender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Pawn broker" 7"Shop keeper" 8"Finance" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 13"Sugar mill loan" 14"Group finance"
label values loanlender loanlender


export excel "NEEMSIS1-loans.xlsx", replace firstrow(variables)

ta loanlender lender4
/*

     loanlender |       WKP  Relatives     Labour  Pawn brok  Shop keep  Moneylend    Friends  Microcred       Bank   Neighbor |     Total
----------------+--------------------------------------------------------------------------------------------------------------+----------
            WKP |       634          2          9          0          0          0          1          2          0         83 |       731 
      Relatives |         2        316          0          0          0          0          0          0          0          0 |       318 
       Employer |         0          0         76          0          0          0          0          0          0          0 |        76 
        Maistry |         0          0         43          0          0          0          0          0          0          0 |        43 
      Colleague |         1          0          7          0          0          0          4          0          0          2 |        14 
    Pawn broker |         0          0          0          3          0          0          0          0          0          0 |         3 
    Shop keeper |         0          0          0          0         11          0          0          0          0          1 |        12 
        Finance |         4          0          0          0          0        143          0         54          0          1 |       202 
        Friends |         0          0          1          0          0          0         47          0          0          1 |        49 
            SHG |         0          0          0          0          0          0          0         32          0          0 |        32 
          Banks |         0          0          0          0          0          0          0          2         75          0 |        77 
      Coop bank |         0          0          0          0          0          0          0          0         28          0 |        28 
Sugar mill loan |         0          0          0          0          0          0          0          0          2          0 |         2 
  Group finance |         0          0          0          0          0          0          0         95          0          0 |        95 
----------------+--------------------------------------------------------------------------------------------------------------+----------
          Total |       641        318        136          3         11        143         52        185        105         88 |     1,682 

*/


/*
loanlender --> lender2
- labour relation = employer + maistry + colleague
- SHG & group finance
- bank et coop bank


lender2 --> lender3 with relationship to the lender
- change relative
- change labour
- change friends
- add SHG + group finance if relationship=SHG ou group finance --> microcredit
- add neighbor cat

lender3 --> lender4 = changer à la main pour répérer d'autres microcrédits
Microcrédit si:
lendername=="Ujjivan" | lendername=="Ujjivan finence" | lendername=="Ujjivan5" | lendername=="Baroda bank" | lendername=="Bwda finance" | lendername=="Bwda" | lendername=="Danalakshmi finance" | lendername=="Equitos finance" | lendername=="Equitos" | lendername=="Equidos" | lendername=="Ekvidas" | lendername=="Eqvidas"
lendername=="Fin care" | lendername=="HDFC" | lendername=="Hdfc" | lendername=="Logu finance" | lendername=="Loki management" | lendername=="Muthood fincorp" | lendername=="Muthoot finance" | lendername=="Muthu  Finance" | lendername=="Pin care" | lendername=="Rbl (finance)" | lendername=="Sriram finance" | lendername=="Sriram fainance" 
lendername=="Mahendra finance" | lendername=="Mahi ndra finance" 
lendername=="Therinjavanga" 
lendername=="Sundaram finance" |  lendername=="Mahi ndra financeQ" | lendername=="Maglir Mandram"
lendername=="Muthu  Finance" |  lendername=="Logu finance" |  lendername=="Rbl (finance)" |  lendername=="Sriram finance" |  lendername=="Sundaram finance" 
*/

gen ok=0
replace ok=1 if lendername=="Ujjivan" | lendername=="Ujjivan finence" | lendername=="Ujjivan5" | lendername=="Baroda bank" | lendername=="Bwda finance" | lendername=="Bwda" | lendername=="Danalakshmi finance" | lendername=="Equitos finance" | lendername=="Equitos" | lendername=="Equidos" | lendername=="Ekvidas" | lendername=="Eqvidas"
replace ok=1 if lendername=="Fin care" | lendername=="HDFC" | lendername=="Hdfc" | lendername=="Logu finance" | lendername=="Loki management" | lendername=="Muthood fincorp" | lendername=="Muthoot finance" | lendername=="Muthu  Finance" | lendername=="Pin care" | lendername=="Rbl (finance)" | lendername=="Sriram finance" | lendername=="Sriram fainance" 
replace ok=1 if lendername=="Mahendra finance" | lendername=="Mahi ndra finance" 
replace ok=1 if lendername=="Therinjavanga" 
replace ok=1 if lendername=="Sundaram finance" |  lendername=="Mahi ndra financeQ" | lendername=="Maglir Mandram"
replace ok=1 if lendername=="Muthu  Finance" |  lendername=="Logu finance" |  lendername=="Rbl (finance)" |  lendername=="Sriram finance" |  lendername=="Sundaram finance" 

ta loanlender ok, m


*2020
use"$loan3", clear
order loanlender_rec, after(loanlender)
drop lender4 loanduration_month
/*
lendername ask only if loanlender<=9
*/

export excel "NEEMSIS2-loans.xlsx", replace firstrow(variables)





****************************************
* END










****************************************
* CLEANING
****************************************
use"panel_loan", clear

*** Lender & reason
label define reason 1"Agriculture" 2"Investment" 3"Family" 4"Repay previous loan" 5"Relatives" 6"Health" 7"Education" 8"Ceremonies" 9"Marriage" 10"Death" 11"Housing" 12"No reason" 13"Other"
gen reasongiven=.
replace reasongiven=1 if loanreasongiven==1
replace reasongiven=3 if loanreasongiven==2
replace reasongiven=6 if loanreasongiven==3
replace reasongiven=4 if loanreasongiven==4
replace reasongiven=11 if loanreasongiven==5
replace reasongiven=2 if loanreasongiven==6
replace reasongiven=8 if loanreasongiven==7
replace reasongiven=9 if loanreasongiven==8
replace reasongiven=7 if loanreasongiven==9
replace reasongiven=5 if loanreasongiven==10
replace reasongiven=10 if loanreasongiven==11
replace reasongiven=12 if loanreasongiven==12
replace reasongiven=13 if loanreasongiven==77
label values reasongiven reason

label define reasonrec 1"Economic" 2"Current" 3"Human capital" 4"Social" 5"Housing" 6"No reason" 7"Other"
gen reasongiven_cat=.
replace reasongiven_cat=1 if loanreasongiven==1
replace reasongiven_cat=2 if loanreasongiven==2
replace reasongiven_cat=3 if loanreasongiven==3
replace reasongiven_cat=2 if loanreasongiven==4
replace reasongiven_cat=5 if loanreasongiven==5
replace reasongiven_cat=1 if loanreasongiven==6
replace reasongiven_cat=4 if loanreasongiven==7
replace reasongiven_cat=4 if loanreasongiven==8
replace reasongiven_cat=3 if loanreasongiven==9
replace reasongiven_cat=2 if loanreasongiven==10
replace reasongiven_cat=4 if loanreasongiven==11
replace reasongiven_cat=6 if loanreasongiven==12
replace reasongiven_cat=7 if loanreasongiven==77
label values reasongiven_cat reasonrec

label define lender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Shop keeper" 7"Friends" 8"Sugar mill loan" 9"Pawn Broker" 10"SHG" 11"Finance" 12"Banks" 13"Coop bank" 14"Group finance" 15"Thandal"
gen lender=.
replace lender=1 if loanlender==1
replace lender=2 if loanlender==2
replace lender=3 if loanlender==3
replace lender=4 if loanlender==4
replace lender=5 if loanlender==5
replace lender=9 if loanlender==6
replace lender=6 if loanlender==7
replace lender=11 if loanlender==8
replace lender=7 if loanlender==9
replace lender=10 if loanlender==10
replace lender=12 if loanlender==11
replace lender=13 if loanlender==12
replace lender=8 if loanlender==13
replace lender=14 if loanlender==14
replace lender=15 if loanlender==15
label values lender lender

label define lenderrec 1"Informal" 2"Semi formal" 3"Formal" 4"Thandal"
gen lender_cat=.
replace lender_cat=1 if loanlender==1
replace lender_cat=1 if loanlender==2
replace lender_cat=1 if loanlender==3
replace lender_cat=1 if loanlender==4
replace lender_cat=1 if loanlender==5
replace lender_cat=2 if loanlender==6
replace lender_cat=1 if loanlender==7
replace lender_cat=3 if loanlender==8
replace lender_cat=1 if loanlender==9
replace lender_cat=2 if loanlender==10
replace lender_cat=3 if loanlender==11
replace lender_cat=3 if loanlender==12
replace lender_cat=1 if loanlender==13
replace lender_cat=3 if loanlender==14
replace lender_cat=4 if loanlender==15
label values lender_cat lenderrec


*** Gen id for main loans
gen mainloan=0
replace mainloan=1 if lendername!="" & year==2010
replace mainloan=1 if lendersex!=. & year==2016
replace mainloan=1 if lenderfirsttime!=. & year==2020

tab mainloan year


*** Loan analysis
ta loansettled
recode loansettled (.=1)
replace loansettled=0 if year==2016 & loan_database=="GOLD"

ta loansettled year

*** drop
drop informal semiformal formal economic current humancap social house incomegen noincomegen economic_amount current_amount humancap_amount social_amount house_amount incomegen_amount noincomegen_amount informal_amount formal_amount semiformal_amount lender2 lender3 totalrepaid2 interestpaid2 principalpaid2 yratepaid monthlyinterestrate



replace loanamount=(loanamount*(100/158))/1000 if year==2016
replace loanamount=(loanamount*(100/184))/1000 if year==2020

replace loan_database="FINANCE" if year==2010

order HHID_panel year caste loan_database loanamount lender lender_cat reasongiven reasongiven_cat otherlenderservices
sort HHID_panel year

ta dummyproblemtorepay year

save"panel_loan_v2", replace
****************************************
* END












****************************************
* USE AND LENDER 2020 
****************************************
use "panel_loan_v2", clear


********** Condition
drop if loansettled==1

ta caste year

ta lender year
ta reasongiven year

/*
*** Clientele using it
fre lender
forvalues i=1(1)15{
gen lenders_`i'=0
}
forvalues i=1(1)15{
replace lenders_`i'=1 if lender==`i'
}
*
cls
preserve 
forvalues i=1(1)15{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)15{
tab lendersHH_`i', m
}
restore

*** Reason given
fre reasongiven
forvalues i=1(1)13{
gen reason_`i'=0
}
forvalues i=1(1)13{
replace reason_`i'=1 if reasongiven==`i'
}
*
cls
preserve 
forvalues i=1(1)13{
bysort HHID_panel: egen reasonHH_`i'=max(reason_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore
*/

*** Amount
tabstat loanamount if year==2010, stat(n mean) by(lender)
tabstat loanamount if year==2016, stat(n mean) by(lender)
tabstat loanamount if year==2020, stat(n mean) by(lender)

tabstat loanamount if year==2010, stat(n mean) by(reasongiven)
tabstat loanamount if year==2016, stat(n mean) by(reasongiven)
tabstat loanamount if year==2020, stat(n mean) by(reasongiven)


*** By caste
ta loan_database year
foreach i in 2020 {
ta lender_cat caste if year==`i'
ta reasongiven_cat caste if year==`i'
}


*** Lender services
keep if loan_database=="FINANCE"
ta loansettled year
tab otherlenderservices year
replace otherlenderservices="" if otherlenderservices=="99"
tab otherlenderservices2 year
replace otherlenderservices2=. if otherlenderservices2==99
tostring otherlenderservices2, replace
tab otherlenderservices2
replace otherlenderservices2="" if otherlenderservices2=="."
egen otherlenderservices_torep=concat(otherlenderservices otherlenderservices2) if year==2010, p(" ")
replace otherlenderservices=otherlenderservices_torep if year==2010
drop otherlenderservices2 otherlenderservices_torep
tab otherlenderservices
split otherlenderservices
gen services1=0
gen services2=0
gen services3=0
gen services4=0
gen services5=0
gen services77=0
forvalues i=1(1)5{
destring otherlenderservices`i', replace
}
forvalues i=1(1)5{
replace services1=1 if otherlenderservices`i'==1
replace services2=1 if otherlenderservices`i'==2
replace services3=1 if otherlenderservices`i'==3
replace services4=1 if otherlenderservices`i'==4
replace services5=1 if otherlenderservices`i'==5
replace services77=1 if otherlenderservices`i'==77
*replace services`i'=. if mainloan==0
}
sort HHID_panel year
sort otherlenderservices
ta otherlenderservices, m
ta otherlenderservices
cls
foreach x in 1 2 3 4 5 77{
tab services`x' year if caste==1, nofreq col
tab services`x' year if caste==2, nofreq col
tab services`x' year if caste==3, nofreq col
}
drop services1 services2 services3 services4 services5 services77 otherlenderservices1 otherlenderservices2 otherlenderservices3 otherlenderservices4 otherlenderservices5


***Main loan
ta mainloan year
keep if mainloan==1
ta caste year

cls
foreach i in 1 2 3 {
ta dummyinterest year if caste==`i', col nofreq
ta termsofrepayment year if caste==`i', col nofreq
ta dummyguarantor year if caste==`i', col nofreq
ta dummyrecommendation year if caste==`i', col nofreq
ta dummyproblemtorepay year if caste==`i', col nofreq
}


*** Borrower services
tab borrowerservices year
replace borrowerservices="" if borrowerservices=="." | borrowerservices=="99"
tab borrowerservices year
split borrowerservices
destring borrowerservices1 borrowerservices2 borrowerservices3, replace
gen services1=0
gen services2=0
gen services3=0
gen services4=0
gen services77=0
forvalues i=1(1)3{
replace services1=1 if borrowerservices`i'==1
replace services2=1 if borrowerservices`i'==2
replace services3=1 if borrowerservices`i'==3
replace services4=1 if borrowerservices`i'==4
replace services77=1 if borrowerservices`i'==77
}
foreach i in 1 2 3 4 77{
replace services`i'=. if mainloan==0
}
cls
foreach x in 1 2 3 4 77{
tab services`x' year if caste==1, col nofreq
tab services`x' year if caste==2, col nofreq
tab services`x' year if caste==3, col nofreq
}
drop services1 services2 services3 services4 services77 borrowerservices1 borrowerservices2 borrowerservices3
****************************************
* END











****************************************
* USE AND LENDER 2020 
****************************************
use "panel_loan_v2", clear

********** Condition
drop if loansettled==1
fre lender_cat
label values lenderscaste jatis
ta lenderscaste year
ta lenderscaste year, m

drop if lender_cat==3
drop if loan_database=="MARRIAGE" & year==2016
drop if loan_database=="GOLD" & year==2016

ta lenderscaste year, m
ta lenderscaste loan_database if year==2016, m
ta loanlender if lenderscaste==. & year==2016, m

ta lenderscaste loan_database if year==2020, m
ta loanlender if lenderscaste==. & year==2020, m


*** Keep informal
fre lender_cat
keep if lender_cat==1
ta lenderscaste year, m
recode lenderscaste (66=.)
recode lenderscaste (99=.)
drop if lenderscaste==.


*** Categories
fre lenderscaste
rename lenderscaste lendersjatis
label values lendersjatis caste
fre lendersjatis
gen lenderscaste=.
replace lenderscaste=1 if lendersjatis==2
replace lenderscaste=1 if lendersjatis==3

replace lenderscaste=2 if lendersjatis==1
replace lenderscaste=2 if lendersjatis==5
replace lenderscaste=2 if lendersjatis==7
replace lenderscaste=2 if lendersjatis==8
replace lenderscaste=2 if lendersjatis==10
replace lenderscaste=2 if lendersjatis==12
replace lenderscaste=2 if lendersjatis==15
replace lenderscaste=2 if lendersjatis==16

replace lenderscaste=3 if lendersjatis==4
replace lenderscaste=3 if lendersjatis==6
replace lenderscaste=3 if lendersjatis==9
replace lenderscaste=3 if lendersjatis==11
replace lenderscaste=3 if lendersjatis==13

replace lenderscaste=77 if lendersjatis==14
replace lenderscaste=77 if lendersjatis==17
replace lenderscaste=77 if lendersjatis==77

replace lenderscaste=88 if lendersjatis==88

label values lenderscaste castecat
label define castecat 1"Dalits" 2"Middle" 3"Upper" 77"Oth" 88"D/K", modify
tab lendersjatis lenderscaste, m


*** Number of loans
tab lenderscaste year if caste==1, col nofreq
tab lenderscaste year if caste==2, col nofreq
tab lenderscaste year if caste==3, col nofreq

tab lenderscaste if year==2010
tab lenderscaste if year==2016
tab lenderscaste if year==2020
cls
tab lenderscaste caste if year==2010, row nofreq
tab lenderscaste caste if year==2016, row nofreq
tab lenderscaste caste if year==2020, row nofreq


*** Amount
cls
tabstat loanamount if caste==1 & year==2010, stat(sum) by(lenderscaste)
tabstat loanamount if caste==2 & year==2010, stat(sum) by(lenderscaste)	
tabstat loanamount if caste==3 & year==2010, stat(sum) by(lenderscaste)	
tabstat loanamount if year==2010, stat(sum) by(lenderscaste) 

cls
tabstat loanamount if caste==1 & year==2016, stat(sum) by(lenderscaste)
tabstat loanamount if caste==2 & year==2016, stat(sum) by(lenderscaste)	
tabstat loanamount if caste==3 & year==2016, stat(sum) by(lenderscaste)	
tabstat loanamount if year==2016, stat(sum) by(lenderscaste) 

cls
tabstat loanamount if caste==1 & year==2020, stat(sum) by(lenderscaste)
tabstat loanamount if caste==2 & year==2020, stat(sum) by(lenderscaste)	
tabstat loanamount if caste==3 & year==2020, stat(sum) by(lenderscaste)	
tabstat loanamount if year==2020, stat(sum) by(lenderscaste) 

****************************************
* END










****************************************
* COVID-19
****************************************
use"$loan3~_2", clear

keep if loan_database=="FINANCE"
ta caste

ta dummyinterest caste, col nofreq
ta dummyinterest caste
fre covfrequencyinterest
ta covfrequencyinterest caste if dummyinterest==1, col nofreq
ta covamountinterest caste if covfrequencyinterest==2, col nofreq

ta covfrequencyrepayment caste, col nofreq

ta covrepaymentstop caste, col nofreq

****************************************
* END
