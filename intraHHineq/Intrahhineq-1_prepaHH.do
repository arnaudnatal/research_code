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

save"panel_v1", replace
****************************************
* END














****************************************
* Inequalities
****************************************


********** RUME
use"raw\RUME-HH.dta", clear

* Selection
keep HHID2010 INDID2010 name sex age relationshiptohead

* Merge income
merge m:1 HHID2010 using "raw\RUME-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2010, replace
merge 1:m HHID2010 INDID2010 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2010 INDID2010

gen year=2010
order HHID_panel INDID_panel year

save"temp1",replace






********** NEEMSIS-1
use"raw\NEEMSIS1-HH.dta", clear

* Selection
ta livinghome egoid
drop if livinghome>=3
keep HHID2016 INDID2016 name sex age relationshiptohead

* Merge income
merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2016 INDID2016

gen year=2016
order HHID_panel INDID_panel year

save"temp2",replace







********** NEEMSIS-2
use"raw\NEEMSIS2-HH.dta", clear

* Selection
ta livinghome egoid
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
keep HHID2020 INDID2020 name sex age relationshiptohead

* Merge income
merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

* Panel
merge m:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using"raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge HHID2020 INDID2020

gen year=2020
order HHID_panel INDID_panel year

save"temp3",replace






********** Append
use"temp1", clear

append using "temp2"
append using "temp3"


* Quanti defalte and round
foreach x in annualincome_HH mainocc_annualincome_indiv annualincome_indiv {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}

save"tempineqindiv", replace
****************************************
* END

















****************************************
* Construction inequalities
****************************************
use"tempineqindiv", clear

* Share income by sex
gen monthlyincome_indiv=annualincome_indiv/12
gen monthlyincome_HH=annualincome_HH/12
gen inc_men=monthlyincome_indiv  if sex==1
gen inc_women=monthlyincome_indiv if sex==2
bysort HHID_panel year: egen suminc_men=sum(inc_men)
bysort HHID_panel year: egen suminc_women=sum(inc_women)
gen test=monthlyincome_HH-suminc_men-suminc_women

* Working pop
fre working_pop
replace working_pop=2 if working_pop==1 & age>35 & (annualincome_indiv==. | annualincome_indiv==0)
replace working_pop=3 if working_pop==1 & age>35 & annualincome_indiv!=. & annualincome_indiv!=0

* Inactive
gen wp_inactive=0
replace wp_inactive=1 if working_pop==1

gen wp_inactive_men=0
replace wp_inactive_men=1 if working_pop==1 & sex==1
gen wp_inactive_women=0
replace wp_inactive_women=1 if working_pop==1 & sex==2

* Unoccupied
gen wp_unoccupi=0
replace wp_unoccupi=1 if working_pop==2

gen wp_unoccupi_men=0
replace wp_unoccupi_men=1 if working_pop==2 & sex==1
gen wp_unoccupi_women=0
replace wp_unoccupi_women=1 if working_pop==2 & sex==2

* Occupied
gen wp_occupied=0
replace wp_occupied=1 if working_pop==3

gen wp_occupied_men=0
replace wp_occupied_men=1 if working_pop==3 & sex==1
gen wp_occupied_women=0
replace wp_occupied_women=1 if working_pop==3 & sex==2

* Total by households
foreach x in inactive inactive_men inactive_women unoccupi unoccupi_men unoccupi_women occupied occupied_men occupied_women {
bysort HHID_panel year: egen wp_`x'_HH=sum(wp_`x')
}
gen wp_active_HH=wp_unoccupi_HH+wp_occupied_HH

gen wp_active_men_HH=wp_unoccupi_men_HH+wp_occupied_men_HH
gen wp_active_women_HH=wp_unoccupi_women_HH+wp_occupied_women_HH

* Save indiv
save "tempineqindiv_v2", replace

* Save HH
keep HHID_panel year suminc_men suminc_women wp_inactive_HH wp_inactive_men_HH wp_inactive_women_HH wp_unoccupi_HH wp_unoccupi_men_HH wp_unoccupi_women_HH wp_occupied_HH wp_occupied_men_HH wp_occupied_women_HH wp_active_HH wp_active_men_HH wp_active_women_HH
duplicates drop
compress
save "tempineqHH", replace


* Merge
use"panel_v2", clear

merge 1:1 HHID_panel year using "tempineqHH"
keep if _merge==3
drop _merge

order HHID_panel HHID panelvar year time dummypanel

save "panel_v3", replace
****************************************
* END


















****************************************
* Construction 2
****************************************
use"panel_v3", clear

* Regular
gen incnonagrireg_HH=incnonagriregnonquali_HH+incnonagriregquali_HH
order incnonagrireg_HH, after(incnrega_HH)

* Annual income 2 = SUM of income to have exact tot (sinon décalage arrondi)
gen annualincome_HH2=incagrise_HH+incagricasual_HH+incnonagricasual_HH+incnonagrireg_HH+incnonagrise_HH+incnrega_HH
order annualincome_HH2, after(annualincome_HH)
tabstat annualincome_HH annualincome_HH2, stat(n mean)

* Annual income 3 = labour + pensions + remittances
gen annualincome_HH3=annualincome_HH2+pension_HH+remreceived_HH
foreach x in incagrise_HH incagricasual_HH incnonagricasual_HH incnonagrireg_HH incnonagrise_HH incnrega_HH pension_HH remreceived_HH {
gen share3_`x'=`x'*100/annualincome_HH3
}

