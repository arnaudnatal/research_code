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
* Factor analysis 
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


*** Var
global varstd dailyincome4_pc_std assets_total_std tdr_std isr_std 

pwcorr $varstd, star(.05)
*graph matrix $varstd, half msize(vsmall) msymbol(oh)

pca $varstd
*screeplot, ci 
*estat kmo
*rotate, quartimin
*estat rotatecompare

predict fact1 fact2
forvalues i=1/2 {
qui summ fact`i'
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







/*
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
