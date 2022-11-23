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




****************************************
* Stat HH
****************************************
use"panel_HH", clear


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


***** Correlation
pwcorr annualincome_HH assets loanamount_HH imp1_ds_tot_HH, star(.05)
graph matrix dsr isr dar tdr, half msize(vsmall) msymbol(oh)

***** Mean
egen meandex1=rowmean(dsr dar tdr)
egen meandex2=rowmean(dsr dar tar)
egen meandex3=rowmean(isr dar tdr)
egen meandex4=rowmean(isr dar tar)
egen meandex5=rowmean(dsr isr dar tdr)
egen meandex6=rowmean(dsr isr dar tar)
egen meandex7=rowmean(dsr isr dar tdr tar)

tabstat meandex*, stat(n mean cv q min max) by(year)

forvalues i=1/7 {
xtile meandex`i'cat=meandex`i',n(4)
}

forvalues i=1/7 {
tabstat loanamount_HH annualincome_HH assets imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar tdr tar, stat(n q) by(meandex`i'cat)
}




***** FA

*global varstd dsr_std dar_std annualincome_HH_std tar_std
** global varstd isr_std dar_std annualincome_HH_std tar_std
** global varstd dsr_std dar_std annualincome_HH_std tdr_std
** global varstd isr_std dar_std annualincome_HH_std tdr_std

*global varstd dsr_std dar_std assets_std tar_std
** global varstd isr_std dar_std assets_std tar_std
** global varstd dsr_std dar_std assets_std tdr_std
** global varstd isr_std dar_std assets_std tdr_std

*global varstd imp1_ds_tot_HH_std annualincome_HH_std assets_std totHH_givenamt_repa
*global varstd dsr_cr isr_cr dar_cr tdr_cr
*global varstd dsr_cr isr_cr dar_cr tar_cr

global varstd dsr isr dar tdr tar

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
rotate, quartimin
estat rotatecompare

predict fact1 fact2
forvalues i=1/2 {
qui summ fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}
dis 48/73
dis 25/73
gen finindex=(fact1_std*0.66)+(fact2_std*0.34)
pwcorr finindex $varstd, star(.05)
pwcorr finindex dsr dar tdr tar, star(.05)
order HHID_panel year finindex fact*
sort HHID_panel year
xtile finindex_cat=finindex, n(4)
tabstat $var, stat(q) by(finindex_cat)
tabstat dsr isr dar tdr tar, stat(q) by(finindex_cat)
tabstat finindex, stat(n mean q) by(year)

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