* Monthly income
gen monthlyincome_HH=annualincome_HH3/12

* Per capita
foreach x in ///
annualincome_HH2 annualincome_HH3 ///
incomeagri_HH incomenonagri_HH /// 
incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH incnonagrireg_HH monthlyincome_HH ///
pension_HH remreceived_HH {
gen `x'_pc=`x'/HHsize
}
rename annualincome_HH2_pc annualincome_pc
rename annualincome_HH3_pc annualincome3_pc
rename incomeagri_HH_pc incomeagri_pc
rename incomenonagri_HH_pc incomenonagri_pc
rename incagrise_HH_pc incagrise_pc
rename incagricasual_HH_pc incagricasual_pc
rename incnonagricasual_HH_pc incnonagricasual_pc
rename incnonagriregnonquali_HH_pc incnonagriregnonquali_pc
rename incnonagriregquali_HH_pc incnonagriregquali_pc
rename incnonagrise_HH_pc incnonagrise_pc
rename incnrega_HH_pc incnrega_pc
rename incnonagrireg_HH_pc incnonagrireg_pc
rename monthlyincome_HH_pc monthlyincome_pc
rename remreceived_HH_pc remreceived_pc
rename pension_HH_pc pension_pc

gen test=annualincome_pc-incagrise_pc-incagricasual_pc-incnonagricasual_pc-incnonagrireg_pc-incnonagrise_pc-incnrega_pc
ta test
drop test

gen test=annualincome3_pc-incagrise_pc-incagricasual_pc-incnonagricasual_pc-incnonagrireg_pc-incnonagrise_pc-incnrega_pc-pension_pc-remreceived_pc
ta test
drop test

* 1000
replace monthlyincome_pc=monthlyincome_pc/1000

* Worker ratio
drop nbworker_HH nbnonworker_HH nonworkersratio mean_nonworkersratio
gen nonworkersratio=wp_unoccupi_HH/wp_occupied_HH
replace nonworkersratio=wp_unoccupi_HH if nonworkersratio==.
bysort HHID_panel: egen mean_nonworkersratio=mean(nonworkersratio)
label var nonworkersratio "Non-workers ratio"

* Dummies occupation
global inc incagrise_HH incagricasual_HH incnonagricasual_HH incnonagrireg_HH incnonagrise_HH incnrega_HH pension_HH remreceived_HH
foreach x in $inc {
gen d_`x'=0
}
foreach x in $inc {
replace d_`x'=1 if `x'!=0 & `x'!=.
}
rename d_incagrise_HH d_agrise
rename d_incagricasual_HH d_agricasual
rename d_incnonagricasual_HH d_nonagricasual
rename d_incnonagrireg_HH d_nonagrireg
rename d_incnonagrise_HH d_nonagrise
rename d_incnrega_HH d_nrega

* Share
drop shareincomeagri_HH shareincomenonagri_HH shareincagrise_HH shareincagricasual_HH shareincnonagricasual_HH shareincnonagriregnonquali_HH shareincnonagriregquali_HH shareincnonagrise_HH shareincnrega_HH
gen s_agrise_HH=incagrise_HH/annualincome_HH3
gen s_agrica_HH=incagricasual_HH/annualincome_HH3
gen s_casual_HH=incnonagricasual_HH/annualincome_HH3
gen s_regula_HH=incnonagrireg_HH/annualincome_HH3
gen s_selfem_HH=incnonagrise_HH/annualincome_HH3
gen s_mgnreg_HH=incnrega_HH/annualincome_HH3
gen s_pensio_HH=pension_HH/annualincome_HH3
gen s_remitt_HH=remreceived_HH/annualincome_HH3

* Jatis and caste
drop jatisdetails jatis
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename casten caste
rename jatisn jatis
encode jatis, gen(jatis_code)
drop jatis
rename jatis_code jatis

gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

ta caste, gen(caste_)
label var caste_1 "Caste: Dalits"
label var caste_2 "Caste: Middle castes"
label var caste_3 "Caste: Upper castes"

order jatis caste caste_1 caste_2 caste_3 dalits, after(livingarea)

save "panel_v4", replace
****************************************
* END
















****************************************
* Construction 3
****************************************
use"panel_v4", clear

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







********** Famille avec au moins 2 femmes et 2 hommes travailleurs pour voir si la méthode de Jalil pourrait fonctionner
gen morethan22=0
replace morethan22=1 if wp_occupied_men_HH>=2 & wp_occupied_women_HH>=2 & wp_occupied_men_HH!=. & wp_occupied_women_HH!=.

ta morethan22 year, col
/*
. ta morethan22 year, col

+-------------------+
| Key               |
|-------------------|
|     frequency     |
| column percentage |
+-------------------+

           |               year
morethan22 |      2010       2016       2020 |     Total
-----------+---------------------------------+----------
         0 |       383        417        539 |     1,339 
           |     94.57      84.93      86.52 |     88.15 
-----------+---------------------------------+----------
         1 |        22         74         84 |       180 
           |      5.43      15.07      13.48 |     11.85 
-----------+---------------------------------+----------
     Total |       405        491        623 |     1,519 
           |    100.00     100.00     100.00 |    100.00 
*/


save "panel_v5", replace
****************************************
* END


