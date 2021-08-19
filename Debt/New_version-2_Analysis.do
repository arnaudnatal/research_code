cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
19 avril 2021
-----
TITLE: ANALYSIS OVERINDEBTEDNESS


-------------------------
*/

clear all
global name "Arnaud"
*set scheme plottig
set scheme plotplain

global directory "D:\Documents\_Thesis\Research-Overindebtedness\New_version_with2020"
cd"$directory"




****************************************
* Not balanced
****************************************
use"$directory\_paneldata\RUME-NEEMSIS-HH_v2.dta", clear
tabstat hhsize_2010 hhsize_2016 hhsize_2020, stat(n mean sd p50) by(caste)

*Verif assets
/*
gen testdiff=def_amountownlandwet_a_2016-def_amountownlandwet_2016
sort testdiff
order testdiff def_amountownlandwet_a_2016 def_amountownlandwet_2016 DAR_2016 DAR_as2010_2016
*/

*Housing
tab house_2010 caste, col nofreq
tab house_2016 caste, col nofreq
tab house_2020 caste, col nofreq
tabstat def_housevalue1000_2010 def_housevalue1000_2016 def_housevalue1000_2020, stat(n mean sd p50) by(caste)
tab housetype_2010 caste, col nofreq
tab housetype_2016 caste, col nofreq
tab housetype_2020 caste, col nofreq
tab housetitle_2010 caste, col nofreq 
tab housetitle_2016 caste, col nofreq
tab housetitle_2020 caste, col nofreq

*Assets
tabstat def_assets1000_2010 def_assets1000_2016 def_assets1000_a_2016, stat(n mean sd p50) by(caste)
tabstat def_assets1000_2010 def_assets1000_2016 def_assets1000_2020, stat(n mean sd p50) by(caste)
tabstat def_assets_noland1000_2010 def_assets_noland1000_2016 def_assets_noland1000_2020, stat(n mean sd p50) by(caste)

*Land
tab dummyownland_2010 caste, col nofreq
tab dummyownland_2016 caste, col nofreq
tab dummyownland_2020 caste, col nofreq
tabstat sizeownland_2010 sizeownland_2016 sizeownland_2020, stat(n mean sd p50) by(caste)

*Income
tabstat def_annualincome_HH1000_2010 def_annualincome_HH1000_2016 def_annualincome_HH1000_2020, stat(n mean sd p50) by(caste)
tabstat nboccupation_HH_2010 nboccupation_HH_2016 nboccupation_HH_2020, stat(n mean sd p50) by(caste)

*Debt
tab debt_HH_2010 caste, col nofreq
tab debt_HH_2016 caste, col nofreq
tab debt_HH_2020 caste, col nofreq

tabstat loans_HH_2010 loans_HH_2016 loans_HH_2020, stat(n mean sd p50) by(caste)

tabstat def_loanamount_HH1000_2010 def_loanamount_HH1000_2016 def_loanamount_HH1000_2020, stat(n mean sd p50) by(caste)

tabstat def_imp1_ds_tot_HH1000_2010 def_imp1_ds_tot_HH1000_2016 def_imp1_ds_tot_HH1000_2020, stat(n mean sd p50) by(caste)

tabstat DAR_2010 DAR_2016 DAR_as2010_2016, stat(n mean sd p50) by(caste)

tabstat DSR_2010 DSR_2016 DSR_2020, stat(n mean sd p50) by(caste)

tabstat loanamount_HH_2010 loanamount_HH_2016 loanamount_HH_2020, stat(n mean sd p50 min max)

gen DIR_2010=loanamount_HH_2010/annualincome_HH_2010
gen DIR_2016=loanamount_HH_2016/annualincome_HH_2016
gen DIR_2020=loanamount_HH_2020/annualincome_HH_2020

tabstat DIR_2010 DIR_2016 DIR_2020, stat(n mean sd p50 p90 p95 p99) by(caste)

********** Head
tab head_sex_2010 caste, col nofreq
tab head_sex_2016 caste, col nofreq
tab head_sex_2020 caste, col nofreq
tabstat head_age_2010 head_age_2016 head_age_2020, stat(n mean sd p50) by(caste)
tab head_edulevel_2010 caste, col nofreq
tab head_edulevel_2016 caste, col nofreq
tab head_edulevel_2020 caste, col nofreq

tab head_mainoccupation_indiv_2010 caste, col nofreq
tab head_mainoccupation_indiv_2016 caste, col nofreq
tab head_mainoccupation_indiv_2020 caste, col nofreq




********** Graph
*DAR
foreach x in DAR {
foreach i in 2010 2016 2020 {
gen `x'2_`i'=`x'_`i'
}
}

rename DAR_as2010_2016 DAR_a_2016
gen DAR2_a_2016=DAR_a_2016
fsum DAR_2010 DAR_2016 DAR_2020 DAR_a_2016, stat(p90 p95 p99 max)

replace DAR2_2010=142 if DAR_2010>142
replace DAR2_2016=787 if DAR_2016>787
replace DAR2_2020=232 if DAR_2020>232
replace DAR2_a_2016=345 if DAR_a_2016>345

set graph off
stripplot DAR2_2010 DAR2_a_2016, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(50)350) ymtick(0(25)350) ytitle() ///
msymbol(oh oh oh) mcolor(plr1   plg1) 

*Graph over caste
twoway (kdensity DAR_2010 if DAR_2010<400 & caste==1, bwidth(6)) (kdensity DAR_2010 if DAR_2010<400 & caste==2, bwidth(6)) (kdensity DAR_2010 if DAR_2010<400 & caste==3, bwidth(6)), legend(order(1 "Dalits" 2 "Middle" 3 "Upper")) xtitle("Debt to assets ratio") xlabel(0(50)400) ytitle("Density") title("2010") name(g1, replace)

twoway (kdensity DAR_a_2016 if DAR_a_2016<400 & caste==1, bwidth(15)) (kdensity DAR_a_2016 if DAR_a_2016<400 & caste==2, bwidth(15)) (kdensity DAR_a_2016 if DAR_a_2016<400 & caste==3, bwidth(15)), legend(order(1 "Dalits" 2 "Middle" 3 "Upper") col(3)) xtitle("Debt to assets ratio") xlabel(0(50)400) ytitle("Density") title("2016-17") name(g2, replace)

grc1leg g1 g2, leg(g2) note("Kernel: epanechnikov, bandwidth: 6 (2010) and 15 (2016-17).", size(vsmall)) name(gcomb, replace)
graph save "DAR_caste.gph", replace
graph export "DAR_caste.pdf", as(pdf) replace


*Graph over assets
xtile q_assets_2010=assets_2010, n(3)
xtile q_assets_a_2016=assets_a_2016, n(3)
twoway (kdensity DAR_2010 if DAR_2010<400 & q_assets_2010==1, bwidth(6)) (kdensity DAR_2010 if DAR_2010<400 & q_assets_2010==2, bwidth(6)) (kdensity DAR_2010 if DAR_2010<400 & q_assets_2010==3, bwidth(6)), legend(order(1 "Tercile 1" 2 "Tercile 2" 3 "Tercile 3")) xtitle("Debt to assets ratio") xlabel(0(50)400) ytitle("Density") title("2010") name(g1, replace)

twoway (kdensity DAR_a_2016 if DAR_a_2016<400 & q_assets_a_2016==1, bwidth(15)) (kdensity DAR_a_2016 if DAR_a_2016<400 & q_assets_a_2016==2, bwidth(15)) (kdensity DAR_a_2016 if DAR_a_2016<400 & q_assets_a_2016==3, bwidth(15)), legend(order(1 "Tercile 1" 2 "Tercile 2" 3 "Tercile 3") col(3)) xtitle("Debt to assets ratio") xlabel(0(50)400) ytitle("Density") title("2016-17") name(g2, replace)

grc1leg g1 g2, leg(g2) note("Kernel: epanechnikov, bandwidth: 6 (2010) and 15 (2016-17).", size(vsmall)) name(gcomb, replace)
graph save "DAR_tercile.gph", replace
graph export "DAR_tercile.pdf", as(pdf) replace
set graph on



*DSR
fsum DSR_2010 DSR_2016 DSR_2020, stat(p90 p95 p99 max)
foreach x in DSR {
foreach i in 2010 2016 2020 {
gen `x'2_`i'=`x'_`i'
}
}
replace DSR2_2010=225 if DSR_2010>225
replace DSR2_2016=381 if DSR_2016>381
replace DSR2_2020=580 if DSR_2020>580

