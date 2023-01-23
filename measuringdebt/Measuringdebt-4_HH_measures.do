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
global overlap dar_std dsr_std afm_std rfm_std isr_std dailyincome_pc_std assets_total_std lapc_std

global overlap incomerev_std dar_std rfmrev_std dsr_std lapc_std


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
global varstd dailyincome_pc_std assets_pc_std rfm_std dsr_std tdr_std lpc_std dar_std
global var dailyincome_pc assets_pc rfm dsr tdr lpc dar


********** Factoshiny
preserve
keep HHID_panel year $varstd
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\pca.csv", replace
restore


********** Desc
tabstat $var, stat(n mean cv p50) by(year)

corr $varstd

factortest $varstd
* Bartlett: 0.00
* KMO: 0.586


********* PCA
pca $varstd
* 3 compo --> 62.05%
pca $varstd, comp(3)
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2 fact3
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))

*** Cluster
cluster wardslinkage fact1 fact2 fact3, measure(L2)
*cluster dendrogram, cutnumber(100)
cluster gen clust=groups(4)

/*
twoway ///
(scatter fact2 fact1 if clust==1, mcolor(plb1%50) ms(oh) xline(0) yline(0)) ///
(scatter fact2 fact1 if clust==2, mcolor(ply1%50) ms(oh)) ///
(scatter fact2 fact1 if clust==3, mcolor(plr1%50) ms(oh)) ///
(scatter fact2 fact1 if clust==4, mcolor(plg1%50) ms(oh)) ///
, aspectratio(0.7)

twoway ///
(scatter fact3 fact1 if clust==1, mcolor(plb1%50) ms(oh) xline(0) yline(0)) ///
(scatter fact3 fact1 if clust==2, mcolor(ply1%50) ms(oh)) ///
(scatter fact3 fact1 if clust==3, mcolor(plr1%50) ms(oh)) ///
(scatter fact3 fact1 if clust==4, mcolor(plg1%50) ms(oh)) ///
, aspectratio(0.7)

twoway ///
(scatter fact3 fact2 if clust==1, mcolor(plb1%50) ms(oh) xline(0) yline(0)) ///
(scatter fact3 fact2 if clust==2, mcolor(ply1%50) ms(oh)) ///
(scatter fact3 fact2 if clust==3, mcolor(plr1%50) ms(oh)) ///
(scatter fact3 fact2 if clust==4, mcolor(plg1%50) ms(oh)) ///
, aspectratio(0.7)
*/

tabstat $var, stat(n mean cv p50) by(clust)
/*
1. Vulnerable
2. Middle trapped
3. High debt but high incomes
4. Highly vulnerable
*/

recode clust (3=1) (2=2) (1=3) (4=4)
label define clust1 1"Rich" 2"Middle trapped" 3"Vulnerable" 4"Highly"
label values clust clust1

ta clust year, col nofreq chi2

ta clust caste if year==2010, col nofreq chi2
ta clust caste if year==2016, col nofreq chi2
ta clust caste if year==2020, col nofreq chi2

ta clust stem if year==2010, col nofreq chi2
ta clust stem if year==2016, col nofreq chi2
ta clust stem if year==2020, col nofreq chi2

drop _clus_1_id _clus_1_ord _clus_1_hgt 
rename clust pcaindexclust

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
xtreg PCA_finindex i.caste i.stem c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base



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
* Bartlett: 0.00
* KMO: 0.628

********* PCA
pca $varstd
* 2 compo --> 60.65%
pca $varstd, comp(2)
estat kmo
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))


*** Cluster
cluster wardslinkage fact1 fact2, measure(L2)
*cluster dendrogram, cutnumber(100)
cluster gen clust=groups(3)

/*
twoway ///
(scatter fact2 fact1 if clust==1, mcolor(plb1%50) ms(oh) xline(0) yline(0)) ///
(scatter fact2 fact1 if clust==2, mcolor(ply1%50) ms(oh)) ///
(scatter fact2 fact1 if clust==3, mcolor(plr1%50) ms(oh)) ///
, aspectratio(0.7)
*/

tabstat $var, stat(n mean cv p50) by(clust)
/*
1. Non-vuln
2. Transition
3. Highly
*/

recode clust (1=1) (2=2) (3=3)
label define clust2 1"Non-vulnerable" 2"Transition" 3"Highly vulnerable"
label values clust clust2

ta clust year, col nofreq chi2

ta clust caste if year==2010, col nofreq chi2
ta clust caste if year==2016, col nofreq chi2
ta clust caste if year==2020, col nofreq chi2

