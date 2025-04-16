*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "intraHHineq"
*Prepa HH
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\intraHHineq.do"
*-------------------------





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* To keep
keep HHID2010 village villagearea ownland house housetitle
fre house housetitle
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
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

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
merge 1:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
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
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle
fre house housetitle
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
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets"
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
drop _merge

* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH"
drop _merge transferts_HH

* Gold
merge 1:1 HHID2016 using "raw/NEEMSIS1-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

* Panel
merge 1:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
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
fre house
preserve
keep if house==""
ta dummyeverland2010
ta dummyeverhadland
restore

* To keep
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle compensation compensationamount
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
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH)
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets"
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
drop _merge

* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH"
drop _merge transferts_HH

* Add gold
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH"
drop _merge
drop goldamount_HH goldamountpledge_HH

* Add covid
merge 1:1 HHID2020 using "raw/NEEMSIS2-covid", keepusing(secondlockdownexposure dummysell dummyexposure)
drop _merge

* Panel
merge 1:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2020 HHID

* GPS
merge 1:1 HHID_panel using "raw/NEEMSIS2-GPS", keepusing(jatisdetails jatis)
keep if _merge==3
drop _merge

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

* Append
append using "temp_NEEMSIS1"
append using "temp_RUME"

*
drop if HHID_panel=="KUV65"

* Housing pour selection
fre house
label define house 1"Own house" 2"Joint house" 3"Family property" 4"Rental" 77"Others", modify
label values house house
ta house year, m
list HHID_panel year if house==., clean noobs
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020
fre housetitle
label values housetitle housetitle
ta housetitle year, m

* Dummy panel
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel HHID year dummypanel
sort HHID_panel year

* Shock
recode dummydemonetisation (.=0)
recode dummymarriage (.=0)

* Quanti defalte and round
global quanti1 head_mocc_annualincome head_annualincome 
global quanti2 loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH
global quanti3 expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri expenses_marr
global quanti4 assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 annualincome_HH
global quanti5 remreceived_HH remsent_HH remittnet_HH pension_HH
global quanti6 goldreadyamount incomeagri_HH incomenonagri_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global quanti $quanti1 $quanti2 $quanti3 $quanti4 $quanti5 $quanti6

foreach x in $quanti {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}

* Recode and replace
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)
recode head_nboccupation (.=0)
replace loanamount_HH=0 if loanamount_HH==.


* Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n


save"panel_v0", replace
****************************************
* END



















****************************************
* Construction variables
****************************************
use"panel_v0", clear

drop compensation compensationamount dummymarriage housetitle area livingarea equiscale_HHsize equimodiscale_HHsize squareroot_HHsize head_INDID2020 head_egoid head_relationshiptohead head_dummyhead head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome pop_workingage pop_dependents dependencyratio dummyheadfemale head_widowseparated dummyoneadult sexratio expenses_educ expenses_marr expenses_total expenses_food expenses_heal expenses_cere expenses_agri shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere assets_sizeownland assets_housevalue assets_livestock assets_goods assets_gold assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 shareassets_housevalue shareassets_livestock shareassets_goods shareassets_ownland shareassets_gold incomeagri_HH incomenonagri_HH incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH shareincagrise_HH shareincagricasual_HH shareincnonagricasual_HH shareincnonagriregnonquali_HH shareincnonagriregquali_HH shareincnonagrise_HH shareincnrega_HH hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH sharehoursayearagri_HH sharehoursayearnonagri_HH nbworker_HH nbnonworker_HH nonworkersratio remreceived_HH remsent_HH remittnet_HH pension_HH goldquantity_HH goldquantitypledge_HH dummyexposure secondlockdownexposure dummysell jatisdetails jatis goldreadyamount dummydemonetisation head_INDID2016 relation_brotherelder relation_brotheryounger head_INDID2010 relation_head relation_wife relation_mother relation_father relation_son relation_daughter relation_soninlaw relation_daughterinlaw relation_sister relation_brother relation_motherinlaw relation_fatherinlaw relation_grandchildren relation_grandfather relation_grandmother relation_cousin relation_other

*
* Merge caste and jatis
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis
order HHID_panel year jatis caste


*** Drop
drop age_group agegrp_0_13 agegrp_14_17 agegrp_18_24 agegrp_25_29 agegrp_30_34 agegrp_35_39 agegrp_40_49 agegrp_50_59 agegrp_60_69 agegrp_70_79 agegrp_80_100 male_agegrp_0_13 female_agegrp_0_13 male_agegrp_14_17 female_agegrp_14_17 male_agegrp_18_24 female_agegrp_18_24 male_agegrp_25_29 female_agegrp_25_29 male_agegrp_30_34 female_agegrp_30_34 male_agegrp_35_39 female_agegrp_35_39 male_agegrp_40_49 female_agegrp_40_49 male_agegrp_50_59 female_agegrp_50_59 male_agegrp_60_69 female_agegrp_60_69 male_agegrp_70_79 female_agegrp_70_79 male_agegrp_80_100 female_agegrp_80_100

