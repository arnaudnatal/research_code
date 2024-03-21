*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* Contextual elements
****************************************
/*
- What is the evolution over time of agriculture?
- What about the volatility of non-agricultural income?
- What about the investment in education?
- What about the investment in the house?
*/

cls
use"panel_HH.dta", clear


********** Decline of land ownership
ta ownland year, col nofreq


********** Increasing share of non-agricultural income

* Global
catplot divHH10 year, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Total") ///
legend(pos(6) col(3)) name(tot, replace)


*****  Caste
set graph off
* Dalits
catplot divHH10 year if caste==1, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Dalits") ///
legend(pos(6) col(3)) name(dal, replace)

* Middle
catplot divHH10 year if caste==2, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Middle castes") ///
legend(pos(6) col(3)) name(mid, replace)

* Uppers
catplot divHH10 year if caste==3, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Upper castes") ///
legend(pos(6) col(3)) name(upp, replace)

* Combine
set graph on
grc1leg tot dal mid upp, name(comb_caste, replace)
graph export "diversification_caste.png", as(png) replace



***** Income
set graph off
* T1
catplot divHH10 year if income_q==1, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T1 of income") ///
legend(pos(6) col(3)) name(inc1, replace)

* T2
catplot divHH10 year if income_q==2, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T2 of income") ///
legend(pos(6) col(3)) name(inc2, replace)

* T3
catplot divHH10 year if income_q==3, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T3 of income") ///
legend(pos(6) col(3)) name(inc3, replace)

* Combine
set graph on
grc1leg tot inc1 inc2 inc3, name(comb_inc, replace)
graph export "diversification_income.png", as(png) replace




***** Assets
set graph off
* T1
catplot divHH10 year if assets_q==1, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T1 of assets") ///
legend(pos(6) col(3)) name(ass1, replace)

* T2
catplot divHH10 year if assets_q==2, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T2 of assets") ///
legend(pos(6) col(3)) name(ass2, replace)

* T3
catplot divHH10 year if assets_q==3, percent(year) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T3 of assets") ///
legend(pos(6) col(3)) name(ass3, replace)

* Combine
set graph on
grc1leg tot ass1 ass2 ass3, name(comb_ass, replace)
graph export "diversification_assets.png", as(png) replace




********** Increasing share of non-agricultural income 2

***** Caste
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(caste year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if caste==1) ///
(line shareincomenonagri_HH year if caste==2) ///
(line shareincomenonagri_HH year if caste==3) ///
, ytitle("Share of non-agricultural income (%)") ylabel(.3(.1).9) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By caste") ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(3)) name(line_caste, replace)

twoway ///
(line incomenonagri_HH year if caste==1) ///
(line incomenonagri_HH year if caste==2) ///
(line incomenonagri_HH year if caste==3) ///
, ytitle("Non-agricultural income (INR 10k)") ylabel(0(2)16) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By caste") ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") pos(6) col(3)) name(line_caste2, replace)




***** Income
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(income_q year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if income_q==1) ///
(line shareincomenonagri_HH year if income_q==2) ///
(line shareincomenonagri_HH year if income_q==3) ///
, ytitle("Share of non-agricultural income (%)") ylabel(.3(.1).9) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By income") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_income, replace)

twoway ///
(line incomenonagri_HH year if income_q==1) ///
(line incomenonagri_HH year if income_q==2) ///
(line incomenonagri_HH year if income_q==3) ///
, ytitle("Non-agricultural income (INR 10k)") ylabel(0(2)16) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By income") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_income2, replace)


***** Assets
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(assets_q year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if assets_q==1) ///
(line shareincomenonagri_HH year if assets_q==2) ///
(line shareincomenonagri_HH year if assets_q==3) ///
, ytitle("Share of non-agricultural income (%)") ylabel(.3(.1).9) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By assets") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_assets, replace)

twoway ///
(line incomenonagri_HH year if assets_q==1) ///
(line incomenonagri_HH year if assets_q==2) ///
(line incomenonagri_HH year if assets_q==3) ///
, ytitle("Non-agricultural income (INR 10k)") ylabel(0(2)16) ///
xtitle("") xlabel(2010 2016 2020) ///
title("By assets") ///
legend(order(1 "Terc.1" 2 "Terc.2" 3 "Terc.3") pos(6) col(3)) name(line_assets2, replace)

***** Comb
graph combine line_caste line_income line_assets, col(3) name(line_comb, replace)
graph export "line_rel_diversi.png", as(png) replace

graph combine line_caste2 line_income2 line_assets2, col(3) name(line_comb2, replace)
graph export "line_abs_diversi.png", as(png) replace






********** Investment in education
* Share
ta dumeducexp_male_HH year, col nofreq

ta dumeducexp_female_HH year, col nofreq

* Amount
preserve
replace educexp_male_HH=educexp_male_HH/1000
tabstat educexp_male_HH if dumeducexp_male_HH==1, stat(n mean p50) by(year) long
restore

preserve
replace educexp_female_HH=educexp_female_HH/1000
tabstat educexp_female_HH if dumeducexp_female_HH==1, stat(n mean p50) by(year) long
restore

* Tests
ttest educexp_male_HH==educexp_female_HH
ttest educexp_male_HH==educexp_female_HH, unpaired
ttest educexp_male_HH==educexp_female_HH, unpaired unequal



********** Dépenses d'habitation
* Share
ta dumHH_given_hous year, col nofreq

ta dumHH_effective_hous year, col nofreq


* Absolut
preserve
replace totHH_givenamt_hous=totHH_givenamt_hous/1000
tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0, stat(n mean p50) by(year) long
restore

preserve
replace totHH_effectiveamt_hous=totHH_effectiveamt_hous/1000
tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0, stat(n mean p50) by(year) long
restore


* Relative
preserve
replace totHH_givenamt_hous=(totHH_givenamt_hous/annualincome_HH)*100
tabstat totHH_givenamt_hous if totHH_givenamt_hous!=0, stat(n mean p50) by(year) long
restore

preserve
replace totHH_effectiveamt_hous=(totHH_effectiveamt_hous/annualincome_HH)*100
tabstat totHH_effectiveamt_hous if totHH_effectiveamt_hous!=0, stat(n mean p50) by(year) long
restore


****************************************
* END