stripplot DSR_2010 DSR_2016 DSR_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(50)580) ymtick(0(10)580) ytitle() ///
msymbol(oh oh oh) mcolor(plr1   plg1)

twoway (kdensity DSR_2010 if DSR_2010<300)(kdensity DSR_2016 if DSR_2016<300) (kdensity DSR_2020 if DSR_2020<300)


****************************************
* END
*/













****************************************
* Strongly balanced
****************************************
cls
use"$directory\_paneldata\RUME-NEEMSIS-HH_v2.dta", clear
keep if panel_comp==1

tabstat hhsize_2010 hhsize_2016 hhsize_2020, stat(n mean sd p50) by(caste)

*Housing
tab house_2010 caste, col nofreq
tab house_2016 caste, col nofreq
tab house_2020 caste, col nofreq
tabstat def_housevalue1000_2010 def_housevalue1000_2016 def_housevalue1000_2020, stat(n mean sd p50) by(caste)
tab housetype_2010 caste, col nofreq
tab housetype_2016 caste, col nofreq
tab housetype_2020 caste, col nofreq
tab housetitle_2010 caste, col nofreq 
tab housetitle_2016 caste, col nofreq
tab housetitle_2020 caste, col nofreq

*Assets
tabstat def_assets1000_2010 def_assets1000_2016 def_assets1000_2020, stat(n mean sd p50) by(caste)
tabstat def_assets_noland1000_2010 def_assets_noland1000_2016 def_assets_noland1000_2020, stat(n mean sd p50) by(caste)

*Land
tab dummyownland_2010 caste, col nofreq
tab dummyownland_2016 caste, col nofreq
tab dummyownland_2020 caste, col nofreq
tabstat sizeownland_2010 sizeownland_2016 sizeownland_2020, stat(n mean sd p50) by(caste)

*Income
tabstat def_annualincome_HH1000_2010 def_annualincome_HH1000_2016 def_annualincome_HH1000_2020, stat(n mean sd p50) by(caste)
tabstat nboccupation_HH_2010 nboccupation_HH_2016 nboccupation_HH_2020, stat(n mean sd p50) by(caste)

*Debt
tab debt_HH_2010 caste, col nofreq
tab debt_HH_2016 caste, col nofreq
tab debt_HH_2020 caste, col nofreq

tabstat loans_HH_2010 loans_HH_2016 loans_HH_2020, stat(n mean sd p50) by(caste)

tabstat def_loanamount_HH1000_2010 def_loanamount_HH1000_2016 def_loanamount_HH1000_2020, stat(n mean sd p50) by(caste)

tabstat def_imp1_ds_tot_HH1000_2010 def_imp1_ds_tot_HH1000_2016 def_imp1_ds_tot_HH1000_2020, stat(n mean sd p50) by(caste)

tabstat DAR_2010 DAR_2016 DAR_2020, stat(n mean sd p50) by(caste)

tabstat DSR_2010 DSR_2016 DSR_2020, stat(n mean sd p50) by(caste)



********** Head
tab head_sex_2010 caste, col nofreq
tab head_sex_2016 caste, col nofreq
tab head_sex_2020 caste, col nofreq
tabstat head_age_2010 head_age_2016 head_age_2020, stat(n mean sd p50) by(caste)
tab head_edulevel_2010 caste, col nofreq
tab head_edulevel_2016 caste, col nofreq
tab head_edulevel_2020 caste, col nofreq

tab head_mainoccupation_indiv_2010 caste, col nofreq
tab head_mainoccupation_indiv_2016 caste, col nofreq
tab head_mainoccupation_indiv_2020 caste, col nofreq


********** With graph?
pctile c1_def_assets=d1_def_assets, nq(20)
pctile c2_def_assets=d2_def_assets, nq(20)

pctile c1_def_assets_noland=d1_def_assets_noland, nq(20)
pctile c2_def_assets_noland=d2_def_assets_noland, nq(20)

pctile c1_def_annualincome_HH=d1_def_annualincome_HH, nq(20)
pctile c2_def_annualincome_HH=d2_def_annualincome_HH, nq(20)

pctile c1_def_imp1_ds_tot_HH=d1_def_imp1_ds_tot_HH, nq(20)
pctile c2_def_imp1_ds_tot_HH=d2_def_imp1_ds_tot_HH, nq(20)

pctile c1_def_loanamount=d1_def_loanamount, nq(20)
pctile c2_def_loanamount=d2_def_loanamount, nq(20)

pctile c1_DAR=d1_DAR, nq(20)
pctile c2_DAR=d2_DAR, nq(20)

pctile c1_DSR=d1_DSR, nq(20)
pctile c2_DSR=d2_DSR, nq(20)

gen n=_n if c1_DAR!=.
replace n=n*5

tabstat d1_def_assets d1_def_assets_noland d1_def_annualincome_HH d1_def_imp1_ds_tot_HH d1_def_loanamount d1_DAR d1_DSR d2_def_assets d2_def_assets_noland d2_def_annualincome_HH d2_def_imp1_ds_tot_HH d2_def_loanamount d2_DAR d2_DSR, stat(n p5 p90 p95)

