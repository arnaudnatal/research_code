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
use"panel_indiv_v2", clear


********** Selection
keep HHID_panel INDID_panel year sex age edulevel relationshiptohead maritalstatus ownland dummymarriage working_pop mainocc_occupation_indiv dummydemonetisation trapamount_indiv nbmale nbfemale HHsize HH_count_child HH_count_adult headsex assets_total1000 annualincome_HH nbworker_HH nbnonworker_HH remittnet_HH secondlockdownexposure loanamount_HH trapamount_HH share_giventrap dummytrap_indiv village_1 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 dalits dummyloans_indiv panelvar


********** Rename
rename assets_total1000 assets_HH
rename HHsize size_HH
rename mainocc_occupation_indiv moccup
rename HH_count_child nbchildren_HH
rename HH_count_adult nbadult_HH

rename dummyloans_indiv dummyloans
rename dummytrap_indiv dummytrap
rename trapamount_indiv trapamount
rename share_giventrap sharetrap


********** New var
* Dalits
label define dalits 0"Non-dalits" 1"Dalits (=1)", modify

* Share
replace sharetrap=sharetrap/100

* Panel indiv
bysort HHID_panel INDID_panel: gen obs=_N
ta obs year

* Edulevel
fre edulevel
recode edulevel (5=2) (4=2) (3=2)
ta edulevel, gen(edu_)
drop edulevel
label var edu_1 "Edu: Below primary"
label var edu_2 "Edu: Primary completed"
label var edu_3 "Edu: High-school or more"

* Occupation
fre moccup
recode moccup (.=0) (5=4)
ta moccup, gen(moccup_)
drop moccup working_pop
label var moccup_1 "Occ: Unoccup"
label var moccup_2 "Occ: Agri SE"
label var moccup_3 "Occ: Agri casual"
label var moccup_4 "Occ: Casual"
label var moccup_5 "Occ: Regular"
label var moccup_6 "Occ: SE"
label var moccup_7 "Occ: MGNREGA"

* HHFE
encode HHID_panel, gen(HHFE)

* Women
gen women=.
replace women=0 if sex==1
replace women=1 if sex==2
drop sex
label define women 0"Man" 1"Woman (=1)"
label values women women

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

* Age sq
gen agesq=age*age
label var age "Age"
label var agesq "Age squared"

* Maritalstatus
fre maritalstatus
gen married=1 if maritalstatus==1
replace married=0 if maritalstatus>1
drop maritalstatus
label var married "Married (=1)"

* Head sex
fre headsex
gen headwoman=0 if headsex==1
replace headwoman=1 if headsex==2
drop headsex

* Shock 1
fre dummymarriage
rename dummymarriage shock1
recode shock1 (.=0)
label var shock1 "Marriage (=1)"

* Shock 2
fre dummydemonetisation
rename dummydemonetisation shock2
recode shock2 (.=0)
label var shock2 "Demonetisation (=1)"

* Shock 3
fre secondlockdownexposure
gen shock3=0 if secondlockdownexposure==1
replace shock3=0 if secondlockdownexposure==2
replace shock3=1 if secondlockdownexposure==3
recode shock3 (.=0)
drop secondlockdownexposure
label var shock3 "After 2nd lockdown (=1)"



********** Order
sort HHID_panel INDID_panel year
order HHID_panel INDID_panel HHFE panelvar year age agesq women relationshiptohead married dalits edu_1 edu_2 edu_3 moccup_1 moccup_2 moccup_3 moccup_4 moccup_5 moccup_6 moccup_7 dummyloan dummytrap trapamount sharetrap headwoman size_HH nbchildren_HH nbadult_HH nbmale nbfemale nbworker_HH nbnonworker_HH assets_std income_std loan_std trapamount_HH remittnet_HH ownland shock1 shock2 shock3



********** Mean over time for FE
global indivcont age agesq married edu_1 edu_2 edu_3 moccup_1 moccup_2 moccup_3 moccup_4 moccup_5 moccup_6 moccup_7
global hhcont headwoman size_HH nbchildren_HH nbadult_HH nbmale nbfemale nbworker_HH nbnonworker_HH assets_std income_std loan_std trapamount_HH shock1 shock2 shock3

foreach x in $indivcont $hhcont {
bysort HHID_panel INDID_panel: egen mean_`x'=mean(`x')
}




********** Var Bates, Papke, Wooldridge
bysort HHID_panel INDID_panel: gen nobs=_N

gen nobs1=nobs==1
gen nobs2=nobs==2

gen year2016=year==2016
gen year2020=year==2020

foreach x in year2016 year2020 {
bysort HHID_panel INDID_panel: egen mean_`x'=mean(`x')
}

label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"

label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"


save"panel_indiv_v2_econo", replace
****************************************
* END












****************************************
* PROBIT 
****************************************
use"panel_indiv_v2_econo", clear



********** Macro
global indivcont ///
age mean_age ///
married mean_married ///
edu_2 mean_edu_2 ///
edu_3 mean_edu_3 ///
moccup_1 mean_moccup_1 ///
moccup_2 mean_moccup_2 ///
moccup_4 mean_moccup_4 ///
moccup_5 mean_moccup_5 ///
moccup_6 mean_moccup_6 ///
moccup_7 mean_moccup_7 ///

