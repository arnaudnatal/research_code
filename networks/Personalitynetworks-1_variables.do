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
* Clean
****************************************
cls
use"Analysis/Main_analyses", clear


*** Networks
merge 1:1 HHID2020 INDID2020 using "Analysis/Main_analyses_DG", keepusing(netsize_all duration_corr strength_mca family_pct friend_pct labour_pct wkp_pct same_gender_pct same_caste_pct same_jatis_pct same_age_pct same_jobstatut_pct same_occup_pct same_educ_pct same_location_pct same_situation_pct IQV_caste IQV_jatis IQV_age IQV_occup IQV_educ IQV_gender multiplexityF_pct meetweekly_pct very_intimate_pct reciprocity_pct money_never_pct)
keep if _merge==3
drop _merge


*** Networks details
merge 1:1 HHID2020 INDID2020 using "Analysis/Main_analyses_DG_debttalkrela", keepusing(netsize_debt netsize_relative netsize_talk talk_duration relative_duration debt_duration strength_debt strength_talk strength_relative talk_samegender_pct relative_samegender_pct debt_samegender_pct talk_samecaste_pct relative_samecaste_pct debt_samecaste_pct talk_samejatis_pct relative_samejatis_pct debt_samejatis_pct talk_sameage_pct relative_sameage_pct debt_sameage_pct talk_samejobstatut_pct relative_samejobstatut_pct debt_samejobstatut_pct talk_sameoccup_pct relative_sameoccup_pct debt_sameoccup_pct talk_sameeduc_pct relative_sameeduc_pct debt_sameeduc_pct talk_samelocation_pct relative_samelocation_pct debt_samelocation_pct talk_samewealth_pct relative_samewealth_pct debt_samewealth_pct talk_IQV_caste talk_IQV_jatis talk_IQV_age talk_IQV_occup talk_IQV_educ talk_IQV_gender talk_IQV_location relative_IQV_caste relative_IQV_jatis relative_IQV_age relative_IQV_occup relative_IQV_educ relative_IQV_gender relative_IQV_location debt_IQV_caste debt_IQV_jatis debt_IQV_age debt_IQV_occup debt_IQV_educ debt_IQV_gender debt_IQV_location debt_multiplex_pct debt_multiplexR_pct talk_multiplexR_pct relative_multiplexR_pct talk_family_pct relative_family_pct debt_family_pct talk_meetweekly_pct talk_veryintimate_pct talk_reciprocity_pct talk_money_pct relative_meetweekly_pct relative_veryintimate_pct relative_reciprocity_pct relative_money_pct debt_meetweekly_pct debt_veryintimate_pct debt_reciprocity_pct debt_money_pct)
keep if _merge==3
drop _merge




*** Occupation
rename mainocc_occupation_indiv occupation
recode occupation (.=0)

ta occupation
ta occup
recode occup (.=12)
codebook occup
label define kindofwork 12"Unoccupied working age individuals", modify

*** HH FE
encode HHID2020, gen(HHFE)
order HHFE, after(HHID2020)

*** Income and wealth
recode annualincome_HH (.=1) (0=1)
recode assets_total (.=1) (0=1)
gen logincome=log(annualincome_HH)
gen logassets=log(assets_total)
egen stdincome=std(annualincome_HH)
egen stdassets=std(assets_total)

*** Marital
fre maritalstatus
gen married=.
replace married=0 if maritalstatus==2
replace married=0 if maritalstatus==3
replace married=1 if maritalstatus==1
ta maritalstatus married
drop maritalstatus

*** Debt
recode nbloans_HH nbloans_indiv (.=0)

*
save"Analysis/Main_analyses_v2", replace


*** Personnalité et réseaux
*drop if egoid==0


save"Analysis/Main_analyses_v3", replace
****************************************
* END


















****************************************
* Alters add ego characteristics
****************************************
cls
use"Analysis/Alters_v2", clear

preserve
use"Analysis/Main_analyses_v3", clear
global var villageid villagearea sex age caste canread educ dummyworkedpastyear working_pop occup locus locuscat fES fOPEX fCO
keep HHID2020 INDID2020 egoid $var
foreach x in $var {
rename `x' ego_`x'
}
ta egoid
save"_temp", replace
restore


merge m:1 HHID2020 INDID2020 using "_temp"
keep if _merge==3
drop _merge

