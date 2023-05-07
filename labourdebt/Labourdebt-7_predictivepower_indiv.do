*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 9, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------







****************************************
* Prediction power with ML-SEM
****************************************
cls
use"panel_indiv_v3", clear

*** HH FE
encode HHID_panel, gen(HHFE)
ta HHFE, gen(HHFE)

********** Panel declaration
xtset panelvar time



********** Education
fre edulevel
gen primary=0 if edulevel==0 | edulevel==.
replace primary=1 if edulevel>0 & edulevel!=.


********** Variables

*** X
global nonvar caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

*global cont1 age primary log_HHsize remittnet_HH assets_total annualincome_HH share_female share_children share_young share_old

global contindiv age primary female 

global contHH log_HHsize assets_total sexratio dependencyratio annualincome_HH remittnet_HH



 


********** Spec 
cls
log using "Indivlevel.log", replace


capture noisily xtdpdml lfp $contindiv $contHH, inv($nonvar) predetermined(fvi L.fvi)

log close



****************************************
* END
