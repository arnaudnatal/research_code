*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 9, 2025
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Prepa data
****************************************
use"panel_HH_v2", clear


********** Selection
keep HHID_panel year head_sex head_age head_edulevel head_maritalstatus ownland dummymarriage head_mocc_occupation dummydemonetisation nbmale nbfemale HHsize HH_count_child HH_count_adult assets_total1000 annualincome_HH nbworker_HH nbnonworker_HH remittnet_HH secondlockdownexposure loanamount_HH trapamount dummytrap villageid dalits caste dummyloans dsr isr gtdr ///
expenses_educ expenses_food expenses_heal expenses_cere expenses_total shareexpenses_educ shareexpenses_food shareexpenses_heal shareexpenses_cere ///
dummytrap_*


********** Rename
rename assets_total1000 assets_HH
rename HHsize size_HH
rename HH_count_child nbchildren_HH
rename HH_count_adult nbadult_HH





********** New var
* HHFE
encode HHID_panel, gen(HHFE)

* Dalits
label define dalits 0"Non-dalits" 1"Dalits (=1)", modify

* Share
replace gtdr=gtdr/100

* Edulevel
fre head_edulevel
rename head_edulevel edulevel
label define edulevel 0"Edu: Below primary" 1"Edu: Primary completed" 2"Edu: High-school or more", replace
label values edulevel edulevel

* Occupation
fre head_mocc_occupation
recode head_mocc_occupation (6=5) (7=6)
rename head_mocc_occupation mainoccupation
label define mainoccupation 0"Occ: No" 1"Occ: Agri self-emp" 2"Occ: Agri casual" 3"Occ: Casual" 4"Occ: Regular" 5"Occ: Self-emp" 6"Occ: MGNREGA", replace
label values mainoccupation mainoccupation

* Women
fre head_sex
rename head_sex sex
label define sex 1"Sex: Man" 2"Sex: Woman", replace
label values sex sex

* Age
rename head_age age
label var age "Age"

* Maritalstatus
fre head_maritalstatus
rename head_maritalstatus maritalstatus
gen married=1 if maritalstatus==1
replace married=0 if maritalstatus>1
drop maritalstatus
label define married 0"Married: No" 1"Married: Yes"
label values married married

* Caste
fre caste
label define caste 1"Caste: Dalits" 2"Caste: Middle castes" 3"Caste: Upper castes", replace
label values caste caste 
fre caste

* Assets
egen assets_std=std(assets_HH)
drop assets_HH
label var assets_std "Wealth (std)"

* Income
egen income_std=std(annualincome_HH)
drop annualincome_HH
label var income_std "Income (std)"

* Loan amount
egen loan_std=std(loanamount_HH)
drop loanamount_HH
label var loan_std "Debt amount (std)"

* Shock 1
fre dummydemonetisation
rename dummydemonetisation shock1
recode shock1 (.=0)
label var shock1 "Shock 1 (=1)"

* Shock 2
fre secondlockdownexposure
gen shock2=0 if secondlockdownexposure==1
replace shock2=0 if secondlockdownexposure==2
replace shock2=1 if secondlockdownexposure==3
recode shock2 (.=0)
drop secondlockdownexposure
label var shock2 "Shock 2 (=1)"

* Shock 3
fre dummymarriage
rename dummymarriage shock3
recode shock3 (.=0)
label var shock3 "Shock 3 (=1)"

* Trap
label define dummytrap 0"In trap: No" 1"In trap: Yes"
label values dummytrap dummytrap 
fre dummytrap

label define dummytrap_1ybefore 0"In trap: No" 1"In trap: Yes"
label values dummytrap_1ybefore dummytrap_1ybefore 
fre dummytrap_1ybefore

label define dummytrap_2ybefore 0"In trap: No" 1"In trap: Yes"
label values dummytrap_2ybefore dummytrap_2ybefore 
fre dummytrap_2ybefore



********** Lag trap
preserve
use"panel_HH_v2", clear
keep HHID_panel year dummytrap trapamount gtdr dsr isr
bysort HHID_panel: gen n=_N
drop if year==2020
recode year (2016=2020) (2010=2016)
rename dummytrap LAGdummytrap
rename trapamount LAGtrapamount
rename gtdr LAGgtdr
rename isr LAGisr
rename dsr LAGdsr
drop if n==1
drop n
save"_temp", replace
restore
merge 1:1 HHID_panel year using "_temp"
drop if _merge==2
drop _merge



********** Expenses par tête
foreach x in expenses_educ expenses_food expenses_heal expenses_cere expenses_total {
replace `x'=1 if `x'==0
replace `x'=1 if `x'==.
gen `x'_pc=`x'/size_HH
gen log_`x'_pc=log(`x'_pc)
}


********** Selection
global var HHID_panel HHFE year age sex married edulevel mainoccupation dalits size_HH nbchildren_HH nbadult_HH income_std assets_std shock1 shock2 shock3 villageid dummyloans trapamount dummytrap_1ybefore dummytrap_2ybefore dummytrap log_expenses_educ_pc log_expenses_food_pc log_expenses_heal_pc log_expenses_cere_pc log_expenses_total_pc caste
keep $var
order $var
sort HHID_panel year


