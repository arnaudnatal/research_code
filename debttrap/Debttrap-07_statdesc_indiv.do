*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*October 07, 2024
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------












****************************************
* Stat desc
****************************************
use"panel_indiv_v3", clear

********** Transfo pour simplifier les stat
replace totindiv_givenamt_repa=totindiv_givenamt_repa/1000
replace totindiv_effectiveamt_repa=totindiv_effectiveamt_repa/1000

replace gtdr_indiv=gtdr_indiv*100
replace etdr_indiv=etdr_indiv*100
replace gtir_indiv=gtir_indiv*100
replace etir_indiv=etir_indiv*100

********** Dummy loans
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1


********** Given
*** Total
ta dumindiv_given_repa year, col
tabstat totindiv_givenamt_repa if dumindiv_given_repa==1, stat(mean med) by(year)
tabstat gtdr_indiv if dumindiv_given_repa==1, stat(mean med) by(year)
tabstat gtir_indiv if dumindiv_given_repa==1, stat(mean med) by(year)

*** Men
ta dumindiv_given_repa year if sex==1, col
tabstat totindiv_givenamt_repa if dumindiv_given_repa==1 & sex==1, stat(mean med) by(year)
tabstat gtdr_indiv if dumindiv_given_repa==1 & sex==1, stat(mean med) by(year)
tabstat gtir_indiv if dumindiv_given_repa==1 & sex==1, stat(mean med) by(year)

*** Women
ta dumindiv_given_repa year if sex==2, col
tabstat totindiv_givenamt_repa if dumindiv_given_repa==1 & sex==2, stat(mean med) by(year)
tabstat gtdr_indiv if dumindiv_given_repa==1 & sex==2, stat(mean med) by(year)
tabstat gtir_indiv if dumindiv_given_repa==1 & sex==2, stat(mean med) by(year)



********** Effective
*** Total
ta dumindiv_effective_repa year, col
tabstat totindiv_effectiveamt_repa if dumindiv_effective_repa==1, stat(mean med) by(year)
tabstat etdr_indiv if dumindiv_effective_repa==1, stat(mean med) by(year)
tabstat etir_indiv if dumindiv_effective_repa==1, stat(mean med) by(year)

*** Men
ta dumindiv_effective_repa year if sex==1, col
tabstat totindiv_effectiveamt_repa if dumindiv_effective_repa==1 & sex==1, stat(mean med) by(year)
tabstat etdr_indiv if dumindiv_effective_repa==1 & sex==1, stat(mean med) by(year)
tabstat etir_indiv if dumindiv_effective_repa==1 & sex==1, stat(mean med) by(year)

*** Women
ta dumindiv_effective_repa year if sex==2, col
tabstat totindiv_effectiveamt_repa if dumindiv_effective_repa==1 & sex==2, stat(mean med) by(year)
tabstat etdr_indiv if dumindiv_effective_repa==1 & sex==2, stat(mean med) by(year)
tabstat etir_indiv if dumindiv_effective_repa==1 & sex==2, stat(mean med) by(year)

****************************************
* END















****************************************
* Stat desc
****************************************
use"panel_indiv_v3", clear

********** Cas concret pour être sûr de la sélection
preserve
keep if year==2020
bysort HHID_panel: gen n=_N
ta n
keep if n==6
drop n
sort HHID_panel INDID_panel
ta etdr
keep if etdr>.6
keep HHID_panel INDID_panel sex etdr etdr_indiv share_etdr totindiv_givenamt_repa totindiv_effectiveamt_repa dumHH_given_repa dumHH_effective_repa totHH_givenamt_repa totHH_effectiveamt_repa dummyloans_indiv loanamount_indiv loanamount_HH
restore


********** Transfo pour mieux lire les stat desc
replace share_etdr=share_etdr*100
replace share_gtdr=share_gtdr*100


********** Share for indebted households
keep if dummyloans_HH==1
tabstat share_etdr if year==2016, stat(n mean q) by(sex)
tabstat share_etdr if year==2020, stat(n mean q) by(sex)


