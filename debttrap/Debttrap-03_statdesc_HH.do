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
ta giv_trap year, col
tabstat giv_trapamount if giv_trap==1, stat(mean med) by(year)
tabstat gtdr if giv_trap==1, stat(mean med) by(year)
tabstat gtar if giv_trap==1, stat(mean med) by(year)


* Effective
ta eff_trap year, col
tabstat eff_trapamount if eff_trap==1, stat(mean med) by(year)
tabstat etdr if eff_trap==1, stat(mean med) by(year)
tabstat etar if eff_trap==1, stat(mean med) by(year)

****************************************
* END













****************************************
* Caste and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

*** Dummy
ta giv_trap caste if year==2010, col nofreq chi2
ta giv_trap caste if year==2016, col nofreq chi2
ta giv_trap caste if year==2020, col nofreq chi2

*** Amount
keep if giv_trap==1
tabstat giv_trapamount if year==2010, stat(n mean q) by(caste)
tabstat giv_trapamount if year==2016, stat(n mean q) by(caste)
tabstat giv_trapamount if year==2020, stat(n mean q) by(caste)

*** Ratio dette
replace gtdr=gtdr*100
tabstat gtdr if year==2010, stat(n mean q) by(caste)
tabstat gtdr if year==2016, stat(n mean q) by(caste)
tabstat gtdr if year==2020, stat(n mean q) by(caste)

*** Ratio actifs
replace gtar=gtar*100
tabstat gtar if year==2010, stat(n mean q) by(caste)
tabstat gtar if year==2016, stat(n mean q) by(caste)
tabstat gtar if year==2020, stat(n mean q) by(caste)




********** Effective trap
use"panel_HH_v3", clear

*** Dummy
ta eff_trap caste if year==2010, col nofreq chi2
ta eff_trap caste if year==2016, col nofreq chi2
ta eff_trap caste if year==2020, col nofreq chi2

*** Amount
keep if eff_trap==1
tabstat eff_trapamount if year==2010, stat(n mean q) by(caste)
tabstat eff_trapamount if year==2016, stat(n mean q) by(caste)
tabstat eff_trapamount if year==2020, stat(n mean q) by(caste)

*** Ratio dette
replace etdr=etdr*100
tabstat etdr if year==2010, stat(n mean q) by(caste)
tabstat etdr if year==2016, stat(n mean q) by(caste)
tabstat etdr if year==2020, stat(n mean q) by(caste)

*** Ratio actifs
replace etar=etar*100
tabstat etar if year==2010, stat(n mean q) by(caste)
tabstat etar if year==2016, stat(n mean q) by(caste)
tabstat etar if year==2020, stat(n mean q) by(caste)

****************************************
* END














****************************************
* Income and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

replace annualincome_HH=annualincome_HH/1000

*** Dummy
tabstat annualincome_HH if year==2010, stat(n mean q) by(giv_trap)
tabstat annualincome_HH if year==2016, stat(n mean q) by(giv_trap)
tabstat annualincome_HH if year==2020, stat(n mean q) by(giv_trap)

*** Amount
keep if giv_trap==1
pwcorr giv_trapamount annualincome_HH if year==2010, sig
pwcorr giv_trapamount annualincome_HH if year==2016, sig
pwcorr giv_trapamount annualincome_HH if year==2020, sig
spearman giv_trapamount annualincome_HH if year==2010, stats(rho p)
spearman giv_trapamount annualincome_HH if year==2016, stats(rho p)
spearman giv_trapamount annualincome_HH if year==2020, stats(rho p)

*** Ratio dette
replace gtdr=gtdr*100
pwcorr gtdr annualincome_HH if year==2010, sig
pwcorr gtdr annualincome_HH if year==2016, sig
pwcorr gtdr annualincome_HH if year==2020, sig
spearman gtdr annualincome_HH if year==2010, stats(rho p)
spearman gtdr annualincome_HH if year==2016, stats(rho p)
spearman gtdr annualincome_HH if year==2020, stats(rho p)

*** Ratio actifs
replace gtar=gtar*100
pwcorr gtar annualincome_HH if year==2010, sig
pwcorr gtar annualincome_HH if year==2016, sig
pwcorr gtar annualincome_HH if year==2020, sig
spearman gtar annualincome_HH if year==2010, stats(rho p)
spearman gtar annualincome_HH if year==2016, stats(rho p)
spearman gtar annualincome_HH if year==2020, stats(rho p)







