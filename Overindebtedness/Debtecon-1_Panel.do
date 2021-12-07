cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
September 30, 2021
-----
Panel for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"
****************************************
* END







****************************************
* PANEL
***************************************
use"$directory\\$wave1", clear
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2010
save"$directory\_temp$wave1", replace

use"$directory\\$wave2", clear
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2016
save"$directory\_temp$wave2", replace

use"$directory\\$wave3", clear
duplicates drop HHID_panel, force
keep HHID_panel year
rename year year2020
save"$directory\_temp$wave3", replace


*Merge all
use"_temp$wave1", clear
merge 1:1 HHID_panel using "_temp$wave2"
drop _merge
merge 1:1 HHID_panel using "_temp$wave3"
drop _merge



*One var
gen panel=0
replace panel=1 if year2010!=. & year2016!=. & year2020!=.
tab panel


keep HHID_panel year2010 year2016 year2020 panel

foreach x in 2010 2016 2020{
recode year`x' (.=0) (`x'=1)
}

sort HHID_panel

save"panel", replace
erase "$directory\_temp$wave1.dta"
erase "$directory\_temp$wave2.dta"
erase "$directory\_temp$wave3.dta"
****************************************
* END










****************************************
* PREPA 2010
****************************************
use "$wave1", clear

* Test
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
sort test2
order test2 test annualincome_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega


egen test3=rowtotal(jobinc_HH_agri jobinc_HH_coolie jobinc_HH_agricoolie jobinc_HH_nregs jobinc_HH_invest jobinc_HH_employee jobinc_HH_selfemp jobinc_HH_pension)
gen test4=test3-annualincome_HH
ta test4
sort test4
order test4 test annualincome_HH jobinc_HH_agri jobinc_HH_coolie jobinc_HH_agricoolie jobinc_HH_nregs jobinc_HH_invest jobinc_HH_employee jobinc_HH_selfemp jobinc_HH_pension

gen test5=test4-test2
sort test5
order test5
restore

drop annualincome_HH
egen annualincome_HH=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)



*Land property
tab1 landowndry landownwet
gen sizeownland=landowndry+landownwet
replace sizeownland=. if sizeownland==0

gen ownland=0
replace ownland=1 if sizeownland>0 & sizeownland!=.

tab ownland
tab sizeownland

*Workage
gen dummy_workage=0
replace dummy_workage=1 if age>=15


*Job+dummy
tab nboccupation_indiv
gen dummy_job=0
replace dummy_job=1 if nboccupation_indiv!=. & nboccupation_indiv>0

gen dummy_nojob=0
replace dummy_nojob=1 if nboccupation_indiv!=. & nboccupation_indiv==0

tab dummy_job dummy_workage


*Age to work 
replace nboccupation_indiv=. if dummy_workage==0
replace dummy_job=. if dummy_workage==0
replace dummy_nojob=. if dummy_workage==0


*HHsize
bysort HHID_panel: gen HHsize=_N


*Nb children
gen dummy_children=0
replace dummy_children=1 if dummy_workage==0
bysort HHID_panel: egen nbchildren_HH=sum(dummy_children)


*Workers structure of HH
bysort HHID_panel: egen nbworkers_HH=sum(dummy_job)
bysort HHID_panel: egen nbnonworkers_HH=sum(dummy_nojob)
*gen workers_to_nonworkers_HH=nbworkers_HH/nbnonworkers_HH
gen nonworkers_to_workers_HH=nbnonworkers_HH/nbworkers_HH
replace nonworkers_to_workers_HH=nbnonworkers_HH if nbworkers_HH==0
gen nontoworkers_HH=nonworkers_to_workers_HH*100
drop nonworkers_to_workers_HH
tab nontoworkers_HH

*Sex ratio of HH
fre sex
label define sex 1"Male" 2"Female"
label values sex sex
fre sex
gen dummy_male=0
gen dummy_female=0
replace dummy_male=1 if sex==1
replace dummy_female=1 if sex==2
bysort HHID_panel: egen nbmale_HH=sum(dummy_male)
bysort HHID_panel: egen nbfemale_HH=sum(dummy_female)
gen female_to_male_HH=nbfemale_HH/nbmale_HH
replace female_to_male_HH=nbfemale if nbmale_HH==0
gen femtomale_HH=female_to_male_HH*100
drop female_to_male_HH
tab femtomale_HH


