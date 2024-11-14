*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* INCOME - Social mobility
****************************************
use"panel_v4", clear

keep HHID_panel year monthlyincome_pc caste
rename monthlyincome_pc income
reshape wide income, i(HHID_panel) j(year)

foreach x in 2010 2016 2020 {
xtile quint`x'=income`x', n(5)
}

* Diff quintile for stat
gen diffq1=quint2016-quint2010
gen absdiffq1=abs(diffq1)
gen catdiffq1=.
label define catdiffq1 1"Downward" 2"Immobility" 3"Upward"
label values catdiffq1 catdiffq1
replace catdiffq1=1 if diffq1<0 & diffq1!=.
replace catdiffq1=2 if diffq1==0 & diffq1!=.
replace catdiffq1=3 if diffq1>0 & diffq1!=.

gen diffq2=quint2020-quint2016
gen absdiffq2=abs(diffq2)
gen catdiffq2=.
label define catdiffq2 1"Downward" 2"Immobility" 3"Upward"
label values catdiffq2 catdiffq2
replace catdiffq2=1 if diffq2<0 & diffq2!=.
replace catdiffq2=2 if diffq2==0 & diffq2!=.
replace catdiffq2=3 if diffq2>0 & diffq2!=.


* Transition matrix
ta quint2010 quint2016, row nofreq chi2
ta quint2016 quint2020, row nofreq chi2

* Immobility and upward and downward mobility
ta catdiffq1
ta catdiffq2

ta catdiffq1 catdiffq2, row nofreq
ta catdiffq1 catdiffq2, chi2 exp cchi2

tabstat absdiffq1 if catdiffq1!=2, stat(n mean) by(catdiffq1)
tabstat absdiffq2 if catdiffq2!=2, stat(n mean) by(catdiffq2)

****************************************
* END












****************************************
* WEALTH - Social mobility
****************************************
use"panel_v4", clear

keep HHID_panel year assets_total caste
rename assets_total assets
reshape wide assets, i(HHID_panel) j(year)

foreach x in 2010 2016 2020 {
xtile quint`x'=assets`x', n(5)
}

* Diff quintile for stat
gen diffq1=quint2016-quint2010
gen absdiffq1=abs(diffq1)
gen catdiffq1=.
label define catdiffq1 1"Downward" 2"Immobility" 3"Upward"
label values catdiffq1 catdiffq1
replace catdiffq1=1 if diffq1<0 & diffq1!=.
replace catdiffq1=2 if diffq1==0 & diffq1!=.
replace catdiffq1=3 if diffq1>0 & diffq1!=.

gen diffq2=quint2020-quint2016
gen absdiffq2=abs(diffq2)
gen catdiffq2=.
label define catdiffq2 1"Downward" 2"Immobility" 3"Upward"
label values catdiffq2 catdiffq2
replace catdiffq2=1 if diffq2<0 & diffq2!=.
replace catdiffq2=2 if diffq2==0 & diffq2!=.
replace catdiffq2=3 if diffq2>0 & diffq2!=.


* Transition matrix
ta quint2010 quint2016, row nofreq chi2
ta quint2016 quint2020, row nofreq chi2

* Immobility and upward and downward mobility
ta catdiffq1
ta catdiffq2

ta catdiffq1 catdiffq2, row nofreq
ta catdiffq1 catdiffq2, chi2 exp cchi2

tabstat absdiffq1 if catdiffq1!=2, stat(n mean) by(catdiffq1)
tabstat absdiffq2 if catdiffq2!=2, stat(n mean) by(catdiffq2)

****************************************
* END





















****************************************
* Cowell and Flachaire (2018, QE)
****************************************

********** Income

* 2010 - 2016-17
use"panel_v4", clear
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc3
drop if inc1==.
drop if inc2==.
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\panelHHincome1.txt", delimiter(tab) replace


* 2016-17 - 2020-21
use"panel_v4", clear
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc1
drop if inc2==.
drop if inc3==.
rename inc2 inc1
rename inc3 inc2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\panelHHincome2.txt", delimiter(tab) replace



********** Assets

* 2010 - 2016-17
use"panel_v4", clear
keep HHID_panel year assets_total
rename assets_total ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass3
drop if ass1==.
drop if ass2==.
drop if ass1==0
drop if ass2==0
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\assetsinequalities\panelHHassets1.txt", delimiter(tab) replace


* 2016-17 - 2020-21
use"panel_v4", clear
keep HHID_panel year assets_total
rename assets_total ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass1
drop if ass2==.
drop if ass3==.
rename ass2 ass1
rename ass3 ass2
drop if ass1==0
drop if ass2==0
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\assetsinequalities\panelHHassets2.txt", delimiter(tab) replace

****************************************
* END









****************************************
* Graph rank CF
****************************************

********** Graph rank
import excel "CowellFlachaire2018QE.xlsx", sheet("rank") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2

*** Overall
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Rank mobility") ///
ytitle("") ylabel() ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(rank, replace)





********** Graph income
import excel "CowellFlachaire2018QE.xlsx", sheet("inc") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2

*** Overall
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Income mobility") ///
ytitle("") ylabel() ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(inco, replace)



********** Combine
grc1leg rank inco, name(comb, replace)
graph export "CFgraph.png", as(png) replace

****************************************
* END











****************************************
* WEALTH - Cowell and Flachaire (2018, QE)
****************************************



********** Graph rank
import excel "CowellFlachaire2018QE.xlsx", sheet("rank") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2

*** Overall
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Rank mobility") ///
ytitle("") ylabel() ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(rank, replace)






********** Graph assets
import excel "CowellFlachaire2018QE.xlsx", sheet("ass") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2

*** Overall
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Wealth mobility") ///
ytitle("") ylabel() ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(inco, replace)



********** Combine
grc1leg rank inco, name(comb, replace)
graph export "CFgraph.png", as(png) replace

****************************************
* END