save"panel_HH_v2_econo", replace
****************************************
* END












****************************************
* Econo without lag
****************************************
use"panel_HH_v2_econo", clear

* Selection
keep if dummyloans==1
xtset HHFE year
ta year

* Macro
global headcont i.sex c.age##c.age i.married i.edulevel i.mainoccupation 
global hhcont size_HH nbchildren_HH income_std assets_std


*** Food
xtreg log_expenses_food_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store food
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_food
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.3(.1).3) ///
title("Annual per capita food expenses (log)") scale(1.1) ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(food, replace)
graph export "graph/xtfe_food.png", as(png) replace


*** Health
xtreg log_expenses_heal_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store heal
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_heal
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.8(.2).8) ///
title("Annual per capita health expenses (log)") scale(1.1) ///
name(heal, replace)
graph export "graph/xtfe_health.png", as(png) replace


*** Education
xtreg log_expenses_educ_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store educ
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_educ
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-3(.5)2) ///
title("Annual per capita education expenses (log)") scale(1.1) ///
name(educ, replace)
graph export "graph/xtfe_education.png", as(png) replace

****************************************
* END














****************************************
* Econo with lag
****************************************
use"panel_HH_v2_econo", clear

* Selection
keep if dummyloans==1
xtset HHFE year
ta year

* Lag
drop dummytrap
rename dummytrap_2ybefore dummytrap

* Macro
global headcont i.sex c.age##c.age i.married i.edulevel i.mainoccupation 
global hhcont size_HH nbchildren_HH income_std assets_std

*** Food
xtreg log_expenses_food_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store food
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_food
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.3(.1).3) ///
title("Annual per capita food expenses (log)") scale(1.1) ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(food, replace)
graph export "graph/xtfe_food_lag.png", as(png) replace


*** Health
xtreg log_expenses_heal_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store heal
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_heal
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.8(.2).8) ///
title("Annual per capita health expenses (log)") scale(1.1) ///
name(heal, replace)
graph export "graph/xtfe_health_lag.png", as(png) replace


*** Education
xtreg log_expenses_educ_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store educ
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_educ
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-3(.5)2) ///
title("Annual per capita education expenses (log)") scale(1.1) ///
name(educ, replace)
graph export "graph/xtfe_education_lag.png", as(png) replace



****************************************
* END















****************************************
* Econo with lag INTERACTIONS
****************************************
use"panel_HH_v2_econo", clear

* Selection
keep if dummyloans==1
xtset HHFE year
ta year

* Lag
drop dummytrap
rename dummytrap_2ybefore dummytrap

* Macro
global headcont i.sex c.age##c.age i.married i.edulevel i.mainoccupation 
global hhcont size_HH nbchildren_HH income_std assets_std




*** Food
xtreg log_expenses_food_pc i.dummytrap##c.income_std $headcont $hhcont, fe vce(cluster HHFE)
est store food_inc
xtreg log_expenses_food_pc i.dummytrap##c.assets_std $headcont $hhcont, fe vce(cluster HHFE)
est store food_ass
xtreg log_expenses_food_pc i.dummytrap##i.dalits $headcont $hhcont, fe vce(cluster HHFE)
est store food_cas



*** Health
xtreg log_expenses_heal_pc i.dummytrap##c.income_std $headcont $hhcont, fe vce(cluster HHFE)
est store heal_inc
xtreg log_expenses_heal_pc i.dummytrap##c.assets_std $headcont $hhcont, fe vce(cluster HHFE)
est store heal_ass
xtreg log_expenses_heal_pc i.dummytrap##i.dalits $headcont $hhcont, fe vce(cluster HHFE)
est store heal_cas


*** Education
xtreg log_expenses_educ_pc i.dummytrap##c.income_std $headcont $hhcont, fe vce(cluster HHFE)
est store educ_inc
xtreg log_expenses_educ_pc i.dummytrap##c.assets_std $headcont $hhcont, fe vce(cluster HHFE)
est store educ_ass
xtreg log_expenses_educ_pc i.dummytrap##i.dalits $headcont $hhcont, fe vce(cluster HHFE)
est store educ_cas



****************************************
* END

























****************************************
* Econo with lag and shocks
****************************************
use"panel_HH_v2_econo", clear

* Selection
keep if dummyloans==1
xtset HHFE year
ta year

* Lag
drop dummytrap
rename dummytrap_2ybefore dummytrap

* Macro
global headcont i.sex c.age##c.age i.married i.edulevel i.mainoccupation 
global hhcont size_HH nbchildren_HH income_std assets_std shock1 shock2


*** Food
xtreg log_expenses_food_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store food
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std shock1 shock2) atmeans post
est store marg_food
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.3(.1).3) ///
title("Annual per capita food expenses (log)") scale(1) ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(food, replace)
graph export "graph/xtfe_food_lag_shocks.png", as(png) replace



