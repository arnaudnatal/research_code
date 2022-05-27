cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
19 octobre 2021
-----
TITLE: Nettoyage et analyse de l'évolution de l'emploi à l'échelle des emploi

-------------------------
*/



****************************************
* INITIALIZATION
****************************************
global directory = "C:\Users\Arnaud\Documents\_Thesis\_DATA\NEEMSIS2\DATA\APPEND\CLEAN"
cd "$directory"


set scheme plotplain

****************************************
* END





****************************************
* Recode
****************************************
use "_ANALYSIS_HH\NEEMSIS2-HH.dta", clear

global job respect workmate useknowledgeatwork satisfyingpurpose schedule takeholiday agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 changework happywork satisfactionsalary executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9 accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10 workexposure1 workexposure2 workexposure3 workexposure4 workexposure5 professionalequipment break retirementwork verbalaggression physicalagression sexualharassment sexualaggression

foreach x in $job{
clonevar `x'_new=`x'
}

***
label define n1 1"Always" 2"Freq/occas." 3"Never"

recode respect_new (2=1) (3=2) (4=3)
recode workmate_new (2=1) (3=2) (4=3)
recode useknowledgeatwork_new (2=1) (3=2) (4=3)


*** 





****************************************
* END













****************************************
* Descriptive
****************************************
use "_ANALYSIS_HH\NEEMSIS2-HH.dta", clear

*** Id selfemp
fre mainocc_occupation_indiv

label define selfemp 0"No" 1"SE non-agri" 2"SE agri"
gen selfemp=0
replace selfemp=1 if mainocc_occupation_indiv==6
replace selfemp=2 if mainocc_occupation_indiv==1

label values selfemp selfemp
fre selfemp


*** Recode mainocc
fre mainocc_occupation_indiv

label define selfempother 1"SE non-agri" 2"SE agri" 3"Other non-agri" 4"Other agri"
gen selfempother=.
replace selfempother=1 if mainocc_occupation_indiv==6
replace selfempother=2 if mainocc_occupation_indiv==1
replace selfempother=3 if mainocc_occupation_indiv==3
replace selfempother=3 if mainocc_occupation_indiv==4
replace selfempother=3 if mainocc_occupation_indiv==5
replace selfempother=4 if mainocc_occupation_indiv==2
replace selfempother=4 if mainocc_occupation_indiv==7

label values selfempother selfempother
fre selfempother




global job respect workmate useknowledgeatwork satisfyingpurpose schedule takeholiday agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 changework happywork satisfactionsalary executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9 accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10 workexposure1 workexposure2 workexposure3 workexposure4 workexposure5 professionalequipment break retirementwork verbalaggression physicalagression sexualharassment sexualaggression



cls
foreach x in $job {
ta selfempother `x', row nofreq chi2
}


/*
To continue
agreementatwork2
agreementatwork3
agreementatwork4
changework
satisfactionsalary with profit/income
executionwork1
executionwork3
physicalharm
problemwork5
problemwork9
workexposure1
workexposure2
workexposure3
workexposure4
workexposure5
break
physicalagression


*/

****************************************
* END
