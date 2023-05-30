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
cabiplot, origin

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




********** MCA
global var reason_cat lender_cat lenderservices
fre $var

*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Axis HAC
qui mca $var, meth(ind) normal(princ) comp dim(4)
global var2 d1 d2 d3 d4
predict $var2




********** HAC
cluster wardslinkage $var2
cluster dendrogram, cutnumber(30)
cluster gen clust=groups(5)

ta clust
ta clust year, col nofreq
foreach x in $var{
ta `x' clust, col nofreq
}

gen loanamount1000=loanamount/1000
tabstat loanamount1000, stat(n mean cv q) by(clust)



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

/*
fre otherlenderservices
drop if otherlenderservices==99
drop if otherlenderservices==77

fre borrowerservices
drop if borrowerservices==77
drop if borrowerservices==99
*/

fre reason_cat
drop if reason_cat==6  // no reason
drop if reason_cat==77






********** MCA
global var reason_cat lender_cat dummyinterest dummyhelptosettleloan dummyrecommendation
fre $var

*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Axis for HCA
qui mca $var, meth(ind) normal(princ) comp dim(5)
global var2 d1 d2 d3 d4 d5
predict $var2




********** HAC
cluster wardslinkage $var2
cluster dendrogram, cutnumber(30)
cluster gen clust=groups(6)

ta clust
ta clust year, col nofreq
foreach x in $var{
ta `x' clust, col nofreq
}

****************************************
* END







