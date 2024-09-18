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

For ILO, working age is 15.

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
* Append
****************************************
use"RUME3_v2", clear

append using "NEEMSIS13_v3"
append using "NEEMSIS23_v3"

* Label
label var year "Year"

save"totalindiv_v1", replace
****************************************
* END








****************************************
* Append les occupations
****************************************
use"RUME2_v2", clear

append using "NEEMSIS12_v2"
append using "NEEMSIS22_v2"

* Label
label var year "Year"

* Rename
forvalues i=1/6 {
rename kow`i' kindofwork`i'
}

rename occupationname1 occupationname_mainocc
rename annualincome1 annualincome_mainocc
rename occupation1 occupation_mainocc
rename kindofwork1 kindofwork_mainocc


save"totalocc", replace
****************************************
* END











****************************************
* Merge les occupations
****************************************
use"totalindiv_v1", clear

merge 1:1 HHID_panel INDID_panel year using "totalocc"
drop if _merge==2
drop _merge
drop if year==.

save"totalindiv_v2", replace
****************************************
* END













****************************************
* Construction
****************************************
use"totalindiv_v2", clear

sort HHID_panel INDID_panel year
order HHID_panel INDID_panel year name sex jatis caste

/*
Pour analyser l'évolution de l'emploi et vérifier les chiffres, il y a plusieurs variables à régarder :
- Age
- Statut étudiant
- Travailleur
- Si oui, rémunéré ou non
- Si non, pourquoi : chomeur, malade, retraite, housewife, etc.
*/

* Age
ta age

* Student
fre student
recode student (.=0)
label define student 0"Not a student" 1"Student at present time"
label values student student

* Worker
ta dummyworkedpastyear2
label define dummyworkedpastyear2 0"Non-worker" 1"Worker"
label values dummyworkedpastyear2 dummyworkedpastyear2
ta dummyworkedpastyear2

* Type of worker
gen workertype=.
replace workertype=1 if paidemployment==1
replace workertype=2 if unpaidemployment==1
label define workertype 1"Paid worker" 2"Unpaid worker"
label values workertype workertype
ta workertype

* Type of worker (with cat instead of income for 2016 and 2020)
gen workertype_cat=.
replace workertype_cat=1 if paidemployment2==1
replace workertype_cat=2 if unpaidemployment2==1
replace workertype_cat=workertype if year==2010
label define workertype_cat 1"Paid worker" 2"Unpaid worker"
label values workertype_cat workertype_cat
ta workertype_cat

* Type of non-worker (only for 2016-2020)
fre reasonnotworkpastyear
gen nonworkertype=.
replace nonworkertype=1 if reasonnotworkpastyear==1
replace nonworkertype=2 if reasonnotworkpastyear==2
replace nonworkertype=3 if reasonnotworkpastyear==3
replace nonworkertype=3 if reasonnotworkpastyear==4
replace nonworkertype=4 if reasonnotworkpastyear==5
replace nonworkertype=4 if reasonnotworkpastyear==6
replace nonworkertype=5 if reasonnotworkpastyear==8
replace nonworkertype=6 if reasonnotworkpastyear==9
replace nonworkertype=6 if reasonnotworkpastyear==10
replace nonworkertype=6 if reasonnotworkpastyear==11
replace nonworkertype=6 if reasonnotworkpastyear==12
replace nonworkertype=6 if reasonnotworkpastyear==13
replace nonworkertype=6 if reasonnotworkpastyear==14
replace nonworkertype=6 if reasonnotworkpastyear==15
replace nonworkertype=. if year==2010
label define nonworkertype 1"In school" 2"Housewife" 3"Retirement" 4"Ill/disability" 5"Not want to work" 6"Unemployed"
label values nonworkertype nonworkertype

* Inactive vs real unemployed (only for 2016-2020)
gen nonworkertype_cat=.
replace nonworkertype_cat=1 if nonworkertype==1
replace nonworkertype_cat=2 if nonworkertype==2
replace nonworkertype_cat=1 if nonworkertype==3
replace nonworkertype_cat=1 if nonworkertype==4
replace nonworkertype_cat=1 if nonworkertype==5
replace nonworkertype_cat=3 if nonworkertype==6
replace nonworkertype_cat=. if year==2010
label define nonworkertype_cat 1"Inactive" 2"Housewife" 3"Unemployed"
label values nonworkertype_cat nonworkertype_cat

* Selection des variables à garder
global var HHID_panel INDID_panel year sex caste ///
age student dummyworkedpastyear2 workertype workertype_cat nonworkertype nonworkertype_cat ///
occupationname_mainocc annualincome_mainocc occupation_mainocc kindofwork_mainocc occupationname2 annualincome2 occupation2 kindofwork2 occupationname3 annualincome3 occupation3 kindofwork3 occupationname4 annualincome4 occupation4 kindofwork4 occupationname5 annualincome5 occupation5 kindofwork5 annualincome6 occupationname6 occupation6 kindofwork6

keep $var
order $var

rename dummyworkedpastyear2 workedpastyear

compress

ta nonworkertype_cat


save"Tosend/Panel-individuals-occupations.dta", replace
****************************************
* END












/*
****************************************
* Correction du chomage pour les égos
****************************************

***** NEEMSIS-1
use"totalindiv_v1", clear
cls
keep if year==2016
recode readystartjob (88=.) (99=.)

* Pour ceux qui ont travaillé l'an passé: Travaillé la semaine dernière ?
ta workpastsevendays
	* Si non : 
	ta searchjob
	ta startbusiness

* Pour ceux qui n'ont pas travaillé l'an passé: Déjà travaillé ?
ta everwork
	* Si non :
	ta searchjobsince15
		* Si oui :
		ta nbermonthsearchjob
	ta businessafter15

ta readystartjob
ta workpastsixmonth
	
	
***** NEEMSIS-2
use"totalindiv_v1", clear
cls
keep if year==2020
recode readystartjob (88=.) (99=.)

* Pour ceux qui ont travaillé l'an passé: Travaillé la semaine dernière ?
ta workpastsevendays
	* Si non : 
	ta searchjob
	ta startbusiness


* Pour ceux qui n'ont pas travaillé l'an passé: Déjà travaillé ?
ta everwork
	* Si non :
	ta searchjobsince15
		* Si oui :
		ta nbermonthsearchjob
	ta businessafter15

ta readystartjob
ta workpastsixmonth
****************************************
* END
*/


















****************************************
* Test Cécile
****************************************
use"totalindiv_v2", clear

ta occupation1
ta workedpastyear

* Merger la variable de Cécile
merge 1:1 HHID_panel INDID_panel year using "panel_indiv_v0", keepusing(employed)
drop _merge
rename employed employedC

* Retrouver sa variable
fre workedpastyear
fre workertype

gen employedA=.
replace employedA=0 if workedpastyear==0
replace employedA=0 if workertype_cat==2
replace employedA=1 if workertype_cat==1
replace employedA=. if age<15

* Stat global
ta employedC year, col nofreq
ta employedA year, col nofreq

* By year
ta employedC employedA if year==2010
ta employedC employedA if year==2016
ta employedC employedA if year==2020

* For 2016
preserve
keep if year==2016
ta employedC employedA
keep if employedC!=employedA
sort employedC
restore

* For 2020
preserve
keep if year==2020
ta employedC employedA
keep if employedC!=employedA
restore

ta employedC year if sex==2, col nofreq
ta employedA year if sex==2, col nofreq

****************************************
* END








