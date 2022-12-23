*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------





****************************************
* Stat HH
****************************************
use"panel_v3", clear


********** Expenses
tabstat expenses_total expenses_food expenses_educ expenses_heal expenses_cere, stat(n mean cv p50) by(year) long

tabstat shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere, stat(n mean cv p50) by(year) long

tabstat expenses_total if caste==1, stat(n mean cv p50) by(year)
tabstat expenses_total if caste==2, stat(n mean cv p50) by(year)
tabstat expenses_total if caste==3, stat(n mean cv p50) by(year)
tabstat expenses_total, stat(n mean cv p50) by(year)


********** Debt
/*
DSR = service  / annual income --> burden of debt
ISR = interest / annual income -->
DIR = amount   / annual income -->
DAR = amount   / assets --------->
TDR = bad debt / amount ---------> share of bad debt as debt is not necessary bad
FM  = Rest of liquid wealth after debt payment and consumption
*/

*** Ratio
tabstat dsr isr dar tdr tar fm, stat(n mean sd p50) by(year)

tabstat dsr isr dar dir tdr tar fm if year==2010, stat(n q) by(caste) long
tabstat dsr isr dar dir tdr tar fm if year==2016, stat(n q) by(caste) long
tabstat dsr isr dar dir tdr tar fm if year==2020, stat(n q) by(caste) long

*** Raw
tabstat loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa, stat(n q) by(year) long

tabstat loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa if year==2010, stat(n q) by(caste) long
tabstat loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa if year==2016, stat(n q) by(caste) long
tabstat loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa if year==2020, stat(n q) by(caste) long




********** Income
*** HH level
tabstat annualincome_HH, stat(n mean cv p50) by(year) long

*** per capita INR
tabstat dailyincome1_pc dailyincome2_pc dailyincome3_pc dailyincome4_pc, stat(q) by(year) long

*** per capita USD
tabstat dailyusdincome1_pc dailyusdincome2_pc dailyusdincome3_pc dailyusdincome4_pc, stat(q) by(year) long

*** Poverty line
cls
ta pl1 caste if year==2010, col nofreq
ta pl2 caste if year==2010, col nofreq
ta pl3 caste if year==2010, col nofreq
ta pl4 caste if year==2010, col nofreq

cls
ta pl1 caste if year==2016, col nofreq
ta pl2 caste if year==2016, col nofreq
ta pl3 caste if year==2016, col nofreq
ta pl4 caste if year==2016, col nofreq

cls
ta pl1 caste if year==2020, col nofreq
ta pl2 caste if year==2020, col nofreq
ta pl3 caste if year==2020, col nofreq
ta pl4 caste if year==2020, col nofreq



********** Wealth
tabstat assets_total assets_housevalue assets_livestock assets_goods assets_ownland assets_gold, stat(n mean cv p50) by(year) long

tabstat shareassets_housevalue shareassets_livestock shareassets_goods shareassets_ownland shareassets_gold, stat(n mean cv p50) by(year) long

tabstat assets_total if caste==1, stat(n mean cv p50) by(year)
tabstat assets_total if caste==2, stat(n mean cv p50) by(year)
tabstat assets_total if caste==3, stat(n mean cv p50) by(year)
tabstat assets_total, stat(n mean cv p50) by(year)


********** Matrix
tabstat fm_std, stat(min p1 p5 p10 q p90 p95 p99 max)
drop if fm_std>3
drop if fm_std<-3
*graph matrix fm_std expenses_total_std dailyincome4_pc_std dsr_std isr_std, half msize(vsmall) msymbol(oh)

****************************************
* END








****************************************
* Factor analysis: Tests
****************************************
use"panel_v3", clear


********** All var corr
pwcorr dailyincome4_pc_std annualincome_HH_std expenses_total_std assets_total_std totHH_givenamt_repa_std imp1_ds_tot_HH_std imp1_is_tot_HH_std dar_std dsr_std isr_std tar_std tdr_std fm_std, star(.05)




********** Spec 1: Wealth + Livelihood + Cost of debt per year + Share of bad debt
global varstd assets_total_std dailyincome4_pc_std isr_std tdr_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
predict sp1fact1 sp1fact2
forvalues i=1/2 {
qui sum sp1fact`i'
gen sp1fact`i'_std = (sp1fact`i'-r(min))/(r(max)-r(min))
}
gen sp1finindex=(sp1fact1_std*0.55)+(sp1fact2_std*0.45)
drop sp1fact*



********** Spec 2: Wealth + Livelihood + Cost of debt per year + Share of bad debt + Expenses
global varstd assets_total_std dailyincome4_pc_std isr_std tdr_std expenses_total_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
predict sp2fact1 sp2fact2
forvalues i=1/2 {
qui sum sp2fact`i'
gen sp2fact`i'_std = (sp2fact`i'-r(min))/(r(max)-r(min))
}
gen sp2finindex=(sp2fact1_std*0.59)+(sp2fact2_std*0.41)
drop sp2fact*





