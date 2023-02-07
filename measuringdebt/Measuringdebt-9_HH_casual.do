*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------








****************************************
* Prediction power with ML-SEM
****************************************
cls
use"panel_v9", clear


********* Share total casual
sum shareincagrise_HH shareincagricasual_HH shareincnonagricasual_HH shareincnonagriregnonquali_HH shareincnonagriregquali_HH shareincnonagrise_HH shareincnrega_HH

gen shareincomecasualfemale_HH=(shareincagricasual_HH+shareincnrega_HH)*100
ta shareincomecasualfemale_HH


********** Panel declaration
xtset panelvar time
set matsize 10000, perm


********** X-var
global interestvar shareincomecasualfemale_HH

global xinvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global xvar1 log_HHsize share_children sexratio dependencyratio

global xvar2 head_female head_age head_educ

global xvar3 remittnet_HH assets_total annualincome_HH


********** Ind occup
global yvar fvi

log using "C:\Users\Arnaud\Downloads\MLSEM_debt.log", replace

foreach y in $yvar {
foreach x in $interestvar {
capture noisily xtdpdml `y' $xvar1 $xvar2 $xvar3, inv($xinvar) predetermined(L.`x') fiml
}
}

log close


****************************************
* END
