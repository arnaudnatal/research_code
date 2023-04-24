*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------






/*
****************************************
* Just before work
****************************************
use"panel_loans", clear


gen tokeep=1
replace tokeep=0 if year==2020 & loandate>td(31dec2019)
replace tokeep=0 if year==2016 & loandate>td(31dec2015)
replace tokeep=0 if year==2010 & loandate>td(31dec2009)

ta tokeep year
keep if tokeep==1
drop if loandate==.
ta year

bysort HHID_panel year: egen loanamount2_HH=sum(loanamount)

keep HHID_panel year loanamount2_HH
duplicates drop
ta year

bysort HHID_panel: gen panel=_N
ta panel year

****************************************
* END
*/










****************************************
* CA with ALL loans
****************************************
use"panel_loans", clear

fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77

cls
ta loanlender year, col nofreq
ta lender4 year, col nofreq

ta loanlender loanreasongiven
ta lender4 loanreasongiven

****************************************
* END











****************************************
* MCA with ML
****************************************
use"panel_loans_nonsettled", clear

fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77
keep if dummyml==1
drop if dummyhelptosettleloan==.

ta year

mca reason_cat lender_cat otherlenderservices_poli otherlenderservices_fina otherlenderservices_guar otherlenderservices_gene otherlenderservices_none otherlenderservices_othe borrowerservices_free borrowerservices_less borrowerservices_supp borrowerservices_none borrowerservices_othe dummyinterest, meth(ind) normal(princ) comp
mcaplot, overlay legend(off) xline(0) yline(0) scale(.8)

predict a1 a2

scatter a2 a1, xline(0) yline(0)

****************************************
* END









****************************************
* MCA
****************************************
use"panel_loans_nonsettled", clear

fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77


*** Deflate and round
foreach x in loanamount2 imp1_debt_service imp1_interest_service {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
replace `x'=round(`x',1)
}


*** New grp for lender and reason
ta lender4 lender_cat
gen lender2_cat=.
replace lender2_cat=1 if lender4==1
replace lender2_cat=1 if lender4==2
replace lender2_cat=1 if lender4==3
replace lender2_cat=2 if lender4==4
replace lender2_cat=1 if lender4==5
replace lender2_cat=3 if lender4==6
replace lender2_cat=1 if lender4==7
replace lender2_cat=3 if lender4==8
replace lender2_cat=3 if lender4==9
replace lender2_cat=2 if lender4==10

ta lender2_cat
label values lender2_cat lender_cat
fre lender2_cat


ta loanreasongiven reason_cat
gen reason2_cat=.
replace reason2_cat=1 if loanreasongiven==1
replace reason2_cat=2 if loanreasongiven==2
replace reason2_cat=3 if loanreasongiven==3
replace reason2_cat=4 if loanreasongiven==4
replace reason2_cat=5 if loanreasongiven==5
replace reason2_cat=1 if loanreasongiven==6
replace reason2_cat=6 if loanreasongiven==7
replace reason2_cat=6 if loanreasongiven==8
replace reason2_cat=3 if loanreasongiven==9
replace reason2_cat=2 if loanreasongiven==10
replace reason2_cat=6 if loanreasongiven==11

ta loanreasongiven reason2_cat
label define reason2_cat 1"econ" 2"curr" 3"huma" 4"repa" 5"hous" 6"soci"
label values reason2_cat reason2_cat


*** Group quanti var
tabstat loanamount imp1_debt_service imp1_interest_service, stat(min p1 p5 p10 q p90 p95 p99 max)

* When the debt amount is high?
tabstat loanamount, stat(min p1 p5 p10 q p90 p95 p99 max)
gen amount=.
replace amount=1 if loanamount<=2000
replace amount=2 if loanamount>2000 & loanamount<=5000
replace amount=3 if loanamount>5000 & loanamount<=15000
replace amount=4 if loanamount>15000 & loanamount<=50000
replace amount=5 if loanamount>50000

label define amount 1"VSmall" 2"Small" 3"Medium" 4"High" 5"VHigh"
label values amount amount

fre amount
*

*** Clean
/*
preserve
keep HHID_panel INDID_panel year loanid loan_database loanlender lender4 lender_cat lender2_cat loanreasongiven reason_cat reason2_cat costamount cost amount
export delimited using "debtMCA.csv", replace q
restore
*/


*** Test using Stata
cls
mca lender2_cat reason2_cat amount, meth(ind) normal(princ) comp
mca lender4 loanreasongiven amount, meth(ind) normal(princ) comp
****************************************
* END