drop nbgeneration1 nbgeneration2 nbgeneration3 nbgeneration4 nbgeneration5 dummygeneration1 dummygeneration2 dummygeneration3 dummygeneration4 dummygeneration5


*** DSR ISR DAR
gen dsr=imp1_ds_tot_HH/annualincome_HH
tabstat dsr, stat(n mean) by(year)

gen isr=imp1_is_tot_HH/annualincome_HH
tabstat isr, stat(n mean) by(year)

gen dar=loanamount_HH/assets_total
tabstat dar, stat(n mean) by(year)

save"panel_v1", replace
****************************************
* END













/*
****************************************
* Construction 3
****************************************

gen intratodrop=0
replace intratodrop=1 if annualincome_HH==1
drop if intratodrop==1
drop intratodrop


********** Part moyenne d'un homme et part moyenne d'une femme
/*
*
gen mshare_men=((suminc_men/wp_occupied_men_HH)/annualincome_HH)*100
gen mshare_women=((suminc_women/wp_occupied_women_HH)/annualincome_HH)*100
gen diff_mshare=mshare_men-mshare_women
gen absdiff_mshare=abs(diff_mshare)

* Groupes 1
gen grpHH=.
replace grpHH=1 if wp_occupied_women_HH==0
replace grpHH=2 if wp_occupied_men_HH==0
replace grpHH=3 if diff_mshare!=. & diff_mshare<-5
replace grpHH=4 if diff_mshare!=. & diff_mshare>=-5  & diff_mshare<=5
replace grpHH=5 if diff_mshare!=. & diff_mshare>5
label define grpHH 1"No women income" 2"No men income" 3"(c) Women > Men" 4"(b) Men = Women" 5"(a) Men > Women"
label values grpHH grpHH

* Group 2
gen grpHH2=.
replace grpHH2=1 if grpHH==3
replace grpHH2=2 if grpHH==4
replace grpHH2=3 if grpHH==5
label define grpHH2 1"(c) Women > Men" 2"(b) Men = Women" 3"(a) Men > Women"
label values grpHH2 grpHH2

* Group 3
gen grpHH3=.
replace grpHH3=1 if grpHH==1
replace grpHH3=2 if grpHH==2
replace grpHH3=3 if grpHH>=3
label define grpHH3 1"No women income" 2"No men income" 3"Income for both"
label values grpHH3 grpHH3
*/


********** Ecart entre le revenu moyen d'un homme et le revenu moyen d'une femme
*
gen av_men=suminc_men/wp_occupied_men_HH
gen av_women=suminc_women/wp_occupied_women_HH
gen diffav=av_men-av_women
gen absdiffav=abs(diffav)
tabstat av_men av_women absdiffav, stat(min p1 p5 p10 q p90 p95 p99 max)
*
gen monthlyincome=head_annualincome/12
tabstat monthlyincome, stat(n mean sd median) by(year)
drop monthlyincome
*

* Groupes 1
gen alt_grpHH=.
replace alt_grpHH=1 if wp_occupied_women_HH==0
replace alt_grpHH=2 if wp_occupied_men_HH==0
replace alt_grpHH=3 if diffav!=. & diffav<-730
replace alt_grpHH=4 if diffav!=. & diffav>=-730  & diffav<=730
replace alt_grpHH=5 if diffav!=. & diffav>730
label define alt_grpHH 1"No women income" 2"No men income" 3"(c) Women > Men" 4"(b) Men = Women" 5"(a) Men > Women"
label values alt_grpHH alt_grpHH

* Group 2
gen alt_grpHH2=.
replace alt_grpHH2=1 if alt_grpHH==3
replace alt_grpHH2=2 if alt_grpHH==4
replace alt_grpHH2=3 if alt_grpHH==5
label define alt_grpHH2 1"(c) Women > Men" 2"(b) Men = Women" 3"(a) Men > Women"
label values alt_grpHH2 alt_grpHH2

* Group 3
gen alt_grpHH3=.
replace alt_grpHH3=1 if alt_grpHH==1
replace alt_grpHH3=2 if alt_grpHH==2
replace alt_grpHH3=3 if alt_grpHH>=3
label define alt_grpHH3 1"No women income" 2"No men income" 3"Income for both"
label values alt_grpHH3 alt_grpHH3
*/

