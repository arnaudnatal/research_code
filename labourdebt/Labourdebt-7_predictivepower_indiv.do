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

global econ remittnet_HH assets_total annualincome_HH

global compo1 log_HHsize share_female share_children share_young share_old share_stock

global compo2 log_HHsize share_children sexratio dependencyratio share_stock

global indiv age edu_2 edu_3 edu_4


*** Y
global yvar nbo nbo_male nbo_female
*lfp lfp_male lfp_female
tab1 $yvar


********** 
mdesc $nonvar $econ $compo1 $compo2 $indiv $yvar
 


********** Spec 1
cls
log using "Indiv_MLSEM.log", replace

foreach y in $yvar {

capture noisily xtdpdml `y' $econ $compo2 , inv($nonvar) predetermined(L.fvi) fiml
est store mlsem_`y'
}
log close

*$indiv $econ


****************************************
* END
