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
* 2010
****************************************
use"raw/RUME-HH", clear

* To keep
keep HHID2010 village villagearea foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses productexpenses1 productexpenses2 productexpenses3 productexpenses4 productexpenses5 goldquantity


* Clean
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


* Uniq HH
duplicates drop
count


* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_othlendserv_6 dumHH_othlendserv_6 nbHH_othlendserv_nrep dumHH_othlendserv_nrep nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_both dumHH_guarantee_both nbHH_guarantee_none dumHH_guarantee_none nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_othe dumHH_borrservices_othe nbHH_borrservices_nrep dumHH_borrservices_nrep nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_noth dumHH_plantorep_noth nbHH_plantorep_othe dumHH_plantorep_othe nbHH_plantorep_nrep dumHH_plantorep_nrep


* Add assets
merge 1:1 HHID2010 using "raw/RUME-assets"
drop _merge


* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH"
drop _merge


* Panel
merge 1:m HHID2010 using"raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2010


*Year
gen year=2010


* Annual expenses
foreach x in productexpenses1 productexpenses2 productexpenses3 productexpenses4 productexpenses5 foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses {
replace `x'=0 if `x'==.
}

gen annualexpenses1=52*foodexpenses+educationexpenses+healthexpenses+ceremoniesexpenses+deathexpenses

gen annualexpenses2=productexpenses1+productexpenses2+productexpenses3+productexpenses4+productexpenses5+52*foodexpenses+educationexpenses+healthexpenses+ceremoniesexpenses+deathexpenses
drop productexpenses1 productexpenses2 productexpenses3 productexpenses4 productexpenses5 foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses

* Gold
gen goldamount=goldquantity*2000
drop goldquantity

save"temp_RUME", replace
****************************************
* END











****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* To keep
keep HHID2016 villageid villagearea educationexpenses foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses productexpenses_paddy productexpenses_ragi productexpenses_millets productexpenses_tapioca productexpenses_cotton productexpenses_sugarca productexpenses_savukku productexpenses_guava productexpenses_groundnut goldquantity


* Clean
foreach x in goldquantity educationexpenses marriageexpenses {
bysort HHID2016: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}

decode villageid, gen(village)
drop villageid

decode villagearea, gen(vi)
drop villagearea
rename vi area


* Drop
duplicates drop
count


* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe


* Add assets
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets"
drop _merge


* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
drop _merge


* Panel
merge 1:m HHID2016 using"raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2016


* Year
gen year=2016


* Annual expenses
foreach x in productexpenses_paddy productexpenses_ragi productexpenses_millets productexpenses_tapioca productexpenses_cotton productexpenses_sugarca productexpenses_savukku productexpenses_guava productexpenses_groundnut foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses ceremoniesrelativesexpenses marriageexpenses {
replace `x'=0 if `x'==.
}

gen annualexpenses1=52*foodexpenses+educationexpenses+healthexpenses+ceremoniesexpenses+deathexpenses+ceremoniesrelativesexpenses+marriageexpenses

gen annualexpenses2=productexpenses_paddy+productexpenses_ragi+productexpenses_millets+productexpenses_tapioca+productexpenses_cotton+productexpenses_sugarca+productexpenses_savukku+productexpenses_guava+productexpenses_groundnut+52*foodexpenses+educationexpenses+healthexpenses+ceremoniesexpenses+deathexpenses+ceremoniesrelativesexpenses+marriageexpenses
drop productexpenses_paddy productexpenses_ragi productexpenses_millets productexpenses_tapioca productexpenses_cotton productexpenses_sugarca productexpenses_savukku productexpenses_guava productexpenses_groundnut foodexpenses educationexpenses healthexpenses ceremoniesexpenses deathexpenses ceremoniesrelativesexpenses marriageexpenses

* Gold
gen goldamount=goldquantity*2700
drop goldquantity



save"temp_NEEMSIS1", replace
****************************************
* END








****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* Clean
keep HHID2020 villageid villagearea educationexpenses productexpenses_paddy productexpenses_cotton productexpenses_sugarcane productexpenses_savukku productexpenses_guava productexpenses_groundnut productexpenses_millets productexpenses_cashew productexpenses_other foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses marriageexpenses goldquantity


* Clean
foreach x in goldquantity educationexpenses marriageexpenses {
bysort HHID2020: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}

decode villageid, gen(village)
drop villageid

decode villagearea, gen(vi)
drop villagearea
rename vi area


* Drop
duplicates drop
count


* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_silv dumHH_prodpledge_silv nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe


* Add assets
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets"
drop _merge


* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
drop _merge

* Panel
merge 1:m HHID2020 using"raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2020


* Year
gen year=2020


* Annual expenses
foreach x in productexpenses_paddy productexpenses_cotton productexpenses_sugarcane productexpenses_savukku productexpenses_guava productexpenses_groundnut productexpenses_millets productexpenses_cashew productexpenses_other foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses educationexpenses marriageexpenses {
replace `x'=0 if `x'==.
}

gen annualexpenses1=52*foodexpenses+educationexpenses+healthexpenses+ceremoniesexpenses+deathexpenses+ceremoniesrelativesexpenses+marriageexpenses

gen annualexpenses2=productexpenses_paddy+productexpenses_cotton+productexpenses_sugarcane+productexpenses_savukku+productexpenses_guava+productexpenses_groundnut+productexpenses_millets+productexpenses_cashew+productexpenses_other+52*foodexpenses+educationexpenses+healthexpenses+ceremoniesexpenses+deathexpenses+ceremoniesrelativesexpenses+marriageexpenses
drop productexpenses_paddy productexpenses_cotton productexpenses_sugarcane productexpenses_savukku productexpenses_guava productexpenses_groundnut productexpenses_millets productexpenses_cashew productexpenses_other foodexpenses healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses educationexpenses marriageexpenses


* Gold
gen goldamount=goldquantity*2700
drop goldquantity


save"temp_NEEMSIS2", replace
****************************************
* END













****************************************
* Panel and construction
****************************************
use"temp_NEEMSIS2", clear

append using "temp_NEEMSIS1"
append using "temp_RUME"

*** Deflate and round
foreach x in loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_lenderamt_WKP totHH_lenderamt_rela totHH_lenderamt_empl totHH_lenderamt_mais totHH_lenderamt_coll totHH_lenderamt_pawn totHH_lenderamt_shop totHH_lenderamt_fina totHH_lenderamt_frie totHH_lenderamt_SHG totHH_lenderamt_bank totHH_lenderamt_coop totHH_lenderamt_suga totHH_lenderamt_grou totHH_lenderamt_than totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givenamt_nore totHH_givenamt_othe totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_givencatamt_nore totHH_givencatamt_othe totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat totHH_effectiveamt_nore totHH_effectiveamt_othe assets assets_noland assets_noprop assets1000 assets1000_noland assets1000_noprop incomeagri_HH incomenonagri_HH annualincome_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
replace `x'=round(`x',1)
}

*** Construction v1
* DSR
tabstat imp1_ds_tot_HH annualincome_HH, stat(min p1 p5 p10 q p90 p95 p99 max)
gen dsr=imp1_ds_tot_HH*100/annualincome_HH
replace dsr=0 if dsr==.
tabstat dsr, stat(n mean cv q p90 p95 p99 max)
ta year if dsr>200
ta year if dsr>300
ta year if dsr>400
/*
stripplot dsr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
replace dsr=400 if dsr>400


* ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.
tabstat isr, stat(n mean cv q p90 p95 p99 max)
ta year if isr>150
ta year if isr>200
/*
stripplot isr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
replace isr=200 if isr>200  // 0.2%, 1.2%, 2.4%


* DAR
gen dar=loanamount_HH*100/assets
replace dar=0 if dar==.
tabstat dar, stat(n mean cv q p90 p95 p99 max)
ta year if dar>200
ta year if dar>300
ta year if dar>400
/*
stripplot dar, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
replace dar=300 if dar>300  // 0.2%, 3.5%, 0.3%


* DIR
gen dir=loanamount_HH*100/annualincome_HH
replace dir=0 if dir==.
tabstat dir, stat(n mean cv q p90 p95 p99 max)
ta year if dir>600
ta year if dir>1400
/*
stripplot dir, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
replace dir=1400 if dir>1400  // 0.2%, 3.9%, 4.6%



*TDR
gen tdr=totHH_givenamt_repa*100/loanamount_HH
replace tdr=0 if tdr==.
tabstat tdr, stat(n mean cv q p90 p95 p99 max)
/*
stripplot tdr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/


*TAR
gen tar=totHH_givenamt_repa*100/assets
replace tar=0 if tar==.
tabstat tar, stat(n mean cv q p90 p95 p99 max)
/*
stripplot tar, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/


***** Clean
foreach x in loanamount_HH annualincome_HH assets imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar dir tdr tar {
egen `x'_std=std(`x')
gen `x'_cr=`x'^(1/3)
}



*** Order
order HHID_panel year
sort HHID_panel year


save"panel_HH", replace
****************************************
* END