set graph off
*Finance
label var c1_def_assets "Δ[2010-2016] Assets"
label var c1_def_assets_noland "Δ[2010-2016] Assets (without immo)"
label var c1_def_annualincome_HH "Δ[2010-2016] Annual income of HH"
label var c2_def_assets "Δ[2016-2020] Assets"
label var c2_def_assets_noland "Δ[2016-2020] Assets (without immo)"
label var c2_def_annualincome_HH "Δ[2016-2020] Annual income of HH"
label var c1_def_loanamount "Δ[2010-2016] Loan amount"
label var c1_DAR "Δ[2010-2016] Debt/assets ratio"
label var c2_def_loanamount "Δ[2016-2020] Loan amount"
label var c2_DAR "Δ[2016-2020] Debt/assets ratio"

/*
twoway ///
(connected c1_def_assets n, msymbol() mcolor() color()) ///
(connected c2_def_assets n, msymbol() mcolor() color()) ///
(connected c1_def_annualincome_HH n, msymbol() mcolor() color()) ///
(connected c2_def_annualincome_HH n, msymbol() mcolor() color()), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(100)1200) ymtick(-100(50)1200) ytitle("Variation rate (%)") yline(0) ///
title("") legend(pos(6) cols(2)) name(fin1, replace)
graph export "Delta_fin.svg", as(svg) name(fin1) replace

twoway ///
(connected c1_def_assets_noland n, msymbol() mcolor( ) color( )) ///
(connected c2_def_assets_noland n, msymbol() mcolor( ) color( )) ///
(connected c1_def_annualincome_HH n, msymbol() mcolor( ) color( )) ///
(connected c2_def_annualincome_HH n, msymbol() mcolor( ) color( )), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(100)1200) ymtick(-100(50)1200) ytitle("Variation rate (%)") yline(0) ///
title("") legend(pos(6) cols(2)) name(fin1, replace)
graph export "Delta_fin_bis.svg", as(svg) name(fin1) replace

*Debt
twoway ///
(connected c1_def_loanamount n, msymbol() mcolor( ) color( )) ///
(connected c2_def_loanamount n, msymbol() mcolor( ) color( )) ///
(connected c1_DAR n if c1_DAR<2000, msymbol() mcolor( ) color( )) ///
(connected c2_DAR n, msymbol() mcolor( ) color( )), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(100)1600) ymtick(-100(50)1600) ytitle("Variation rate (%)") yline(0) ///
title("") legend(pos(6) cols(2)) name(debt, replace)
graph export "Delta_debt.svg", as(svg) name(debt) replace
*/
set graph on


*********** Double cat
*Assets
tab cat_d1_def_assets cat_d2_def_assets, cell nofreq
tab cat_d1_def_assets_noland cat_d2_def_assets_noland, cell nofreq


*Income
tab cat_d1_def_annualincome_HH cat_d2_def_annualincome_HH, cell nofreq


*Debt
tab cat_d1_DAR cat_d2_DAR, cell nofreq
tab cat_d1_def_loanamount_HH cat_d2_def_loanamount_HH, cell nofreq
tab cat_d1_def_imp1_ds_tot_HH cat_d2_def_imp1_ds_tot_HH, cell nofreq



/*
********** Graph rpz of debt
label define caste 1"Dalit" 2"Middle" 3"Upper", replace
label values caste caste
*DAR
fsum DAR_2010 DAR_2016 DAR_2020, stat(p90 p95 p99 max)
tab DAR_2010 if DAR_2010>700  // 1
tab DAR_2016 if DAR_2016>700  // 6
tab DAR_2020 if DAR_2020>700  // 1
foreach x in DAR {
foreach i in 2010 2016 2020 {
gen `x'2_`i'=`x'_`i'
}
}
replace DAR2_2010=700 if DAR_2010>700
replace DAR2_2016=700 if DAR_2016>700
replace DAR2_2020=700 if DAR_2020>700

stripplot DAR2_2010 DAR2_2016 DAR2_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(1"2010" 2"2016" 3"2020",angle())  ///
ylabel(0(100)700) ymtick(0(50)700) ytitle("Debt to assets ratio") ///
msymbol(oh oh oh) mcolor(plr1   plg1) name(debt, replace)
graph export "Box_DAR.svg", as(svg) name(debt)

*DSR
fsum def_loanamount_HH1000_2010 def_loanamount_HH1000_2016 def_loanamount_HH1000_2020, stat(p90 p95 p99 max)
foreach x in DSR {
foreach i in 2010 2016 2020 {
gen `x'2_`i'=`x'_`i'
}
}
replace def_loanamount_HH1000_2010=1200 if def_loanamount_HH1000_2010>1200
replace def_loanamount_HH1000_2016=1200 if def_loanamount_HH1000_2016>1200
replace def_loanamount_HH1000_2020=1200 if def_loanamount_HH1000_2020>1200

stripplot def_loanamount_HH1000_2010 def_loanamount_HH1000_2016 def_loanamount_HH1000_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(1"2010" 2"2016" 3"2020",angle())  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle("Loan amount (1,000 INR)") ///
msymbol(oh oh oh) mcolor(plr1   plg1) name(debt, replace)
graph export "Box_Loan.svg", as(svg) name(debt)
*/



********** Chitfunds
tab dummychitfund_2010 caste 
tab dummychitfund_2016 caste
tab dummychitfund_2020 caste


********** Savings
tab dummysavingaccount_2010 caste
tab dummysavingaccount_2016 caste
tab dummysavingaccount_2020 caste



********** Insurance
tab dummyinsurance_2010 caste
tab dummyinsurance_2016 caste
tab dummyinsurance_2020 caste






********** Non agri income vs income agri?
/*
tabstat def_incomeagri_HH_2010 def_incomeagri_HH_2016 def_incomeagri_HH_2020 def_incomenonagri_HH_2010 def_incomenonagri_HH_2016 def_incomenonagri_HH_2020, stat(n mean sd p50) by(caste)

tabstat def_incomeonlyagri_HH_2010 def_incomeonlyagri_HH_2016 def_incomeonlyagri_HH_2020 def_incomenononlyagri_HH_2010 def_incomenononlyagri_HH_2016 def_incomenononlyagri_HH_2020, stat(n mean sd p50) by(caste)

tabstat d1_def_incomeagri_HH d2_def_incomeagri_HH d1_def_incomenonagri_HH d2_def_incomenonagri_HH, stat(n mean sd p50) by(caste)

tabstat d1_def_incomeonlyagri_HH d2_def_incomeonlyagri_HH d1_def_incomenononlyagri_HH d2_def_incomenononlyagri_HH, stat(n mean sd p50) by(caste)
*/

