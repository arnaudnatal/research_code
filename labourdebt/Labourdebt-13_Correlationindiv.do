*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------






****************************************
* 2010 at individual level
****************************************
use"raw/RUME-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name sex age relationshiptohead)
drop _merge

* Selection 
keep HHID2010 INDID2010 sex age name relationshiptohead mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv nboccupation_indiv working_pop annualincome_indiv incomeagri_indiv incomenonagri_indiv

* Merge panel
merge m:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2010, replace
merge 1:m HHID_panel INDID2010 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Year
gen year=2010

* Order
order HHID_panel INDID_panel HHID2010 INDID2010 year name age sex relationshiptohead working_pop

drop HHID2010 INDID2010

save "occ2010", replace
****************************************
* END








****************************************
* 2016-17 at individual level
****************************************
use"raw/NEEMSIS1-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name sex age relationshiptohead livinghome)
drop _merge

* Selection 
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop livinghome

keep HHID2016 INDID2016 sex age name relationshiptohead mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv nboccupation_indiv mainocc_hoursayear_indiv working_pop hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv annualincome_indiv incomeagri_indiv incomenonagri_indiv


* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Year
gen year=2016

* Order
order HHID_panel INDID_panel HHID2016 INDID2016 year name age sex relationshiptohead working_pop

drop HHID2016 INDID2016

save "occ2016", replace
****************************************
* END











****************************************
* 2020-21 at individual level
****************************************
use"raw/NEEMSIS2-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name sex age relationshiptohead livinghome dummylefthousehold)
drop _merge

* Selection
drop if dummylefthousehold==1
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop dummylefthousehold livinghome

keep HHID2020 INDID2020 sex age name relationshiptohead mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv nboccupation_indiv mainocc_hoursayear_indiv working_pop hoursayear_indiv hoursayearagri_indiv hoursayearnonagri_indiv annualincome_indiv incomeagri_indiv incomenonagri_indiv

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Year
gen year=2020

* Order
order HHID_panel INDID_panel HHID2020 INDID2020 year name age sex relationshiptohead working_pop

drop HHID2020 INDID2020

save "occ2020", replace
****************************************
* END












****************************************
* Append indiv database
****************************************
use"occ2010", clear

append using "occ2016"
append using "occ2020"

* Merge caste
merge m:m HHID_panel year using "raw/Panel-Caste_HH_long", keepusing(jatiscorr caste)
drop _merge

order jatiscorr caste, after(relationshiptohead)
label define caste 1"Dalits" 2"Middle castes" 3"Upper castes", replace
label values caste caste

* Merge fvi
preserve
use "panel_v3indiv_hours", clear
keep HHID_panel year fvi_lag fvi_noinv_lag fvi fvi_noinv
duplicates drop
ta year
save"_temp", replace
restore

merge m:1 HHID_panel year using "_temp"
drop _merge

save"occindiv", replace
****************************************
* END













****************************************
* Total
****************************************
use"occindiv", clear

* Change style
set scheme plotplain_v2
grstyle init
grstyle set plain, box grid
*

* Selection
drop if year==2010
ta year
drop if hoursayear_indiv==.
drop if hoursayear_indiv>4000

********** Total line for working time
gen hours_male=hoursayear_indiv if sex==1
gen hours_female=hoursayear_indiv if sex==2

pctile perc_hours=hoursayear_indiv, n(100)
pctile perc_hours_male=hours_male, n(100)
pctile perc_hours_female=hours_female, n(100)

gen n=_n
replace n=. if n>99

twoway ///
(line perc_hours_male n, yline(1669 2500, lcolor("197 102 63")) lcolor("164 204 76")) ///
(line perc_hours_female n, lcolor("80 151 68")) ///
, ///
xtitle("Centiles") xlabel(0(10)100) xmtick(5(5)95, grid glcolor("164 204 76")) ///
ytitle("Heures / an") ylabel(0(1000)4000) ymtick(0(500)4000) ///
legend(order(1 "Hommes" 2 "Femmes") pos(6) col(2)) ///
note("Échantillon groupé 2016-17 2020-21.", size(vsmall)) scale(1.5) ///
title("Temps de travail par an") name(heurestot, replace) 

graph export "Heuresparan.pdf", as(pdf) replace



*********** FVI cat and below p25 and above for males
xtile cat_fvi=fvi_noinv_lag, nq(4)

twoway ///
(kdensity hours_male if cat_fvi==1, xline(1669 2500, lcolor("197 102 63")) lcolor("164 204 76")) ///
(kdensity hours_male if cat_fvi==4, lcolor("80 151 68")) ///
, ///
xtitle("Heures par an") xlabel(0(1000)4000) xmtick(0(500)4000) ///
ytitle("Densité") title("Temps de travail des hommes") ///
legend(order(1 "25 % FVI plus bas" 2 "25 % FVI plus haut") pos(6) col(2)) name(densité, replace) scale(1.5)

graph export "Heuresparan_fvi.pdf", as(pdf) replace


*********** FVI cat and below p25 and above for females
twoway ///
(kdensity hours_female if cat_fvi==1, xline(1669 2500, lcolor("197 102 63")) lcolor("164 204 76")) ///
(kdensity hours_female if cat_fvi==4, lcolor("80 151 68")) ///
, ///
xtitle("Heures par an") xlabel(0(1000)4000) xmtick(0(500)4000) ///
ytitle("Densité") title("Temps de travail des femmes") ///
legend(order(1 "25 % FVI plus bas" 2 "25 % FVI plus haut") pos(6) col(2)) name(densité, replace) scale(1.5)

graph export "Heuresparan_f_fvi.pdf", as(pdf) replace


********** Scatter
twoway (scatter hours_female fvi_noinv_lag)


****************************************
* END




