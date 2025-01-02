*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Prepa HH
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* Savings
sort HHID2010 INDID2010
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3)
bysort HHID2010: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2010 village villagearea ownland house housetitle savings_HH
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


* Nouvelles estimations des biens de consommation durables en 2010
/*
rename assets_goods assets_goodsold
rename assets_total assets_totalold
rename assets_totalnoland assets_totalnolandold
rename assets_totalnoprop assets_totalnopropold
rename assets_total1000 assets_totalold1000
rename assets_totalnoland1000 assets_totalnolandold1000
rename assets_totalnoprop1000 assets_totalnopropold1000

rename assets_goodsbis assets_goods
rename assets_totalbis assets_total
rename assets_totalnolandbis assets_totalnoland
rename assets_totalnopropbis assets_totalnoprop
rename assets_totalbis1000 assets_total1000
rename assets_totalnolandbis1000 assets_totalnoland1000
rename assets_totalnopropbis1000 assets_totalnoprop1000
*/


save"temp_RUME", replace
****************************************
* END














****************************************
* Estimation consumer good prices 2010
****************************************

* 2016-17
use"raw/NEEMSIS1-HH", clear

foreach x in car cookgas computer antenna bike fridge furniture tailormach phone landline DVD camera {
gen `x'=(goodtotalamount_`x'/numbergoods_`x')*(100/158)
}
keep HHID2016 car cookgas computer antenna bike fridge furniture tailormach phone landline DVD camera
duplicates drop
rename HHID2016 HHID
gen year=2016
order HHID year, first

save"_temp1", replace


* 2020-21
use"raw/NEEMSIS2-HH", clear

foreach x in car cookgas computer antenna bike fridge furniture tailormach phone landline camera {
gen `x'=(goodtotalamount_`x'/numbergoods_`x')*(100/184)
}
keep HHID2020 car cookgas computer antenna bike fridge furniture tailormach phone landline camera
duplicates drop
rename HHID2020 HHID
gen year=2020
order HHID year, first

save"_temp2", replace

* Pooled
use"_temp1", clear

append using "_temp2"
ta year

save"_temp3", replace


* Stat
use"_temp3", clear

tabstat car cookgas computer antenna bike fridge furniture tailormach phone landline camera DVD, stat(n mean p50) by(year)


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

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2016: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle savings_HH
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

* Drop duplicates
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2020: egen savings_HH=sum(savings_indiv)

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
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle compensation compensationamount savings_HH
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


********** Controls
* HH
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)
fre village villageid vill
ta vill, gen(village_)

* Caste
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

* Jatis 1
fre jatis
gen jatis2=jatis
recode jatis2 ///
(1=1) (11=2) ///
(7=3) (9=5) (12=6) (4=8) (2=9) ///
(6=11) (3=12) (8=13) (5=14) (10=15)

label define jatis2 ///
2"SC" 1"Arunthathiyar" ///
9"Asarai" 8"Kulalar" 7"Gramani" 6"Vanniyar" 5"Nattar" 4"Navithar" 3"Muslims" ///
15"Rediyar" 14"Marwari" 13"Naidu" 12"Chettiyar" 11"Mudaliar" 10"Yathavar"
label values jatis2 jatis2

ta jatis jatis2

drop jatis
rename jatis2 jatis
order jatis, after(caste)


* Jatis 2
gen jatis3=jatis
fre jatis3
recode jatis3 (5=4) (6=5) (8=6) (9=7) (11=8) (12=9) (13=10) (14=11) (15=12)
label define jatis3 ///
2"SC" 1"Arunthathiyar" ///
7"Asarai" 6"Kulalar" 5"Vanniyar" 4"Nattar" 3"Muslims" ///
12"Rediyar" 11"Marwari" 10"Naidu" 9"Chettiyar" 8"Mudaliar"
label values jatis3 jatis3

ta jatis3 jatis
drop jatis
rename jatis3 jatis
order jatis, after(caste)



********** Nettoyage
drop head_*
drop agegrp*
drop male_agegrp*
drop female_agegrp*
drop relation_*
drop nbgeneration1 nbgeneration2 nbgeneration3 nbgeneration4 nbgeneration5 dummygeneration1 dummygeneration2 dummygeneration3 dummygeneration4 dummygeneration5
drop vill
drop shareincagrise_HH shareincagricasual_HH shareincnonagricasual_HH shareincnonagriregnonquali_HH shareincnonagriregquali_HH shareincnonagrise_HH shareincnrega_HH sharehoursayearagri_HH sharehoursayearnonagri_HH shareincomeagri_HH shareincomenonagri_HH
drop expenses_educ expenses_marr expenses_total expenses_food expenses_heal expenses_cere expenses_agri shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere
drop age_group family typeoffamily nbgeneration waystem dummypolygamous pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH
drop compensation compensationamount dummymarriage
drop hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH nbworker_HH nbnonworker_HH nonworkersratio
drop assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 shareassets_housevalue shareassets_livestock shareassets_goods shareassets_ownland shareassets_gold assets_sizeownland
drop goldquantity_HH goldquantitypledge_HH goldreadyamount
drop village_1 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
drop caste_1 caste_2 caste_3
drop house
drop housetitle nbmale nbfemale HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize incomeagri_HH incomenonagri_HH remsent_HH remittnet_HH dummyexposure secondlockdownexposure dummysell dummydemonetisation panelvar dalits
drop dummypanel

