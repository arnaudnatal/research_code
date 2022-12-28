*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------








****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* To keep
keep HHID2010 village villagearea
gen livingarea=1

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
gen villageid=village

* Uniq HH
duplicates drop
count

* Family compo
merge 1:1 HHID2010 using "raw/RUME-family"
drop _merge

* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_othlendserv_6 dumHH_othlendserv_6 nbHH_othlendserv_nrep dumHH_othlendserv_nrep nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_both dumHH_guarantee_both nbHH_guarantee_none dumHH_guarantee_none nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_othe dumHH_borrservices_othe nbHH_borrservices_nrep dumHH_borrservices_nrep nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_noth dumHH_plantorep_noth nbHH_plantorep_othe dumHH_plantorep_othe nbHH_plantorep_nrep dumHH_plantorep_nrep


* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets"
drop _merge


* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH"
drop _merge


* Add remittances
merge 1:1 HHID2010 using "raw/RUME-transferts_HH"
drop _merge


* Gold
merge 1:1 HHID2010 using "raw/RUME-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

* Panel
merge 1:m HHID2010 using"raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2010 HHID

*Year
gen year=2010
ta village livingarea


* Gold not pledge
gen test=assets_gold-(goldquantity_HH*2000)
ta test
drop test
gen goldreadyamount=(goldquantity_HH-goldquantitypledge_HH)*2000
tabstat assets_gold goldreadyamount, stat(n mean cv q)


save"temp_RUME", replace
****************************************
* END











****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4


* To keep
keep HHID2016 villagearea villageid
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid

* Livingarea
merge 1:1 HHID2016 using "raw/NEEMSIS1-villages", keepusing(villagename2016 livingarea)
drop _merge
rename villagename2016 village
ta village livingarea

* Drop
duplicates drop
count


* Family compo
merge 1:1 HHID2016 using "raw/NEEMSIS1-family"
drop _merge


* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe


* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets"
drop _merge


* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
drop _merge


* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH"
drop _merge pension_HH transferts_HH

* Gold
merge 1:1 HHID2016 using "raw/NEEMSIS1-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH


* Panel
merge 1:m HHID2016 using"raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2016 HHID


* Year
gen year=2016

* Gold not pledge
gen test=assets_gold-(goldquantity_HH*2700)
ta test
drop test
gen goldreadyamount=(goldquantity_HH-goldquantitypledge_HH)*2700
tabstat assets_gold goldreadyamount, stat(n mean cv q)


save"temp_NEEMSIS1", replace
****************************************
* END











****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1


* To keep
keep HHID2020 villagearea villageid
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid


* Livingarea
merge 1:1 HHID2020 using "raw/NEEMSIS2-villages",keepusing(village_new livingarea)
drop _merge
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
ta village livingarea


* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2020 using "raw/NEEMSIS2-family"
drop _merge


* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH"
drop _merge
drop nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_silv dumHH_prodpledge_silv nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe


* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets"
drop _merge


* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
drop _merge


* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH"
drop _merge pension_HH transferts_HH

* Add gold
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH



* Panel
merge 1:m HHID2020 using"raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2020 HHID

* Year
gen year=2020

* Gold not pledge
gen test=assets_gold-(goldquantity_HH*2700)
ta test
drop test
gen goldreadyamount=(goldquantity_HH-goldquantitypledge_HH)*2700
tabstat assets_gold goldreadyamount, stat(n mean cv q)



save"temp_NEEMSIS2", replace
****************************************
* END











****************************************
* Panel
****************************************
use"temp_NEEMSIS2", clear

append using "temp_NEEMSIS1"
append using "temp_RUME"

fre typeoffamily

ta livingarea year

* Dummy panel
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel HHID year dummypanel
sort HHID_panel year


* Caste
tostring year, replace
merge 1:1 HHID_panel year using "raw/ODRIIS-HH_long", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr caste
destring year, replace
ta caste
encode caste, gen(castecode)
drop caste
rename castecode caste
fre caste


*** Quanti 
global quanti1 head_mocc_annualincome head_annualincome 
global quanti2 loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_lenderamt_WKP totHH_lenderamt_rela totHH_lenderamt_empl totHH_lenderamt_mais totHH_lenderamt_coll totHH_lenderamt_pawn totHH_lenderamt_shop totHH_lenderamt_fina totHH_lenderamt_frie totHH_lenderamt_SHG totHH_lenderamt_bank totHH_lenderamt_coop totHH_lenderamt_suga totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat totHH_lenderamt_grou totHH_lenderamt_than totHH_givenamt_nore totHH_givenamt_othe totHH_givencatamt_nore totHH_givencatamt_othe totHH_effectiveamt_nore totHH_effectiveamt_othe
global quanti3 expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri expenses_marr
global quanti4 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000
global quanti5 incomeagri_HH incomenonagri_HH annualincome_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global quanti6 remreceived_HH remsent_HH remittnet_HH
global quant7 goldreadyamount
global quanti $quanti1 $quanti2 $quanti3 $quanti4 $quanti5 $quanti6 $quanti7



*** Deflate and round
foreach x in $quanti {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
replace `x'=round(`x',1)
}

count if loanamount_HH==.
count if totHH_givenamt_repa==.


*** Clean
/*
foreach x in $quanti1 $quanti3 $quanti4 $quanti5 $quanti6  {
recode `x' (.=0)
}
*/


save"panel_v0", replace
****************************************
* END















****************************************
* Construction: debt
****************************************
use"panel_v0", clear

