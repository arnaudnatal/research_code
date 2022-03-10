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
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
*set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
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

drop annualincome_HH
egen annualincome_HH2=rowtotal(occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega)
rename annualincome_HH2 annualincome_HH

* AEU
fre sex
gen AEU_weight1=.
replace AEU_weight1=1 if sex==1 & age>=16
replace AEU_weight1=0.8 if sex==2 & age>=16
replace AEU_weight1=0.6 if sex==1 & age<16
replace AEU_weight1=0.6 if sex==2 & age<16
replace AEU_weight1=0 if livinghome2==0

gen AEU_weight2=.
replace AEU_weight2=1 if sex==1 & age>=16
replace AEU_weight2=1 if sex==2 & age>=16
replace AEU_weight2=0.6 if sex==1 & age<16
replace AEU_weight2=0.6 if sex==2 & age<16
replace AEU_weight2=0 if livinghome2==0

gen AEU_weight=.
replace AEU_weight=1 if sex==1 & age>=16
replace AEU_weight=1 if sex==2 & age>=16
replace AEU_weight=1 if sex==1 & age<16
replace AEU_weight=1 if sex==2 & age<16
replace AEU_weight=0 if livinghome2==0

foreach x in weight weight1 weight2 {
bysort HHID_panel: egen AEU_`x'_HH=sum(AEU_`x')
}


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
*label define sex 1"Male" 2"Female"
*label values sex sex
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

global expenses livestockspent foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses cropsexpenses labourcostexpenses

*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH loans_HH
global indep villageid villagearea religion jatis caste assets annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount effectcrisislostjob mainocc_occupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega assets_noland  $asse $nature $expenses

keep HHID_panel year $dep $indep AEU_weight_HH AEU_weight1_HH AEU_weight2_HH

duplicates drop

merge 1:1 HHID_panel using "panel"
*drop _merge
*keep if panel==1

mdesc

foreach x in $asse amountownland{
rename `x' `x'_2010
}

drop amountownlanddry_2010 amountownlandwet_2010

rename amountownland_2010 amountownland

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


* AEU
fre sex
gen AEU_weight1=.
replace AEU_weight1=1 if sex==1 & age>=16
replace AEU_weight1=0.8 if sex==2 & age>=16
replace AEU_weight1=0.6 if sex==1 & age<16
replace AEU_weight1=0.6 if sex==2 & age<16

gen AEU_weight2=.
replace AEU_weight2=1 if sex==1 & age>=16
replace AEU_weight2=1 if sex==2 & age>=16
replace AEU_weight2=0.6 if sex==1 & age<16
replace AEU_weight2=0.6 if sex==2 & age<16

gen AEU_weight=.
replace AEU_weight=1 if sex==1 & age>=16
replace AEU_weight=1 if sex==2 & age>=16
replace AEU_weight=1 if sex==1 & age<16
replace AEU_weight=1 if sex==2 & age<16

foreach x in weight weight1 weight2 {
bysort HHID_panel: egen AEU_`x'_HH=sum(AEU_`x')
}




********** Test gold
order goldquantity goldquantityamount HHID_panel INDID_panel goldownerlist
sort HHID_panel INDID_panel
drop goldquantity
rename s_goldquantity goldquantity


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


* Product expenses + livestock + business
egen productexpenses=rowtotal(productexpenses_paddy productexpenses_ragi productexpenses_millets productexpenses_tapioca productexpenses_cotton productexpenses_sugarca productexpenses_savukku productexpenses_guava productexpenses_groundnut)

egen livestockexpenses=rowtotal(livestockspent_cow livestockspent_goat livestockspent_chicken livestockspent_bullock)

bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)


*Assets
global asse amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock housevalue goldquantityamount goodtotalamount
global nature houseroom housetitle housesize goldquantity

global expenses foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses demoexpenses businessexpenses_HH marriageexpenses_HH educationexpenses productexpenses livestockexpenses demoexpenses democonsoless democonsomore democonsosame democonsopractices democonsoplace


*Variables to keep
global dep imp1_ds_tot_HH imp1_is_tot_HH loanamount_gm_HH loans_gm_HH loanamount_g_HH loans_g_HH
global indep villageid villagearea religion jatis caste assets annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummydemonetisation dummymarriage marriageexpenses_HH mainocc_occupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega assets_noland $asse $nature villageareaid $expenses
 
keep HHID_panel year $dep $indep AEU_weight_HH AEU_weight1_HH AEU_weight2_HH

rename loanamount_gm_HH loanamount_HH
rename loans_gm_HH loans_HH

