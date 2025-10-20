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

use"Analysis/Main_analyses_network", clear

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

*** Selection
drop if egoid==0

*** Social identity
gen female=0
replace female=1 if sex==2
gen dalit=0
replace dalit=1 if caste==1
order female, after(sex)
order dalit, after(caste)


*** Std
foreach x in fES fOPEX fCO locus {
egen `x'std=std(`x')
rename `x' `x'_raw
rename `x'std `x'
}


*** Panel key
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


*
save"Analysis/Main_analyses_v2", replace
****************************************
* END









****************************************
* Cleaning
****************************************
use"Analysis/Main_analyses_v2", clear

drop imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking

drop head_egoid head_name head_sex head_age head_maritalstatus head_mocc_occupation head_mocc_annualincome head_annualincome head_nboccupation head_edulevel

drop incomeagri_HH incomenonagri_HH shareincomeagri_HH shareincomenonagri_HH nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH

drop mainocc_profession_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv mainocc_hoursayear_indiv mainocc_tenureday_indiv

drop imp1_ds_tot_indiv imp1_is_tot_indiv

drop locus_raw locuscat fES_raw fOPEX_raw fCO_raw 

drop dummyworkedpastyear working_pop

drop waystem

drop canread

order logincome logassets stdincome stdassets married fES fOPEX fCO locus, after(typeoffamily)

save"Analysis/Main_analyses_v3", replace
****************************************
* END



