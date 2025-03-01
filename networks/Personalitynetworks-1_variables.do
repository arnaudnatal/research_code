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
* Enlever les 6 ménages pour lesquels il nous manque des infos
****************************************
cls
use"raw/NEEMSIS2-alters_new", clear

rename ALTERID alterid

*
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"


* Enlever les 8 personnes avec un souci de livinghome
drop if HHID2020=="uuid:0e75c80d-e953-475e-b5bd-4a5f3b9755e6" & INDID2020==1
drop if HHID2020=="uuid:22d52dbd-161f-4111-bd4f-9731398a878c" & INDID2020==4
drop if HHID2020=="uuid:607b5085-73ed-4c37-9c6f-55e6d4ac7875" & INDID2020==1
drop if HHID2020=="uuid:72cbd9f1-7b7e-456b-a173-8bde0c64afbd" & INDID2020==7
drop if HHID2020=="uuid:a807111d-42b8-4fca-95f3-6eec9cef337b" & INDID2020==1
drop if HHID2020=="uuid:b33ac02d-ffe0-4a63-8b4a-1ac442b86cf7" & INDID2020==1
drop if HHID2020=="uuid:c184574f-8651-4c3f-bc5d-345417c2f287" & INDID2020==4
drop if HHID2020=="uuid:e53470cf-5e62-48df-9042-145dcbaed9e6" & INDID2020==3


* Caste and jatis
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

********** Save hh
save"Analysis/Alters", replace


* Add details of hhmember
keep if dummyhh==1
/*
sex, age, caste, jatis, educ, occup
*/
keep HHID2020 INDID2020 alterid hhmember
rename INDID2020 ego_INDID2020
rename hhmember INDID2020
label val INDID2020
compress
format ego_INDID2020 %4.0g
format INDID2020 %4.0g

* Sex caste age education
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex caste age currentlyatschool classcompleted everattendedschool reasonnotworkpastyear)
keep if _merge==3
drop _merge

* Occupation indiv
preserve
use "raw/NEEMSIS2-occupnew", clear
keep if dummymainocc==1
keep HHID2020 INDID2020 kindofwork_new
rename kindofwork_new occupation
save"_tempocc", replace
restore

merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv", keepusing(dummyworkedpastyear working_pop)
keep if _merge==3
drop _merge

merge m:1 HHID2020 INDID2020 using "_tempocc"
drop if _merge==2
drop _merge

* Clean
ta caste

fre classcompleted
gen educ=.
replace educ=1 if classcompleted==1
replace educ=1 if classcompleted==2
replace educ=1 if classcompleted==3
replace educ=1 if classcompleted==4
replace educ=1 if classcompleted==5
replace educ=2 if classcompleted==6
replace educ=2 if classcompleted==7
replace educ=2 if classcompleted==8
replace educ=3 if classcompleted==9
replace educ=3 if classcompleted==10
replace educ=4 if classcompleted==12
replace educ=5 if classcompleted==15
replace educ=5 if classcompleted==16
replace educ=6 if everattendedschool==0
recode educ (.=6)

fre occupation
gen occup=.
replace occup=1 if occupation==1
replace occup=2 if occupation==2
replace occup=3 if occupation==3
replace occup=4 if occupation==4
replace occup=5 if occupation==5
replace occup=6 if occupation==6
replace occup=7 if occupation==7
replace occup=8 if occupation==8
replace occup=10 if currentlyatschool==1

fre reasonnotworkpastyear
replace occup=10 if reasonnotworkpastyear==1
replace occup=12 if reasonnotworkpastyear==2
replace occup=12 if reasonnotworkpastyear==4
replace occup=12 if reasonnotworkpastyear==8
replace occup=12 if reasonnotworkpastyear==9
replace occup=12 if reasonnotworkpastyear==10
replace occup=12 if reasonnotworkpastyear==11
replace occup=9 if working_pop==2 

drop everattendedschool classcompleted currentlyatschool reasonnotworkpastyear dummyworkedpastyear working_pop occupation 

rename INDID2020 alter_INDID2020
rename ego_INDID2020 INDID2020

foreach x in sex age caste educ occup {
rename `x' `x'_alter
}



save"_tempreste", replace


********** Append les deux bases
use"Analysis/Alters", clear 

ta dummyhh

merge 1:1 HHID2020 INDID2020 alterid using "_tempreste", keepusing(sex_alter age_alter caste_alter educ_alter occup_alter)
drop _merge

