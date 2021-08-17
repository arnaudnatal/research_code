cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
August 17, 2021
-----
Stability over time of personality traits: analysis p2
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain, perm

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v17"
****************************************
* END







****************************************
* OMEGA
****************************************
preserve
import delimited "$git\Analysis\Personality\Big-5\_omega.csv", delimiter(";") clear

encode traits, gen(big5)
gen deltaraw=(raw2020-raw2016)*100/raw2016
gen deltacor=(cor2020-cor2016)*100/cor2016

gen delta2016=(cor2016-raw2016)*100/raw2016
gen delta2020=(cor2020-raw2020)*100/raw2020
set graph off
graph bar raw2016 cor2016 raw2020 cor2020, over(traits) blabel(bar, format(%4.2f) size(tiny)) legend(pos(6) col(4) order(1 "Non-cor. 2016-17" 2 "Corr. 2016-17" 3 "Non-cor. 2020-21" 4 "Corr. 2020-21")) name(g1, replace) note("McDonald's Ω", size(tiny))
graph save "$git\Analysis\Personality\Big-5\omega.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\omega.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\omega.pdf", as(pdf) replace

graph bar deltaraw deltacor, over(traits) ylabel(-70(10)80) ymtick(-65(5)75) blabel(bar, format(%4.2f) size(tiny)) legend(pos(6) col(2) order(1 "Non-cor." 2 "Corr.")) title("Variation over time (2016-17 / 2020-21)", size(small)) name(g2, replace)
graph bar delta2016 delta2020, over(traits) ylabel(-70(10)80) blabel(bar, format(%4.2f) size(tiny)) legend(pos(6) col(2) order(1 "2016-17" 2 "2020-21")) title("Variation over correction (Non-cor. / Corr.)", size(small)) name(g3, replace)
graph combine g2 g3, col(3) note("Variation rate of McDonald's Ω", size(tiny))
graph save "$git\Analysis\Personality\Big-5\omega_delta.gph", replace
graph export "$git\RUME-NEEMSIS\Big-5\omega_delta.svg", as(svg) replace
graph export "$git\Analysis\Personality\Big-5\omega_delta.pdf", as(pdf) replace
set graph on

restore
****************************************
* END










****************************************
* TABLE
****************************************
*Nb
tab nbdec  // 0-403; 1-297; 2-115; 3-20
tab1 dec_raven_tt dec_num_tt dec_lit_tt
tab dec_raven_tt if nbdec==1  // 234=78.79
tab dec_num_tt if nbdec==1  // 37=12.46
tab dec_lit_tt if nbdec==1  // 26=8.75

tab dec_raven dec_num if nbdec==2  // 52=45.22
tab dec_raven dec_lit if nbdec==2  // 56=48.69
tab dec_num dec_lit if nbdec==2  // 7=6.09

*By age
stripplot age , over(nbdec) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(4) xtitle("") xlabel(0 "Stable or better" 1 "One decrease" 2 "Two decrease" 3 "Three decrease",angle(45))  ///
ylabel(15(5)90) ytitle("") ///
title("Age in 2016-17") ///
msymbol(oh) mcolor(gs8) name(y1, replace) 
*By gender
tab nbdec sex, col nofreq
*By caste
tab nbdec caste, col nofreq

****************************************
* END