tabstat share_agri_2010 share_agri_2016 share_agri_2020, stat(n mean sd p50) by(caste)
tabstat share_nonagri_2010 share_nonagri_2016 share_nonagri_2020, stat(n mean sd p50) by(caste)
tabstat share_onlyagri_2010 share_onlyagri_2016 share_onlyagri_2020, stat(n mean sd p50) by(caste)
tabstat share_nononlyagri_2010 share_nononlyagri_2016 share_nononlyagri_2020, stat(n mean sd p50) by(caste)

label define caste 1"Dalits" 2"Middle" 3"Upper", replace
label values caste caste

set graph off
/*
** Not only
stripplot share_agri_2010 share_agri_2016 share_agri_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("Agri. income") xlabel(1"2010" 2"2016" 3"2020",angle(45))  ///
ylabel(0(10)100) ymtick(-0(5)100) ytitle("Share of total income of HH") ///
msymbol(oh oh oh) mcolor(plr1 plg1 ply1) name(agri1, replace) leg(col(3))


stripplot share_nonagri_2010 share_nonagri_2016 share_nonagri_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("Non-agri. income") xlabel(1"2010" 2"2016" 3"2020",angle(45))  ///
ylabel(0(10)100) ymtick(-0(5)100) ytitle("Share of total income of HH") ///
msymbol(oh oh oh) mcolor(plr1 plg1 ply1) name(nonagri1, replace)

grc1leg agri1 nonagri1, name(share1, replace)
graph export "Shareincome1.svg", as(svg) name(share1) replace

**Only
stripplot share_onlyagri_2010 share_onlyagri_2016 share_onlyagri_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("Only agri. income") xlabel(1"2010" 2"2016" 3"2020",angle(45))  ///
ylabel(0(10)100) ymtick(-0(5)100) ytitle("Share of total income of HH") ///
msymbol(oh oh oh) mcolor(plr1 plg1 ply1) name(agri1, replace) leg(col(3))


stripplot share_nononlyagri_2010 share_nononlyagri_2016 share_nononlyagri_2020, over() separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("Only non-agri. income") xlabel(1"2010" 2"2016" 3"2020",angle(45))  ///
ylabel(0(10)100) ymtick(-0(5)100) ytitle("Share of total income of HH") ///
msymbol(oh oh oh) mcolor(plr1 plg1 ply1) name(nonagri1, replace)

grc1leg agri1 nonagri1, name(share1, replace)
graph export "Shareincome2.svg", as(svg) name(share1) replace
*/
set graph on


********** Evolution
cls
tab cat_d1_share_agri caste, col nofreq
tab cat_d2_share_agri caste, col nofreq

tab cat_d1_share_nonagri caste, col nofreq
tab cat_d2_share_nonagri caste, col nofreq

tab cat_d1_share_onlyagri caste, col nofreq
tab cat_d2_share_onlyagri caste, col nofreq

tab cat_d1_share_nononlyagri caste, col nofreq
tab cat_d2_share_nononlyagri caste, col nofreq


pctile c1_share_agri=d1_share_agri, nq(20)
pctile c2_share_agri=d2_share_agri, nq(20)
label var c1_share_agri "Δ 2010-2016/17"
label var c2_share_agri "Δ 2016/17-2020/21"

pctile c1_share_nonagri=d1_share_nonagri, nq(20)
pctile c2_share_nonagri=d2_share_nonagri, nq(20)
label var c1_share_nonagri "Δ 2010-2016/17"
label var c2_share_nonagri "Δ 2016/17-2020/21"

pctile c1_share_onlyagri=d1_share_onlyagri, nq(20)
pctile c2_share_onlyagri=d2_share_onlyagri, nq(20)
label var c1_share_onlyagri "Δ 2010-2016/17"
label var c2_share_onlyagri "Δ 2016/17-2020/21"

pctile c1_share_nononlyagri=d1_share_nononlyagri, nq(20)
pctile c2_share_nononlyagri=d2_share_nononlyagri, nq(20)
label var c1_share_nononlyagri "Δ 2010-2016/17"
label var c2_share_nononlyagri "Δ 2016/17-2020/21"

tabstat c1_share_agri c2_share_agri c1_share_nonagri c2_share_nonagri, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max)
tabstat c1_share_onlyagri c2_share_onlyagri c1_share_nononlyagri c2_share_nononlyagri, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max)

set graph off

twoway ///
(connected c1_share_agri n, msymbol() mcolor() color()) ///
(connected c2_share_agri n, msymbol() mcolor() color()), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(100)1000) ymtick(-100(50)1000) ytitle("Variation rate (%)") yline(0) ///
title("Agri income") legend(pos(6) cols(2)) name(fin1, replace)

twoway ///
(connected c1_share_nonagri n if c1_share_nonagri<100000, msymbol() mcolor() color()) ///
(connected c2_share_nonagri n if c2_share_nonagri<100000, msymbol() mcolor() color()), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(100)1100) ymtick(-100(50)1100) ytitle("Variation rate (%)") yline(0) ///
title("Non-agri income") legend(pos(6) cols(2)) name(fin2, replace)

grc1leg fin1 fin2, name(evo,replace)
graph export "Delta_share1.svg", as(svg) replace

twoway ///
(connected c1_share_onlyagri n, msymbol() mcolor() color()) ///
(connected c2_share_onlyagri n, msymbol() mcolor() color()), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(100)600) ymtick(-100(50)600) ytitle("Variation rate (%)") yline(0) ///
title("Only agri income") legend(pos(6) cols(2)) name(fin1, replace)

twoway ///
(connected c1_share_nononlyagri n if c1_share_nonagri<100000, msymbol() mcolor() color()) ///
(connected c2_share_nononlyagri n if c2_share_nonagri<100000, msymbol() mcolor() color()), ///
xlabel(0(10)100) xmtick(0(5)100) xtitle("% of population") ///
ylabel(-100(50)300) ymtick(-100(10)350) ytitle("Variation rate (%)") yline(0) ///
title("Only non-agri income") legend(pos(6) cols(2)) name(fin2, replace)

grc1leg fin1 fin2, name(evo,replace)
graph export "Delta_share2.svg", as(svg) replace

set graph on


****************************************
* END

















****************************************
* STATS 2020 : loss in assets
****************************************
use"$directory\Data\NEEMSIS2-HH_v17.dta", clear
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge

sort HHID_panel INDID
bysort HHID_panel : gen n=_n
keep if n==1
dropmiss, force
tab orga_HHagri
keep if orga_HHagri==3
tab panel_2010_2016_2020
sort HHID_panel


********** Loans
tab covrefusalloan caste, col nofreq