********** Effective trap
use"panel_HH_v3", clear

replace annualincome_HH=annualincome_HH/1000

*** Dummy
tabstat annualincome_HH if year==2010, stat(n mean q) by(eff_trap)
tabstat annualincome_HH if year==2016, stat(n mean q) by(eff_trap)
tabstat annualincome_HH if year==2020, stat(n mean q) by(eff_trap)

*** Amount
keep if eff_trap==1
pwcorr eff_trapamount annualincome_HH if year==2010, sig
pwcorr eff_trapamount annualincome_HH if year==2016, sig
pwcorr eff_trapamount annualincome_HH if year==2020, sig
spearman eff_trapamount annualincome_HH if year==2010, stats(rho p)
spearman eff_trapamount annualincome_HH if year==2016, stats(rho p)
spearman eff_trapamount annualincome_HH if year==2020, stats(rho p)

*** Ratio dette
replace etdr=etdr*100
pwcorr etdr annualincome_HH if year==2010, sig
pwcorr etdr annualincome_HH if year==2016, sig
pwcorr etdr annualincome_HH if year==2020, sig
spearman etdr annualincome_HH if year==2010, stats(rho p)
spearman etdr annualincome_HH if year==2016, stats(rho p)
spearman etdr annualincome_HH if year==2020, stats(rho p)

*** Ratio actifs
replace etar=etar*100
pwcorr etar annualincome_HH if year==2010, sig
pwcorr etar annualincome_HH if year==2016, sig
pwcorr etar annualincome_HH if year==2020, sig
spearman etar annualincome_HH if year==2010, stats(rho p)
spearman etar annualincome_HH if year==2016, stats(rho p)
spearman etar annualincome_HH if year==2020, stats(rho p)

****************************************
* END

















****************************************
* Wealth and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

*** Dummy
tabstat assets_total1000 if year==2010, stat(n mean q) by(giv_trap)
tabstat assets_total1000 if year==2016, stat(n mean q) by(giv_trap)
tabstat assets_total1000 if year==2020, stat(n mean q) by(giv_trap)

*** Amount
keep if giv_trap==1
pwcorr giv_trapamount assets_total1000 if year==2010, sig
pwcorr giv_trapamount assets_total1000 if year==2016, sig
pwcorr giv_trapamount assets_total1000 if year==2020, sig
spearman giv_trapamount assets_total1000 if year==2010, stats(rho p)
spearman giv_trapamount assets_total1000 if year==2016, stats(rho p)
spearman giv_trapamount assets_total1000 if year==2020, stats(rho p)

*** Ratio dette
replace gtdr=gtdr*100
pwcorr gtdr assets_total1000 if year==2010, sig
pwcorr gtdr assets_total1000 if year==2016, sig
pwcorr gtdr assets_total1000 if year==2020, sig
spearman gtdr assets_total1000 if year==2010, stats(rho p)
spearman gtdr assets_total1000 if year==2016, stats(rho p)
spearman gtdr assets_total1000 if year==2020, stats(rho p)

*** Ratio actifs
replace gtar=gtar*100
pwcorr gtar assets_total1000 if year==2010, sig
pwcorr gtar assets_total1000 if year==2016, sig
pwcorr gtar assets_total1000 if year==2020, sig
spearman gtar assets_total1000 if year==2010, stats(rho p)
spearman gtar assets_total1000 if year==2016, stats(rho p)
spearman gtar assets_total1000 if year==2020, stats(rho p)







********** Effective trap
use"panel_HH_v3", clear

*** Dummy
tabstat assets_total1000 if year==2010, stat(n mean q) by(eff_trap)
tabstat assets_total1000 if year==2016, stat(n mean q) by(eff_trap)
tabstat assets_total1000 if year==2020, stat(n mean q) by(eff_trap)

*** Amount
keep if eff_trap==1
pwcorr eff_trapamount assets_total1000 if year==2010, sig
pwcorr eff_trapamount assets_total1000 if year==2016, sig
pwcorr eff_trapamount assets_total1000 if year==2020, sig
spearman eff_trapamount assets_total1000 if year==2010, stats(rho p)
spearman eff_trapamount assets_total1000 if year==2016, stats(rho p)
spearman eff_trapamount assets_total1000 if year==2020, stats(rho p)

