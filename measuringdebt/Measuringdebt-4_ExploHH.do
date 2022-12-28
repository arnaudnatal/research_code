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



********** Spec 0: Debt only debt
global varstd assets_total_std isr_std tdr_std dailyincome4_pc_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo






********** Spec 0: Debt only debt
global varstd assets_total_std isr_std tdr_std dailyincome4_pc_std

pwcorr $varstd, star(.05)
factor $varstd, pcf
estat kmo








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
factor $varstd, pcf
estat kmo
rotate, quartimin

preserve
predict sp8fact1 sp8fact2
forvalues i=1/2 {
qui sum sp8fact`i'
gen sp8fact`i'_std = (sp8fact`i'-r(min))/(r(max)-r(min))
}
gen sp8finindex=((sp8fact1_std*0.55)+(sp8fact2_std*0.45))*100
drop sp8fact*

reg sp8finindex $varstd
*reg sp8finindex i.year i.caste
restore

****************************************
* END










****************************************
* Overlap between measures
****************************************
use"panel_v3", clear

*** Measures of financial distress
global overlap dar_std dsr_std afm_std tdr_std isr_std dailyincome4_pc_std assets_total_std

corr $overlap
graph matrix $overlap, half msize(vsmall) msymbol(oh)


/*
Not really overlap
Each measures seems to measure a precise aspect of indebtedness
A household can have high value on one aspect, low in another one.
*/


/*
This result reinforce the use of a multidimensional index to assesse financial vulnerability to take into account each dimensions

Indeed, if many overlap, we can only use one aspect.
*/

/*
We choose a compensatory approach: a debt that is costly can be compensated with a low level of debt, or a low level of impoverishing debt.

2 strategies:
- data dependend method (PCA)
- simple method (mean)

We will test the two
*/


****************************************
* END







****************************************
* Factor analysis: Final specification
****************************************
use"panel_v3", clear

global varstd afm_std isr_std tdr_std dar_std

********** Desc
tabstat $varstd, stat(mean cv min p1 p5 p10 q p90 p95 p99 max)
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
tabstat fact1 fact2, stat(mean cv min p1 p5 p10 q p90 p95 p99 max)
*twoway (scatter fact2 fact1, xline(0) yline(0))


********* Corr between var and fact
cpcorr $varstd \ fact1 fact2
cpcorr $varstd \ fact1 fact2 if year==2010
cpcorr $varstd \ fact1 fact2 if year==2016
cpcorr $varstd \ fact1 fact2 if year==2020


********* Std indiv score
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
* MCA of trends
****************************************
use"panel_v3", clear


global var dailyincome4_pc assets_total tdr isr

********** Reshape
keep HHID_panel year $var
reshape wide $var, i(HHID_panel) j(year)


********** Gen diff
foreach x in $var {
gen `x'_d1=(`x'2016-`x'2010)*100/`x'2010
gen `x'_d2=(`x'2020-`x'2016)*100/`x'2016
}

foreach x in $var {
gen `x'_cat1=0
gen `x'_cat2=0
}

recode dailyincome4_pc_d1 assets_total_d1 tdr_d1 isr_d1 dailyincome4_pc_d2 assets_total_d2 tdr_d2 isr_d2 (.=0)

foreach x in $var {
forvalues i=1/2 {
replace `x'_cat`i'=1 if `x'_d`i'>-10 & `x'_d`i'<10 & `x'_d`i'!=.
replace `x'_cat`i'=2 if `x'_d`i'>=10 & `x'_d`i'!=.
replace `x'_cat`i'=3 if `x'_d`i'<=-10 & `x'_d`i'!=.
}
}

********** Reshape
keep HHID_panel dailyincome4_pc_cat1 dailyincome4_pc_cat2 assets_total_cat1 assets_total_cat2 tdr_cat1 tdr_cat2 isr_cat1 isr_cat2
reshape long dailyincome4_pc_cat assets_total_cat tdr_cat isr_cat, i(HHID_panel) j(time)
drop if dailyincome4_pc_cat==0


