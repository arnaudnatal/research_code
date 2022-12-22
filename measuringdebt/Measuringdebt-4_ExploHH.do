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

****************************************
* END








****************************************
* Factor analysis: Tests
****************************************
use"panel_v3", clear

/*
Azzopardi and Fareed:
- DSR
- DAR
- Income
--> PCA on 4 subsamples
	+ HAC, Kmeans
	= 2 groups
	
Anderloni et al.:
- Expenditure vuln on Likert
- Income and saving vuln on Likert
- Loan vuln on Likert
--> PCA 

*/
********** All var corr
pwcorr dailyincome4_pc_std annualincome_HH_std expenses_total_std assets_total_std totHH_givenamt_repa_std imp1_ds_tot_HH_std imp1_is_tot_HH_std dar_std dsr_std isr_std tar_std tdr_std fm_std, star(.05)




********** Spec 1: Wealth + Livelihood + Cost of debt per year + Share of bad debt
global varstd assets_total_std dailyincome4_pc_std isr_std tdr_std

pwcorr $varstd, star(.05)
pca $varstd
*59
estat kmo
/*
    -----------------------
        Variable |     kmo 
    -------------+---------
    assets_to~td |  0.5032 
    dailyincom~d |  0.5026 
         isr_std |  0.5090 
         tdr_std |  0.4869 
    -------------+---------
         Overall |  0.5033 
    -----------------------
*/
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
pca $varstd
*53
estat kmo
/*
    -----------------------
        Variable |     kmo 
    -------------+---------
    assets_to~td |  0.5875 
    dailyincom~d |  0.6002 
         isr_std |  0.5241 
         tdr_std |  0.5960 
    expenses_t~d |  0.5933 
    -------------+---------
         Overall |  0.5871 
    -----------------------
*/
predict sp2fact1 sp2fact2
forvalues i=1/2 {
qui sum sp2fact`i'
gen sp2fact`i'_std = (sp2fact`i'-r(min))/(r(max)-r(min))
}
gen sp2finindex=(sp2fact1_std*0.59)+(sp2fact2_std*0.41)
drop sp2fact*






********** Spec 3: Wealth + Livelihood + Cost of debt per year + Expenses
global varstd assets_total_std dailyincome4_pc_std isr_std expenses_total_std

pwcorr $varstd, star(.05)
pca $varstd
*64
estat kmo
/*
    -----------------------
        Variable |     kmo 
    -------------+---------
    assets_to~td |  0.5837 
    dailyincom~d |  0.6025 
         isr_std |  0.5227 
    expenses_t~d |  0.5855 
    -------------+---------
         Overall |  0.5836 
    -----------------------
*/
predict sp3fact1 sp3fact2
forvalues i=1/2 {
qui sum sp3fact`i'
gen sp3fact`i'_std = (sp3fact`i'-r(min))/(r(max)-r(min))
}
gen sp3finindex=(sp3fact1_std*0.60)+(sp3fact2_std*0.40)
drop sp3fact*



********** Spec 4: Wealth + Income after payment + Cost of debt per year + Amount of bad debt
global varstd assets_total_std fm_std isr_std totHH_givenamt_repa_std

pwcorr $varstd, star(.05)
pca $varstd
*57
estat kmo
/*
    -----------------------
        Variable |     kmo 
    -------------+---------
    assets_to~td |  0.5683 
          fm_std |  0.5051 
         isr_std |  0.5054 
    totHH_giv~pa |  0.5178 
    -------------+---------
         Overall |  0.5077 
    -----------------------
*/
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
pca $varstd
*72
estat kmo
/*
    -----------------------
        Variable |     kmo 
    -------------+---------
    assets_to~td |  0.5667 
    dailyincom~d |  0.6048 
         isr_std |  0.5194 
    totHH_give~d |  0.4536 
    expenses_t~d |  0.5759 
    -------------+---------
         Overall |  0.5704 
    -----------------------
*/
predict sp5fact1 sp5fact2 sp5fact3
forvalues i=1/3 {
qui sum sp5fact`i'
gen sp5fact`i'_std = (sp5fact`i'-r(min))/(r(max)-r(min))
}
gen sp5finindex=(sp5fact1_std*0.43)+(sp5fact2_std*0.29)+(sp5fact3_std*0.28)
drop sp5fact*