*Head var
fre relationshiptohead
gen _sex=sex if relationshiptohead==1
gen _maritalstatus=. if relationshiptohead==1
gen _age=age if relationshiptohead==1
gen _edulevel=edulevel if relationshiptohead==1
gen _occupation=mainocc_occupation_indiv if relationshiptohead==1

bysort HHID_panel: egen head_sex=sum(_sex)
bysort HHID_panel: egen head_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen head_age=sum(_age)
bysort HHID_panel: egen head_edulevel=sum(_edulevel)
bysort HHID_panel: egen head_occupation=sum(_occupation)

fre head_sex

drop _sex _maritalstatus _age _edulevel _occupation

*Husband/wife var
gen _sex=sex if relationshiptohead==2
gen _maritalstatus=. if relationshiptohead==2
gen _age=age if relationshiptohead==2
gen _edulevel=edulevel if relationshiptohead==2
gen _occupation=mainocc_occupation_indiv if relationshiptohead==2

bysort HHID_panel: egen wifehusb_sex=sum(_sex)
bysort HHID_panel: egen wifehusb_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen wifehusb_age=sum(_age)
bysort HHID_panel: egen wifehusb_edulevel=sum(_edulevel)
bysort HHID_panel: egen wifehusb_occupation=sum(_occupation)

drop _sex _maritalstatus _age _edulevel _occupation


*Crisis
tab effectcrisislostjob


*Label
label list

label values head_edulevel edulevel
label values head_sex sex

label values wifehusb_edulevel edulevel
label values wifehusb_sex sex


*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount effectcrisislostjob mainocc_occupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega assets_noland1000
 
keep HHID_panel year $dep $indep

duplicates drop

merge 1:1 HHID_panel using "panel"
drop _merge
keep if panel==1

mdesc

save"$wave1-_temp", replace
****************************************
* END












****************************************
* PREPA 2016
****************************************
use "$wave2", clear

*Individual who not live in the HH = to drop
fre livinghome
drop if livinghome==3 | livinghome==4

/*
HHID_panel	HHID2010
MANAM6	28
MANAM18	37
ORA34	51
NAT21	76
MAN11	92
MAN33	ADMPO10
ORA23	ANDOR405
ELA11	ANTEP240
GOV29	ANTGP238
ELA16	PSEP79
SEM12	PSSEM96
KAR29	RAKARU259
KAR3	VENKARU274
MANAM9	VENMTP315
NAT5	VENNAT350
ORA52	VENOR395
*/


*Villagearea+religion+HH debt
tab villagearea, m
tab religion, m
tab loanamount_HH


*Land property
tab ownland, m
replace ownland=0 if ownland==.

tab sizeownland
replace ownland=0 if sizeownland==0


*Workage
gen dummy_workage=0
replace dummy_workage=1 if age>=15


*Job+dummy
tab nboccupation_indiv
gen dummy_job=0
replace dummy_job=1 if nboccupation_indiv!=. & nboccupation_indiv>0

gen dummy_nojob=0
replace dummy_nojob=1 if nboccupation_indiv!=. & nboccupation_indiv==0

tab dummy_job dummy_workage


*Age to work 
replace nboccupation_indiv=. if dummy_workage==0
replace dummy_job=. if dummy_workage==0
replace dummy_nojob=. if dummy_workage==0


*HHsize
bysort HHID_panel: gen HHsize=_N


*Nb children
gen dummy_children=0
replace dummy_children=1 if dummy_workage==0
bysort HHID_panel: egen nbchildren_HH=sum(dummy_children)


