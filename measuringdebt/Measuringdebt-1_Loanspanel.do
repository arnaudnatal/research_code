*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------







****************************************
* RUME
****************************************
use"raw/RUME-loans_mainloans_new", clear

merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

keep HHID_panel loanid loanamount loanreasongiven loanlender lender4 reason_cat lender_cat loanbalance loansettled imp1_debt_service imp1_interest_service imp1_interest imp1_totalrepaid_year debt_service interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat

gen year=2010

order HHID_panel year loanid loanamount loansettled loanbalance loanreasongiven reason_cat loanlender lender4 lender_cat 

fre loanreasongiven
fre loanlender

save"temp_RUMEloanpanel", replace
****************************************
* END














****************************************
* NEEMSIS1
****************************************
use"raw/NEEMSIS1-loans_mainloans_new", clear

merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
drop if _merge==2
drop _merge

keep HHID_panel INDID_panel loan_database loanid loanamount loanreasongiven loanlender lender4 reason_cat lender_cat loanbalance loansettled imp1_debt_service imp1_interest_service imp1_interest imp1_totalrepaid_year debt_service interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat given_nore givenamt_nore givencat_nore givencatamt_nore effective_nore effectiveamt_nore given_othe givenamt_othe givencat_othe givencatamt_othe effective_othe effectiveamt_othe

gen year=2016

fre loanreasongiven
fre loanlender

order HHID_panel year INDID_panel loan_database loanid loanamount loansettled loanbalance loanreasongiven reason_cat loanlender lender4 lender_cat 

tostring loanid, replace

save"temp_NEEMSIS1loanpanel", replace
****************************************
* END
















****************************************
* NEEMSIS2
****************************************
use"raw/NEEMSIS2-loans_mainloans_new", clear

merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/ODRIIS-indiv_wide", keepusing(INDID_panel)
drop if _merge==2
drop _merge

keep HHID_panel INDID_panel loan_database loanid loanamount loanreasongiven loanlender loaneffectivereason lender4 reason_cat lender_cat loanbalance loansettled imp1_debt_service imp1_interest_service imp1_interest imp1_totalrepaid_year debt_service interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat given_nore givenamt_nore givencat_nore givencatamt_nore effective_nore effectiveamt_nore given_othe givenamt_othe givencat_othe givencatamt_othe effective_othe effectiveamt_othe

gen year=2020

fre loanreasongiven
fre loanlender

tostring loanid, replace

order HHID_panel year INDID_panel loan_database loanid loanamount loansettled loanbalance loanreasongiven reason_cat loanlender lender4 lender_cat loaneffectivereason 

save"temp_NEEMSIS2loanpanel", replace

****************************************
* END








****************************************
* Append panel
****************************************
use "temp_NEEMSIS2loanpanel", clear
append using "temp_NEEMSIS1loanpanel"
append using "temp_RUMEloanpanel"

save"panel_loans", replace


drop if loansettled==1
drop if loansettled==.
save"panel_loans_nonsettled", replace
****************************************
* END
