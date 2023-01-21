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


*** Other activities
preserve
use"raw/RUME-occupnew", clear

* Clean
fre occupation
drop if occupation==0
recode occupation (5=4)

* Dummies
ta occupation, gen(occup_)

* Income
forvalues i=1/6 {
gen occup_inc_`i'=0
}

forvalues i=1/6 {
replace occup_inc_`i'=annualincome if occup_`i'==1
}

* Indiv
forvalues i=1/6 {
bysort HHID2010 INDID2010: egen sum_occup_`i'=sum(occup_`i')
bysort HHID2010 INDID2010: egen sum_occup_inc_`i'=sum(occup_inc_`i')
}
keep HHID2010 INDID2010 sum_occup_1 sum_occup_inc_1 sum_occup_2 sum_occup_inc_2 sum_occup_3 sum_occup_inc_3 sum_occup_4 sum_occup_inc_4 sum_occup_5 sum_occup_inc_5 sum_occup_6 sum_occup_inc_6
duplicates drop

forvalues i=1/6 {
rename sum_occup_`i' occ_`i'
rename sum_occup_inc_`i' occinc_`i'
}

* Dummies
forvalues i=1/6 {
gen dumocc_`i'=0
}
forvalues i=1/6 {
replace dumocc_`i'=1 if occ_`i'>0
}
order HHID2010 INDID2010 dumocc_1 dumocc_2 dumocc_3 dumocc_4 dumocc_5 dumocc_6 occ_1 occ_2 occ_3 occ_4 occ_5 occ_6 occinc_1 occinc_2 occinc_3 occinc_4 occinc_5 occinc_6

save "occtomerge2010", replace
restore

merge 1:1 HHID2010 INDID2010 using "occtomerge2010"
drop if _merge==2
drop _merge


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


*** Other activities
preserve
use"raw/NEEMSIS1-occupnew", clear

* Clean
fre occupation
drop if occupation==0
recode occupation (5=4)

* Dummies
ta occupation, gen(occup_)

* Income
forvalues i=1/6 {
gen occup_inc_`i'=0
}

forvalues i=1/6 {
replace occup_inc_`i'=annualincome if occup_`i'==1
}

* Hours
forvalues i=1/6 {
gen occup_hours_`i'=0
}

forvalues i=1/6 {
replace occup_hours_`i'=hoursayear if occup_`i'==1
}

* Indiv
forvalues i=1/6 {
bysort HHID2016 INDID2016: egen sum_occup_`i'=sum(occup_`i')
bysort HHID2016 INDID2016: egen sum_occup_inc_`i'=sum(occup_inc_`i')
bysort HHID2016 INDID2016: egen sum_occup_hours_`i'=sum(occup_hours_`i')
}
keep HHID2016 INDID2016 sum_occup_1 sum_occup_inc_1 sum_occup_2 sum_occup_inc_2 sum_occup_3 sum_occup_inc_3 sum_occup_4 sum_occup_inc_4 sum_occup_5 sum_occup_inc_5 sum_occup_6 sum_occup_inc_6 sum_occup_hours_1 sum_occup_hours_2 sum_occup_hours_3 sum_occup_hours_4 sum_occup_hours_5 sum_occup_hours_6
duplicates drop

forvalues i=1/6 {
rename sum_occup_`i' occ_`i'
rename sum_occup_inc_`i' occinc_`i'
rename sum_occup_hours_`i' occhours_`i'
}

* Dummies
forvalues i=1/6 {
gen dumocc_`i'=0
}
forvalues i=1/6 {
replace dumocc_`i'=1 if occ_`i'>0
}
order HHID2016 INDID2016 dumocc_1 dumocc_2 dumocc_3 dumocc_4 dumocc_5 dumocc_6 occ_1 occ_2 occ_3 occ_4 occ_5 occ_6 occinc_1 occinc_2 occinc_3 occinc_4 occinc_5 occinc_6 occhours_1 occhours_2 occhours_3 occhours_4 occhours_5 occhours_6

save "occtomerge2016", replace
restore

merge 1:1 HHID2016 INDID2016 using "occtomerge2016"
drop if _merge==2
drop _merge



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


*** Other activities
preserve
use"raw/NEEMSIS2-occupnew", clear

* Clean
fre occupation
drop if occupation==0
recode occupation (5=4)

* Dummies
ta occupation, gen(occup_)

* Income
forvalues i=1/6 {
gen occup_inc_`i'=0
}

forvalues i=1/6 {
replace occup_inc_`i'=annualincome if occup_`i'==1
}

