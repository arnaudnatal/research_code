*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 31, 2024
*-----
gl link = "labourdebt"
*Attrition
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------











****************************************
* Attrition HH level
****************************************
use"raw/keypanel-HH_long", clear

destring year, replace
drop if HHID==""
drop HHID address villageid villagearea villageid_new

* Debt
merge 1:1 HHID_panel year using "panel_debt_noinvest"
drop _merge

* Controls
merge 1:1 HHID_panel year using "panel_cont_v1"
keep if _merge==3
drop _merge

* Year
drop if year==2020
ta year

* Attrition
preserve
use"raw/keypanel-HH_wide", clear
keep HHID_panel HHID2010 HHID2016 HHID2020
gen attrition=0
replace attrition=1 if HHID2010!="" & HHID2016==""
replace attrition=2 if HHID2016!="" & HHID2020==""
drop HHID2010 HHID2016 HHID2020
gen year=2010 if attrition==1
replace year=2016 if attrition==2
drop if attrition==0
save"_temp", replace
restore

merge 1:1 HHID_panel year using "_temp"
drop _merge
ta year
recode attrition (.=0)

*
save"attrition", replace


**********
use"attrition", clear

***** Var
gen DSR=imp1_ds_tot_HH*100/annualincome_HH
replace loanamount_HH=loanamount_HH/1000
replace annualincome_HH=annualincome_HH/1000

ta hoursamonth_indiv


***** Analysis 2010
tabstat annualincome_HH loanamount_HH DSR if year==2010, stat(n mean median) by(attrition)

reg annualincome_HH i.attrition if year==2010
reg loanamount_HH i.attrition if year==2010
reg DSR i.attrition if year==2010


***** Analysis 2016-17
tabstat annualincome_HH loanamount_HH DSR if year==2016, stat(n mean median) by(attrition)

reg annualincome_HH i.attrition if year==2016
reg loanamount_HH i.attrition if year==2016
reg DSR i.attrition if year==2016

****************************************
* END



























****************************************
* Attrition Indiv level
****************************************
use"panel_laboursupplyindiv_v2", clear

drop if age<14
keep if year==2016
count

keep HHID_panel INDID_panel year hoursamonth_indiv


merge m:1 HHID_panel year using "attrition", keepusing(attrition)
keep if _merge==3
drop _merge


***** Analysis 2016-17
tabstat hoursamonth_indiv, stat(n mean median) by(attrition)
reg hoursamonth_indiv i.attrition

****************************************
* END