********** Label
label define pente 1"Stable" 2"Increase" 3"Decrease"
foreach x in dailyincome4_pc_cat assets_total_cat tdr_cat isr_cat {
label values `x' pente
}


********** MCA test
mca dailyincome4_pc_cat assets_total_cat tdr_cat isr_cat, method (indicator) normal(princ) comp

mcaplot, overlay legend(off) xline(0) yline(0) scale(.8)


****************************************
* END












****************************************
* Average
****************************************
use"panel_v3", clear


* Poverty in %
gen diffPL=1.9-dailyusdincome4_pc
replace diffPL=0 if diffPL<0
ta diffPL


tabstat isr dar tdr, stat(n mean cv p50 min max)

********** Mean
egen finindex=rowmean(isr dar tdr)
gen lambda=(dailyusdincome4_pc-1.9)/1.9
replace lambda=0.99 if lambda>0.99
replace lambda=0.01 if lambda<0.01
gen puissa=1-lambda

gen finindex2=finindex^puissa

tabstat finindex2, stat(n mean cv p50 min max)
reg finindex i.year i.caste dailyusdincome4_pc
reg finindex2 i.year i.caste dailyusdincome4_pc


sort finindex2
br HHID_panel year finindex finindex2 dailyusdincome4_pc isr dar tdr

*replace finindex=finindex/100
replace finindex=100 if finindex>100


********** Charact
tabstat finindex, stat(n mean cv p50 min max) by(year)
tabstat finindex, stat(n mean cv p50 min max) by(caste)

graph box finindex if caste==1, over(year) noout
graph box finindex if caste==2, over(year) noout
graph box finindex if caste==3, over(year) noout

graph box finindex, over(year) noout


graph box finindex if year==2010, over(caste) noout
graph box finindex if year==2016, over(caste) noout
graph box finindex if year==2020, over(caste) noout


pwcorr finindex assets_total dailyincome4_pc expenses_total, star(.05)




* reg
encode HHID_panel, gen(panelvar)
xtset panelvar year

encode typeoffamily, gen(tof)
fre head_sex head_age head_mocc_occupation head_edulevel head_widowseparated

xtreg finindex2 i.caste head_sex head_age i.head_mocc_occupation i.head_edulevel i.tof assets_total_std



****************************************
* END
















****************************************
* K means
****************************************
use"panel_v3", clear

global varcr dailyincome4_pc_cr assets_total_cr tdr_cr isr_cr
global varstd dailyincome4_pc_std assets_total_std tdr_std isr_std
global var dailyincome4_pc assets_total tdr isr


********** Tabstat
tabstat $varstd, stat(n mean cv p50 p75 p90 p95 p99 max)
/*
foreach x in $varstd {
replace `x'=3 if `x'>3
}
*/

********** Corr
pwcorr $varstd, star(.05)
pwcorr $varcr, star(.05)
pwcorr $var, star(.05)
graph matrix $varstd, half msize(vsmall) msymbol(oh)


********** Cluster
cluster wardslinkage $varstd, measure(Euclidean)
cluster dendrogram, cutnumber(100)
cluster gen cah_clust=groups(3)
cluster kmeans $varstd, k(3) measure(Euclidean) name(clust) start(group(cah_clust))
drop _clus_*

*ta cah_clust
ta clust

*ta cah_clust year, col nofreq
ta clust year, col nofreq


***** Interpretation
foreach x in $var {
reg `x' i.clust
*graph box `x', over(cah_clust) noout name(bp`x', replace)
}


***** Clean
label define clust 1"Weak" 2"Distress" 3"Wealthy"
label values clust clust


***** Characteristics
ta clust caste, chi2 exp cchi2

foreach x in dsr dar {
*graph box `x', over(clust) noout name(bp`x', replace)
}


********** Transition matrix
keep HHID_panel year clust
reshape wide clust, i(HHID_panel) j(year)

ta clust2010 clust2016, row nofreq
ta clust2016 clust2020, row nofreq

/*
Household stay blocked
*/



****************************************
* END




/*
stripplot `x', over(clust) vert ///
stack width(0.2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks) name(sp`x', replace)
*/


/*
program drop _all
program define stripgraph
stripplot `1' if `1'<`4', over(`2') by(`3', title("`1'")) vert ///
stack width(1) jitter(0) ///
box(barw(1)) boffset(-0.3) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks)
end
*/




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
