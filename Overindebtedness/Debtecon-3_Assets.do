cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
September 30, 2021
-----
Panel for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all


global user "anatal"
global folder "Downloads"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END












/*
****************************************
* Assets index
****************************************
use"panel_v3", clear

ta panel
keep if panel==1

xtset panelvar year

/*
recode sizeownland (.=0)

qui reg expPLU c.sizeownland##c.assets_noland##i.head_edulevel##i.wifehusb_edulevel if year==2010
dis e(N)
dis e(r2)
dis e(r2_a)
predict lwai2010, xb

qui reg expPLU c.sizeownland##c.assets_noland##i.head_edulevel##i.wifehusb_edulevel if year==2016
dis e(N)
dis e(r2)
dis e(r2_a)
predict lwai2016, xb

qui reg expPLU c.sizeownland##c.assets_noland##i.head_edulevel##i.wifehusb_edulevel if year==2020
dis e(N)
dis e(r2)
dis e(r2_a)
predict lwai2020, xb

gen lwai=.
replace lwai=lwai2010 if year==2010
replace lwai=lwai2016 if year==2016
replace lwai=lwai2020 if year==2020

tabstat lwai, stat(n mean sd p50) by(year)

tabstat lwai assets assets_noland, stat(n mean sd p50) by(year)
*/



********** Trends
/*
sort panelvar year

foreach x in assets_noland {

gen d1_`x'=`x'-L6.`x' if year==2016
gen d2_`x'=`x'-L4.`x' if year==2020

forvalues i=1(1)2 {
bysort HHID_panel: egen max_d`i'_`x'=max(d`i'_`x')
drop d`i'_`x'
rename max_d`i'_`x' d`i'_`x'
egen p25_d`i'_`x'=pctile(d`i'_`x'), p(25)
egen p50_d`i'_`x'=pctile(d`i'_`x'), p(50)
egen p75_d`i'_`x'=pctile(d`i'_`x'), p(75)
egen mean_d`i'_`x'=mean(d`i'_`x')
}

foreach y in p25 p50 p75 mean {
gen `y'_d_`x'=.
replace `y'_d_`x'=100 if year==2010
replace `y'_d_`x'=100+`y'_d1_`x' if year==2016
replace `y'_d_`x'=100+`y'_d2_`x' if year==2020
}

}


keep year p25_d_assets_noland p50_d_assets_noland p75_d_assets_noland mean_d_assets_noland
duplicates drop

twoway (line p50_d_assets_noland year)
*/




********** Double diff
sort panelvar year

foreach x in assets_noland {

gen diff_`x'=.
replace diff_`x'=`x'-L6.`x' if year==2016
replace diff_`x'=`x'-L4.`x' if year==2020

}

********** Reshape
keep panelvar year caste assets_noland diff_assets_noland
reshape wide diff_assets_noland assets_noland, i(panelvar) j(year)


********** Graph rpz
/*
foreach x in assets_noland {
gen td_`x'=0
forvalues i=2016(4)2020 {
qui sum diff_`x'`i', det
replace td_`x'=1 if diff_`x'`i'<r(p1)
replace td_`x'=1 if diff_`x'`i'>r(p99)
}

qui sum diff_`x'2016, det
gen range_`x'=diff_`x'2016
replace range_`x'=r(p5) if range_`x'<r(p1)
replace range_`x'=r(p95) if range_`x'>r(p99)
}


foreach x in assets_noland {
twoway (scatter diff_`x'2020 diff_`x'2016) (function y=-x, range(range_`x')), yline(0) xline(0) xtitle("2016-2010") ytitle("2020-2016")

preserve
drop if td_`x'==1
twoway (scatter diff_`x'2020 diff_`x'2016 if caste==1, msymbol(oh)) (scatter diff_`x'2020 diff_`x'2016 if caste==2, msymbol(oh)) (scatter diff_`x'2020 diff_`x'2016 if caste==3, msymbol(oh)) (function y=-x, range(range_`x')), yline(0) xline(0) xtitle("2016-2010") ytitle("2020-2016")
restore
}
*/




********** Table rpz

