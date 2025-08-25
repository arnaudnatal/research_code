*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "intraHHineq"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\intraHHineq.do"
*-------------------------











****************************************
* Trends in intra-
****************************************
cls
use"panel_v2", clear

fre catdiff

ta catdiff year
ta catdiff year, col nofreq
ta year catdiff, row nofreq


********** Graph cat 1
tabplot catdiff year, percent(year) showval frame(100) ///
frameopts(color(plb1)) ///
fcolor(plb1*0.4) lcolor(plb1) ///
subtitle("") ///
xtitle("") ytitle("") ///
xlabel(1 "2010" 2 "2016-17" 3 "2020-21") ylabel() ///
note("{it:Note:} Percent given year.", size(small)) ///
scale(1.2)
graph export "incidence.png", as(png) replace


****************************************
* END













****************************************
* Intensity
****************************************
cls
use"panel_v2", clear

fre catdiff
keep if catdiff==3 | catdiff==5
ta catdiff year, m

egen typetime=group(catdiff year), label

ta year

fre typetime
label define typetime ///
1"2010" 2"2016-17" 3"2020-21" ///
4"2010" 5"2016-17" 6"2020-21", replace
label values typetime typetime

tabstat absdiff, stat(min p1 p5 p10 q p90 p95 p99 max)
replace absdiff=absdiff/1000
tabstat absdiff, stat(min p1 p5 p10 q p90 p95 p99 max)

violinplot absdiff, over(typetime) horizontal left dscale(2.8) noline range(0 250) now ///
addplot(function y=-2.5, range(0 250) lcolor(black) lpattern(shortdash)) ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
title("Intra-household income gender gap", size(small)) ///
xtitle("1k rupees") xlabel(0(50)250) ///
ylabel(,grid) ytick(-2.5) ytitle("(a) Men > Women       (c) Women > Men") ///
legend(order(7 "IQR" 14 "Median" 20 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(viodiff, replace) note("{it:Note:} For 296 households in 2010, 392 in 2016-17, and 472 in 2020-21.", size(vsmall))
graph export "Intensityintra.png", as(png) replace

****************************************
* END
















****************************************
* Deter path for all HH
****************************************
cls
use"panel_v2", clear

* Caste
ta catdiff caste, col nofreq 
ta catdiff caste, exp cchi2 chi2

* Head charact
ta head_sex catdiff, row nofreq chi2
ta head_sex catdiff, exp cchi2 chi2

ta head_maritalstatus catdiff, row nofreq chi2
ta head_maritalstatus catdiff, exp cchi2 chi2

ta head_mocc_occupation catdiff, row nofreq chi2
ta head_mocc_occupation catdiff, exp cchi2 chi2

ta head_edulevel catdiff, row nofreq chi2
ta head_edulevel catdiff, exp cchi2 chi2

tabstat head_age, stat(n mean) by(catdiff)
reg head_age i.catdiff

replace loanamount_HH=loanamount_HH/1000
tabstat loanamount_HH, stat(n mean) by(catdiff)
reg loanamount_HH i.catdiff
replace loanamount_HH=loanamount_HH*1000

tabstat dsr, stat(n mean) by(catdiff)
reg dsr i.catdiff

tabstat isr, stat(n mean) by(catdiff)
reg isr i.catdiff

tabstat dar, stat(n mean) by(catdiff)
reg dar i.catdiff

****************************************
* END















****************************************
* Test econometrics HH level
****************************************
use"panel_v2", clear


*
encode HHID_panel, gen(HHFE)
xtset HHFE year


********** DSR
***** No lag
*
xtreg dsr i.catdiff i.caste, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg dsr absdiff_log i.caste, fe cluster(HHFE)
restore


***** Lag
*
xtreg dsr i.LAGcatdiff i.caste, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg dsr LAGabsdiff_log i.caste, fe cluster(HHFE)
restore





********** ISR
***** No lag
*
xtreg isr i.catdiff i.caste, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg isr absdiff_log i.caste, fe cluster(HHFE)
restore


***** Lag
*
xtreg isr i.LAGcatdiff i.caste, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg isr LAGabsdiff_log i.caste, fe cluster(HHFE)
restore






********** DAR
***** No lag
*
xtreg dar i.catdiff i.caste, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg dar absdiff_log i.caste, fe cluster(HHFE)
restore


***** Lag
*
xtreg dar i.LAGcatdiff i.caste, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg dar LAGabsdiff_log i.caste, fe cluster(HHFE)
restore


****************************************
* END
















****************************************
* Test econometrics indiv level
****************************************
use"panelindiv_v1", clear


*
drop if year==2010
xtset indivFE year


********** Proba to be indebted without lag
***** For all individual
*
xtreg indebted i.catdiff age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg indebted absdiff_log age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
restore


***** Separate sample
*
xtreg indebted i.catdiff age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg indebted i.catdiff age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg indebted absdiff_log age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg indebted absdiff_log age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
restore





********** Proba to be indebted with lag
***** For all individual
*
xtreg indebted i.LAGcatdiff age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg indebted LAGabsdiff_log age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
restore




***** Separate sample
*
xtreg indebted i.LAGcatdiff age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg indebted i.LAGcatdiff age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg indebted LAGabsdiff_log age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg indebted LAGabsdiff_log age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
restore






********** Debt amount without lag
keep if indebted==1
***** For all individual
*
xtreg loanamount_indiv i.catdiff age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg loanamount_indiv absdiff_log age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
restore


***** Separate sample
*
xtreg loanamount_indiv i.catdiff age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg loanamount_indiv i.catdiff age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg loanamount_indiv absdiff_log age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg loanamount_indiv absdiff_log age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
restore





********** Debt amount with lag
***** For all individual
*
xtreg loanamount_indiv i.LAGcatdiff age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg loanamount_indiv LAGabsdiff_log age sex i.caste i.mainocc_occupation, fe cluster(HHFE)
restore




***** Separate sample
*
xtreg loanamount_indiv i.LAGcatdiff age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg loanamount_indiv i.LAGcatdiff age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
*
preserve
keep if catdiff==3 | catdiff==5
xtreg loanamount_indiv LAGabsdiff_log age i.caste i.mainocc_occupation if sex==1, fe cluster(HHFE)
xtreg loanamount_indiv LAGabsdiff_log age i.caste i.mainocc_occupation if sex==2, fe cluster(HHFE)
restore













































********** Opinion working woman without lag
reg opinionworkingwoman i.catdiff age sex i.caste i.mainocc_occupation, cluster(HHFE)

preserve
keep if catdiff==3 | catdiff==5
reg opinionworkingwoman absdiff_log age sex i.caste i.mainocc_occupation, cluster(HHFE)
restore


****************************************
* END

