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
* Labour var: 2010
****************************************
use"raw/RUME-occup_indiv", clear

keep HHID2010 INDID2010 dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv incomeagri_indiv incomenonagri_indiv shareincomeagri_indiv shareincomenonagri_indiv incagrise_indiv incagricasual_indiv incnonagricasual_indiv incnonagriregnonquali_indiv incnonagriregquali_indiv incnonagrise_indiv incnrega_indiv shareincagrise_indiv shareincagricasual_indiv shareincnonagricasual_indiv shareincnonagriregnonquali_indiv shareincnonagriregquali_indiv shareincnonagrise_indiv shareincnrega_indiv

*** Merge charact
merge 1:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge edu
merge 1:1 HHID2010 INDID2010 using "raw/RUME-education", keepusing(edulevel)
keep if _merge==3
drop _merge


*** Merge HHID_panel
merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010


save"RUME-newoccvar_indiv", replace
****************************************
* END










****************************************
* Labour var: 2016-17
****************************************
use"raw/NEEMSIS1-occup_indiv", clear


keep HHID2016 INDID2016 dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv incomeagri_indiv incomenonagri_indiv shareincomeagri_indiv shareincomenonagri_indiv incagrise_indiv incagricasual_indiv incnonagricasual_indiv incnonagriregnonquali_indiv incnonagriregquali_indiv incnonagrise_indiv incnrega_indiv shareincagrise_indiv shareincagricasual_indiv shareincnonagricasual_indiv shareincnonagriregnonquali_indiv shareincnonagriregquali_indiv shareincnonagrise_indiv shareincnrega_indiv hoursayear_indiv mainocc_hoursayear_indiv

*** Merge charact
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name age sex livinghome)
rename livinghome livinghome2016
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64

*** Merge edu
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education", keepusing(edulevel)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016


save"NEEMSIS1-newoccvar_indiv", replace
****************************************
* END








****************************************
* Labour var: 2020-21
****************************************
use"raw/NEEMSIS2-occup_indiv", clear


keep HHID2020 INDID2020 dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv incomeagri_indiv incomenonagri_indiv shareincomeagri_indiv shareincomenonagri_indiv incagrise_indiv incagricasual_indiv incnonagricasual_indiv incnonagriregnonquali_indiv incnonagriregquali_indiv incnonagrise_indiv incnrega_indiv shareincagrise_indiv shareincagricasual_indiv shareincnonagricasual_indiv shareincnonagriregnonquali_indiv shareincnonagriregquali_indiv shareincnonagrise_indiv shareincnrega_indiv hoursayear_indiv mainocc_hoursayear_indiv

*** Merge charact
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name age sex dummylefthousehold livinghome)
rename dummylefthousehold dummylefthousehold2020
rename livinghome livinghome2020
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64

*** Merge edu
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education", keepusing(edulevel)
keep if _merge==3
drop _merge

*** Merge HHID_panel
merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020


save"NEEMSIS2-newoccvar_indiv", replace
****************************************
* END













****************************************
* Append all
****************************************
use"RUME-newoccvar_indiv", clear

append using "NEEMSIS1-newoccvar_indiv"
append using "NEEMSIS2-newoccvar_indiv"


order HHID_panel year INDID2010 INDID2016 INDID2020
sort HHID_panel year

tostring INDID2016, replace
tostring INDID2020, replace

gen INDID=""
replace INDID=INDID2010 if year==2010
replace INDID=INDID2016 if year==2016
replace INDID=INDID2020 if year==2020

gen HHID=""
replace HHID=HHID2010 if year==2010
replace HHID=HHID2016 if year==2016
replace HHID=HHID2020 if year==2020

order HHID_panel INDID year

* Merge INDID_panel
tostring year, replace
merge m:1 HHID_panel INDID year using "raw/ODRIIS-indiv_long", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring year, replace
order HHID_panel INDID_panel INDID year name sex age dep
sort HHID_panel INDID_panel year

drop HHID2010 HHID2016 HHID2020
drop INDID2010 INDID2016 INDID2020

order HHID_panel HHID INDID_panel INDID

********** Livinghome
fre livinghome*
gen livinghome=.
replace livinghome=livinghome2016 if year==2016
replace livinghome=livinghome2020 if year==2020
drop livinghome2016 livinghome2020
rename dummylefthousehold2020 dummylefthousehold


********** Clean
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
drop livinghome dummylefthousehold
drop shareincagrise_indiv shareincagricasual_indiv shareincnonagricasual_indiv shareincnonagriregnonquali_indiv shareincnonagriregquali_indiv shareincnonagrise_indiv shareincnrega_indiv
drop incagrise_indiv incagricasual_indiv incnonagricasual_indiv incnonagriregnonquali_indiv incnonagriregquali_indiv incnonagrise_indiv incnrega_indiv


********** No occ
fre mainocc_occupation_indiv working_pop
ta mainocc_occupation_indiv working_pop, m
clonevar occup=mainocc_occupation_indiv
replace occup=0 if working_pop==2
ta occup working_pop, m
fre occup
ta occup sex
ta occup year



********** Deflate
foreach x in mainocc_annualincome_indiv annualincome_indiv incomeagri_indiv incomenonagri_indiv {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}


save"panel-newoccvar_indiv", replace
****************************************
* END











****************************************
* Var
****************************************
use"panel-newoccvar_indiv", clear


********** Panel nb
bysort HHID_panel INDID_panel: gen n=_N
ta n
drop if n==1

