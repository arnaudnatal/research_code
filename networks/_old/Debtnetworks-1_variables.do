*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 8, 2024
*-----
gl link = "networks"
*Correction base alters et bases couples
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------







****************************************
* Réseaux de dette
****************************************
cls
use"raw/NEEMSIS2-alters", clear

*
fre networkpurpose*
keep if networkpurpose1==1
compress


*
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"

* Caste and jatis
fre castes
rename castes jatis
fre jatis
gen caste=.
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes" 88"Don't know"
label values caste caste
order caste, after(jatis)
replace caste=1 if jatis==2
replace caste=1 if jatis==3

replace caste=2 if jatis==1
replace caste=2 if jatis==5
replace caste=2 if jatis==7
replace caste=2 if jatis==8
replace caste=2 if jatis==10
replace caste=2 if jatis==12
replace caste=2 if jatis==15
replace caste=2 if jatis==16

replace caste=3 if jatis==4
replace caste=3 if jatis==6
replace caste=3 if jatis==9
replace caste=3 if jatis==11
replace caste=3 if jatis==13
replace caste=3 if jatis==14

replace caste=88 if jatis==66
replace caste=88 if jatis==88

ta jatis caste


save"Analysis/Debtnetworks", replace
****************************************
* END










****************************************
* Enlever les 6 ménages pour lesquels il nous manque des infos
****************************************
cls
use"raw/NEEMSIS2-alters", clear


*
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"

* Caste and jatis
fre castes
rename castes jatis
fre jatis
gen caste=.
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes" 88"Don't know"
label values caste caste
order caste, after(jatis)
replace caste=1 if jatis==2
replace caste=1 if jatis==3

replace caste=2 if jatis==1
replace caste=2 if jatis==5
replace caste=2 if jatis==7
replace caste=2 if jatis==8
replace caste=2 if jatis==10
replace caste=2 if jatis==12
replace caste=2 if jatis==15
replace caste=2 if jatis==16

replace caste=3 if jatis==4
replace caste=3 if jatis==6
replace caste=3 if jatis==9
replace caste=3 if jatis==11
replace caste=3 if jatis==13
replace caste=3 if jatis==14

replace caste=88 if jatis==66
replace caste=88 if jatis==88

ta jatis caste


save"Analysis/Alters", replace
****************************************
* END









****************************************
* Loans
****************************************
cls
use"raw/NEEMSIS2-loans_mainloans_new", clear


*
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"


save"Analysis/Loans", replace
****************************************
* END