*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 7, 2024
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
use"panel_HH_v3", clear

*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Given
ta dumHH_given_repa year, col
tabstat totHH_givenamt_repa if dumHH_given_repa==1, stat(n mean q) by(year)
tabstat gtdr if dumHH_given_repa==1, stat(n mean q) by(year)


* Effective
ta dumHH_effective_repa year, col
tabstat totHH_effectiveamt_repa if dumHH_effective_repa==1, stat(n mean q) by(year)
tabstat etdr if dumHH_effective_repa==1, stat(n mean q) by(year)


****************************************
* END











****************************************
* Nb of HH concerned
****************************************
use"panel_HH_v3", clear

* Prepa data
gen total=1
collapse (sum) total dummyloans_HH dumHH_given_repa, by(time)
rename dummyloans_HH indebt
rename dumHH_given_repa intrap
gen sum1=intra*100/indebt
gen sum2=100


* 2010 - 2016
twoway ///
(bar sum1 time, barwidth(.9)) ///
(rbar sum1 sum2 time, barwidth(.9)) ///
, ///
xlabel(1 2 3,valuelabel) xtitle("") ///
ylabel(0(10)100) ytitle("Percent") ///
title("") ///
legend(order(1 "In trap" 2 "Not in trap") pos(6) col(2)) ///
note("{it:Note:} For 405 households in 2010, 487 in 2016-17, and 622 in 2020-21.", size(small)) ///
name(intrap, replace)


****************************************
* END






















****************************************
* Amount and ratio with graph
****************************************
use"panel_HH_v3", clear

* Selection
keep if dummyloans_HH==1
keep if dumHH_given_repa==1


* Amount
tabstat totHH_givenamt_repa, stat(n q p90 p95 p99 max) by(year)
replace totHH_givenamt_repa=totHH_givenamt_repa/1000
tabstat totHH_givenamt_repa, stat(n q p90 p95 p99 max) by(year)

violinplot totHH_givenamt_repa, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Debt to repay debt") ///
xtitle("1k rupees") xlabel(0(20)200) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 75 households in 2010, 80 in 2016-17, and 285 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(amount, replace) range(0 200)


* Ratio
tabstat gtdr, stat(n q p90 p95 p99 max) by(year)
replace gtdr=gtdr*100
tabstat gtdr, stat(n q p90 p95 p99 max) by(year)

violinplot gtdr, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Debt to repay debt to total debt") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 75 households in 2010, 80 in 2016-17, and 285 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(ratio, replace) range(0 100)


****************************************
* END



















****************************************
* Debt composition
****************************************
use"panel_indiv_v3", clear


* Decile of debt
foreach i in 2010 2016 2020 {
xtile loangrp`i'=loanamount_HH if year==`i', n(10)
}
gen loangroup=.
foreach i in 2010 2016 2020 {
replace loangroup=loangrp`i' if year==`i'
drop loangrp`i' 
}

* Decile of income
foreach i in 2010 2016 2020 {
xtile incgrp`i'=annualincome_HH if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}

* Share source
rename totHH_lendercatamt_info info
rename totHH_lendercatamt_semi semi
rename totHH_lendercatamt_form form
gen s1=info+semi+form
foreach x in info semi form {
gen s_`x'=`x'*100/s1
}
drop s1
egen test=rowtotal(s_info s_semi s_form)
ta test
drop test

* Share use
rename totHH_givencatamt_econ econ
rename totHH_givencatamt_curr curr
rename totHH_givencatamt_huma huma
rename totHH_givencatamt_soci soci
rename totHH_givencatamt_hous hous
gen s2=econ+curr+huma+soci+hous
foreach x in econ curr huma soci hous {
gen s_`x'=`x'*100/s2
}
drop s2
egen test=rowtotal(s_econ s_curr s_huma s_soci s_hous)
ta test
drop test


********** By decile of debt
preserve
collapse (mean) s_info s_semi s_form s_econ s_curr s_huma s_soci s_hous, by(year loangroup)

gen sum1=s_info
gen sum2=sum1+s_semi
gen sum3=sum2+s_form

gen sum11=s_econ
gen sum21=sum11+s_curr
gen sum31=sum21+s_huma
gen sum41=sum31+s_soci
gen sum51=sum41+s_hous


***** Sources
foreach x in 2010 2016 2020 {
twoway ///
(area sum1 loangroup if year==`x') ///
(rarea sum1 sum2 loangroup if year==`x') ///
(rarea sum2 sum3 loangroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of loan amount per household") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Informal" 2 "Semi formal" 3 "Formal") pos(6) col(4)) ///
name(compo`x', replace)
}
grc1leg compo2010 compo2016 compo2020, name(compo_loan, replace) col(3)
graph export "Compo_loan.png", replace



****************************************
* END
