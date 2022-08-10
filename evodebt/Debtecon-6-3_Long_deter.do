*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 31, 2022
*-----
gl link = "evodebt"
*Long deter
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------








****************************************
* Clean
****************************************
cls
use"panel_v10_wide.dta", clear

********** store var from v4
preserve
use"panel_v4", clear
label define housetype 1"Concrete house (non-govt)" 2"Government/green house" 3"Thatched roof house"
label values housetype housetype
*keep if panel==1
keep HHID_panel year housetype housetitle HHsize nbchildren dummymarriage ownland nontoworkers femtomale
reshape wide housetype housetitle HHsize nbchildren dummymarriage ownland nontoworkers femtomale, i(HHID_panel) j(year)
save"_temp_v4", replace
restore

merge 1:1 HHID_panel using "_temp_v4"
drop _merge
erase "_temp_v4.dta"

********** recode
foreach t in 2010 2016 2020 {
***** sex
recode head_sex`t' (1=0) (2=1)
rename head_sex`t' head_female`t'
label define sex2 0"Male" 1"Female", replace
label values head_female`t' sex2
recode wifehusb_sex`t' (1=0) (2=1)
rename wifehusb_sex`t' wifehusb_female`t'
label values wifehusb_female`t' sex2

***** occupation
recode head_occupation`t' (5=4)
recode wifehusb_occupation`t' (5=4)
recode mainocc_occupation`t' (5=4)
label define occ 0"No occ." 1"Agri. SE" 2"Agri. casual" 3"Non-agri. casual" 4"Non-agri. reg." 6"Non-agri. SE" 7"NREGA", replace
label values head_occupation`t' occ
label values wifehusb_occupation`t' occ
label values mainocc_occupation`t' occ


***** education
recode head_edulevel`t' (3=2) (4=2) (5=2)
recode wifehusb_edulevel`t' (3=2) (4=2) (5=2)

***** marital status
label define marital 1"Married" 2"Unmarried" 3"Widowed" 4"Separated/divorced", replace
label values head_maritalstatus`t' marital
label values wifehusb_maritalstatus`t' marital
recode head_maritalstatus`t' (2=0) (3=0) (4=0)
recode wifehusb_maritalstatus`t' (2=0) (3=0) (4=0)
rename head_maritalstatus`t' head_married`t'
rename wifehusb_maritalstatus`t' wifehusb_married`t'

***** villagearea
gen village_ur`t'=.
replace village_ur`t'=0 if villagearea`t'=="Colony"
replace village_ur`t'=1 if villagearea`t'=="Ur"
}


********** Rename 
foreach x in 2010 2016 2020 {
rename DAR_without`x' DAR`x'
rename assets_noland`x' assets`x'
rename annualincome`x' income`x'
rename yearly_expenses`x' expenses`x'
rename ihs_annualincome`x' ihs_income`x'
rename ihs_assets_noland`x' ihs_assets`x'
}

rename sbd_annualincome sbd_income
rename sbd_assets_noland sbd_assets


save"panel_v11_wide.dta", replace
****************************************
* END






****************************************
* Desc
****************************************
cls
use"panel_v11_wide.dta", clear

********** Desc var used
***** Stat
tabstat DSR2010 DSR2016 DSR2020 DAR2010 DAR2016 DAR2020 assets2010 assets2016 assets2020, stat(mean sd p50 min max sk k)

tabstat ihs_DSR2010 ihs_DSR2016 ihs_DSR2020 ihs_DAR2010 ihs_DAR2016 ihs_DAR2020 ihs_assets2010 ihs_assets2016 ihs_assets2020, stat(mean sd p50 min max sk k)

