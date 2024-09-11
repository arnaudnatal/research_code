*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 11, 2024
*-----
gl link = "employment"
*Création des variables
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------



/*
In India, the age of majority is 18.
But children can start work at the age of 14 in specific occupations (no hazardous jobs).

In order to be classified as unemployed according to the ILO’s definition, a person aged 15 and over needs to fulfil three criteria:
(i) not to have worked at all in the reference week,
(ii) to be available to take up work within the next two weeks
(iii) to have been either actively seeking work in the past four weeks or have already found a job that starts in the next three months.

A person in employment as defined by the International Labour Office (ILO) is a person aged 15 or over who has done at least one hour's paid work in a given week, or who is absent from work for certain reasons (annual leave, sickness, maternity, etc.) and for a certain period of time.
All forms of employment are covered (employees, self-employed, family helpers), whether the employment is declared or not.
People who declare that they have a job from which they are absent are classified as being in employment if they are absent on paid leave, sickness, maternity/paternity leave, parental leave of 3 months or less, or with a compensatory income linked to the activity, such as Prepare, reorganisation of working hours, training authorised by the employer, off-season period as part of a seasonal activity in the case of regular work as part of this seasonal activity, short-time working (or technical or bad weather), other reason for absence lasting 3 months or less.

A person is outside the labour force, according to the International Labour Organisation definition, if he or she is not part of the labour force, meaning he or she is neither employed nor unemployed. The set of people outside the labour is also called the "inactive population" and can include pre-school children, school children, students, pensioners and housewives or -men, for example, provided that they are not working at all and not available or looking for work either; some of these may be of working-age.

En 2016-17 et 2020-21, il y a plusieurs personnes qui ont déclaré des emplois unpaid.
*/



****************************************
* Employment RUME
****************************************
use"RUME1", clear

fre kindofwork
drop if kindofwork==9

* Inc
count if annualincome==0
gen paidemployment_inc=1 if annualincome>0
gen unpaidemployment_inc=1 if annualincome==0
bysort HHID_panel INDID_panel: egen paidemployment_inc_indiv=sum(paidemployment_inc)
bysort HHID_panel INDID_panel: egen unpaidemployment_inc_indiv=sum(unpaidemployment_inc)
bysort HHID_panel INDID_panel: egen income_indiv=sum(annualincome)

* Keep
keep HHID_panel INDID_panel year paidemployment_inc_indiv unpaidemployment_inc_indiv income_indiv
rename paidemployment_inc_indiv paidemployment_inc
rename unpaidemployment_inc_indiv unpaidemployment_inc
replace paidemployment_inc=1 if paidemployment_inc>1
replace unpaidemployment_inc=1 if unpaidemployment_inc>1
duplicates drop
save"_temp1", replace

use"RUME3", clear
merge 1:1 HHID_panel INDID_panel using "_temp1", keepusing(paidemployment_inc unpaidemployment_inc income_indiv)
drop _merge
recode paidemployment_inc unpaidemployment_inc (.=0)
gen dummyworkedpastyear_inc=0
replace dummyworkedpastyear_inc=1 if paidemployment_inc==1

* Clean
drop villagename relationshiptohead HHID2010 INDID2010
gen student=.
replace student=0 if studentpresent==0
replace student=1 if studentpresent==1
drop studentpresent

*
ta age,m
save"RUME3_v2", replace
****************************************
* RUME













****************************************
* Employment NEEMSIS-1
****************************************
use"NEEMSIS11", clear

fre kindofwork

* Inc
count if annualincome==0
gen paidemployment_inc=1 if annualincome>0
gen unpaidemployment_inc=1 if annualincome==0
bysort HHID_panel INDID_panel: egen paidemployment_inc_indiv=sum(paidemployment_inc)
bysort HHID_panel INDID_panel: egen unpaidemployment_inc_indiv=sum(unpaidemployment_inc)
bysort HHID_panel INDID_panel: egen income_indiv=sum(annualincome)

* Status
gen paidemployment_stat=1 if kindofwork==1 | kindofwork==2 | kindofwork==3 | kindofwork==4
gen unpaidemployment_stat=1 if kindofwork==5 | kindofwork==6 | kindofwork==7 | kindofwork==8
bysort HHID_panel INDID_panel: egen paidemployment_stat_indiv=sum(paidemployment_stat)
bysort HHID_panel INDID_panel: egen unpaidemployment_stat_indiv=sum(unpaidemployment_stat)

* Keep
keep HHID_panel INDID_panel year paidemployment_inc_indiv unpaidemployment_inc_indiv paidemployment_stat_indiv unpaidemployment_stat_indiv income_indiv
rename paidemployment_inc_indiv paidemployment_inc
rename unpaidemployment_inc_indiv unpaidemployment_inc
rename paidemployment_stat_indiv paidemployment_stat
rename unpaidemployment_stat_indiv unpaidemployment_stat
replace paidemployment_inc=1 if paidemployment_inc>1
replace unpaidemployment_inc=1 if unpaidemployment_inc>1
replace paidemployment_stat=1 if paidemployment_stat>1
replace unpaidemployment_stat=1 if unpaidemployment_stat>1
duplicates drop
save"_temp2", replace

