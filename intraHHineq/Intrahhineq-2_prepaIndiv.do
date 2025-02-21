*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "intraHHineq"
*Prepa Indiv
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\intraHHineq.do"
*-------------------------








****************************************
* 2010
****************************************
use"raw\RUME-HH.dta", clear

* Selection
keep HHID2010 INDID2010 name sex age relationshiptohead religion

* Merge income
merge m:1 HHID2010 using "raw\RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv shareincomeagri_indiv shareincomenonagri_indiv)
drop _merge

* Family compo
merge m:1 HHID2010 using "raw/RUME-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult typeoffamily sexratio)
drop _merge

* Merge KILM
merge 1:1 HHID2010 INDID2010 using "raw\RUME-kilm", keepusing(employed)
drop _merge

* Panel
merge m:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

merge 1:m HHID2010 INDID2010 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2010 INDID2010

gen year=2010
order HHID_panel INDID_panel year


save"temp1",replace
****************************************
* END











****************************************
* 2016
****************************************
use"raw\NEEMSIS1-HH.dta", clear

* Selection
ta livinghome egoid
drop if livinghome>=3
keep HHID2016 INDID2016 name sex age relationshiptohead reasonnotworkpastyear

* Merge income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv shareincomeagri_indiv shareincomenonagri_indiv)
keep if _merge==3
drop _merge

* Family compo
merge m:1 HHID2016 using "raw/NEEMSIS1-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize typeoffamily sexratio)
drop _merge

* Merge KILM
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-kilm", keepusing(employed)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2016 INDID2016

gen year=2016
order HHID_panel INDID_panel year

save"temp2",replace
****************************************
* END











****************************************
* 2020
****************************************
use"raw\NEEMSIS2-HH.dta", clear

* Selection
drop if dummylefthousehold==1
drop if livinghome>=3
keep HHID2020 INDID2020 name sex age relationshiptohead reasonnotworkpastyear

* Merge income
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv shareincomeagri_indiv shareincomenonagri_indiv)
keep if _merge==3
drop _merge

* Family compo
merge m:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize typeoffamily sexratio)
drop _merge

* Merge KILM
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-kilm", keepusing(employed)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2020 INDID2020

gen year=2020
order HHID_panel INDID_panel year

save"temp3",replace
****************************************
* END











****************************************
* Panel
****************************************
use"temp1", clear

append using "temp2"
append using "temp3"

*
drop if HHID_panel=="KUV65"

ta year

* Dummy panel
bysort HHID_panel INDID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel INDID_panel year dummypanel
sort HHID_panel INDID_panel year


* Working pop
fre working_pop
fre reasonnotworkpastyear
ta reasonnotworkpastyear working_pop

replace working_pop=1 if reasonnotworkpastyear==1
replace working_pop=1 if reasonnotworkpastyear==2
replace working_pop=1 if reasonnotworkpastyear==3
replace working_pop=1 if reasonnotworkpastyear==4
replace working_pop=1 if reasonnotworkpastyear==5
replace working_pop=1 if reasonnotworkpastyear==6
replace working_pop=1 if reasonnotworkpastyear==7
replace working_pop=1 if reasonnotworkpastyear==8
replace working_pop=2 if reasonnotworkpastyear==9
replace working_pop=2 if reasonnotworkpastyear==10
replace working_pop=2 if reasonnotworkpastyear==11
replace working_pop=2 if reasonnotworkpastyear==12
replace working_pop=1 if reasonnotworkpastyear==13
replace working_pop=2 if reasonnotworkpastyear==14
replace working_pop=2 if reasonnotworkpastyear==15
replace working_pop=3 if working_pop==1 & annualincome_indiv!=. & annualincome_indiv!=0

* Rename and new var
fre working_pop
ta mainocc_occupation_indiv working_pop
ta age year if working_pop==1 & mainocc_occupation_indiv!=.
gen status=working_pop
replace status=4 if working_pop==1 & mainocc_occupation_indiv!=.
ta status
recode status (3=1) (1=3)
ta status
label define status 1"Active occupied" 2"Active unoccupied" 3"Inactive unoccupied" 4"Inactive occupied"
label values status status
ta status
ta status working_pop


* Drop
drop mainocc_profession_indiv mainocc_sector_indiv nbworker_HH nbnonworker_HH nonworkersratio reasonnotworkpastyear equiscale_HHsize equimodiscale_HHsize squareroot_HHsize dummyworkedpastyear working_pop employed