/*
***** Corr
*** 2010
pwcorr DSR2010 DAR2010 assets2010

twoway ///
(scatter DSR2010 assets2010 if DAR2010<5, ms(oh)) ///
(lfit DSR2010 assets2010 if DAR2010<5) ///
, xtitle("Assets") ytitle("DSR") legend(off) name("gph1_2010", replace) ///
note("Correlation" "r=0.18", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

twoway ///
(scatter DAR2010 assets2010 if DAR2010<5, ms(oh)) ///
(lfit DAR2010 assets2010 if DAR2010<5) ///
, xtitle("Assets") ytitle("DAR") legend(off) name("gph3_2010", replace) ///
note("Correlation" "r=-0.08", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

twoway ///
(scatter DAR2010 DSR2010 if DAR2010<5, ms(oh)) ///
(lfit DAR2010 DSR2010 if DAR2010<5) ///
, xtitle("DSR") ytitle("DAR") legend(off) name("gph4_2010", replace) ///
note("Correlation" "r=0.15", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 


*** 2016-17
pwcorr assets2016 DSR2016 DAR2016

twoway ///
(scatter DSR2016 assets2016 if assets2016<1400 & DSR2016<5 & DAR2016<10, ms(oh)) ///
(lfit DSR2016 assets2016 if assets2016<1400 & DSR2016<5 & DAR2016<10) ///
, xtitle("Assets") ytitle("DSR") legend(off) name("gph1_2016", replace) ///
note("Correlation" "r=0.05", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

twoway ///
(scatter DAR2016 assets2016 if assets2016<1400 & DSR2016<5 & DAR2016<10, ms(oh)) ///
(lfit DAR2016 assets2016 if assets2016<1400 & DSR2016<5 & DAR2016<10) ///
, xtitle("Assets") ytitle("DAR") legend(off) name("gph3_2016", replace) ///
note("Correlation" "r=-0.13", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

twoway ///
(scatter DAR2016 DSR2016 if assets2016<1400 & DSR2016<5 & DAR2016<10, ms(oh)) ///
(lfit DAR2016 DSR2016 if assets2016<1400 & DSR2016<5 & DAR2016<10) ///
, xtitle("DSR") ytitle("DAR") legend(off) name("gph4_2016", replace) ///
note("Correlation" "r=-0.01", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 



*** 2020-21
pwcorr assets2020 DSR2020 DAR2020

twoway ///
(scatter DSR2020 assets2020 if assets2020<1400 & DSR2020<5 & DAR2020<10, ms(oh)) ///
(lfit DSR2020 assets2020 if assets2020<1400 & DSR2020<5 & DAR2020<10) ///
, xtitle("Assets") ytitle("DSR") legend(off) name("gph1_2020", replace) ///
note("Correlation" "r=-0.05", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

twoway ///
(scatter DAR2020 assets2020 if assets2020<1400 & DSR2020<5 & DAR2020<10, ms(oh)) ///
(lfit DAR2020 assets2020 if assets2020<1400 & DSR2020<5 & DAR2020<10) ///
, xtitle("Assets") ytitle("DAR") legend(off) name("gph3_2020", replace) ///
note("Correlation" "r=-0.17", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

twoway ///
(scatter DAR2020 DSR2020 if assets2020<1400 & DSR2020<5 & DAR2020<10, ms(oh)) ///
(lfit DAR2020 DSR2020 if assets2020<1400 & DSR2020<5 & DAR2020<10) ///
, xtitle("DSR") ytitle("DAR") legend(off) name("gph4_2020", replace) ///
note("Correlation" "r=0.51", ring(0) pos(1) size(*1) box) aspectratio(1) graphregion(margin(zero)) 

graph combine gph1_2010 gph3_2010 gph4_2010, name(corr2010, replace) title("2010") holes(2) 
graph export "graph\corr2010.pdf", as(pdf) replace

graph combine gph1_2016 gph3_2016 gph4_2016, name(corr2016, replace) title("2016-17") holes(2)
graph export "graph\corr2016.pdf", as(pdf) replace

graph combine gph1_2020 gph3_2020 gph4_2020, name(corr2020, replace) title("2020-21") holes(2)
graph export "graph\corr2020.pdf", as(pdf) replace
*/

********** Desc class
ta cl_vuln
ta cl_vuln dummyvuln


********** Caste and class
cls
foreach x in caste2010 cat_income cat_assets {
ta `x' dummyvuln, row nofreq chi2
}


********** Burden of debt
cls
foreach x in DSR DAR DIR assets income loanamount {
tabstat `x'2010 `x'2016 `x'2020, stat(mean sd p50) by(dummyvuln)
}


********** Type and use of debt I
cls
foreach x in formal eco current humank social home {
tabstat rel_`x'_HH2010 rel_`x'_HH2016 rel_`x'_HH2020, stat(mean sd p50) by (dummyvuln)
}

********** Type and use of debt II
cls
foreach x in formal informal eco current humank social home {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by (dummyvuln)
}


********** Type and use of debt III
cls
foreach x in dummyincrel_formal dummyincrel_informal dummyincrel_repay_amt dummyincrel_eco dummyincrel_current dummyincrel_social dummyincrel_humank dummyinc_nagri {
ta `x' dummyvuln, col nofreq
}



