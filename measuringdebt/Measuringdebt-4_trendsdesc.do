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
* Corr between measures
****************************************
use"panel_v5", clear

* Spec 1
pwcorr tdr isr rrgpl, star(.05)

* Spec 2
pwcorr tar isr rrgpl, star(.05)

****************************************
* END












****************************************
* Evo time
****************************************
use"panel_v5", clear

tabstat fvi fvib, stat(n mean cv q) by(time)
tabstat fvi fvib, stat(n mean cv q) by(caste)

*twoway (kdensity fvi) (kdensity fvib)


****************************************
* END













****************************************
* Clean name and overlap
****************************************
use"panel_v5", clear


********** Overlap
set graph off

*** DSR
gen dsr2=dsr
replace dsr2=500 if dsr2>500
/*
twoway ///
(scatter fvi dsr2, mcolor(black%30)) ///
(lfit fvi dsr2) ///
, ///
ytitle("FVI") xtitle("DSR") ///
aspectratio(1) ///
leg(off) name(dsr, replace)
*/


*** DIR
gen dir2=dir
replace dir2=2000 if dir2>2000
/*
twoway ///
(scatter fvi dir2, mcolor(black%30)) ///
(lfit fvi dir2) ///
, ///
ytitle("FVI") xtitle("DIR") ///
aspectratio(1) ///
leg(off) name(dir, replace)
*/


*** DAR
gen dar2=dar
replace dar2=500 if dar2>500
/*
twoway ///
(scatter fvi dar2, mcolor(black%30)) ///
(lfit fvi dar2) ///
, ///
ytitle("FVI") xtitle("DAR") ///
aspectratio(1) ///
leg(off) name(dar, replace)
*/


*** Abs FM
gen afm2=afm
replace afm2=-140000 if afm2<-140000
replace afm2=550000 if afm2>550000
/*
twoway ///
(scatter fvi afm2, mcolor(black%30)) ///
(lfit fvi afm2) ///
, ///
ytitle("FVI") xtitle("Absolut FM") ///
aspectratio(1) ///
leg(off) name(afm, replace)
*/


*** Rel FM
gen rfm2=rfm
replace rfm2=-1000 if rfm2<-1000
replace rfm2=650 if rfm2>650
/*
twoway ///
(scatter fvi rfm2, mcolor(black%30)) ///
(lfit fvi rfm2) ///
, ///
ytitle("FVI") xtitle("Relative FM") ///
aspectratio(1) ///
leg(off) name(rfm, replace)
*/


*** DCR
gen dcr=(loanamount_HH/expenses_total)*100
gen dcr2=dcr
replace dcr2=800 if dcr2>800
/*
twoway ///
(scatter fvi dcr2, mcolor(black%30)) ///
(lfit fvi dcr2) ///
, ///
ytitle("FVI") xtitle("DCR") ///
aspectratio(1) ///
leg(off) name(dcr, replace)
*/


set graph on

*** Combine
*graph combine dsr dir dar afm rfm dcr, col(3) name(comb, replace)


*save"panel_v5", replace
****************************************
* END












****************************************
* FVI
****************************************
use"panel_v5", clear


*** Density
/*
twoway ///
(kdensity fvi) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("FVI") ///
ytitle("Density") ///
name(kd, replace)

twoway ///
(kdensity fvi if year==2010) ///
(kdensity fvi if year==2016) ///
(kdensity fvi if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("FVI") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_fvi, replace)
*/


*** Stripplot
/*
stripplot fvi, over(time) vert ///
stack width(0.5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh oh oh) msize(small) mc(black%30) ///
yla(0(10)100, ang(h)) xla(, noticks) ///
ytitle("FVI") xtitle("") name(sp_fvi, replace)


stripplot ampi, over(time) vert ///
stack width(0.5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh oh oh) msize(small) mc(black%30) ///
yla(70(10)130, ang(h)) xla(, noticks) ///
ytitle("A-MPI") xtitle("") name(sp_ampi, replace)
*/



*** ISR
/*
twoway ///
(kdensity isr if year==2010) ///
(kdensity isr if year==2016) ///
(kdensity isr if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("ISR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_isr, replace)
*/



*** TDR
/*
twoway ///
(kdensity tdr if year==2010) ///
(kdensity tdr if year==2016) ///
(kdensity tdr if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("TDR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_tdr, replace)
*/



*** RRGPL
/*
twoway ///
(kdensity rrgpl if year==2010) ///
(kdensity rrgpl if year==2016) ///
(kdensity rrgpl if year==2020) ///
, ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("RRGPL") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_rrgpl, replace)
*/



