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
* Gini by group (HH)
****************************************
cls
use"panelindiv_v0", clear


encode HHID_panel, gen(HHcode)
order HHID_panel HHcode

* 
foreach i in 2010 2016 2020 {
qui ineqdeco mainocc_annualincome_indiv if year==`i', by(HHcode)
foreach x in ge0 ge1 ge2 within_ge0 within_ge1 within_ge2 between_ge0 between_ge1 between_ge2 {
local `x'=round(r(`x'),0.001)
}
dis _skip(3) "GE(0)" _skip(2) "GE(1)" _skip(2) "GE(2)" _newline ///
"O" _skip(2) "`ge0'" _skip(3)"`ge1'" _skip(3) "`ge2'"  _newline ///
"W" _skip(2) "`within_ge0'" _skip(3) "`within_ge1'" _skip(3) "`within_ge2'"  _newline ///
"B" _skip(2) "`between_ge0'" _skip(3) "`between_ge1'" _skip(3) "`between_ge2'"
}

****************************************
* END









****************************************
* Trends in intra-
****************************************

********** Categories
cls
use"panel_v6", clear

* Stat
ta type year, col nofreq

* Graph
import excel "Shareintra.xlsx", sheet("Sheet1") firstrow clear
gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
drop year
order time
gen sum1=MsupW
gen sum2=sum1+WeqM
gen sum3=sum2+WsupM

twoway ///
(bar sum1 time, barwidth(.95)) ///
(rbar sum1 sum2 time, barwidth(.95)) ///
(rbar sum2 sum3 time, barwidth(.95)) ///
, ///
title("Household type by gender distribution of income", size(small)) ///
xlabel(1 2 3,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
legend(order(1 "(a) Men > Women" 2 "(b) Men = Women" 3 "(c) Women > Men") pos(6) col(2)) ///
aspectratio() scale(1.2) name(barshare, replace)


********** Intensity
cls
use"panel_v6", clear

drop if type==2
egen typetime=group(type time), label

fre typetime
label define typetime ///
1"2010" 2"2016-17" 3"2020-21" ///
4"2010" 5"2016-17" 6"2020-21", replace
label values typetime typetime

violinplot absdiffpercent, over(typetime) horizontal left dscale(2.8) noline range(-2 102) now ///
addplot(function y=-2.5, range(-2 102) lcolor(black) lpattern(shortdash)) ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Intra-household relative income gender gap", size(small)) ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ytick(-2.5) ytitle("(a) Men > Women          (c) Women > Men") ///
legend(order(7 "IQR" 14 "Median" 20 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(viodiff, replace)



********** Combine
graph combine barshare viodiff, name(comb, replace)
graph export "Intra.png", as(png) replace


****************************************
* END

















****************************************
* Intensity of inequalities: Ecart relatif
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
grc1leg vio1 vio2, col(1) title("Relative difference in income between men and women") name(comb, replace)
graph export "Intra.png", as(png) replace


***** Avec un seul graphique ?


****************************************
* END














****************************************
* Intensity of inequalities: Part women
****************************************
cls
use"panel_v6", clear


* Depth
tabstat sharewomen, stat(n mean q) by(year)


violinplot sharewomen, over(time) horizontal left dscale(2.8) noline range(-2 102) now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
subtitle("Sample 1: Men income < women income") ///
xtitle("Percent") xlabel(0(.1)1) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 28 households in 2010, 48 in 2016-17 and 94 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(vio1, replace)



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