* Rename
rename mainocc_occupation_indiv mainocc_occupation
rename mainocc_annualincome_indiv mainocc_annualincome
rename mainocc_occupationname_indiv mainocc_occupationname
rename annualincome_indiv total_annualincome
rename nboccupation_indiv nboccupation
rename shareincomeagri_indiv shareincomeagri
rename shareincomenonagri_indiv shareincomenonagri

* Jatis caste
merge m:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis
encode jatis, gen(jatis_code)
drop jatis
rename jatis_code jatis

gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

* Order and sort
order HHID_panel INDID_panel year dummypanel name age sex relationshiptohead caste dalits jatis religion status mainocc_occupation mainocc_annualincome mainocc_occupationname total_annualincome nboccupation shareincomeagri shareincomenonagri

save"panelindiv_v0", replace
****************************************
* END
















****************************************
* Base occupations
****************************************

********** 2010
use"raw\RUME-occupnew.dta", clear

keep HHID2010 INDID2010 year occupationid occupationname kindofwork annualincome profession sector occupation construction_coolie construction_regular construction_qualified dummymainoccupation_indiv annualincome_indiv nboccupation_indiv

* Indiv charact
merge m:1 HHID2010 INDID2010 using"raw/RUME-HH", keepusing(name age sex dummyworkedpastyear relationshiptohead)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

merge m:m HHID2010 INDID2010 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2010 INDID2010

order HHID_panel INDID_panel year age sex dummyworkedpastyear

save"tempRUME", replace



********** 2016
use"raw\NEEMSIS1-occupnew.dta", clear

keep HHID2016 INDID2016 year occupationid occupationname kindofwork annualincome profession sector occupation construction_coolie construction_regular construction_qualified dummymainoccupation_indiv annualincome_indiv nboccupation_indiv

* Indiv charact
merge m:1 HHID2016 INDID2016 using"raw/NEEMSIS1-HH", keepusing(name age sex dummyworkedpastyear livinghome relationshiptohead)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2016 INDID2016

order HHID_panel INDID_panel year age sex dummyworkedpastyear

save"tempNEEMSIS1", replace



********** 2020
use"raw\NEEMSIS2-occupnew.dta", clear

keep HHID2020 INDID2020 year occupationid occupationname kindofwork annualincome profession sector occupation construction_coolie construction_regular construction_qualified dummymainoccupation_indiv annualincome_indiv nboccupation_indiv

* Indiv charact
merge m:1 HHID2020 INDID2020 using"raw/NEEMSIS2-HH", keepusing(name age sex dummyworkedpastyear livinghome dummylefthousehold relationshiptohead)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID202 INDID2020

order HHID_panel INDID_panel year age sex dummyworkedpastyear

save"tempNEEMSIS2", replace


***** Append
use"tempRUME", clear

append using "tempNEEMSIS1"
append using "tempNEEMSIS2"


save"panelocc_v0", replace



***** Modifications
use"panelocc_v0", clear

foreach x in annualincome annualincome_indiv {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=(`x'/12)
replace `x'=round(`x',0.01)
}
rename annualincome monthlyincome
rename annualincome_indiv tot_monthlyincome

drop construction_coolie construction_regular construction_qualified

* Merge caste and jatis
merge m:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis
order HHID_panel INDID_panel year name age sex relationshiptohead jatis caste livinghome dummylefthousehold

save"panelocc_v1", replace


***** Selection
use"panelocc_v1", clear

fre livinghome
drop if livinghome==4

fre dummylefthousehold

drop livinghome dummylefthousehold dummyworkedpastyear occupationid

sort HHID_panel INDID_panel year occupationname

fre occupation
list HHID_panel INDID_panel year kindofwork occupationname monthlyincome if occupation==0, clean noobs
drop if occupation==0

fre occupation
codebook occupation
label define occupcode 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Reg non-qualified" 5"Reg qualified" 6"Self-employed" 7"MGNREGA", replace
fre occupation

*
drop kindofwork
rename tot_monthlyincome total_monthlyincome
rename nboccupation_indiv nboccupation


save"panelocc_v2", replace
****************************************
* END
















****************************************
* Ineq var
****************************************
use"panelindiv_v0", clear

*
fre status
fre sex
gen maleoccupied=1 if sex==1 & (status==1 | status==9)
gen femaoccupied=1 if sex==2 & (status==1 | status==9)

*
bysort HHID_panel year: egen nbmaleoccupied=sum(maleoccupied)
bysort HHID_panel year: egen nbfemaoccupied=sum(femaoccupied)

*
keep HHID_panel year nbmaleoccupied nbfemaoccupied
duplicates drop

ta nbmaleoccupied year, col nofreq
ta nbfemaoccupied year, col nofreq

****************************************
* END







