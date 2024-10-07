*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 7, 2024
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------









****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* To keep
keep HHID2016 INDID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle name sex age relationshiptohead livinghome
fre house housetitle
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid

* Livingarea
merge m:1 HHID2016 using "raw/NEEMSIS1-villages", keepusing(villagename2016 livingarea)
drop _merge
rename villagename2016 village
ta village livingarea



********** Individual characteristics
* Education
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education"
drop _merge

* Occupation
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv"
drop _merge

* Debt
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-loans_indiv"
drop _merge
drop nbindiv_othlendserv_poli dumindiv_othlendserv_poli nbindiv_othlendserv_fina dumindiv_othlendserv_fina nbindiv_othlendserv_guar dumindiv_othlendserv_guar nbindiv_othlendserv_gene dumindiv_othlendserv_gene nbindiv_othlendserv_none dumindiv_othlendserv_none nbindiv_othlendserv_othe dumindiv_othlendserv_othe nbindiv_guarantee_doc dumindiv_guarantee_doc nbindiv_guarantee_chit dumindiv_guarantee_chit nbindiv_guarantee_shg dumindiv_guarantee_shg nbindiv_guarantee_pers dumindiv_guarantee_pers nbindiv_guarantee_jewe dumindiv_guarantee_jewe nbindiv_guarantee_none dumindiv_guarantee_none nbindiv_guarantee_othe dumindiv_guarantee_othe nbindiv_borrservices_free dumindiv_borrservices_free nbindiv_borrservices_work dumindiv_borrservices_work nbindiv_borrservices_supp dumindiv_borrservices_supp nbindiv_borrservices_none dumindiv_borrservices_none nbindiv_borrservices_othe dumindiv_borrservices_othe nbindiv_plantorep_chit dumindiv_plantorep_chit nbindiv_plantorep_work dumindiv_plantorep_work nbindiv_plantorep_migr dumindiv_plantorep_migr nbindiv_plantorep_asse dumindiv_plantorep_asse nbindiv_plantorep_inco dumindiv_plantorep_inco nbindiv_plantorep_borr dumindiv_plantorep_borr nbindiv_plantorep_othe dumindiv_plantorep_othe nbindiv_settlestrat_inco dumindiv_settlestrat_inco nbindiv_settlestrat_sche dumindiv_settlestrat_sche nbindiv_settlestrat_borr dumindiv_settlestrat_borr nbindiv_settlestrat_sell dumindiv_settlestrat_sell nbindiv_settlestrat_land dumindiv_settlestrat_land nbindiv_settlestrat_cons dumindiv_settlestrat_cons nbindiv_settlestrat_addi dumindiv_settlestrat_addi nbindiv_settlestrat_work dumindiv_settlestrat_work nbindiv_settlestrat_supp dumindiv_settlestrat_supp nbindiv_settlestrat_harv dumindiv_settlestrat_harv nbindiv_settlestrat_othe dumindiv_settlestrat_othe nbindiv_prodpledge_gold dumindiv_prodpledge_gold nbindiv_prodpledge_land dumindiv_prodpledge_land nbindiv_prodpledge_car dumindiv_prodpledge_car nbindiv_prodpledge_bike dumindiv_prodpledge_bike nbindiv_prodpledge_frid dumindiv_prodpledge_frid nbindiv_prodpledge_furn dumindiv_prodpledge_furn nbindiv_prodpledge_tail dumindiv_prodpledge_tail nbindiv_prodpledge_cell dumindiv_prodpledge_cell nbindiv_prodpledge_line dumindiv_prodpledge_line nbindiv_prodpledge_dvd dumindiv_prodpledge_dvd nbindiv_prodpledge_came dumindiv_prodpledge_came nbindiv_prodpledge_gas dumindiv_prodpledge_gas nbindiv_prodpledge_comp dumindiv_prodpledge_comp nbindiv_prodpledge_dish dumindiv_prodpledge_dish nbindiv_prodpledge_none dumindiv_prodpledge_none nbindiv_prodpledge_othe dumindiv_prodpledge_othe

* PTCS
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-PTCS", keepusing(cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit raven_tt num_tt lit_tt)
drop _merge


* Transferts
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-transferts_indiv"
drop _merge

* Gold
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-gold", keepusing(goldquantity2 goldquantitypledge2 goldamountpledge2 corr dummygold)
drop _merge



********** Household characteristics

* Family compo
merge m:1 HHID2016 using "raw/NEEMSIS1-family"
drop _merge

* Assets and expenses
merge m:1 HHID2016 using "raw/NEEMSIS1-assets"
drop _merge

* Income
merge m:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
drop _merge

* Remittances
merge m:1 HHID2016 using "raw/NEEMSIS1-transferts_HH"
drop _merge pension_HH transferts_HH

* Gold
merge m:1 HHID2016 using "raw/NEEMSIS1-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH


********** Final

* Panel HH
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge


* Panel indiv
tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Rename
rename HHID2016 HHID
rename INDID2016 INDID
order HHID_panel INDID_panel

*Year
gen year=2016




save"temp_NEEMSIS1indiv", replace
****************************************
* END