* Time
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
order time, after(year)


save"panel_v1", replace
****************************************
* END














****************************************
* Assets
****************************************
use"panel_v1", clear


********** HH

* Rename
rename savings_HH savings
rename assets_ownland land
rename assets_housevalue house
rename assets_livestock livestock
rename assets_goods goods
rename assets_gold gold

* Dummy ownland
recode ownland (.=0)
ta ownland year, col nofreq
label define ownland 0"Own land: No" 1"Own land: Yes"
label values ownland ownland

* Recode and dummies
global assets house livestock goods land gold savings
foreach x in $assets {
recode `x' (.=0)
replace `x'=`x'/1000
gen d_`x'=.
replace d_`x'=0 if `x'==0
replace d_`x'=1 if `x'>0
}

* Total
egen assets_total=rowtotal(house livestock goods land gold savings)

* Share
foreach x in house livestock goods land gold savings {
g s_`x'=`x'*100/assets_total
}




********** Per capita

* Level
foreach x in assets_total house livestock goods land gold savings {
gen `x'_pc=`x'/HHsize
}

* Share
foreach x in house livestock goods land gold savings {
g s_`x'_pc=`x'_pc*100/assets_total_pc
}

* Order
order ///
d_house d_livestock d_goods d_land d_gold d_savings ///
assets_total house livestock goods land gold savings ///
s_house s_livestock s_goods s_land s_gold s_savings ///
assets_total_pc house_pc livestock_pc goods_pc land_pc gold_pc savings_pc ///
s_house_pc s_livestock_pc s_goods_pc s_land_pc s_gold_pc s_savings_pc, last

save"panel_v2", replace
****************************************
* END



















****************************************
* Income
****************************************
use"panel_v2", clear


********** HH

* Rename
rename incagrise_HH agrise
rename incagricasual_HH agrica
rename incnonagricasual_HH casual
rename incnonagriregnonquali_HH regnqu
rename incnonagriregquali_HH regqua
rename incnonagrise_HH selfem
rename incnrega_HH mgnreg
rename pension_HH pensio
rename remreceived_HH remitt

* Regular
gen regula=regnqu+regqua
order regula, after(mgnreg)

* Clean
drop regnqu regqua annualincome_HH

* Annual income 
gen annualincome=agrise+agrica+casual+regula+selfem+mgnreg+pensio+remitt

* Monthly income
gen monthlyincome=annualincome/12

* Dummies occupation
global inc agrise agrica casual regula selfem mgnreg pensio remitt
foreach x in $inc {
gen d_`x'=0
}
foreach x in $inc {
replace d_`x'=1 if `x'!=0 & `x'!=.
}


* Share
foreach x in agrise agrica casual regula selfem mgnreg pensio remitt {
gen s_`x'=`x'*100/annualincome
}

* Order
order ///
d_agrise d_agrica d_casual d_regula d_selfem d_mgnreg d_pensio d_remitt ///
monthlyincome annualincome agrise agrica casual selfem mgnreg regula pensio remitt ///
s_agrise s_agrica s_casual s_regula s_selfem s_mgnreg s_pensio s_remitt, last




********** Per capita
* Level
foreach x in monthlyincome annualincome agrise agrica casual regula selfem mgnreg pensio remitt {
gen `x'_pc=`x'/HHsize
}

* Share
foreach x in agrise agrica casual regula selfem mgnreg pensio remitt {
g s_`x'_pc=`x'_pc*100/annualincome_pc
}


* Order
order ///
d_agrise d_agrica d_casual d_regula d_selfem d_mgnreg d_pensio d_remitt ///
monthlyincome annualincome agrise agrica casual selfem mgnreg regula pensio remitt ///
s_agrise s_agrica s_casual s_regula s_selfem s_mgnreg s_pensio s_remitt ///
monthlyincome_pc annualincome_pc agrise_pc agrica_pc casual_pc regula_pc selfem_pc mgnreg_pc pensio_pc remitt_pc ///
s_agrise_pc s_agrica_pc s_casual_pc s_regula_pc s_selfem_pc s_mgnreg_pc s_pensio_pc s_remitt_pc, last



********** 1k rupees
replace monthlyincome=monthlyincome/1000
replace monthlyincome_pc=monthlyincome_pc/1000



save "panel_v3", replace
****************************************
* END

