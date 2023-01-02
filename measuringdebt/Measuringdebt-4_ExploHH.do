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
* Finindex no. 1
****************************************
use"panel_v3", clear

/*
- Livelihood pc
- Wealth pc
- Relative financial margin
- Debt service
- Trap ratio
- Loans per capita
- Debt to assets
*/

********** Global
global varstd dailyincome4_pc_std assets_pc_std rfm_std dsr_std tdr_std lpc_std dar_std
global var dailyincome4_pc assets_pc rfm dsr tdr lpc dar



********** Desc
tabstat $var, stat(n mean cv p50) by(year)

corr $varstd

factortest $varstd


********* PCA
pca $varstd
estat kmo
pca $varstd, comp(3)
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2 fact3
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))


*** Corr between var and fact
cpcorr $varstd \ fact1 fact2 fact3


*** More is bad
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


*** Econo
xtset panelvar year
xtreg PCA_finindex i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base



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


********* Clean
drop fact1 fact2 fact3 fact1_std fact2_std fact3_std


save"panel_v4", replace
****************************************
* END
















****************************************
* Finindex no. 2
****************************************
use"panel_v4", clear

/*
- Relative financial margin
- Debt service
- Trap ratio
- Loans per capita
- Debt to assets
*/


********** Global
global varstd rfm_std dsr_std tdr_std lpc_std dar_std
global var rfm dsr tdr lpc dar


********** Desc
tabstat $var, stat(n mean cv p50) by(year)

corr $varstd

factortest $varstd


********* PCA
pca $varstd
pca $varstd, comp(2)
estat kmo
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))


*** Corr between var and fact
cpcorr $varstd \ fact1 fact2


*** Std indiv score
forvalues i=1/2 {
qui sum fact`i'
gen fact`i'_std = (fact`i'-r(min))/(r(max)-r(min))
}


*** Index construction
gen PCA_finindexnew=((fact1_std*0.62)+(fact2_std*0.38))*100


*** Index meaning
cpcorr fact1 fact2 $varstd \ PCA_finindexnew
tabstat PCA_finindexnew, stat(n mean cv q) by(year)
tabstat PCA_finindexnew, stat(n mean cv q) by(caste)



*** Econo
xtset panelvar year
xtreg PCA_finindexnew i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base




********** Stability over time
preserve
keep HHID_panel year PCA_finindexnew caste
reshape wide PCA_finindexnew, i(HHID_panel) j(year)
cls
corr PCA_finindexnew2010 PCA_finindexnew2016 PCA_finindexnew2020
corr PCA_finindexnew2010 PCA_finindexnew2016 PCA_finindexnew2020 if caste==1
corr PCA_finindexnew2010 PCA_finindexnew2016 PCA_finindexnew2020 if caste==2
corr PCA_finindexnew2010 PCA_finindexnew2016 PCA_finindexnew2020 if caste==3
restore



********* Clean
drop fact1 fact2 fact1_std fact2_std



save"panel_v5", replace
****************************************
* END














****************************************
* Finindex by simple calculation to compare
****************************************
use"panel_v5", clear



********** Specification no. 1
/*
- Livelihood pc
- Wealth pc
- Relative financial margin
- Debt service
- Trap ratio
- Loans per capita
- Debt to assets
*/
global varstd dailyincome4_pc_std assets_pc_std rfm_std dsr_std tdr_std lpc_std dar_std
global var dailyincome4_pc assets_pc rfm dsr tdr lpc dar

tabstat $varstd, stat(n mean cv p50 min max)
tabstat $var, stat(n mean cv p50 min max)




********** Specification no.2 
/*
- Relative financial margin
- Debt service
- Trap ratio
- Loans per capita
- Debt to assets
*/
global varnewstd rfmrev_std dsr_std tdr_std lpc_std dar_std
global varnew rfmrev dsr tdr lpc dar

tabstat $varnewstd, stat(n mean cv q min max)
tabstat $varnew, stat(n mean cv q min max)


* Step 1: Reduce
/*
replace rfmrev=200 if rfmrev>200
replace rfmrev=-300 if rfmrev<-300
replace dsr=100 if dsr>100
replace dar=100 if dar>100
*/
tabstat $varnew, stat(min p1 p5 p10 q p90 p95 p99 max)