* DSR
tabstat imp1_ds_tot_HH annualincome_HH, stat(min p1 p5 p10 q p90 p95 p99 max)
gen dsr=imp1_ds_tot_HH*100/annualincome_HH
replace dsr=0 if dsr==.
tabstat dsr, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if dsr>200
ta year if dsr>300
ta year if dsr>400
/*
stripplot dsr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
*replace dsr=400 if dsr>400


* ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.
tabstat isr, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if isr>150
ta year if isr>200
/*
stripplot isr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
*replace isr=200 if isr>200  // 0.2%, 1.2%, 2.4%


* DAR
gen dar=loanamount_HH*100/assets_total
replace dar=0 if dar==.
tabstat dar, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if dar>200
ta year if dar>300
ta year if dar>400
/*
stripplot dar, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
*replace dar=300 if dar>300  // 0.2%, 3.5%, 0.3%


* DIR
gen dir=loanamount_HH*100/annualincome_HH
replace dir=0 if dir==.
tabstat dir, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if dir>600
ta year if dir>1400
/*
stripplot dir, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30)
*/
*replace dir=1400 if dir>1400  // 0.2%, 3.9%, 4.6%



* TDR
gen tdr=totHH_givenamt_repa*100/loanamount_HH
replace tdr=0 if tdr==.
tabstat tdr, stat(n mean cv q p90 p95 p99 max) by(year)
tabstat tdr if totHH_givenamt_repa!=0, stat(n mean cv q p90 p95 p99 max) by(year)
/*
stripplot tdr, over(year) vert refline ///
stack width(1) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30)

stripplot tdr if totHH_givenamt_repa!=0, over(year) vert refline ///
stack width(1) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30)
*/


* TAR
gen tar=totHH_givenamt_repa*100/assets_total
replace tar=0 if tar==.
tabstat tar, stat(n mean cv q p90 p95 p99 max) by(year)
/*
stripplot tar, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/


* AFM - Absolut Financial Margin
gen temp=1 if imp1_ds_tot_HH==.
recode imp1_ds_tot_HH (.=0)
gen afm=annualincome_HH+remittnet_HH+goldreadyamount-imp1_ds_tot_HH-expenses_total
*gen fm=annualincome_HH+remittnet_HH+assets_gold-imp1_ds_tot_HH-expenses_educ-expenses_food-expenses_heal
replace imp1_ds_tot_HH=. if temp==1
drop temp

gen dummyafmpos=0
replace dummyafmpos=1 if afm>0
ta dummyafmpos year, col
ta dummyafmpos caste if year==2010, row nofreq
ta dummyafmpos caste if year==2016, row nofreq
ta dummyafmpos caste if year==2020, row nofreq


* RFM - Relative Financial Margin
gen rfm=afm/annualincome_HH
ta rfm



/*
stripplot fm2, over(dummyfm) vert ///
stack width(5000) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/

save"panel_v1", replace
****************************************
* END

















****************************************
* Construction: poverty
****************************************
use"panel_v1", clear


* HH income per capita
gen dailyincome1_pc=(annualincome_HH/365)/HHsize
gen dailyincome2_pc=(annualincome_HH/365)/equiscale_HHsize
gen dailyincome3_pc=(annualincome_HH/365)/equimodiscale_HHsize
gen dailyincome4_pc=(annualincome_HH/365)/squareroot_HHsize

* USD in 2010: 1 USD = 45.73 INR
gen dailyusdincome1_pc=dailyincome1_pc/45.73
gen dailyusdincome2_pc=dailyincome2_pc/45.73
gen dailyusdincome3_pc=dailyincome3_pc/45.73
gen dailyusdincome4_pc=dailyincome4_pc/45.73

* PL net
gen dailyplincome1_pc=dailyusdincome1_pc-1.9
gen dailyplincome2_pc=dailyusdincome2_pc-1.9
gen dailyplincome3_pc=dailyusdincome3_pc-1.9
gen dailyplincome4_pc=dailyusdincome4_pc-1.9

* PL dummy
gen apl1=0 if dailyplincome1_pc<0
gen apl2=0 if dailyplincome2_pc<0
gen apl3=0 if dailyplincome3_pc<0
gen apl4=0 if dailyplincome4_pc<0

recode apl1 apl2 apl3 apl4 (.=1)


ta apl4 
ta dummyafmpos apl4


* Financial distress
egen fd=group(apl4 dummyafmpos), label
fre fd
recode fd (2=1) (3=1) (4=0)
label define fd 0"Non-poor" 1"Distress", replace
label values fd fd

ta fd year, col nofreq

ta fd caste, col nofreq
ta fd caste if year==2010, col nofreq
ta fd caste if year==2016, col nofreq
ta fd caste if year==2020, col nofreq


save"panel_v2", replace
****************************************
* END








****************************************
* Construction: clean
****************************************
use"panel_v2", clear

tabstat dsr isr dar dir tdr tar rfm, stat(n mean cv min p1 p5 p10 q p90 p95 p99 max)

count if dsr>430
count if isr>190
count if dar>420
count if dir>2800
count if tar>39
count if rfm>7 | rfm<-10

replace dsr=430 if dsr>430
replace isr=190 if isr>190
replace dar=420 if dar>420
replace dir=2800 if dir>2800
replace tar=39 if tar>39
replace rfm=7 if rfm>7
replace rfm=-10 if rfm<-10

tabstat dsr isr dar dir tdr tar rfm, stat(n mean cv min p1 p5 p10 q p90 p95 p99 max)


foreach x in loanamount_HH annualincome_HH assets_total imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar dir tdr tar afm rfm expenses_total remreceived_HH remsent_HH remittnet_HH dailyincome4_pc assets_gold goldquantity_HH {
egen `x'_std=std(`x')
gen `x'_cr=`x'^(1/3)
}



*** Order
order HHID_panel year
sort HHID_panel year

save"panel_v3", replace
****************************************
* END
