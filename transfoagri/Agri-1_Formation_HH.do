*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 21, 2023
*-----
gl link = "transfoagri"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* RUME
****************************************
use"$directory\RUME-HH", clear

*** Expenses
sum foodexpenses educationexpenses healthexpenses
preserve
order HHID2010 INDID2010 foodexpenses educationexpenses healthexpenses
restore

*** Family
merge m:1 HHID2010 using "RUME-family"
drop _merge

*** Asset
merge m:1 HHID2010 using "RUME-assets"
drop _merge

*** Income HH
merge m:1 HHID2010 using "RUME-occup_HH"
drop _merge

*** Income indiv
merge 1:1 HHID2010 INDID2010 using "RUME-occup_indiv"
drop _merge

*** KILM
merge 1:1 HHID2010 INDID2010 using "RUME-kilm"
drop _merge

*** Edu indiv
merge 1:1 HHID2010 INDID2010 using "RUME-education"
drop _merge

*** Debt
merge m:1 HHID2010 using "RUME-loans_HH"
drop _merge

*** Transferts
merge m:1 HHID2010 using "RUME-transferts_HH"
drop _merge

*** Gold
merge m:1 HHID2010 using"RUME-gold_HH"
drop _merge

*** keypanel HH
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

*** keypanel indiv
tostring INDID2010, replace
merge 1:m HHID_panel INDID2010 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

*** Save
save"RUME_v0", replace

****************************************
* END







****************************************
* NEEMSIS-1
****************************************
use"$directory\NEEMSIS1-HH", clear

*** Expenses
sum foodexpenses educationexpenses healthexpenses
bysort HHID2016: egen ed=sum(educationexpenses)
drop educationexpenses
rename ed educationexpenses

*** PTCS
merge 1:1 HHID2016 INDID2016 using "NEEMSIS1-ptcs", keepusing(raven_tt num_tt lit_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit)
drop _merge

*** Family
merge m:1 HHID2016 using "NEEMSIS1-family"
drop _merge

*** Asset
merge m:1 HHID2016 using "NEEMSIS1-assets"
drop _merge

*** Income HH
merge m:1 HHID2016 using "NEEMSIS1-occup_HH"
drop _merge

*** Income indiv
merge 1:1 HHID2016 INDID2016 using "NEEMSIS1-occup_indiv"
drop _merge

*** KILM
merge 1:1 HHID2016 INDID2016 using "NEEMSIS1-kilm"
drop _merge

*** Edu indiv
merge 1:1 HHID2016 INDID2016 using "NEEMSIS1-education"
drop _merge

*** Debt
merge m:1 HHID2016 using "NEEMSIS1-loans_HH"
drop _merge

*** Transferts
merge m:1 HHID2016 using "NEEMSIS1-transferts_HH"
drop _merge

*** Village
merge m:1 HHID2016 using "NEEMSIS1-villages"
drop _merge

*** Gold
merge m:1 HHID2016 using"NEEMSIS1-gold_HH"
drop _merge

*** keypanel HH
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

*** keypanel indiv
tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

*** Save
save"NEEMSIS1_v0", replace

****************************************
* END









****************************************
* NEEMSIS-2
****************************************
use"$directory\NEEMSIS2-HH", clear

*** Expenses
sum foodexpenses educationexpenses healthexpenses
bysort HHID2020: egen ed=sum(educationexpenses)
drop educationexpenses
rename ed educationexpenses

*** PTCS
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-ptcs", keepusing(raven_tt num_tt lit_tt cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit locus)
drop _merge

*** Working conditions
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-ego", keepusing(respect workmate useknowledgeatwork satisfyingpurpose schedule takeholiday agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 changework happywork satisfactionsalary executionwork1 executionwork2 executionwork3 executionwork4 executionwork5 executionwork6 executionwork7 executionwork8 executionwork9 accidentalinjury losswork lossworknumber mostseriousincident mostseriousinjury seriousinjuryother physicalharm problemwork1 problemwork2 problemwork4 problemwork5 problemwork6 problemwork7 problemwork8 problemwork9 problemwork10 workexposure1 workexposure2 workexposure3 workexposure4 workexposure5 professionalequipment break retirementwork verbalaggression physicalagression sexualharassment sexualaggression discrimination1 discrimination2 discrimination3 discrimination4 discrimination5 discrimination6 discrimination7 discrimination8 discrimination9 resdiscrimination1 resdiscrimination2 resdiscrimination3 resdiscrimination4 resdiscrimination5 rurallocation lackskill)
drop _merge

*** Family
merge m:1 HHID2020 using "NEEMSIS2-family"
drop _merge

*** Asset
merge m:1 HHID2020 using "NEEMSIS2-assets"
drop _merge

*** Income HH
merge m:1 HHID2020 using "NEEMSIS2-occup_HH"
drop _merge

*** Income indiv
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-occup_indiv"
drop _merge

*** KILM
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-kilm"
drop _merge

*** Edu indiv
merge 1:1 HHID2020 INDID2020 using "NEEMSIS2-education"
drop _merge

