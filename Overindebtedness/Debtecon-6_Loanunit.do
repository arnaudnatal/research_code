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
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
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
ta lenderrelation lender4

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

replace lender4=lender4_rec if year==2020
ta lender4 year
drop lender4_rec

replace dummymainloans=dummymainloan if year==2016
drop dummymainloan

recode dummymainloans (.=0)

save"panel_loan", replace
****************************************
* END










/*
****************************************
* ALL LOANS in same db
****************************************
*2010
use"$loan1", clear
*Merge sex, caste, nom, village, age
*Add dummy main loan to be sure

rename repayduration22 repayduration2


*** Label
destring loanreasongiven, replace
label define loanreasongiven 1"Agri" 2"Family" 3"Health" 4"Repay" 5"House" 6"Investment" 7"Ceremonies" 8"Marriage" 9"Education" 10"Relatives" 11"Death" 66"Irr" 77"Oth" 88"D/K" 99"N/R", replace
label values loanreasongiven loanreasongiven

destring loanlender, replace
label define loanlender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Pawn broker" 7"Shop keeper" 8"Finance" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 13"Sugar mill loan" 14"Nobody" 66"Irr" 77"Oth" 88"D/K" 99"N/R", replace
label values loanlender loanlender

destring relativerelation, replace
label define relativerelation 1"Maternal uncle" 2"Brother" 3"Paternal uncle" 4"Cousin" 5"Nephew" 6"Father/mother-in-law" 7"Brother-in-law" 8"Wife relatives" 9"Father brother" 10"No relation" 11"Father" 66"Irr" 77"Oth" 88"D/K" 99"N/R", replace
label values relativerelation relativerelation

destring lenderscaste, replace
label define lenderscaste 1"Vanniyar" 2"SC" 3"Arunthatthiyar" 4"Rediyar" 5"Gramani" 6"Naidu" 7"Navithar" 8"Asarai" 9"Settu" 10"Nattar" 12"Muthaliyar" 13"Kulalar" 66"Irr" 77"Oth" 88"D/K" 99"N/R", replace
label values lenderscaste lenderscaste

destring lendernativevillage, replace
label define lendernativevillage 1"Inside the village" 2"Outside the village", replace
label values lendernativevillage lendernativevillage

destring otherlenderservices, replace
label define otherlenderservices 1"Political support" 2"Financial support" 3"Guarantor" 4"General informant" 5"Other" 6"None", replace
label values otherlenderservices otherlenderservices
label values otherlenderservices otherlenderservices2

destring borrowerservices, replace
label define borrowerservices 1"Free service" 2"Work for less wage" 3"Provide support whenever he need" 4"Other", replace
label values borrowerservices borrowerservices

destring interestfrequency, replace
label define interestfrequency 1"Monthly" 2"Weekly" 3"Yearly" 4"Once in six months" 5"Pay whenever have money" 6"Other", replace
label values interestfrequency interestfrequency

destring repayduration1, replace
label define repayduration1 1"Monthly" 2"Weekly" 3"Yearly" 4"Once in six months" 5"Pay whenever have money" 6"Other", replace
label values repayduration1 repayduration1

destring repaydecide, replace
label define repaydecide 1"Myself" 2"Lender", replace
label values repaydecide repaydecide

destring termsofrepayment, replace
label define termsofrepayment 1"Fixed duration" 2"Repay when have money" 3"Repay when asked by the lender", replace
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
*/









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



*** Gen id for main loans
rename dummymainloans mainloan
tab mainloan year


*** Loan analysis
ta loansettled
recode loansettled (.=1)
replace loansettled=0 if year==2016 & loan_database=="GOLD"

ta loansettled year

replace loanamount=loanamount/1000 if year==2010
replace loanamount=(loanamount*(100/158))/1000 if year==2016
replace loanamount=(loanamount*(100/184))/1000 if year==2020

replace loan_database="FINANCE" if year==2010

order HHID_panel year caste loan_database loanamount lender lender_cat reasongiven reason_cat otherlenderservices
sort HHID_panel year

ta dummyproblemtorepay year


********** Panel
merge m:1 HHID_panel using "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\_Miscellaneous\Individual_panel\ODRIIS-HH", keepusing(panel3)
keep if _merge==3
drop _merge

preserve
use "panel_v4", clear
keep if panel==1
keep if year==2010
keep HHID_panel caste assetspanel_q3 incomepanel_q3
save"panel_v4_temp", replace
restore
merge m:1 HHID_panel using "panel_v4_temp", keepusing(caste assetspanel_q3 incomepanel_q3)
drop if _merge==2
drop _merge

save"panel_loan_v2", replace

erase "panel_v4_temp.dta"
****************************************
* END


















****************************************
* STATS for loans
****************************************
cls
use"panel_loan_v2", clear

keep if panel3==1

********** Recode
tab loan_database year
recode loanreasongiven (77=13)
codebook loanreasongiven
label define loanreasongiven 13"Other", modify


/*
********** Amount and number
cls
foreach x in 2010 2016 2020 {
tabstat loanamount if year==`x', stat(n mean) by(loanreasongiven)
foreach i in 1 2 3 {
tabstat loanamount if year==`x' & caste==`i', stat(n mean) by(loanreasongiven)
}
foreach i in 1 2 3 {
tabstat loanamount if year==`x' & assetspanel_q3==`i', stat(n mean) by(loanreasongiven)
}
}
*/

********** Total clientele using it: reason
forvalues i=1(1)13{
gen reason`i'=0
}
forvalues i=1(1)13{
replace reason`i'=1 if loanreasongiven==`i'
}

keep if incomepanel_q3==3


*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)13{
bysort HHID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore

*2016
cls
preserve 
keep if year==2016
forvalues i=1(1)13{
bysort HHID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore

*2020
cls
preserve 
keep if year==2020
forvalues i=1(1)13{
bysort HHID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore



drop reason1 reason2 reason3 reason4 reason5 reason6 reason7 reason8 reason9 reason10 reason11 reason12 reason13 