*** Ratio dette
replace etdr=etdr*100
pwcorr etdr assets_total1000 if year==2010, sig
pwcorr etdr assets_total1000 if year==2016, sig
pwcorr etdr assets_total1000 if year==2020, sig
spearman etdr assets_total1000 if year==2010, stats(rho p)
spearman etdr assets_total1000 if year==2016, stats(rho p)
spearman etdr assets_total1000 if year==2020, stats(rho p)

*** Ratio actifs
replace etar=etar*100
pwcorr etar assets_total1000 if year==2010, sig
pwcorr etar assets_total1000 if year==2016, sig
pwcorr etar assets_total1000 if year==2020, sig
spearman etar assets_total1000 if year==2010, stats(rho p)
spearman etar assets_total1000 if year==2016, stats(rho p)
spearman etar assets_total1000 if year==2020, stats(rho p)

****************************************
* END













****************************************
* DSR and trap
****************************************

********** Given trap
use"panel_HH_v3", clear

replace dsr=dsr*100

*** Dummy
tabstat dsr if year==2010, stat(n mean q) by(giv_trap)
tabstat dsr if year==2016, stat(n mean q) by(giv_trap)
tabstat dsr if year==2020, stat(n mean q) by(giv_trap)

*** Amount
keep if giv_trap==1
pwcorr giv_trapamount dsr if year==2010, sig
pwcorr giv_trapamount dsr if year==2016, sig
pwcorr giv_trapamount dsr if year==2020, sig
spearman giv_trapamount dsr if year==2010, stats(rho p)
spearman giv_trapamount dsr if year==2016, stats(rho p)
spearman giv_trapamount dsr if year==2020, stats(rho p)

*** Ratio dette
replace gtdr=gtdr*100
pwcorr gtdr dsr if year==2010, sig
pwcorr gtdr dsr if year==2016, sig
pwcorr gtdr dsr if year==2020, sig
spearman gtdr dsr if year==2010, stats(rho p)
spearman gtdr dsr if year==2016, stats(rho p)
spearman gtdr dsr if year==2020, stats(rho p)

*** Ratio actifs
replace gtar=gtar*100
pwcorr gtar dsr if year==2010, sig
pwcorr gtar dsr if year==2016, sig
pwcorr gtar dsr if year==2020, sig
spearman gtar dsr if year==2010, stats(rho p)
spearman gtar dsr if year==2016, stats(rho p)
spearman gtar dsr if year==2020, stats(rho p)







********** Effective trap
use"panel_HH_v3", clear

*** Dummy
tabstat dsr if year==2010, stat(n mean q) by(eff_trap)
tabstat dsr if year==2016, stat(n mean q) by(eff_trap)
tabstat dsr if year==2020, stat(n mean q) by(eff_trap)

*** Amount
keep if eff_trap==1
pwcorr eff_trapamount dsr if year==2010, sig
pwcorr eff_trapamount dsr if year==2016, sig
pwcorr eff_trapamount dsr if year==2020, sig
spearman eff_trapamount dsr if year==2010, stats(rho p)
spearman eff_trapamount dsr if year==2016, stats(rho p)
spearman eff_trapamount dsr if year==2020, stats(rho p)

*** Ratio dette
replace etdr=etdr*100
pwcorr etdr dsr if year==2010, sig
pwcorr etdr dsr if year==2016, sig
pwcorr etdr dsr if year==2020, sig
spearman etdr dsr if year==2010, stats(rho p)
spearman etdr dsr if year==2016, stats(rho p)
spearman etdr dsr if year==2020, stats(rho p)

*** Ratio actifs
replace etar=etar*100
pwcorr etar dsr if year==2010, sig
pwcorr etar dsr if year==2016, sig
pwcorr etar dsr if year==2020, sig
spearman etar dsr if year==2010, stats(rho p)
spearman etar dsr if year==2016, stats(rho p)
spearman etar dsr if year==2020, stats(rho p)

****************************************
* END






























****************************************
* Evo DSR
****************************************
use"panel_HH_v3", clear

*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1


* DSR
tabstat dsr, stat(n q p90 p95 p99 max) by(year)
replace dsr=dsr*100
tabstat dsr, stat(n q p90 p95 p99 max) by(year)