/*
HHID2020									INDID2020	egoid
uuid:0e75c80d-e953-475e-b5bd-4a5f3b9755e6	1			1
uuid:0eacf77c-4f63-4ffc-80c9-f6b9da59fdba	7			3
uuid:22d52dbd-161f-4111-bd4f-9731398a878c	4			3
uuid:607b5085-73ed-4c37-9c6f-55e6d4ac7875	1			1
uuid:6bd1eaa0-9117-47c2-8c61-29d5102daf1f	18			3
uuid:72cbd9f1-7b7e-456b-a173-8bde0c64afbd	7			3
uuid:a807111d-42b8-4fca-95f3-6eec9cef337b	1			1
uuid:b33ac02d-ffe0-4a63-8b4a-1ac442b86cf7	1			1
uuid:c184574f-8651-4c3f-bc5d-345417c2f287	4			3
uuid:e53470cf-5e62-48df-9042-145dcbaed9e6	3			3
*/


save"Analysis/Alters_v3", replace
****************************************
* END









****************************************
* Keep only egos
****************************************
cls

***** Alters
use"Analysis/Alters_v3", clear

drop if egoid==0
drop if sex==.

save"Analysis/Alters_v4", replace


***** Egos
use"Analysis/Main_analyses_v3", clear

drop if egoid==0

* Social identity
gen female=0
replace female=1 if sex==2
gen dalit=0
replace dalit=1 if caste==1
order female, after(sex)
order dalit, after(caste)

* Std
foreach x in fES fOPEX fCO locus {
egen `x'std=std(`x')
rename `x' `x'_raw
rename `x'std `x'
}


save"Analysis/Main_analyses_v4", replace
****************************************
* END















****************************************
* Nouvelles variables à partir de celles de Damien : All networks
****************************************
use"Analysis/Main_analyses_v4", clear


********** Panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
order HHID_panel

tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
order HHID_panel INDID_panel
destring INDID2020, replace





***** Hetero
cls
foreach x in IQV_caste IQV_jatis IQV_age IQV_occup IQV_educ IQV_gender {
ta `x'
}

*** Dummy
label define hetero 0"Homo (100%)" 1"Hetero"
foreach x in caste jatis age occup educ gender {
gen hetero_`x'=IQV_`x'
replace hetero_`x'=1 if hetero_`x'!=0 & hetero_`x'>0 & hetero_`x'!=.
label values hetero_`x' hetero
}


***** Homophily
cls
foreach x in same_gender_pct same_caste_pct same_jatis_pct same_age_pct same_jobstatut_pct same_occup_pct same_educ_pct same_location_pct same_situation_pct {
ta `x'
}

*** Categorical
label define same 0"Different" 1"Same" 2"Mix"
foreach x in gender caste jatis age jobstatut occup educ location situation {
gen same_`x'=same_`x'_pct
replace same_`x'=2 if same_`x'!=0 & same_`x'!=1 & same_`x'!=.
label values same_`x' same
}


*** Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location situation {
gen diff`x'=abs(same_`x'_pct-1)
}

label define ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location situation {
gen ddiff`x'=diff`x'
replace ddiff`x'=1 if diff`x'>0 & diff`x'!=.
label values ddiff`x' ddiff
}



save"Analysis/Main_analyses_v5", replace
****************************************
* END

















****************************************
* Nouvelles variables à partir de celles de Damien: Split networks
****************************************
use"Analysis/Main_analyses_v5", clear

********** Debt
*** Hetero
cls
foreach x in debt_IQV_caste debt_IQV_jatis debt_IQV_age debt_IQV_occup debt_IQV_educ debt_IQV_gender {
ta `x'
}
* Dummy
label define debt_hetero 0"Homo (100%)" 1"Hetero"
foreach x in caste jatis age occup educ gender {
gen debt_hetero_`x'=debt_IQV_`x'
replace debt_hetero_`x'=1 if debt_hetero_`x'!=0 & debt_hetero_`x'>0 & debt_hetero_`x'!=.
label values debt_hetero_`x' debt_hetero
}

