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
* Attrition household level
****************************************
use"raw/keypanel-HH_wide", clear

* Var to keep
keep HHID_panel HHID2010 HHID2016 HHID2020

gen attrition=0
replace attrition=1 if HHID2010!="" & HHID2016==""
replace attrition=2 if HHID2016!="" & HHID2020==""


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


