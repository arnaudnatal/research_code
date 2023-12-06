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
* 2016-17 at HH level
****************************************
use"raw/NEEMSIS1-occup_indiv", clear

* Merge sex
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(sex)
drop _merge

* HH level total and by sex
bysort HHID2016: egen hours_HH=sum(hoursayear_indiv)

fre sex
gen hours_male=hoursayear_indiv if sex==1
gen hours_female=hoursayear_indiv if sex==2

bysort HHID2016: egen hours_male_HH=sum(hours_male)
bysort HHID2016: egen hours_female_HH=sum(hours_female)

keep HHID2016 hours_HH hours_male_HH hours_female_HH
duplicates drop

* Merge panel
merge 1:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

gen year=2016
order HHID_panel HHID2016 year

* Ajout hours 2016
foreach x in hours_HH hours_male_HH hours_female_HH {
gen `x'2016=`x'
}

save "hoursHH2016", replace
****************************************
* END








****************************************
* 2020-21 at HH level
****************************************
use"raw/NEEMSIS2-occup_indiv", clear

* Merge sex
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(sex)
drop _merge

* HH level total and by sex
bysort HHID2020: egen hours_HH=sum(hoursayear_indiv)

fre sex
gen hours_male=hoursayear_indiv if sex==1
gen hours_female=hoursayear_indiv if sex==2

bysort HHID2020: egen hours_male_HH=sum(hours_male)
bysort HHID2020: egen hours_female_HH=sum(hours_female)

keep HHID2020 hours_HH hours_male_HH hours_female_HH
duplicates drop

* Merge panel
merge 1:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

gen year=2020
order HHID_panel HHID2020 year

* Ajout hours 2020
foreach x in hours_HH hours_male_HH hours_female_HH {
gen `x'2020=`x'
}

save "hoursHH2020", replace
****************************************
* END











****************************************
* Append HH database
****************************************
use"hoursHH2016", clear

append using "hoursHH2020"
order HHID_panel year
drop HHID2016 HHID2020

save"hoursHH", replace
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
* Merge HH hours with the main database
****************************************
use"panel_v3", clear


* Merge hours
merge 1:1 HHID_panel year using "hoursHH"
drop if _merge==2
drop _merge

* Merge FVI lag
merge 1:1 HHID_panel year using "HHhourslag"
drop if _merge==2
drop _merge

* Selection
drop if year==2010
ta year

save"panel_v3HHhours", replace
****************************************
* END









****************************************
* Analysis
****************************************
use"panel_v3HHhours", clear


********** Controls
global nonvar caste_1 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total dummymarriage 
global compo1 log_HHsize share_children sexratio dependencyratio share_stock
global xvar fvi_noinv_lag

********** Effets de FVI lag en FE
xtset panelvar year
xtreg hours_HH 	$xvar	$compo1 $econ $head $nonvar, fe
xtreg hours_male_HH	$xvar	$compo1 $econ $head $nonvar, fe
xtreg hours_female_HH $xvar $compo1 $econ $head $nonvar, fe


****************************************
* END
