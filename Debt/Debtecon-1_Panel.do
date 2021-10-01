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
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\2010_2016_2020"
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
global wave2 "NEEMSIS1-HH_v7"
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
****************************************
* END


































****************************************
* PREPA 2010
****************************************
use "$wave1", clear

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
gen _occupation=. if relationshiptohead==1

bysort HHID_panel: egen head_sex=sum(_sex)
bysort HHID_panel: egen head_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen head_age=sum(_age)
bysort HHID_panel: egen head_edulevel=sum(_edulevel)
bysort HHID_panel: egen head_occupation=sum(_occupation)

drop _sex _maritalstatus _age _edulevel _occupation

*Husband/wife var
gen _sex=sex if relationshiptohead==2
gen _maritalstatus=. if relationshiptohead==2
gen _age=age if relationshiptohead==2
gen _edulevel=edulevel if relationshiptohead==2
gen _occupation=. if relationshiptohead==2

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
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount effectcrisislostjob
 
keep HHID_panel year $dep $indep

duplicates drop


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
fre relationshiptohead
gen _sex=sex if relationshiptohead==1
gen _maritalstatus=maritalstatus if relationshiptohead==1
gen _age=age if relationshiptohead==1
gen _edulevel=edulevel if relationshiptohead==1
gen _occupation=. if relationshiptohead==1

bysort HHID_panel: egen head_sex=sum(_sex)
bysort HHID_panel: egen head_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen head_age=sum(_age)
bysort HHID_panel: egen head_edulevel=sum(_edulevel)
bysort HHID_panel: egen head_occupation=sum(_occupation)

drop _sex _maritalstatus _age _edulevel _occupation

*Husband/wife var
gen _sex=sex if relationshiptohead==2
gen _maritalstatus=maritalstatus if relationshiptohead==2
gen _age=age if relationshiptohead==2
gen _edulevel=edulevel if relationshiptohead==2
gen _occupation=. if relationshiptohead==2

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
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummydemonetisation dummymarriage marriageexpenses_HH
 
keep HHID_panel year $dep $indep

duplicates drop

save"$wave2-_temp", replace
****************************************
* END




























****************************************
* PREPA 2020
****************************************
use "$wave3", clear


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
fre relationshiptohead
gen _sex=sex if relationshiptohead==1
gen _maritalstatus=maritalstatus if relationshiptohead==1
gen _age=age if relationshiptohead==1
gen _edulevel=edulevel if relationshiptohead==1
gen _occupation=. if relationshiptohead==1

bysort HHID_panel: egen head_sex=sum(_sex)
bysort HHID_panel: egen head_maritalstatus=sum(_maritalstatus)
bysort HHID_panel: egen head_age=sum(_age)
bysort HHID_panel: egen head_edulevel=sum(_edulevel)
bysort HHID_panel: egen head_occupation=sum(_occupation)

drop _sex _maritalstatus _age _edulevel _occupation

*Husband/wife var
gen _sex=sex if relationshiptohead==2
gen _maritalstatus=maritalstatus if relationshiptohead==2
gen _age=age if relationshiptohead==2
gen _edulevel=edulevel if relationshiptohead==2
gen _occupation=. if relationshiptohead==2

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
destring religion housetype housetitle, replace


*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummymarriage marriageexpenses_HH
 
keep HHID_panel year $dep $indep

duplicates drop


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


save"panel_v2", replace
****************************************
* END
