cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
19 octobre 2021
-----
TITLE: Nettoyage et analyse de l'évolution de l'emploi à l'échelle des emploi

-------------------------
*/

global directory = "D:\Documents\_Thesis\Research-Employment_evolution\Data"
cd "$directory"

global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"
global occ1 "RUME-occupations_v4"
global occ2 "NEEMSIS-occupation_allwide_v4"
global occ3 "NEEMSIS_APPEND-occupations_v5"


set scheme plotplain






****************************************
* Evolution mainocc
****************************************
global var caste jatis age sex relationshiptohead occupation occupationname annualincome sector worker mainocc_occupation_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv occinc_indiv_agri occinc_indiv_agricasual occinc_indiv_nonagricasual occinc_indiv_nonagriregnonqual occinc_indiv_nonagriregqual occinc_indiv_selfemp occinc_indiv_nrega

use"$occ1", clear
keep HHID_panel INDID_panel $var
order HHID_panel INDID_panel $var
gen year=2010
sort HHID_panel INDID_panel occupationname
keep if occupation!=.
save "$occ1-_temp", replace

use"$occ2", clear
keep HHID_panel INDID_panel $var
order HHID_panel INDID_panel $var
gen year=2016
sort HHID_panel INDID_panel occupationname
keep if occupation!=.
save "$occ2-_temp", replace


use"$occ3", clear
keep HHID_panel INDID_panel $var
order HHID_panel INDID_panel $var
gen year=2020
sort HHID_panel INDID_panel occupationname
keep if occupation!=.

append using "$occ1-_temp"
append using "$occ2-_temp"

bysort HHID_panel INDID_panel year (occupationname annualincome): gen occupationid=_n

sort year HHID_panel INDID_panel occupationid
order HHID_panel INDID_panel year occupationid

label define occupcode 0"No occ" 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify




********** Deflater les valeurs
foreach x in annualincome mainocc_annualincome_indiv {
clonevar `x'_raw=`x'
replace `x'=`x'/1000 if year==2010
replace `x'=(`x'*(100/158))/1000 if year==2016
replace `x'=(`x'*(100/184))/1000 if year==2020
label var `x' "₹1k "
}



********** Time for graph
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time 

order time, after(year)


********** Jatis et caste
label define castecat 1"Dalits" 2"Middle" 3"Upper" 77"Other", modify


save"panel_occ_v1", replace
erase "$occ1-_temp.dta"
erase "$occ2-_temp.dta"
****************************************
* END








****************************************
* Graph par sex et an
****************************************
use"panel_occ_v1", clear

drop if occupation==0

*********Occupation par an et par sexe
foreach x in 2010 2016 2020 {
foreach y in 1 2 {
preserve
keep if year==`x'
keep if sex==`y'
gen ok=1
contract occupation ok, zero freq(freq) perc(pc)
gen sex=`y'
gen year=`x'
save"occ_`x'_`y'.dta", replace
restore
}
}
*
use"occ_2010_1.dta", clear
foreach x in 2010 2016 2020 {
foreach y in 1 2 {
append using "occ_`x'_`y'.dta"
erase "occ_`x'_`y'.dta"
}
}

label define sex 1"Male" 2"Female"
label values sex sex
drop ok
*

********** Graph
set graph off
foreach x in 1 2 {
preserve
keep if sex==`x'
duplicates drop
separate pc, by(year) veryshortlabel
*
graph bar pc2010 pc2016 pc2020, ///
over(occupation, label(angle(45))) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
blabel(bar, format(%5.1f) size(tiny)) ///
ytitle("%") ylabel() ymtick() ///
title("`x'") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(occ_year_`x', replace)
restore
}

set graph on
grc1leg occ_year_1 occ_year_2, col(3) note("1=Male, 2=Female", size(vsmall))
graph export "occ_year_sex.pdf", replace

****************************************
* END








****************************************
* Graph par caste et an
****************************************
use"panel_occ_v1", clear

drop if occupation==0


foreach x in 2010 2016 2020 {
foreach y in 1 2 3{
preserve
keep if year==`x'
keep if caste==`y'
gen ok=1
contract occupation ok, zero freq(freq) perc(pc)
gen caste=`y'
gen year=`x'
save"occ_`x'_`y'.dta", replace
restore
}
}
*
use"occ_2010_1.dta", clear
foreach x in 2010 2016 2020 {
foreach y in 1 2 3{
append using "occ_`x'_`y'.dta"
erase "occ_`x'_`y'.dta"
}
}

label define caste 1"Dalits" 2"Middle" 3"Upper" 77"Other"
label values caste caste
drop ok
*

********** Graph
set graph off
foreach x in 1 2 3{
preserve
keep if caste==`x'
duplicates drop
separate pc, by(year) veryshortlabel
*
graph bar pc2010 pc2016 pc2020, ///
over(occupation, label(angle(45))) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
blabel(bar, format(%5.1f) size(tiny)) ///
ytitle("%") ylabel() ymtick() ///
title("`x'") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(occ_year_`x', replace)
restore
}

set graph on
grc1leg occ_year_1 occ_year_2 occ_year_3, col(3) note("1=Dalits, 2=Middle, 3=Upper, 77=Other", size(vsmall))
graph export "occ_year_caste.pdf", replace

****************************************
* END










****************************************
* Graph stripplot income
****************************************
use"panel_occ_v1", clear

tabstat annualincome1 annualincome2 annualincome3, stat(n mean p90 p95 p99 max)

set graph off

********** 2010
preserve
drop if occupation1==0
stripplot annualincome1 if annualincome1<200, over(occupation1) separate(caste1) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(20)200) ymtick(0(10)200) ytitle() ///
title("2010") ///
legend(pos(6) col(4) off) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_occ2010, replace)
restore

********** 2016
preserve
drop if occupation2==0
stripplot annualincome2 if annualincome2<200, over(occupation2) separate(caste2) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(20)200) ymtick(0(10)200) ytitle() ///
title("2016") ///
legend(pos(6) col(3) off) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_occ2016, replace)
restore

********** 2020
preserve
drop if occupation3==0
stripplot annualincome3 if annualincome3<200, over(occupation3) separate(caste3) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(20)200) ymtick(0(10)200) ytitle() ///
title("2020") ///
legend(pos(6) col(3) off) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_occ2020, replace)
restore


********** Panel
set graph on
grc1leg inc_occ2010 inc_occ2016 inc_occ2020, leg(inc_occ2010) col(3)
graph export inc_occ_panel.pdf, replace

****************************************
* END