/*
********** Spec 3: Wealth + Livelihood + Cost of debt per year + Expenses
global varstd assets_total_std dailyincome4_pc_std isr_std expenses_total_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
predict sp3fact1 sp3fact2
forvalues i=1/2 {
qui sum sp3fact`i'
gen sp3fact`i'_std = (sp3fact`i'-r(min))/(r(max)-r(min))
}
gen sp3finindex=(sp3fact1_std*0.60)+(sp3fact2_std*0.40)
drop sp3fact*
*/




********** Spec 4: Wealth + Income after payment + Cost of debt per year + Amount of bad debt
global varstd assets_total_std fm_std isr_std totHH_givenamt_repa_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
predict sp4fact1 sp4fact2
forvalues i=1/2 {
qui sum sp4fact`i'
gen sp4fact`i'_std = (sp4fact`i'-r(min))/(r(max)-r(min))
}
gen sp4finindex=(sp4fact1_std*0.55)+(sp4fact2_std*0.45)
drop sp4fact*





********** Spec 5: Wealth + Livelihood + Cost of debt per year + Amount of bad debt + Expenses
global varstd assets_total_std dailyincome4_pc_std isr_std totHH_givenamt_repa_std expenses_total_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
predict sp5fact1 sp5fact2 sp5fact3
forvalues i=1/3 {
qui sum sp5fact`i'
gen sp5fact`i'_std = (sp5fact`i'-r(min))/(r(max)-r(min))
}
gen sp5finindex=(sp5fact1_std*0.43)+(sp5fact2_std*0.29)+(sp5fact3_std*0.28)
drop sp5fact*




********** Spec 6: Wealth + Livelihood + Cost of debt per year + Share of bad debt

global varstd assets_total_std fm_std isr_std tdr_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo
predict sp6fact1 sp6fact2
forvalues i=1/2 {
qui sum sp6fact`i'
gen sp6fact`i'_std = (sp6fact`i'-r(min))/(r(max)-r(min))
}
gen sp6finindex=(sp6fact1_std*0.53)+(sp6fact2_std*0.47)
drop sp6fact*







********** Spec 7: Wealth + Livelihood + Share of bad debt + Stock of debt
global varstd assets_total_std dailyincome4_pc_std tdr_std loanamount_HH_std


pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo

predict sp7fact1 sp7fact2
forvalues i=1/2 {
qui sum sp7fact`i'
gen sp7fact`i'_std = (sp7fact`i'-r(min))/(r(max)-r(min))
}
gen sp7finindex=(sp7fact1_std*0.6)+(sp7fact2_std*0.4)
drop sp7fact*






********** Spec 8: Try to improve the 7
global varstd dailyincome4_pc_std tdr_std isr_std assets_total_std

pwcorr $varstd, star(.05)

preserve
factor $varstd, pcf
*screeplot, mean
estat kmo
rotate, quartimin
predict sp8fact1 sp8fact2
forvalues i=1/2 {
qui sum sp8fact`i'
gen sp8fact`i'_std = (sp8fact`i'-r(min))/(r(max)-r(min))
}
gen sp8finindex=((sp8fact1_std*0.55)+(sp8fact2_std*0.45))*100
drop sp8fact*

reg sp8finindex $varstd
reg sp8finindex i.year i.caste
restore

****************************************
* END















****************************************
* Average
****************************************
use"panel_v3", clear

tabstat isr dar tdr, stat(n mean cv p50 min max)

egen finindex=rowmean(isr dar tdr)
replace finindex=100 if finindex>100

tabstat finindex, stat(n mean cv p50 min max) by(year)
tabstat finindex, stat(n mean cv p50 min max) by(caste)

pwcorr finindex assets_total dailyincome4_pc expenses_total, star(.05)

sort finindex
*br HHID_panel year caste finindex dar tdr isr assets_total dailyincome4_pc expenses_total loanamount_HH dsr  dir

*kdensity finindex, norm

global varstd dsr_std dar_std dailyincome4_pc_std assets_total_std expenses_total_std loanamount_HH_std

pwcorr $varstd, star(.05)

factor $varstd, pcf
factor $varstd, pcf

rotate, quartimin
estat kmo
****************************************
* END











****************************************
* kmeans
****************************************
use"panel_v3", clear

cluster wardslinkage isr_std tdr_std dailyincome4_pc_std assets_total_std
*cluster dendrogram, cutnumber(20)
cluster generate clus=groups(3)

tabstat isr tdr dailyincome4_pc assets_total, stat(n mean cv p50) by(clus)

ta clus year, col nofreq

****************************************
* END













****************************************
* Factor analysis: Final specification
****************************************
use"panel_v3", clear


global varstd dailyincome4_pc_std tdr_std isr_std assets_total_std


********** Desc
pwcorr $varstd, star(.05)
*graph matrix $varstd, half msize(vsmall) msymbol(oh)


********* Factor analysis
factor $varstd, pcf
*screeplot, mean
estat kmo
rotate, quartimin
estat rotatecompare


********* Projection of variables
*loadingplot , component(2) combined xline(0) yline(0) aspect(1)