global hhcont ///
size_HH mean_size_HH ///
nbchildren_HH mean_nbchildren_HH ///
income_std mean_income_std ///
assets_std mean_assets_std 

global shocks ///
shock1 mean_shock1 ///
shock2 mean_shock2 ///
shock3 mean_shock3

global invar ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2020 mean_year2020 ///
nobs2


********** Sample
* Only trapped HH
keep if trapamount_HH!=0
ta dummytrap year, col
recode dummytrap (.=0)
ta dummytrap year, col


********** Final
* Overfit
/*
overfit: probit dummytrap i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)
*/
* Probit
probit dummytrap i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)
est store pro1
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg1



********** HH cluster
* Probit
probit dummytrap i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl HHFE)
est store pro2
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg2



********** Shocks
* Probit
probit dummytrap i.women i.dalits ///
$indivcont $hhcont $shocks $invar $time ///
, vce(cl panelvar)
est store pro3
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std shock1 shock2 shock3) atmeans post
est store marg3



********** HH FE
* Probit
probit dummytrap i.women i.dalits ///
$indivcont $hhcont $invar $time i.HHFE ///
, vce(cl panelvar)
est store pro4
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg4






********** Table
esttab pro1 pro2 pro3 pro4 using "Trap_pro.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	drop(mean_* village_* year* nobs*) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N N_clust r2_p, fmt(0 0 2)	labels(`"Observations"' `"Number of clust"'))

****************************************
* END


















****************************************
* FRACTIONAL PROBIT 
****************************************
use"panel_indiv_v2_econo", clear


********** Macro
global indivcont ///
age mean_age ///
married mean_married ///
edu_2 mean_edu_2 ///
edu_3 mean_edu_3 ///
moccup_1 mean_moccup_1 ///
moccup_2 mean_moccup_2 ///
moccup_4 mean_moccup_4 ///
moccup_5 mean_moccup_5 ///
moccup_6 mean_moccup_6 ///
moccup_7 mean_moccup_7 ///

global hhcont ///
size_HH mean_size_HH ///
nbchildren_HH mean_nbchildren_HH ///
income_std mean_income_std ///
assets_std mean_assets_std 

global shocks ///
shock1 mean_shock1 ///
shock2 mean_shock2 ///
shock3 mean_shock3

global invar ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2020 mean_year2020 ///
nobs2


********** Sample
* Only trapped HH
keep if trapamount_HH!=0
ta dummytrap year, col
recode dummytrap (.=0)
ta dummytrap year, col
keep if dummytrap==1
ta year




********** Final
* Overfit
/*
overfit: glm sharetrap i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
*/
* Frac
glm sharetrap i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
est store fra1
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg1





********** HH cluster
* Frac
glm sharetrap i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(HHFE)
est store fra2
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg2




********** Shocks
* Frac
glm sharetrap i.women i.dalits ///
$indivcont $hhcont $shocks $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
est store fra3
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std shock1 shock2 shock3) atmeans post
est store marg3



/*
********** HH FE
* Frac
glm sharetrap i.women i.dalits ///
$indivcont $hhcont $invar $time i.HHFE ///
, family(binomial) link(probit) cluster(panelvar)
est store fra4
* Margins
margins, dydx(women dalits age married edu_2 edu_3 moccup_1 moccup_2 moccup_4 moccup_5 moccup_6 moccup_7 size_HH nbchildren_HH income_std assets_std) atmeans post
est store marg4
*/






********** Table
esttab fra1 fra2 fra3 using "Trap_fra.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	drop(mean_* village_* year* nobs*) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N N_clust r2_p, fmt(0 0 2)	labels(`"Observations"' `"Number of clust"'))
	
	
****************************************
* END





















****************************************
* Graphs PROBIT
****************************************

********** Final
import excel "_marggraph.xlsx", sheet("probit_final") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/18,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/probit_final.png", as(png) replace


********** HH clust
import excel "_marggraph.xlsx", sheet("probit_HHclus") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/18,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/probit_HHclus.png", as(png) replace


********** Shocks
import excel "_marggraph.xlsx", sheet("probit_shocks") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/21,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/probit_shocks.png", as(png) replace


********** HH FE
import excel "_marggraph.xlsx", sheet("probit_HHFE") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/18,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/probit_HHFE.png", as(png) replace

	
****************************************
* END




















****************************************
* Graphs FRACTIONAL PROBIT
****************************************

********** Final
import excel "_marggraph.xlsx", sheet("fracprob_final") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/18,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/fracprob_final.png", as(png) replace


********** HH clust
import excel "_marggraph.xlsx", sheet("fracprob_HHclus") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/18,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/fracprob_HHclus.png", as(png) replace


********** Shocks
import excel "_marggraph.xlsx", sheet("fracprob_shocks") firstrow clear
labmask cat, values(lab)
drop lab
*
twoway ///
(rcap max min cat, horiz xline(0)) ///
(scatter cat dydx, msymbol(S)) ///
, ylabel(1/21,value) ///
ytitle("") xtitle("Marginal effect") ///
legend(order(1 "95% CI" 2 "Effect") pos(6) col(2)) ///
scale(1.2) name(probit_final, replace)
graph export "graph/fracprob_shocks.png", as(png) replace


	
****************************************
* END



