*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------









****************************************
* Labour var: 2010
****************************************
use"raw/RUME-occupnew", clear

fre kindofwork
drop if kindofwork==9

keep HHID2010 INDID2010 profession sector occupation annualincome_indiv nboccupation_indiv construction_coolie construction_regular construction_qualified
fre occupation
ta occupation, gen(occ_)

gen acttype=0
replace acttype=1 if occupation==1
replace acttype=1 if occupation==2
replace acttype=2 if occupation==3
replace acttype=2 if occupation==4
replace acttype=2 if occupation==5
replace acttype=2 if occupation==6
replace acttype=2 if occupation==7
label define acttype 1"Agri." 2"Non-agri"
label values acttype acttype

ta occupation acttype 
ta acttype, gen(type_)

*** Indiv level
forvalues i=1/7 {
bysort HHID2010 INDID2010: egen nbocc`i'=sum(occ_`i')
}
rename nbocc1 nbocc_agriself
rename nbocc2 nbocc_agricasu
rename nbocc3 nbocc_nonacasu
rename nbocc4 nbocc_nonarnqu
rename nbocc5 nbocc_nonarqua
rename nbocc6 nbocc_nonaself
rename nbocc7 nbocc_nonanreg

forvalues i=1/2 {
bysort HHID2010 INDID2010: egen nbocc`i'=sum(type_`i')
}
rename nbocc1 nbocc_agri
rename nbocc2 nbocc_nonagri

keep HHID2010 INDID2010 nbocc_*
duplicates drop

*** Merge charact
merge 1:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(age sex)
drop _merge


*** Merge indiv
merge 1:1 HHID2010 INDID2010 using "raw/RUME-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv)
drop _merge

drop nbocc_agriself nbocc_agricasu nbocc_nonacasu nbocc_nonarnqu nbocc_nonarqua nbocc_nonaself nbocc_nonanreg

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64

********** Dummies for nb individuals at HH level
gen occ_all=0
replace occ_all=1 if nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_female=0
replace occ_female=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_male=0
replace occ_male=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_agri=0
replace occ_agri=1 if nbocc_agri!=0 & nbocc_agri!=. & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_nonagri=0
replace occ_nonagri=1 if nbocc_nonagri!=0 & nbocc_nonagri!=. & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_female_agri=0
replace occ_female_agri=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen occ_female_nonagri=0
replace occ_female_nonagri=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen occ_male_agri=0
replace occ_male_agri=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen occ_male_nonagri=0
replace occ_male_nonagri=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen occ_dep=0
replace occ_dep=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1

gen occ_dep_female=0
replace occ_dep_female=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==2

gen occ_dep_male=0
replace occ_dep_male=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==1

********** Nb occ at HH level
gen nbocc_all=0
replace nbocc_all=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_female=0
replace nbocc_female=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_male=0
replace nbocc_male=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_female_agri=0
replace nbocc_female_agri=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen nbocc_female_nonagri=0
replace nbocc_female_nonagri=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen nbocc_male_agri=0
replace nbocc_male_agri=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen nbocc_male_nonagri=0
replace nbocc_male_nonagri=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen nbocc_dep=0
replace nbocc_dep=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1

gen nbocc_dep_female=0
replace nbocc_dep_female=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==2

gen nbocc_dep_male=0
replace nbocc_dep_male=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==1

********** HH level
foreach x in occ_all occ_female occ_male occ_agri occ_nonagri occ_female_agri occ_female_nonagri occ_male_agri occ_male_nonagri nbocc_agri nbocc_nonagri nbocc_all nbocc_female nbocc_male nbocc_female_agri nbocc_female_nonagri nbocc_male_agri nbocc_male_nonagri nbocc_dep nbocc_dep_male nbocc_dep_female occ_dep occ_dep_male occ_dep_female {
bysort HHID2010: egen `x'_HH=sum(`x')
}

bysort HHID2010: egen nboccupation_HH=sum(nboccupation_indiv)