********** Loss
*Land
destring covsellland, replace
recode covsellland (66=0) (2=0)
tab covsellland caste, col 
*Livestock
foreach x in covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin covselllivestock_none {
tab `x' caste, col nofreq
}
egen covselllivestock_total=rowtotal(covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin)
replace covselllivestock_total=1 if covselllivestock_total>=1
tab covselllivestock_total caste, col 
*Equipment
foreach x in covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac covsellequipment_none {
tab `x' caste, col nofreq
}
egen covsellequipment_total=rowtotal(covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac)
replace covsellequipment_total=1 if covsellequipment_total>=1
tab covsellequipment_total caste, col nofreq
*Goods
foreach x in covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other covsellgoods_none {
tab `x' caste, col nofreq
}
egen covsellgoods_total=rowtotal(covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other)
replace covsellgoods_total=1 if covsellgoods_total>=1
tab covsellgoods_total caste, col nofreq
*House
destring covsellhouse, replace
recode covsellhouse (66=0) (2=0)
tab covsellhouse caste, col nofreq

destring covsellplot, replace
recode covsellplot (66=0) (2=0)
tab covsellplot caste, col nofreq

*Gold
destring covsoldgold, replace
tab covsoldgold caste, col
tabstat covsoldgoldquantity, stat(n mean sd p50) by(caste)
tab covlostgold caste, col

*Total
recode covsellland covselllivestock_total covsellequipment_total covsellgoods_total covsellhouse covsellplot covsoldgold (.=0)
egen covsell_total=rowtotal(covsellland covselllivestock_total covsellequipment_total covsellgoods_total covsellhouse covsellplot covsoldgold)
replace covsell_total=1 if covsell_total>1

tab covsell_total caste, col




********** SC vs subsistence
tab dummyeverhadland caste, col
tab ownland caste, col
tab covsubsistence caste, col
tab covsubsistencenext caste, col



**************
****** INDIVIDUAL SCALE
use"$directory\Data\NEEMSIS2-HH_v17.dta", clear
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge

dropmiss, force
tab orga_HHagri
keep if orga_HHagri==3
fre livinghome
drop if livinghome==3
drop if livinghome==4
tab panel_2010_2016_2020
sort caste
drop if caste==.
sort HHID_panel INDID

********** Lending
gen lendingindiv=0
replace lendingindiv=1 if borrowerscaste!=.
tab lendingindiv caste, col
replace covlendrepayment=2 if covlendrepayment==. & lendingindiv==1
tab covlendrepayment caste, col
tab covlending caste, col




********** Chitfunds, saving, gold
*Chitfund
tab chitfundbelongerid_ caste, col
tab nbchitfunds caste, col
destring covchitfundstop1 covchitfundstop2 covchitfundstop3, replace
egen covchitfundstop=rowtotal(covchitfundstop1 covchitfundstop2 covchitfundstop3)
replace covchitfundstop=1 if covchitfundstop>1
replace covchitfundstop=. if chitfundbelongerid_==. | chitfundbelongerid_==0
tab covchitfundstop caste, col

replace covchitfundreturn1="0" if covchitfundstop1!=. & covchitfundreturn1==""
replace covchitfundreturn2="0" if covchitfundstop2!=. & covchitfundreturn2==""
destring covchitfundreturn1 covchitfundreturn2, replace
egen covchitfundreturn=rowtotal(covchitfundreturn1 covchitfundreturn2)
replace covchitfundreturn=1 if covchitfundreturn>1
replace covchitfundreturn=. if chitfundbelongerid_==. | chitfundbelongerid_==0
tab covchitfundreturn caste, col

*Saving
recode savingsownerid_ (.=0)
tab savingsownerid_ caste, col
tab nbsavingaccounts caste, col nofreq
destring covsavinguse1 covsavinguse2 covsavinguse3 covsavinguse4, replace
egen covsavinguse=rowtotal(covsavinguse1 covsavinguse2 covsavinguse3 covsavinguse4)
replace covsavinguse=1 if covsavinguse>1
replace covsavinguse=. if savingsownerid_==. | savingsownerid_==0
tab covsavinguse caste, col nofreq

egen covsavinguseamount=rowtotal(covsavinguseamount1 covsavinguseamount2 covsavinguseamount3)
replace covsavinguseamount=. if savingsownerid_==. | savingsownerid_==0
replace covsavinguseamount=. if covsavinguse==. | covsavinguse==0
tabstat covsavinguseamount, stat(n mean sd p50) by(caste)

*Gold pledge
tab dummygoldpledged caste, col
gen goldamountpledge1000=goldamountpledge/1000
tabstat goldquantitypledge goldamountpledge1000, stat(n mean sd p50) by(caste)
tabstat covgoldpledged, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(caste)
gen covratio=covgoldpledged*100/goldquantitypledge
tabstat covratio, stat(n mean sd p50) by(caste)
drop covratio


****************************************
* END
















****************************************
* STATS 2020 : loss in assets for BALANCED PANEL ONLY
****************************************
cls
use"$directory\Data\NEEMSIS2-HH_v17.dta", clear
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge

sort HHID_panel INDID
bysort HHID_panel : gen n=_n
keep if n==1
dropmiss, force
tab orga_HHagri
keep if orga_HHagri==3
tab panel_2010_2016_2020
keep if panel_2010_2016_2020==1
sort HHID_panel


********** Loans
tab covrefusalloan caste, col nofreq



********** Loss
*Land
destring covsellland, replace
recode covsellland (66=0) (2=0)
tab covsellland caste, col 
*Livestock
foreach x in covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin covselllivestock_none {
tab `x' caste, col nofreq
}
egen covselllivestock_total=rowtotal(covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin)
replace covselllivestock_total=1 if covselllivestock_total>=1
tab covselllivestock_total caste, col 
*Equipment
foreach x in covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac covsellequipment_none {
tab `x' caste, col nofreq
}
egen covsellequipment_total=rowtotal(covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac)
replace covsellequipment_total=1 if covsellequipment_total>=1
tab covsellequipment_total caste, col nofreq
*Goods
foreach x in covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other covsellgoods_none {
tab `x' caste, col nofreq
}
egen covsellgoods_total=rowtotal(covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other)
replace covsellgoods_total=1 if covsellgoods_total>=1
tab covsellgoods_total caste, col nofreq
*House
destring covsellhouse, replace
recode covsellhouse (66=0) (2=0)
tab covsellhouse caste, col nofreq

destring covsellplot, replace
recode covsellplot (66=0) (2=0)
tab covsellplot caste, col nofreq

*Gold
destring covsoldgold, replace
tab covsoldgold caste, col
tabstat covsoldgoldquantity, stat(n mean sd p50) by(caste)
tab covlostgold caste, col

*Total
recode covsellland covselllivestock_total covsellequipment_total covsellgoods_total covsellhouse covsellplot covsoldgold (.=0)
egen covsell_total=rowtotal(covsellland covselllivestock_total covsellequipment_total covsellgoods_total covsellhouse covsellplot covsoldgold)
replace covsell_total=1 if covsell_total>1

