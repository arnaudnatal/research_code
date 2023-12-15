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
* 2016-17 at individual level
****************************************
use"raw/NEEMSIS1-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(sex age relationshiptohead livinghome)
drop _merge

* Merge edulevel
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education", keepusing(edulevel)
drop _merge

* Keep
keep HHID2016 INDID2016 hoursayear_indiv sex age edulevel   relationshiptohead dummyworkedpastyear working_pop livinghome

* Merge panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge 1:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2016
order HHID_panel INDID_panel HHID2016 INDID2016 year

* Ajout hours 2016
gen hoursayear_indiv2016=hoursayear_indiv

* Selection 
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop livinghome


save "hoursindiv2016", replace
****************************************
* END










****************************************
* 2020-21 at individual level
****************************************
use"raw/NEEMSIS2-occup_indiv", clear

* Merge sex, age
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex age relationshiptohead livinghome dummylefthousehold)
drop _merge

* Merge edulevel
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education", keepusing(edulevel)
drop _merge

* Keep
keep HHID2020 INDID2020 hoursayear_indiv sex age edulevel relationshiptohead dummyworkedpastyear working_pop livinghome dummylefthousehold

* Merge panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge 1:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2020
order HHID_panel INDID_panel HHID2020 INDID2020 year

* Ajout hours 2020
gen hoursayear_indiv2020=hoursayear_indiv

* Selection
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
drop livinghome dummylefthousehold


save "hoursindiv2020", replace
****************************************
* END







****************************************
* Append indiv database
****************************************
use"hoursindiv2016", clear

append using "hoursindiv2020"
order HHID_panel INDID_panel year
drop HHID2016 HHID2020 INDID2016 INDID2020

save"hoursindiv", replace
****************************************
* END









****************************************
* Merger FVI lag
****************************************
use"panel_v3", clear

keep HHID_panel year fvi fvi2 fvi3 fvi4 fvi_noinv
drop if year==2020
recode year (2016=2020) (2010=2016)
foreach x in fvi fvi2 fvi3 fvi4 fvi_noinv {
rename `x' `x'_lag
}

save "HHhourslag", replace
****************************************
* END







****************************************
* Merge FVI lag with the main database
****************************************
use"panel_v3", clear

* Merge FVI lag
merge 1:1 HHID_panel year using "HHhourslag"
drop if _merge==2
drop _merge

* Selection
drop if year==2010
ta year

* Keep var of interest
keep HHID_panel year caste_1 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 head_female head_age head_educ remittnet_HH assets_total dummymarriage log_HHsize share_children sexratio dependencyratio share_stock fvi fvi_lag fvi_noinv fvi_noinv_lag

save"varHH", replace
****************************************
* END





****************************************
* Indiv database construction
****************************************
use"hoursindiv", clear

* Merge HH var
merge m:1 HHID_panel year using "varHH"
keep if _merge==3
drop _merge

* Selection
fre working_pop
drop if working_pop==1
ta year

gen work=.
replace work=0 if working_pop==2
replace work=1 if working_pop==3
ta work working_pop, m
bysort HHID_panel INDID_panel: egen test=sum(work)
ta test
drop test

* Panel var
egen panelvar=group(HHID_panel INDID_panel)
order HHID_panel INDID_panel panelvar year

* HHclust
encode HHID_panel, gen(HHclust)

save"panel_v3indiv_hours", replace
****************************************
* END







****************************************
* Analysis
****************************************
use"panel_v3indiv_hours", clear


********** Controls
global nonvar caste_1 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total dummymarriage 
global compo1 log_HHsize share_children sexratio dependencyratio share_stock
global xvar fvi_noinv_lag
global indiv age i.edulevel i.relationshiptohead



********** Effets de FVI lag no invest en FE
xtset panelvar year

* Male
preserve
keep if sex==1
xtreg hoursayear_indiv $xvar $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
restore

* Female
preserve
keep if sex==2
sum hoursayear_indiv, det
drop if hoursayear_indiv>r(p95)
xtreg hoursayear_indiv $xvar $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
restore


****************************************
* END





/*


****************************************
* Coef plot
****************************************
import excel "Testhours.xlsx", sheet("Sheet1") firstrow clear

* Label
replace level="1" if level=="Household"
replace level="2" if level=="Individual"
destring level, replace
label define level 1"Ménage" 2"Individu"
label values level level

replace sample="1" if sample=="Total"
replace sample="2" if sample=="Males"
replace sample="3" if sample=="Females"
destring sample, replace
label define sample 1"Total" 2"Hommes" 3"Femmes"
label values sample sample

drop y

*"80 151 68" brick
*"164 204 76" greenlight
*"197 102 63" darkgreen

* Graph HH
preserve
keep if level==1
twoway ///
(rcap max min sample, lcolor("164 204 76")) ///
(scatter coef sample, yline(0, lcolor("197 102 63")) mcolor("80 151 68")) ///
, xlabel(0" " 1"Total" 2"Hommes" 3"Femmes" 4" ", nogrid notick angle(0)) ///
ylab(, angle(vertical)) ///
title("Niveau ménage", size(small)) ///
xtitle("Échantillon") ytitle("Heures travaillées") ///
legend(order(1 "I.C. 95 %" 2 "Coef." ) pos(6) col(2)) ///
note("Modèles à EF", size(vsmall)) scale(1.5) ///
name(hourshh, replace)
restore


* Graph indiv
preserve
keep if level==2
twoway ///
(rcap max min sample, lcolor("164 204 76")) ///
(scatter coef sample, yline(0, lcolor("197 102 63")) mcolor("80 151 68")) ///
, xlabel(1" " 2"Hommes" 3"Femmes" 4" ", nogrid notick angle(0)) ///
ylab(, angle(vertical)) ///
title("Niveau individu", size(small)) ///
xtitle("Échantillon") ytitle("Heures travaillées") ///
legend(order(1 "I.C. 95 %" 2 "Coef." ) pos(6) col(2)) ///
note("Modèles à EF + cluster ménage", size(vsmall)) scale(1.5) ///
name(hoursindiv, replace)
restore


* One graph
grc1leg hourshh hoursindiv, title("Effet du lag de FVI, sans investissement") name(gphcomb, replace)
graph export "Testhours.pdf", as(pdf) replace


****************************************
* END



