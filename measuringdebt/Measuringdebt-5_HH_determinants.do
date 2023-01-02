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
* Evo over time
****************************************
use"panel_v7", clear


tabstat pca2index m2index, stat(n mean cv p50) by(year) long


tabstat dsr_std dar_std lpc_std rfmrev_std tdr_std, stat(n mean cv p50) by(year) long


tabstat dsr dar lpc rfmrev tdr, stat(n mean cv p50) by(year) long


stripplot pca2index, over(time) vert ///
stack width(0.2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks) name(sp`x', replace)

****************************************
* END












****************************************
* FE vs RE?
****************************************
use"panel_v7", clear

xtset panelvar time

********** Qreg test
xtqreg pca2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc, q(.5)

qregpd pca2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc, id(panelvar) fix(time) q(.5)


********** RE
* BP LM test
xtreg pca2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base re
est store pcaRE
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No random effect
*/

xtreg m2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base re
est store mRE
xttest0
/*
pvalue higher than .05, we do not reject H0
-> No random effect
*/



********** FE
xtreg pca2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store pcaFE
/*
pvalue lower than .05, we reject H0
-> Fixed effect
*/

xtreg m2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store mFE
/*
pvalue lower than .05, we reject H0
-> Fixed effect
*/





****************************************
* END











****************************************
* FE vs CRE?
****************************************
use"panel_v7", clear



********** CRE to have FE with constant terms as caste
global mean stem_mean HHsize_mean HH_count_child_mean head_female_mean head_age_mean head_occ2_mean head_occ3_mean head_occ4_mean head_occ5_mean head_occ6_mean head_occ7_mean head_educ2_mean head_educ3_mean head_nonmarried_mean dummymarriage_mean assets_pc_mean dailyincome_pc_mean


/*
The between R2 is "How much of the variance between seperate panel units does my model account for"
The within R2 is "How much of the variance within the panel units does my model account for"
and the R2 overall is a weighted average of these two.
*/

*** PCA
xtreg pca2index i.caste stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill $mean, base re


*** Mean
xtreg m2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill $mean, base re



****************************************
* END










****************************************
* Effect of family
****************************************
use"panel_v7", clear

xtreg dsr_std dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store dsr

xtreg dar_std dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store dar

xtreg lpc_std dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store lpc

xtreg tdr_std dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store tdr

xtreg rfmrev_std dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store rfmrev

xtreg pca2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store pca

xtreg m2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill, base fe
est store m

esttab dsr dar tdr rfmrev lpc, ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	

esttab pca m, ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///
	legend label varlabels(_cons constant) ///
	stats(N r2_p ll chi2 p, fmt(0 2 2 2 2) labels(`"Observations"' `"Pseudo \$R^2$"' `"Log-likelihood"' `"$\upchi^2$"' `"p-value"')) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace	





****************************************
* END














****************************************
* Effect of marriage 
****************************************
use"panel_v7", clear

/*
For a real diff in diff, need to observe the trend of Y before
So I can only investigate the impact of marriage between 2016-17 
and 2020-21
Bc, I can obs trend in index between 2010 and 2016-17.

Need to do a conditional diff in diff matching
*/



********** Test psmatch2
/*
I do not remember how to do
*/

reg pca2index dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill if year==2020



********** Diff in diff
gen time=.
replace time=0 if year==2010
replace time=0 if year==2016
replace time=1 if year==2020

reg pca2index i.dummymarriage##i.time dalits stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill


****************************************
* END










****************************************
* Trends
****************************************
use"panel_v7", clear

/*
********** Trends
preserve
keep if dummypanel==1
keep HHID_panel year pca2index m2index

reshape wide pca2index m2index, i(HHID_panel) j(year)
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore
*/

/*
********** Import
import delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\indextrend.csv", clear



save"indextrend.dta", replace
*/



********** Diff
keep HHID_panel year pca2index m2index
reshape wide pca2index m2index, i(HHID_panel) j(year)

gen diff1=0
replace diff1=pca2index2016-pca2index2010 if pca2index2010!=. & pca2index2016!=.
replace diff1=0 if diff1>-5 & diff1<5 & diff1!=.
replace diff1=. if pca2index2010==.
replace diff1=. if pca2index2016==.

gen diff2=0
replace diff2=pca2index2020-pca2index2016 if pca2index2016!=. & pca2index2020!=.
replace diff2=0 if diff2>-5 & diff2<5 & diff2!=.
replace diff2=. if pca2index2016==.
replace diff2=. if pca2index2020==.


* Trends
gen trend1=.
replace trend1=1 if diff1<0 & diff1!=.
replace trend1=2 if diff1==0 & diff1!=.
replace trend1=3 if diff1>0 & diff1!=.

gen trend2=.
replace trend2=1 if diff2<0 & diff2!=.
replace trend2=2 if diff2==0 & diff2!=.
replace trend2=3 if diff2>0 & diff2!=.

label define trend 1"Dec" 2"Sta" 3"Inc"
label values trend1 trend
label values trend2 trend

* Groups
egen trends=group(trend1 trend2), label
fre trends

* Groups 2
fre trends
gen trends2=trends
recode trends2 (2=1) (4=1) (8=6) (9=6)
recode trends2 (3=2) (5=3) (6=4) (7=5)
ta trends trends2
label define trends2 1"Dec" 2"Dec-Inc" 3"Sta" 4"Inc" 5"Inc-Dec"
label values trends2 trends2
fre trends2

* Groups 3 
fre trends2
gen trends3=trends2
recode trends3 (1=0) (2=0) (3=0) (4=1) (5=0)
gen absdiff1=abs(diff1)
gen absdiff2=abs(diff2)
replace trends3=1 if trends2==2 & absdiff1<absdiff2
replace trends3=1 if trends2==5 & absdiff1>absdiff2
label define trends3 0"Stab" 1"Worse"
label values trends3 trends3

ta trends2 trends3


save "indextrend", replace


********** Add var
use"panel_v7", clear

merge m:1 HHID_panel using "indextrend.dta"
drop _merge


ta trends caste if year==2010, chi2 exp

ta trends2 caste if year==2010, chi2 exp

ta trends3 caste if year==2010, chi2 exp


probit trends3 i.caste stem HHsize HH_count_child head_female head_age head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ2 head_educ3 head_nonmarried dummymarriage assets_pc dailyincome_pc i.vill if year==2010



save"panel_v8", replace
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