*Workers structure of HH
bysort HHID_panel: egen nbworkers_HH=sum(dummy_job)
bysort HHID_panel: egen nbnonworkers_HH=sum(dummy_nojob)
*gen workers_to_nonworkers_HH=nbworkers_HH/nbnonworkers_HH
gen nonworkers_to_workers_HH=nbnonworkers_HH/nbworkers_HH
replace nonworkers_to_workers_HH=nbnonworkers_HH if nbworkers_HH==0
gen nontoworkers_HH=nonworkers_to_workers_HH*100
drop nonworkers_to_workers_HH
tab nontoworkers_HH


*Sex ratio of HH
fre sex
gen dummy_male=0
gen dummy_female=0
replace dummy_male=1 if sex==1
replace dummy_female=1 if sex==2
bysort HHID_panel: egen nbmale_HH=sum(dummy_male)
bysort HHID_panel: egen nbfemale_HH=sum(dummy_female)
gen female_to_male_HH=nbfemale_HH/nbmale_HH
replace female_to_male_HH=nbfemale if nbmale_HH==0
gen femtomale_HH=female_to_male_HH*100
drop female_to_male_HH
tab femtomale_HH


*Head var
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(dummyhead)
ta sum_head
sort sum_head HHID_panel INDID_panel
order HHID_panel INDID_panel sum_head relationshiptohead age

replace relationshiptohead=1 if relationshiptohead==2 & sum_head==0
replace relationshiptohead=0 if HHID_panel=="KUV36" & INDID_panel=="Ind_5"
replace relationshiptohead=0 if HHID_panel=="SEM29" & INDID_panel=="Ind_1"

drop dummyhead sum_head
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(dummyhead)
ta sum_head
sort sum_head HHID_panel INDID_panel
order HHID_panel INDID_panel sum_head relationshiptohead age

bysort HHID_panel: egen max_age=max(age)
replace relationshiptohead=1 if max_age==age & sum_head==0

drop dummyhead sum_head
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(dummyhead)
ta sum_head
sort sum_head HHID_panel INDID_panel
order HHID_panel INDID_panel sum_head relationshiptohead age
drop dummyhead sum_head


fre relationshiptohead
gen _sex=sex if relationshiptohead==1
gen _maritalstatus=maritalstatus if relationshiptohead==1
gen _age=age if relationshiptohead==1
gen _edulevel=edulevel if relationshiptohead==1
gen _occupation=mainocc_occupation_indiv if relationshiptohead==1

bysort HHID_panel: egen head_sex=sum(_sex)
bysort HHID_panel: egen head_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen head_age=sum(_age)
bysort HHID_panel: egen head_edulevel=sum(_edulevel)
bysort HHID_panel: egen head_occupation=sum(_occupation)

fre head_sex

drop _sex _maritalstatus _age _edulevel _occupation

*Husband/wife var
gen _sex=sex if relationshiptohead==2
gen _maritalstatus=maritalstatus if relationshiptohead==2
gen _age=age if relationshiptohead==2
gen _edulevel=edulevel if relationshiptohead==2
gen _occupation=mainocc_occupation_indiv if relationshiptohead==2

bysort HHID_panel: egen wifehusb_sex=sum(_sex)
bysort HHID_panel: egen wifehusb_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen wifehusb_age=sum(_age)
bysort HHID_panel: egen wifehusb_edulevel=sum(_edulevel)
bysort HHID_panel: egen wifehusb_occupation=sum(_occupation)

drop _sex _maritalstatus _age _edulevel _occupation
label values head_edulevel edulevel
label values head_sex sex

label values wifehusb_edulevel edulevel
label values wifehusb_sex sex

*Assets
gen assets1000=assets/1000
gen assets_noland1000=assets_noland/1000

*Crisis
tab1 dummydemonetisation dummymarriage
bysort HHID_panel: egen marriageexpenses_HH=sum(marriageexpenses)
replace marriageexpenses_HH=. if dummymarriage==0


*Gold+education at HH level
foreach x in goldquantity educationexpenses {
bysort HHID_panel: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}





*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummydemonetisation dummymarriage marriageexpenses_HH mainocc_occupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega assets_noland1000
 
keep HHID_panel year $dep $indep


*Occupation
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
restore



duplicates drop

