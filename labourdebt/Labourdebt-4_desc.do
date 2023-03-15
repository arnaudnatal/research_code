*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------







****************************************
* Stat desc: Y ind
****************************************
cls
use"panel_v3", clear


********** Macro
rename sind sind_total

global yvar sind_total sind_female sind_male sind_young sind_middle sind_old

********** Orga
keep year $yvar

foreach y in $yvar {
ta `y', gen(`y'_)
}

drop $yvar
collapse (mean) sind_total_1 sind_total_2 sind_total_3 sind_total_4 sind_total_5 sind_total_6 sind_total_7 sind_total_8 sind_total_9 sind_female_1 sind_female_2 sind_female_3 sind_female_4 sind_female_5 sind_male_1 sind_male_2 sind_male_3 sind_male_4 sind_male_5 sind_young_1 sind_young_2 sind_young_3 sind_young_4 sind_young_5 sind_middle_1 sind_middle_2 sind_middle_3 sind_middle_4 sind_middle_5 sind_middle_6 sind_old_1 sind_old_2 sind_old_3 sind_old_4, by(year)


reshape long sind_total_ sind_female_ sind_male_ sind_young_ sind_middle_ sind_old_, i(year) j(n)

foreach y in $yvar {
rename `y'_ `y'
replace `y'=`y'*100
}


********** sindividuals
set graph off

*** Total
twoway /// 
(connected sind_total n if year==2010, lp(solid) lc(gs3)) ///
(connected sind_total n if year==2016, lp(dash) lc(gs8)) ///
(connected sind_total n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)9) title("Total") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(sind_total, replace) graphregion(margin(zero))

*** Male
twoway /// 
(connected sind_male n if year==2010, lp(solid) lc(gs3)) ///
(connected sind_male n if year==2016, lp(dash) lc(gs8)) ///
(connected sind_male n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)9) title("Male") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(sind_male, replace) graphregion(margin(zero))


*** Female
twoway /// 
(connected sind_female n if year==2010, lp(solid) lc(gs3)) ///
(connected sind_female n if year==2016, lp(dash) lc(gs8)) ///
(connected sind_female n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)9) title("Female") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(sind_female, replace) graphregion(margin(zero))

*** Young
twoway /// 
(connected sind_young n if year==2010, lp(solid) lc(gs3)) ///
(connected sind_young n if year==2016, lp(dash) lc(gs8)) ///
(connected sind_young n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)9) title("Young") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(sind_young, replace) graphregion(margin(zero))

*** Middle
twoway /// 
(connected sind_middle n if year==2010, lp(solid) lc(gs3)) ///
(connected sind_middle n if year==2016, lp(dash) lc(gs8)) ///
(connected sind_middle n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)9) title("Middle") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(sind_middle, replace) graphregion(margin(zero))


*** Old
twoway /// 
(connected sind_old n if year==2010, lp(solid) lc(gs3)) ///
(connected sind_old n if year==2016, lp(dash) lc(gs8)) ///
(connected sind_old n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)9) title("Old") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(sind_old, replace) graphregion(margin(zero))



*** Combine
set graph on
grc1leg sind_total sind_male sind_female sind_young sind_middle sind_old, col(3) graphregion(margin(zero)) name(sind_comb, replace)
graph export "graph/yvar_sind.pdf", as(pdf) replace


****************************************
* END













****************************************
* Stat desc: Y snbo
****************************************
cls
use"panel_v3", clear


********** Macro
rename snbo snbo_total

global yvar snbo_total snbo_female snbo_male snbo_young snbo_middle snbo_old

********** Orga
keep year $yvar

foreach y in $yvar {
ta `y', gen(`y'_)
}

drop $yvar
collapse (mean) snbo_total_1 snbo_total_2 snbo_total_3 snbo_total_4 snbo_total_5 snbo_total_6 snbo_total_7 snbo_total_8 snbo_total_9 snbo_total_10 snbo_total_11 snbo_total_12 snbo_total_13 snbo_total_14 snbo_female_1 snbo_female_2 snbo_female_3 snbo_female_4 snbo_female_5 snbo_female_6 snbo_female_7 snbo_female_8 snbo_female_9 snbo_male_1 snbo_male_2 snbo_male_3 snbo_male_4 snbo_male_5 snbo_male_6 snbo_male_7 snbo_male_8 snbo_young_1 snbo_young_2 snbo_young_3 snbo_young_4 snbo_young_5 snbo_young_6 snbo_young_7 snbo_young_8 snbo_young_9 snbo_middle_1 snbo_middle_2 snbo_middle_3 snbo_middle_4 snbo_middle_5 snbo_middle_6 snbo_middle_7 snbo_middle_8 snbo_middle_9 snbo_middle_10 snbo_middle_11 snbo_middle_12 snbo_old_1 snbo_old_2 snbo_old_3 snbo_old_4 snbo_old_5 snbo_old_6, by(year)