sum loanamount_HH

drop loanamount_g_HH


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

*
rename villageareaid villagearea

rename amountownland_2016 amountownland

save"$wave2-_temp", replace
****************************************
* END
















****************************************
* PREPA 2020
****************************************
use "$wave3", clear

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


* AEU
fre sex
gen AEU_weight1=.
replace AEU_weight1=1 if sex==1 & age>=16
replace AEU_weight1=0.8 if sex==2 & age>=16
replace AEU_weight1=0.6 if sex==1 & age<16
replace AEU_weight1=0.6 if sex==2 & age<16

gen AEU_weight2=.
replace AEU_weight2=1 if sex==1 & age>=16
replace AEU_weight2=1 if sex==2 & age>=16
replace AEU_weight2=0.6 if sex==1 & age<16
replace AEU_weight2=0.6 if sex==2 & age<16

gen AEU_weight=.
replace AEU_weight=1 if sex==1 & age>=16
replace AEU_weight=1 if sex==2 & age>=16
replace AEU_weight=1 if sex==1 & age<16
replace AEU_weight=1 if sex==2 & age<16

foreach x in weight weight1 weight2 {
bysort HHID_panel: egen AEU_`x'_HH=sum(AEU_`x')
}



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
. tab decisionconsumption 

Who usually makes decisions about |
making major household purchases? |      Freq.     Percent        Cum.
----------------------------------+-----------------------------------
        Yourself - Household head |        270       43.97       43.97
            Spouse (Husband/Wife) |        310       50.49       94.46
 Your spouse and yourseld jointly |         22        3.58       98.05
                     Someone else |          2        0.33       98.37
Yourself and someone else jointly |          8        1.30       99.67
                            Other |          2        0.33      100.00
----------------------------------+-----------------------------------
                            Total |        614      100.00

. tab decisionhealth  // avec les gens du HH

 Who usually makes decision about |
    health care in the household? |      Freq.     Percent        Cum.
----------------------------------+-----------------------------------
        Yourself - Household head |        259       42.18       42.18
            Spouse (Husband/Wife) |        321       52.28       94.46
 Your spouse and yourseld jointly |         22        3.58       98.05
                     Someone else |          2        0.33       98.37
Yourself and someone else jointly |          9        1.47       99.84
                            Other |          1        0.16      100.00
----------------------------------+-----------------------------------
                            Total |        614      100.00

						
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


*Crisis
tab1 dummymarriage
bysort HHID_panel: egen marriageexpenses_HH=sum(marriageexpenses)
replace marriageexpenses_HH=. if dummymarriage==0


*Education at HH level
foreach x in educationexpenses {
bysort HHID_panel: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}

*Destring
ta house
ta housetype
destring religion housetype housetitle, replace

*Expenses
egen productexpenses=rowtotal(productexpenses1 productexpenses2 productexpenses3 productexpenses4 productexpenses5 productexpenses9 productexpenses11 productexpenses12 productexpenses14)

bysort HHID_panel: egen businessexpenses_HH=sum(businessexpenses)

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

rename goodtotalamount2 goodtotalamount

drop assets assets_noland
egen assets=rowtotal(amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount)
egen assets_noland=rowtotal(livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount)


global asse amountownland livestockamount_cow livestockamount_goat livestockamount_chicken livestockamount_bullock livestockamount_bull housevalue goldquantityamount goodtotalamount
global nature houseroom housetitle housesize goldquantity

global expenses foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses covgenexpenses covexpensesdecrease covexpensesincrease covexpensesstable businessexpenses_HH marriageexpenses_HH educationexpenses productexpenses

*Variables to keep
global dep loanamount_HH loans_HH imp1_ds_tot_HH imp1_is_tot_HH
global indep villageid villagearea religion jatis caste assets annualincome_HH nboccupation_HH foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses HHsize housetype housetitle houseroom nbchildren_HH nontoworkers_HH femtomale_HH head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation sizeownland amountownland ownland goldquantity goldquantityamount dummymarriage marriageexpenses_HH assets_noland occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega $asse $nature religion $expenses
 
keep HHID_panel year $dep $indep AEU_weight_HH AEU_weight1_HH AEU_weight2_HH

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
recode nboccupation_HH  occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega imp1_ds_tot_HH imp1_is_tot_HH loans_HH loanamount_HH marriageexpenses_HH (.=0)

foreach x in $asse {
rename `x' `x'_2020
}

rename amountownland_2020 amountownland


save"$wave3-_temp", replace
****************************************
* END