* Hours
forvalues i=1/6 {
gen occup_hours_`i'=0
}

forvalues i=1/6 {
replace occup_hours_`i'=hoursayear if occup_`i'==1
}

* Indiv
forvalues i=1/6 {
bysort HHID2020 INDID2020: egen sum_occup_`i'=sum(occup_`i')
bysort HHID2020 INDID2020: egen sum_occup_inc_`i'=sum(occup_inc_`i')
bysort HHID2020 INDID2020: egen sum_occup_hours_`i'=sum(occup_hours_`i')
}
keep HHID2020 INDID2020 sum_occup_1 sum_occup_inc_1 sum_occup_2 sum_occup_inc_2 sum_occup_3 sum_occup_inc_3 sum_occup_4 sum_occup_inc_4 sum_occup_5 sum_occup_inc_5 sum_occup_6 sum_occup_inc_6 sum_occup_hours_1 sum_occup_hours_2 sum_occup_hours_3 sum_occup_hours_4 sum_occup_hours_5 sum_occup_hours_6
duplicates drop

forvalues i=1/6 {
rename sum_occup_`i' occ_`i'
rename sum_occup_inc_`i' occinc_`i'
rename sum_occup_hours_`i' occhours_`i'
}

* Dummies
forvalues i=1/6 {
gen dumocc_`i'=0
}
forvalues i=1/6 {
replace dumocc_`i'=1 if occ_`i'>0
}
order HHID2020 INDID2020 dumocc_1 dumocc_2 dumocc_3 dumocc_4 dumocc_5 dumocc_6 occ_1 occ_2 occ_3 occ_4 occ_5 occ_6 occinc_1 occinc_2 occinc_3 occinc_4 occinc_5 occinc_6 occhours_1 occhours_2 occhours_3 occhours_4 occhours_5 occhours_6

save "occtomerge2020", replace
restore

merge 1:1 HHID2020 INDID2020 using "occtomerge2020"
drop if _merge==2
drop _merge


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
foreach x in mainocc_annualincome_indiv annualincome_indiv incomeagri_indiv incomenonagri_indiv occinc_1 occinc_2 occinc_3 occinc_4 occinc_5 occinc_6 {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}



********** Rename
foreach x in dumocc occ occinc occhours {
rename `x'_1 `x'_agrise
rename `x'_2 `x'_agricasu
rename `x'_3 `x'_casu
rename `x'_4 `x'_regu
rename `x'_5 `x'_se
rename `x'_6 `x'_nrega
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
*ta n
*drop if n==1

save"panel-newoccvar_indiv_v2", replace



********** Reshape
reshape wide HHID INDID name sex age dep edulevel dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv incomeagri_indiv incomenonagri_indiv shareincomeagri_indiv shareincomenonagri_indiv occup hoursayear_indiv mainocc_hoursayear_indiv dumocc_agrise dumocc_agricasu dumocc_casu dumocc_regu dumocc_se dumocc_nrega occ_agrise occ_agricasu occ_casu occ_regu occ_se occ_nrega occinc_agrise occinc_agricasu occinc_casu occinc_regu occinc_se occinc_nrega occhours_agrise occhours_agricasu occhours_casu occhours_regu occhours_se occhours_nrega, i(HHID_panel INDID_panel) j(year)


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


********** HH charact
merge m:1 HHID_panel year using "panel_v8", keepusing(remittnet_HH assets_total villageid)
drop _merge

encode villageid, gen(vill)
ta vill, gen(vill_)
drop vill


save"panel_indiv_v1", replace
****************************************
* END


















****************************************
* ML SEM and LEV at individual level
****************************************
cls
use"panel_indiv_v1", clear


*** Seletion working age
drop if age<15


*** Panel declaration
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
xtset panelvar time
set maxiter 50


*** Var crea


*** Macro
global xHH HHsize HH_count_child sexratio dependencyratio remittnet_HH assets_total vill_2 vill_3 vill_4 vill_5 vill_6 vill_7 vill_8 vill_9 vill_10


*** LEV
log using "C:\Users\Arnaud\Downloads\Indiv_LEV.log", replace

foreach y in dumocc_agrise dumocc_agricasu dumocc_casu dumocc_regu dumocc_se dumocc_nrega {
foreach x in pca2index pcaindex loanamount_HH {
capture noisily xtlogit `y' L.`x' c.age##c.age i.sex i.dalits i.edulevel $xHH, fe
}
}

log close



****************************************
* END