ta clust stem if year==2010, col nofreq chi2
ta clust stem if year==2016, col nofreq chi2
ta clust stem if year==2020, col nofreq chi2

drop _clus_2_id _clus_2_ord _clus_2_hgt 
rename clust pca2indexclust

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
cpcorr fact1 fact2 \ PCA_finindexnew
cpcorr $varstd \ PCA_finindexnew
cpcorr $var \ PCA_finindexnew



*** Econo
xtset panelvar year
xtreg PCA_finindexnew i.caste i.stem c.HHsize c.HH_count_child i.head_sex head_age i.head_mocc_occupation i.head_edulevel i.vill, base




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
* Finindex no. 3
****************************************
use"panel_v5", clear

********** Clean
replace assets_pc=assets_pc/1000
replace lapc=lapc/10000
replace afm=afm/10000

********** Global
global varstd dailyincome_pc_std assets_pc_std dsr_std dar_std lapc_std afm_std
global var dailyincome_pc assets_pc dsr dar lapc afm


*** Cluster
cluster wardslinkage $varstd, measure(L2)
cluster dendrogram, cutnumber(100)
cluster gen clust=groups(3)

tabstat $var, stat(p50) by(clust)

ta clust year
ta clust year, col nofreq

ta clust caste if year==2010, exp cchi2 chi2
ta clust caste if year==2016, exp cchi2 chi2
ta clust caste if year==2020, exp cchi2 chi2






save"panel_v5", replace
****************************************
* END
























****************************************
* Finindex by simple calculation to compare
****************************************
use"panel_v5", clear

/*
- Relative financial margin
- Debt service
- Trap ratio
- Loans per capita
- Debt to assets
*/
global varnew rfmrev dsr tdr lpc dar
tabstat $varnew, stat(n mean cv p50) long by(dalits)

tabstat $varnew, stat(n mean cv q min max)
tabstat $varnew, stat(cv min p1 p5 p10 q p90 p95 p99 max range iqr)


* Step 1: Reduce
*replace tdr=100 if tdr>0


* Step 2: Rowmean of %
*egen percmean=rowmean(rfmrev dsr tdr dar)
*gen percmean=(rfmrev*(1/26))+(dsr*(4/26))+(tdr*(17/26))+(dar*(4/26))
gen percmean=(rfmrev*(5/100))+(dsr*(10/100))+(tdr*(80/100))+(dar*(5/100))


tabstat $varnew percmean, stat(n mean cv p50 min max)


* Step 3: Nb of loan in % by divided by 100
*ta lpc
gen multinbl=1+(lpc/10)


* Step 4: Final res
gen M_finindexnew=percmean*multinbl
cpcorr $varnew \ M_finindexnew


* Comparison with PCA
corr M_finindexnew PCA_finindexnew


* Scatter
/*
twoway ///
(scatter M_finindexnew PCA_finindexnew, mcolor(black%30)) ///
(qfit M_finindexnew PCA_finindexnew)
*/


* Caste
tabstat $varnew M_finindexnew, stat(n mean p50) by(dalits) long


* Heatplot
/*
preserve
xtile M_q=M_finindexnew, n(10)
xtile PCA_q=PCA_finindexnew, n(10)

rename PCA_q x
rename M_q y
qui ta x, gen(x_)
qui ta y, gen(y_)
forvalues i=1(1)10 {
bysort x y: egen n_tot`i'=sum(x_`i')
qui count if n_tot`i'!=0
gen perc_`i'=n_tot`i'/r(N)
}
gen perc=.
forvalues i=1(1)10{
replace perc=perc_`i' if perc_`i'!=0
}
*
heatplot perc x y, ///
colors(HSV grays, reverse) ///
statistic(mean) ///
xscale(alt) xbwidth(1) xlab(0(1)10) xtitle("PCA") ///
yscale(reverse) ybwidth(1) ylab(0(1)10) ytitle("Mean") ///
legend(off) title("")
restore
*/


********** Clean
drop percmean multinbl

save"panel_v6", replace
****************************************
* END












****************************************
* Clean name and overlap
****************************************
use"panel_v6", clear

*** Rename
rename PCA_finindex pcaindex
rename PCA_finindexnew pca2index
rename M_finindexnew m2index


********** Overlap
*graph matrix pcaindex pca2index m2index, half msize(vsmall) msymbol(oh) mcolor(black%30)

***
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

save"panel_v7", replace
****************************************
* END







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