********** Share for indebted individuals
keep if dummyloans_indiv==1
tabstat share_etdr if year==2016, stat(n mean q) by(sex)
tabstat share_etdr if year==2020, stat(n mean q) by(sex)


********** Share for trapped individuals
keep if dumindiv_effective_repa==1
tabstat share_etdr if year==2016, stat(n mean q) by(sex)
tabstat share_etdr if year==2020, stat(n mean q) by(sex)



****************************************
* END










****************************************
* Nb of individuals concerned
****************************************
use"panel_indiv_v3", clear

* Prepa data
gen total=1
collapse (sum) total dummyloans_indiv dumindiv_given_repa, by(time)
rename dummyloans_indiv indebt
rename dumindiv_given_repa intrap
gen sum1=intra*100/indebt
gen sum2=100


* 2010 - 2016
twoway ///
(bar sum1 time, barwidth(.9)) ///
(rbar sum1 sum2 time, barwidth(.9)) ///
, ///
xlabel(2 3,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("") ///
legend(order(1 "In a trap" 2 "Not in a trap") pos(6) col(2)) ///
note("{it:Note:} For 924 individuals in 2016-17 and 1317 in 2020-21.", size(small)) ///
name(intrap_indiv, replace)
graph export "Intrap_indiv.png", as(png) replace


****************************************
* END














****************************************
* Amount and ratio with graph
****************************************
use"panel_indiv_v3", clear

* Selection
keep if dummyloans_indiv==1
keep if dumindiv_given_repa==1


* Amount
tabstat totindiv_givenamt_repa, stat(n q p90 p95 p99 max) by(year)
replace totindiv_givenamt_repa=totindiv_givenamt_repa/1000
tabstat totindiv_givenamt_repa, stat(n q p90 p95 p99 max) by(year)

violinplot totindiv_givenamt_repa, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Amount of debt dedicated to" "debt repayment") ///
xtitle("1k rupees") xlabel(0(20)200) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 83 individuals in 2016-17 and 361 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(amount_indiv, replace) range(0 200)


* Ratio
tabstat gtdr_indiv, stat(n q p90 p95 p99 max) by(year)
replace gtdr_indiv=gtdr_indiv*100
tabstat gtdr_indiv, stat(n q p90 p95 p99 max) by(year)

violinplot gtdr_indiv, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Ratio of debt dedicated to debt" "repayment to total debt") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 83 individuals in 2016-17 and 361 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(ratio_indiv, replace) range(0 100)

grc1leg amount_indiv ratio_indiv
graph export "Trap_indiv.png", as(png) replace

****************************************
* END




















****************************************
* By sex
****************************************
use"panel_indiv_v3", clear

* Selection 1
ta dummyloans_indiv year, m
ta dummyloans_indiv year, col
keep if dummyloans_indiv==1

* Qui supporte la plus grande part du dsr?
tabstat share_dsr if year==2016, stat(n mean q) by(sex)
tabstat share_dsr if year==2020, stat(n mean q) by(sex)

* Qui supporte la plus grande part de la trappe ?
preserve
keep if dumHH_given_repa==1
tabstat share_gtdr if year==2016, stat(n mean q) by(sex)
tabstat share_gtdr if year==2020, stat(n mean q) by(sex)
restore

* Recourse to debt trap
ta dumindiv_given_repa sex if year==2016, chi2 col nofreq
ta dumindiv_given_repa sex if year==2020, chi2 col nofreq
/*
Beaucoup plus les femmes que les hommes
*/

* Selection 2
keep if dumindiv_given_repa==1

* Amount of the trap
tabstat totindiv_givenamt_repa if year==2016, stat(n mean q) by(sex)
tabstat totindiv_givenamt_repa if year==2020, stat(n mean q) by(sex)
/*
Qui ont des montants plus élevés
*/

* Ratio
tabstat gtdr_indiv if year==2016, stat(n mean q) by(sex)
tabstat gtdr_indiv if year==2020, stat(n mean q) by(sex)
/*
Ca réprésente une part beaucoup plus importante de leur dette
*/



****************************************
* END