violinplot dsr, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("") ///
xtitle("Percent") xlabel(0(20)180) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 405 households in 2010, 487 in 2016-17, and 622 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(dsr, replace) range(0 180)
graph export "DSR.png", as(png) replace




****************************************
* END











****************************************
* Changes over time
****************************************
use"panel_HH_v3", clear

*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

keep HHID_panel year dumHH_given_repa
rename dumHH_given_repa trap

reshape wide trap, i(HHID_panel) j(year)

* Stat
ta trap2010 trap2016
ta trap2016 trap2020


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
legend(order(1 "In a trap" 2 "Not in a trap") pos(6) col(2)) ///
note("{it:Note:} For 405 households in 2010, 487 in 2016-17, and 622 in 2020-21.", size(small)) ///
name(intrap, replace)
graph export "Intrap_HH.png", as(png) replace


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
title("Amount of debt dedicated to" "debt repayment") ///
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
title("Ratio of debt dedicated to debt" "repayment to total debt") ///
xtitle("Percent") xlabel(0(10)100) ///
ylabel(,grid) ///
legend(order(4 "IQR" 7 "Median" 10 "Mean") pos(6) col(3) on) ///
note("{it:Note:} For 75 households in 2010, 80 in 2016-17, and 285 in 2020-21.", size(vsmall)) ///
aspectratio() scale(1.2) name(ratio, replace) range(0 100)

grc1leg amount ratio
graph export "Trap_HH.png", as(png) replace

****************************************
* END



















****************************************
* Debt composition
****************************************
use"panel_HH_v3", clear


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

* Share use
foreach x in agri fami heal repa hous inve cere marr educ rela deat nore othe {
rename totHH_givenamt_`x' `x'
}
drop nore othe
egen s2=rowtotal(agri fami heal repa hous inve cere marr educ rela deat)
foreach x in agri fami heal repa hous inve cere marr educ rela deat {
gen s_`x'=`x'*100/s2
}
egen test=rowtotal(s_agri s_fami s_heal s_repa s_hous s_inve s_cere s_marr s_educ s_rela s_deat)
ta test year
drop test s2


********** By decile of debt
preserve
collapse (mean) s_agri s_fami s_heal s_repa s_hous s_inve s_cere s_marr s_educ s_rela s_deat, by(year loangroup)

gen sum1=s_agri
gen sum2=sum1+s_fami
gen sum3=sum2+s_heal
gen sum4=sum3+s_repa
gen sum5=sum4+s_hous
gen sum6=sum5+s_inve
gen sum7=sum6+s_cere
gen sum8=sum7+s_marr
gen sum9=sum8+s_educ
gen sum10=sum9+s_rela
gen sum11=sum10+s_deat

