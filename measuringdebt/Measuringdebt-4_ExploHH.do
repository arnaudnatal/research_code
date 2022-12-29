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
* Overlap between measures
****************************************
use"panel_v3", clear

*** Measures of financial distress
global overlap dar_std dsr_std afm_std rfm_std isr_std dailyincome4_pc_std assets_total_std

corr $overlap
*graph matrix $overlap, half msize(vsmall) msymbol(oh)


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


********** Recode
*** Inc better to worse
gen incomerev=dailyincome4_pc*(-1)
tabstat dailyincome4_pc incomerev, stat(n q)
egen incomerev_std=std(incomerev)

*** RFM better to worse
gen rfmrev=rfm*(-1)
tabstat rfm rfmrev, stat(n q)
egen rfmrev_std=std(rfmrev)

*** Assets better to worse
gen assetsrev=assets_total*(-1)
tabstat assets_total assetsrev, stat(n q)
egen assetsrev_std=std(assetsrev)

*** AFM better to worse
gen afmrev=afm*(-1)
tabstat afm afmrev, stat(n q)
egen afmrev_std=std(afmrev)

*** AFM2 better to worse
gen afm2rev=afm2*(-1)
tabstat afm2 afm2rev, stat(n q)
egen afm2rev_std=std(afm2rev)



save"panel_v4", replace
****************************************
* END











****************************************
* Specification no. 1
****************************************
use"panel_v4", clear


********** Var
global varstd incomerev_std dar_std rfmrev_std dsr_std
pwcorr $varstd, star(.05)





********* Method 1: Factor analysis
factor $varstd, pcf
*screeplot, mean
estat kmo
rotate, quartimin
/*
-----------------------------------------------
Factor 1:		(-) --------------> (+)
-----------------------------------------------
DSR (+84%):		Low cost			High cost
RFM (+74%):		High margin			Weak margin
Inc (+62%):		Rich				Poor
---
DAR (+15%):		Low stock			High stock
-----------------------------------------------
Interpretation: Low burden			High burden
-----------------------------------------------



-----------------------------------------------
Factor 2:		(-) --------------> (+)
-----------------------------------------------
DAR (+87%):		Low stock			High stock
Inc (-48%):		Poor				Rich
---
RFM (+27%):		High margin			Weak margin
DSR (+07%):		Low cost			High cost
-----------------------------------------------
Interpretation: Low stock			High stock
-----------------------------------------------
*/


*** Projection of individuals
predict fact1 fact2


*** Corr between var and fact
cpcorr $varstd \ fact1 fact2


*** Std indiv score
forvalues i=1/2 {
qui sum fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}


*** Index construction
gen PCA_finindex=((fact1_std*0.62)+(fact2_std*0.38))*100


*** Index meaning
cpcorr $varstd fact1 fact2 \ PCA_finindex
reg PCA_finindex $varstd
reg PCA_finindex i.caste i.year assets_total_std, base





********** Method 2: Arithmetic mean of std
egen _tempfinindex=rowmean($varstd)

qui sum _tempfinindex
gen M_finindex=((_tempfinindex-r(min))/(r(max)-r(min)))*100

*** Index meaning
reg M_finindex $varstd
reg M_finindex i.caste i.year assets_total_std, base



********** PCA vs Arithmetic mean
plot M_finindex PCA_finindex
cpcorr $varstd \ PCA_finindex M_finindex
/*
Finindex
Good to bad
*/



********** Econometric tests
encode HHID_panel, gen(panelvar)
xtset panelvar year
encode villageid, gen(vill)
encode typeoffamily, gen(tof)

xtreg PCA_finindex i.caste i.tof i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.dummypolygamous squareroot_HHsize i.vill, base




********** Stability over time
preserve
keep HHID_panel year PCA_finindex M_finindex caste
reshape wide PCA_finindex M_finindex, i(HHID_panel) j(year)

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020
corr M_finindex2010 M_finindex2016 M_finindex2020

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==1
corr M_finindex2010 M_finindex2016 M_finindex2020 if caste==1

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==2
corr M_finindex2010 M_finindex2016 M_finindex2020 if caste==2

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==3
corr M_finindex2010 M_finindex2016 M_finindex2020 if caste==3
restore


********** Clean
drop fact1 fact2 fact1_std fact2_std _tempfinindex
rename PCA_finindex PCA_finindex1
rename M_finindex M_finindex1


save"panel_v5", replace
****************************************
* END


















****************************************
* Specification no. 2
****************************************
use"panel_v5", clear



********** Var
global varstd isr_std tdr_std incomerev_std dar_std rfmrev_std assetsrev_std
pwcorr $varstd, star(.05)




