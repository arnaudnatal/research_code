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












****************************************
* Traits de personnalité
****************************************
cls
use"raw/NEEMSIS2-PTCS", clear


********** Imputation
* Add indiv charact
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex caste)
keep if _merge==3
drop _merge

*
global big5cr ///
cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination ///
cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties ///
cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts ///
cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers ///
cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm ///
cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5cr{
gen im`x'=`x'
}

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}


********** Construction
*** ES
egen fES=rowmean(imcr_enjoypeople imcr_rudetoother imcr_shywithpeople imcr_repetitivetasks imcr_putoffduties imcr_feeldepressed imcr_changemood imcr_easilyupset imcr_nervous imcr_worryalot)
replace fES=0 if fES<0 & fES!=. 
replace fES=6 if fES>6 & fES!=.


*** OPEX
egen fOPEX=rowmean(imcr_interestedbyart imcr_curious imcr_talkative imcr_expressingthoughts imcr_sharefeelings imcr_inventive imcr_liketothink imcr_newideas)
replace fOPEX=0 if fOPEX<0 & fOPEX!=. 
replace fOPEX=6 if fOPEX>6 & fOPEX!=. 


*** CO
egen fCO=rowmean(imcr_organized imcr_enthusiastic imcr_appointmentontime imcr_workhard imcr_completeduties imcr_makeplans)
replace fCO=0 if fCO<0 & fCO!=. 
replace fCO=6 if fCO>6 & fCO!=. 

*
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"


*
save"_tempptcs", replace
****************************************
* END















****************************************
* Base pour les analyses
****************************************
cls
use"raw/NEEMSIS2-HH", clear

*
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"
*

drop if dummylefthousehold==1
drop if livinghome==3
drop if livinghome==4

keep HHID2020 INDID2020 egoid name age sex villageid villagearea religion caste jatis relationshiptohead maritalstatus canread

* Education
count
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education", keepusing(edulevel)
keep if _merge==3
drop _merge
count

* Occupation indiv
count
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv", keepusing(dummyworkedpastyear working_pop mainocc_occupation_indiv mainocc_profession_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv mainocc_hoursayear_indiv mainocc_tenureday_indiv)
keep if _merge==3
drop _merge
count

* Dette indiv
count
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-loans_indiv", keepusing(nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv)
drop if _merge==2
drop _merge
count

* Wealth
count
merge m:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total assets_totalnoland assets_totalnoprop)
keep if _merge==3
drop _merge
count

* Occupation HH
count
merge m:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
keep if _merge==3
drop _merge
count

* Dette HH
count
merge m:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop if _merge==2
drop _merge
count

* Family characteristics
count
merge m:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbmale nbfemale HHsize HH_count_child HH_count_adult typeoffamily waystem head_egoid head_name head_sex head_age head_maritalstatus head_mocc_occupation head_mocc_annualincome head_annualincome head_nboccupation head_edulevel)
keep if _merge==3
drop _merge
count

* Cognition
count
merge 1:1 HHID2020 INDID2020 using "_tempptcs", keepusing(locus locuscat imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking fES fOPEX fCO)
drop if _merge==2
drop _merge
count


*
save "Analysis/Main_analyses.dta", replace
****************************************
* END