use"NEEMSIS13", clear
merge 1:1 HHID_panel INDID_panel using "_temp2", keepusing(paidemployment_inc unpaidemployment_inc paidemployment_stat unpaidemployment_stat income_indiv)
drop _merge
recode paidemployment_inc unpaidemployment_inc paidemployment_stat unpaidemployment_stat (.=0)
gen dummyworkedpastyear_inc=0
replace dummyworkedpastyear_inc=1 if paidemployment_inc==1
gen dummyworkedpastyear_stat=0
replace dummyworkedpastyear_stat=1 if paidemployment_stat==1

* Clean
drop villageid_new relationshiptohead HHID2016 INDID2016
gen student=.
replace student=0 if currentlyatschool==0
replace student=1 if currentlyatschool==1
drop currentlyatschool

*
ta age,m
save"NEEMSIS13_v2", replace
****************************************
* RUME














****************************************
* Employment NEEMSIS-2
****************************************
use"NEEMSIS21", clear

fre kindofwork

* Inc
count if annualincome==0
gen paidemployment_inc=1 if annualincome>0
gen unpaidemployment_inc=1 if annualincome==0
bysort HHID_panel INDID_panel: egen paidemployment_inc_indiv=sum(paidemployment_inc)
bysort HHID_panel INDID_panel: egen unpaidemployment_inc_indiv=sum(unpaidemployment_inc)
bysort HHID_panel INDID_panel: egen income_indiv=sum(annualincome)

* Status
gen paidemployment_stat=1 if kindofwork==1 | kindofwork==2 | kindofwork==3 | kindofwork==4
gen unpaidemployment_stat=1 if kindofwork==5 | kindofwork==6 | kindofwork==7 | kindofwork==8
bysort HHID_panel INDID_panel: egen paidemployment_stat_indiv=sum(paidemployment_stat)
bysort HHID_panel INDID_panel: egen unpaidemployment_stat_indiv=sum(unpaidemployment_stat)

* Keep
keep HHID_panel INDID_panel year paidemployment_inc_indiv unpaidemployment_inc_indiv paidemployment_stat_indiv unpaidemployment_stat_indiv income_indiv
rename paidemployment_inc_indiv paidemployment_inc
rename unpaidemployment_inc_indiv unpaidemployment_inc
rename paidemployment_stat_indiv paidemployment_stat
rename unpaidemployment_stat_indiv unpaidemployment_stat
replace paidemployment_inc=1 if paidemployment_inc>1
replace unpaidemployment_inc=1 if unpaidemployment_inc>1
replace paidemployment_stat=1 if paidemployment_stat>1
replace unpaidemployment_stat=1 if unpaidemployment_stat>1
duplicates drop
save"_temp3", replace

use"NEEMSIS23", clear
merge 1:1 HHID_panel INDID_panel using "_temp3", keepusing(paidemployment_inc unpaidemployment_inc paidemployment_stat unpaidemployment_stat income_indiv)
drop if _merge==2
drop _merge
recode paidemployment_inc unpaidemployment_inc paidemployment_stat unpaidemployment_stat (.=0)
gen dummyworkedpastyear_inc=0
replace dummyworkedpastyear_inc=1 if paidemployment_inc==1
gen dummyworkedpastyear_stat=0
replace dummyworkedpastyear_stat=1 if paidemployment_stat==1

* Clean
drop village_new relationshiptohead HHID2020 INDID2020
gen student=.
replace student=0 if currentlyatschool==0
replace student=1 if currentlyatschool==1
drop currentlyatschool

*
ta age,m
save"NEEMSIS23_v2", replace
****************************************
* END












****************************************
* Status RUME
****************************************
use"RUME3_v2", clear

* J'enlève les moins de 14 car rien à voir avec l'emploi
drop if age<14

* Catégories d'ages selon l'Inde
gen catinde=.
replace catinde=1 if age>14 & age<18
replace catinde=2 if age>=18
label define catinde 1"Adolescents" 2"Adults"
label values catinde catinde

* Catégories d'ages selon ILO
gen catilo=.
replace catilo=1 if age<15
replace catilo=2 if age>=15
label define catilo 1"Children" 2"Adults"
label values catilo catilo

* Combine d'inactifs ?
gen inactive=0
replace inactive=1 if student==1

* Employment ILO
gen employment_inc=.
label define employment 0"Unemployed" 1"Worker" 2"Unpaid worker"

replace employment_inc=0 if dummyworkedpastyear_inc==0 & unpaidemployment_inc==0

replace employment_inc=1 if dummyworkedpastyear_inc==1

replace employment_inc=2 if dummyworkedpastyear_inc==0 & unpaidemployment_inc==1

replace employment_inc=. if inactive==1

label values employment_inc employment

ta inactive
ta employment_inc
ta income_indiv if employment_inc==0

* Save
save"RUME3_v3", replace

****************************************
* END