********* Method 1: Factor analysis
factor $varstd, pcf
*screeplot, mean
estat kmo
rotate, quartimin


*** Projection of individuals
predict fact1 fact2 fact3


*** Corr between var and fact
cpcorr $varstd \ fact1 fact2 fact3


*** Std indiv score
forvalues i=1/3 {
qui sum fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}


*** Index construction
gen PCA_finindex=((fact1_std*0.42)+(fact2_std*0.31)+(fact3_std*0.27))*100


*** Index meaning
cpcorr $varstd fact1 fact2 fact3 \ PCA_finindex
reg PCA_finindex $varstd
reg PCA_finindex i.caste i.year, base





********** Method 2: Arithmetic mean of std
egen _tempfinindex=rowmean($varstd)

qui sum _tempfinindex
gen M_finindex=((_tempfinindex-r(min))/(r(max)-r(min)))*100

*** Index meaning
reg M_finindex $varstd
reg M_finindex i.caste i.year, base





********** PCA vs Arithmetic mean
plot M_finindex PCA_finindex
cpcorr $varstd \ PCA_finindex M_finindex
/*
Finindex
Good to bad
*/




********** Econometric tests
xtset panelvar year

xtreg PCA_finindex i.caste i.tof i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.dummypolygamous squareroot_HHsize i.vill, base



********** Stability over time
preserve
keep HHID_panel year PCA_finindex M_finindex caste
gen panel=1
reshape wide panel PCA_finindex M_finindex, i(HHID_panel) j(year)

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020
corr M_finindex2010 M_finindex2016 M_finindex2020

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==1
corr M_finindex2010 M_finindex2016 M_finindex2020 if caste==1

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==2
corr M_finindex2010 M_finindex2016 M_finindex2020 if caste==2

corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==3
corr M_finindex2010 M_finindex2016 M_finindex2020 if caste==3
restore





********** Clean
drop fact1 fact2 fact3 fact1_std fact2_std fact3_std _tempfinindex
rename PCA_finindex PCA_finindex2
rename M_finindex M_finindex2



save"panel_v6", replace
****************************************
* END


























****************************************
* Overlap specifications and shocks
****************************************
use"panel_v6", clear



***** Overlap 2 specifications
*graph matrix PCA_finindex1 M_finindex1 PCA_finindex2 M_finindex2 PCA_finindex3 M_finindex3, half msize(vsmall) msymbol(oh)



***** Trends
/*
gen dummypanel=0
replace dummypanel=1 if panel2010==1 & panel2016==1 & panel2020==1
keep if dummypanel==1
drop panel2010 panel2016 panel2020
order HHID_panel dummypanel caste
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
*/


***** Contrib of shocks
*** Demonetisation 2016-17
reg PCA_finindex1 dummydemonetisation if year==2016
reg M_finindex1 dummydemonetisation if year==2016
reg PCA_finindex2 dummydemonetisation if year==2016
reg M_finindex2 dummydemonetisation if year==2016

*** Second lockdown 2021
reg PCA_finindex1 i.secondlockdownexposure if year==2020
reg M_finindex1 i.secondlockdownexposure if year==2020
reg PCA_finindex2 i.secondlockdownexposure if year==2020
reg M_finindex2 i.secondlockdownexposure if year==2020

*** Marriage 2016-17
reg PCA_finindex1 dummymarriage if year==2016
reg M_finindex1 dummymarriage if year==2016
reg PCA_finindex2 dummymarriage if year==2016
reg M_finindex2 dummymarriage if year==2016


*** Marriage 2020-21
reg PCA_finindex1 dummymarriage if year==2020
reg M_finindex1 dummymarriage if year==2020
reg PCA_finindex2 dummymarriage if year==2020
reg M_finindex2 dummymarriage if year==2020



****************************************
* END








/*
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
*/

















********* Graph
/*
graph matrix $varstd, half msize(vsmall) msymbol(oh)

loadingplot , component(2) combined xline(0) yline(0) aspect(1)

twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30)), name(rev, replace)

twoway (scatter fact2 fact1 if year==2010, xline(0) yline(0) mcolor(black%30)), name(year2010, replace)
twoway (scatter fact2 fact1 if year==2016, xline(0) yline(0) mcolor(black%30)), name(year2016, replace)
twoway (scatter fact2 fact1 if year==2020, xline(0) yline(0) mcolor(black%30)), name(year2020, replace)

combineplot fact1 ($varstd): scatter @y @x || lfit @y @x
combineplot fact2 ($varstd): scatter @y @x || lfit @y @x
*/








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
