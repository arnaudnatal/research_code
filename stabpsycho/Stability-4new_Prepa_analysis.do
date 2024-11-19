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
*keep if panel2016==1


********** To keep
keep HHID_panel INDID_panel ///
egoid* name* sex* age* jatiscorr* caste* edulevel* villageid* panel* dummydemonetisation* relationshiptohead* maritalstatus* mainocc_occupation_indiv* annualincome_indiv* annualincome_HH* assets_total1000* assets_totalnoland1000* HHsize* typeoffamily* village* aspirationminimumwage* dummyaspirationmorehours* aspirationminimumwage2* dummyexposure* secondlockdownexposure* dummysell* submissiondate* ars* ars2* ars3* username* edulevel_backup* num_tt* lit_tt* raven_tt* loanamount_HH* imp1_ds_tot_HH* assets_sizeownland* ownland* dummymarriage* dummy_marriedlist* expenses_heal* shareexpenses_heal* mainocc_profession_indiv* mainocc_sector_indiv* mainocc_occupationname_indiv*



********** Username
* 2016
rename username_2016_code2016 username_neemsis1
desc username_neemsis1
fre username_neemsis1
label define username_2016_code 1"Enu2016: Ant" 2"Enu2016: Kum" 3"Enu2016: May" 4"Enu2016: Paz" 5"Enu2016: Raj" 6"Enu2016: Sit" 7"Enu2016: Viv", modify

* 2020
rename username_2020_code2020 username_neemsis2
fre username_neemsis2
desc username_neemsis2
recode username_neemsis2 (1=4)
fre username_neemsis2
label define userneemsis2 1"Enu2020: Chi" 2"Enu2020: May" 3"Enu2020: Paz" 4"Enu2020: Rai" 5"Enu2020: Raj" 6"Enu2020: Sug" 7"Enu2020: Viv"
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
label define occupcode2 0"Occ: No occup" 1"Occ: Agri" 2"Occ: Agri coolie" 3"Occ: Coolie" 4"Occ: Reg" 6"Occ: SE" 7"Occ: MGNREGA"
label values moc_indiv occupcode2
ta mainocc_occupation_indiv2016 moc_indiv


* Bias
gen diff_ars3=ars32020-ars32016
tabstat diff_ars3, stat(n mean sd p50 min max range)
dis 2.428571*0.05
egen diff_ars3_cat5=cut(diff_ars3), at(-1,-.121,.121,1.5) icodes
label define ars3cat 0"AcqB: Decrease" 1"AcqB: Stable" 2"AcqB: Increase"
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


* Label
label var age2016 "Age (in years)"
label var HHsize2016 "Household size"
label var ars32016 "Absolute acquiescence score"




********** Merge cognition
global items imcr_curious2016 imcr_interestedbyart2016 imcr_repetitivetasks2016 imcr_inventive2016 imcr_liketothink2016 imcr_newideas2016 imcr_activeimagination2016 imcr_organized2016 imcr_makeplans2016 imcr_workhard2016 imcr_appointmentontime2016 imcr_putoffduties2016 imcr_easilydistracted2016 imcr_completeduties2016 imcr_enjoypeople2016 imcr_sharefeelings2016 imcr_shywithpeople2016 imcr_enthusiastic2016 imcr_talktomanypeople2016 imcr_talkative2016 imcr_expressingthoughts2016 imcr_workwithother2016 imcr_understandotherfeeling2016 imcr_trustingofother2016 imcr_rudetoother2016 imcr_toleratefaults2016 imcr_forgiveother2016 imcr_helpfulwithothers2016 imcr_managestress2016 imcr_nervous2016 imcr_changemood2016 imcr_feeldepressed2016 imcr_easilyupset2016 imcr_worryalot2016 imcr_staycalm2016 imcr_curious2020 imcr_interestedbyart2020 imcr_repetitivetasks2020 imcr_inventive2020 imcr_liketothink2020 imcr_newideas2020 imcr_activeimagination2020 imcr_organized2020 imcr_makeplans2020 imcr_workhard2020 imcr_appointmentontime2020 imcr_putoffduties2020 imcr_easilydistracted2020 imcr_completeduties2020 imcr_enjoypeople2020 imcr_sharefeelings2020 imcr_shywithpeople2020 imcr_enthusiastic2020 imcr_talktomanypeople2020 imcr_talkative2020 imcr_expressingthoughts2020 imcr_workwithother2020 imcr_understandotherfeeling2020 imcr_trustingofother2020 imcr_rudetoother2020 imcr_toleratefaults2020 imcr_forgiveother2020 imcr_helpfulwithothers2020 imcr_managestress2020 imcr_nervous2020 imcr_changemood2020 imcr_feeldepressed2020 imcr_easilyupset2020 imcr_worryalot2020 imcr_staycalm2020