tab covsell_total caste, col



********** SC vs subsistence
tab dummyeverhadland caste, col
tab ownland caste, col
tab covsubsistence caste, col
tab covsubsistencenext caste, col




**************
****** INDIVIDUAL SCALE
use"$directory\Data\NEEMSIS2-HH_v17.dta", clear
merge m:1 HHID_panel using "$directory\_paneldata\panel_comp.dta"
keep if _merge==3
drop _merge

dropmiss, force
tab orga_HHagri
keep if orga_HHagri==3
fre livinghome
drop if livinghome==3
drop if livinghome==4
tab panel_2010_2016_2020
keep if panel_2010_2016_2020==1
sort caste
drop if caste==.
sort HHID_panel INDID
cls

********** Lending
gen lendingindiv=0
replace lendingindiv=1 if borrowerscaste!=.
tab lendingindiv caste, col
replace covlendrepayment=2 if covlendrepayment==. & lendingindiv==1
tab covlendrepayment caste, col
tab covlending caste, col




********** Chitfunds, saving, gold
*Chitfund
tab chitfundbelongerid_ caste, col
tab nbchitfunds caste, col
destring covchitfundstop1 covchitfundstop2 covchitfundstop3, replace
egen covchitfundstop=rowtotal(covchitfundstop1 covchitfundstop2 covchitfundstop3)
replace covchitfundstop=1 if covchitfundstop>1
replace covchitfundstop=. if chitfundbelongerid_==. | chitfundbelongerid_==0
tab covchitfundstop caste, col

replace covchitfundreturn1="0" if covchitfundstop1!=. & covchitfundreturn1==""
replace covchitfundreturn2="0" if covchitfundstop2!=. & covchitfundreturn2==""
destring covchitfundreturn1 covchitfundreturn2, replace
egen covchitfundreturn=rowtotal(covchitfundreturn1 covchitfundreturn2)
replace covchitfundreturn=1 if covchitfundreturn>1
replace covchitfundreturn=. if chitfundbelongerid_==. | chitfundbelongerid_==0
tab covchitfundreturn caste, col

*Saving
recode savingsownerid_ (.=0)
tab savingsownerid_ caste, col
tab nbsavingaccounts caste, col nofreq
destring covsavinguse1 covsavinguse2 covsavinguse3 covsavinguse4, replace
egen covsavinguse=rowtotal(covsavinguse1 covsavinguse2 covsavinguse3 covsavinguse4)
replace covsavinguse=1 if covsavinguse>1
replace covsavinguse=. if savingsownerid_==. | savingsownerid_==0
tab covsavinguse caste, col nofreq

egen covsavinguseamount=rowtotal(covsavinguseamount1 covsavinguseamount2 covsavinguseamount3)
replace covsavinguseamount=. if savingsownerid_==. | savingsownerid_==0
replace covsavinguseamount=. if covsavinguse==. | covsavinguse==0
tabstat covsavinguseamount, stat(n mean sd p50) by(caste)

*Gold pledge
tab dummygoldpledged caste, col
gen goldamountpledge1000=goldamountpledge/1000
tabstat goldquantitypledge goldamountpledge1000, stat(n mean sd p50) by(caste)
tabstat covgoldpledged, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(caste)
gen covratio=covgoldpledged*100/goldquantitypledge
tabstat covratio, stat(n mean sd p50) by(caste)
drop covratio


****************************************
* END


















****************************************
* STATS for loans
****************************************
cls
use"$directory\_paneldata\panel-all_loans_v2.dta", clear


********** Number of loans, ML and data base
tab mainloan caste if year==2010
tab mainloan caste if year==2016
tab mainloan caste if year==2020

tab loan_database year



********** Amount and number
tabstat def_loanamount1000, stat(n mean p50 min max) by(year)

foreach x in 2010 2016 2020 {
tabstat def_loanamount1000 if year==`x', stat(n mean) by(loanreasongiven)
}

foreach x in 2010 2016 2020 {
tabstat def_loanamount1000 if year==`x', stat(n mean) by(loanlender)
}

*Balanced
foreach x in 2010 2016 2020 {
tabstat def_loanamount1000 if year==`x' & panel_2010_2016_2020==1, stat(n mean) by(loanreasongiven)
}
foreach x in 2010 2016 2020 {
tabstat def_loanamount1000 if year==`x' & panel_2010_2016_2020==1, stat(n mean) by(loanlender)
}


********** Total clientele using it: reason
fre loanreasongiven
recode loanreasongiven (6=1) (4=2) (10=2) (9=3) (8=7) (11=7) (77=12)
fre loanreasongiven
recode loanreasongiven (7=4) (12=6)
fre loanreasongiven

tabstat def_loanamount1000 if year==2010, stat(n mean) by(loanreasongiven)
tabstat def_loanamount1000 if year==2016, stat(n mean) by(loanreasongiven)


forvalues i=1(1)6{
gen reason`i'=0
}

forvalues i=1(1)6{
replace reason`i'=1 if loanreasongiven==`i'
}
replace reason13=1 if loanreasongiven==77

*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)6{
bysort HHID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)6{
tab reasonHH_`i', m
}
restore

*2016
cls
preserve 
keep if year==2016
forvalues i=1(1)6{
bysort HHID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)6{
tab reasonHH_`i', m
}
restore

