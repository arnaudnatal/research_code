*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Formation
****************************************
use"panel_stab_v2_wide", clear


********** Selection
keep if panel2016==1


********** To keep
keep HHID_panel INDID_panel ///
egoid* name* sex* age* jatiscorr* caste* edulevel* villageid* panel* dummydemonetisation* relationshiptohead* maritalstatus* mainocc_occupation_indiv* annualincome_indiv* annualincome_HH* assets_total1000* assets_totalnoland1000* HHsize* typeoffamily* village* aspirationminimumwage* dummyaspirationmorehours* aspirationminimumwage2* dummyexposure* secondlockdownexposure* dummysell* submissiondate* ars* ars2* ars3* username* edulevel_backup* num_tt* lit_tt* raven_tt* loanamount_HH* assets_sizeownland* ownland* dummymarriage* dummy_marriedlist* expenses_heal* shareexpenses_heal* mainocc_profession_indiv* mainocc_sector_indiv* mainocc_occupationname_indiv*



********** Username
* 2016
rename username_2016_code2016 username_neemsis1
desc username_neemsis1
fre username_neemsis1
label define username_2016_code 1"Enum: Ant" 2"Enum: Kum" 3"Enum: May" 4"Enum: Paz" 5"Enum: Raj" 6"Enum: Sit" 7"Enum: Viv", modify

* 2020
rename username_2020_code2020 username_neemsis2
fre username_neemsis2
desc username_neemsis2
recode username_neemsis2 (1=4)
fre username_neemsis2
label define userneemsis2 1"Chithra-Radhika" 2"Mayan" 3"Pazani" 4"Raichal" 5"Rajalakschmi" 6"Suganya-Malarvizhi" 7"Vivek-Radja"
fre username_neemsis2
replace username_neemsis2=username_neemsis2-1
label values username_neemsis2 userneemsis2
fre username_neemsis2

drop username2016 username_20162016 username_20202016 username_2020_code2016 username2020 username_20162020 username_20202020 username_2016_code2020

fre username_backup2016 username_neemsis1 username_backup2020 username_neemsis2




********** Creation
* Sex
rename sex2016 sex
drop sex2020
desc sex
label define sex 1"Sex: Male" 2"Sex: Female", modify
fre sex


* Age
egen age_cat=cut(age2016), at(18,25,35,45,55,65,82) icodes
label define age 0"Age: [18;25[" 1"Age: [25;35[" 2"Age: [35;45[" 3"Age: [45;55[" 4"Age: [55;65[" 5"Age: [65;]", modify
label values age_cat age
recode age_cat (5=4)
label define age 0"Age: [18;25[" 1"Age: [25;35[" 2"Age: [35;45[" 3"Age: [45;55[" 4"Age: [55;+]", modify
tab age2016 age_cat


* Age2
gen age25=0 if age2016<25
replace age25=1 if age2016>=25


* Edu
clonevar educode=edulevel2016
clonevar educode20=edulevel2020
recode educode educode20 (4=3)
fre educode educode20
label define edulevel 0"Edu: Below prim" 1"Edu: Primary" 2"Edu: High school" 3"Edu: HSC/Diploma or more", modify 



* MOC
clonevar moc_indiv=mainocc_occupation_indiv2016
recode moc_indiv (5=4)
label define occupcode2 0"Occ: No occup" 1"Occ: Agri" 2"Occ: Agri coolie" 3"Occ: Coolie" 4"Occ: Reg" 6"Occ: SE" 7"Occ: NREGA"
label values moc_indiv occupcode2
ta mainocc_occupation_indiv2016 moc_indiv


* Bias
gen diff_ars3=ars32020-ars32016
tabstat diff_ars3, stat(n mean sd p50 min max range)
dis 2.428571*0.05
egen diff_ars3_cat5=cut(diff_ars3), at(-1,-.121,.121,1.5) icodes
label define ars3cat 0"Bias: Decrease" 1"Bias: Stable" 2"Bias: Increase"
label values diff_ars3_cat5 ars3cat


* HH
encode HHID_panel, gen(cluster)


* Marital
fre maritalstatus2016
clonevar marital=maritalstatus2016
recode marital (3=2) (4=2)
recode marital (1=0) (2=1)
ta maritalstatus2016 marital
label define maritalstatus 0"Married: Yes" 1"Married: No", modify 


* Female
fre sex
gen female=sex-1
fre female
label define female 0"Sex: Male" 1"Sex: Female"
label values female female


* Caste
ta caste2016 caste2020
drop caste2020
rename caste2016 caste
label define castecat 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper", modify


* Demonetisation
label define demo 0"Demo: No" 1"Demo: Yes"
label values dummydemonetisation2016 demo


* Villages
label define villageid 1"Vill: ELA" 2"Vill: GOV" 3"Vill: KAR" 4"Vill: KOR" 5"Vill: KUV" 6"Vill: MAN" 7"Vill: MANAM" 8"Vill: NAT" 9"Vill: ORA" 10"Vill: SEM", modify