merge 1:1 HHID_panel INDID_panel using "panel_stab_v2_pooled_wide", keepusing( ///
fES2016 fES2020 ///
fCO2016 fCO2020 ///
fOPEX2016 fOPEX2020 ///
num_tt2016 num_tt2020 ///
lit_tt2016 lit_tt2020 ///
raven_tt2016 raven_tt2020 ///
diff_fES abs_diff_fES catdiff_fES dumdiff_fES ///
diff_fCO abs_diff_fCO catdiff_fCO dumdiff_fCO ///
diff_fOPEX abs_diff_fOPEX catdiff_fOPEX dumdiff_fOPEX ///
var_fES abs_var_fES catvar_fES dumvar_fES ///
var_fCO abs_var_fCO catvar_fCO dumvar_fCO ///
var_fOPEX abs_var_fOPEX catvar_fOPEX dumvar_fOPEX ///
$items)
drop _merge
keep if sex!=.

label var fES2016 "Emotional stability score"
label var fCO2016 "Conscientiousness score"
label var fOPEX2016 "Plasticity score"
label var num_tt2016 "Numeracy score"
label var lit_tt2016 "Literacy score"
label var raven_tt2016 "Raven score"

label var fES2020 "Emotional stability score in 2020-21"
label var fCO2020 "Conscientiousness score in 2020-21"
label var fOPEX2020 "Plasticity score in 2020-21"
label var num_tt2020 "Numeracy score in 2020-21"
label var lit_tt2020 "Literacy score in 2020-21"
label var raven_tt2020 "Raven score in 2020-21"

label var diff_fES "Emotional stability"
label var diff_fCO "Conscientiousness"
label var diff_fOPEX "Plasticity"

label var dumdiff_fES "Unstable on ES (% of yes)"
label var dumdiff_fCO "Unstable on CO (% of yes)"
label var dumdiff_fOPEX "Unstable on PL (% of yes)"

label var catdiff_fES "ES temporal trajectory"
label var catdiff_fCO "CO temporal trajectory"
label var catdiff_fOPEX "PL temporal trajectory"

label var abs_diff_fES "Intensity of ES instability"
label var abs_diff_fCO "Intensity of CO instability"
label var abs_diff_fOPEX "Intensity of PL instability"

label var var_fES "Variation ES (%)"
label var var_fCO "Variation CO (%)"
label var var_fOPEX "Variation PL (%)"

label var dumvar_fES "Unstable on ES (% of yes)"
label var dumvar_fCO "Unstable on CO (% of yes)"
label var dumvar_fOPEX "Unstable on PL (% of yes)"

label var catvar_fES "ES temporal trajectory"
label var catvar_fCO "CO temporal trajectory"
label var catvar_fOPEX "PL temporal trajectory"

label var abs_var_fES "Intensity of ES instability"
label var abs_var_fCO "Intensity of CO instability"
label var abs_var_fOPEX "Intensity of PL instability"



********** Items to rename
foreach x in $items {
local new=substr("`x'",6,99)
rename `x' `new'
}


********** Shocks
* COVID
destring dummysell2020, replace
label define cov 0 "Cov: Not exp" 1 "Cov: Exposed"
label values dummysell2020 cov
fre dummysell2020
label var dummysell2020 "COVID-19 exposure (% of yes)"

* Demonetisation
ta dummydemonetisation2016
label define demo2 0 "Demo: Not exp" 1 "Demo: Exposed"
label values dummydemonetisation2016 demo2
fre dummydemonetisation2016
label var dummydemonetisation2016 "Demonetisation exposure (% of yes)"

* Land
gen dummyshockland=.
label define shockland 0 "Same or higher land area" 1 "Sale/loss of land"
label values dummyshockland shockland
replace dummyshockland=0 if assets_sizeownland2020>=assets_sizeownland2016
replace dummyshockland=1 if assets_sizeownland2020<assets_sizeownland2016
ta dummyshockland
label var dummyshockland "Sale/loss of land (% of yes)"

