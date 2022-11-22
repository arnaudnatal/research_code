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
* panel debt
****************************************
********** RUME panel
use"RUME-loans_mainloans_new", clear

merge m:m HHID2010 using "ODRIIS-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

keep HHID_panel loanid loanamount loanreasongiven loanlender lender4 reason_cat lender_cat loanbalance loansettled imp1_debt_service imp1_interest_service imp1_interest imp1_totalrepaid_year debt_service interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat

gen year=2010

order HHID_panel year loanid loanamount loansettled loanbalance loanreasongiven reason_cat loanlender lender4 lender_cat 

fre loanreasongiven
fre loanlender

save"temp_RUMEloanpanel", replace


********** NEEMSIS-1
use"NEEMSIS1-loans_mainloans_new", clear

merge m:m HHID2016 using "ODRIIS-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "ODRIIS-indiv_wide", keepusing(INDID_panel)
drop if _merge==2
drop _merge

keep HHID_panel INDID_panel loan_database loanid loanamount loanreasongiven loanlender lender4 reason_cat lender_cat loanbalance loansettled imp1_debt_service imp1_interest_service imp1_interest imp1_totalrepaid_year debt_service interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat given_nore givenamt_nore givencat_nore givencatamt_nore effective_nore effectiveamt_nore given_othe givenamt_othe givencat_othe givencatamt_othe effective_othe effectiveamt_othe

gen year=2016

fre loanreasongiven
fre loanlender

order HHID_panel year INDID_panel loan_database loanid loanamount loansettled loanbalance loanreasongiven reason_cat loanlender lender4 lender_cat 

tostring loanid, replace

save"temp_NEEMSIS1loanpanel", replace





********** NEEMSIS-2
use"NEEMSIS2-loans_mainloans_new", clear

merge m:m HHID2020 using "ODRIIS-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "ODRIIS-indiv_wide", keepusing(INDID_panel)
drop if _merge==2
drop _merge

keep HHID_panel INDID_panel loan_database loanid loanamount loanreasongiven loanlender loaneffectivereason lender4 reason_cat lender_cat loanbalance loansettled imp1_debt_service imp1_interest_service imp1_interest imp1_totalrepaid_year debt_service interest_service lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat given_nore givenamt_nore givencat_nore givencatamt_nore effective_nore effectiveamt_nore given_othe givenamt_othe givencat_othe givencatamt_othe effective_othe effectiveamt_othe

gen year=2020

fre loanreasongiven
fre loanlender

tostring loanid, replace

order HHID_panel year INDID_panel loan_database loanid loanamount loansettled loanbalance loanreasongiven reason_cat loanlender lender4 lender_cat loaneffectivereason 

save"temp_NEEMSIS2loanpanel", replace



********** Append
use "temp_NEEMSIS2loanpanel", clear
append using "temp_NEEMSIS1loanpanel"
append using "temp_RUMEloanpanel"

save"panel_loans", replace


drop if loansettled==1
drop if loansettled==.
save"panel_loans_nonsettled", replace
****************************************
* END









****************************************
* 2010
****************************************
use"RUME-HH", clear

keep HHID2010 village villagearea

decode village, gen(villageid)
drop village
rename villageid village
replace village="ELA" if village=="ELANTHALMPATTU"
replace village="GOV" if village=="GOVULAPURAM"
replace village="KOR" if village=="KORATTORE"
replace village="KAR" if village=="KARUMBUR"
replace village="KUV" if village=="KUVAGAM"
replace village="ORA" if village=="ORAIYURE"
replace village="SEM" if village=="SEMAKOTTAI"
replace village="MAN" if village=="MANAPAKKAM"
replace village="MANAM" if village=="MANAMTHAVIZHINTHAPUTHUR"
replace village="NAT" if village=="NATHAM"

decode villagearea, gen(vi)
drop villagearea
rename vi area

duplicates drop
count

* Add debt
merge 1:1 HHID2010 using "RUME-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_othlendserv_6 dumHH_othlendserv_6 nbHH_othlendserv_nrep dumHH_othlendserv_nrep nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_both dumHH_guarantee_both nbHH_guarantee_none dumHH_guarantee_none nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_othe dumHH_borrservices_othe nbHH_borrservices_nrep dumHH_borrservices_nrep nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_noth dumHH_plantorep_noth nbHH_plantorep_othe dumHH_plantorep_othe nbHH_plantorep_nrep dumHH_plantorep_nrep

* Add assets
merge 1:1 HHID2010 using "RUME-assets"
drop _merge


* Add income
merge 1:1 HHID2010 using "RUME-occup_HH"
drop _merge

* Panel
merge 1:m HHID2010 using"ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2010

gen year=2010


save"temp_RUME", replace
****************************************
* END











****************************************
* 2016-17
****************************************
use"NEEMSIS1-HH", clear

keep HHID2016 villageid villagearea

decode villageid, gen(village)
drop villageid

decode villagearea, gen(vi)
drop villagearea
rename vi area

duplicates drop
count

* Add debt
merge 1:1 HHID2016 using "NEEMSIS1-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe


* Add assets
merge 1:1 HHID2016 using "NEEMSIS1-assets"
drop _merge


* Add income
merge 1:1 HHID2016 using "NEEMSIS1-occup_HH"
drop _merge

* Panel
merge 1:m HHID2016 using"ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2016

gen year=2016


save"temp_NEEMSIS1", replace
****************************************
* END








****************************************
* 2020-21
****************************************
use"NEEMSIS2-HH", clear

keep HHID2020 villageid villagearea

decode villageid, gen(village)
drop villageid

decode villagearea, gen(vi)
drop villagearea
rename vi area

duplicates drop
count

* Add debt
merge 1:1 HHID2020 using "NEEMSIS2-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_silv dumHH_prodpledge_silv nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe


* Add assets
merge 1:1 HHID2020 using "NEEMSIS2-assets"
drop _merge


* Add income
merge 1:1 HHID2020 using "NEEMSIS2-occup_HH"
drop _merge

* Panel
merge 1:m HHID2020 using"ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2020

gen year=2020


save"temp_NEEMSIS2", replace
****************************************
* END













****************************************
* Panel and construction
****************************************
use"temp_NEEMSIS2", clear

append using "temp_NEEMSIS1"
append using "temp_RUME"


*** Construction v1
* DSR
gen dsr=imp1_ds_tot_HH*100/annualincome_HH
replace dsr=0 if dsr==.

* ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.

* DAR
gen dar=loanamount_HH*100/assets
replace dar=0 if dar==.

*TDR
gen tdr=totHH_givenamt_repa*100/loanamount_HH
gen effectiveTDR=totHH_effectiveamt_repa*100/loanamount_HH

*TAR
gen tar=totHH_givenamt_repa*100/assets
gen effectiveTAR=totHH_effectiveamt_repa*100/assets


*** Order
order HHID_panel year
sort HHID_panel year


save"panel_HH", replace
****************************************
* END




















****************************************
* Stat HH
****************************************
use"panel_HH", clear


* Debt
tabstat dsr isr dar, stat(n mean sd min max q) by(year)


* Debt trap
ta dumHH_given_repa year, col
ta dumHH_effective_repa year, col
/*
I think it is better to use given as it is for all loans for all years
(effective only for ML in 2010)
*/

tabstat dsr isr dar tdr tar if year==2010, stat(n mean cv q) by(dumHH_given_repa) long
tabstat dsr isr dar tdr tar if year==2016, stat(n mean cv q) by(dumHH_given_repa) long
tabstat dsr isr dar tdr tar if year==2020, stat(n mean cv q) by(dumHH_given_repa) long

****************************************
* END