save"panel-newoccvar_indiv_v2", replace



********** Reshape
reshape wide HHID INDID name sex age dep edulevel dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv incomeagri_indiv incomenonagri_indiv shareincomeagri_indiv shareincomenonagri_indiv occup hoursayear_indiv mainocc_hoursayear_indiv, i(HHID_panel INDID_panel) j(year)


********** New occ var
fre occup2010 occup2016 occup2020
recode occup2010 occup2016 occup2020 (5=4) (6=5) (7=6)
label define occupnew 0"Occ: None" 1"Occ: Agri SE" 2"Occ: Agri casual" 3"Occ: Casual" 4"Occ: Regular" 5"Occ: SE" 6"Occ: NREGA"
label values occup2010 occupnew
label values occup2016 occupnew
label values occup2020 occupnew


********** Abs diff income
gen absmobinc1=log(annualincome_indiv2016-annualincome_indiv2010)
gen absmobinc2=log(annualincome_indiv2020-annualincome_indiv2016)


********** Rel diff income
xtile percincome2010=annualincome_indiv2010, n(100)
xtile percincome2016=annualincome_indiv2016, n(100)
xtile percincome2020=annualincome_indiv2020, n(100)

gen relmobinc1=percincome2016-percincome2010
gen relmobinc2=percincome2020-percincome2016

ta relmobinc1
ta relmobinc2



******** Change 
gen change1=0 if occup2010!=. & occup2016!=.
replace change1=1 if occup2010!=occup2016 & change1==0
ta change1

gen change2=0 if occup2016!=. & occup2020!=.
replace change2=1 if occup2016!=occup2020 & change2==0
ta change2


********** LFP
gen lfp2010=0
replace lfp2010=1 if occup2010>0
ta occup2010 lfp2010

gen lfp2016=0
replace lfp2016=1 if occup2016>0
ta occup2016 lfp2016

gen lfp2020=0
replace lfp2020=1 if occup2020>0
ta occup2020 lfp2020



********** New occupation
gen diffnbocc1=nboccupation_indiv2016-nboccupation_indiv2010
gen diffnbocc2=nboccupation_indiv2020-nboccupation_indiv2016

ta diffnbocc1
ta diffnbocc2

gen dummydiffnbocc1=0
replace dummydiffnbocc1=1 if diffnbocc1>0 & diffnbocc1!=0
ta diffnbocc1 dummydiffnbocc1


gen dummydiffnbocc2=0
replace dummydiffnbocc2=1 if diffnbocc2>0 & diffnbocc2!=0
ta diffnbocc2 dummydiffnbocc2 

/*
Variable qui concerne uniquement des actifs ET actifs
Donc augmentation du nb d'activités
*/



********** More hours a year
gen diffhours2=hoursayear_indiv2020-hoursayear_indiv2016

gen dummydiffhours2=0
replace dummydiffhours2=1 if diffhours2>0 & diffhours2!=.
ta dummydiffhours2



********** Save
duplicates report HHID_panel INDID_panel

save"panel-newoccvar_indiv_v3", replace

****************************************
* END










****************************************
* Merge with main dataset
****************************************
use"panel-newoccvar_indiv_v2", clear


********** Merge new var
merge m:1 HHID_panel INDID_panel using "panel-newoccvar_indiv_v3", keepusing(occup2010 occup2016 occup2020 absmobinc1 absmobinc2 percincome2010 percincome2016 percincome2020 relmobinc1 relmobinc2 change1 change2 lfp2010 lfp2016 lfp2020 diffnbocc1 diffnbocc2 dummydiffnbocc1 dummydiffnbocc2 diffhours2 dummydiffhours2)
drop _merge


********** Merge debt
merge m:1 HHID_panel year using "panel_v8", keepusing(village HHsize HH_count_child HH_count_adult squareroot_HHsize family typeoffamily nbgeneration waystem dummypolygamous sexratio dependencyratio nbloans_HH loanamount_HH trend1 trend2 trends pcaindex pca2index dalits)
keep if _merge==3
drop _merge

order HHID_panel INDID_panel year
sort HHID_panel INDID_panel year


********** Panel var
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
encode HHINDID, gen(panelvar)

order HHINDID panelvar HHID_panel INDID_panel year


********** New var
foreach x in absmobinc relmobinc dummydiffnbocc change {
gen `x'=.
replace `x'=`x'1 if year==2010
replace `x'=`x'2 if year==2016
}


save"panel_indiv_v1", replace
****************************************
* END

















****************************************
* Test
****************************************
cls
use"panel_indiv_v1", clear


*** Panel declaration
xtset panelvar year

preserve
keep if year==2010
foreach y in dummydiffnbocc1 absmobinc1 relmobinc1 {
reg `y' c.pca2index##i.dalits##i.sex
}
restore

cls
preserve
keep if year==2016
foreach y in dummydiffnbocc2 dummydiffhours2 absmobinc2 relmobinc2 {
reg `y' c.pca2index##i.dalits##i.sex
}
restore

cls
preserve
drop if year==2020
foreach y in dummydiffnbocc absmobinc change relmobinc {
xtreg `y' c.pca2index##i.dalits##i.sex, fe
}
restore

****************************************
* END
















****************************************
* Test
****************************************
cls
use"panel_indiv_v1", clear


*** Panel declaration
xtset panelvar year

ta occup, gen(occup_)

xtprobit occup_2 L.pca2index


****************************************
* END

