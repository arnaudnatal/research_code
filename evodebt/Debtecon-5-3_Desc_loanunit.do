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
* USE AND LENDER 
****************************************
use "panel_loan_v2", clear


********** Condition
drop if loansettled==1

ta caste year

ta lender year
ta lender4 year
fre lender lender4
ta reasongiven year

ta loan_database year, m

/*
*** Clientele using it
fre lender4
forvalues i=1(1)10{
gen lenders_`i'=0
}
forvalues i=1(1)10{
replace lenders_`i'=1 if lender4==`i'
}
*
cls
preserve 
forvalues i=1(1)10{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel year: gen n=_n
keep if n==1
forvalues i=1(1)10{
tab lendersHH_`i' year, m col nofreq
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
bysort HHID_panel year: gen n=_n
keep if n==1
tab caste year
cls
forvalues i=1(1)13{
tab reasonHH_`i' year if caste==1, m col nofreq
tab reasonHH_`i' year if caste==2, m col nofreq
tab reasonHH_`i' year if caste==3, m col nofreq
}
restore
*/

*** Amount
tabstat loanamount if year==2010, stat(n mean) by(lender4)
tabstat loanamount if year==2016, stat(n mean) by(lender4)
tabstat loanamount if year==2020, stat(n mean) by(lender4)

tabstat loanamount if year==2010, stat(n mean) by(reasongiven)
tabstat loanamount if year==2016, stat(n mean) by(reasongiven)
tabstat loanamount if year==2020, stat(n mean) by(reasongiven)


*** By caste
ta loan_database year
foreach i in 2020 {
ta lender_cat caste if year==`i'
ta reason_cat caste if year==`i'
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
* SUITE
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






****************************************
* TO CHECK
****************************************
cls
use"panel_loan_v2", clear




/*
********** Amount and number
cls
foreach x in 2010 2016 2020 {
*tabstat loanamount if year==`x', stat(n mean) by(loanreasongiven) m
*foreach i in 1 2 3 {
*tabstat loanamount if year==`x' & caste==`i', stat(n mean) by(loanreasongiven) m
*}
foreach i in 1 2 3 {
tabstat loanamount if year==`x' & incomepanel_q3==`i', stat(n mean) by(loanreasongiven) m
}
}
*/

********** Total clientele using it: reason
/*
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
*/
****************************************
* END