****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* Drop migrants
drop if dummylefthousehold==1
fre house

* To keep
keep HHID2020 INDID2020 villagearea villageid village_new dummymarriage ownland ownland house housetitle name sex age relationshiptohead livinghome
fre house housetitle
destring house housetitle, replace
destring ownland, replace
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid


* Livingarea
rename village_new village
replace village="ELA" if village=="Elanthalmpattu"
replace village="GOV" if village=="Govulapuram"
replace village="KOR" if village=="Korattore"
replace village="KAR" if village=="Karumbur"
replace village="KUV" if village=="Kuvagam"
replace village="ORA" if village=="Oraiyure"
replace village="SEM" if village=="Semakottai"
replace village="MAN" if village=="Manapakkam"
replace village="MANAM" if village=="Manamthavizhinthaputhur"
replace village="NAT" if village=="Natham"
ta village area



********** Individual characteristics
* Education
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-education"
drop _merge

* Occupation
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv"
drop _merge

* Debt
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-loans_indiv"
drop _merge
drop nbindiv_othlendserv_poli dumindiv_othlendserv_poli nbindiv_othlendserv_fina dumindiv_othlendserv_fina nbindiv_othlendserv_guar dumindiv_othlendserv_guar nbindiv_othlendserv_gene dumindiv_othlendserv_gene nbindiv_othlendserv_none dumindiv_othlendserv_none nbindiv_othlendserv_othe dumindiv_othlendserv_othe nbindiv_guarantee_doc dumindiv_guarantee_doc nbindiv_guarantee_chit dumindiv_guarantee_chit nbindiv_guarantee_shg dumindiv_guarantee_shg nbindiv_guarantee_pers dumindiv_guarantee_pers nbindiv_guarantee_jewe dumindiv_guarantee_jewe nbindiv_guarantee_none dumindiv_guarantee_none nbindiv_guarantee_othe dumindiv_guarantee_othe nbindiv_borrservices_free dumindiv_borrservices_free nbindiv_borrservices_work dumindiv_borrservices_work nbindiv_borrservices_supp dumindiv_borrservices_supp nbindiv_borrservices_none dumindiv_borrservices_none nbindiv_borrservices_othe dumindiv_borrservices_othe nbindiv_plantorep_chit dumindiv_plantorep_chit nbindiv_plantorep_work dumindiv_plantorep_work nbindiv_plantorep_migr dumindiv_plantorep_migr nbindiv_plantorep_asse dumindiv_plantorep_asse nbindiv_plantorep_inco dumindiv_plantorep_inco nbindiv_plantorep_borr dumindiv_plantorep_borr nbindiv_plantorep_othe dumindiv_plantorep_othe nbindiv_settlestrat_inco dumindiv_settlestrat_inco nbindiv_settlestrat_sche dumindiv_settlestrat_sche nbindiv_settlestrat_borr dumindiv_settlestrat_borr nbindiv_settlestrat_sell dumindiv_settlestrat_sell nbindiv_settlestrat_land dumindiv_settlestrat_land nbindiv_settlestrat_cons dumindiv_settlestrat_cons nbindiv_settlestrat_addi dumindiv_settlestrat_addi nbindiv_settlestrat_work dumindiv_settlestrat_work nbindiv_settlestrat_supp dumindiv_settlestrat_supp nbindiv_settlestrat_harv dumindiv_settlestrat_harv nbindiv_settlestrat_othe dumindiv_settlestrat_othe nbindiv_prodpledge_gold dumindiv_prodpledge_gold nbindiv_prodpledge_land dumindiv_prodpledge_land nbindiv_prodpledge_car dumindiv_prodpledge_car nbindiv_prodpledge_bike dumindiv_prodpledge_bike nbindiv_prodpledge_frid dumindiv_prodpledge_frid nbindiv_prodpledge_furn dumindiv_prodpledge_furn nbindiv_prodpledge_tail dumindiv_prodpledge_tail nbindiv_prodpledge_cell dumindiv_prodpledge_cell nbindiv_prodpledge_line dumindiv_prodpledge_line nbindiv_prodpledge_dvd dumindiv_prodpledge_dvd nbindiv_prodpledge_came dumindiv_prodpledge_came nbindiv_prodpledge_gas dumindiv_prodpledge_gas nbindiv_prodpledge_comp dumindiv_prodpledge_comp nbindiv_prodpledge_dish dumindiv_prodpledge_dish nbindiv_prodpledge_none dumindiv_prodpledge_none nbindiv_prodpledge_othe dumindiv_prodpledge_othe

* PTCS
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-PTCS", keepusing(cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit raven_tt num_tt lit_tt)
drop _merge


* Transferts
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-transferts_indiv"
drop _merge

* Gold
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-gold", keepusing(goldquantity2 goldquantitypledge2 goldamountpledge2 corr dummygold)
drop _merge



********** Household characteristics

* Family compo
merge m:1 HHID2020 using "raw/NEEMSIS2-family"
drop _merge

* Assets and expenses
merge m:1 HHID2020 using "raw/NEEMSIS2-assets"
drop _merge

