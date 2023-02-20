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
* Debt
****************************************
use"panel_loans", clear

*** Number of loans
ta loansettled year

*** Clean
drop if loansettled==1
ta year

*** Deflate and 1000
foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}

*** Amount
tabstat loanamount, stat(n mean cv q) by(year) long

*** Reason
ta loanreasongiven year, col nofreq
ta reason_cat year, col nofreq

*** Lender
ta loanlender year, col nofreq
ta lender4 year, col nofreq
ta lender_cat year, col nofreq

****************************************
* END




















****************************************
* Redundancy between variables
****************************************
use"panel_v6", clear


*** Stat
ta tar 
ta isr
ta rrgpl


*** Corr
pwcorr tar isr rrgpl, star(.05)


*** Graph
corr tar isr rrgpl
graph matrix tar isr rrgpl, half ///
ms(oh) mc(black%30) ///
note("Correlation:" "TAR-ISR: 0.0243; TAR-RRGPL: -0.0179; ISR-RRGPL: 0.4515", size(vsmall))
graph export "graph/matrix_corr.pdf", as(pdf) replace



*** Alpha
alpha tar isr rrgpl


*** As for PCA
factortest tar isr rrgpl


****************************************
* END












****************************************
* Correlation with classic ratios
****************************************
use"panel_v6", clear


********** Overlap
set graph off

*** DSR
gen dsr2=dsr
replace dsr2=500 if dsr2>500

twoway ///
(scatter fvi dsr2, mcolor(black%30)) ///
(lfit fvi dsr2) ///
, ///
ytitle("FVI") xtitle("DSR") ///
aspectratio(1) ///
leg(order(2 "Fitted values") pos(6) col(1)) name(dsr, replace)



*** DIR
gen dir2=dir
replace dir2=2000 if dir2>2000

twoway ///
(scatter fvi dir2, mcolor(black%30)) ///
(lfit fvi dir2) ///
, ///
ytitle("FVI") xtitle("DIR") ///
aspectratio(1) ///
leg(off) name(dir, replace)



*** DAR
gen dar2=dar
replace dar2=500 if dar2>500

twoway ///
(scatter fvi dar2, mcolor(black%30)) ///
(lfit fvi dar2) ///
, ///
ytitle("FVI") xtitle("DAR") ///
aspectratio(1) ///
leg(off) name(dar, replace)



*** Abs FM
gen afm2=afm
replace afm2=-140000 if afm2<-140000
replace afm2=550000 if afm2>550000

twoway ///
(scatter fvi afm2, mcolor(black%30)) ///
(lfit fvi afm2) ///
, ///
ytitle("FVI") xtitle("Absolut FM") ///
aspectratio(1) ///
leg(off) name(afm, replace)



*** Rel FM
gen rfm2=rfm
replace rfm2=-1000 if rfm2<-1000
replace rfm2=650 if rfm2>650

twoway ///
(scatter fvi rfm2, mcolor(black%30)) ///
(lfit fvi rfm2) ///
, ///
ytitle("FVI") xtitle("Relative FM") ///
aspectratio(1) ///
leg(off) name(rfm, replace)



*** DCR
gen dcr=(loanamount_HH/expenses_total)*100
gen dcr2=dcr
replace dcr2=800 if dcr2>800

twoway ///
(scatter fvi dcr2, mcolor(black%30)) ///
(lfit fvi dcr2) ///
, ///
ytitle("FVI") xtitle("DCR") ///
aspectratio(1) ///
leg(off) name(dcr, replace)



set graph on

*** Combine
grc1leg dsr dir dar afm rfm dcr, col(3) name(comb, replace)
graph export "graph/Corr_fvi_oth.pdf", as(pdf) replace

****************************************
* END














****************************************
* FVI
****************************************
use"panel_v6", clear




********** Stat desc
tabstat fvi isr tar rrgpl, stat(n mean cv p50) by(time) long

tabstat fvi isr tar rrgpl, stat(min p1 p5 p10 q p90 p95 p99 max) by(time) long




********** Graph FVI

*** Kernel density
/*
twoway ///
(kdensity fvi if year==2010) ///
(kdensity fvi if year==2016) ///
(kdensity fvi if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("FVI") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_fvi, replace)
*/


*** Stripplot vert
/*
stripplot fvi, over(time) vert ///
stack width(0.5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh oh oh) msize(small) mc(black%30) ///
yla(0(10)100, ang(h)) xla(, noticks) ///
ytitle("FVI") xtitle("") name(sp_fvi_vert, replace)
*/

*** Stripplot horiz
stripplot fvi, over(time) ///
stack width(0.5) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(10)100, ang(h)) yla(, noticks) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_fvi_horiz, replace)
graph export "graph/Distri_fvi.pdf", as(pdf) replace




********** Graph components

set graph off

*** ISR
twoway ///
(kdensity isr if year==2010) ///
(kdensity isr if year==2016) ///
(kdensity isr if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("ISR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
aspectratio(1) name(kd_isr, replace)


*** TAR
twoway ///
(kdensity tar if year==2010) ///
(kdensity tar if year==2016) ///
(kdensity tar if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("TAR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
aspectratio(1) name(kd_tar, replace)




*** RRGPL
twoway ///
(kdensity rrgpl if year==2010) ///
(kdensity rrgpl if year==2016) ///
(kdensity rrgpl if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("RRGPL") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
aspectratio(1) name(kd_rrgpl, replace)

set graph on

*** Combine
grc1leg kd_isr kd_tar kd_rrgpl, col(3) name(kd_compo, replace)
graph export "graph/FVI_compo.pdf", as(pdf) replace

****************************************
* END
