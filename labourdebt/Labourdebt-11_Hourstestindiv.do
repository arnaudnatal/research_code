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
keep HHID_panel year caste_1 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 head_female head_age head_educ remittnet_HH assets_total dummymarriage log_HHsize share_children sexratio dependencyratio share_stock fvi fvi_lag

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
global indiv age i.edulevel i.relationshiptohead


cls
********** Effets de FVI en pooled
reg work c.fvi##i.sex $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
reg hoursayear_indiv c.fvi##i.sex $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
* Male
preserve
keep if sex==1
reg work c.fvi $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
reg hoursayear_indiv c.fvi $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
restore
* Female
preserve
keep if sex==2
reg work c.fvi $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
reg hoursayear_indiv c.fvi $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
restore



cls
********** Effets de FVI en FE
xtset panelvar year
xtreg work c.fvi##i.sex $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
xtreg hoursayear_indiv c.fvi##i.sex $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
* Male
preserve
keep if sex==1
xtreg work c.fvi $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
xtreg hoursayear_indiv c.fvi $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
restore
* Female
preserve
keep if sex==2
xtreg work c.fvi $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
xtreg hoursayear_indiv c.fvi $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
restore


cls
********** Effets de FVI lag en pooled
reg work c.fvi_lag##i.sex $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
reg hoursayear_indiv c.fvi_lag##i.sex $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
* Male
preserve
keep if sex==1
reg work c.fvi_lag $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
reg hoursayear_indiv c.fvi_lag $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
restore
* Female
preserve
keep if sex==2
reg work c.fvi_lag $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
reg hoursayear_indiv c.fvi_lag $compo1 $econ $head $nonvar $indiv, cluster(HHclust)
restore


cls
********** Effets de FVI lag en FE SUPER !
xtset panelvar year
xtreg work c.fvi_lag##i.sex $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
xtreg hoursayear_indiv c.fvi_lag##i.sex $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
* Male
preserve
keep if sex==1
xtreg work c.fvi_lag $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
xtreg hoursayear_indiv c.fvi_lag $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
restore
* Female
preserve
keep if sex==2
xtreg work c.fvi_lag $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
xtreg hoursayear_indiv c.fvi_lag $compo1 $econ $head $nonvar $indiv, fe cluster(HHclust)
restore


****************************************
* END