reshape long snbo_total_ snbo_female_ snbo_male_ snbo_young_ snbo_middle_ snbo_old_, i(year) j(n)

foreach y in $yvar {
rename `y'_ `y'
replace `y'=`y'*100
}


********** snbo
set graph off

*** Total
twoway /// 
(connected snbo_total n if year==2010, lp(solid) lc(gs3)) ///
(connected snbo_total n if year==2016, lp(dash) lc(gs8)) ///
(connected snbo_total n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)14) title("Total") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(snbo_total, replace) graphregion(margin(zero))

*** Male
twoway /// 
(connected snbo_male n if year==2010, lp(solid) lc(gs3)) ///
(connected snbo_male n if year==2016, lp(dash) lc(gs8)) ///
(connected snbo_male n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)14) title("Male") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(snbo_male, replace) graphregion(margin(zero))


*** Female
twoway /// 
(connected snbo_female n if year==2010, lp(solid) lc(gs3)) ///
(connected snbo_female n if year==2016, lp(dash) lc(gs8)) ///
(connected snbo_female n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)14) title("Female") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(snbo_female, replace) graphregion(margin(zero))

*** Young
twoway /// 
(connected snbo_young n if year==2010, lp(solid) lc(gs3)) ///
(connected snbo_young n if year==2016, lp(dash) lc(gs8)) ///
(connected snbo_young n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)14) title("Young") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(snbo_young, replace) graphregion(margin(zero))

*** Middle
twoway /// 
(connected snbo_middle n if year==2010, lp(solid) lc(gs3)) ///
(connected snbo_middle n if year==2016, lp(dash) lc(gs8)) ///
(connected snbo_middle n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)14) title("Middle") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(snbo_middle, replace) graphregion(margin(zero))


*** Old
twoway /// 
(connected snbo_old n if year==2010, lp(solid) lc(gs3)) ///
(connected snbo_old n if year==2016, lp(dash) lc(gs8)) ///
(connected snbo_old n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)14) title("Old") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(snbo_old, replace) graphregion(margin(zero))



*** Combine
set graph on
grc1leg snbo_total snbo_male snbo_female snbo_young snbo_middle snbo_old, col(3) graphregion(margin(zero)) name(snbo_comb, replace)
graph export "graph/yvar_snbo.pdf", as(pdf) replace

****************************************
* END

















****************************************
* Stat desc: X
****************************************
cls
use"panel_v3", clear


********** FVI
set graph off
stripplot fvi, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_fvi_horiz, replace)
graph export "graph/Distri_fvi.pdf", as(pdf) replace
set graph on

********** Other X

*** Economics
tabstat remittnet_HH assets_total annualincome_HH shareform, stat(n mean cv p50) by(year)


*** Head
ta head_female 
tabstat head_age, stat(n mean cv p50)
ta head_educ


*** Family
* Compo no. 1
tabstat dalits caste_1 caste_2 caste_3 stem log_HHsize share_female share_children share_young share_old share_stock, stat(n mean cv p50) by(time)


* Compo no. 2
tabstat dalits caste_1 caste_2 caste_3 stem HHsize HH_count_child sexratio dependencyratio share_stock, stat(n mean cv p50) by(time)

****************************************
* END




















****************************************
* Stat desc: Correlation
****************************************
cls
use"panel_v3", clear

xtset panelvar time

*** Corr
pwcorr fvi ///
sind sind_female sind_male sind_young sind_middle sind_old ///
snbo snbo_male snbo_female snbo_young snbo_middle snbo_old, sig

pwcorr L.fvi ///
sind sind_female sind_male sind_young sind_middle sind_old ///
snbo snbo_male snbo_female snbo_young snbo_middle snbo_old, sig


****************************************
* END















****************************************
* Stat desc: Correlation
****************************************
cls
use"panel_v3", clear


*** Panel
xtset panelvar time


*** OLS by caste
global nonvar caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total annualincome_HH shareform
global compo1 log_HHsize share_female share_children share_young share_old share_stock
global yvar sind sind_female sind_male sind_young sind_middle sind_old snbo snbo_male snbo_female snbo_young snbo_middle snbo_old

* FE instead of ML-SEM
foreach y in snbo_female {
xtreg `y' L.fvi $compo1 $econ $head $nonvar, fe
}

* Interaction
foreach y in snbo_female {
xtreg `y' L.c.fvi##i.caste $compo1 $econ $head $nonvar, fe
}

* Dalits
foreach y in snbo_female {
xtreg `y' L.fvi $compo1 $econ $head $nonvar if caste==1, fe
}

* Middle
foreach y in snbo_female {
xtreg `y' L.fvi $compo1 $econ $head $nonvar if caste==2, fe
}

* Upper
foreach y in snbo_female {
xtreg `y' L.fvi $compo1 $econ $head $nonvar if caste==3, fe
}


****************************************
* END