* Debt
gen temp1=imp1_ds_tot_HH2016/annualincome_HH2016
gen temp2=imp1_ds_tot_HH2020/annualincome_HH2020
gen dummyshockdebt=.
label define shockdebt 0 "Same or lower debt" 1 "Higher debt (x1.5)"
label values dummyshockdebt shockdebt
gen temp=temp2/temp1
ta temp
replace dummyshockdebt=0 if temp<1.5
replace dummyshockdebt=1 if temp>=1.5
ta dummyshockdebt
drop temp temp1 temp2
label var dummyshockdebt "Higher debt (x1.5) (% of yes)"
ta dummyshockdebt

* Debt2
gen temp1=imp1_ds_tot_HH2016/annualincome_HH2016
gen temp2=imp1_ds_tot_HH2020/annualincome_HH2020
gen dummyshockdebt2=.
label define shockdebt2 0 "Same or lower debt" 1 "Higher debt (x2)"
label values dummyshockdebt2 shockdebt2
gen temp=temp2/temp1
ta temp
replace dummyshockdebt2=0 if temp<2
replace dummyshockdebt2=1 if temp>=2
ta dummyshockdebt2
drop temp temp1 temp2
label var dummyshockdebt2 "Higher debt (x2) (% of yes)"
ta dummyshockdebt2

* Health
gen temp1=expenses_heal2016/annualincome_HH2016
gen temp2=expenses_heal2020/annualincome_HH2020
gen dummyshockhealth=.
label define shockhealth 0 "Same or lower health spending" 1 "Higher health spending (x1.5)"
label values dummyshockhealth shockhealth
gen temp=temp2/temp1
ta temp
replace dummyshockhealth=0 if temp<1.5
replace dummyshockhealth=1 if temp>=1.5
ta dummyshockhealth
drop temp temp1 temp2
label var dummyshockhealth "Higher health spending (x1.5) (% of yes)"
ta dummyshockhealth


* Health2
gen temp1=expenses_heal2016/annualincome_HH2016
gen temp2=expenses_heal2020/annualincome_HH2020
gen dummyshockhealth2=.
label define shockhealth2 0 "Same or lower health spending" 1 "Higher health spending (x2)"
label values dummyshockhealth2 shockhealth2
gen temp=temp2/temp1
ta temp
replace dummyshockhealth2=0 if temp<2
replace dummyshockhealth2=1 if temp>=2
ta dummyshockhealth2
drop temp temp1 temp2
label var dummyshockhealth2 "Higher health spending (x2) (% of yes)"
ta dummyshockhealth2


* Income
gen temp1=annualincome_indiv2016*(100/158)
gen temp2=annualincome_indiv2020*(100/184)
gen dummyshockincome=.
label define shockincome 0 "Same or lower income" 1 "Higher income (x1.5)"
label values dummyshockincome shockincome
gen temp=temp2/temp1
ta temp
replace dummyshockincome=0 if temp<1.5
replace dummyshockincome=1 if temp>=1.5
ta dummyshockincome
drop temp temp1 temp2
label var dummyshockincome "Higher income (x1.5) (% of yes)"
ta dummyshockincome


* Income2
gen temp1=annualincome_indiv2016*(100/158)
gen temp2=annualincome_indiv2020*(100/184)
gen dummyshockincome2=.
label define shockincome2 0 "Same or lower income" 1 "Higher income (x2)"
label values dummyshockincome2 shockincome2
gen temp=temp2/temp1
ta temp
replace dummyshockincome2=0 if temp<2
replace dummyshockincome2=1 if temp>=2
ta dummyshockincome2
drop temp temp1 temp2
label var dummyshockincome2 "Higher income (x2) (% of yes)"
ta dummyshockincome2


* Assets
gen temp1=assets_total10002016*(100/158)
gen temp2=assets_total10002020*(100/184)
gen dummyshockassets=.
label define shockassets 0 "Assets: Same or higher" 1 "Assets: Lower"
label values dummyshockassets shockassets
gen temp=temp2/temp1
ta temp
replace dummyshockassets=0 if temp>=1
replace dummyshockassets=1 if temp<1
ta dummyshockassets
drop temp temp1 temp2
label var dummyshockassets "Lower assets (% of yes)"
ta dummyshockassets


********** Abs diff rec
foreach x in ES OPEX CO {
gen abs_diff_rec_f`x'=abs_diff_f`x'
replace abs_diff_rec_f`x'=0 if dumdiff_f`x'==0
order abs_diff_rec_f`x', after(abs_diff_f`x')
}




save "panel_stab_pooled_wide_v3", replace
****************************************
* END


