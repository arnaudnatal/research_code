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
replace rrgpl=-100 if rrgpl<-100
gen rrgpl2=rrgpl
replace rrgpl2=0 if rrgpl<0

*** ISR
replace isr=100 if isr>100
ta isr


*** TDR
ta tdr

*** TAR
replace tar=100 if tar>100

*** FVI
/*
2*tdr+2*isr+rrgpl2
tar+isr+rrgpl2
*/
gen fvi=(tar+isr+rrgpl2)/3



********** AMPI

*** Range 70-130
* TDR
ta tdr
gen a_tdr=((tdr-0)/(100-0))*60+70
sum a_tdr

* ISR
ta isr
gen a_isr=((isr-0)/(100-0))*60+70
sum a_isr

* RRGPL
ta rrgpl
gen a_rrgpl=((rrgpl+100)/(100+100))*60+70
sum a_rrgpl


*** Mean, CV, and STD
egen M=rowmean(a_tdr a_isr a_rrgpl)
egen S=rowsd(a_tdr a_isr a_rrgpl)
gen cv=S/M


*** AMPI
gen ampi=M+S*cv
ta ampi

*** Clean
drop a_tdr a_isr a_rrgpl M S cv
drop rrgpl
rename rrgpl2 rrgpl


********** Desc
tabstat fvi ampi, stat(n mean cv) by(year)
/*

    year |       fvi      ampi
---------+--------------------
    2010 |       405       405
         |  9.488783  85.40796
         |  .9620034  .1004855
---------+--------------------
    2016 |       492       492
         |  11.09747  85.37688
         |  1.194643  .1411051
---------+--------------------
    2020 |       632       632
         |  15.24777  87.07009
         |  1.034624  .1521721
---------+--------------------
   Total |      1529      1529
         |  12.38686  86.08499
         |  1.105246  .1370989
------------------------------
*/


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

*** Change threshold
forvalues i=2/7 {
forvalues j=0(1)100 {
gen fvi`i'_thre`j'=0
}
}