********** Trap
cls
foreach x in repay_amt rel_repay_amt MLborrowstrat_amt rel_MLborrowstrat_amt {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by (dummyvuln)
}


********** SBD
cls
foreach x in sbd_assets sbd_dsr sbd_dar sbd_income sbd_dir {
ta `x' dummyvuln, nofreq row
}


********** Good // Bad
cls
foreach x in rel_MLgooddebt_amt rel_MLbaddebt_amt {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by(dummyvuln)
}


********** Multiple borrowing
cls
foreach x in rel_lf_IMF rel_lf_bank rel_lf_moneylender {
tabstat `x'_amt_HH2010 `x'_amt_HH2016 `x'_amt_HH2020, stat(mean sd p50) by(dummyvuln)
}


********** Threaten debt
cls
foreach x in rel_MLstrat_asse rel_MLstrat_migr {
tabstat `x'_amt_HH2010 `x'_amt_HH2016 `x'_amt_HH2020, stat(mean sd p50) by(dummyvuln)
}



********** Over
cls
foreach x in 30 40 50 {
tabstat DSR`x'2010 DSR`x'2016 DSR`x'2020, stat(mean) by(dummyvuln)
}


********** Head
cls
foreach x in edulevel occupation {
ta head_`x'2010 dummyvuln, nofreq row
*ta head_`x'2016 dummyvuln, nofreq row
*ta head_`x'2020 dummyvuln, nofreq row
}


********** Wife
cls
foreach x in edulevel occupation {
ta wifehusb_`x'2010 dummyvuln, nofreq row
*ta wifehusb_`x'2016 dummyvuln, nofreq row
*ta wifehusb_`x'2020 dummyvuln, nofreq row
}


****************************************
* END









****************************************
* ECONOMETRIC
****************************************
use"panel_v11_wide.dta", clear

ta cl_vuln dummyvuln
ta caste2010 dummyvuln
ta caste2016 dummyvuln
ta caste2020 dummyvuln


********** var to keep
global id HHID_panel sbd_* dummyvuln cl_vuln dummymarriage*
global wealth assets* income*
global hhcharact HHsize* nbchildren* dummymarriage* villageid* village_ur* caste* jatis* ownland* nontoworkers* femtomale* housetype* housetitle*
global headwife head_* wifehusb_* 
global debt1 DSR* DIR* ISR* DAR* loanamount*
global debt2 rel_repay_amt_HH* rel_formal_HH* rel_informal_HH* rel_eco_HH* rel_current_HH* rel_humank_HH* rel_social_HH* rel_home_HH*
global debt3 dummyIMF* dummybank* dummymoneylender* dummyrepay* dummyborrowstrat* dummymigrstrat* dummyassestrat*

global var $id $wealth $hhcharact $headwife $debt1 $debt2 $debt3

foreach y in 2010 2016 2020 {
global HH`y' i.caste`y' i.housetype`y' HHsize`y' nbchildren`y' income`y' assets`y' ownland`y' i.villageid`y'
global head`y' head_female`y' head_age`y' i.head_edulevel`y' i.head_occupation`y'
global wife`y' wifehusb_female`y' wifehusb_age`y' i.wifehusb_edulevel`y' i.wifehusb_occupation`y'

global typedebt`y' rel_formal_HH`y'
global usedebt`y' rel_repay_amt_HH`y' rel_eco_HH`y' rel_current_HH`y' rel_humank_HH`y' rel_social_HH`y' rel_home_HH`y'
}


********** Spec I
cls
probit dummyvuln $HH2010
probit dummyvuln $HH2010 $head2010, baselevels
probit dummyvuln $HH2010 $wife2010, baselevels
probit dummyvuln $HH2010 $head2010 $wife2010, baselevels
probit dummyvuln $HH2010 $head2010 $wife2010 $typedebt2010 $usedebt2010, baselevels


********** Spec II
probit dummyvuln $HH2016
probit dummyvuln $HH2016 $head2016, baselevels
probit dummyvuln $HH2016 $wife2016, baselevels
probit dummyvuln $HH2016 $head2016 $wife2016, baselevels

********** Spec III
probit dummyvuln $HH2020
probit dummyvuln $HH2020 $head2020, baselevels
probit dummyvuln $HH2020 $wife2020, baselevels
probit dummyvuln $HH2020 $head2020 $wife2020, baselevels


*save "panel_v11_wide", replace
****************************************
* END
