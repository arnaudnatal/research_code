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
* Clean
****************************************
cls
use"Analysis/Main_analyses", clear


*** Networks details
merge 1:1 HHID2020 INDID2020 using "Analysis/Fullnetwork_traits_DG_tomerge", keepusing(netsize_debt netsize_relative netsize_talk talk_samegender_pct relative_samegender_pct debt_samegender_pct talk_samecaste_pct relative_samecaste_pct debt_samecaste_pct talk_samejatis_pct relative_samejatis_pct debt_samejatis_pct talk_sameage_pct relative_sameage_pct debt_sameage_pct talk_samejobstatut_pct relative_samejobstatut_pct debt_samejobstatut_pct talk_sameoccup_pct relative_sameoccup_pct debt_sameoccup_pct talk_sameeduc_pct relative_sameeduc_pct debt_sameeduc_pct talk_samelocation_pct relative_samelocation_pct debt_samelocation_pct talk_IQV_caste talk_IQV_jatis talk_IQV_age talk_IQV_occup talk_IQV_educ talk_IQV_gender talk_IQV_location relative_IQV_caste relative_IQV_jatis relative_IQV_age relative_IQV_occup relative_IQV_educ relative_IQV_gender relative_IQV_location debt_IQV_caste debt_IQV_jatis debt_IQV_age debt_IQV_occup debt_IQV_educ debt_IQV_gender debt_IQV_location debt_multiplex_pct debt_multiplexR_pct talk_multiplexR_pct relative_multiplexR_pct)
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




/*
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
*/


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
foreach x in debt_samegender_pct debt_samecaste_pct debt_samejatis_pct debt_sameage_pct debt_samejobstatut_pct debt_sameoccup_pct debt_sameeduc_pct debt_samelocation_pct {
ta `x'
}
* Categorical
label define debt_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis sameage samejobstatut sameoccup sameeduc samelocation {
gen debt_`x'=debt_`x'_pct
replace debt_`x'=2 if debt_`x'!=0 & debt_`x'!=1 & debt_`x'!=.
label values debt_`x' debt_same
}
* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location {
gen debt_diff`x'=abs(debt_same`x'_pct-1)
}
label define debt_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location {
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
foreach x in talk_samegender_pct talk_samecaste_pct talk_samejatis_pct talk_sameage_pct talk_samejobstatut_pct talk_sameoccup_pct talk_sameeduc_pct talk_samelocation_pct {
ta `x'
}
* Categorical
label define talk_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis sameage samejobstatut sameoccup sameeduc samelocation {
gen talk_`x'=talk_`x'_pct
replace talk_`x'=2 if talk_`x'!=0 & talk_`x'!=1 & talk_`x'!=.
label values talk_`x' talk_same
}
* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location {
gen talk_diff`x'=abs(talk_same`x'_pct-1)
}
label define talk_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location {
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
foreach x in relative_samegender_pct relative_samecaste_pct relative_samejatis_pct relative_sameage_pct relative_samejobstatut_pct relative_sameoccup_pct relative_sameeduc_pct relative_samelocation_pct {
ta `x'
}
* Categorical
label define relative_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis sameage samejobstatut sameoccup sameeduc samelocation {
gen relative_`x'=relative_`x'_pct
replace relative_`x'=2 if relative_`x'!=0 & relative_`x'!=1 & relative_`x'!=.
label values relative_`x' relative_same
}
* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis age jobstatut occup educ location {
gen relative_diff`x'=abs(relative_same`x'_pct-1)
}
label define relative_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis age jobstatut occup educ location {
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

