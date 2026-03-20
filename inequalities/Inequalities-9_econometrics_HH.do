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


*** Prepa for time serie clustering
preserve
keep HHID_panel year assets_total_pc
rename assets_total_pc wealth
bys HHID_panel: gen n=_N
ta n
keep if n==4
ta year
drop n
reshape wide wealth, i(HHID_panel) j(year)
export delimited "wealth.csv", replace
restore
preserve
keep HHID_panel year annualincome_pc
rename annualincome_pc income
bys HHID_panel: gen n=_N
ta n
keep if n==4
ta year
drop n
reshape wide income, i(HHID_panel) j(year)
export delimited "income.csv", replace
restore


*** Declaration
ta year
*drop if year==2026
xtset panelvar time

*** Lag
preserve
keep HHID_panel year logincome logassets
drop if year==2026
recode year (2010=2016) (2016=2020) (2020=2026)
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


*** XTQREG
xtset panelvar time

* Assets with income
xtqreg logassets laglogassets logincome $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)

* Assets with lag income
xtqreg logassets laglogassets logincome laglogincome $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)

* Income with assets
xtqreg logincome laglogincome logassets $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)

* Income with assets lag
xtqreg logincome laglogincome logassets laglogassets $head $hh $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)








*** QREGPD
xtset panelvar time
gen l_assets_total=l.assets_total
gen l_annualincome=l.annualincome
qregpd assets_total logincome $head l_assets_total, id(panelvar) fix(time)
qregpd annualincome logassets $head l_annualincome, id(panelvar) fix(time)


*** Simple diff
xtset panelvar time
xtreg D.logassets L.c.logincome##i.caste $head $hh $invar, fe
xtreg D.logincome L.c.logassets##i.caste $head $hh $invar, fe

*** ML-SEM
xtset panelvar time
* Income in t-1 on Wealth in t
xtdpdml logassets $head $hh, inv($invar) predetermined(L.logincome) fiml

* Wealth in t-1 on Income in t
xtdpdml logincome $head $hh, inv($invar) predetermined(L.logassets) fiml

* Income in t-1 X caste on Wealth in t
xtdpdml logassets $head $hh, inv($invar) predetermined(L.logincome L.caste2_logincome L.caste3_logincome) fiml

* Wealth in t-1 X caste on Income in t
xtdpdml logincome $head $hh, inv($invar) predetermined(L.logassets L.caste2_logassets caste3_logassets) fiml




****************************************
* END

















****************************************
* PCA
****************************************
use"panel_v3", clear

foreach x in annualincome_pc expenses_total loanamount_HH assets_total_pc {
replace `x'=`x'/1000
}

pca annualincome expenses_total loanamount_HH assets_total
predict a1 a2 a3

cluster wardslinkage a1 a2 a3, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clust2=groups(2)
cluster gen clust4=groups(4)

tabstat annualincome expenses_total loanamount_HH assets_total, stat(n mean) by(clust4)

ta clust4 year, col nofreq





****************************************
* END



