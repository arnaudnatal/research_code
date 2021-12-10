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

global loan1 "RUME-loans_v8"
global loan2 "NEEMSIS1-loans_v4"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020



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

*Assets
global asse amountownlanddry amountownlandwet livestockamount_goat livestockamount_cow housevalue goldquantityamount goodtotalamount
global nature houseroom housetitle goldquantity

*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH loans_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount effectcrisislostjob mainocc_occupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega assets_noland1000 $asse $nature

keep HHID_panel year $dep $indep

duplicates drop

merge 1:1 HHID_panel using "panel"
*drop _merge
*keep if panel==1

mdesc

foreach x in $asse {
rename `x' `x'_2010
}

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


********** Test gold
order goldquantity goldquantityamount HHID_panel INDID_panel INDID2016 goldownerlist
sort HHID_panel INDID_panel
drop goldquantity
rename s_goldquantity goldquantity


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
foreach x in educationexpenses {
bysort HHID_panel: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}

*Assets
global asse amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock housevalue goldquantityamount goodtotalamount
global nature houseroom housetitle housesize goldquantity



*Variables to keep
global dep imp1_ds_tot_HH imp1_is_tot_HH loans_HH loanamount_g_HH loanamount_gm_HH loanamount_HH loans_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummydemonetisation dummymarriage marriageexpenses_HH mainocc_occupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega assets_noland1000 $asse $nature
 
keep HHID_panel year $dep $indep


*Occupation
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
restore



duplicates drop

merge 1:1 HHID_panel using "panel"
*drop _merge
*keep if panel==1

mdesc

*Recode
recode imp1_ds_tot_HH imp1_is_tot_HH loans_HH loanamount_HH marriageexpenses_HH (.=0)

mdesc


*
foreach x in $asse {
rename `x' `x'_2016
}

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

********** Test gold
order goldquantity goldquantityamount HHID_panel INDID_panel goldownerid
sort HHID_panel INDID_panel
drop goldquantity
rename s_goldquantity goldquantity





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
foreach x in educationexpenses {
bysort HHID_panel: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}



*Destring
ta house
ta housetype
destring religion housetype housetitle, replace


*Assets
rename livestockamount_bullforploughing livestockamount_bull
global asse amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount2

egen test=rowtotal(livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount2)
gen test2=test-assets_noland
ta test2
ta HHID_panel if test2>1000

preserve
keep if HHID_panel=="KOR16" | HHID_panel=="KOR23"
order HHID_panel assets_noland test test2 $asse
restore
drop assets assets_noland assets1000 assets_noland1000

rename goodtotalamount2 goodtotalamount

egen assets=rowtotal(amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount)
egen assets_noland=rowtotal(livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount)

gen assets1000=assets/1000
gen assets_noland1000=assets_noland/1000

global asse amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount
global nature houseroom housetitle housesize goldquantity


*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH loans_HH
global indep villageid villagearea religion jatis caste assets1000 annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummymarriage marriageexpenses_HH assets_noland1000 occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega $asse $nature
 
keep HHID_panel year $dep $indep

*Occupation
preserve
egen test=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
gen test2=test-annualincome_HH
ta test2
restore

duplicates drop


merge 1:1 HHID_panel using "panel"
*drop _merge
*keep if panel==1

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

foreach x in $asse {
rename `x' `x'_2020
}


save"$wave3-_temp", replace
****************************************
* END