*** Homophily
cls
foreach x in debt_samegender_pct debt_samecaste_pct debt_samejatis_pct debt_sameage_pct debt_samejobstatut_pct debt_sameoccup_pct debt_sameeduc_pct debt_samelocation_pct debt_samewealth_pct {
ta `x'
}
* Categorical
label define debt_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis sameage samejobstatut sameoccup sameeduc samelocation samewealth {
gen debt_`x'=debt_`x'_pct
replace debt_`x'=2 if debt_`x'!=0 & debt_`x'!=1 & debt_`x'!=.
label values debt_`x' debt_same
}
* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location wealth {
gen debt_diff`x'=abs(debt_same`x'_pct-1)
}
label define debt_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location wealth {
gen debt_ddiff`x'=debt_diff`x'
replace debt_ddiff`x'=1 if debt_diff`x'>0 & debt_diff`x'!=.
label values debt_ddiff`x' debt_ddiff
}




********** Talk
*** Hetero
cls
foreach x in talk_IQV_caste talk_IQV_jatis talk_IQV_age talk_IQV_occup talk_IQV_educ talk_IQV_gender {
ta `x'
}
* Dummy
label define talk_hetero 0"Homo (100%)" 1"Hetero"
foreach x in caste jatis age occup educ gender {
gen talk_hetero_`x'=talk_IQV_`x'
replace talk_hetero_`x'=1 if talk_hetero_`x'!=0 & talk_hetero_`x'>0 & talk_hetero_`x'!=.
label values talk_hetero_`x' talk_hetero
}

*** Homophily
cls
foreach x in talk_samegender_pct talk_samecaste_pct talk_samejatis_pct talk_sameage_pct talk_samejobstatut_pct talk_sameoccup_pct talk_sameeduc_pct talk_samelocation_pct talk_samewealth_pct {
ta `x'
}
* Categorical
label define talk_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis sameage samejobstatut sameoccup sameeduc samelocation samewealth {
gen talk_`x'=talk_`x'_pct
replace talk_`x'=2 if talk_`x'!=0 & talk_`x'!=1 & talk_`x'!=.
label values talk_`x' talk_same
}
* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location wealth {
gen talk_diff`x'=abs(talk_same`x'_pct-1)
}
label define talk_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location wealth {
gen talk_ddiff`x'=talk_diff`x'
replace talk_ddiff`x'=1 if talk_diff`x'>0 & talk_diff`x'!=.
label values talk_ddiff`x' talk_ddiff
}




********** Relative
*** Hetero
cls
foreach x in relative_IQV_caste relative_IQV_jatis relative_IQV_age relative_IQV_occup relative_IQV_educ relative_IQV_gender {
ta `x'
}
* Dummy
label define relative_hetero 0"Homo (100%)" 1"Hetero"
foreach x in caste jatis age occup educ gender {
gen relative_hetero_`x'=relative_IQV_`x'
replace relative_hetero_`x'=1 if relative_hetero_`x'!=0 & relative_hetero_`x'>0 & relative_hetero_`x'!=.
label values relative_hetero_`x' relative_hetero
}

*** Homophily
cls
foreach x in relative_samegender_pct relative_samecaste_pct relative_samejatis_pct relative_sameage_pct relative_samejobstatut_pct relative_sameoccup_pct relative_sameeduc_pct relative_samelocation_pct relative_samewealth_pct {
ta `x'
}
* Categorical
label define relative_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis sameage samejobstatut sameoccup sameeduc samelocation samewealth {
gen relative_`x'=relative_`x'_pct
replace relative_`x'=2 if relative_`x'!=0 & relative_`x'!=1 & relative_`x'!=.
label values relative_`x' relative_same
}
* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location wealth {
gen relative_diff`x'=abs(relative_same`x'_pct-1)
}
label define relative_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location wealth {
gen relative_ddiff`x'=relative_diff`x'
replace relative_ddiff`x'=1 if relative_diff`x'>0 & relative_diff`x'!=.
label values relative_ddiff`x' relative_ddiff
}


save"Analysis/Main_analyses_v6", replace
****************************************
* END














****************************************
* Personality traits lag
****************************************
use"Analysis/Main_analyses_v6", clear


********** JDS (i.e., no pooled PCA)
preserve
use"raw/JDS-cognition2016", clear
rename base_f1_std ES2016
rename base_f2_std CO2016
rename base_f3_std PL2016
rename base_f5_std AG2016
save"_tempcognition2016", replace
restore
merge 1:1 HHID_panel INDID_panel using "_tempcognition2016"
drop if _merge==2
drop _merge


********** Stability (i.e., pooled PCA)
preserve
use"raw/WP-stabilitypooled", clear
rename f1corr_ES pES2016
rename f2corr_OPEX pPL2016
rename f3corr_CO pCO2016
keep if year==2016
drop year
save"_tempcognition2016", replace
restore
merge 1:1 HHID_panel INDID_panel using "_tempcognition2016"
drop if _merge==2
drop _merge


********** Cleaning
drop imcr_*



save"Analysis/Main_analyses_v7", replace
****************************************
* END










****************************************
* Nb egos
****************************************
use"raw/NEEMSIS2-HH", clear

drop if egoid==0

drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"

count

clear

use"Analysis/Main_analyses_v6", clear
****************************************
* END