merge 1:1 HHID_panel using "panel"
drop _merge
keep if panel==1

mdesc

*Recode
recode imp1_ds_tot_HH imp1_is_tot_HH loans_HH loanamount_HH marriageexpenses_HH (.=0)

mdesc

save"$wave2-_temp", replace
****************************************
* END




























****************************************
* PREPA 2020
****************************************
use "$wave3", clear

drop age
merge 1:1 HHID_panel INDID_panel using "NEEMSIS2-HH_v24.dta", keepusing(age)
drop _merge
ta age

*Individual who not live in the HH = to drop
preserve
keep if INDID_left!=.
dropmiss, force
tab reasonlefthome
restore
drop if INDID_left!=.

fre livinghome
drop if livinghome==3 | livinghome==4

drop if HHID_panel==""


*Decision
label define deconsumption 77"Other" 1"Yourself - Household head" 2"Spouse (Husband/Wife)" 3"Your spouse and yourseld jointly" 4"Someone else" 5"Yourself and someone else jointly", replace
destring decisionconsumption decisionhealth, replace
label values decisionconsumption deconsumption
label values decisionhealth deconsumption

preserve
duplicates drop HHID_panel, force
tab decisionconsumption 
tab decisionhealth  // avec les gens du HH
restore
/*

Who usually makes decisions about |
making major household purchases? |      Freq.     Percent        Cum.
----------------------------------+-----------------------------------
        Yourself - Household head |        222       44.85       44.85
            Spouse (Husband/Wife) |        250       50.51       95.35
 Your spouse and yourseld jointly |         14        2.83       98.18
                     Someone else |          2        0.40       98.59
Yourself and someone else jointly |          5        1.01       99.60
                            Other |          2        0.40      100.00
----------------------------------+-----------------------------------
                            Total |        495      100.00


 Who usually makes decision about |
    health care in the household? |      Freq.     Percent        Cum.
----------------------------------+-----------------------------------
        Yourself - Household head |        215       43.43       43.43
            Spouse (Husband/Wife) |        256       51.72       95.15
 Your spouse and yourseld jointly |         17        3.43       98.59
                     Someone else |          1        0.20       98.79
Yourself and someone else jointly |          6        1.21      100.00
----------------------------------+-----------------------------------
                            Total |        495      100.00

						
Given that, I choose to put in the regression spouse characteristics.
*/						



*Land property
destring ownland, replace
tab ownland, m
replace ownland=0 if ownland==.

tab sizeownland
replace ownland=0 if sizeownland==0


*Workage
gen dummy_workage=0
replace dummy_workage=1 if age>=15


*Job+dummy
tab nboccupation_indiv
gen dummy_job=0
replace dummy_job=1 if nboccupation_indiv!=. & nboccupation_indiv>0

gen dummy_nojob=0
replace dummy_nojob=1 if nboccupation_indiv!=. & nboccupation_indiv==0

tab dummy_job dummy_workage



*Age to work 
replace nboccupation_indiv=. if dummy_workage==0
replace dummy_job=. if dummy_workage==0
replace dummy_nojob=. if dummy_workage==0


*HHsize
bysort HHID_panel: gen HHsize=_N


*Nb children
gen dummy_children=0
replace dummy_children=1 if dummy_workage==0
bysort HHID_panel: egen nbchildren_HH=sum(dummy_children)


*Workers structure of HH
bysort HHID_panel: egen nbworkers_HH=sum(dummy_job)
bysort HHID_panel: egen nbnonworkers_HH=sum(dummy_nojob)
*gen workers_to_nonworkers_HH=nbworkers_HH/nbnonworkers_HH
gen nonworkers_to_workers_HH=nbnonworkers_HH/nbworkers_HH
replace nonworkers_to_workers_HH=nbnonworkers_HH if nbworkers_HH==0
gen nontoworkers_HH=nonworkers_to_workers_HH*100
drop nonworkers_to_workers_HH
tab nontoworkers_HH