*** Health
xtreg log_expenses_heal_pc i.dummytrap##c.assets_std $headcont $hhcont, fe vce(cluster HHFE)
est store heal
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std shock1 shock2) atmeans post
est store marg_heal
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.8(.2).8) ///
title("Annual per capita health expenses (log)") scale(1.1) ///
name(heal, replace)
graph export "graph/xtfe_health_lag_shocks.png", as(png) replace



*** Education
xtreg log_expenses_educ_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store educ
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std shock1 shock2) atmeans post
est store marg_educ
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-3(.5)2) ///
title("Annual per capita education expenses (log)") scale(1.1) ///
name(educ, replace)
graph export "graph/xtfe_education_lag_shocks.png", as(png) replace

****************************************
* END



























****************************************
* Econo with lag drop outliers
****************************************
use"panel_HH_v2_econo", clear

* Selection
keep if dummyloans==1
xtset HHFE year
ta year

* Lag
drop dummytrap
rename dummytrap_2ybefore dummytrap

* Macro
global headcont i.sex c.age##c.age i.married i.edulevel i.mainoccupation 
global hhcont size_HH nbchildren_HH income_std assets_std

*** Food
preserve
sum log_expenses_food_pc, det
local min=`r(p1)'
local max=`r(p99)'
drop if log_expenses_food_pc<`min'
drop if log_expenses_food_pc>`max'
*
xtreg log_expenses_food_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store food
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_food
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.3(.1).3) ///
title("Annual per capita food expenses (log)") scale(1.1) ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(food, replace)
graph export "graph/xtfe_food_lag_out.png", as(png) replace
restore


*** Health
preserve
sum log_expenses_heal_pc, det
local min=`r(p1)'
local max=`r(p99)'
drop if log_expenses_heal_pc<`min'
drop if log_expenses_heal_pc>`max'
*
xtreg log_expenses_heal_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store heal
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_heal
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-.8(.2).8) ///
title("Annual per capita health expenses (log)") scale(1.1) ///
name(heal, replace)
graph export "graph/xtfe_health_lag_out.png", as(png) replace
restore

*** Education
preserve
sum log_expenses_educ_pc, det
local min=`r(p1)'
local max=`r(p99)'
drop if log_expenses_educ_pc<`min'
drop if log_expenses_educ_pc>`max'
*
xtreg log_expenses_educ_pc i.dummytrap $headcont $hhcont, fe vce(cluster HHFE)
est store educ
*
margins, dydx(dummytrap sex age married edulevel mainoccupation size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg_educ
*
coefplot, drop(_cons) xline(0) base ///
msymbol(S) mcolor(plb1) ///
headings( ///
1.sex="{bf:Head charact}" ///
size_HH="{bf:Household charact}") ///
xtitle("Marginal effect") xlabel(-3(.5)2) ///
title("Annual per capita education expenses (log)") scale(1.1) ///
name(educ, replace)
graph export "graph/xtfe_education_lag_out.png", as(png) replace
restore

****************************************
* END


















****************************************
* Econo with lag drop Quantiles
****************************************
use"panel_HH_v2_econo", clear

*** Selection
keep if dummyloans==1
xtset HHFE year
ta year

*** Lag
drop dummytrap
rename dummytrap_2ybefore dummytrap

*** Macro
global headcont i.sex c.age##c.age i.married i.edulevel i.mainoccupation 
global hhcont size_HH nbchildren_HH income_std assets_std


********** Econo

*** Food
cls
xtqreg log_expenses_food_pc i.dummytrap $headcont $hhcont, id(HHFE) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
est store qfood

*** Health
cls
xtqreg log_expenses_heal_pc i.dummytrap $headcont $hhcont, id(HHFE) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
est store qheal

*** Education
cls
xtqreg log_expenses_educ_pc i.dummytrap $headcont $hhcont, id(HHFE) q(.1 .2 .3 .4 .5 .6 .7 .8 .9)
est store qeduc


********** Graph

*** Food
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
keep if var=="food"
*
twoway ///
(rarea max min quantile, color(plb1%30)) ///
(line coef quantile, lcolor(plb1) yline(0)) ///
, xlabel(1(1)9) ylabel(-.4(.1).1) ///
xtitle("Quantile") ///
title("Food") ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(food, replace) scale (1.2) aspectratio(3)

*** Health
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
keep if var=="health"
*
twoway ///
(rarea max min quantile, color(plb1%30)) ///
(line coef quantile, lcolor(plb1) yline(0)) ///
, xlabel(1(1)9) ylabel(-1(.2).2) ///
xtitle("Quantile") ///
title("Health") ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(health, replace) scale (1.2) aspectratio(3)

*** Education
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
keep if var=="educ"
*
twoway ///
(rarea max min quantile, color(plb1%30)) ///
(line coef quantile, lcolor(plb1) yline(0)) ///
, xlabel(1(1)9) ylabel(-10(2)10) ///
xtitle("Quantile") ///
title("Education") ///
legend(order(2 "Effect" 1 "95% CI") pos(6) col(2)) ///
name(educ, replace) scale (1.2) aspectratio(3)


*** Comb
grc1leg food health educ, col(3) name(comb, replace)
graph export "graph/xtqreg.png", as(png) replace


****************************************
* END











