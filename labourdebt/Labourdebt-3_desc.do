*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------







****************************************
* Stat desc: Y ind
****************************************
cls
use"panel_v3", clear


********** Macro
global yvar ind_total ind_female ind_male ind_agri ind_nona

********** Orga
keep year $yvar

foreach y in $yvar {
ta `y', gen(`y'_)
}

drop $yvar
collapse (mean) ind_total_1 ind_total_2 ind_total_3 ind_total_4 ind_total_5 ind_total_6 ind_total_7 ind_total_8 ind_total_9 ind_female_1 ind_female_2 ind_female_3 ind_female_4 ind_female_5 ind_male_1 ind_male_2 ind_male_3 ind_male_4 ind_male_5 ind_agri_1 ind_agri_2 ind_agri_3 ind_agri_4 ind_agri_5 ind_agri_6 ind_nona_1 ind_nona_2 ind_nona_3 ind_nona_4 ind_nona_5 ind_nona_6 ind_nona_7 ind_nona_8 ind_nona_9, by(year)


reshape long ind_total_ ind_female_ ind_male_ ind_agri_ ind_nona_, i(year) j(n)

foreach y in $yvar {
rename `y'_ `y'
replace `y'=`y'*100
}


********** Individuals
set graph off

*** Total
twoway /// 
(connected ind_total n if year==2010, lp(solid) lc(gs3)) ///
(connected ind_total n if year==2016, lp(dash) lc(gs8)) ///
(connected ind_total n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)8) title("Total") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(ind_total, replace) graphregion(margin(zero))

*** Male
twoway /// 
(connected ind_male n if year==2010, lp(solid) lc(gs3)) ///
(connected ind_male n if year==2016, lp(dash) lc(gs8)) ///
(connected ind_male n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)8) title("Male") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(ind_male, replace) graphregion(margin(zero))


*** Female
twoway /// 
(connected ind_female n if year==2010, lp(solid) lc(gs3)) ///
(connected ind_female n if year==2016, lp(dash) lc(gs8)) ///
(connected ind_female n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)8) title("Female") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(ind_female, replace) graphregion(margin(zero))


*** Agri
twoway /// 
(connected ind_agri n if year==2010, lp(solid) lc(gs3)) ///
(connected ind_agri n if year==2016, lp(dash) lc(gs8)) ///
(connected ind_agri n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)8) title("Agri") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(ind_agri, replace) graphregion(margin(zero))


*** Non-agri
twoway /// 
(connected ind_nona n if year==2010, lp(solid) lc(gs3)) ///
(connected ind_nona n if year==2016, lp(dash) lc(gs8)) ///
(connected ind_nona n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of workers") ytitle("Percent") ///
xlab(1(1)8) title("Non-agri") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(ind_nona, replace) graphregion(margin(zero))


*** Combine
grc1leg ind_male ind_female ind_agri ind_nona, col(2) name(comb_ind_sub, replace) graphregion(margin(zero))

set graph on
grc1leg ind_total comb_ind_sub, col(2) graphregion(margin(zero)) name(ind_comb, replace)
graph export "graph/yvar_ind.pdf", as(pdf) replace

****************************************
* END













****************************************
* Stat desc: Y occ
****************************************
cls
use"panel_v3", clear


********** Macro
global yvar occ_total occ_female occ_male occ_agri occ_nona


********** Orga
keep year $yvar

foreach y in $yvar {
ta `y', gen(`y'_)
}

drop $yvar
collapse (mean) occ_total_1 occ_total_2 occ_total_3 occ_total_4 occ_total_5 occ_total_6 occ_total_7 occ_total_8 occ_total_9 occ_total_10 occ_total_11 occ_total_12 occ_total_13 occ_total_14 occ_female_1 occ_female_2 occ_female_3 occ_female_4 occ_female_5 occ_female_6 occ_female_7 occ_female_8 occ_female_9 occ_male_1 occ_male_2 occ_male_3 occ_male_4 occ_male_5 occ_male_6 occ_male_7 occ_male_8 occ_agri_1 occ_agri_2 occ_agri_3 occ_agri_4 occ_agri_5 occ_agri_6 occ_agri_7 occ_agri_8 occ_agri_9 occ_agri_10 occ_nona_1 occ_nona_2 occ_nona_3 occ_nona_4 occ_nona_5 occ_nona_6 occ_nona_7 occ_nona_8 occ_nona_9 occ_nona_10, by(year)


reshape long occ_total_ occ_female_ occ_male_ occ_agri_ occ_nona_, i(year) j(n)

foreach y in $yvar {
rename `y'_ `y'
replace `y'=`y'*100
}


********** Individuals
set graph off

*** Total
twoway /// 
(connected occ_total n if year==2010, lp(solid) lc(gs3)) ///
(connected occ_total n if year==2016, lp(dash) lc(gs8)) ///
(connected occ_total n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)13) title("Total") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(occ_total, replace)

*** Male
twoway /// 
(connected occ_male n if year==2010, lp(solid) lc(gs3)) ///
(connected occ_male n if year==2016, lp(dash) lc(gs8)) ///
(connected occ_male n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)13) title("Male") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(occ_male, replace)


*** Female
twoway /// 
(connected occ_female n if year==2010, lp(solid) lc(gs3)) ///
(connected occ_female n if year==2016, lp(dash) lc(gs8)) ///
(connected occ_female n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)13) title("Female") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(occ_female, replace)


