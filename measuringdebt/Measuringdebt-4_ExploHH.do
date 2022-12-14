*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------




****************************************
* Stat HH
****************************************
use"panel_HH", clear

tabstat annualexpenses annualfoodexpenses annualeducationexpenses annualhealth annualceremonies annualmarriage, stat(n mean cv p50) by(year) long

tabstat annualexpenses if caste==1, stat(n mean cv p50) by(year)
tabstat annualexpenses if caste==2, stat(n mean cv p50) by(year)
tabstat annualexpenses if caste==3, stat(n mean cv p50) by(year)
tabstat annualexpenses, stat(n mean cv p50) by(year)


tabstat dsr isr dar, stat(n mean sd p50) by(year)


/*
DSR = service  / annual income --> burden of debt
ISR = interest / annual income -->
DIR = amount   / annual income -->
DAR = amount   / assets --------->
TDR = bad debt / amount ---------> share of bad debt as debt is not necessary bad
FM  = Rest of liquid wealth after debt payment and consumption
*/





* Monetary indicators
tabstat annualincome_HH assets annualexpenses loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa, stat(n q) by(year) long

tabstat annualincome_HH assets annualexpenses loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa if year==2010, stat(n q) by(caste) long
tabstat annualincome_HH assets annualexpenses loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa if year==2016, stat(n q) by(caste) long
tabstat annualincome_HH assets annualexpenses loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa if year==2020, stat(n q) by(caste) long





* Debt indicators
tabstat dsr isr dar dir tdr tar fm if year==2010, stat(n q) by(caste) long
tabstat dsr isr dar dir tdr tar fm if year==2016, stat(n q) by(caste) long
tabstat dsr isr dar dir tdr tar fm if year==2020, stat(n q) by(caste) long



****************************************
* END








****************************************
* Factor analysis 
****************************************
use"panel_HH", clear

global varstd dailyincome4_pc isr_std tdr_std dar_std
global var dailyincome4_pc isr tdr dar

pwcorr $varstd, star(.05)
*graph matrix $varstd, half msize(vsmall) msymbol(oh)

factor $varstd, pcf
*estat kmo
rotate, quartimin
*estat rotatecompare

predict fact1 fact2
forvalues i=1/2 {
qui summ fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}
dis 36/65
dis 29/65
gen finindex=(fact1_std*0.55)+(fact2_std*0.45)
pwcorr finindex $varstd, star(.05)
order HHID_panel year finindex fact*
sort HHID_panel year
xtile finindex_cat=finindex, n(3)
tabstat finindex $var, stat(q) by(finindex_cat) long

graph box annualincome_HH, over(finindex_cat)
graph box assets, over(finindex_cat)
graph box loanamount_HH, over(finindex_cat)
graph box imp1_ds_tot_HH, over(finindex_cat)
graph box imp1_is_tot_HH, over(finindex_cat)
graph box totHH_givenamt_repa, over(finindex_cat)

****************************************
* END















****************************************
* PCA
****************************************
use"panel_HH", clear

keep HHID_panel year isr dar tdr loanamount_HH assets imp1_ds_tot_HH imp1_is_tot_HH annualincome_HH totHH_givenamt_repa

export delimited using "debtPCA.csv", replace
 
****************************************
* END