label define path 1"Inc-Inc - Increasing" 2"Inc-Dec - Increasing" 3"Dec-Inc - Increasing" 4"Inc-Dec - Decreasing" 5"Dec-Inc - Decreasing" 6"Dec-Dec - Decreasing", replace 
foreach x in assets_noland {
gen path_`x'=.
replace path_`x'=1 if diff_`x'2016>=0 & diff_`x'2020>=0
replace path_`x'=2 if diff_`x'2016>=0 & diff_`x'2020<0 & diff_`x'2016+diff_`x'2020>=0
replace path_`x'=3 if diff_`x'2016<0 & diff_`x'2020>=0 & diff_`x'2016+diff_`x'2020>=0
replace path_`x'=4 if diff_`x'2016>=0 & diff_`x'2020<0 & diff_`x'2016+diff_`x'2020<0
replace path_`x'=5 if diff_`x'2016<0 & diff_`x'2020>=0 & diff_`x'2016+diff_`x'2020<0
replace path_`x'=6 if diff_`x'2016<0 & diff_`x'2020<0
label values path_`x' path
}

***** Qtile
xtile assets2010_q=assets_noland2010, n(3)
bysort panelvar: egen max_assets2010_q=max(assets2010_q)
drop assets2010_q
rename max_assets2010_q assets2010_q

***** Cross table
ta path_assets_noland caste, nofreq col
ta path_assets_noland assets2010_q, nofreq col



****************************************
* END
*/













****************************************
* How assets evo?
****************************************
use"panel_v3", clear

*** Initialization
xtset time panelvar

global assetsanalysis assets assets_noland livestock housevalue goldquantityamount goodtotalamount amountownland

foreach x in $assetsanalysis {
recode `x' (0=.)
}

********** Not balanced
cls
ta caste year
*** Evo amt
tabstat $assetsanalysis, stat(mean sd p50) by(year)
*** Over caste
forvalues i=1(1)3{
tabstat $assetsanalysis if caste==`i', stat(mean sd p50) by(year)
}


********** Balanced
cls
keep if panel==1
ta caste year
*** Evo amt
tabstat $assetsanalysis, stat(mean sd p50) by(year)
*** Over caste
forvalues i=1(1)3{
tabstat $assetsanalysis if caste==`i', stat(mean sd p50) by(year)
}

****************************************
* END













****************************************
* Reshape for strange evolution
****************************************
use"panel_v3", clear

********** Initialization
xtset time panelvar

global var ///
assets assets_noland ///
livestock ///
houseroom housevalue ///
goodtotalamount ///
amountownland sizeownland ///
goldquantity goldquantityamount

*** Select+reshape
keep HHID_panel panelvar year caste panel $var housetitle housetype loanamount annualincome
reshape wide $var caste housetitle housetype loanamount annualincome, i(panelvar) j(year)

gen caste=.
replace caste=caste2010 if caste==.
replace caste=caste2016 if caste==.
replace caste=caste2020 if caste==.

********** Graph1
/*
foreach y in assets assets_noland livestock housevalue goldquantityamount goodtotalamount amountownland {
set graph off
forvalues i=1(1)3 {

foreach j in 10 16 20 {
qui sum `y'20`j' if caste==`i', det
local med`j'=round(r(p50),1)
local n`j'=r(N)
}

stripplot `y'2010 `y'2016 `y'2020 if caste==`i', over() separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("Caste `i'") xlabel(1"2010" 2"2016-17" 3"2020-21",angle(45))  ///
ylabel(#10) ymtick(#20) ytitle("`y'") ///
msymbol(oh) mcolor(ply`i') ///
note("N--Median" "2010: `n10'--`med10'" "2016: `n16'--`med16'" "2020: `n20'--`med20'", size(small)) ///
legend(off) ///
name(`y'`i', replace) 
}
graph combine `y'1 `y'2 `y'3, title("`y'") col(3) name(`y'_comb, replace)
graph export "graph/evo_`y'.pdf", replace
set graph on
}
*/


********** Observe strange households
keep if panel==1

