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


save"panel_v4", replace
****************************************
* END




















****************************************
* Specification no. 1
****************************************
use"panel_v4", clear

gen dummytrap=0
replace dummytrap=1 if tdr>0
ta dummytrap

********** Factoshiny
/*
preserve
keep HHID_panel year dailyincome4_pc_std assets_total_std rfm_std dsr_std dar_std afm_std isr_std dummytrap
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore
*/

********** Var
*global varstd assetsrev_std incomerev_std isr_std tdr_std
*global varstd assetsrev_std incomerev_std tdr_std dsr_std

*global varstd assetsrev_std incomerev_std isr_std tdr_std dar_std
*global varstd assetsrev_std incomerev_std dsr_std tdr_std dar_std

*global varstd assetsrev_std isr_std tdr_std dar_std
*global varstd assetsrev_std dsr_std tdr_std dar_std

*global varstd incomerev_std isr_std tdr_std dar_std
*global varstd incomerev_std dsr_std tdr_std dar_std

*global varstd incpercpl_std isr_std tdr_std dar_std
*global varstd incpercpl_std dsr_std tdr_std dar_std

*global varstd annualincome_HH_std isr_std tdr_std dar_std
*global varstd annualincome_HH_std dsr_std tdr_std dar_std

*global varstd annualincome_HH_std assets_total_std isr_std tdr_std dar_std
*global varstd annualincome_HH_std assets_total_std dsr_std tdar_std dar_std

*global varstd annualincome_HH_std assets_total_std isr_std tar_std dar_std
*global varstd annualincome_HH_std assets_total_std dsr_std tar_std dar_std

*global varstd dailyincome4_pc_std afm_std dsr_std tdr_std dar_std
*global varstd dailyincome4_pc_std afm_std isr_std tdr_std dar_std
*global varstd dailyincome4_pc_std afm_std dsr_std isr_std tdr_std dar_std

*global varstd dailyincome4_pc_std rfm_std dsr_std tdr_std dar_std
*global varstd dailyincome4_pc_std rfm_std isr_std tdr_std dar_std

*global varstd afm_std dsr_std tdr_std dar_std 
*global varstd afm_std isr_std tdr_std dar_std

*global varstd dailyincome4_pc_std afm_std dsr_std dar_std nbloans_HH_std

*global varstd annualincome_HH_std assets_total_std afm_std dsr_std tdr_std dar_std

*global varstd dailyincome4_pc_std assets_total_std afm_std dsr_std dar_std
global varstd assetsrev_std incomerev_std afmrev_std dsr_std dar_std

corr $varstd
*graph matrix $varstd, half msize(vsmall) msymbol(oh) mcolor(black%30)
factortest $varstd


********* Method 1: Factor analysis
factor $varstd, pcf
/*
Factor1	1.83325	0.56665	0.3666	0.3666
Factor2	1.26660	0.39246	0.2533	0.6200
*/
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
gen PCA_finindex=((fact1_std*0.59)+(fact2_std*0.41))*100


*** Index meaning
cpcorr $varstd fact1 fact2 \ PCA_finindex
reg PCA_finindex $varstd





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



********** PCA vs Arithmetic mean
tabstat PCA_finindex M_finindex MW_finindex MW2_finindex, stat(n mean cv q)

* Diff
sort MW2_finindex
gen n_MW2=_n

sort PCA_finindex
gen n_PCA=_n

gen diff=n_MW2-n_PCA
gen absdiff=abs(diff)
ta absdiff

sort MW2_finindex
br HHID_panel year absdiff PCA_finindex n_PCA MW2_finindex n_MW2 dailyusdincome4_pc dar dsr rfmrev step1 lambda lambdarev



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
global varstd isr_std tdr_std dar_std rfmrev_std dir_std dsr_std
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




********** Panel analysis

* Caste
fre caste
gen dalits=caste
recode dalits (2=0) (3=0)
label values dalits yesno
ta dalits year, col nofreq

* Type of family
fre tof
gen stem=tof
recode stem (2=0) (3=1)
label values stem yesno
ta stem year, col nofreq

* Initialize
global control stem dalits HHsize
global control2 dalits c.HHsize##i.stem
xtset panelvar year

xtreg PCA_finindex1 $control
xtreg M_finindex1 $control
xtreg PCA_finindex2 $control
xtreg M_finindex2 $control


xtreg PCA_finindex1 $control2
xtreg M_finindex1 $control2
xtreg PCA_finindex2 $control2
xtreg M_finindex2 $control2






********** Contrib of shocks

*** Prepa
global control i.tof HHsize i.caste


*** Demonetisation 2016-17
reg PCA_finindex1 dummydemonetisation $control if year==2016
reg M_finindex1 dummydemonetisation $control if year==2016
reg PCA_finindex2 dummydemonetisation $control if year==2016
reg M_finindex2 dummydemonetisation $control if year==2016

*** Second lockdown 2021
reg PCA_finindex1 dummyexposure $control if year==2020
reg M_finindex1 dummyexposure $control if year==2020
reg PCA_finindex2 dummyexposure $control if year==2020
reg M_finindex2 dummyexposure $control if year==2020

*** Marriage 2016-17
reg PCA_finindex1 dummymarriage $control if year==2016
reg M_finindex1 dummymarriage $control if year==2016
reg PCA_finindex2 dummymarriage $control if year==2016
reg M_finindex2 dummymarriage $control if year==2016

*** Marriage 2020-21
reg PCA_finindex1 dummymarriage $control if year==2020
reg M_finindex1 dummymarriage $control if year==2020
reg PCA_finindex2 dummymarriage $control if year==2020
reg M_finindex2 dummymarriage $control if year==2020



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
