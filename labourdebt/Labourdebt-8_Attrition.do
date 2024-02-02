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
* Attrition
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
****************************************
* END
















****************************************
* Attrition
****************************************
use"attrition", clear

***** Creation
* DSR
gen DSR=imp1_ds_tot_HH*100/annualincome_HH

* ISR
gen ISR=imp1_is_tot_HH*100/annualincome_HH

* DAR
gen DAR=loanamount_HH*100/annualincome_HH


***** Analysis
global varquanti dependencyratio sexratio head_age nbmale nbfemale HHsize HH_count_child HH_count_adult annualincome_HH ownland assets_total1000 nbloans_HH loanamount_HH DSR ISR DAR shareform
global varquali head_sex head_relationshiptohead head_maritalstatus head_working_pop head_mocc_occupation head_edulevel

* 2010
cls
foreach x in $varquali {
ta `x' attrition if year==2010, col nofreq chi2
}
foreach x in $varquanti {
reg `x' i.attrition if year==2010
}
/*
Dans les ménages attrition il y a :
moins d'enfants
plus d'adultes
*/


* 2016
cls
foreach x in $varquali {
ta `x' attrition if year==2016, col nofreq chi2
}
foreach x in $varquanti {
reg `x' i.attrition if year==2016
}
/*
Dans les ménages attrition il y a :
*/


****************************************
* END




