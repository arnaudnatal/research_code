*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 1, 2024
*-----
gl link = "educationdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\educationdebt.do"
*-------------------------







****************************************
* Descriptive statistics
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
sort HHID_panel INDID_panel year



********** Variables
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv age i.edulevel i.relation2 i.sex
global indiv2 age i.edulevel i.relation2 i.sex i.mainocc_occupation_indiv

global xvar DSR_lag
global yvar work multipleoccup hoursaweek_indiv


********** Var of interest
preserve
keep HHID_panel year caste DSR
duplicates drop
tabstat DSR, stat(n mean cv q) by(year)
tabstat DSR if caste==1, stat(n mean cv q) by(year)
tabstat DSR if caste==2, stat(n mean cv q) by(year)
tabstat DSR if caste==3, stat(n mean cv q) by(year)
restore


********** Dependant variables
/*
Bien vérifier la sélection de l'échantillon : combien de personnes travaillent ?
Regarder selection Heckman
*/
ta work year, col nofreq
ta work year if sex==1, col nofreq
ta work year if sex==2, col nofreq

ta multipleoccup year, col nofreq
ta multipleoccup year if sex==1, col nofreq
ta multipleoccup year if sex==2, col nofreq

tabstat hoursaweek_indiv, stat(n mean cv p50) by(year)
tabstat hoursaweek_indiv if sex==1, stat(n mean cv p50) by(year)
tabstat hoursaweek_indiv if sex==2, stat(n mean cv p50) by(year)


********** Controls
*** Indiv level
foreach x in edulevel relation2 mainocc_occupation_indiv {
ta `x' year, col nofreq
ta `x' year if sex==1, col nofreq
ta `x' year if sex==2, col nofreq
}

*** HH level
preserve
keep HHID_panel year caste villageid remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio nonworkersratio
duplicates drop
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio, stat(n mean cv p50) by(year) long
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio if caste==1, stat(n mean cv p50) by(year) long
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio if caste==2, stat(n mean cv p50) by(year) long
tabstat remittnet_HH assets_total HHsize HH_count_child sexratio nonworkersratio if caste==3, stat(n mean cv p50) by(year) long
restore

****************************************
* END
