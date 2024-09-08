*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Prepa Indiv
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
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

merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv"
drop _merge

* Family compo
merge m:1 HHID2010 using "raw/RUME-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize typeoffamily sexratio)
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
keep HHID2016 INDID2016 name sex age relationshiptohead

* Merge income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Family compo
merge m:1 HHID2016 using "raw/NEEMSIS1-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize typeoffamily sexratio)
drop _merge

* Merge KILM
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-kilm", keepusing(employed)
drop _merge

* Ego
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-ego", keepusing(everwork workpastsevendays searchjob startbusiness reasondontsearchjob searchjobsince15 businessafter15 reasondontsearchjobsince15 nbermonthsearchjob readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage kindofworkfirstjob unpaidinbusinessfirstjob agestartworking agestartworkingpaidjob methodfindfirstjob monthstofindjob beforemainoccup otherbeforemainoccup mainoccuptype dummypreviouswagejob previousjobcontract reasonstoppedwagejob)
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
keep HHID2020 INDID2020 name sex age relationshiptohead

* Merge income
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Family compo
merge m:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize typeoffamily sexratio)
drop _merge

* Merge KILM
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-kilm", keepusing(employed)
drop _merge

* Ego
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-ego", keepusing(everwork workpastsevendays searchjob startbusiness reasondontsearchjob searchjobsince15 businessafter15 reasondontsearchjobsince15 nbermonthsearchjob readystartjob methodfindjob jobpreference moveoutsideforjob moveoutsideforjobreason aspirationminimumwage kindofworkfirstjob unpaidinbusinessfirstjob agestartworking agestartworkingpaidjob methodfindfirstjob monthstofindjob beforemainoccup otherbeforemainoccup mainoccuptype dummypreviouswagejob previousjobcontract reasonstoppedwagejob respect workmate useknowledgeatwork satisfyingpurpose schedule takeholiday agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 changework happywork satisfactionsalary executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9 accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10 workexposure1 workexposure2 workexposure3 workexposure4 workexposure5 professionalequipment break retirementwork verbalaggression physicalagression sexualharassment sexualaggression discrimination1 discrimination2 discrimination3 discrimination4 discrimination5 discrimination6 discrimination7 discrimination8 discrimination9 resdiscrimination1 resdiscrimination2 resdiscrimination3 resdiscrimination4 resdiscrimination5 rurallocation lackskill)
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

ta year

* Dummy panel
bysort HHID_panel INDID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel INDID_panel year dummypanel
sort HHID_panel INDID_panel year


* Caste


* Working pop
fre working_pop
replace working_pop=2 if working_pop==1 & age>35 & (annualincome_indiv==. | annualincome_indiv==0)
replace working_pop=3 if working_pop==1 & age>35 & annualincome_indiv!=. & annualincome_indiv!=0

drop nbworker_HH nbnonworker_HH nonworkersratio

gen wp_inactive=0
replace wp_inactive=1 if working_pop==1

gen wp_unoccupi=0
replace wp_unoccupi=1 if working_pop==2

gen wp_occupied=0
replace wp_occupied=1 if working_pop==3

foreach x in inactive unoccupi occupied {
bysort HHID_panel year: egen wp_`x'_HH=sum(wp_`x')
}
gen wp_active_HH=wp_unoccupi_HH+wp_occupied_HH

gen test=HHsize-wp_active_HH-wp_inactive_HH
ta test
drop test


* Recode moc
fre mainocc_occupation_indiv
gen moc_indiv=mainocc_occupation_indiv
fre moc_indiv
recode moc_indiv (0=.) (5=4) (6=5) (7=6)
label define moc_indiv 1"Agri self-employed" 2"Agri casual" 3"Non-agri casual" 4"Non-agri regular" 5"Non-agri self-employed" 6"MGNREGA"
label values moc_indiv moc_indiv

* Jatis caste
merge m:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis
encode jatis, gen(jatis_code)
drop jatis
rename jatis_code jatis

* 
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

ta caste, gen(caste_)

order jatis caste caste_1 caste_2 caste_3 dalits, after(age)

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


save"panelocc_v2", replace
****************************************
* END



