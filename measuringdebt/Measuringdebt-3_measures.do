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
* FVI
****************************************
use"panel_v3", clear


*** Income
replace rrgpl=100 if rrgpl>100
replace rrgpl=0 if rrgpl<0

*** ISR
replace isr=100 if isr>100
ta isr


*** TDR
ta tdr


*** FVI
gen fvi=(2*tdr+2*isr+rrgpl)/5


save"panel_v4", replace
****************************************
* END









****************************************
* Sensitivity tests
****************************************
use"panel_v4", clear

/*
- Poverty line
- Equivalence scale
- Weight in the average
*/


*** Poverty line at US$2.2
*gen dailyincome_pc=(annualincome_HH/365)/squareroot_HHsize
*gen dailyusdincome_pc=dailyincome_pc/45.73
gen rrgpl2=((dailyusdincome_pc-2.15)/2.15)*(-1)*100
replace rrgpl2=100 if rrgpl2>100
replace rrgpl2=0 if rrgpl2<0
gen fvi2=(2*tdr+2*isr+rrgpl2)/5



*** Equivalence scale
* None
gen dailyincome_pc3=(annualincome_HH/365)/HHsize
gen dailyusdincome_pc3=dailyincome_pc3/45.73
gen rrgpl3=((dailyusdincome_pc3-1.9)/1.9)*(-1)*100
replace rrgpl3=100 if rrgpl3>100
replace rrgpl3=0 if rrgpl3<0
gen fvi3=(2*tdr+2*isr+rrgpl3)/5


* OECD
gen dailyincome_pc4=(annualincome_HH/365)/equiscale_HHsize
gen dailyusdincome_pc4=dailyincome_pc4/45.73
gen rrgpl4=((dailyusdincome_pc4-1.9)/1.9)*(-1)*100
replace rrgpl4=100 if rrgpl4>100
replace rrgpl4=0 if rrgpl4<0
gen fvi4=(2*tdr+2*isr+rrgpl4)/5

* Modified OECD
gen dailyincome_pc5=(annualincome_HH/365)/equimodiscale_HHsize
gen dailyusdincome_pc5=dailyincome_pc5/45.73
gen rrgpl5=((dailyusdincome_pc5-1.9)/1.9)*(-1)*100
replace rrgpl5=100 if rrgpl5>100
replace rrgpl5=0 if rrgpl5<0
gen fvi5=(2*tdr+2*isr+rrgpl5)/5



*** Weight
gen fvi6=(tdr+isr+rrgpl)/3
gen fvi7=(3*tdr+3*isr+rrgpl)/7



********** Distrib
*** Pos
sort fvi
gen pos_fvi=(_n/1529)*100

forvalues i=2/7 {
sort fvi`i'
gen pos_fvi`i'=(_n/1529)*100
}

*** Diff
forvalues i=2/7 {
gen diff_fvi`i'=pos_fvi`i'-pos_fvi
}


*** Abs diff
forvalues i=2/7 {
gen absdiff_fvi`i'=abs(diff_fvi`i')
ta absdiff_fvi`i'
}

*** 5% change threshold
forvalues i=2/7 {
gen threshold1_fvi`i'=0
gen threshold5_fvi`i'=0
gen threshold10_fvi`i'=0
gen threshold20_fvi`i'=0
}
forvalues i=2/7 {
replace threshold1_fvi`i'=1 if absdiff_fvi`i'>1
replace threshold5_fvi`i'=1 if absdiff_fvi`i'>5
replace threshold10_fvi`i'=1 if absdiff_fvi`i'>10
replace threshold20_fvi`i'=1 if absdiff_fvi`i'>20
}



********* Graph
forvalues i=2/7 {
set graph off
twoway ///
(scatter fvi`i' fvi, ms(oh) mc(black%30)) ///
(function y=x, range(0 100)) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("FVI") ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("FVI-`i'") ///
legend(off) name(f`i', replace)
set graph on
}

graph combine f2 f3 f4 f5 f6 f7, col(3) name(fcomb, replace)



********** Desc share






********** Res
tabstat fvi fvi2 fvi3 fvi4 fvi5 fvi6 fvi7, stat(n mean cv)




save"panel_v5", replace
****************************************
* END










/*
****************************************
* Graph PCA
****************************************
use"panel_v3", clear

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






/*
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
/*
preserve
keep HHID_panel year $varstd
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\pca.csv", replace
restore
*/

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
*/




/*
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
*/
