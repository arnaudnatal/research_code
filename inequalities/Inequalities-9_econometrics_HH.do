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

*** First diff
preserve
keep HHID_panel year logassets logincome
reshape wide logassets logincome, i(HHID_panel) j(year)
foreach x in logassets logincome {
gen d_`x'2010=`x'2016-`x'2010
gen d_`x'2016=`x'2020-`x'2016
gen d_`x'2020=`x'2026-`x'2020
drop `x'2010 `x'2016 `x'2020 `x'2026
}
reshape long d_logassets d_logincome, i(HHID_panel) j(year)
drop if d_logassets==.
drop if d_logincome==.
ta year
save"_temp", replace
restore
* Merger
merge 1:1 HHID_panel year using "_temp"
keep if _merge==3
ta year

*** Interactions

*** Declaration panel
xtset panelvar time

*** Macro
global head head_female head_age head_married head_edu2 head_edu3 head_edu4 head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7
global hh logincome logassets logdebt sexratio logHHsize
global invar vill2 vill3 vill4 vill5 vill6 vill7 vill8 vill9 vill10 dalits


*** FE model
* Delta log assets
xtreg d_logassets $hh $head $invar, fe
xtreg d_logassets c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, fe


* Delta log income
xtreg d_logincome $hh $head $invar, fe
xtreg d_logincome c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, fe



*** Quantile regressions
* Delta log assets
xtqreg d_logassets $hh $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
xtqreg d_logassets c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)



* Delta log income
xtqreg d_logincome $hh $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
xtqreg d_logincome c.logincome##i.dalits c.logassets##i.dalits c.logdebt##i.dalits sexratio logHHsize $head $invar, id(panelvar) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)





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