foreach x in 2010 2016 2020 {
twoway ///
(area sum1 loangroup if year==`x') ///
(rarea sum1 sum2 loangroup if year==`x') ///
(rarea sum2 sum3 loangroup if year==`x') ///
(rarea sum3 sum4 loangroup if year==`x') ///
(rarea sum4 sum5 loangroup if year==`x') ///
(rarea sum5 sum6 loangroup if year==`x') ///
(rarea sum6 sum7 loangroup if year==`x') ///
(rarea sum7 sum8 loangroup if year==`x') ///
(rarea sum8 sum9 loangroup if year==`x') ///
(rarea sum9 sum10 loangroup if year==`x') ///
(rarea sum10 sum11 loangroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of loan amount per household") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Agriculture" 2 "Family" 3 "Health" 4 "Repay previous" 5 "Housing" 6 "Investment" 7 "Ceremonies" 8 "Marriage" 9 "Education" 10 "Relatives" 11 " Deaths") pos(6) col(5)) ///
name(compo`x', replace)
}
grc1leg compo2010 compo2016 compo2020, name(compo_loan, replace) col(3)
*graph export "Compo_loan.png", replace
restore



********** By decile of income
preserve
collapse (mean) s_agri s_fami s_heal s_repa s_hous s_inve s_cere s_marr s_educ s_rela s_deat, by(year incgroup)

gen sum1=s_agri
gen sum2=sum1+s_fami
gen sum3=sum2+s_heal
gen sum4=sum3+s_repa
gen sum5=sum4+s_hous
gen sum6=sum5+s_inve
gen sum7=sum6+s_cere
gen sum8=sum7+s_marr
gen sum9=sum8+s_educ
gen sum10=sum9+s_rela
gen sum11=sum10+s_deat

foreach x in 2010 2016 2020 {
twoway ///
(area sum1 incgroup if year==`x') ///
(rarea sum1 sum2 incgroup if year==`x') ///
(rarea sum2 sum3 incgroup if year==`x') ///
(rarea sum3 sum4 incgroup if year==`x') ///
(rarea sum4 sum5 incgroup if year==`x') ///
(rarea sum5 sum6 incgroup if year==`x') ///
(rarea sum6 sum7 incgroup if year==`x') ///
(rarea sum7 sum8 incgroup if year==`x') ///
(rarea sum8 sum9 incgroup if year==`x') ///
(rarea sum9 sum10 incgroup if year==`x') ///
(rarea sum10 sum11 incgroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of income per household") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Agriculture" 2 "Family" 3 "Health" 4 "Repay previous" 5 "Housing" 6 "Investment" 7 "Ceremonies" 8 "Marriage" 9 "Education" 10 "Relatives" 11 " Deaths") pos(6) col(5)) ///
name(compo`x', replace)
}
grc1leg compo2010 compo2016 compo2020, name(compo_income, replace) col(3)
*graph export "Compo_loan.png", replace
restore

****************************************
* END













****************************************
* By caste and class
****************************************

********** By caste
use"panel_HH_v3", clear

* Selection 1
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Recourse to debt trap
ta dumHH_given_repa caste if year==2010, chi2 col nofreq
ta dumHH_given_repa caste if year==2016, chi2 col nofreq
ta dumHH_given_repa caste if year==2020, chi2 col nofreq

* Selection 2
keep if dumHH_given_repa==1

* Amount of the trap
tabstat totHH_givenamt_repa if year==2010, stat(n mean q) by(caste)
tabstat totHH_givenamt_repa if year==2016, stat(n mean q) by(caste)
tabstat totHH_givenamt_repa if year==2020, stat(n mean q) by(caste)

* Ratio
tabstat gtdr if year==2010, stat(n mean q) by(caste)
tabstat gtdr if year==2016, stat(n mean q) by(caste)
tabstat gtdr if year==2020, stat(n mean q) by(caste)




********** By class
use"panel_HH_v3", clear

* Selection 1
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Recourse to debt trap
ta dumHH_given_repa assets_cat if year==2010, chi2 col nofreq
ta dumHH_given_repa assets_cat if year==2016, chi2 col nofreq
ta dumHH_given_repa assets_cat if year==2020, chi2 col nofreq

* Selection 2
keep if dumHH_given_repa==1

* Amount of the trap
tabstat totHH_givenamt_repa if year==2010, stat(n mean q) by(assets_cat)
tabstat totHH_givenamt_repa if year==2016, stat(n mean q) by(assets_cat)
tabstat totHH_givenamt_repa if year==2020, stat(n mean q) by(assets_cat)

* Ratio
tabstat gtdr if year==2010, stat(n mean q) by(assets_cat)
tabstat gtdr if year==2016, stat(n mean q) by(assets_cat)
tabstat gtdr if year==2020, stat(n mean q) by(assets_cat)




********** By income
use"panel_HH_v3", clear

* Selection 1
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1

* Recourse to debt trap
ta dumHH_given_repa assets_cat if year==2010, chi2 col nofreq
ta dumHH_given_repa assets_cat if year==2016, chi2 col nofreq
ta dumHH_given_repa assets_cat if year==2020, chi2 col nofreq

* Selection 2
keep if dumHH_given_repa==1

* Amount of the trap
tabstat totHH_givenamt_repa if year==2010, stat(n mean q) by(assets_cat)
tabstat totHH_givenamt_repa if year==2016, stat(n mean q) by(assets_cat)
tabstat totHH_givenamt_repa if year==2020, stat(n mean q) by(assets_cat)

* Ratio
tabstat gtdr if year==2010, stat(n mean q) by(assets_cat)
tabstat gtdr if year==2016, stat(n mean q) by(assets_cat)
tabstat gtdr if year==2020, stat(n mean q) by(assets_cat)

****************************************
* END














****************************************
* Determinants
****************************************
use"panel_HH_v3", clear

*Craggs

* Tobit

* Zero inflated model



****************************************
* END