*** Agri
twoway /// 
(connected occ_agri n if year==2010, lp(solid) lc(gs3)) ///
(connected occ_agri n if year==2016, lp(dash) lc(gs8)) ///
(connected occ_agri n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)13) title("Agri") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(occ_agri, replace)


*** Non-agri
twoway /// 
(connected occ_nona n if year==2010, lp(solid) lc(gs3)) ///
(connected occ_nona n if year==2016, lp(dash) lc(gs8)) ///
(connected occ_nona n if year==2020, lp(shortdash) lc(gs12)) ///
, ///
xtitle("Number of occupations") ytitle("Percent") ///
xlab(1(1)13) title("Non-agri") ///
ylab(0(20)100) ymtick(0(10)100) ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3) off) ///
name(occ_nona, replace)



*** Combine
grc1leg occ_male occ_female occ_agri occ_nona, col(2) name(comb_occ_sub, replace) graphregion(margin(zero))

set graph on
grc1leg occ_total comb_occ_sub, col(2) graphregion(margin(zero)) name(occ_comb, replace)
graph export "graph/yvar_occ.pdf", as(pdf) replace

****************************************
* END

















****************************************
* Stat desc: X
****************************************
cls
use"panel_v3", clear


********** FVI
stripplot fvi, over(time) ///
stack width(0.5) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(10)100, ang(h)) yla(, noticks) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("FVI") ytitle("") name(sp_fvi_horiz, replace)
graph export "graph/Distri_fvi.pdf", as(pdf) replace



********** Other X

*** Economics
tabstat remittnet_HH assets_total annualincome_HH shareform, stat(n mean cv p50) by(year)


*** Head
ta head_female 
tabstat head_age, stat(n mean cv p50)
ta head_educ


*** Family
* Compo no. 1
tabstat dalits caste_1 caste_2 caste_3 stem log_HHsize share_female share_children share_young share_old share_stock, stat(n mean cv p50) by(time)


* Compo no. 2
tabstat dalits caste_1 caste_2 caste_3 stem HHsize HH_count_child sexratio dependencyratio share_stock, stat(n mean cv p50) by(time)

****************************************
* END

























/*
****************************************
* Stat desc: Y
****************************************
cls
use"panel_v3", clear


********** Panel declaration
xtset panelvar time
set matsize 10000, perm


********** Variables
global yvar ind_total ind_female ind_male ind_agri ind_nona occ_total occ_female occ_male occ_agri occ_nona



********** Histogram Indiv
set graph off
*** Total
twoway (histogram ind_total if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_total_2010, replace)  graphregion(margin(zero))

twoway (histogram ind_total if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_total_2016, replace)  graphregion(margin(zero))

twoway (histogram ind_total if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_total_2020, replace)  graphregion(margin(zero))



*** Male
twoway (histogram ind_male if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_male_2010, replace)  graphregion(margin(zero))

twoway (histogram ind_male if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_male_2016, replace)  graphregion(margin(zero))

twoway (histogram ind_male if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_male_2020, replace)  graphregion(margin(zero))



*** Female
twoway (histogram ind_female if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_female_2010, replace)  graphregion(margin(zero))

twoway (histogram ind_female if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_female_2016, replace)  graphregion(margin(zero))

twoway (histogram ind_female if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_female_2020, replace)  graphregion(margin(zero))

*** Agri
twoway (histogram ind_agri if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_agri_2010, replace)  graphregion(margin(zero))

twoway (histogram ind_agri if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_agri_2016, replace)  graphregion(margin(zero))

twoway (histogram ind_agri if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_agri_2020, replace)  graphregion(margin(zero))

*** Non-agri
twoway (histogram ind_nona if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_nona_2010, replace)  graphregion(margin(zero))

twoway (histogram ind_nona if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_nona_2016, replace)  graphregion(margin(zero))

twoway (histogram ind_nona if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_nona_2020, replace) graphregion(margin(zero))


*** Text
* Blank
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
name(gbl, replace) graphregion(margin(zero))


* 2010
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "2010", place(c) size(vlarge)) ///
name(g2010, replace) graphregion(margin(zero))

* 2016-17
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "2016-17", place(c) size(vlarge)) ///
name(g2016, replace) graphregion(margin(zero))

* 2020-21
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "2020-21", place(c) size(vlarge)) ///
name(g2020, replace) graphregion(margin(zero))

* Total
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "Total", place(c) size(vlarge)) ///
name(gtotal, replace) graphregion(margin(zero))

* Male
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "Male", place(c) size(vlarge)) ///
name(gmale, replace) graphregion(margin(zero))

* Female
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "Female", place(c) size(vlarge)) ///
name(gfemale, replace) graphregion(margin(zero))

* Agri
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "Agri", place(c) size(vlarge)) ///
name(gagri, replace) graphregion(margin(zero))

* Non-agri
twoway (function y=x, range(0 1) lc(white)) ///
, ///
plotregion(style(none))  ///
xtitle("") ytitle("") ///
xlab("") ylab("") ///
text(.5 .5 "Non-agri", place(c) size(vlarge)) ///
name(gnona, replace) graphregion(margin(zero))



*** Combine
set graph on
graph combine ///
gbl g2010 g2016 g2020 ///
gtotal ind_total_2010 ind_total_2016 ind_total_2020 ///
gmale ind_male_2010 ind_male_2016 ind_male_2020 ///
gfemale ind_female_2010 ind_female_2016 ind_female_2020 ///
gagri ind_agri_2010 ind_agri_2016 ind_agri_2020 ///
gnona ind_nona_2010 ind_nona_2016 ind_nona_2020, col(4) name(ind, replace)



****************************************
* END
*/