* Wealth
xtile assets2016_q=assets_total10002016, n(3)
xtile annualincome_HH2016_q=annualincome_HH2016, n(3)
recode annualincome_indiv2016 (.=0)
xtile annualincome_indiv2016_q=annualincome_indiv2016, n(3)
label define assets 1"Assets: T1" 2"Assets: T2" 3"Assets: T3"
label values assets2016_q assets
label define income 1"Income: T1" 2"Income: T2" 3"Income: T3"
label values annualincome_HH2016_q income
label values annualincome_indiv2016_q income


* Caste
codebook caste
label define castecat2 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper", modify
label values caste castecat
fre caste


* Type of family
label define typeoffamily 1 "Fam: Nuclear" 2 "Fam: Stem" 3 "Fam: Joint-stem"
foreach i in 2016 2020 {
replace typeoffamily`i'="1" if typeoffamily`i'=="nuclear"
replace typeoffamily`i'="2" if typeoffamily`i'=="stem"
replace typeoffamily`i'="3" if typeoffamily`i'=="joint-stem"
destring typeoffamily`i', replace
}
label values typeoffamily2016 typeoffamily
label values typeoffamily2020 typeoffamily
fre typeoffamily2016 typeoffamily2020



********** Merge cognition
merge 1:1 HHID_panel INDID_panel using "panel_stab_v2_pooled_wide"
drop _merge
keep if sex!=.




********** Shocks
* COVID
destring dummysell2020, replace
label define cov 0 "Cov: Not exp" 1 "Cov: Exposed"
label values dummysell2020 cov
fre dummysell2020

* Demonetisation
ta dummydemonetisation2016
label define demo2 0 "Demo: Not exp" 1 "Demo: Exposed"
label values dummydemonetisation2016 demo2
fre dummydemonetisation2016

* Land
gen dummyshockland=.
label define shockland 0 "Same or higher land area" 1 "Sale/loss of land"
label values dummyshockland shockland
replace dummyshockland=0 if assets_sizeownland2020>=assets_sizeownland2016
replace dummyshockland=1 if assets_sizeownland2020<assets_sizeownland2016
ta dummyshockland

* Debt
gen temp1=loanamount_HH2016*(100/158)
gen temp2=loanamount_HH2020*(100/184)
gen dummyshockdebt=.
label define shockdebt 0 "Same or lower debt" 1 "Higher debt (x2)"
label values dummyshockdebt shockdebt
gen temp=temp2/temp1
ta temp
replace dummyshockdebt=0 if temp<2
replace dummyshockdebt=1 if temp>=2
ta dummyshockdebt
drop temp temp1 temp2

* Health
gen temp1=expenses_heal2016*(100/158)
gen temp2=expenses_heal2020*(100/184)
gen dummyshockhealth=.
label define shockhealth 0 "Same or lower health spending" 1 "Higher health spending (x2)"
label values dummyshockhealth shockhealth
gen temp=temp2/temp1
ta temp
replace dummyshockhealth=0 if temp<2
replace dummyshockhealth=1 if temp>=2
ta dummyshockhealth
drop temp temp1 temp2


* Health2
gen dummyshockhealth2=.
label define shockhealth2 0 "Same or lower health spending" 1 "Higher health spending"
label values dummyshockhealth2 shockhealth2
gen temp=shareexpenses_heal2020/shareexpenses_heal2016
ta temp
replace dummyshockhealth2=0 if temp<2
replace dummyshockhealth2=1 if temp>=2
ta dummyshockhealth
drop temp


* Employment
ta mainocc_occupation_indiv2016 mainocc_occupation_indiv2020, chi2
fre mainocc_occupation_indiv2016

gen dummyshockemployment=0
label define shockemployment 0 "Same or better type of job" 1 "Lower type of job"
replace dummyshockemployment=1 if mainocc_occupation_indiv2016!=0 & mainocc_occupation_indiv2020==0
replace dummyshockemployment=1 if mainocc_occupation_indiv2016!=0 & mainocc_occupation_indiv2016!=7 & mainocc_occupation_indiv2020==7
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==1 & mainocc_occupation_indiv2020==2
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==1 & mainocc_occupation_indiv2020==7
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==4 & mainocc_occupation_indiv2020==2
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==4 & mainocc_occupation_indiv2020==3
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==4 & mainocc_occupation_indiv2020==7
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==5 & mainocc_occupation_indiv2020==2
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==5 & mainocc_occupation_indiv2020==3
replace dummyshockemployment=1 if mainocc_occupation_indiv2016==5 & mainocc_occupation_indiv2020==7
label values dummyshockemployment shockemployment

ta mainocc_occupation_indiv2016 mainocc_occupation_indiv2020 if dummyshockemployment==0
ta mainocc_occupation_indiv2016 mainocc_occupation_indiv2020 if dummyshockemployment==1


cls
global shock dummysell2020 dummydemonetisation2016 dummyshockland dummyshockdebt dummyshockhealth dummyshockemployment
tab1 $shock

save "panel_stab_pooled_wide_v3", replace
****************************************
* END


