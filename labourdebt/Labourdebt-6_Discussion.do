*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Stat desc discussion
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------










****************************************
* Caractéristiques de l'emploi des femmes
****************************************


********** Type of employment
cls
use"panel_laboursupplyindiv_v2", clear
drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
rename mainocc_annualincome_indiv income
rename mainocc_hoursayear_indiv hoursayear

ta occupation sex, col nofreq
ta occupation sex, cchi2 exp chi2
/*
Femmes sur-représentés dans les activités agri casual et MGNREGA.
*/



********** Hourly income
cls
use"panel_laboursupplyindiv_v2", clear
drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
*
rename mainocc_annualincome_indiv income
rename mainocc_hoursayear_indiv hoursayear
gen hourlyincome=income/hoursayear
fre occupation
ta occupation year
*
tabstat hourlyincome, stat(n mean q) by(occupation)
reg hourlyincome ib(2).occupation, clust(HHFE) baselevel
*
margins, dydx(occupation) atmeans post
*marginsplot, yline(0)

***** Graph
collapse (mean) hourlyincome, by(occupation year)
drop if occupation==.

*
graph bar hourlyincome, over(year) over(occupation, lab(angle(45)) relabel(1 "Agri self-emp" 2 "Agri casual" 3 "Casual" 4 "Reg non-quali" 5 "Reg quali" 6 "Self-emp" 7 "MGNREGA"))	ytitle("Mean") ylabel(0(10)90) asyvars legend(order(1 "2016-17" 2 "2020-21") pos(6) col(2)) name(inc, replace) ///
note("{it:Note:} For 1323 individuals in 2016-17 and 1704 in 2020-21." "{it:Source:} NEEMSIS-1 (2016-17) and NEEMSIS-2 (2020-21); authors' calculations.", size(vsmall)) scale(1.2)
graph export "Hourlyincome.png", as(png) replace








********** WEC
cls
use"panel_laboursupplyindiv_v2", clear

* verif des couples
preserve
keep if year==2020
keep if executionwork!=.
fre relationshiptohead
keep if relationshiptohead==1 | relationshiptohead==2
keep HHID_panel INDID_panel
gen couple=1
bysort HHID_panel: gen n=_n
drop INDID_panel
reshape wide couple, i(HHID_panel) j(n)
keep if couple1!=. & couple2!=.
restore

drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
*
keep if year==2020
fre occupation
ta executionwork
global var executionwork problemwork workexposure wec
*
foreach x in $var {
tabstat `x', stat(n mean q) by(occupation)
reg `x' ib(2).occupation, clust(HHFE) baselevel
margins, dydx(occupation) atmeans post
*marginsplot, yline(0) name(`x',replace)
}

***** Graph
collapse (mean) executionwork problemwork workexposure, by(occupation)
drop if occupation==.

rename executionwork score1
rename problemwork score2
rename workexposure score3
reshape long score, i(occupation) j(type)
label define type 1"Execution" 2"Problem" 3"Exposure"
label values type type
label define mainocc_occupation_indiv 1"Agri self-emp" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"Self-emp" 7"MGNREGA", replace

***** Graph
graph bar score, over(type) over(occupation, lab(angle(45)))	ytitle("Mean") ylabel(0(.1).9) asyvars legend(order(1 "Execution" 2 "Problem" 3 "Exposure") pos(6) col(3)) name(inc, replace) ///
note("{it:Note:} For 1272 individuals in 2020-21." "{it:Source:} NEEMSIS-2 (2020-21); authors' calculations.", size(vsmall)) scale(1.2)
graph export "Workingcond.png", as(png) replace








********** Discrimination
cls
use"panel_laboursupplyindiv_v2", clear
drop if age<14
keep if work==1
rename mainocc_occupation_indiv occupation
*
keep if year==2020
fre occupation
global var respect workmate agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 happywork verbalaggression physicalaggression sexualharassment discrimination discrimination_dummy
*
foreach x in $var {
tabstat `x', stat(n mean q) by(occupation)
reg `x' ib(2).occupation, clust(HHFE) baselevel
margins, dydx(occupation) atmeans post
marginsplot, yline(0) name(`x',replace)
}

****************************************
* END


