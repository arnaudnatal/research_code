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
* Sensitivity tests
****************************************
use"panel_v5", clear

/*
- Poverty line
- Equivalence scale
*/



*** Poverty line at US$2.2
*gen dailyincome_pc=(annualincome_HH/365)/squareroot_HHsize
*gen dailyusdincome_pc=dailyincome_pc/45.73
gen rrgpl2=((dailyusdincome_pc-2.15)/2.15)*(-1)*100
replace rrgpl2=100 if rrgpl2>100
replace rrgpl2=0 if rrgpl2<0
gen fvi2=(tar+isr+rrgpl2)/3



*** Equivalence scale
* None
gen dailyincome_pc3=(annualincome_HH/365)/HHsize
gen dailyusdincome_pc3=dailyincome_pc3/45.73
gen rrgpl3=((dailyusdincome_pc3-1.9)/1.9)*(-1)*100
replace rrgpl3=100 if rrgpl3>100
replace rrgpl3=0 if rrgpl3<0
gen fvi3=(tar+isr+rrgpl3)/3

* OECD
gen dailyincome_pc4=(annualincome_HH/365)/equiscale_HHsize
gen dailyusdincome_pc4=dailyincome_pc4/45.73
gen rrgpl4=((dailyusdincome_pc4-1.9)/1.9)*(-1)*100
replace rrgpl4=100 if rrgpl4>100
replace rrgpl4=0 if rrgpl4<0
gen fvi4=(tar+isr+rrgpl4)/3

* Modified OECD
gen dailyincome_pc5=(annualincome_HH/365)/equimodiscale_HHsize
gen dailyusdincome_pc5=dailyincome_pc5/45.73
gen rrgpl5=((dailyusdincome_pc5-1.9)/1.9)*(-1)*100
replace rrgpl5=100 if rrgpl5>100
replace rrgpl5=0 if rrgpl5<0
gen fvi5=(tar+isr+rrgpl5)/3



********** Distrib
*** Pos
sort fvi
gen pos_fvi=(_n/1529)*100

forvalues i=2/5 {
sort fvi`i'
gen pos_fvi`i'=(_n/1529)*100
}

*** Diff
forvalues i=2/5 {
gen diff_fvi`i'=pos_fvi`i'-pos_fvi
}


*** Abs diff
forvalues i=2/5 {
gen absdiff_fvi`i'=abs(diff_fvi`i')
ta absdiff_fvi`i'
}


save"panel_v6", replace
****************************************
* END












****************************************
* Graph 1
****************************************
use"panel_v6", clear


*** Change threshold
forvalues i=2/5 {
forvalues j=0(1)100 {
gen fvi`i'_thre`j'=0
}
}

