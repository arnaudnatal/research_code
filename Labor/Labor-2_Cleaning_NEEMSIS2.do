cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
24 avril 2021
-----
TITLE: Nettoyage NEEMSIS2 pour les avances

-------------------------
*/




****************************************
* Initialization
****************************************
global directory = "D:\Documents\_Thesis\Research-Labour_and_debt\Data"
cd "$directory"

global dropbox "C:\Users\Arnaud\Dropbox\RUME-NEEMSIS"
global git ""

global thesis "D:\Documents\_Thesis\_DATA\NEEMSIS2\DATA\APPEND\CLEAN"

global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v18"
global track "TRACKING1-HH_v2"
****************************************
* END








****************************************
* Migration database
****************************************
use"$dropbox\NEEMSIS2\\$wave3", clear
duplicates list HHID_panel INDID_panel
ta migrantlist_
keep 
*144 migrants ici + 78 pour NEEMSIS1 ?


use"$dropbox\NEEMSIS2\NEEMSIS2-migration", clear
duplicates list HHID_panel INDID_panel
tab dummyadvance

merge m:m HHID_panel INDID_panel using "$dropbox\NEEMSIS2\\$wave3"
ta migrantlist_
keep if migrantlist_==1
sort _merge

/*
Ils sont dans la liste des HH migrants, mais rien dans la liste des migrations
HHID
uuid:84aaf986-614e-4a31-b580-16c61e47706e
uuid:84aaf986-614e-4a31-b580-16c61e47706e
uuid:ce5711dc-94fd-45ee-a5c1-423e475bd96e



uuid:85f128ee-58f8-46d4-899b-8e55b5947a30
uuid:85f128ee-58f8-46d4-899b-8e55b5947a30
uuid:85f128ee-58f8-46d4-899b-8e55b5947a30
uuid:30187ee9-dd3b-4a82-b20f-6ec0db908a4c


HHID_panel
SEM18
SEM18
NAT45
KUV10
KUV10
KUV10
GOV38
GOV38
GOV38
GOV21


    Unique |
harmonized |
 household |
identifier |      version_HH
for LAKSMI |  DECEMBER  NEW_APRIL |     Total
-----------+----------------------+----------
     GOV21 |         0          4 |         4 
     GOV38 |         0          8 |         8 
     KUV10 |         0          7 |         7 
     NAT45 |         5          0 |         5 
     SEM18 |         6          0 |         6 
-----------+----------------------+----------
     Total |        11         19 |        30 



*/

gen tokeep=.
replace tokeep=1 if HHID_panel=="SEM18"
replace tokeep=1 if HHID_panel=="NAT45"
replace tokeep=1 if HHID_panel=="KUV10"
replace tokeep=1 if HHID_panel=="GOV38"
replace tokeep=1 if HHID_panel=="GOV21"

keep if tokeep==1
tab version_HH
tab username




use"$thesis\NEEMSIS_APPEND-migrationjobidgroup", clear
split key, p(/)
drop setofmigrationjobidgroup
rename parent_key setofmigration
rename key1 parent_key
drop key2 key3

	drop if parent_key=="uuid:1ea7523b-cad1-44da-9afa-8c4f96189433"
	drop if parent_key=="uuid:b283cb62-a316-418a-80b5-b8fe86585ef8"
	drop if parent_key=="uuid:5a19b036-4004-4c71-9e2a-b4efd3572cf3"
	drop if parent_key=="uuid:7fc65842-447f-4b1d-806a-863556d03ed3"
	drop if parent_key=="uuid:2cca6f5f-3ecb-4088-b73f-1ecd9586690d"
	drop if parent_key=="uuid:9b931ac2-ef49-43e9-90cd-33ae0bf1928f"
	drop if parent_key=="uuid:d0cd220f-bec1-49b8-a3ff-d70f82a3b231"
	drop if parent_key=="uuid:73af0a16-d6f8-4389-b117-2c40d591b806"
keep if migrationarea!=.	

	
****************************************
* END












****************************************
* Working conditions + debt
****************************************
use"$dropbox\NEEMSIS2\\$wave3", clear

*
fre respect workmate useknowledgeatwork

*
fre satisfyingpurpose schedule takeholiday

*
fre agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4

*
fre changework happywork satisfactionsalary

*
global execution executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9
fre $execution
foreach x in $execution {
reg loanamount_indiv `x'
}



*
fre accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm

*
fre problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10

*
fre workexposure1 workexposure2 workexposure3 workexposure4 workexposure5

*
fre professionalequipment break retirementwork verbalaggression physicalagression sexualharassment 

*
fre sexualaggression

*
fre discrimination1 discrimination2 discrimination3 discrimination4 discrimination5 discrimination6 discrimination7 discrimination8 discrimination9

*
fre resdiscrimination1 resdiscrimination2 resdiscrimination3

*
fre rurallocation lackskill


*Debt

