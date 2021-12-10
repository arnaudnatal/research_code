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
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"

global loan1 "RUME-loans_v8"
global loan2 "NEEMSIS1-loans_v4"
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
use"panel_v3", clear

xtset time panelvar


rename assets1000 assets
rename assets_noland1000 assetsnl
rename amountownland1000 amountownland
rename livestock1000 livestock
rename housevalue1000 housevalue
rename goldquantityamount1000 goldquantityamount
rename goodtotalamount1000 goodtotalamount

rename loanamount_HH1000 loanamount
rename loanamount_g_HH1000 loanamount_g
rename loanamount_gm_HH1000 loanamount_gm
rename loans_HH loans

**********Deflate: all in 2010 value 
***https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
foreach x in assets assetsnl amountownland livestock housevalue goldquantityamount goodtotalamount loanamount loanamount_g loanamount_gm {
clonevar `x'_raw=`x'
replace `x'=`x'*(100/158) if year==2016 & `x'!=.
replace `x'=`x'*(100/184) if year==2020 & `x'!=.
}


global toana assets assetsnl amountownland livestock housevalue goldquantityamount goodtotalamount loanamount loans


tabstat $toana, stat(n mean sd p50) by(year)

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


*** Macro
global var $toana houseroom housetitle housetype goldquantity

*** Select+reshape
keep HHID_panel year caste $var
reshape wide $var, i(HHID_panel) j(year)

*** Evol
foreach x in $var {
gen b1_`x'=`x'2016-`x'2010
gen b2_`x'=`x'2020-`x'2016
}





********** Desc var
order b1_assetsnl b2_assetsnl housevalue* houseroom* goldquantityamount* goldquantity* HHID_panel caste
sort b2_assetsnl

* Bell for house value
gen pb1=0
replace pb1=1 if (housevalue2016>3*housevalue2010 & housevalue2016>2*housevalue2020)

* Bell for gold
gen pb2=0
replace pb2=1 if (goldquantity2016>3*goldquantity2010 & goldquantity2016>1.5*goldquantity2020)

* Gold to high (higher than 500 grams)
gen pb3=0
replace pb3=1 if goldquantity2010>500 | goldquantity2016>500 | goldquantity2020>500


order b1_assetsnl b2_assetsnl pb1 housevalue* houseroom* goldquantityamount* pb2 pb3 goldquantity* HHID_panel caste
sort b2_assetsnl

sort pb2 goldquantity2016



********** Loanamount
order b1_loanamount b2_loanamount loanamount2010 loanamount2016 loanamount2020 b1_loans b2_loans loans2010 loans2016 loans2020 HHID_panel caste
sort b2_loanamount

*












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
