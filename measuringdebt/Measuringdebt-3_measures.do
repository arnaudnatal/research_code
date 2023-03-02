*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------




/*
FactomineR:
Linkage: Ward
Distance: L2squared  squared Euclidean distance 
*/






****************************************
* FVI
****************************************
use"panel_v3", clear

*** Replace
foreach x in tdr isr rrgpl {
replace `x'=0 if `x'<0
replace `x'=1 if `x'>1
}

*** FVI
*2*tdr+2*isr+rrgpl
gen fvi=(2*tdr+2*isr+rrgpl)/5


*** FVI-2
*tar+isr+rrgpl
*gen fvi2=(tar+isr+rrgpl)/3

*** Label
label var tdr "TDR"
label var isr "ISR"
label var rrgpl "RRGPL"
label var fvi "FVI"

save"panel_v4.dta", replace
****************************************
* END










****************************************
* Desc
****************************************
use"panel_v4", clear


********** Desc
tabstat fvi, stat(n mean cv) by(year)

* Corr for FE
keep HHID_panel year fvi
reshape wide fvi, i(HHID_panel) j(year)
pwcorr fvi2010 fvi2016 fvi2020, star(.1)

****************************************
* END