********** Check consistency between measures
pwcorr sp1finindex sp2finindex sp3finindex sp4finindex sp5finindex, star(.05)
/*
             | sp1fin~x sp2fin~x sp3fin~x sp4fin~x sp5fin~x
-------------+---------------------------------------------
 sp1finindex |   1.0000 
 sp2finindex |   0.8646*  1.0000 
 sp3finindex |   0.6788*  0.9151*  1.0000 
 sp4finindex |  -0.1935* -0.3255* -0.1863*  1.0000 
 sp5finindex |   0.1193*  0.4084*  0.6593*  0.3701*  1.0000 
*/

graph matrix sp1finindex sp2finindex sp3finindex sp4finindex sp5finindex, half msize(vsmall) msymbol(oh)


/*
1 & 2
1 & 3
2 & 3
3 & 5

4 is reverse.

1, 2, 3, and 5.
*/




********** Check consistency with other indicators
*** Finindex No.1
pwcorr sp1finindex dsr_std isr_std dar_std dir_std tdr_std dailyincome4_pc_std annualincome_HH_std assets_total_std expenses_total_std fm_std, p(.05)
reg sp1finindex i.year i.caste


*** Finindex No.2
pwcorr sp2finindex dsr_std isr_std dar_std dir_std tdr_std dailyincome4_pc_std annualincome_HH_std assets_total_std expenses_total_std fm_std, p(.05)
reg sp2finindex i.year i.caste


*** Finindex No.3
pwcorr sp3finindex dsr_std isr_std dar_std dir_std tdr_std dailyincome4_pc_std annualincome_HH_std assets_total_std expenses_total_std fm_std, p(.05)
reg sp3finindex i.year i.caste


*** Finindex No.5
pwcorr sp5finindex dsr_std isr_std dar_std dir_std tdr_std dailyincome4_pc_std annualincome_HH_std assets_total_std expenses_total_std fm_std, p(.05)
reg sp4finindex i.year i.caste dsr_std dar_std dailyincome4_pc_std expenses_total_std tdr_std isr_std assets_total_std
sort sp5finindex
br HHID_panel year caste typeoffamily sp5finindex dsr isr dar 



****************************************
* END












****************************************
* Factor analysis: Final specification
****************************************
use"panel_v3", clear

global varstd

pwcorr $varstd, star(.05)
graph matrix $varstd, half msize(vsmall) msymbol(oh)
pca $varstd
screeplot, ci addplot(function y=1, range(1 4))
estat kmo
rotate, quartimin
estat rotatecompare



predict fact1 fact2
forvalues i=1/2 {
qui sum fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}
dis 33/60
dis 27/60
gen finindex=(fact1_std*0.55)+(fact2_std*0.45)
xtile finindex_cat=finindex, n(3)
order HHID_panel year finindex fact* dsr dar annualincome_HH assets_total caste
sort finindex


*** Interpretation
tabstat finindex, stat(mean cv p1 p5 p10 q p90 p95 p99)
pwcorr finindex $varstd, star(.05)
pwcorr finindex dsr isr dar tdr dailyincome4_pc assets_total, star(.05)
tabstat finindex dsr isr dar tdr dailyincome4_pc assets_total, stat(q) by(finindex_cat) long




********** Evolution test
preserve
keep HHID_panel year finindex finindex_cat
reshape wide finindex finindex_cat, i(HHID_panel) j(year)

pwcorr finindex2010 finindex2016 finindex2020, star(0.05)
*graph matrix finindex2010 finindex2016 finindex2020, half msize(vsmall) msymbol(oh)

ta finindex_cat2010 finindex_cat2016, nofreq row
ta finindex_cat2016 finindex_cat2020, nofreq row

ta finindex_cat2010 finindex_cat2020, nofreq row
restore

save"panel_v4", replace
****************************************
* END
















****************************************
* Econometrics
****************************************
use"panel_v4", clear

encode HHID_panel, gen(panelvar)
xtset panelvar year


xtreg finindex dailyincome4_pc i.caste

glm finindex dailyincome4_pc i.caste, family(binomial) link(logit)

xtgee finindex dailyincome4_pc i.caste, family(binomial) link(logit)



****************************************
* END












****************************************
* ML dimension with subsample
****************************************
use"panel_v3", clear


forvalues i=1/99 {
preserve
sample 500, count
mean year
restore
}

****************************************
* END
