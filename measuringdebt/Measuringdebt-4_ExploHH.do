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


* Debt
tabstat dsr isr dar, stat(n mean sd min max q) by(year)


* Debt trap
ta dumHH_given_repa year, col
ta dumHH_effective_repa year, col
/*
I think it is better to use given as it is for all loans for all years
(effective only for ML in 2010)
*/

tabstat dsr isr dar tdr tar if year==2010, stat(n mean cv q) by(dumHH_given_repa) long
tabstat dsr isr dar tdr tar if year==2016, stat(n mean cv q) by(dumHH_given_repa) long
tabstat dsr isr dar tdr tar if year==2020, stat(n mean cv q) by(dumHH_given_repa) long

****************************************
* END








****************************************
* Factor analysis 
****************************************
use"panel_HH", clear


pwcorr dsr isr dar tdr tar

pwcorr loanamount_HH annualincome_HH assets imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa

pwcorr loanamount_HH annualincome_HH assets imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar tdr tar

pwcorr dsr dar tar annualincome_HH

***** FA No.1
global var loanamount_HH annualincome_HH assets imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa

foreach x in $var {
egen `x'_std=std(`x')
}

global varstd loanamount_HH_std annualincome_HH_std assets_std imp1_ds_tot_HH_std imp1_is_tot_HH_std totHH_givenamt_repa_std


minap $var
factor $var, pcf
estat kmo
rotate, quartimin
predict fact1 fact2 fact3

foreach x in fact1 fact2 fact3 {
qui summ `x'
gen `x'_std = (`x'-r(min))/(r(max)-r(min))
}

dis 34.92/79.39
dis 23.13/79.39
dis 21.33/79.39
gen finindex=(fact1_std*0.44)+(fact2_std*0.29)+(fact3_std*0.27)

tabstat finindex, stat(n mean sd q) by(year)

pwcorr finindex $varstd

pwcorr finindex dsr isr dar tdr tar

xtile finindex_cat=finindex, n(4)

tabstat dsr isr dar tdr tar, stat(q) by(finindex_cat)










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
