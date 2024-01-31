*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 31, 2024
*-----
gl link = "labourdebt"
*Attrition
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------












****************************************
* Reasons
****************************************


********** Ne garder que les individus éligibles
use"raw/keypanel-indiv_long", clear

* Var to keep
ta year
keep HHID_panel INDID_panel year
destring year, replace
drop if year==2010

* Var for regressions
global varreg hoursamonth_indiv DSR_lag age edulevel relation2 sex marital remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio work nonworkersratio
global varsup panel multipleoccup caste villageid hoursaweek_indiv hoursayear_indiv working_pop mainocc_occupation_indiv
merge 1:1 HHID_panel INDID_panel year using "panel_laboursupplyindiv_v2", keepusing($varreg $varsup)
/*
Je supprime les individus de 2010 car pas de y
Je supprime les morts
*/
keep if _merge==3
drop _merge
ta year

* Selection
drop if age<14
sort HHID_panel INDID_panel year

* Var for selection
merge 1:1 HHID_panel INDID_panel year using "ssizeindiv"
drop _merge
ta selection_indiv year, m
/*
selection_indiv permet la selection entre attrition et panel
*/

* Check for working status
ta selection_indiv

keep HHID_panel INDID_panel year selection_indiv

save"attrition", replace



********** Base avec les raisons de l'attrition
use"raw/NEEMSIS2-HH", clear
keep HHID2020 INDID2020 dummylefthousehold reasonlefthome reasonlefthomeother lefthomedurationlessoneyear lefthomedurationmoreoneyear lefthomedestination lefthomereason livinghome lefthomedurationlessoneyear lefthomedurationmoreoneyear lefthomedestination lefthomereason

merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

save"_tempattr", replace




********** Merger les deux
use"attrition", clear

merge 1:1 HHID_panel INDID_panel using "_tempattr", force
drop if _merge==2
drop _merge

* Attrition
keep HHID_panel INDID_panel selection_indiv dummylefthousehold reasonlefthome reasonlefthomeother livinghome lefthomereason

foreach x in reasonlefthome lefthomereason {
decode `x', gen(n1)
drop `x'
rename n1 `x'
}

gen reason=""
replace reason=reasonlefthome if reason==""
replace reason=lefthomereason if reason==""
replace reason="" if panel==1
drop reasonlefthome reasonlefthomeother lefthomereason

sort panel
ta reason panel, m col nofreq

save"attritionv_2", replace
****************************************
* END











****************************************
* Analyses de l'attrition
****************************************
use"attrition_v2", clear




****************************************
* END








****************************************
* Attrition individual level
****************************************
use"raw/keypanel-indiv_long", clear

* Var to keep
ta year
keep HHID_panel INDID_panel year
destring year, replace
drop if year==2010

* Var for regressions
global varreg hoursamonth_indiv DSR_lag age edulevel relation2 sex marital remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio work nonworkersratio
global varsup panel multipleoccup caste villageid hoursaweek_indiv hoursayear_indiv working_pop mainocc_occupation_indiv
merge 1:1 HHID_panel INDID_panel year using "panel_laboursupplyindiv_v2", keepusing($varreg $varsup)
/*
Je supprime les individus de 2010 car pas de y
Je supprime les morts
*/
keep if _merge==3
drop _merge
ta year

* Selection
drop if age<14
sort HHID_panel INDID_panel year

* Var for selection
merge 1:1 HHID_panel INDID_panel year using "ssizeindiv"
drop _merge
ta selection_indiv year, m
/*
selection_indiv permet la selection entre attrition et panel
*/

* Check for working status
ta selection_indiv
/*
Total sample - 	4330
Attrition - 	988
Panel - 		3342
*/

ta selection_indiv year if work==1
/*
Working individual - 	3027
Attrition -				673
Panel - 				2354
*/




********** Attrition
tabstat age hoursamonth_indiv, stat(min p1 p5 p10 q p90 p95 p99 max)
gen cat_age=.
replace cat_age=1 if age<25 & age!=.
replace cat_age=2 if age>=25 & age<35 & age!=.
replace cat_age=3 if age>=35 & age<45 & age!=.
replace cat_age=4 if age>=45 & age<60 & age!=.
replace cat_age=5 if age>=60 & age!=.

gen cat_hours=.
replace cat_hours=1 if hoursamonth_indiv<60 & hoursamonth_indiv!=.
replace cat_hours=2 if hoursamonth_indiv>=60 & hoursamonth_indiv<110 & hoursamonth_indiv!=.
replace cat_hours=3 if hoursamonth_indiv>=110 & hoursamonth_indiv<180 & hoursamonth_indiv!=.
replace cat_hours=4 if hoursamonth_indiv>=180 & hoursamonth_indiv<240 & hoursamonth_indiv!=.
replace cat_hours=5 if hoursamonth_indiv>=240 & hoursamonth_indiv!=.

cls
foreach x in cat_age sex relation2 caste edulevel work multipleoccup working_pop mainocc_occupation_indiv cat_hours {
ta `x' selection_indiv, exp cchi2 chi2
}

