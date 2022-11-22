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
* PCA
****************************************
use"panel_HH", clear

keep HHID_panel year isr dar tdr loanamount_HH assets imp1_ds_tot_HH imp1_is_tot_HH annualincome_HH totHH_givenamt_repa

export delimited using "debtPCA.csv", replace
 
****************************************
* END