*** Debt
merge m:1 HHID2020 using "NEEMSIS2-loans_HH"
drop _merge

*** Transferts
merge m:1 HHID2020 using "NEEMSIS2-transferts_HH"
drop _merge

*** Village
merge m:1 HHID2020 using "NEEMSIS2-villages"
drop _merge

*** Gold
merge m:1 HHID2020 using"NEEMSIS2-gold_HH"
drop _merge

*** keypanel HH
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

*** keypanel indiv
tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

*** Drop 6 without agri
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef" 
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4" 
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7" 
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409" 

*** Save
save"NEEMSIS2_v0", replace

****************************************
* END









****************************************
* Panel HH
****************************************

********** RUME
use"$directory\RUME_v0", clear

* Migration at HH level
bysort HHID2010: egen sum_dummymigration=sum(dummymigration)

* Keep
keep HHID_panel village villagearea ///
house housetitle ///
HHsize family typeoffamily nbgeneration waystem dummypolygamous head_sex head_age head_edulevel dependencyratio dummyheadfemale sexratio ///
assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland ///
incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH ///
ownland sizeownland ///
loanamount_HH nbloans_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous ///
remittnet_HH nonworkersratio sum_dummymigration goldquantity_HH ///
foodexpenses educationexpenses healthexpenses

* Level
gen year=2010
duplicates drop


* Save
order HHID_panel year
sort HHID_panel
save"RUME_v1", replace


********** NEEMSIS-1
use"$directory\NEEMSIS1_v0", clear

* Gold at HH level

* Migration at HH level
bysort HHID2016: egen sum_dummymigration=sum(dummymigration)

* Keep
keep HHID_panel villageid villagearea ///
house housetitle ///
HHsize family typeoffamily nbgeneration waystem dummypolygamous head_sex head_age head_edulevel dependencyratio dummyheadfemale sexratio ///
assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland ///
incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH ///
ownland sizeownland ///
loanamount_HH nbloans_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous ///
remittnet_HH nonworkersratio sum_dummymigration goldquantity_HH ///
foodexpenses educationexpenses healthexpenses

* Level
gen year=2016
duplicates drop

* Save
order HHID_panel year
sort HHID_panel
save"NEEMSIS1_v1", replace




********** NEEMSIS-2
use"$directory\NEEMSIS2_v0", clear

* Migration at HH level
bysort HHID2020: egen sum_dummymigration=sum(dummymigration)

* Keep
keep HHID_panel villageid villagearea ///
house housetitle ///
HHsize family typeoffamily nbgeneration waystem dummypolygamous head_sex head_age head_edulevel dependencyratio dummyheadfemale sexratio ///
assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland ///
incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH ///
ownland sizeownland ///
loanamount_HH nbloans_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous ///
remittnet_HH nonworkersratio sum_dummymigration goldquantity_HH ///
foodexpenses educationexpenses healthexpenses

* Level
gen year=2020
duplicates drop

* Destring
destring ownland house housetitle, replace

* Save
order HHID_panel year
sort HHID_panel
save"NEEMSIS2_v1", replace


********** Panel
use"RUME_v1", clear

append using "NEEMSIS1_v1"
append using "NEEMSIS2_v1"


*** Migration
ta sum_dummymigration
replace sum_dummymigration=1 if sum_dummymigration>1
rename sum_dummymigration dummymigration

*** Villages

*** Land
recode ownland (.=0)

*** Panel
encode HHID_panel, gen(panelvar)
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

order HHID_panel panelvar year time

*** Deflate
foreach x in assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total incomeagri_HH incomenonagri_HH annualincome_HH loanamount_HH totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous remittnet_HH assets_totalnoland foodexpenses educationexpenses healthexpenses {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}

*** Tof
gen tof=0
replace tof=1 if typeoffamily=="nuclear"
replace tof=2 if typeoffamily=="stem"
replace tof=3 if typeoffamily=="joint-stem"

label define tof 1"ToF: Nuclear" 2"ToF: Stem" 3"ToF: Joint-stem"
label values tof tof

*** Caste
preserve
use"RUME-caste", clear
keep HHID_panel caste jatiscorr
gen year=2010
append using "NEEMSIS1-caste"
keep HHID_panel year caste jatiscorr
replace year=2016 if year==.
append using "NEEMSIS2-caste"
keep HHID_panel year caste jatiscorr
replace year=2020 if year==.
encode jatiscorr, gen(jatis)
drop jatiscorr
collapse (mean) jatis caste, by(HHID_panel year)
label values jatis jatis
ta caste year
save"castetemp", replace
restore

merge 1:1 HHID_panel year using "castetemp"
drop _merge

label define caste 1"Dalits" 2"Middle" 3"Upper"
label values caste caste

*** Caste2 Caste
gen caste2=caste
recode caste2 (3=2)

label define caste2 1"Dalits" 2"Non-Dalits"
label values caste2 caste2

*** Year
label define year 2010"2010" 2016"2016-17" 2020"2020-21"
label values year year

*
label values jatis jatis

* Select
drop if time==.

save"panel_v0", replace
****************************************
* END
