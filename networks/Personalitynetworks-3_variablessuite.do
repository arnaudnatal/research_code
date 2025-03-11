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
use"Analysis/Main_analyses_network_MAJ", clear


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
****************************************
* END























****************************************
* Keep only egos
****************************************
cls

***** Alters
*
use"Analysis/Alters_full", clear

drop if egoid==0
drop if sex==.

save"Analysis/Alters_full_v2", replace


*
use"Analysis/Alters_sub", clear

drop if egoid==0
drop if sex==.

save"Analysis/Alters_sub_v2", replace



***** Egos
use"Analysis/Main_analyses_v2", clear

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

save"Analysis/Main_analyses_v3", replace
****************************************
* END















****************************************
* Nouvelles variables à partir de celles de Damien : All networks
****************************************
use"Analysis/Main_analyses_v3", clear


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
foreach x in IQV_caste IQV_jatis IQV_gender IQV_location {
ta `x'
}

*** Dummy
label define hetero 0"Homo (100%)" 1"Hetero"
foreach x in caste jatis gender location {
gen hetero_`x'=IQV_`x'
replace hetero_`x'=1 if hetero_`x'!=0 & hetero_`x'>0 & hetero_`x'!=.
label values hetero_`x' hetero
}


***** Homophily
cls
foreach x in samegender_pct samecaste_pct samejatis_pct     samelocation_pct {
ta `x'
}

*** Categorical
label define same 0"Different" 1"Same" 2"Mix"
foreach x in gender caste jatis location {
gen same`x'=same`x'_pct
replace same`x'=2 if same`x'!=0 & same`x'!=1 & same`x'!=.
label values same`x' same
}


*** Homophily --> Heterophily pour faire une catégorielle "logique"
foreach x in gender caste jatis location {
gen diff`x'=abs(same`x'_pct-1)
}

label define ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis location {
gen ddiff`x'=diff`x'
replace ddiff`x'=1 if diff`x'>0 & diff`x'!=.
label values ddiff`x' ddiff
}
*/


save"Analysis/Main_analyses_v4", replace
****************************************
* END

















****************************************
* Nouvelles variables à partir de celles de Damien: Split networks
****************************************
use"Analysis/Main_analyses_v4", clear


/*
********** Heterogeneity
cls
foreach cat in debt relative talk labour {
foreach x in `cat'_IQV_caste `cat'_IQV_jatis `cat'_IQV_gender `cat'_IQV_location {
ta `x'
}
}

* Dummy
foreach cat in debt relative talk labour {
label define `cat'_hetero 0"Homo (100%)" 1"Hetero"
foreach x in caste jatis location gender {
gen `cat'_hetero_`x'=`cat'_IQV_`x'
replace `cat'_hetero_`x'=1 if `cat'_hetero_`x'!=0 & `cat'_hetero_`x'>0 & `cat'_hetero_`x'!=.
label values `cat'_hetero_`x' `cat'_hetero
}
}
*/


********** Homophily
cls
foreach cat in debt relative talk labour {
foreach x in `cat'_samegender_pct `cat'_samecaste_pct `cat'_samejatis_pct `cat'_samelocation_pct {
ta `x'
}
}

* Categorical
foreach cat in debt relative talk labour {
label define `cat'_same 0"Different" 1"Same" 2"Mix"
foreach x in samegender samecaste samejatis samelocation {
gen `cat'_`x'=`cat'_`x'_pct
replace `cat'_`x'=2 if `cat'_`x'!=0 & `cat'_`x'!=1 & `cat'_`x'!=.
label values `cat'_`x' `cat'_same
}
}

* Homophily --> Heterophily pour faire une catégorielle "logique"
foreach cat in debt relative talk labour {
foreach x in gender caste jatis location {
gen `cat'_diff`x'=abs(`cat'_same`x'_pct-1)
}
label define `cat'_ddiff 0"Perfect homophily" 1"Heterophily"
foreach x in gender caste jatis location {
gen `cat'_ddiff`x'=`cat'_diff`x'
replace `cat'_ddiff`x'=1 if `cat'_diff`x'>0 & `cat'_diff`x'!=.
label values `cat'_ddiff`x' `cat'_ddiff
}
}




********** Heterophily
cls

tabstat EI_gender EI_caste, stat(n mean q min max)



save"Analysis/Main_analyses_v5", replace
****************************************
* END












****************************************
* Cleaning
****************************************
use"Analysis/Main_analyses_v5", clear

drop imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

drop HHINDID

drop head_egoid head_name head_sex head_age head_maritalstatus head_mocc_occupation head_mocc_annualincome head_annualincome head_nboccupation head_edulevel

drop incomeagri_HH incomenonagri_HH shareincomeagri_HH shareincomenonagri_HH nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH

drop mainocc_profession_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv mainocc_hoursayear_indiv mainocc_tenureday_indiv

drop imp1_ds_tot_indiv imp1_is_tot_indiv

drop locus_raw locuscat fES_raw fOPEX_raw fCO_raw 

drop occup dummyworkedpastyear working_pop

drop waystem

drop sex canread

order logincome logassets stdincome stdassets married fES fOPEX fCO locus, after(typeoffamily)

rename duration_corr duration

rename debt_strenght debt_strength
rename relative_strenght relative_strength
rename talk_strenght talk_strength
rename labour_strenght labour_strength



save"Analysis/Main_analyses_v6", replace
****************************************
* END