********* Projection of individuals
predict fact1 fact2
*twoway (scatter fact2 fact1, xline(0) yline(0))
forvalues i=1/2 {
qui sum fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}
*twoway (scatter fact2_std fact1_std)


********** Index construction
gen finindex=(fact1_std*0.55)+(fact2_std*0.45)


********** Index modifications
*** Log
*gen _temp1logfinindex=finindex/(1-finindex)
*gen logfinindex=log(_temp1logfinindex)
*drop _temp1logfinindex

*** Cat
xtile finindex_cat=finindex, n(3)


********** Interpretation
reg finindex $varstd
*betareg finindex $varstd
*glm finindex $varstd, family(gamma) link(probit)


********* Representation
*kdensity finindex, norm
*kdensity logfinindex, norm
*twoway (scatter logfinindex finindex)
tabstat finindex, stat(n mean cv p50)
tabstat finindex, stat(min p1 p5 p10 q p90 p95 p99 max)


********** Interpretation part 2
reg finindex dsr dar i.caste i.year



********** Evolution test
preserve
keep HHID_panel year finindex
reshape wide finindex, i(HHID_panel) j(year)

*** Correlation
pwcorr finindex2010 finindex2016 finindex2020, star(0.05)
*graph matrix finindex2010 finindex2016 finindex2020, half msize(vsmall) msymbol(oh)
restore

save"panel_v4", replace
****************************************
* END













****************************************
* DTWclust preparation
****************************************
use"panel_v4", clear

keep HHID_panel year finindex dailyincome4_pc_std tdr_std isr_std assets_total_std dailyincome4_pc tdr isr assets_total dsr dsr_std dar dar_std fm fm_std expenses_total_std expenses_total caste

gen panel=year

reshape wide panel caste expenses_total assets_total dsr isr dar tdr fm dailyincome4_pc assets_total_std dsr_std isr_std dar_std tdr_std fm_std expenses_total_std dailyincome4_pc_std finindex, i(HHID_panel) j(year)

order HHID_panel panel2010 panel2016 panel2020
sort HHID_panel
gen dummypanel=0
replace dummypanel=1 if panel2010==2010 & panel2016==2016 & panel2020==2020

keep if dummypanel==1
ta caste2010 caste2016
ta caste2016 caste2020

export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace


********** Manually create groups for finindex
gen variarate1=(finindex2016-finindex2010)*100/finindex2010
gen variarate2=(finindex2020-finindex2016)*100/finindex2016


*** Groups
label define dynamic 1"Sta-Sta" 2"Sta-Inc" 3"Inc-Sta" 4"Inc-Inc" 5"Sta-Dec" 6"Dec-Sta" 7"Dec-Dec" 8"Inc-Dec" 9"Dec-Inc"

gen finindexdynamic=0

replace finindexdynamic=1 if variarate1<5 & variarate1>-5 & variarate2<5 & variarate2>-5 

replace finindexdynamic=2 if variarate1<5 & variarate1>-5 & variarate2>=5 
replace finindexdynamic=3 if variarate1>=5 & variarate2<5 & variarate2>-5 
replace finindexdynamic=4 if variarate1>=5 & variarate2>=5 

replace finindexdynamic=5 if variarate1<5 & variarate1>-5 & variarate2<=-5 
replace finindexdynamic=6 if variarate1<=-5 & variarate2<5 & variarate2>-5 
replace finindexdynamic=7 if variarate1<=-5 & variarate2<=-5 

replace finindexdynamic=8 if variarate1>=5 & variarate2<=-5 
replace finindexdynamic=9 if variarate1<=-5 & variarate2>=5

label values finindexdynamic dynamic

tab finindexdynamic
/*
finindexdyn |
       amic |      Freq.     Percent        Cum.
------------+-----------------------------------
    Sta-Sta |        126       32.98       32.98
    Sta-Inc |         16        4.19       37.17
    Inc-Sta |         27        7.07       44.24
    Inc-Inc |          5        1.31       45.55
    Sta-Dec |         69       18.06       63.61
    Dec-Sta |         40       10.47       74.08
    Dec-Dec |         25        6.54       80.63
    Inc-Dec |         24        6.28       86.91
    Dec-Inc |         50       13.09      100.00
------------+-----------------------------------
      Total |        382      100.00
*/

*** Check consistency
cls
forvalues i=1/9 {
tabstat finindex2010 finindex2016 finindex2020 if finindexdynamic==`i', stat(n mean cv p50)
}

****************************************
* END











****************************************
* Econometrics
****************************************
use"panel_v4", clear

encode HHID_panel, gen(panelvar)
xtset panelvar year


xtreg finindex dailyincome4_pc i.caste
*xtgee finindex dailyincome4_pc i.caste, family(binomial) link(logit)

****************************************
* END









****************************************
* ML dimension with subsample
****************************************
use"panel_v3", clear

/*
forvalues i=1/99 {
preserve
sample 500, count
mean year
restore
}
*/

****************************************
* END