foreach x in sex age caste educ occup {
replace `x'=`x'_alter if `x'==. & `x'_alter!=.
}

drop sex_alter age_alter caste_alter educ_alter occup_alter

*drop if egoid==0

save"Analysis/Alters_v2", replace
****************************************
* END













****************************************
* Traits de personnalité
****************************************
cls
use"raw/NEEMSIS2-PTCS", clear

* Enlever les 8 personnes avec un souci de livinghome
drop if HHID2020=="uuid:0e75c80d-e953-475e-b5bd-4a5f3b9755e6" & INDID2020==1
drop if HHID2020=="uuid:22d52dbd-161f-4111-bd4f-9731398a878c" & INDID2020==4
drop if HHID2020=="uuid:607b5085-73ed-4c37-9c6f-55e6d4ac7875" & INDID2020==1
drop if HHID2020=="uuid:72cbd9f1-7b7e-456b-a173-8bde0c64afbd" & INDID2020==7
drop if HHID2020=="uuid:a807111d-42b8-4fca-95f3-6eec9cef337b" & INDID2020==1
drop if HHID2020=="uuid:b33ac02d-ffe0-4a63-8b4a-1ac442b86cf7" & INDID2020==1
drop if HHID2020=="uuid:c184574f-8651-4c3f-bc5d-345417c2f287" & INDID2020==4
drop if HHID2020=="uuid:e53470cf-5e62-48df-9042-145dcbaed9e6" & INDID2020==3



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


/*
********** Keep
keep HHID2020 INDID2020 egoid imcr_* locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4_rv locuscontrol5_rv locuscontrol6_rv

rename locuscontrol1 locus1
rename locuscontrol2 locus2
rename locuscontrol3 locus3
rename locuscontrol4_rv locus4
rename locuscontrol5_rv locus5
rename locuscontrol6_rv locus6


global var imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm 

*imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking
*locus1 locus2 locus3 locus4 locus5 locus6


**********
factortest $var
factor $var, pcf factor(2)
rotate, quartimin


* Kaiser criterion (eigenvalue>1)
* 14

* Velicer Minimum Average Partial Correlation
minap $var
* 3

* Horn Parallel Analysis
paran $var, factor(pcf)
* 8

* Catell screeplot
*screeplot, neigen(15) yline(1)


putexcel set "EFA.xlsx", modify sheet(Sheet1)
putexcel (E2)=matrix(e(r_L))
*/





********** Construction
*** ES
egen fES=rowmean(imcr_enjoypeople imcr_rudetoother imcr_shywithpeople imcr_repetitivetasks imcr_putoffduties imcr_feeldepressed imcr_changemood imcr_easilyupset imcr_nervous imcr_worryalot)
replace fES=0 if fES<0 & fES!=. 
replace fES=6 if fES>6 & fES!=.
alpha imcr_enjoypeople imcr_rudetoother imcr_shywithpeople imcr_repetitivetasks imcr_putoffduties imcr_feeldepressed imcr_changemood imcr_easilyupset imcr_nervous imcr_worryalot


*** OPEX
egen fOPEX=rowmean(imcr_interestedbyart imcr_curious imcr_talkative imcr_expressingthoughts imcr_sharefeelings imcr_inventive imcr_liketothink imcr_newideas)
replace fOPEX=0 if fOPEX<0 & fOPEX!=. 
replace fOPEX=6 if fOPEX>6 & fOPEX!=. 
alpha imcr_interestedbyart imcr_curious imcr_talkative imcr_expressingthoughts imcr_sharefeelings imcr_inventive imcr_liketothink imcr_newideas


*** CO
egen fCO=rowmean(imcr_organized imcr_enthusiastic imcr_appointmentontime imcr_workhard imcr_completeduties imcr_makeplans)
replace fCO=0 if fCO<0 & fCO!=. 
replace fCO=6 if fCO>6 & fCO!=.
alpha imcr_organized imcr_enthusiastic imcr_appointmentontime imcr_workhard imcr_completeduties imcr_makeplans

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


* Enlever les 8 personnes avec un souci de livinghome
drop if HHID2020=="uuid:0e75c80d-e953-475e-b5bd-4a5f3b9755e6" & INDID2020==1
drop if HHID2020=="uuid:22d52dbd-161f-4111-bd4f-9731398a878c" & INDID2020==4
drop if HHID2020=="uuid:607b5085-73ed-4c37-9c6f-55e6d4ac7875" & INDID2020==1
drop if HHID2020=="uuid:72cbd9f1-7b7e-456b-a173-8bde0c64afbd" & INDID2020==7
drop if HHID2020=="uuid:a807111d-42b8-4fca-95f3-6eec9cef337b" & INDID2020==1
drop if HHID2020=="uuid:b33ac02d-ffe0-4a63-8b4a-1ac442b86cf7" & INDID2020==1
drop if HHID2020=="uuid:c184574f-8651-4c3f-bc5d-345417c2f287" & INDID2020==4
drop if HHID2020=="uuid:e53470cf-5e62-48df-9042-145dcbaed9e6" & INDID2020==3

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

keep HHID2020 INDID2020 egoid name age sex villageid villagearea religion caste jatis relationshiptohead maritalstatus canread classcompleted everattendedschool

* Education
fre classcompleted
gen educ=.
replace educ=1 if classcompleted==1
replace educ=1 if classcompleted==2
replace educ=1 if classcompleted==3
replace educ=1 if classcompleted==4
replace educ=1 if classcompleted==5
replace educ=2 if classcompleted==6
replace educ=2 if classcompleted==7
replace educ=2 if classcompleted==8
replace educ=3 if classcompleted==9
replace educ=3 if classcompleted==10
replace educ=4 if classcompleted==12
replace educ=5 if classcompleted==15
replace educ=5 if classcompleted==16
replace educ=6 if everattendedschool==0
recode educ (.=6)
label define educ 1"Primary or below" 2"Upper primary" 3"High school" 4"Senior secondary" 5"Bachelor and above" 6"No education"
label values educ educ
drop classcompleted everattendedschool


* Kindofwork
preserve
use"raw/NEEMSIS2-occupnew", clear
keep if dummymainocc==1
keep HHID2020 INDID2020 kindofwork_new
rename kindofwork_new occup
save"_temp", replace
restore
merge 1:1 HHID2020 INDID2020 using "_temp"
drop if _merge==2
drop _merge

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












****************************************
* Prepa alters
****************************************
use "Analysis\Alters_v2.dta", clear

save "Analysis\NEEMSIS2-alters_full.dta", replace


********** Merger Ego
preserve
use "Analysis\Main_analyses.dta", replace
keep HHID2020 INDID2020 villageid villagearea name religion sex age jatis caste educ mainocc_occupation_indiv 
foreach var in villageid villagearea name religion sex age jatis caste educ mainocc_occupation_indiv  {
rename `var' `var'_ego
}
rename mainocc_occupation_indiv_ego occup_ego
save "Analysis\Infosegos.dta", replace
restore