* Step 2: Rowmean of %
*egen percmean=rowmean(rfmrev dsr tdr dar)
gen percmean=(tdr*0.5)+(dsr*0.2)+(dar*0.2)+(rfmrev*0.1)

tabstat $varnew percmean, stat(n mean cv p50 min max)


* Step 3: Nb of loan in % by divided by 100
*ta lpc
gen multinbl=1+(lpc/10)


* Step 4: Final res
gen M_finindexnew=percmean*multinbl
cpcorr $varnew \ M_finindexnew


* Comparison with PCA
corr M_finindexnew PCA_finindexnew

tabstat M_finindexnew PCA_finindexnew, stat(n mean cv q min max)

twoway ///
(scatter M_finindexnew PCA_finindexnew) ///
(qfit M_finindexnew PCA_finindexnew)




save"panel_v6", replace
****************************************
* END













****************************************
* Overlap 2 specifications
****************************************
use"panel_v6", clear


********** Prepa
xtset panelvar year



********** Overlap
/*
twoway ///
(scatter PCA_finindexnew PCA_finindex)
*/



********** Prediction of assets and income for 2nd specification
qui xtreg PCA_finindexnew i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base re
est store store1

qui xtreg PCA_finindexnew i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill  i.dummydemonetisation i.dummymarriage i.dummyexposure assets_pc_std dailyincome4_pc_std, base re
est store store2

qui xtreg PCA_finindexnew i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base fe
est store store3

qui xtreg PCA_finindexnew i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill  i.dummydemonetisation i.dummymarriage i.dummyexposure assets_pc_std dailyincome4_pc_std, base fe
est store store4

esttab store1 store2 store3 store4




********** Determinants comparison
foreach y in PCA_finindex PCA_finindexnew {
qui xtreg `y' i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base re
est store RE_`y'_1

qui xtreg `y' i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill  i.dummydemonetisation i.dummymarriage i.dummyexposure, base re
est store RE_`y'_2

qui xtreg `y' i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base fe
est store FE_`y'_1

qui xtreg `y' i.caste i.tof c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill  i.dummydemonetisation i.dummymarriage i.dummyexposure, base fe
est store FE_`y'_2
}

cls
esttab RE_PCA_finindex_1 RE_PCA_finindexnew_1
esttab RE_PCA_finindex_2 RE_PCA_finindexnew_2
esttab FE_PCA_finindex_1 FE_PCA_finindexnew_1
esttab FE_PCA_finindex_2 FE_PCA_finindexnew_2



****************************************
* END
















****************************************
* Trends
****************************************
use"panel_v6", clear


***** Trends
preserve
keep if dummypanel==1
keep HHID_panel year PCA_finindex
reshape wide PCA_finindex, i(HHID_panel) j(year)
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore

****************************************
* END




















****************************************
* Prediction power
****************************************
use"panel_v6", clear


********** To keep
global vardebt PCA_finindex PCA_finindexnew dsr dar rfm tdr lpc
global varlabour head_nboccupation nbworker_HH hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH sharehoursayearagri_HH sharehoursayearnonagri_HH
keep panelvar year $vardebt $varlabour
mdesc $vardebt $varlabour


********** Reshape
reshape wide $vardebt $varlabour, i(panelvar) j(year)


********** Re-organize the dataset
*** Drop occ 2010
foreach x in $varlabour {
drop `x'2010
}

*** Drop debt 2020
foreach x in $vardebt {
drop `x'2020
}

*** Rename
foreach x in $vardebt {
rename `x'2010 `x'1
rename `x'2016 `x'2
}

foreach x in $varlabour {
rename `x'2016 `x'1
rename `x'2020 `x'2
}

*** Clean with only full obs, i.e. full panel HH
drop if PCA_finindex1==.
drop if PCA_finindex2==.
drop if head_nboccupation2==.


*** Reshape
reshape long $vardebt $varlabour, i(panelvar) j(period)
mdesc $vardebt $varlabour



********** Test econometrics
xtset panelvar period
tabstat $varlabour, stat(n mean cv p50 min max)

cls
foreach y in $vardebt {
foreach x in $varlabour {
xtreg `y' `x', fe
}
}


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
