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


********** Panel declaration
xtset panelvar time


********** Variables

*** X
global nonvar caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global econ remittnet_HH assets_total annualincome_HH shareform

global compo1 stem log_HHsize share_female share_children share_young share_old share_stock

global indiv age edu_2 edu_3 edu_4


*** Y
global yvar lfp lfp_male lfp_female lfp_young lfp_middle lfp_old
*igap igap_male igap_female




********** Spec 1
log using "Labourdebt_indiv_spec1.log", replace

foreach y in $yvar {

capture noisily xtdpdml `y' $compo1 $econ $indiv, inv($nonvar) predetermined(L.fvi) fiml
*capture noisily xtdpdml `y' $compo1 $econ $indiv, inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'
}
log close





****************************************
* END