merge m:1 HHID2020 INDID2020 using "Analysis\Infosegos.dta"
keep if _merge==3
drop _merge

save "Analysis\Alters_DG.dta", replace


********** Drop les alters problématiques
drop if pbalter==1
drop pbalter


********** Type of network
codebook networkpurpose1, tabulate(13)
gen debt_network=cond( ///
networkpurpose1==1 | ///
networkpurpose2==1 | ///
networkpurpose3==1 | ///
networkpurpose4==1 | ///
networkpurpose5==1 | ///
networkpurpose6==1 | ///
networkpurpose7==1 | ///
networkpurpose8==1 | ///
networkpurpose9==1 | ///
networkpurpose1==2 | ///
networkpurpose2==2 | ///
networkpurpose3==2 | ///
networkpurpose4==2 | ///
networkpurpose5==2 | ///
networkpurpose6==2 | ///
networkpurpose7==2 | ///
networkpurpose8==2 | ///
networkpurpose9==2 ///
,1,0)
tab debt_network

gen relative_network=cond( ///
networkpurpose1==11 | ///
networkpurpose2==11 | ///
networkpurpose3==11 | ///
networkpurpose4==11 | ///
networkpurpose5==11 | ///
networkpurpose6==11 | ///
networkpurpose7==11 | ///
networkpurpose8==11 | ///
networkpurpose9==11 ///
,1,0)
tab relative_network 

gen talk_network=cond( ///
networkpurpose1==9 | ///
networkpurpose2==9 | ///
networkpurpose3==9 | ///
networkpurpose4==9 | ///
networkpurpose5==9 | ///
networkpurpose6==9 | ///
networkpurpose7==9 | ///
networkpurpose8==9 | ///
networkpurpose9==9 ///
,1,0)
tab talk_network

