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
********** Path to folder "data" folder.
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

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










****************************************
* How assets evo?
****************************************
use"panel_v4", clear

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



********** Graph
/*
foreach y in mean median {
set graph off
preserve
collapse (`y') $toana, by(caste year)
foreach x in $toana {
twoway ///
(line `x' year if caste==1) ///
(line `x' year if caste==2) ///
(line `x' year if caste==3) ///
, ///
ytitle("`x'") xtitle("Year") ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") col(3)) ///
name(`x', replace)
}
grc1leg $toana, name(comb_`y', replace) title("`y'") col(3)
graph export "graph/line_desc_`y'.pdf", replace
restore
set graph on
}
*/

****************************************
* END













****************************************
* Reshape for strange evolution
****************************************
use"panel_v4", clear

********** Initialization
xtset time panelvar

ta housevalue

global var assets assets_noland livestock housevalue goldquantityamount goodtotalamount amountownland goldquantity loanamount loans


*** Select+reshape
keep HHID_panel year caste panel $var houseroom housetitle housetype
reshape wide $var houseroom housetitle housetype, i(HHID_panel) j(year)

tab1 livestock2010 livestock2016 livestock2020

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

foreach x in housetype2010 houseroom2010 housetitle2010 goldquantity2010 assets2010 assets_noland2010 livestock2010 housevalue2010 goldquantityamount2010 goodtotalamount2010 amountownland2010 housetype2016 houseroom2016 housetitle2016 goldquantity2016 assets2016 assets_noland2016 livestock2016 housevalue2016 goldquantityamount2016 goodtotalamount2016 amountownland2016 housetype2020 houseroom2020 housetitle2020 goldquantity2020 assets2020 assets_noland2020 livestock2020 housevalue2020 goldquantityamount2020 goodtotalamount2020 amountownland2020 loanamount2010 loanamount2016 loanamount2020 {
recode `x' (.=0)
}

*** Evol
foreach x in $var {
gen b1_`x'=`x'2016-`x'2010
gen b2_`x'=`x'2020-`x'2016
}


*** Graph
/*
foreach cat in caste {
foreach x in $var {
forvalues i=1(1)3 {
set graph off

twoway ///
(scatter b2_`x' b1_`x' if `cat'==`i', xline(0) yline(0) msymbol(oh) msize(medsmall)) ///
(function y=-x if `cat'==`i', range(b1_`x')) ///
, ///
xlabel(#5) ylabel(#5) ///
xmtick(#10) ymtick(#10) ///
xtitle("β1=2016-2010") ytitle("β2=2020-2016") ///
title("`cat' `i'") ///
legend(pos(6) col(2) order(2 "Second bisector")) name(`x'_`i', replace)
}
grc1leg `x'_1 `x'_2 `x'_3, col(3) title("`x'") name(comb_`x', replace)
graph export "graph/comb`cat'_`x'.pdf", replace
set graph on
}
}
*/



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
