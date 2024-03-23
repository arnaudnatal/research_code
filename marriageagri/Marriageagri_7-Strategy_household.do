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
* Non-agricultural income
****************************************
cls
use"panel_HH.dta", clear


* Global
catplot divHH10 time, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Total") ///
legend(pos(6) col(3)) name(tot, replace)


*****  Caste
set graph off
* Dalits
catplot divHH10 time if caste==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Dalits") ///
legend(pos(6) col(3)) name(dal, replace)

* Middle
catplot divHH10 time if caste==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Middle castes") ///
legend(pos(6) col(3)) name(mid, replace)

* Uppers
catplot divHH10 time if caste==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("Upper castes") ///
legend(pos(6) col(3)) name(upp, replace)

* Combine
set graph on
grc1leg tot dal mid upp, name(comb_caste, replace)
graph export "graph/diversification_caste.png", as(png) replace



***** Income
set graph off
* T1
catplot divHH10 time if income_q==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T1 of income") ///
legend(pos(6) col(3)) name(inc1, replace)

* T2
catplot divHH10 time if income_q==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T2 of income") ///
legend(pos(6) col(3)) name(inc2, replace)

* T3
catplot divHH10 time if income_q==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T3 of income") ///
legend(pos(6) col(3)) name(inc3, replace)

* Combine
set graph on
grc1leg tot inc1 inc2 inc3, name(comb_inc, replace)
graph export "graph/diversification_income.png", as(png) replace




***** Assets
set graph off
* T1
catplot divHH10 time if assets_q==1, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T1 of assets") ///
legend(pos(6) col(3)) name(ass1, replace)

* T2
catplot divHH10 time if assets_q==2, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T2 of assets") ///
legend(pos(6) col(3)) name(ass2, replace)

* T3
catplot divHH10 time if assets_q==3, percent(time) asyvars stack vert ///
bar(1, color(gs0)) bar(2, color(gs7))  bar(3, color(gs12)) ///
ylabel(0(10)100) ymtick(0(5)100) ///
ytitle("Percent") title("T3 of assets") ///
legend(pos(6) col(3)) name(ass3, replace)

* Combine
set graph on
grc1leg tot ass1 ass2 ass3, name(comb_ass, replace)
graph export "graph/diversification_assets.png", as(png) replace




********** Increasing share of non-agricultural income 2

***** Caste
use"panel_HH.dta", clear

collapse (mean) annualincome_HH incomenonagri_HH incomeagri_HH shareincomenonagri_HH shareincomeagri_HH, by(caste year)
replace incomenonagri_HH=incomenonagri_HH/10000

twoway ///
(line shareincomenonagri_HH year if caste==1) ///
(line shareincomenonagri_HH year if caste==2) ///
(line shareincomenonagri_HH year if caste==3) ///
, ytitle("Average share of non-agricultural income (%)") ylabel(.3(.1).9) ///
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
, ytitle("Average share of non-agricultural income (%)") ylabel(.3(.1).9) ///
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
, ytitle("Average share of non-agricultural income (%)") ylabel(.3(.1).9) ///
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
graph export "graph/average_share_diversi.png", as(png) replace

graph combine line_caste2 line_income2 line_assets2, col(3) name(line_comb2, replace)
graph export "graph/average_amount_diversi.png", as(png) replace


****************************************
* END












****************************************
* Investment in education
****************************************

********** Stat
cls
use"panel_HH.dta", clear

* Selection
drop if year==2010
recode educexp_male_HH educexp_female_HH (0=.)
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000


* Share
ta dumeducexp_male_HH year, col nofreq
ta dumeducexp_male_HH year if caste==1, col nofreq
ta dumeducexp_male_HH year if caste==2, col nofreq
ta dumeducexp_male_HH year if caste==3, col nofreq

ta dumeducexp_female_HH year, col nofreq
ta dumeducexp_female_HH year if caste==1, col nofreq
ta dumeducexp_female_HH year if caste==2, col nofreq
ta dumeducexp_female_HH year if caste==3, col nofreq


* Amount
tabstat educexp_male_HH educexp_female_HH, stat(n mean q min max) by(year) long
tabstat educexp_male_HH educexp_female_HH if caste==1, stat(n mean) by(year) long
tabstat educexp_male_HH educexp_female_HH if caste==2, stat(n mean) by(year) long
tabstat educexp_male_HH educexp_female_HH if caste==3, stat(n mean) by(year) long



********** Graph
cls
use"panel_HH.dta", clear

* Selection
drop if year==2010
recode educexp_male_HH educexp_female_HH (0=.)
replace educexp_male_HH=educexp_male_HH/1000
replace educexp_female_HH=educexp_female_HH/1000

* Format
collapse (mean) dumeducexp_male_HH dumeducexp_female_HH educexp_male_HH educexp_female_HH, by(caste time)

rename dumeducexp_male_HH dumeducexp1
rename dumeducexp_female_HH dumeducexp2
rename educexp_male_HH educexp1
rename educexp_female_HH educexp2

reshape long dumeducexp educexp, i(caste time) j(sex)
label define sex 1"Males" 2"Females"
label values sex sex

* Share
graph bar (mean) dumeducexp, over(time) over(sex) over(caste) ///
ytitle("Percent") ylabel(0(.1).6) ymtick(0(.05).6) ///
title("Share of households investing in education") ///
legend(pos(6) col(2)) name(share, replace)

* Amount invested
graph bar (mean) educexp, over(time) over(sex) over(caste) ///
ytitle("INR 1k") ylabel(0(2)22) ymtick(0(1)22) ///
title("Average amount invested in education") ///
legend(pos(6) col(2)) name(amount, replace)

* Comb
grc1leg share amount, name(comb, replace)
graph export "graph/Education_expenses.png", as(png) replace



****************************************
* END












****************************************
* Investment in housing
****************************************
cls
use"panel_HH.dta", clear

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













****************************************
* Land by caste
****************************************
cls
use"panel_HH.dta", clear

* Caste and jatis
ta jatis caste
clonevar jatis_str=jatis
encode jatis, gen(jatis_enc)
drop jatis
rename jatis_enc jatis

* Acre to hectar
replace assets_sizeownland=assets_sizeownland*0.404686
tabstat assets_sizeownland, stat(n mean) by(year)

* Collapse
gen n=1
collapse (sum) sizeownland n ownland (mean) assets_sizeownland, by(year jatis)

* Size by jatis and average size
bysort year: egen total_land=sum(sizeownland)
bysort year: egen total_n=sum(n)
bysort year: egen total_ownland=sum(ownland)
gen share_land=sizeownland*100/total_land
gen share_own=ownland*100/total_ownland
drop if ownland==0

* Graph share total land
ta share_land
graph bar (mean) share_land, over(year, lab(nolab)) over(jatis, lab(angle(45))) asyvars ///
bar(1, fcolor(gs0)) bar(2, fcolor(gs7)) bar(3, fcolor(gs14)) ///
ytitle("Percent") ylabel(0(10)60) ymtick(0(5)60) ///
title("Share of total land area held by each jati") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(area, replace)

* Graph average size
ta assets_sizeownland
graph bar (mean) assets_sizeownland, over(year, lab(nolab)) over(jatis, lab(angle(45))) asyvars ///
bar(1, fcolor(gs0)) bar(2, fcolor(gs7)) bar(3, fcolor(gs14)) ///
ytitle("Hectar") ylabel(0(0.5)3.5) ymtick(0(.25)3.5) ///
title("Average area of land held by each jati") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(average, replace)

* Comb
grc1leg area average, name(com, replace) col(2)
graph export "graph/land_jatis.png", as(png) replace

****************************************
* END
