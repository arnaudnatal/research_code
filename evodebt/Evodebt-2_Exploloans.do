*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 14, 2023
*-----
gl link = "evodebt"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------











****************************************
* CA for all loans
****************************************
use"panel_loans", clear

fre lender4 reason_cat

ca lender4 reason_cat
*cabiplot, origin

ta lender4 reason_cat, chi2

****************************************
* END














****************************************
* MCA for all loans
****************************************
use"panel_loans", clear

fre lender4 reason_cat

********** Selection
drop if loan_database=="MARRIAGE"
drop if loansettled==1

fre otherlenderservices
drop if otherlenderservices==99
drop if otherlenderservices==77

fre reason_cat
drop if reason_cat==6  // no reason
drop if reason_cat==77




********** New variables
*** Lender5
fre lender4
gen lender5=lender4
recode lender5 (5=1)
fre lender5
label values lender5 lender3
fre lender5

*** Services
fre otherlenderservices
gen lenderservices=.
replace lenderservices=1 if otherlenderservices==1
replace lenderservices=1 if otherlenderservices==2
replace lenderservices=1 if otherlenderservices==3
replace lenderservices=1 if otherlenderservices==4
replace lenderservices=0 if otherlenderservices==5
replace lenderservices=1 if otherlenderservices==6
label define lenderservices 0"No_serv" 1"Serv"
label values lenderservices lenderservices
ta otherlenderservices lenderservices


*** Amount
tabstat loanamount, stat(min p1 p5 p10 q p90 p95 p99 max)
gen cat_amount=.
replace cat_amount=1 if loanamount<2000
replace cat_amount=2 if loanamount>=2000 & loanamount<5000
replace cat_amount=3 if loanamount>=5000 & loanamount<10000
replace cat_amount=4 if loanamount>=10000 & loanamount<20000
replace cat_amount=5 if loanamount>=20000 & loanamount<40000
replace cat_amount=6 if loanamount>=40000

label define cat_amount 1"V. small" 2"Small" 3"L. Medium" 4"H. Medium" 5"High" 6"V. High"
label values cat_amount cat_amount
fre cat_amount


********** MCA
global var reason_cat lender_cat cat_amount
fre $var

*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Axis HAC
qui mca $var, meth(ind) normal(princ) comp dim(6)
global var2 d1 d2 d3 d4 d5 d6
predict $var2



********** HAC
cluster wardslinkage $var2
cluster dendrogram, cutnumber(30)
cluster gen clust=groups(7)

ta clust
ta clust year, col nofreq
foreach x in $var{
ta `x' clust, col nofreq
}

****************************************
* END


















****************************************
* MCA + HAC for ML
****************************************
use"panel_loans", clear

********** Prepa
*** Selection
keep if dummyml==1
drop if loansettled==1

fre reason_cat
drop if reason_cat==6  // no reason
drop if reason_cat==77

fre borrowerservices
drop if borrowerservices==77
drop if borrowerservices==99

fre termsofrepayment
drop if termsofrepayment==.


*** dummyborrowerservices
gen dummyborrowerservices=.
replace dummyborrowerservices=0 if borrowerservices==4
replace dummyborrowerservices=1 if borrowerservices==1
replace dummyborrowerservices=1 if borrowerservices==2
replace dummyborrowerservices=1 if borrowerservices==3
ta borrowerservices dummyborrowerservices, m
label values dummyborrowerservices yesno


********** MCA
global var reason_cat lender_cat dummyinterest dummyhelptosettleloan dummyborrowerservices
fre $var

*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Axis for HCA
qui mca $var, meth(ind) normal(princ) comp dim(5)
global var2 d1 d2 d3 d4 d5
predict $var2




********** HAC
cluster wardslinkage $var2
cluster dendrogram, cutnumber(89)
cluster gen clust=groups(6)

ta clust
ta clust year, col nofreq
foreach x in $var{
ta `x' clust, col nofreq
}

****************************************
* END