keep HHID2010 occ_all_HH occ_female_HH occ_male_HH occ_agri_HH occ_nonagri_HH occ_female_agri_HH occ_female_nonagri_HH occ_male_agri_HH occ_male_nonagri_HH nbocc_agri_HH nbocc_nonagri_HH nbocc_all_HH nbocc_female_HH nbocc_male_HH nbocc_female_agri_HH nbocc_female_nonagri_HH nbocc_male_agri_HH nbocc_male_nonagri_HH nboccupation_HH nbocc_dep_HH nbocc_dep_male_HH nbocc_dep_female_HH occ_dep_HH occ_dep_male_HH occ_dep_female_HH
duplicates drop


*** Merge nbworkers
merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(nbworker_HH nbnonworker_HH)
drop _merge

*** Merge HHID_panel
merge 1:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

save"RUME-newoccvar", replace
****************************************
* END












****************************************
* Labour var: 2016-17
****************************************
use"raw/NEEMSIS1-occupnew", clear

fre kindofwork

keep HHID2016 INDID2016 profession sector occupation annualincome_indiv nboccupation_indiv construction_coolie construction_regular construction_qualified
fre occupation
ta occupation, gen(occ_)

gen acttype=0
replace acttype=1 if occupation==1
replace acttype=1 if occupation==2
replace acttype=2 if occupation==3
replace acttype=2 if occupation==4
replace acttype=2 if occupation==5
replace acttype=2 if occupation==6
replace acttype=2 if occupation==7
label define acttype 1"Agri." 2"Non-agri"
label values acttype acttype

ta occupation acttype 
ta acttype, gen(type_)

*** Indiv level
forvalues i=1/7 {
bysort HHID2016 INDID2016: egen nbocc`i'=sum(occ_`i')
}
rename nbocc1 nbocc_agriself
rename nbocc2 nbocc_agricasu
rename nbocc3 nbocc_nonacasu
rename nbocc4 nbocc_nonarnqu
rename nbocc5 nbocc_nonarqua
rename nbocc6 nbocc_nonaself
rename nbocc7 nbocc_nonanreg

forvalues i=1/2 {
bysort HHID2016 INDID2016: egen nbocc`i'=sum(type_`i')
}
rename nbocc1 nbocc_agri
rename nbocc2 nbocc_nonagri

keep HHID2016 INDID2016 nbocc_*
duplicates drop

*** Merge charact
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(age sex)
drop _merge


*** Merge indiv
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv)
drop _merge

drop nbocc_agriself nbocc_agricasu nbocc_nonacasu nbocc_nonarnqu nbocc_nonarqua nbocc_nonaself nbocc_nonanreg

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64

********** Dummies for nb individuals at HH level
gen occ_all=0
replace occ_all=1 if nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_female=0
replace occ_female=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_male=0
replace occ_male=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_agri=0
replace occ_agri=1 if nbocc_agri!=0 & nbocc_agri!=. & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_nonagri=0
replace occ_nonagri=1 if nbocc_nonagri!=0 & nbocc_nonagri!=. & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_female_agri=0
replace occ_female_agri=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen occ_female_nonagri=0
replace occ_female_nonagri=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen occ_male_agri=0
replace occ_male_agri=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen occ_male_nonagri=0
replace occ_male_nonagri=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen occ_dep=0
replace occ_dep=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1

gen occ_dep_female=0
replace occ_dep_female=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==2

gen occ_dep_male=0
replace occ_dep_male=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==1



********** Nb occ at HH level
gen nbocc_all=0
replace nbocc_all=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_female=0
replace nbocc_female=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_male=0
replace nbocc_male=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_female_agri=0
replace nbocc_female_agri=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen nbocc_female_nonagri=0
replace nbocc_female_nonagri=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen nbocc_male_agri=0
replace nbocc_male_agri=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen nbocc_male_nonagri=0
replace nbocc_male_nonagri=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen nbocc_dep=0
replace nbocc_dep=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1

gen nbocc_dep_female=0
replace nbocc_dep_female=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==2

gen nbocc_dep_male=0
replace nbocc_dep_male=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==1

********** HH level
foreach x in occ_all occ_female occ_male occ_agri occ_nonagri occ_female_agri occ_female_nonagri occ_male_agri occ_male_nonagri nbocc_agri nbocc_nonagri nbocc_all nbocc_female nbocc_male nbocc_female_agri nbocc_female_nonagri nbocc_male_agri nbocc_male_nonagri nbocc_dep nbocc_dep_male nbocc_dep_female occ_dep occ_dep_male occ_dep_female {
bysort HHID2016: egen `x'_HH=sum(`x')
}