*2020
cls
preserve 
keep if year==2020
forvalues i=1(1)13{
bysort HHID_panel: egen reasonHH_`i'=max(reason`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore


********** Clientele using it: source
fre loanlender
forvalues i=1(1)14{
gen lenders_`i'=0
}
forvalues i=1(1)14{
replace lenders_`i'=1 if loanlender==`i'
}

*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)14{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)14{
tab lendersHH_`i', m
}
restore

*2016
cls
preserve 
keep if year==2016
forvalues i=1(1)14{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)14{
tab lendersHH_`i', m
}
restore
*2020
cls
preserve 
keep if year==2020
forvalues i=1(1)14{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)14{
tab lendersHH_`i', m
}
restore

drop reason1 reason2 reason3 reason4 reason5 reason6 reason7 reason8 reason9 reason10 reason11 reason12 reason13 lenders_1 lenders_2 lenders_3 lenders_4 lenders_5 lenders_6 lenders_7 lenders_8 lenders_9 lenders_10 lenders_11 lenders_12 lenders_13 lenders_14



********** Loan source and loan lender by caste
tab loanreasongiven caste if year==2010, col nofreq
tab loanreasongiven caste if year==2016, col nofreq
tab loanreasongiven caste if year==2020, col nofreq

tab loanlender caste if year==2010, col nofreq
tab loanlender caste if year==2016, col nofreq
tab loanlender caste if year==2020, col nofreq

tabstat def_loanamount1000 if year==2010, stat(n min p1 p5 p10 q p90 p95 p99 max) by(caste)
tabstat def_loanamount1000 if year==2016, stat(n min p1 p5 p10 q p90 p95 p99 max) by(caste)
tabstat def_loanamount1000 if year==2020, stat(n min p1 p5 p10 q p90 p95 p99 max) by(caste)


*Graph
pctile c1_2010_def_loanamount1000=def_loanamount1000 if year==2010 & caste==1, nq(20)
pctile c2_2010_def_loanamount1000=def_loanamount1000 if year==2010 & caste==2, nq(20)
pctile c3_2010_def_loanamount1000=def_loanamount1000 if year==2010 & caste==3, nq(20)

pctile c1_2016_def_loanamount1000=def_loanamount1000 if year==2016 & caste==1, nq(20)
pctile c2_2016_def_loanamount1000=def_loanamount1000 if year==2016 & caste==2, nq(20)
pctile c3_2016_def_loanamount1000=def_loanamount1000 if year==2016 & caste==3, nq(20)

pctile c1_2020_def_loanamount1000=def_loanamount1000 if year==2020 & caste==1, nq(20)
pctile c2_2020_def_loanamount1000=def_loanamount1000 if year==2020 & caste==2, nq(20)
pctile c3_2020_def_loanamount1000=def_loanamount1000 if year==2020 & caste==3, nq(20)


gen n=_n if c1_2010_def_loanamount1000!=.
replace n=n*5

label var c1_2010_def_loanamount1000 "2010"  // 13.17
label var c2_2010_def_loanamount1000 "2010"  // 20
label var c3_2010_def_loanamount1000 "2010"  // 16.18

label var c1_2016_def_loanamount1000 "2016"  // 23.94
label var c2_2016_def_loanamount1000 "2016"  // 37.69
label var c3_2016_def_loanamount1000 "2016"  // 43.26

label var c1_2020_def_loanamount1000 "2020"  // 13.32
label var c2_2020_def_loanamount1000 "2020"  // 18.11
label var c3_2020_def_loanamount1000 "2020"  // 27.50


foreach x in c1_2010_def_loanamount1000 c2_2010_def_loanamount1000 c3_2010_def_loanamount1000 c1_2016_def_loanamount1000 c2_2016_def_loanamount1000 c3_2016_def_loanamount1000 c1_2020_def_loanamount1000 c2_2020_def_loanamount1000  c3_2020_def_loanamount1000 {
sum `x'
}

set graph off
twoway ///
(line c1_2010_def_loanamount1000 n) ///
(line c1_2016_def_loanamount1000 n) ///
(line c1_2020_def_loanamount1000 n), ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("% of loans") ///
ylabel(0(10)100) ymtick(0(5)100) ytitle("Loan amount (1,000 INR)") ///
title("Dalits") legend(pos(6) cols(3)) name(c1, replace)


twoway ///
(line c2_2010_def_loanamount1000 n) ///
(line c2_2016_def_loanamount1000 n) ///
(line c2_2020_def_loanamount1000 n), ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("% of loans") ///
ylabel(0(20)160) ymtick(0(10)170) ytitle("Loan amount (1,000 INR)") ///
title("Middle") legend(pos(6) cols(3)) name(c2, replace)

twoway ///
(line c3_2010_def_loanamount1000 n) ///
(line c3_2016_def_loanamount1000 n) ///
(line c3_2020_def_loanamount1000 n), ///
xlabel(0(20)100) xmtick(0(10)100) xtitle("% of loans") ///
ylabel(0(20)160) ymtick(0(10)170) ytitle("Loan amount (1,000 INR)") ///
title("Upper") legend(pos(6) cols(3)) name(c3, replace)

*grc1leg c1 c2 c3, name(comb, replace) cols(3)
*graph export "Distri_loans.svg", as(svg) name(comb)
set graph on

drop c1_2010_def_loanamount1000 c1_2016_def_loanamount1000 c1_2020_def_loanamount1000 c2_2010_def_loanamount1000 c2_2016_def_loanamount1000 c2_2020_def_loanamount1000 c3_2010_def_loanamount1000 c3_2016_def_loanamount1000 c3_2020_def_loanamount1000 n

*Duration
cls
tabstat loanduration if year==2010, stat(mean sd p50) by(loanreasongiven)
tabstat loanduration if year==2016, stat(mean sd p50) by(loanreasongiven)
tabstat loanduration if year==2020, stat(mean sd p50) by(loanreasongiven)

tabstat loanduration if year==2010, stat(mean sd p50) by(loanlender)
tabstat loanduration if year==2016, stat(mean sd p50) by(loanlender)
tabstat loanduration if year==2020, stat(mean sd p50) by(loanlender)

tabstat loanduration if year==2010, stat(mean sd p50) by(caste)
tabstat loanduration if year==2016, stat(mean sd p50) by(caste)
tabstat loanduration if year==2020, stat(mean sd p50) by(caste)




********** Lender caste and borrower caste
label values lenderscaste jatis
tab lenderscaste year, m
tab jatis caste, m
fre lenderscaste
rename lenderscaste lendersjatis
fre lendersjatis
gen lenderscaste=.
replace lenderscaste=1 if lendersjatis==2
replace lenderscaste=1 if lendersjatis==3

replace lenderscaste=2 if lendersjatis==1
replace lenderscaste=2 if lendersjatis==5
replace lenderscaste=2 if lendersjatis==7
replace lenderscaste=2 if lendersjatis==8
replace lenderscaste=2 if lendersjatis==10
replace lenderscaste=2 if lendersjatis==12
replace lenderscaste=2 if lendersjatis==15
replace lenderscaste=2 if lendersjatis==16

replace lenderscaste=3 if lendersjatis==4
replace lenderscaste=3 if lendersjatis==6
replace lenderscaste=3 if lendersjatis==9
replace lenderscaste=3 if lendersjatis==11
replace lenderscaste=3 if lendersjatis==13

replace lenderscaste=77 if lendersjatis==14
replace lenderscaste=77 if lendersjatis==17
replace lenderscaste=77 if lendersjatis==77

replace lenderscaste=88 if lendersjatis==88

label values lenderscaste caste
tab lenderscaste
tab lendersjatis
recode lendersjatis (66=.)
recode lendersjatis (99=.)
tab lendersjatis
tab lenderscaste


*Keep only informal loan
fre loanlender
preserve
drop if loanlender==8
drop if loanlender==10
drop if loanlender==11
drop if loanlender==12
drop if loanlender==13
drop if loanlender==14
tab loanlender year
cls
tab lenderscaste caste if year==2010, col nofreq
tab lenderscaste caste if year==2016, col nofreq
tab lenderscaste caste if year==2020, col nofreq
tab lenderscaste caste if year==2010, row nofreq
tab lenderscaste caste if year==2016, row nofreq
tab lenderscaste caste if year==2020, row nofreq
restore