*Sex ratio of HH
fre sex
gen dummy_male=0
gen dummy_female=0
replace dummy_male=1 if sex==1
replace dummy_female=1 if sex==2
bysort HHID_panel: egen nbmale_HH=sum(dummy_male)
bysort HHID_panel: egen nbfemale_HH=sum(dummy_female)
gen female_to_male_HH=nbfemale_HH/nbmale_HH
replace female_to_male_HH=nbfemale if nbmale_HH==0
gen femtomale_HH=female_to_male_HH*100
drop female_to_male_HH
tab femtomale_HH


*Head var
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(dummyhead)
ta sum_head
sort sum_head HHID_panel INDID_panel
order HHID_panel INDID_panel sum_head relationshiptohead age

replace relationshiptohead=1 if relationshiptohead==2 & sum_head==0
replace relationshiptohead=0 if HHID_panel=="ELA18" & INDID_panel=="Ind_2"


drop dummyhead sum_head
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(dummyhead)
ta sum_head
sort sum_head HHID_panel INDID_panel
order HHID_panel INDID_panel sum_head relationshiptohead age

bysort HHID_panel: egen max_age=max(age)
replace relationshiptohead=1 if max_age==age & sum_head==0

drop dummyhead sum_head
gen dummyhead=0
replace dummyhead=1 if relationshiptohead==1
bysort HHID_panel: egen sum_head=sum(dummyhead)
ta sum_head
sort sum_head HHID_panel INDID_panel
order HHID_panel INDID_panel sum_head relationshiptohead age
drop dummyhead sum_head

fre relationshiptohead
gen _sex=sex if relationshiptohead==1
gen _maritalstatus=maritalstatus if relationshiptohead==1
gen _age=age if relationshiptohead==1
gen _edulevel=edulevel if relationshiptohead==1
gen _occupation=mainocc_occupation_indiv if relationshiptohead==1

bysort HHID_panel: egen head_sex=sum(_sex)
bysort HHID_panel: egen head_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen head_age=sum(_age)
bysort HHID_panel: egen head_edulevel=sum(_edulevel)
bysort HHID_panel: egen head_occupation=sum(_occupation)

fre head_sex

drop _sex _maritalstatus _age _edulevel _occupation

*Husband/wife var
gen _sex=sex if relationshiptohead==2
gen _maritalstatus=maritalstatus if relationshiptohead==2
gen _age=age if relationshiptohead==2
gen _edulevel=edulevel if relationshiptohead==2
gen _occupation=mainocc_occupation_indiv if relationshiptohead==2

bysort HHID_panel: egen wifehusb_sex=sum(_sex)
bysort HHID_panel: egen wifehusb_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen wifehusb_age=sum(_age)
bysort HHID_panel: egen wifehusb_edulevel=sum(_edulevel)
bysort HHID_panel: egen wifehusb_occupation=sum(_occupation)

drop _sex _maritalstatus _age _edulevel _occupation
label values head_edulevel edulevel
label values head_sex sex

label values wifehusb_edulevel edulevel
label values wifehusb_sex sex


*Assets
gen assets1000=assets/1000
gen assets_noland1000=assets_noland/1000

*Crisis
tab1 dummymarriage
bysort HHID_panel: egen marriageexpenses_HH=sum(marriageexpenses)
replace marriageexpenses_HH=. if dummymarriage==0


*Gold+education at HH level
foreach x in goldquantity educationexpenses {
bysort HHID_panel: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}


*Destring
ta house
ta housetype
destring religion housetype housetitle, replace


*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummymarriage marriageexpenses_HH assets_noland1000 occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega
 
keep HHID_panel year $dep $indep

*Occupation
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
restore

duplicates drop


merge 1:1 HHID_panel using "panel"
drop _merge
keep if panel==1

mdesc, abbreviate(32)

*Recode
gen pb=0
replace pb=1 if loans_HH==.
/*
HHID_panel
GOV22
GOV4
*/
recode amountownland nboccupation_HH  occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega imp1_ds_tot_HH imp1_is_tot_HH loans_HH loanamount_HH marriageexpenses_HH (.=0)


save"$wave3-_temp", replace
****************************************
* END




















