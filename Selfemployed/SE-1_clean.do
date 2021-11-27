cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
November 27, 2021
-----
TITLE: Cleaning for SE analysis

-------------------------
*/

global directory = "D:\Documents\_Thesis\Research-Selfemployed\Data"
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
use"$wave1", clear
keep HHID_panel INDID_panel caste jatis age sex relationshiptohead villageid working_pop annualincome_indiv annualincome_HH mainocc_occupation_indiv mainocc_profession_indiv mainocc_occupation_HH worker villageid
gen year=2010
save "$wave1-_temp", replace

use"$wave2", clear
keep HHID_panel INDID_panel caste jatis age sex relationshiptohead villageid working_pop annualincome_indiv annualincome_HH mainocc_occupation_indiv mainocc_profession_indiv mainocc_occupation_HH worker villageid livinghome
gen year=2016
save "$wave2-_temp", replace


use"$wave3", clear
keep HHID_panel INDID_panel caste jatis age sex relationshiptohead villageid working_pop annualincome_indiv annualincome_HH mainocc_occupation_indiv mainocc_profession_indiv mainocc_occupation_HH worker villageid livinghome INDID_left
gen dummyleft=0
replace dummyleft=1 if INDID_left!=.
drop INDID_left
gen year=2020


append using "$wave1-_temp"
append using "$wave2-_temp"

sort year HHID_panel INDID_panel
order HHID_panel INDID_panel year


label define occupcode 0"No occ" 1"Agri SE" 2"Agri casual" 3"Casual" 4"Reg non-quali" 5"Reg quali" 6"SE" 7"NREGA", modify



********** Deflater les valeurs
foreach x in annualincome_indiv annualincome_HH {
clonevar `x'_raw=`x'
replace `x'=`x'/10000 if year==2010
replace `x'=(`x'*(100/158))/10000 if year==2016
replace `x'=(`x'*(100/184))/10000 if year==2020
label var `x' "₹10k "
}



********** Time for graph
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time 



********** Jatis et caste
tab jatis caste
label define castecat 1"Dalits" 2"Middle" 3"Upper" 77"Other", modify


save"panel_v1", replace
erase "$wave1-_temp.dta"
erase "$wave2-_temp.dta"
****************************************
* END













****************************************
* Graph bar INDID + HH
****************************************
use"panel_v1", clear

set graph off

********** Moc des 15-70
preserve
drop if mainocc_occupation_indiv==.
drop if working_pop==1
*
tab mainocc_occupation_indiv year, m col nofreq
*
contract mainocc_occupation_indiv year, zero freq(moc_freq) perc(moc_pc)
foreach i in 2010 2016 2020{
egen tot_`i'=sum(moc_freq) if year==`i'
replace moc_pc=moc_freq*100/tot_`i' if tot_`i'!=.
}
separate moc_pc, by(year) veryshortlabel
*
graph bar moc_pc2010 moc_pc2016 moc_pc2020, ///
over(mainocc_occupation_indiv, label(angle(45))) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
blabel(bar, format(%5.1f) size(tiny)) ///
ytitle("%") ylabel(0(3)35) ymtick(0(1)36) ///
note("Occupation principale des 15-70 ans", size(vsmall)) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(evo_moc_1570, replace)
*
graph export "evo_moc_1570.pdf", replace
restore


********** Moc de ceux qui sont occupés
preserve
drop if mainocc_occupation_indiv==.
drop if working_pop==1
drop if working_pop==2
*
tab mainocc_occupation_indiv year, m col nofreq
*
contract mainocc_occupation_indiv year, zero freq(moc_freq) perc(moc_pc)
foreach i in 2010 2016 2020{
egen tot_`i'=sum(moc_freq) if year==`i'
replace moc_pc=moc_freq*100/tot_`i' if tot_`i'!=.
}
separate moc_pc, by(year) veryshortlabel
*
graph bar moc_pc2010 moc_pc2016 moc_pc2020, ///
over(mainocc_occupation_indiv, label(angle(45))) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
blabel(bar, format(%5.1f) size(tiny)) ///
ytitle("%") ylabel(0(3)35) ymtick(0(1)36) ///
note("Occupation principale des 15-70 ans occupés", size(vsmall)) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(evo_moc_1570act, replace)
*
graph export "evo_moc_1570act.pdf", replace
restore



********** Moc des HH
preserve
duplicates drop HHID_panel year, force
drop if mainocc_occupation_HH==.
*
tab mainocc_occupation_HH year, col
*
contract mainocc_occupation_HH year, zero freq(moc_freq) perc(moc_pc)
foreach i in 2010 2016 2020{
egen tot_`i'=sum(moc_freq) if year==`i'
replace moc_pc=moc_freq*100/tot_`i' if tot_`i'!=.
}
separate moc_pc, by(year) veryshortlabel
*
graph bar moc_pc2010 moc_pc2016 moc_pc2020, ///
over(mainocc_occupation_HH, label(angle(45))) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
blabel(bar, format(%5.1f) size(tiny)) ///
ytitle("%") ylabel(0(3)35) ymtick(0(1)36) ///
note("Occupation principale des ménages", size(vsmall)) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(evo_moc_HH, replace)
*
graph export "evo_moc_HH.pdf", replace
restore



********** Income des INDID
preserve
drop if mainocc_occupation_indiv==.
drop if working_pop==1
drop if working_pop==2
*
stripplot annualincome_indiv, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel() ymtick() ytitle() ///
note("Revenus des 15-70 ans occupés", size(vsmall)) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_indiv, replace)
graph export "inc_indiv.pdf", replace
*
stripplot annualincome_indiv if annualincome_indiv<50, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel() ymtick() ytitle() ///
note("Revenus des 15-70 ans occupés gagnant moins de 500k/py", size(vsmall)) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_indiv, replace)
graph export "inc_indiv500k.pdf", replace
*
stripplot annualincome_indiv if annualincome_indiv<10, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel() ymtick() ytitle() ///
note("Revenus des 15-70 ans occupés gagnant moins de 100k/py", size(vsmall)) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_indiv, replace)
graph export "inc_indiv100k.pdf", replace
restore


********** Income des HH
preserve
duplicates drop HHID_panel year, force
drop if mainocc_occupation_HH==.
*
stripplot annualincome_HH, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel() ymtick() ytitle() ///
note("Revenus des ménages", size(vsmall)) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_HH, replace)
graph export "inc_hh.pdf", replace
*
stripplot annualincome_HH if annualincome_HH<50, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel() ymtick() ytitle() ///
note("Revenus des ménages gagnant moins de 500k/py", size(vsmall)) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_HH, replace)
graph export "inc_hh500k.pdf", replace
*
stripplot annualincome_HH if annualincome_HH<10, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel() ymtick() ytitle() ///
note("Revenus des ménages gagnant moins de 100k/py", size(vsmall)) ///
msymbol(oh oh oh oh) mcolor(plr1 plg1 ply1 plb1) name(inc_hh, replace)
graph export "inc_hh100k.pdf", replace
restore

****************************************
* END