****************************************
* END













****************************************
* Others measures
****************************************
use"panel_v5", clear

*** DSR
/*
twoway ///
(kdensity dsr2 if year==2010) ///
(kdensity dsr2 if year==2016) ///
(kdensity dsr2 if year==2020) ///
, ///
xtitle("DSR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_dsr, replace)
*/


*** DIR
/*
twoway ///
(kdensity dir2 if year==2010) ///
(kdensity dir2 if year==2016) ///
(kdensity dir2 if year==2020) ///
, ///
xtitle("DIR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_dir, replace)
*/


*** DAR
/*
twoway ///
(kdensity dar2 if year==2010) ///
(kdensity dar2 if year==2016) ///
(kdensity dar2 if year==2020) ///
, ///
xtitle("DAR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_dar, replace)
*/


*** DCR
/*
twoway ///
(kdensity dcr2 if year==2010) ///
(kdensity dcr2 if year==2016) ///
(kdensity dcr2 if year==2020) ///
, ///
xtitle("DCR") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_dcr, replace)
*/


*** Absolut FM
/*
twoway ///
(kdensity afm2 if year==2010) ///
(kdensity afm2 if year==2016) ///
(kdensity afm2 if year==2020) ///
, ///
xtitle("Absolut FM") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_afm, replace)
*/


*** Relative FM
/*
twoway ///
(kdensity rfm2 if year==2010) ///
(kdensity rfm2 if year==2016) ///
(kdensity rfm2 if year==2020) ///
, ///
xtitle("Relative FM") ///
ytitle("Density") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) name(kd_rfm, replace)
*/


****************************************
* END












****************************************
* Trends
****************************************
use"panel_v5", clear


********** Trends
preserve
rename fvi index
tabstat index, stat(min max range)
keep if dummypanel==1
keep HHID_panel year index

reshape wide index, i(HHID_panel) j(year)
corr index2010 index2016 index2020
export delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\debtnew.csv", replace
restore



********** Import
import delimited "C:\Users\Arnaud\Documents\GitHub\research_code\measuringdebt\indextrend.csv", clear

* Clean
drop v1
rename hhid_panel HHID_panel
rename cluster1 cl1
rename cluster2 cl2
rename cluster3 cl3
rename cluster4 cl4

* Reshape
reshape long index, i(HHID_panel) j(year)

save"indextrend.dta", replace



********** Merge
use"panel_v5", clear

merge 1:1 HHID_panel year using "indextrend"
drop _merge


*** Clean
drop index

save"panel_v6", replace
****************************************
* END





/*





****************************************
* Characteristics
****************************************
use"panel_v5", clear

xtset panelvar year


*** Graph line
forvalues i=1/4 {
forvalues j=1/4 {
set graph off
sort HHID_panel year
twoway (line index year if cl`i'==`j', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("FVI") ///
title("Cluster `j'") ///
name(cl`i'_`j', replace)
set graph on
}
}

* Combine
forvalues i=1/4 {
set graph off
graph combine cl`i'_1 cl`i'_2 cl`i'_3 cl`i'_4, col(2) name(cl`i'_gph, replace)
set graph on
}

* Display
/*
graph display cl1_gph
graph display cl2_gph
graph display cl3_gph
graph display cl4_gph
*/

* Label 
label define cl1 ///
1"Transitory non-vulnerable" ///
2"Non-vulnerable" ///
3"Vulnerable" ///
4"Transitory vulnerable"

label define cl2 ///
1"Vulnerable" ///
2"Transitory non-vulnerable" ///
3"Decreasing vulnerability" ///
4"Non-vulnerable"

label define cl3 ///
1"Vulnerable" ///
2"Transitory vulnerable" ///
3"Decreasing vulnerability" ///
4"Non-vulnerable"

label define cl4 ///
1"Transitory vulnerable" ///
2"Vulnerable dynamics" ///
3"V+ Vulnerable dynamics" ///
4"Non-vulnerable"

label values cl1 cl1
label values cl2 cl2
label values cl3 cl3
label values cl4 cl4


********** Which one to retain?
/*
Choose between 2 and 3
Keep the number 3
*/

*graph display cl1_gph
*graph display cl2_gph
graph display cl3_gph
*graph display cl4_gph
drop cl1 cl2 cl4


********* Desc
ta cl3
ta cl3 caste, exp cchi2 chi2
ta cl3 caste, col nofreq





****************************************
* END