bysort HHID2016: egen nboccupation_HH=sum(nboccupation_indiv)

keep HHID2016 occ_all_HH occ_female_HH occ_male_HH occ_agri_HH occ_nonagri_HH occ_female_agri_HH occ_female_nonagri_HH occ_male_agri_HH occ_male_nonagri_HH nbocc_agri_HH nbocc_nonagri_HH nbocc_all_HH nbocc_female_HH nbocc_male_HH nbocc_female_agri_HH nbocc_female_nonagri_HH nbocc_male_agri_HH nbocc_male_nonagri_HH nboccupation_HH nbocc_dep_HH nbocc_dep_male_HH nbocc_dep_female_HH occ_dep_HH occ_dep_male_HH occ_dep_female_HH
duplicates drop


*** Merge nbworkers
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(nbworker_HH nbnonworker_HH)
drop _merge


*** Merge HHID_panel
merge 1:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016


save"NEEMSIS1-newoccvar", replace
****************************************
* END



























****************************************
* Labour var: 2020-21
****************************************
use"raw/NEEMSIS2-occupnew", clear

fre kindofwork

keep HHID2020 INDID2020 profession sector occupation annualincome_indiv nboccupation_indiv construction_coolie construction_regular construction_qualified
fre occupation
ta occupation, gen(occ_)

gen acttype=0
replace acttype=1 if occupation==1
replace acttype=1 if occupation==2
replace acttype=2 if occupation==3
replace acttype=2 if occupation==4
replace acttype=2 if occupation==5
replace acttype=2 if occupation==6
replace acttype=2 if occupation==7
label define acttype 1"Agri." 2"Non-agri"
label values acttype acttype

ta occupation acttype 
ta acttype, gen(type_)

*** Indiv level
forvalues i=1/7 {
bysort HHID2020 INDID2020: egen nbocc`i'=sum(occ_`i')
}
rename nbocc1 nbocc_agriself
rename nbocc2 nbocc_agricasu
rename nbocc3 nbocc_nonacasu
rename nbocc4 nbocc_nonarnqu
rename nbocc5 nbocc_nonarqua
rename nbocc6 nbocc_nonaself
rename nbocc7 nbocc_nonanreg

forvalues i=1/2 {
bysort HHID2020 INDID2020: egen nbocc`i'=sum(type_`i')
}
rename nbocc1 nbocc_agri
rename nbocc2 nbocc_nonagri

keep HHID2020 INDID2020 nbocc_*
duplicates drop

*** Merge charact
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(age sex)
drop _merge


*** Merge indiv
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv)
drop _merge

drop nbocc_agriself nbocc_agricasu nbocc_nonacasu nbocc_nonarnqu nbocc_nonarqua nbocc_nonaself nbocc_nonanreg

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64

********** Dummies for nb individuals at HH level
gen occ_all=0
replace occ_all=1 if nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_female=0
replace occ_female=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_male=0
replace occ_male=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_agri=0
replace occ_agri=1 if nbocc_agri!=0 & nbocc_agri!=. & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_nonagri=0
replace occ_nonagri=1 if nbocc_nonagri!=0 & nbocc_nonagri!=. & nboccupation_indiv>0 & nboccupation_indiv!=.

gen occ_female_agri=0
replace occ_female_agri=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen occ_female_nonagri=0
replace occ_female_nonagri=1 if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen occ_male_agri=0
replace occ_male_agri=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen occ_male_nonagri=0
replace occ_male_nonagri=1 if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen occ_dep=0
replace occ_dep=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1

gen occ_dep_female=0
replace occ_dep_female=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==2

gen occ_dep_male=0
replace occ_dep_male=1 if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==1


********** Nb occ at HH level
gen nbocc_all=0
replace nbocc_all=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_female=0
replace nbocc_female=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_male=0
replace nbocc_male=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=.