* Income
merge m:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
drop _merge

* Remittances
merge m:1 HHID2020 using "raw/NEEMSIS2-transferts_HH"
drop _merge pension_HH transferts_HH

* Gold
merge m:1 HHID2020 using "raw/NEEMSIS2-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

* Demonetisation
merge m:1 HHID2020 using "raw\NEEMSIS2-covid"
drop _merge

********** Final

* Panel HH
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge


* Panel indiv
tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Rename
rename HHID2020 HHID
rename INDID2020 INDID
order HHID_panel INDID_panel

*Year
gen year=2020


save"temp_NEEMSIS2indiv", replace
****************************************
* END











****************************************
* Panel
****************************************
use"temp_NEEMSIS2indiv", clear

append using "temp_NEEMSIS1indiv"

* Selection
drop if livinghome==.
drop if livinghome==3
drop if livinghome==4
ta year
drop livinghome

*** Label
fre house
label define house 1"Own house" 2"Joint house" 3"Family property" 4"Rental" 77"Others", modify
label values house house
ta house year, m

*** No agri quest in 2020
/*
list HHID_panel year if house==., clean noobs
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020
*/


*** Dummy panel HH
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel_HH


*** Dummy panel indiv
bysort HHID_panel INDID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel_indiv
order HHID_panel HHID dummypanel_HH INDID_panel INDID dummypanel_indiv year  
sort HHID_panel INDID_panel year

*** Shock
recode dummydemonetisation (.=0)
recode dummymarriage (.=0)

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time



*** Quanti 
global quanti1 head_mocc_annualincome head_annualincome 
global quanti3 expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri expenses_marr
global quanti4 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000
global quanti5 incomeagri_HH incomenonagri_HH annualincome_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global quanti6 remreceived_HH remsent_HH remittnet_HH
global quanti7 annualincome_indiv incomeagri_indiv incomenonagri_indiv incagrise_indiv incagricasual_indiv incnonagricasual_indiv incnonagriregnonquali_indiv incnonagriregquali_indiv incnonagrise_indiv incnrega_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv totindiv_lenderamt_WKP totindiv_lenderamt_rela totindiv_lenderamt_empl totindiv_lenderamt_mais totindiv_lenderamt_coll totindiv_lenderamt_pawn totindiv_lenderamt_shop totindiv_lenderamt_fina totindiv_lenderamt_frie totindiv_lenderamt_SHG totindiv_lenderamt_bank totindiv_lenderamt_coop totindiv_lenderamt_suga totindiv_lenderamt_grou totindiv_lenderamt_than totindiv_lender4amt_WKP totindiv_lender4amt_rela totindiv_lender4amt_labo totindiv_lender4amt_pawn totindiv_lender4amt_shop totindiv_lender4amt_mone totindiv_lender4amt_frie totindiv_lender4amt_micr totindiv_lender4amt_bank totindiv_lender4amt_neig totindiv_lendercatamt_info totindiv_lendercatamt_semi totindiv_lendercatamt_form totindiv_givenamt_agri totindiv_givenamt_fami totindiv_givenamt_heal totindiv_givenamt_repa totindiv_givenamt_hous totindiv_givenamt_inve totindiv_givenamt_cere totindiv_givenamt_marr totindiv_givenamt_educ totindiv_givenamt_rela totindiv_givenamt_deat totindiv_givenamt_nore totindiv_givenamt_othe totindiv_givencatamt_econ totindiv_givencatamt_curr totindiv_givencatamt_huma totindiv_givencatamt_soci totindiv_givencatamt_hous totindiv_givencatamt_nore totindiv_givencatamt_othe totindiv_effectiveamt_agri totindiv_effectiveamt_fami totindiv_effectiveamt_heal totindiv_effectiveamt_repa totindiv_effectiveamt_hous totindiv_effectiveamt_inve totindiv_effectiveamt_cere totindiv_effectiveamt_marr totindiv_effectiveamt_educ totindiv_effectiveamt_rela totindiv_effectiveamt_deat totindiv_effectiveamt_nore totindiv_effectiveamt_othe remreceived_indiv remsent_indiv remittnet_indiv pension_indiv transferts_indiv
global quanti $quanti1 $quanti3 $quanti4 $quanti5 $quanti6 $quanti7


gen annualincome_indiv_backup=annualincome_indiv

*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}


*** Drop 2010
drop if year==2010


*** Clean
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)
recode head_nboccupation (.=0)


*** Caste 
merge m:1 HHID_panel year using "raw/JatisCastePanel"
rename jatisn jatis
rename casten caste
keep if _merge==3
drop _merge
ta caste


*** Debt from HH database
merge m:1 HHID_panel year using "panel_HH_v3", keepusing(dummyloans_HH dumHH_given_repa totHH_givenamt_repa gtdr dumHH_effective_repa totHH_effectiveamt_repa etdr shareform dsr isr dar dir dcr loanamount_HH nbloans_HH imp1_ds_tot_HH dailyuspppdincome_pc)
drop if _merge==2
drop if _merge==1
drop _merge


save"panel_indiv_v0", replace
****************************************
* END
