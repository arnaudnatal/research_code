*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 2, 2025
*-----
gl link = "debtnetworks"
*Creation variables
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------










****************************************
* Alters
****************************************
use"raw/NEEMSIS2-alters - VF", clear

********** Prepa
*
keep if networkpurpose1==1 | ///
networkpurpose2==1 | ///
networkpurpose3==1 | ///
networkpurpose4==1 | ///
networkpurpose5==1 | ///
networkpurpose6==1 | ///
networkpurpose7==1 | ///
networkpurpose8==1 | ///
networkpurpose9==1 | ///
networkpurpose10==1 | ///
networkpurpose11==1 | ///
networkpurpose12==1

drop networkpurpose1 networkpurpose2 networkpurpose3 networkpurpose4 networkpurpose5 networkpurpose6 networkpurpose7 networkpurpose8 networkpurpose9 networkpurpose10 networkpurpose11 networkpurpose12 money

rename castes jatis
gen caste=1 if jatis==2 | jatis==3
replace caste=2 if inlist(jatis,1,5,7,8,10,12,15,16)
replace caste=3 if inlist(jatis,4,6,9,11,13,14)
replace caste=4 if inlist(jatis,66,88)
label define caste 1"Dalits" 2"Middle caste" 3"Upper caste" 4"Don't know", replace
label value caste caste
tab jatis caste 

* Ego characteristics
rename sex sex_alter
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex)
keep if _merge==3
drop _merge
rename sex sex_ego
rename sex_alter sex

merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
order HHID_panel, before(HHID2020)

preserve
use"raw/JatisCastePanel", clear
keep if year==2020
keep HHID_panel casten
rename casten caste_ego
save"_temp", replace
restore
merge m:1 HHID_panel using "_temp"
keep if _merge==3
drop _merge

ta loanid
* For loan selection
preserve
keep HHID2020 INDID2020 nbloanperalter loanid
split loanid, p(,)
sort HHID2020 INDID2020
bysort HHID2020 INDID2020: gen n=_n
drop n
rename loanid lid
reshape long loanid, i(HHID2020 INDID2020 lid) j(n)
drop if loanid==""
sort HHID2020 INDID2020
keep HHID2020 INDID2020 loanid nbloanperalter
save"_temploan", replace
restore

********** Size
bys HHID2020 INDID2020 : egen netsize=sum(1)


********** Force
*Meet frequency : overall average + average by categories
tab	meetfrequency
gen meetfrequency_weekly=cond(meetfrequency==1,1,0)
bys HHID2020 INDID2020 : egen meetweekly_n=total(meetfrequency_weekly)

*Intimacy
tab	intimacy
gen very_intimate=cond(intimacy==3,1,0)
bys HHID2020 INDID2020: egen veryintimate_n=total(very_intimate)

*Invitation
tab	invite reciprocity1 
gen invite_reciprocity=cond(invite==1 & reciprocity1==1,1,0)
bys HHID2020 INDID2020: egen reciprocity_n=total(invite_reciprocity)

*Duration 
*kdensity duration if duration<100
gen duration_cat=1 if duration<5
replace duration_cat=2 if duration>=5 & duration<10
replace duration_cat=3 if duration>=10 & duration<15
replace duration_cat=4 if duration>=15 & duration<20
replace duration_cat=5 if duration>=20 & duration<25
replace duration_cat=6 if duration>=25 & duration<30
replace duration_cat=7 if duration>=30 
tab duration_cat
gen duration_corr=cond(duration<100,duration,.) 
bys HHID2020 INDID2020: egen durationm=mean(duration_corr)

* Strenght 
mca meetfrequency intimacy invite_reciprocity duration_cat, method(indicator) 
predict dim1
sum dim1
gen strength_mca=(dim1-`r(min)')/(`r(max)'-`r(min)')
sum strength_mca


********** Gender homophily
gen same_gender=cond(sex==sex_ego,1,0)
bys HHID2020 INDID2020: egen same_gender_n=total(same_gender)


********** Caste homophily
gen same_caste=cond(caste==caste_ego,1,0)
* Si caste=Don't know alors on part du principe que ce n'est pas la même caste
bys HHID2020 INDID2020: egen same_caste_n=total(same_caste)
ta caste, gen(caste)
*Si caste=Don't know, on part du principe que c'est l'inférieur
replace caste1=1 if caste4==1
bys HHID2020 INDID2020: egen lowcaste_n=total(caste1)
bys HHID2020 INDID2020: egen midcaste_n=total(caste2)
bys HHID2020 INDID2020: egen upcaste_n=total(caste3)




********** Collapse
keep HHID2020 INDID2020 duration_corr netsize meetweekly_n veryintimate_n reciprocity_n strength_mca same_gender_n same_caste_n lowcaste_n midcaste_n upcaste_n

collapse (mean) duration_corr netsize strength_mca meetweekly_n veryintimate_n reciprocity_n same_gender_n same_caste_n lowcaste_n midcaste_n upcaste_n, by(HHID2020 INDID2020)

gen samegender_pct=same_gender_n/netsize
drop same_gender_n

gen samecaste_pct=same_caste_n/netsize
drop same_caste_n


********** Clean
keep HHID2020 INDID2020 samegender_pct samecaste_pct duration_corr netsize strength_mca


save"debtnetw", replace
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
merge m:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbmale nbfemale HHsize HH_count_child HH_count_adult typeoffamily waystem)
keep if _merge==3
drop _merge
count


*
save "Main_analyses.dta", replace
****************************************
* END














****************************************
* Clean
****************************************
cls
use"Main_analyses", clear

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
save"Main_analyses_v2", replace
****************************************
* END










****************************************
* Add networks
****************************************
cls
use"Main_analyses_v2", clear


********** Debt networks
merge 1:1 HHID2020 INDID2020 using "raw/Main_analyses_DG_debttalkrela", keepusing(debt_duration debt_samegender_pct debt_samecaste_pct debt_samejatis_pct debt_sameage_pct debt_samejobstatut_pct debt_sameoccup_pct debt_sameeduc_pct debt_samelocation_pct debt_samewealth_pct debt_IQV_caste debt_IQV_jatis debt_IQV_age debt_IQV_occup debt_IQV_educ debt_IQV_gender debt_IQV_location debt_multiplex_pct debt_multiplexR_pct debt_family_pct debt_meetweekly_pct debt_veryintimate_pct debt_reciprocity_pct debt_money_pct strength_debt netsize_debt)
keep if _merge==3
drop _merge


save"Main_analyses_v3", replace
****************************************
* END















****************************************
* Stat desc pour voir ce que ca donne
****************************************
cls
use"Main_analyses_v3", clear

*
gen dsr=imp1_ds_tot_indiv*100/annualincome_indiv

tabstat dsr, stat(n mean q) by(sex)
tabstat dsr, stat(n mean q) by(caste)

* Macro
global varcont i.sex c.age i.caste i.educ i.occup i.married c.stdassets c.stdincome i.villageid

reg dsr netsize_debt debt_samegender_pct debt_samecaste_pct debt_sameage_pct debt_samejobstatut_pct debt_sameoccup_pct debt_sameeduc_pct debt_samelocation_pct debt_samewealth_pct $varcont


****************************************
* END