forvalues i=2/5 {
forvalues j=0(1)100 {
replace fvi`i'_thre`j'=1 if absdiff_fvi`i'>`j'
}
}


keep fvi2_thre* fvi3_thre* fvi4_thre* fvi5_thre* 

collapse (mean) fvi2_thre0 fvi2_thre1 fvi2_thre2 fvi2_thre3 fvi2_thre4 fvi2_thre5 fvi2_thre6 fvi2_thre7 fvi2_thre8 fvi2_thre9 fvi2_thre10 fvi2_thre11 fvi2_thre12 fvi2_thre13 fvi2_thre14 fvi2_thre15 fvi2_thre16 fvi2_thre17 fvi2_thre18 fvi2_thre19 fvi2_thre20 fvi2_thre21 fvi2_thre22 fvi2_thre23 fvi2_thre24 fvi2_thre25 fvi2_thre26 fvi2_thre27 fvi2_thre28 fvi2_thre29 fvi2_thre30 fvi2_thre31 fvi2_thre32 fvi2_thre33 fvi2_thre34 fvi2_thre35 fvi2_thre36 fvi2_thre37 fvi2_thre38 fvi2_thre39 fvi2_thre40 fvi2_thre41 fvi2_thre42 fvi2_thre43 fvi2_thre44 fvi2_thre45 fvi2_thre46 fvi2_thre47 fvi2_thre48 fvi2_thre49 fvi2_thre50 fvi2_thre51 fvi2_thre52 fvi2_thre53 fvi2_thre54 fvi2_thre55 fvi2_thre56 fvi2_thre57 fvi2_thre58 fvi2_thre59 fvi2_thre60 fvi2_thre61 fvi2_thre62 fvi2_thre63 fvi2_thre64 fvi2_thre65 fvi2_thre66 fvi2_thre67 fvi2_thre68 fvi2_thre69 fvi2_thre70 fvi2_thre71 fvi2_thre72 fvi2_thre73 fvi2_thre74 fvi2_thre75 fvi2_thre76 fvi2_thre77 fvi2_thre78 fvi2_thre79 fvi2_thre80 fvi2_thre81 fvi2_thre82 fvi2_thre83 fvi2_thre84 fvi2_thre85 fvi2_thre86 fvi2_thre87 fvi2_thre88 fvi2_thre89 fvi2_thre90 fvi2_thre91 fvi2_thre92 fvi2_thre93 fvi2_thre94 fvi2_thre95 fvi2_thre96 fvi2_thre97 fvi2_thre98 fvi2_thre99 fvi2_thre100 fvi3_thre0 fvi3_thre1 fvi3_thre2 fvi3_thre3 fvi3_thre4 fvi3_thre5 fvi3_thre6 fvi3_thre7 fvi3_thre8 fvi3_thre9 fvi3_thre10 fvi3_thre11 fvi3_thre12 fvi3_thre13 fvi3_thre14 fvi3_thre15 fvi3_thre16 fvi3_thre17 fvi3_thre18 fvi3_thre19 fvi3_thre20 fvi3_thre21 fvi3_thre22 fvi3_thre23 fvi3_thre24 fvi3_thre25 fvi3_thre26 fvi3_thre27 fvi3_thre28 fvi3_thre29 fvi3_thre30 fvi3_thre31 fvi3_thre32 fvi3_thre33 fvi3_thre34 fvi3_thre35 fvi3_thre36 fvi3_thre37 fvi3_thre38 fvi3_thre39 fvi3_thre40 fvi3_thre41 fvi3_thre42 fvi3_thre43 fvi3_thre44 fvi3_thre45 fvi3_thre46 fvi3_thre47 fvi3_thre48 fvi3_thre49 fvi3_thre50 fvi3_thre51 fvi3_thre52 fvi3_thre53 fvi3_thre54 fvi3_thre55 fvi3_thre56 fvi3_thre57 fvi3_thre58 fvi3_thre59 fvi3_thre60 fvi3_thre61 fvi3_thre62 fvi3_thre63 fvi3_thre64 fvi3_thre65 fvi3_thre66 fvi3_thre67 fvi3_thre68 fvi3_thre69 fvi3_thre70 fvi3_thre71 fvi3_thre72 fvi3_thre73 fvi3_thre74 fvi3_thre75 fvi3_thre76 fvi3_thre77 fvi3_thre78 fvi3_thre79 fvi3_thre80 fvi3_thre81 fvi3_thre82 fvi3_thre83 fvi3_thre84 fvi3_thre85 fvi3_thre86 fvi3_thre87 fvi3_thre88 fvi3_thre89 fvi3_thre90 fvi3_thre91 fvi3_thre92 fvi3_thre93 fvi3_thre94 fvi3_thre95 fvi3_thre96 fvi3_thre97 fvi3_thre98 fvi3_thre99 fvi3_thre100 fvi4_thre0 fvi4_thre1 fvi4_thre2 fvi4_thre3 fvi4_thre4 fvi4_thre5 fvi4_thre6 fvi4_thre7 fvi4_thre8 fvi4_thre9 fvi4_thre10 fvi4_thre11 fvi4_thre12 fvi4_thre13 fvi4_thre14 fvi4_thre15 fvi4_thre16 fvi4_thre17 fvi4_thre18 fvi4_thre19 fvi4_thre20 fvi4_thre21 fvi4_thre22 fvi4_thre23 fvi4_thre24 fvi4_thre25 fvi4_thre26 fvi4_thre27 fvi4_thre28 fvi4_thre29 fvi4_thre30 fvi4_thre31 fvi4_thre32 fvi4_thre33 fvi4_thre34 fvi4_thre35 fvi4_thre36 fvi4_thre37 fvi4_thre38 fvi4_thre39 fvi4_thre40 fvi4_thre41 fvi4_thre42 fvi4_thre43 fvi4_thre44 fvi4_thre45 fvi4_thre46 fvi4_thre47 fvi4_thre48 fvi4_thre49 fvi4_thre50 fvi4_thre51 fvi4_thre52 fvi4_thre53 fvi4_thre54 fvi4_thre55 fvi4_thre56 fvi4_thre57 fvi4_thre58 fvi4_thre59 fvi4_thre60 fvi4_thre61 fvi4_thre62 fvi4_thre63 fvi4_thre64 fvi4_thre65 fvi4_thre66 fvi4_thre67 fvi4_thre68 fvi4_thre69 fvi4_thre70 fvi4_thre71 fvi4_thre72 fvi4_thre73 fvi4_thre74 fvi4_thre75 fvi4_thre76 fvi4_thre77 fvi4_thre78 fvi4_thre79 fvi4_thre80 fvi4_thre81 fvi4_thre82 fvi4_thre83 fvi4_thre84 fvi4_thre85 fvi4_thre86 fvi4_thre87 fvi4_thre88 fvi4_thre89 fvi4_thre90 fvi4_thre91 fvi4_thre92 fvi4_thre93 fvi4_thre94 fvi4_thre95 fvi4_thre96 fvi4_thre97 fvi4_thre98 fvi4_thre99 fvi4_thre100 fvi5_thre0 fvi5_thre1 fvi5_thre2 fvi5_thre3 fvi5_thre4 fvi5_thre5 fvi5_thre6 fvi5_thre7 fvi5_thre8 fvi5_thre9 fvi5_thre10 fvi5_thre11 fvi5_thre12 fvi5_thre13 fvi5_thre14 fvi5_thre15 fvi5_thre16 fvi5_thre17 fvi5_thre18 fvi5_thre19 fvi5_thre20 fvi5_thre21 fvi5_thre22 fvi5_thre23 fvi5_thre24 fvi5_thre25 fvi5_thre26 fvi5_thre27 fvi5_thre28 fvi5_thre29 fvi5_thre30 fvi5_thre31 fvi5_thre32 fvi5_thre33 fvi5_thre34 fvi5_thre35 fvi5_thre36 fvi5_thre37 fvi5_thre38 fvi5_thre39 fvi5_thre40 fvi5_thre41 fvi5_thre42 fvi5_thre43 fvi5_thre44 fvi5_thre45 fvi5_thre46 fvi5_thre47 fvi5_thre48 fvi5_thre49 fvi5_thre50 fvi5_thre51 fvi5_thre52 fvi5_thre53 fvi5_thre54 fvi5_thre55 fvi5_thre56 fvi5_thre57 fvi5_thre58 fvi5_thre59 fvi5_thre60 fvi5_thre61 fvi5_thre62 fvi5_thre63 fvi5_thre64 fvi5_thre65 fvi5_thre66 fvi5_thre67 fvi5_thre68 fvi5_thre69 fvi5_thre70 fvi5_thre71 fvi5_thre72 fvi5_thre73 fvi5_thre74 fvi5_thre75 fvi5_thre76 fvi5_thre77 fvi5_thre78 fvi5_thre79 fvi5_thre80 fvi5_thre81 fvi5_thre82 fvi5_thre83 fvi5_thre84 fvi5_thre85 fvi5_thre86 fvi5_thre87 fvi5_thre88 fvi5_thre89 fvi5_thre90 fvi5_thre91 fvi5_thre92 fvi5_thre93 fvi5_thre94 fvi5_thre95 fvi5_thre96 fvi5_thre97 fvi5_thre98 fvi5_thre99 fvi5_thre100 

gen n=_n
reshape long fvi2_thre fvi3_thre fvi4_thre fvi5_thre, j(pos) i(n)
drop n

forvalues i=2/5 {
replace fvi`i'_thre=fvi`i'_thre*100
}

*** Graph
forvalues i=2/5 {
set graph off
twoway ///
(line fvi`i'_thre pos if pos<40, xline(5 10 20)) ///
, ///
xtitle("Tolerance threshold (in pp)") xlabel(0(5)40) ///
ytitle("% of HH with FVI-`i' ≠ FVI")  ylabel(0(10)100) ymtick(0(5)100) ///
aspectratio(0.5) name(thr_fvi`i', replace)
set graph on
}

graph combine thr_fvi2 thr_fvi3 thr_fvi4 thr_fvi5, col(2) name(thr_comb, replace)
graph export "graph/Sensi_threshold.pdf", as(pdf) replace


****************************************
* END










****************************************
* Graph 2
****************************************
use"panel_v6", clear

graph drop _all

forvalues i=2/5 {
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

graph dir

grc1leg f2 f3 f4 f5, col(2) name(sensi_scatter, replace)
graph export "graph/Sensi_scatter.pdf", as(pdf) replace

****************************************
* END












****************************************
* Graph 3
****************************************
use"panel_v6", clear


tabstat fvi fvi2 fvi3 fvi4 fvi5, stat(mean cv q)

label var diff_fvi2 "FVI-2"
label var diff_fvi3 "FVI-3"
label var diff_fvi4 "FVI-4"
label var diff_fvi5 "FVI-5"

* Horizontal
vioplot diff_fvi2 diff_fvi3 diff_fvi4 diff_fvi5, horizontal xline(-5 0 5) ///
xlabel(-50(10)50) xmtick(-50(5)50) xtitle("(FVI-n - FVI)") ///
ylabel(,angle(0)) ytitle("FVI-n") ///
name(sensi_vio_ho, replace)
graph export "graph/Sensi_violin_horiz.pdf", as(pdf) replace


* Vertical
vioplot diff_fvi2 diff_fvi3 diff_fvi4 diff_fvi5, yline(-5 0 5) ///
ylabel(-50(10)50) ymtick(-50(5)50) ytitle("(FVI-n - FVI)") ///
xlabel(,angle(0))  xtitle("FVI-n") ///
name(sensi_vio, replace)
graph export "graph/Sensi_violin_vert.pdf", as(pdf) replace

****************************************
* END









****************************************
* Graph 4
****************************************
use"panel_v6", clear

keep HHID_panel year diff_fvi2 diff_fvi3 diff_fvi4 diff_fvi5
reshape long diff_fvi, i(HHID_panel year) j(n)

label define diff_fvi 2"FVI-2" 3"FVI-3" 4"FVI-4" 5"FVI-5" 
label values diff_fvi diff_fvi

stripplot diff_fvi, over(n) ///
stack width(1) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh) msize(small) mc(black%30) ///
xla(-50(10)50, ang(h)) yla(, noticks) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
ylabel(2 "FVI-2" 3 "FVI-3" 4 "FVI-4" 5 "FVI-5") ///
xline(-5 0 5) ///
xtitle("(FVI-n - FVI)") ytitle("FVI-n") name(diff_fvi_horiz, replace)
graph export "graph/Sensi_stripplot_vert.pdf", as(pdf) replace

****************************************
* END
