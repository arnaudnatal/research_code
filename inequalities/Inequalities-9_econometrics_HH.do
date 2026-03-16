*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 16, 2026
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* Econometrics test
****************************************
use"panel_v3", clear

*** Declaration
ta year
drop if year==2026
xtset panelvar time

*** Lag
preserve
keep HHID_panel year logincome logassets
drop if year==2020
recode year (2010=2016) (2016=2020)
fre year
rename logincome laglogincome
rename logassets laglogassets
save"_temp", replace
restore
merge 1:1 HHID_panel year using "_temp"
drop if _merge==2
drop _merge


*** Interactions
forvalues i=1/3 {
gen caste`i'_logincome=logincome*caste`i'
gen caste`i'_logassets=logassets*caste`i'
}


*** Macro
global head head_female head_age head_married head_edu2 head_edu3 head_edu4 head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7
global hh sexratio logdebt logHHsize
global invar vill2 vill3 vill4 vill5 vill6 vill7 vill8 vill9 vill10 caste2 caste3


***
xtqreg assets_total c.logincome##i.caste $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)

/*
xtqreg assets_total c.laglogincome##i.caste $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)

xtqreg annualincome c.laglogassets##i.caste $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
*/



*** Income in t-1 on Wealth in t
xtdpdml logassets $head $hh, inv($invar) predetermined(L.logincome) fiml

*** Wealth in t-1 on Income in t
xtdpdml logincome $head $hh, inv($invar) predetermined(L.logassets) fiml

*** Income in t-1 X caste on Wealth in t
xtdpdml logassets $head $hh, inv($invar) predetermined(L.logincome L.caste2_logincome L.caste3_logincome) fiml

*** Wealth in t-1 X caste on Income in t
xtdpdml logincome $head $hh, inv($invar) predetermined(L.logassets L.caste2_logassets caste3_logassets) fiml




****************************************
* END