forvalues i=2/7 {
forvalues j=0(1)100 {
replace fvi`i'_thre`j'=1 if absdiff_fvi`i'>`j'
}
}


********** Graph 
preserve
keep fvi2_thre* fvi3_thre* fvi4_thre* fvi5_thre* fvi6_thre* fvi7_thre*

collapse (mean) fvi2_thre0 fvi2_thre1 fvi2_thre2 fvi2_thre3 fvi2_thre4 fvi2_thre5 fvi2_thre6 fvi2_thre7 fvi2_thre8 fvi2_thre9 fvi2_thre10 fvi2_thre11 fvi2_thre12 fvi2_thre13 fvi2_thre14 fvi2_thre15 fvi2_thre16 fvi2_thre17 fvi2_thre18 fvi2_thre19 fvi2_thre20 fvi2_thre21 fvi2_thre22 fvi2_thre23 fvi2_thre24 fvi2_thre25 fvi2_thre26 fvi2_thre27 fvi2_thre28 fvi2_thre29 fvi2_thre30 fvi2_thre31 fvi2_thre32 fvi2_thre33 fvi2_thre34 fvi2_thre35 fvi2_thre36 fvi2_thre37 fvi2_thre38 fvi2_thre39 fvi2_thre40 fvi2_thre41 fvi2_thre42 fvi2_thre43 fvi2_thre44 fvi2_thre45 fvi2_thre46 fvi2_thre47 fvi2_thre48 fvi2_thre49 fvi2_thre50 fvi2_thre51 fvi2_thre52 fvi2_thre53 fvi2_thre54 fvi2_thre55 fvi2_thre56 fvi2_thre57 fvi2_thre58 fvi2_thre59 fvi2_thre60 fvi2_thre61 fvi2_thre62 fvi2_thre63 fvi2_thre64 fvi2_thre65 fvi2_thre66 fvi2_thre67 fvi2_thre68 fvi2_thre69 fvi2_thre70 fvi2_thre71 fvi2_thre72 fvi2_thre73 fvi2_thre74 fvi2_thre75 fvi2_thre76 fvi2_thre77 fvi2_thre78 fvi2_thre79 fvi2_thre80 fvi2_thre81 fvi2_thre82 fvi2_thre83 fvi2_thre84 fvi2_thre85 fvi2_thre86 fvi2_thre87 fvi2_thre88 fvi2_thre89 fvi2_thre90 fvi2_thre91 fvi2_thre92 fvi2_thre93 fvi2_thre94 fvi2_thre95 fvi2_thre96 fvi2_thre97 fvi2_thre98 fvi2_thre99 fvi2_thre100 fvi3_thre0 fvi3_thre1 fvi3_thre2 fvi3_thre3 fvi3_thre4 fvi3_thre5 fvi3_thre6 fvi3_thre7 fvi3_thre8 fvi3_thre9 fvi3_thre10 fvi3_thre11 fvi3_thre12 fvi3_thre13 fvi3_thre14 fvi3_thre15 fvi3_thre16 fvi3_thre17 fvi3_thre18 fvi3_thre19 fvi3_thre20 fvi3_thre21 fvi3_thre22 fvi3_thre23 fvi3_thre24 fvi3_thre25 fvi3_thre26 fvi3_thre27 fvi3_thre28 fvi3_thre29 fvi3_thre30 fvi3_thre31 fvi3_thre32 fvi3_thre33 fvi3_thre34 fvi3_thre35 fvi3_thre36 fvi3_thre37 fvi3_thre38 fvi3_thre39 fvi3_thre40 fvi3_thre41 fvi3_thre42 fvi3_thre43 fvi3_thre44 fvi3_thre45 fvi3_thre46 fvi3_thre47 fvi3_thre48 fvi3_thre49 fvi3_thre50 fvi3_thre51 fvi3_thre52 fvi3_thre53 fvi3_thre54 fvi3_thre55 fvi3_thre56 fvi3_thre57 fvi3_thre58 fvi3_thre59 fvi3_thre60 fvi3_thre61 fvi3_thre62 fvi3_thre63 fvi3_thre64 fvi3_thre65 fvi3_thre66 fvi3_thre67 fvi3_thre68 fvi3_thre69 fvi3_thre70 fvi3_thre71 fvi3_thre72 fvi3_thre73 fvi3_thre74 fvi3_thre75 fvi3_thre76 fvi3_thre77 fvi3_thre78 fvi3_thre79 fvi3_thre80 fvi3_thre81 fvi3_thre82 fvi3_thre83 fvi3_thre84 fvi3_thre85 fvi3_thre86 fvi3_thre87 fvi3_thre88 fvi3_thre89 fvi3_thre90 fvi3_thre91 fvi3_thre92 fvi3_thre93 fvi3_thre94 fvi3_thre95 fvi3_thre96 fvi3_thre97 fvi3_thre98 fvi3_thre99 fvi3_thre100 fvi4_thre0 fvi4_thre1 fvi4_thre2 fvi4_thre3 fvi4_thre4 fvi4_thre5 fvi4_thre6 fvi4_thre7 fvi4_thre8 fvi4_thre9 fvi4_thre10 fvi4_thre11 fvi4_thre12 fvi4_thre13 fvi4_thre14 fvi4_thre15 fvi4_thre16 fvi4_thre17 fvi4_thre18 fvi4_thre19 fvi4_thre20 fvi4_thre21 fvi4_thre22 fvi4_thre23 fvi4_thre24 fvi4_thre25 fvi4_thre26 fvi4_thre27 fvi4_thre28 fvi4_thre29 fvi4_thre30 fvi4_thre31 fvi4_thre32 fvi4_thre33 fvi4_thre34 fvi4_thre35 fvi4_thre36 fvi4_thre37 fvi4_thre38 fvi4_thre39 fvi4_thre40 fvi4_thre41 fvi4_thre42 fvi4_thre43 fvi4_thre44 fvi4_thre45 fvi4_thre46 fvi4_thre47 fvi4_thre48 fvi4_thre49 fvi4_thre50 fvi4_thre51 fvi4_thre52 fvi4_thre53 fvi4_thre54 fvi4_thre55 fvi4_thre56 fvi4_thre57 fvi4_thre58 fvi4_thre59 fvi4_thre60 fvi4_thre61 fvi4_thre62 fvi4_thre63 fvi4_thre64 fvi4_thre65 fvi4_thre66 fvi4_thre67 fvi4_thre68 fvi4_thre69 fvi4_thre70 fvi4_thre71 fvi4_thre72 fvi4_thre73 fvi4_thre74 fvi4_thre75 fvi4_thre76 fvi4_thre77 fvi4_thre78 fvi4_thre79 fvi4_thre80 fvi4_thre81 fvi4_thre82 fvi4_thre83 fvi4_thre84 fvi4_thre85 fvi4_thre86 fvi4_thre87 fvi4_thre88 fvi4_thre89 fvi4_thre90 fvi4_thre91 fvi4_thre92 fvi4_thre93 fvi4_thre94 fvi4_thre95 fvi4_thre96 fvi4_thre97 fvi4_thre98 fvi4_thre99 fvi4_thre100 fvi5_thre0 fvi5_thre1 fvi5_thre2 fvi5_thre3 fvi5_thre4 fvi5_thre5 fvi5_thre6 fvi5_thre7 fvi5_thre8 fvi5_thre9 fvi5_thre10 fvi5_thre11 fvi5_thre12 fvi5_thre13 fvi5_thre14 fvi5_thre15 fvi5_thre16 fvi5_thre17 fvi5_thre18 fvi5_thre19 fvi5_thre20 fvi5_thre21 fvi5_thre22 fvi5_thre23 fvi5_thre24 fvi5_thre25 fvi5_thre26 fvi5_thre27 fvi5_thre28 fvi5_thre29 fvi5_thre30 fvi5_thre31 fvi5_thre32 fvi5_thre33 fvi5_thre34 fvi5_thre35 fvi5_thre36 fvi5_thre37 fvi5_thre38 fvi5_thre39 fvi5_thre40 fvi5_thre41 fvi5_thre42 fvi5_thre43 fvi5_thre44 fvi5_thre45 fvi5_thre46 fvi5_thre47 fvi5_thre48 fvi5_thre49 fvi5_thre50 fvi5_thre51 fvi5_thre52 fvi5_thre53 fvi5_thre54 fvi5_thre55 fvi5_thre56 fvi5_thre57 fvi5_thre58 fvi5_thre59 fvi5_thre60 fvi5_thre61 fvi5_thre62 fvi5_thre63 fvi5_thre64 fvi5_thre65 fvi5_thre66 fvi5_thre67 fvi5_thre68 fvi5_thre69 fvi5_thre70 fvi5_thre71 fvi5_thre72 fvi5_thre73 fvi5_thre74 fvi5_thre75 fvi5_thre76 fvi5_thre77 fvi5_thre78 fvi5_thre79 fvi5_thre80 fvi5_thre81 fvi5_thre82 fvi5_thre83 fvi5_thre84 fvi5_thre85 fvi5_thre86 fvi5_thre87 fvi5_thre88 fvi5_thre89 fvi5_thre90 fvi5_thre91 fvi5_thre92 fvi5_thre93 fvi5_thre94 fvi5_thre95 fvi5_thre96 fvi5_thre97 fvi5_thre98 fvi5_thre99 fvi5_thre100 fvi6_thre0 fvi6_thre1 fvi6_thre2 fvi6_thre3 fvi6_thre4 fvi6_thre5 fvi6_thre6 fvi6_thre7 fvi6_thre8 fvi6_thre9 fvi6_thre10 fvi6_thre11 fvi6_thre12 fvi6_thre13 fvi6_thre14 fvi6_thre15 fvi6_thre16 fvi6_thre17 fvi6_thre18 fvi6_thre19 fvi6_thre20 fvi6_thre21 fvi6_thre22 fvi6_thre23 fvi6_thre24 fvi6_thre25 fvi6_thre26 fvi6_thre27 fvi6_thre28 fvi6_thre29 fvi6_thre30 fvi6_thre31 fvi6_thre32 fvi6_thre33 fvi6_thre34 fvi6_thre35 fvi6_thre36 fvi6_thre37 fvi6_thre38 fvi6_thre39 fvi6_thre40 fvi6_thre41 fvi6_thre42 fvi6_thre43 fvi6_thre44 fvi6_thre45 fvi6_thre46 fvi6_thre47 fvi6_thre48 fvi6_thre49 fvi6_thre50 fvi6_thre51 fvi6_thre52 fvi6_thre53 fvi6_thre54 fvi6_thre55 fvi6_thre56 fvi6_thre57 fvi6_thre58 fvi6_thre59 fvi6_thre60 fvi6_thre61 fvi6_thre62 fvi6_thre63 fvi6_thre64 fvi6_thre65 fvi6_thre66 fvi6_thre67 fvi6_thre68 fvi6_thre69 fvi6_thre70 fvi6_thre71 fvi6_thre72 fvi6_thre73 fvi6_thre74 fvi6_thre75 fvi6_thre76 fvi6_thre77 fvi6_thre78 fvi6_thre79 fvi6_thre80 fvi6_thre81 fvi6_thre82 fvi6_thre83 fvi6_thre84 fvi6_thre85 fvi6_thre86 fvi6_thre87 fvi6_thre88 fvi6_thre89 fvi6_thre90 fvi6_thre91 fvi6_thre92 fvi6_thre93 fvi6_thre94 fvi6_thre95 fvi6_thre96 fvi6_thre97 fvi6_thre98 fvi6_thre99 fvi6_thre100 fvi7_thre0 fvi7_thre1 fvi7_thre2 fvi7_thre3 fvi7_thre4 fvi7_thre5 fvi7_thre6 fvi7_thre7 fvi7_thre8 fvi7_thre9 fvi7_thre10 fvi7_thre11 fvi7_thre12 fvi7_thre13 fvi7_thre14 fvi7_thre15 fvi7_thre16 fvi7_thre17 fvi7_thre18 fvi7_thre19 fvi7_thre20 fvi7_thre21 fvi7_thre22 fvi7_thre23 fvi7_thre24 fvi7_thre25 fvi7_thre26 fvi7_thre27 fvi7_thre28 fvi7_thre29 fvi7_thre30 fvi7_thre31 fvi7_thre32 fvi7_thre33 fvi7_thre34 fvi7_thre35 fvi7_thre36 fvi7_thre37 fvi7_thre38 fvi7_thre39 fvi7_thre40 fvi7_thre41 fvi7_thre42 fvi7_thre43 fvi7_thre44 fvi7_thre45 fvi7_thre46 fvi7_thre47 fvi7_thre48 fvi7_thre49 fvi7_thre50 fvi7_thre51 fvi7_thre52 fvi7_thre53 fvi7_thre54 fvi7_thre55 fvi7_thre56 fvi7_thre57 fvi7_thre58 fvi7_thre59 fvi7_thre60 fvi7_thre61 fvi7_thre62 fvi7_thre63 fvi7_thre64 fvi7_thre65 fvi7_thre66 fvi7_thre67 fvi7_thre68 fvi7_thre69 fvi7_thre70 fvi7_thre71 fvi7_thre72 fvi7_thre73 fvi7_thre74 fvi7_thre75 fvi7_thre76 fvi7_thre77 fvi7_thre78 fvi7_thre79 fvi7_thre80 fvi7_thre81 fvi7_thre82 fvi7_thre83 fvi7_thre84 fvi7_thre85 fvi7_thre86 fvi7_thre87 fvi7_thre88 fvi7_thre89 fvi7_thre90 fvi7_thre91 fvi7_thre92 fvi7_thre93 fvi7_thre94 fvi7_thre95 fvi7_thre96 fvi7_thre97 fvi7_thre98 fvi7_thre99 fvi7_thre100

gen n=_n
reshape long fvi2_thre fvi3_thre fvi4_thre fvi5_thre fvi6_thre fvi7_thre, j(pos) i(n)
drop n

forvalues i=2/7 {
replace fvi`i'_thre=fvi`i'_thre*100
}

*** Graph
forvalues i=2/7 {
set graph off
twoway ///
(line fvi`i'_thre pos if pos<40, xline(5 10 20)) ///
, ///
xtitle("Tolerance threshold (in pp)") xlabel(0(5)40) ///
ytitle("% of HH with FVI-`i' ≠ FVI")  ylabel(0(10)100) ymtick(0(5)100) ///
name(thr_fvi`i', replace)
set graph on
}

graph combine thr_fvi2 thr_fvi3 thr_fvi4 thr_fvi5 thr_fvi6 thr_fvi7, col(3) name(thr_comb, replace)
graph export "Sensi_threshold.pdf", as(pdf) replace
restore 


********* Graph
forvalues i=2/7 {
set graph off
twoway ///
(scatter fvi`i' fvi, ms(oh) mc(black%30)) ///
(function y=x, range(0 100)) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("FVI") ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("FVI-`i'") ///
legend(order(2 "First bisector") pos(6) col(1)) name(f`i', replace)
set graph on
}

grc1leg f2 f3 f4 f5 f6 f7, col(3) name(fcomb, replace)
graph export "Sensi_scatter.pdf", as(pdf) replace



********** Clean
drop fvi2_thre*
drop fvi3_thre*
drop fvi4_thre*
drop fvi5_thre*
drop fvi6_thre*
drop fvi7_thre*

drop pos_fvi pos_fvi2 pos_fvi3 pos_fvi4 pos_fvi5 pos_fvi6 pos_fvi7 absdiff_fvi2 absdiff_fvi3 absdiff_fvi4 absdiff_fvi5 absdiff_fvi6 absdiff_fvi7

drop dailyincome_pc4 dailyusdincome_pc4 rrgpl4 dailyincome_pc5 dailyusdincome_pc5 rrgpl5 dailyincome_pc3 dailyusdincome_pc3 rrgpl3 rrgpl2


save"panel_v5", replace
****************************************
* END






****************************************
* Sensitive var
****************************************
use"panel_v5", clear


tabstat fvi fvi2 fvi3 fvi4 fvi5 fvi6 fvi7, stat(mean cv q)

label var diff_fvi2 "FVI-2 - FVI"
label var diff_fvi3 "FVI-3 - FVI"
label var diff_fvi4 "FVI-4 - FVI"
label var diff_fvi5 "FVI-5 - FVI"
label var diff_fvi6 "FVI-6 - FVI"
label var diff_fvi7 "FVI-7 - FVI"

vioplot diff_fvi2 diff_fvi3 diff_fvi4 diff_fvi5 diff_fvi6 diff_fvi7, xline(0) horizontal ylabel(,angle(0)) name(sensi_vio, replace)
graph export "Sensi_violin.pdf", as(pdf) replace


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