****************************************
* Base panel
****************************************
use"$wave1-_temp", clear


*Append
append using "$wave2-_temp"
append using "$wave3-_temp"


*Panel
merge m:1 HHID_panel using "panel"
keep if _merge==3
drop _merge


*Only keep full panel
tab panel
dis 1146/3
keep if panel==1
drop year2010 year2016 year2020 panel

* 1000
foreach x in loanamount_HH annualincome_HH amountownland {
gen `x'1000=`x'/1000
}


save"panel_v2", replace
****************************************
* END























****************************************
* Var creation
****************************************
use"panel_v2", clear


*Occupation
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
restore



**********Deflate: all in 2010 value 
***https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
foreach x in foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses goldquantityamount amountownland assets1000 annualincome_HH1000 imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH1000 marriageexpenses_HH assets_noland1000 amountownland1000 occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega annualincome_HH {
clonevar `x'_raw=`x'
replace `x'=`x'*(100/158) if year==2016 & `x'!=.
replace `x'=`x'*(100/184) if year==2020 & `x'!=.
}


 

**********Agri income
egen agri_HH=rowtotal(occinc_HH_agri occinc_HH_agricasual)
egen nagri_HH=rowtotal(occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
preserve
egen income_HH=rowtotal(agri_HH nagri_HH)
gen test=income_HH-annualincome_HH
ta test
restore

gen shareagri_HH=agri_HH/annualincome_HH
gen sharenagri_HH=nagri_HH/annualincome_HH
preserve
egen test=rowtotal(shareagri_HH sharenagri_HH)
ta test
restore




**********Debt measure
*Continuous
gen DIR=loanamount_HH/annualincome_HH
gen DAR_without=loanamount_HH/(assets_noland1000*1000)
gen DAR_with=loanamount_HH/(assets1000*1000)
gen DSR=imp1_ds_tot_HH/annualincome_HH
gen ISR=imp1_is_tot_HH/annualincome_HH


*Dummy for overindebtedness
foreach x in DSR DAR_with DAR_without {
forvalues i=30(10)50{
gen `x'`i'=0
}
}

foreach x in DSR DAR_with DAR_without {
forvalues i=30(10)50{
replace `x'`i'=1 if `x'>=.`i' & `x'!=.
}
}


*** Recode for extreme
tabstat DIR DAR_with DAR_without DSR ISR, stat(n mean sd p50 p75 p90 p95 p99 max) by(year) long

foreach x in DIR DAR_with DAR_without DSR ISR {
clonevar `x'_r=`x'
}

replace DIR_r=9.5 if DIR>=10 & year==2010
replace DIR_r=25.51 if DIR>=26 & year==2016
replace DIR_r=50 if DIR>=51 & year==2020

replace DAR_with_r=2 if DAR_with>=2.2 & year==2010
replace DAR_with_r=10.41 if DAR_with>=11 & year==2016
replace DAR_with_r=2.32 if DAR_with>=2.5 & year==2020

replace DAR_without_r=2 if DAR_without>=2.2 & year==2010
replace DAR_without_r=10.41 if DAR_without>=11 & year==2016
replace DAR_without_r=2.32 if DAR_without>=2.5 & year==2020


replace DSR_r=2.66 if DSR>=2.7 & year==2010
replace DSR_r=3.7 if DSR>=3.8 & year==2016
replace DSR_r=7.22 if DSR>=7.3 & year==2020

replace ISR_r=0.74 if ISR>=0.75 & year==2010
replace ISR_r=2.34 if ISR>=2.35 & year==2016
replace ISR_r=3.11 if ISR>=3.13 & year==2020



********** Time
fre year
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

fre time


********** Panel var
encode HHID_panel, gen(panelvar)


********** Caste
replace caste=. if year==2010
replace caste=. if year==2020

bysort HHID_panel: egen max_caste=max(caste)
drop caste
rename max_caste caste
label values caste castecat
fre caste


********** Shock
recode dummydemonetisation dummymarriage (.=0)


save"panel_v3", replace
****************************************
* END