foreach x in caste2010 sizeownland2010 housetype2010 houseroom2010 housetitle2010 goldquantity2010 amountownland2010 assets2010 assets_noland2010 livestock2010 housevalue2010 goldquantityamount2010 goodtotalamount2010 caste2016 sizeownland2016 housetype2016 houseroom2016 housetitle2016 goldquantity2016 amountownland2016 assets2016 assets_noland2016 livestock2016 housevalue2016 goldquantityamount2016 goodtotalamount2016 caste2020 sizeownland2020 housetype2020 houseroom2020 housetitle2020 goldquantity2020 amountownland2020 assets2020 assets_noland2020 livestock2020 housevalue2020 goldquantityamount2020 goodtotalamount2020 {
recode `x' (.=0)
}


tabstat assets2010 assets2016 assets2020 assets_noland2010 assets_noland2016 assets_noland2020 annualincome2010 annualincome2016 annualincome2020 loanamount2010 loanamount2016 loanamount2020, stat(n mean sd q)

*** Evol
foreach x in $var {
gen b1_`x'=`x'2016-`x'2010
gen b2_`x'=`x'2020-`x'2016
}



*** Graph
foreach x in $var {
*set graph off
twoway ///
(scatter b2_`x' b1_`x', xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x, range(b1_`x')) ///
, ///
xlabel(#5) ylabel(#5) ///
xmtick(#10) ymtick(#10) ///
xtitle("β1=2016-2010") ytitle("β2=2020-2016") ///
title("`x'") ///
legend(pos(6) col(2) order(2 "Second bisector")) name(`x'_`i', replace)
}



*** Desc var
order b1_assets_noland b2_assets_noland housevalue* houseroom* goldquantityamount* goldquantity* HHID_panel caste
sort b2_assets_noland

* Bell for house value
gen pb1=0
replace pb1=1 if (housevalue2016>3*housevalue2010 & housevalue2016>2*housevalue2020)

* Bell for gold
gen pb2=0
replace pb2=1 if (goldquantity2016>3*goldquantity2010 & goldquantity2016>1.5*goldquantity2020)

* Gold to high (higher than 500 grams)
gen pb3=0
replace pb3=1 if goldquantity2010>500 | goldquantity2016>500 | goldquantity2020>500


order b1_assets_noland b2_assets_noland pb1 housevalue* houseroom* goldquantityamount* pb2 pb3 goldquantity* HHID_panel caste
sort b2_assets_noland

sort pb2 goldquantity2016



*** Loanamount
order b1_loanamount b2_loanamount loanamount2010 loanamount2016 loanamount2020 b1_loans b2_loans loans2010 loans2016 loans2020 HHID_panel caste
sort b2_loanamount
*/
*

****************************************
* END














/*
****************************************
* Change
****************************************
use"panel_v3", clear


********** To change
gen pb2=0
foreach x in KAR27	ORA23	GOV22	ORA14	ORA9	MANAM4	GOV23	KAR3	MAN28	KUV52	GOV11	GOV14	GOV44	ELA39	SEM17	NAT28	MANAM32	ORA1	SEM52	KUV37	KUV34	SEM8	KUV40	MAN22	ELA21	ELA19	NAT6	MANAM22	KUV12	MANAM39	GOV48	GOV6	MANAM48	ELA30	NAT50 {
replace pb2=1 if HHID_panel=="`x'" & year==2016
}
foreach x in ORA23	MAN19	GOV42	KOR24	GOV18	SEM32	KOR9	MAN41	NAT9	KUV6	KOR33 {
replace pb2=2 if HHID_panel=="`x'" & year==2016
}
ta pb2



********** Replace house value
clonevar housevalue_new=housevalue
replace housevalue_new=housevalue/10 if pb2==1
order HHID_panel year housevalue housevalue_new pb2
sort pb2 HHID_panel year




********** Replace gold
clonevar goldquantityamount_new=goldquantityamount
replace goldquantityamount_new=goldquantityamount/10 if pb2==2
replace goldquantityamount_new=goldquantityamount/10 if goldquantity>1000
order HHID_panel year goldquantityamount goldquantityamount_new pb2
sort pb2 HHID_panel year

****************************************
* END
