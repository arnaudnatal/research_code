*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------



****************************************
* Gini by group
****************************************
cls
use"panelindiv_v0", clear

* By HH
encode HHID_panel, gen(HHcode)
order HHID_panel HHcode
qui ineqdeco mainocc_annualincome_indiv if year==2010, by(HHcode)
foreach x in ge0 ge1 ge2 within_ge0 within_ge1 within_ge2 between_ge0 between_ge1 between_ge2 {
local `x'=round(r(`x'),0.001)
}
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"O" _skip(2) "`ge0'" _skip(3)"`ge1'" _skip(3) "`ge2'"  _newline ///
"W" _skip(2) "`within_ge0'" _skip(3) "`within_ge1'" _skip(3) "`within_ge2'"  _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"

* By sex
qui ineqdeco mainocc_annualincome_indiv if year==2010, by(sex)
foreach x in ge0 ge1 ge2 within_ge0 within_ge1 within_ge2 between_ge0 between_ge1 between_ge2 {
local `x'=round(r(`x'),0.001)
}
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"O" _skip(2) "`ge0'" _skip(3)"`ge1'" _skip(3) "`ge2'"  _newline ///
"W" _skip(2) "`within_ge0'" _skip(3) "`within_ge1'" _skip(3) "`within_ge2'"  _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"

* By caste
qui ineqdeco mainocc_annualincome_indiv if year==2010, by(caste)
foreach x in ge0 ge1 ge2 within_ge0 within_ge1 within_ge2 between_ge0 between_ge1 between_ge2 {
local `x'=round(r(`x'),0.001)
}
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"O" _skip(2) "`ge0'" _skip(3)"`ge1'" _skip(3) "`ge2'"  _newline ///
"W" _skip(2) "`within_ge0'" _skip(3) "`within_ge1'" _skip(3) "`within_ge2'"  _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"


****************************************
* END









****************************************
* Path over time
****************************************
cls
use"panel_v6", clear


* Categories
ta type year
ta type year, col nofreq

* Graph
tabplot type year, percent(year) showval frame(100) name(G2)

****************************************
* END

















****************************************
* Intensity of inequalities
****************************************
cls
use"panel_v6", clear


* Depth
tabstat absdiffpercent if type==1, stat(n mean q) by(year)
tabstat absdiffpercent if type==3, stat(n mean q) by(year)

* Graph for M<W
violinplot absdiffpercent if type==1, over(time) horizontal left dscale(2.8) noline range(-2 102) now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
subtitle("Sample 1: Men income < women income") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 28 households in 2010, 48 in 2016-17 and 94 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio1, replace)

* Graph for M>W
violinplot absdiffpercent if type==3, over(time) horizontal left dscale(2.8) noline range(-2 102) now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
subtitle("Sample 2: Men income > women income") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 357 households in 2010, 412 in 2016-17 and 502 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio2, replace)

* Combine
grc1leg vio1 vio2, title("Relative difference in income between men and women") name(comb, replace)
graph export "Intra.png", as(png) replace


****************************************
* END
















****************************************
* Diff between groups
****************************************
cls
use"panel_v6", clear

cls
foreach i in 2010 2016 2020 {
foreach x in log_annualincome_HH log_assets_totalnoland remittnet_HH ownland housetitle HHsize HH_count_child sexratio nonworkersratio stem head_female head_age head_occ1 head_occ2 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage dummydemonetisation lock_2 lock_3 caste_2 caste_3 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 {
tabstat `x' if year==`i', stat(mean) by(type)
}
}


****************************************
* END