/*
Qui sont les individus attrition ?
- "25 35 ans" surreprésentés dans l'attrition et sous-représentés dans le panel
- Rien sur le sexe
- "Parents" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Middles" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Uppers" sous-représentés dans l'attrition et surreprésentés dans le panel
- "HSC or more" surreprésentés dans l'attrition et sous-représentés dans le panel
- Rien sur le statut dans l'emploi
- Rien sur les occupations multiples
- "Casual" sous-représentés dans l'attrition et surreprésentés dans le panel
- "MGNREGA" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Q3 LS" sous-représentés dans l'attrition et surreprésentés dans le panel
- "Q5 LS" surreprésentés dans l'attrition et sous-représentés dans le panel
*/

****************************************
* END














****************************************
* Attrition household level
****************************************
use"raw/keypanel-HH_long", clear

* Var to keep
ta year
keep HHID_panel year
destring year, replace
drop if year==2010

* Var for regressions
global varreg DSR_lag remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio nonworkersratio DSR
global varsup panel caste villageid
merge 1:m HHID_panel year using "panel_laboursupplyindiv_v2", keepusing($varreg $varsup)
/*
Je supprime les ménages de 2010 car pas de y
Je supprime les doublons pour être à l'échelle du ménage
*/
keep if _merge==3
drop _merge
duplicates drop
ta year

* Var for selection
merge 1:1 HHID_panel year using "ssizeHH"
drop _merge
ta selection_HH year, m
/*
selection_HH permet la selection entre attrition et panel
*/

* Sample size
ta selection_HH
/*
Total sample - 	1124
Attrition - 	251
Panel - 		873
*/



********** Attrition
foreach x in HHsize HH_count_child sexratio assets_total nonworkersratio remittnet_HH DSR {
xtile q_`x'=`x', n(3)
}

cls
foreach x in q_HHsize q_HH_count_child q_sexratio q_assets_total q_nonworkersratio q_remittnet_HH q_DSR dummymarriage caste villageid {
ta `x' selection_HH, exp cchi2 chi2
}

/*
Qui sont les ménages attrition ?
- Rien sur la taille du ménage
- "Q1 nb child" sous-représentés dans l'attrition et surreprésentés dans le panel
- "Q3 nb child" surreprésentés dans l'attrition et sous-représenéts dans le panel
- Rien sur le sex ratio
- "Q1 assets" sous-représentés dans l'attrition et surreprésentés dans le panel
- "Q3 non workers ratio" surreprésentés dans l'attrition et sous-représentés dans le panel
- Rien sur les remittances
- "Q2 DSR" surrepresentés dans l'attrition et sous-représentés dans le panel
- Rien sur le mariage
- "Middles" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Uppers" sous-représentés dans l'attrition et surreprésentés dans le panel
- Rien sur les villages
*/



****************************************
* END


