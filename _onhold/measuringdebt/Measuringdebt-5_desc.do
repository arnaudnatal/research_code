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
* Redundancy between variables
****************************************
cls
use"panel_v5", clear


*** Corr
corr tdr isr rrgpl
label var tdr "DTR"

*** Graph
set graph off
graph matrix tdr isr rrgpl, half ///
ms(oh) mc(black%30) ///
note("Correlation:" "DTR-ISR: 0.00; DTR-RRGPL: 0.00; ISR-RRGPL: 0.35", size(vsmall))
graph export "graph/matrix_corr.pdf", as(pdf) replace
set graph on


*** As for PCA
factortest tdr isr rrgpl


****************************************
* END












****************************************
* Correlation with classic ratios
****************************************
use"panel_v5", clear


********** Stat desc
tabstat dsr dir dar dcr afm rfm, stat(n mean cv min p1 p5 p10 q p90 p95 p99 max) by(time) long

tabstat dsr isr, stat(n mean cv q) by(time) long



********** Overlap
set graph off

*** DSR
gen dsr2=dsr
replace dsr2=5 if dsr2>5

twoway ///
(scatter fvi dsr2, mcolor(black%30)) ///
, ///
ytitle("FVI") xtitle("DSR") ///
ylabel(0(.2)1) ymtick(0(.1)1) ///
aspectratio(1) ///
leg(off) name(dsr, replace)



*** DIR
gen dir2=dir
replace dir2=20 if dir2>20

twoway ///
(scatter fvi dir2, mcolor(black%30)) ///
, ///
ylabel(0(.2)1) ymtick(0(.1)1) ///
ytitle("FVI") xtitle("DIR") ///
aspectratio(1) ///
leg(off) name(dir, replace)



*** DAR
gen dar2=dar
replace dar2=5 if dar2>5

twoway ///
(scatter fvi dar2, mcolor(black%30)) ///
, ///
ylabel(0(.2)1) ymtick(0(.1)1) ///
ytitle("FVI") xtitle("DAR") ///
aspectratio(1) ///
leg(off) name(dar, replace)



*** Abs FM
gen afm2=afm/1000
replace afm2=-140 if afm2<-140
replace afm2=550 if afm2>550

twoway ///
(scatter fvi afm2, mcolor(black%30)) ///
, ///
ylabel(0(.2)1) ymtick(0(.1)1) ///
ytitle("FVI") xtitle("Absolut FM (INR 1k)") ///
aspectratio(1) ///
leg(off) name(afm, replace)



*** Rel FM
gen rfm2=rfm
tabstat rfm2, stat(min p1 p5 p10 p90 p95 p99 max)
replace rfm2=-10 if rfm2<-10
replace rfm2=6.5 if rfm2>6.5

twoway ///
(scatter fvi rfm2, mcolor(black%30)) ///
, ///
ylabel(0(.2)1) ymtick(0(.1)1) ///
ytitle("FVI") xtitle("Relative FM") ///
aspectratio(1) ///
leg(off) name(rfm, replace)



*** DCR
gen dcr2=dcr
replace dcr2=8 if dcr2>8

twoway ///
(scatter fvi dcr2, mcolor(black%30)) ///
, ///
ylabel(0(.2)1) ymtick(0(.1)1) ///
ytitle("FVI") xtitle("DCR") ///
aspectratio(1) ///
leg(off) name(dcr, replace)

set graph on


*** Combine
set graph off
*graph combine dsr dir dar afm rfm dcr, col(3) name(comb, replace)
graph combine dsr dir dar afm, col(2) name(comb, replace)
graph export "graph/Corr_fvi_oth.pdf", as(pdf) replace
set graph on

***
graph display comb

****************************************
* END














****************************************
* FVI
****************************************
use"panel_v5", clear


********** Stat desc
tabstat isr tdr rrgpl fvi, stat(n mean cv min p1 p5 p10 q p90 p95 p99 max) by(time) long


********** Graph FVI
set graph off
stripplot fvi, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_fvi_horiz, replace)
graph export "graph/Distri_fvi.pdf", as(pdf) replace
set graph on

***
graph display sp_fvi_horiz

/*
*** Test addplot
stripplot fvi, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_fvi_horiz, replace) addplot(scatteri 3 0.5  2 0.25, mcolor(red))
*/



********** Graph components

set graph off
*** ISR
twoway ///
(kdensity isr if year==2010) ///
(kdensity isr if year==2016) ///
(kdensity isr if year==2020) ///
, ///
xlabel(0(.2)1) xmtick(0(.1)1) xtitle("ISR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
aspectratio(1) name(kd_isr, replace)

*** TDR
twoway ///
(kdensity tdr if year==2010) ///
(kdensity tdr if year==2016) ///
(kdensity tdr if year==2020) ///
, ///
xlabel(0(.2)1) xmtick(0(.1)1) xtitle("DTR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
aspectratio(1) name(kd_tdr, replace)


*** RRGPL
twoway ///
(kdensity rrgpl if year==2010) ///
(kdensity rrgpl if year==2016) ///
(kdensity rrgpl if year==2020) ///
, ///
xlabel(0(.2)1) xmtick(0(.1)1) xtitle("RRGPL") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
aspectratio(1) name(kd_rrgpl, replace)

set graph on

*** Combine
set graph off
grc1leg kd_isr kd_tdr kd_rrgpl, col(2) name(kd_compo, replace)
graph export "graph/FVI_compo.pdf", as(pdf) replace
set graph on


***
graph display kd_compo
****************************************
* END