****************************************
* Status NEEMSIS-1
****************************************
use"NEEMSIS13_v2", clear

* J'enlève les moins de 14 car rien à voir avec l'emploi
drop if age<14

* Catégories d'ages selon l'Inde
gen catinde=.
replace catinde=1 if age>14 & age<18
replace catinde=2 if age>=18
label define catinde 1"Adolescents" 2"Adults"
label values catinde catinde

* Catégories d'ages selon ILO
gen catilo=.
replace catilo=1 if age<15
replace catilo=2 if age>=15
label define catilo 1"Children" 2"Adults"
label values catilo catilo

* Combine d'inactifs ?
gen inactive=0
replace inactive=1 if student==1

* Employment ILO
gen employment_inc=.
gen employment_stat=.
label define employment 0"Unemployed" 1"Worker" 2"Unpaid worker"

replace employment_inc=0 if dummyworkedpastyear_inc==0 & unpaidemployment_inc==0
replace employment_stat=0 if dummyworkedpastyear_stat==0 & unpaidemployment_stat==0

replace employment_inc=1 if dummyworkedpastyear_inc==1
replace employment_stat=1 if dummyworkedpastyear_stat==1

replace employment_inc=2 if dummyworkedpastyear_inc==0 & unpaidemployment_inc==1
replace employment_stat=2 if dummyworkedpastyear_stat==0 & unpaidemployment_stat==1

replace employment_inc=. if inactive==1
replace employment_stat=. if inactive==1

label values employment_inc employment
label values employment_stat employment

ta inactive
ta employment_inc
ta employment_stat
ta income_indiv if employment_inc==0
ta income_indiv if employment_inc==2

*
fre reasonnotworkpastyear

* Save
save"NEEMSIS13_v3", replace

****************************************
* END



















****************************************
* Status NEEMSIS-2
****************************************
use"NEEMSIS23_v2", clear

* J'enlève les moins de 14 car rien à voir avec l'emploi
drop if age<14

* Catégories d'ages selon l'Inde
gen catinde=.
replace catinde=1 if age>14 & age<18
replace catinde=2 if age>=18
label define catinde 1"Adolescents" 2"Adults"
label values catinde catinde

* Catégories d'ages selon ILO
gen catilo=.
replace catilo=1 if age<15
replace catilo=2 if age>=15
label define catilo 1"Children" 2"Adults"
label values catilo catilo

* Combine d'inactifs ?
gen inactive=0
replace inactive=1 if student==1

* Employment ILO
gen employment_inc=.
gen employment_stat=.
label define employment 0"Unemployed" 1"Worker" 2"Unpaid worker"

replace employment_inc=0 if dummyworkedpastyear_inc==0 & unpaidemployment_inc==0
replace employment_stat=0 if dummyworkedpastyear_stat==0 & unpaidemployment_stat==0

replace employment_inc=1 if dummyworkedpastyear_inc==1
replace employment_stat=1 if dummyworkedpastyear_stat==1

replace employment_inc=2 if dummyworkedpastyear_inc==0 & unpaidemployment_inc==1
replace employment_stat=2 if dummyworkedpastyear_stat==0 & unpaidemployment_stat==1

replace employment_inc=. if inactive==1
replace employment_stat=. if inactive==1

label values employment_inc employment
label values employment_stat employment

ta inactive
ta employment_inc
ta employment_stat
ta income_indiv if employment_inc==0
ta income_indiv if employment_inc==2

*
fre reasonnotworkpastyear

* Save
save"NEEMSIS23_v3", replace

****************************************
* END













****************************************
* Characteristics egos
****************************************

********** NEEMSIS-1
use"NEEMSIS14", clear
keep HHID_panel INDID_panel everwork workpastsevendays searchjob startbusiness searchjobsince15 businessafter15 nbermonthsearchjob readystartjob
save "_tempego1", replace

*
use"NEEMSIS13_v3", clear
merge 1:1 HHID_panel INDID_panel using"_tempego1"
drop _merge
save"NEEMSIS13_v4", replace


********** NEEMSIS-2
use"NEEMSIS24", clear
keep HHID_panel INDID_panel everwork workpastsevendays searchjob startbusiness searchjobsince15 businessafter15 nbermonthsearchjob readystartjob
save "_tempego2", replace

*
use"NEEMSIS23_v3", clear
merge 1:1 HHID_panel INDID_panel using"_tempego2"
drop if _merge==2
drop _merge
save"NEEMSIS23_v4", replace

****************************************
* END










****************************************
* Append
****************************************
use"RUME3_v3", clear

append using "NEEMSIS13_v4"
append using "NEEMSIS23_v4"

save"totalindiv_v1", replace
****************************************
* END








****************************************
* Correction du chomage pour les égos
****************************************
use"totalindiv_v1", clear





****************************************
* END











****************************************
* Stat
****************************************
use"totalindiv_v1", clear

ta employment_inc year, col nofreq

ta employment_inc year if sex==1, col nofreq
ta employment_inc year if sex==2 & caste==1, col nofreq



****************************************
* END
