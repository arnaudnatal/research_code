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
cls
use"panel_v5", clear

ta year

* Stat
ta year grpHH
ta year grpHH, row nofreq

ta year grpHH2
ta year grpHH2, row nofreq



********** Graph total
import excel "Shareintra.xlsx", sheet("Sheet1") firstrow clear
gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
drop year
order time

gen sum1=msup
gen sum2=sum1+equal
gen sum3=sum2+wsup
gen sum4=sum3+nowoinc
gen sum5=sum4+nomeinc

twoway ///
(bar sum1 time, barwidth(.95)) ///
(rbar sum1 sum2 time, barwidth(.95)) ///
(rbar sum2 sum3 time, barwidth(.95)) ///
(rbar sum3 sum4 time, barwidth(.95)) ///
(rbar sum4 sum5 time, barwidth(.95)) ///
, ///
title("Distribution of households by income of men" "and women for all households", size(small)) ///
xlabel(1 2 3,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
legend(order(1 "(a) Men > Women" 2 "(b) Men = Women" 3 "(c) Women > Men" 4 "(d) No income from women" 5 "(e) No income from men") pos(6) col(3)) ///
aspectratio() scale(1.2) name(barshare1, replace) note("{it:Note:} For 405 households in 2010, 491 in 2016-17, and 623 in 2020-21.", size(vsmall))


*********** Graph income
import excel "Shareintra.xlsx", sheet("Sheet2") firstrow clear
gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time
drop year
order time
gen sum1=msup
gen sum2=sum1+equal
gen sum3=sum2+wsup

twoway ///
(bar sum1 time, barwidth(.95)) ///
(rbar sum1 sum2 time, barwidth(.95)) ///
(rbar sum2 sum3 time, barwidth(.95)) ///
, ///
title("Distribution of households by income of men" "and women without zero income", size(small)) ///
xlabel(1 2 3,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
legend(order(1 "(a) Men > Women" 2 "(b) Men = Women" 3 "(c) Women > Men") pos(6) col(2)) ///
aspectratio() scale(1.2) name(barshare2, replace) note("{it:Note:} For 320 households in 2010, 426 in 2016-17, and 534 in 2020-21.", size(vsmall))


********** Combine
grc1leg barshare1 barshare2, name(comb, replace) 
graph export "Intra.png", as(png) replace

****************************************
* END













****************************************
* Intensity
****************************************
cls
use"panel_v5", clear

ta grpHH year
ta grpHH2 year

fre grpHH
drop if grpHH2==.
drop if grpHH2==2
ta grpHH2 year

egen typetime=group(grpHH2 time), label

fre typetime
label define typetime ///
1"2010" 2"2016-17" 3"2020-21" ///
4"2010" 5"2016-17" 6"2020-21", replace
label values typetime typetime

* Stat
tabstat absdiff_mshare if grpHH==3, stat(n mean q) by(year)
tabstat absdiff_mshare if grpHH==5, stat(n mean q) by(year)

* Graph
violinplot absdiff_mshare, over(typetime) horizontal left dscale(2.8) noline range(0 100) now ///
addplot(function y=-2.5, range(0 100) lcolor(black) lpattern(shortdash)) ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Intra-household relative income gender gap", size(small)) ///
xtitle("Percentage point") xlabel(0(10)100) ///
ylabel(,grid) ytick(-2.5) ytitle("(a) Men > Women       (c) Women > Men") ///
legend(order(7 "IQR" 14 "Median" 20 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(viodiff, replace) note("{it:Note:} For 298 households in 2010, 387 in 2016-17, and 493 in 2020-21.", size(vsmall))
graph export "Intensityintra.png", as(png) replace

****************************************
* END
















****************************************
* Deter path for all HH
****************************************
cls
use"panel_v5", clear

* GrpHH
fre grpHH
clonevar grpHHbis=grpHH
recode grpHHbis (4=3) (5=3)
fre grpHHbis
ta grpHH year, col nofreq
recode grpHH (3=5) (5=3)
ta grpHH, gen(grpHH_)

* Caste
ta grpHH caste, col nofreq 
ta grpHH caste, exp cchi2 chi2

* Head charact
tabstat head_female head_nonmarried head_widowseparated head_age, stat(mean) by(grpHH)

* Family charact
tabstat HHsize HH_count_child sexratio nbmale nbfemale stem wp_inactive_men_HH wp_inactive_women_HH wp_unoccupi_men_HH wp_unoccupi_women_HH wp_occupied_men_HH wp_occupied_women_HH wp_active_men_HH wp_active_women_HH, stat(mean) by(grpHH)

* Test de moyenne
cls
foreach y in head_female head_nonmarried head_widowseparated head_age HHsize HH_count_child sexratio nbmale nbfemale stem wp_inactive_men_HH wp_inactive_women_HH wp_unoccupi_men_HH wp_unoccupi_women_HH wp_occupied_men_HH wp_occupied_women_HH wp_active_men_HH wp_active_women_HH {
reg `y' ib(3).grpHHbis, noh baselevel
}


dunntest head_female, by(grpHH) ma(bonferroni)

****************************************
* END
