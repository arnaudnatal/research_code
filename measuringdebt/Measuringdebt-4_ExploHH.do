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

global overlap incomerev_std dar_std rfmrev_std dsr_std


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


****************************************
* END











****************************************
* Finindex
****************************************
use"panel_v3", clear


********** Global
global varstd dailyincome4_pc_std assets_pc_std rfm_std dsr_std tdr_std lpc_std dar_std
global var dailyincome4_pc assets_pc rfm dsr tdr lpc dar


********** Desc
tabstat $var, stat(n mean cv p50) by(year)

corr $varstd

factortest $varstd


********* PCA
pca $varstd, comp(3)
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2 fact3
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))


*** Corr between var and fact
cpcorr $varstd \ fact1 fact2 fact3


*** More is bad
*replace fact1=fact1*(-1)
replace fact2=fact2*(-1)
cpcorr $varstd \ fact1 fact2 fact3


*** Std indiv score
forvalues i=1/3 {
qui sum fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}


*** Index construction
gen PCA_finindex=((fact1_std*0.45)+(fact2_std*0.29)+(fact3_std*0.26))*100


*** Index meaning
cpcorr fact1 fact2 fact3 $varstd \ PCA_finindex
tabstat PCA_finindex, stat(n mean cv q) by(year)
tabstat PCA_finindex, stat(n mean cv q) by(caste)


/*
stripplot PCA_finindex, over(year) vert ///
stack width(0.2) jitter(1) refline ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks)
*/

xtset panelvar year

mdesc PCA_finindex caste tof HHsize HH_count_child head_sex head_age head_mocc_occupation head_edulevel vill dummydemonetisation dummyexposure

xtreg PCA_finindex i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base

xtreg PCA_finindex i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill i.dummydemonetisation i.dummyexposure, base




********** Stability over time
preserve
keep HHID_panel year PCA_finindex caste
reshape wide PCA_finindex, i(HHID_panel) j(year)
cls
corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020
corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==1
corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==2
corr PCA_finindex2010 PCA_finindex2016 PCA_finindex2020 if caste==3
restore


save"panel_v4", replace
****************************************
* END














****************************************
* Trends and shocks
****************************************
use"panel_v4", clear


***** Trends
preserve
keep if dummypanel==1
keep HHID_panel year PCA_finindex
reshape wide PCA_finindex, i(HHID_panel) j(year)
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore





********** Contrib of shocks
global control ib(2).caste

reg PCA_finindex dummydemonetisation $control if year==2016, base
reg PCA_finindex dummyexposure $control if year==2020, base
*reg PCA_finindex dummymarriage $control if year==2016
*reg PCA_finindex dummymarriage $control if year==2020
*reg PCA_finindex dummymarriage $control if year!=2016

****************************************
* END









****************************************
* Finindex by simple calculation to compare
****************************************
use"panel_v4", clear


********** Global
global varstd dailyincome4_pc_std assets_pc_std rfm_std dsr_std tdr_std lpc_std dar_std
global var dailyincome4_pc assets_pc rfm dsr tdr lpc dar


********** Desc
mdesc $var PCA_finindex
tabstat $var PCA_finindex, stat(n mean cv p50) by(year)







****************************************
* END















****************************************
* Prediction power
****************************************
use"panel_v4", clear


********** To keep
keep panelvar year PCA_finindex dsr dar head_mocc_occupation head_nboccupation nbworker_HH
mdesc 


********** Reshape
reshape wide PCA_finindex dsr dar head_mocc_occupation head_nboccupation nbworker_HH, i(panelvar) j(year)


********** Re-organize the dataset
drop head_mocc_occupation2010 head_nboccupation2010 nbworker_HH2010 PCA_finindex2020 dar2020 dsr2020

rename PCA_finindex2010 PCA_finindex1
rename head_mocc_occupation2016 head_mocc_occupation1
rename head_nboccupation2016 head_nboccupation1
rename nbworker_HH2016 nbworker_HH1

rename PCA_finindex2016 PCA_finindex2
rename head_mocc_occupation2020 head_mocc_occupation2
rename head_nboccupation2020 head_nboccupation2
rename nbworker_HH2020 nbworker_HH2


********** Clean with only full obs, i.e. full panel HH
drop if PCA_finindex1==.
drop if PCA_finindex2==.
drop if head_mocc_occupation2==.


********** Reshape
reshape long PCA_finindex head_mocc_occupation head_nboccupation nbworker_HH, i(panelvar) j(period)
mdesc



********** Test econometrics
xtset panelvar period
tabstat nbworker_HH head_nboccupation, stat(n mean cv p50 min max)

xtreg nbworker_HH PCA_finindex


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









/*
****************************************
* Simple aggregation
****************************************
use"panel_v3", clear

********** Method 2: Arithmetic mean of std
egen _tempfinindex=rowmean($varstd)
qui sum _tempfinindex
gen M_finindex=((_tempfinindex-r(min))/(r(max)-r(min)))*100
drop _tempfinindex



********** Method 3: Arithmetic mean weighted by income
*assetsrev incomerev afmrev

egen step1=rowmean(dar dsr)
*replace step1=0 if step1<0
gen lambda=(dailyusdincome4_pc-1.9)/1.9
gen lambdarev=lambda*(-1)
replace lambdarev=0 if lambdarev<0
gen MW_finindex=step1*(1+lambdarev)
drop step1 lambda lambdarev


********** Method 4: Arithmetic mean weighted by income
egen step1=rowmean(dar dsr tdr)
*replace step1=0 if step1<0
gen lambda=(dailyusdincome4_pc-1.9)/1.9
gen lambdarev=lambda*(-1)
ta lambdarev
replace lambdarev=0 if lambdarev<0
ta lambdarev
gen MW2_finindex=step1*(1+lambdarev)
drop step1 lambda lambdarev
****************************************
* END
*/











/*
****************************************
* Graph PCA
****************************************
use"panel_v3", clear
/*
graph matrix $varstd, half msize(vsmall) msymbol(oh)

loadingplot , component(2) combined xline(0) yline(0) aspect(1)

twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30)), name(rev, replace)

twoway (scatter fact2 fact1 if year==2010, xline(0) yline(0) mcolor(black%30)), name(year2010, replace)
twoway (scatter fact2 fact1 if year==2016, xline(0) yline(0) mcolor(black%30)), name(year2016, replace)
twoway (scatter fact2 fact1 if year==2020, xline(0) yline(0) mcolor(black%30)), name(year2020, replace)

combineplot fact1 ($varstd): scatter @y @x || lfit @y @x
combineplot fact2 ($varstd): scatter @y @x || lfit @y @x


stripplot `x', over(clust) vert ///
stack width(0.2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks) name(sp`x', replace)


program drop _all
program define stripgraph
stripplot `1' if `1'<`4', over(`2') by(`3', title("`1'")) vert ///
stack width(1) jitter(0) ///
box(barw(1)) boffset(-0.3) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks)
end
****************************************
* END
*/
