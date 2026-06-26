*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 16, 2026
*-----
gl link = "evolutions"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\evolutions.do"
*-------------------------






****************************************
* Debt dynamics for the pooled sample
****************************************
use"pooled_v1", clear

xtset panelvar year

gen diffdebt=logdebt_t1-logdebt_t
gen logwealth=log(assets_total)
gen logincome=log(annualincome_HH)


*** Macro
global head head_female head_age head_married i.head_edulevel i.head_mocc_occupation
global hh logwealth logincome sexratio HHsize


*** FE model
xtreg diffdebt c.logdebt_t##c.logdebt_t##c.logdebt_t##c.logdebt_t $hh $head, fe

xtreg diffdebt c.logdebt_t##c.logdebt_t##c.logdebt_t##c.logdebt_t##i.dalits $hh $head, fe


*** Quantile regressions
xtqreg diffdebt c.logdebt_t##c.logdebt_t##c.logdebt_t##c.logdebt_t $hh $head, id(panelvar) q(.25 .5 .75 .9)
xtqreg diffdebt c.logdebt_t##c.logdebt_t##c.logdebt_t##c.logdebt_t##i.dalits $hh $head, id(panelvar) q(.25 .5 .75 .9)

****************************************
* END
