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
use"panel_v4", clear

/*
- Equivalence scale
- Poverty line
*/


*** Equivalence scale square root following Joliffe
gen dailyincome_pc2=(annualincome_HH2/365)/squareroot_HHsize
gen dailyusdincome_pc2=dailyincome_pc2/65.10
gen rrgpl2=((dailyusdincome_pc2-2.15)/2.15)*(-1)
replace rrgpl2=1 if rrgpl2>1
replace rrgpl2=0 if rrgpl2<0
gen fvi2=(2*tdr+2*isr+rrgpl2)/5


*** Previous PL
*gen dailyincome_pc2=(annualincome_HH2/365)/squareroot_HHsize
*gen dailyusdincome_pc2=dailyincome_pc2/65.10
gen rrgpl3=((dailyusdincome_pc-1.90)/1.90)*(-1)
replace rrgpl3=1 if rrgpl3>1
replace rrgpl3=0 if rrgpl3<0
gen fvi3=(2*tdr+2*isr+rrgpl3)/5


*** Change weight
gen fvi4=(1.5*tdr+1.5*isr+rrgpl)/4


********** Distrib
*** Pos
sort fvi
gen pos_fvi=(_n/1529)*100

forvalues i=2/4 {
sort fvi`i'
gen pos_fvi`i'=(_n/1529)*100
}

*** Diff
forvalues i=2/4 {
gen diff_fvi`i'=pos_fvi`i'-pos_fvi
}


*** Abs diff
forvalues i=2/4 {
gen absdiff_fvi`i'=abs(diff_fvi`i')
ta absdiff_fvi`i'
}


save"panel_v5", replace
****************************************
* END
















****************************************
* Graph 2
****************************************
use"panel_v5", clear

graph drop _all



forvalues i=2/4 {
set graph off
twoway ///
(scatter pos_fvi`i' pos_fvi, ms(oh) mc(black%30)) ///
(function y=x, range(0 100)) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("% of the distribution" "of FVI") ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("% of the distribution" "of FVI-`i'") ///
legend(order(2 "First bisector") pos(6) col(1)) name(posf`i', replace)
set graph on
}


set graph off
grc1leg posf2 posf3 posf4, col(2) name(possensi_scatter, replace)
graph export "graph/Sensi_posscatter.pdf", as(pdf) replace
set graph on

****************************************
* END
















****************************************
* Graph 3
****************************************
use"panel_v5", clear

keep HHID_panel year diff_fvi2 diff_fvi3 diff_fvi4
reshape long diff_fvi, i(HHID_panel year) j(n)

label define diff_fvi 2"FVI-2" 3"FVI-3" 4"FVI-4"
label values diff_fvi diff_fvi

set graph off
stripplot diff_fvi, over(n) ///
stack width(1) jitter(1) refline(lp(shortdash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh) msize(small) mc(black%30) ///
xla(-50(10)50, ang(h)) yla(, noticks) ///
legend(order(1 "± 5% tolerance threshold" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
ylabel(2 "FVI-2" 3 "FVI-3" 4 "FVI-4") ///
xline(-5 5) ///
xtitle("% in the distribution of FVI-n minus" "the % in the distribution of FVI") ytitle("FVI-n") name(diff_fvi_horiz, replace)
graph export "graph/Sensi_stripplot_vert.pdf", as(pdf) replace
set graph on

****************************************
* END









****************************************
* Try to combine
****************************************
use"panel_v5", clear


set graph off
graph combine possensi_scatter diff_fvi_horiz, col(2) name(sensi_poscomb, replace)
graph export "graph/Sensi_poscomb.pdf", as(pdf) replace
set graph on 

****************************************
* END