gen interperso_network=cond(relative_network==1 |talk_network==1,1,0) 
tab interperso_network

gen labour_network=cond(inlist(networkpurpose1,3,5,6,7,8) | ///
inlist(networkpurpose2,3,5,6,7,8) | ///
inlist(networkpurpose3,3,5,6,7,8) | ///
inlist(networkpurpose4,3,5,6,7,8) | ///
inlist(networkpurpose5,3,5,6,7,8) | ///
inlist(networkpurpose6,3,5,6,7,8) | ///
inlist(networkpurpose7,3,5,6,7,8) | ///
inlist(networkpurpose8,3,5,6,7,8) | ///
inlist(networkpurpose9,3,5,6,7,8) ///
,1,0)
tab labour_network

gen covid_network=cond(inlist(networkpurpose1,12,13) | ///
inlist(networkpurpose2,12,13) | ///
inlist(networkpurpose3,12,13) | ///
inlist(networkpurpose4,12,13) | ///
inlist(networkpurpose5,12,13) | ///
inlist(networkpurpose6,12,13) | ///
inlist(networkpurpose7,12,13) | ///
inlist(networkpurpose8,12,13) | ///
inlist(networkpurpose9,12,13) ///
,1,0)
tab covid_network

gen asso_network=cond(inlist(networkpurpose1,4) | ///
inlist(networkpurpose2,4) | ///
inlist(networkpurpose3,4) | ///
inlist(networkpurpose4,4) | ///
inlist(networkpurpose5,4) | ///
inlist(networkpurpose6,4) | ///
inlist(networkpurpose7,4) | ///
inlist(networkpurpose8,4) | ///
inlist(networkpurpose9,4) ///
,1,0)
tab asso_network

gen medical_network=cond(inlist(networkpurpose1,10) | ///
inlist(networkpurpose2,10) | ///
inlist(networkpurpose3,10) | ///
inlist(networkpurpose4,10) | ///
inlist(networkpurpose5,10) | ///
inlist(networkpurpose6,10) | ///
inlist(networkpurpose7,10) | ///
inlist(networkpurpose8,10) | ///
inlist(networkpurpose9,10) ///
,1,0)
tab medical_network


********** Correction sur les friends
*Correction 09/12/24
tab relative_network friend
replace friend=0 if relative_network==1
*si close_relative alors famille_etendu==1
gen family=cond(dummyfam==1 | relative_network==1,1,0)

gen role=cond(family==0 & friend==0 & labourrelation==0 & wkp==0,1,0)
tab role

tab networkpurpose1 role
gen lender=cond(role==1 & networkpurpose1==1,1,0)
replace role=0 if lender==1
tab meet if role==1 & networkpurpose1!=1
replace labourrelation=1 if role==1 & meet==1
replace role=0 if labourrelation==1 & role==1
replace friend=1 if networkpurpose1==10 & role==1
replace role=0 if friend==1 & role==1
drop if role==1

drop role
gen role=cond(lender==0 & (family==0 |  family==.) & (friend==0 | friend==.) & (labourrelation==0 | labourrelation==.) & (wkp==0 | wkp==.),1,0)
tab role

tab networkpurpose1 role
replace lender=1 if role==1 & networkpurpose1==1
replace role=0 if lender==1
tab meet if role==1 & networkpurpose1!=1
replace labourrelation=1 if role==1 & meet==1
replace role=0 if labourrelation==1 & role==1
replace friend=1 if networkpurpose1==10 & role==1
replace role=0 if friend==1 & role==1
drop if role==1
drop role

* Missing friend : 
replace friend=0 if friend==.
replace friend=0 if family==1
gen other_relation=cond(family==0 & friend==0,1,0)
ta other_relation

*11836 alters

********** Alters clean 
preserve
drop debt_network relative_network talk_network interperso_network labour_network covid_network asso_network medical_network
egen HHINDID=group(HHID2020 INDID2020)
order HHINDID HHID2020 INDID2020 egoid alterid
save"Analysis/NEEMSIS2-alters_clean", replace
restore



********** Alters clean subgroups
preserve
drop if interperso_network==0 & debt_network==0 & labour_network==0
drop interperso_network covid_network asso_network medical_network
egen HHINDID=group(HHID2020 INDID2020)
order HHINDID HHID2020 INDID2020 egoid alterid
save"Analysis/NEEMSIS2-alters_subclean", replace
restore

****************************************
* END