********** Same as before but with amount of loans
cls
preserve
drop if loanlender==8
drop if loanlender==10
drop if loanlender==11
drop if loanlender==12
drop if loanlender==13
drop if loanlender==14

tabstat def_loanamount1000 if caste==1 & year==2010, stat(n sum) by(lenderscaste)
tabstat def_loanamount1000 if caste==2 & year==2010, stat(n sum) by(lenderscaste)	
tabstat def_loanamount1000 if caste==3 & year==2010, stat(n sum) by(lenderscaste)	
tabstat def_loanamount1000 if year==2010, stat(n sum) by(lenderscaste) 
	
tabstat def_loanamount1000 if caste==1 & year==2016, stat(n sum) by(lenderscaste)
tabstat def_loanamount1000 if caste==2 & year==2016, stat(n sum) by(lenderscaste)	
tabstat def_loanamount1000 if caste==3 & year==2016, stat(n sum) by(lenderscaste)	
tabstat def_loanamount1000 if year==2016, stat(n sum) by(lenderscaste) 

tabstat def_loanamount1000 if caste==1 & year==2020, stat(n sum) by(lenderscaste)
tabstat def_loanamount1000 if caste==2 & year==2020, stat(n sum) by(lenderscaste)	
tabstat def_loanamount1000 if caste==3 & year==2020, stat(n sum) by(lenderscaste)	
tabstat def_loanamount1000 if year==2020, stat(n sum) by(lenderscaste) 
restore
	
	
********** Interest
tab dummyinterest caste if year==2010, col nofreq
tab dummyinterest caste if year==2016, col nofreq
tab dummyinterest caste if year==2020, col nofreq


********** Lender services
tab otherlenderservices year
replace otherlenderservices="" if otherlenderservices=="99"
tab otherlenderservices2 year
replace otherlenderservices2=. if otherlenderservices2==99
tostring otherlenderservices2, replace
tab otherlenderservices2
replace otherlenderservices2="" if otherlenderservices2=="."
egen otherlenderservices_torep=concat(otherlenderservices otherlenderservices2) if year==2010, p(" ")
replace otherlenderservices=otherlenderservices_torep if year==2010
drop otherlenderservices2 otherlenderservices_torep

tab otherlenderservices
split otherlenderservices

gen services1=0
gen services2=0
gen services3=0
gen services4=0
gen services5=0
gen services77=0

forvalues i=1(1)5{
destring otherlenderservices`i', replace
}

forvalues i=1(1)5{
replace services1=1 if otherlenderservices`i'==1
replace services2=1 if otherlenderservices`i'==2
replace services3=1 if otherlenderservices`i'==3
replace services4=1 if otherlenderservices`i'==4
replace services5=1 if otherlenderservices`i'==5
replace services77=1 if otherlenderservices`i'==77
replace services`i'=. if mainloan==0
}

cls
foreach x in 1 2 3 4 5 77{
tab services`x' caste if year==2010, col nofreq
tab services`x' caste if year==2016, col nofreq
tab services`x' caste if year==2020, col nofreq
}
drop services1 services2 services3 services4 services5 services77 otherlenderservices1 otherlenderservices2 otherlenderservices3 otherlenderservices4 otherlenderservices5

********** Dummy problem to repay & dummy help to settle
tab dummyhelptosettleloan caste if year==2010, col nofreq
tab dummyhelptosettleloan caste if year==2016, col nofreq
tab dummyhelptosettleloan caste if year==2020, col nofreq

tab dummyproblemtorepay year
replace dummyproblemtorepay=1 if dummyproblemtorepay!=0 & dummyproblemtorepay!=. & dummyproblemtorepay!=9 & year==2010
replace dummyproblemtorepay=0 if dummyproblemtorepay==9 | dummyproblemtorepay==0

tab dummyproblemtorepay caste if year==2010, col nofreq
tab dummyproblemtorepay caste if year==2016, col nofreq
tab dummyproblemtorepay caste if year==2020, col nofreq


********** Services rendered by borrower
tab borrowerservices year
replace borrowerservices="" if borrowerservices=="." | borrowerservices=="99"
tab borrowerservices year
split borrowerservices
destring borrowerservices1 borrowerservices2 borrowerservices3, replace

gen services1=0
gen services2=0
gen services3=0
gen services4=0
gen services77=0

forvalues i=1(1)3{
replace services1=1 if borrowerservices`i'==1
replace services2=1 if borrowerservices`i'==2
replace services3=1 if borrowerservices`i'==3
replace services4=1 if borrowerservices`i'==4
replace services77=1 if borrowerservices`i'==77
}
foreach i in 1 2 3 4 77{
replace services`i'=. if mainloan==0
}
cls
foreach x in 1 2 3 4 77{
tab services`x' caste if year==2010, col nofreq
tab services`x' caste if year==2016, col nofreq
tab services`x' caste if year==2020, col nofreq
}
drop services1 services2 services3 services4 services77 borrowerservices1 borrowerservices2 borrowerservices3


********** Terms of repayment
tab termsofrepayment caste if year==2010, col nofreq
tab termsofrepayment caste if year==2016, col nofreq
tab termsofrepayment caste if year==2020, col nofreq




********** Guarantor & recommendation
cls
tab dummyguarantor caste if year==2010, col nofreq
tab dummyguarantor caste if year==2016, col nofreq
tab dummyguarantor caste if year==2020, col nofreq

tab dummyrecommendation caste if year==2010, col nofreq
tab dummyrecommendation caste if year==2016, col nofreq
tab dummyrecommendation caste if year==2020, col nofreq
****************************************
* END









****************************************
* STATS for loans and COVID
****************************************
cls
use"$directory\Data\NEEMSIS2-loans_v13_new.dta", clear
keep if loansettled==0

********** Date
tab loandate
gen lockdown_loan=1 if loandate<td(25mar2020)
replace lockdown_loan=2 if loandate>=td(25mar2020) & loandate<td(1jun2020)
replace lockdown_loan=3 if loandate>=td(1jun2020) & loandate<td(1sep2020)
replace lockdown_loan=4 if loandate>=td(1sep2020)

label define lock 1"Before lockdown" 2"During lockdown" 3"Lockdown + 3 months" 4"After lockdown", replace
label values lockdown_loan lock

tab lockdown_loan caste, col nofreq

********** COVID
tab caste
preserve
duplicates drop HHID_panel INDID, force
tab caste
duplicates drop HHID_panel, force
tab caste
restore

tab loan_database caste

tab dummyinterest caste

tab covfrequencyinterest caste, col nofreq
tab covamountinterest caste, col nofreq

tab covfrequencyrepayment caste, col nofreq
tab covrepaymentstop caste, col nofreq


****************************************
* END
