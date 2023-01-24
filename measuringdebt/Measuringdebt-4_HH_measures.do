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




/*
FactomineR:
Linkage: Ward
Distance: L2squared  squared Euclidean distance 
*/








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
pca $varstd, comp(4)
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2 fact3 fact4
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))

*** Cluster
cluster wardslinkage fact1 fact2 fact3 fact4, measure(L2)
*cluster dendrogram, cutnumber(100)
cluster stop
cluster gen clust=groups(5)

tabstat $var, stat(p50) by(clust)
/*
1. Non-vulnerable
2. ++ Vulnerable
3. +++ Vulnerable
4. Rich trapped
5. Sustainable
*/

label define clust1 1"Non-vulnerable" 2"++ Vulnerable" 3"+++ Vulnerable" 4"Rich trapped" 5"Sustainble"
label values clust clust1

ta clust year
ta clust caste

ta clust year, col nofreq
ta clust caste, col nofreq

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
drop fact1 fact2 fact3 fact1_std fact2_std fact3_std fact4


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
pca $varstd, comp(3)
estat kmo
*screeplot, ci mean
rotate, quartimin

*** Projection of individuals
predict fact1 fact2 fact3
*twoway (scatter fact2 fact1, xline(0) yline(0) mcolor(black%30) msymbol(oh))


*** Cluster
cluster wardslinkage fact1 fact2 fact3, measure(L2)
*cluster dendrogram, cutnumber(100)
cluster stop
cluster gen clust=groups(5)


tabstat $var, stat(p50) by(clust)
/*
1. Non-vulnerable
2. Trapped
3. Vulnerable
4. +++ Vulnerable
5. ++ Vulnerable
*/

label define clust2 1"Non-vulnerable" 2"Trapped" 3"Vulnerable" 4"+++ Vulnerable" 5"++ Vulnerable"
label values clust clust2

ta clust year
ta clust caste

ta clust year, col nofreq chi2
ta clust caste, col nofreq chi2

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
drop fact1 fact2 fact1_std fact2_std fact3



save"panel_v5", replace
****************************************
* END










****************************************
* Test
****************************************
use"panel_v5", clear

merge 1:1 HHID_panel year using "panel_v9", keepusing(hoursayear_female hoursayear_dep hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_casu_female)

keep HHID_panel year hoursayear_female hoursayear_dep hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_casu_female  assets_pc_std dsr_std dar_std afm_std tdr_std afm_std dailyincome_pc_std lapc_std lpc_std

reshape wide dsr_std dar_std tdr_std afm_std assets_pc_std hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_female hoursayear_dep hoursayear_casu_female dailyincome_pc_std lapc_std lpc_std, i(HHID_panel) j(year)


cls
cpcorr lapc_std2010 lpc_std2010 dailyincome_pc_std2010 dsr_std2010 dar_std2010 tdr_std2010 afm_std2010 assets_pc_std2010 \ hoursayear_casu2016
cpcorr lapc_std2016 lpc_std2016  dailyincome_pc_std2016 dsr_std2016 dar_std2016 tdr_std2016 afm_std2016 assets_pc_std2016 \ hoursayear_casu2020


cpcorr lapc_std2010 lpc_std2010 dailyincome_pc_std2010 dsr_std2010 dar_std2010 tdr_std2010 afm_std2010 assets_pc_std2010 \ hoursayear_female2016

cpcorr lapc_std2016 lpc_std2016  dailyincome_pc_std2016 dsr_std2016 dar_std2016 tdr_std2016 afm_std2016 assets_pc_std2016 \ hoursayear_female2020


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
global varstd assets_pc_std dsr_std dar_std afm_std tdr_std
global var assets_pc dsr dar afm tdr


/*
5 groupes pas mal, mais pas de casual:
global varstd dailyincome_pc_std assets_pc_std dsr_std dar_std rfm_std tdr_std
global var dailyincome_pc assets_pc dsr dar rfm tdr

*/

********** Pre tests
factortest $varstd


********* PCA
pca $varstd
*screeplot, ci mean
pca $varstd, comp(3)
rotate, quartimin

*** Projection of individuals
predict fact1 fact2 fact3


*** Cluster
cluster wardslinkage fact1 fact2 fact3, measure(L2squared)

cluster dendrogram, cutnumber(100)
cluster stop
cluster gen clust=groups(4)
ta clust year, col nofreq
tabstat $var, stat(p50) by(clust)

label define clust99 1"Poor" 2"Vulnerable" 3"Vulnerable" 4"Highly vulnerable"
label values clust clust99

ta clust year, col nofreq
ta clust caste, exp cchi2 chi2


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



do"C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\Measuringdebt-5_HH_determinants"
do"C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\Measuringdebt-6_HH_labouroutcomes"





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