gen nbocc_female_agri=0
replace nbocc_female_agri=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen nbocc_female_nonagri=0
replace nbocc_female_nonagri=nboccupation_indiv if sex==2 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen nbocc_male_agri=0
replace nbocc_male_agri=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_agri!=0 & nbocc_agri!=.

gen nbocc_male_nonagri=0
replace nbocc_male_nonagri=nboccupation_indiv if sex==1 & nboccupation_indiv>0 & nboccupation_indiv!=. & nbocc_nonagri!=0 & nbocc_nonagri!=.

gen nbocc_dep=0
replace nbocc_dep=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1

gen nbocc_dep_female=0
replace nbocc_dep_female=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==2

gen nbocc_dep_male=0
replace nbocc_dep_male=nboccupation_indiv if nboccupation_indiv>0 & nboccupation_indiv!=. & dep==1 & sex==1

********** HH level
foreach x in occ_all occ_female occ_male occ_agri occ_nonagri occ_female_agri occ_female_nonagri occ_male_agri occ_male_nonagri nbocc_agri nbocc_nonagri nbocc_all nbocc_female nbocc_male nbocc_female_agri nbocc_female_nonagri nbocc_male_agri nbocc_male_nonagri nbocc_dep nbocc_dep_male nbocc_dep_female occ_dep occ_dep_male occ_dep_female {
bysort HHID2020: egen `x'_HH=sum(`x')
}

bysort HHID2020: egen nboccupation_HH=sum(nboccupation_indiv)

keep HHID2020 occ_all_HH occ_female_HH occ_male_HH occ_agri_HH occ_nonagri_HH occ_female_agri_HH occ_female_nonagri_HH occ_male_agri_HH occ_male_nonagri_HH nbocc_agri_HH nbocc_nonagri_HH nbocc_all_HH nbocc_female_HH nbocc_male_HH nbocc_female_agri_HH nbocc_female_nonagri_HH nbocc_male_agri_HH nbocc_male_nonagri_HH nboccupation_HH nbocc_dep_HH nbocc_dep_male_HH nbocc_dep_female_HH occ_dep_HH occ_dep_male_HH occ_dep_female_HH
duplicates drop


*** Merge nbworkers
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(nbworker_HH nbnonworker_HH)
drop _merge


*** Merge HHID_panel
merge 1:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020


save"NEEMSIS2-newoccvar", replace
****************************************
* END











****************************************
* Append all and merge with pca and bla bla bla
****************************************
use"RUME-newoccvar", clear

append using "NEEMSIS1-newoccvar"
append using "NEEMSIS2-newoccvar"

order HHID_panel year
drop HHID2010 HHID2016 HHID2020
sort HHID_panel year


*** rename
foreach x in occ_all_HH occ_female_HH occ_male_HH occ_agri_HH occ_nonagri_HH occ_female_agri_HH occ_female_nonagri_HH occ_male_agri_HH occ_male_nonagri_HH occ_dep_HH occ_dep_male_HH occ_dep_female_HH {
local new=substr("`x'",4,strlen("`x'")-6)
rename `x' nbindiv`new'
}


foreach x in nbocc_agri_HH nbocc_nonagri_HH nbocc_all_HH nbocc_female_HH nbocc_male_HH nbocc_female_agri_HH nbocc_female_nonagri_HH nbocc_male_agri_HH nbocc_male_nonagri_HH nbocc_dep_HH nbocc_dep_male_HH nbocc_dep_female_HH {
local new=substr("`x'",1,strlen("`x'")-3)
rename `x' `new'
}

drop nboccupation_HH nbworker_HH nbnonworker_HH

* Gen dummy for dependent
gen dummy_dep=0
replace dummy_dep=1 if nbindiv_dep>0

gen dummy_dep_female=0
replace dummy_dep_female=1 if nbindiv_dep_female>0

gen dummy_dep_male=0
replace dummy_dep_male=1 if nbindiv_dep_male>0

ta dummy_dep year, col nofreq
ta dummy_dep_female year, col nofreq
ta dummy_dep_male year, col nofreq

save"panel-newoccvar", replace


********** Merge with the main database
use"panel_v8", clear

merge 1:1 HHID_panel year using "panel-newoccvar"
drop _merge

save"panel_v9", replace
****************************************
* END
