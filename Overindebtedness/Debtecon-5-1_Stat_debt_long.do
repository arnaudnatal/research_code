cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
December 07, 2021
-----
Stat for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"

* Scheme
*net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
*set scheme plotplain
set scheme white_tableau
*set scheme plotplain
grstyle init
grstyle set plain, nogrid

*set scheme black_tableau
*set scheme swift_red


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
* Stat debt evo with long data
****************************************
use"panel_v4", clear

********** Initialization
xtset panelvar time
keep if panel==1



********** Pctile
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)
foreach x in loanamount annualincome assets_noland formal_HH informal_HH {
bysort cat_p: egen mean_`x'=mean(`x')
bysort cat_p: egen median_`x'=median(`x')
}
keep cat_p mean_loanamount median_loanamount mean_annualincome median_annualincome mean_assets_noland median_assets_noland mean_formal_HH median_formal_HH mean_informal_HH median_informal_HH
duplicates drop
rename cat_p n
set graph off
foreach x in mean median {
twoway ///
(connected `x'_loanamount n) ///
(connected `x'_annualincome n) ///
(connected `x'_assets_noland n) ///
, ///
title("t=`i'") ///
ylabel(0(100)600) ymtick(0(50)650) ///
leg(col(3) pos(6)) ///
name(`x'`i', replace)
}
set graph on
restore
}

grc1leg mean1 mean2 mean3, col(3) name(mean, replace)
grc1leg median1 median2 median3, col(3) name(median, replace)





********** DSR, ISR
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)
foreach x in DSR ISR DAR_without {
bysort cat_p: egen mean_`x'=mean(`x')
bysort cat_p: egen median_`x'=median(`x')
}
keep cat_p mean_DSR median_DSR mean_ISR median_ISR mean_DAR_without median_DAR_without
duplicates drop
rename cat_p n
set graph off
foreach x in mean median {
twoway ///
(connected `x'_DSR n) ///
(connected `x'_ISR n) ///
(connected `x'_DAR_without n) ///
, ///
title("t=`i'") ///
ylabel() ymtick() ///
leg(col(3) pos(6)) ///
name(`x'`i', replace)
}
set graph on
restore
}
grc1leg mean1 mean2 mean3, col(3) name(mean, replace)




********* Using mean according to distribution of debt and income
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)

collapse (mean) rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH, by(cat_p)

rename rel_eco_HH sum1
rename rel_current_HH up2
rename rel_humank_HH up3
rename rel_social_HH up4
rename rel_home_HH up5
rename rel_other_HH up6

gen sum2=sum1+up2
gen sum3=sum2+up3
gen sum4=sum3+up4
gen sum5=sum4+up5
gen sum6=sum5+up6

keep cat_p sum*

set graph off
twoway ///
area sum1 cat_p || ///
rarea sum1 sum2 cat_p || ///
rarea sum2 sum3 cat_p || ///
rarea sum3 sum4 cat_p || ///
rarea sum4 sum5 cat_p || ///
rarea sum5 sum6 cat_p ///
, ///
legend(pos(6) col(3) order(1 "Economic purpose" 2 "Current expenses" 3 "Human capital" 4 "Social purpose" 5 "Housing" 6 "Other")) ///
title("t=`i'") ///
name(using`i',replace)
set graph on
restore
}

grc1leg using1 using2 using3, col(3)





********* Source mean according to distribution of debt and income
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=annualincome, n(5)

collapse (mean) rel_formal_HH rel_informal_HH, by(cat_p)

rename rel_formal_HH sum1
rename rel_informal_HH up2

gen sum2=sum1+up2

keep cat_p sum*

set graph off
twoway ///
area sum1 cat_p || ///
rarea sum1 sum2 cat_p || ///
, ///
legend(pos(6) col(3) order(1 "Formal" 2 "Informal")) ///
title("t=`i'") ///
name(source`i',replace)
set graph on
restore
}

grc1leg source1 source2 source3, col(3)

****************************************
* END












/*

********** Line
*** Debt, income and assets
preserve
set graph off
collapse (mean) annualincome loanamount assets_noland, by(caste year)
forvalues i=1(1)3 {
twoway ///
(line loanamount year if caste==`i') ///
(line annualincome year if caste==`i') ///
(line assets_noland year if caste==`i') ///
, ///
ytitle("`x'") xtitle("Year") ///
ylabel(0(100)500) ytick(0(50)500) ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order() col(3) pos(6)) ///
name(caste`i', replace)
}
set graph on
restore

grc1leg caste1 caste2 caste3, col(3)

*** Income, interest and repayment
preserve
collapse (mean) DSR ISR annualincome rel_formal_HH rel_informal_HH, by(caste year)

forvalues i=1(1)3 {
set graph off
twoway ///
(line annualincome year if caste==`i') ///
(line DSR year if caste==`i') ///
(line ISR year if caste==`i') ///
(line rel_formal_HH year if caste==`i') ///
(line rel_informal_HH year if caste==`i') ///
, ///
ytitle("`x'") xtitle("Year") ///
ylabel(0(20)160) ytick(0(10)160) ///
xlabel(2010 2016 2020, ang(45)) ///
legend(order() col(3) pos(6)) ///
name(caste`i', replace)
}
set graph on
restore

grc1leg caste1 caste2 caste3, col(3)


********** Kernel
foreach y in 2010 2016 2020 {
foreach x in DIR DAR_with DSR ISR {
qui sum `x'_r, det
local maxv=r(max)
set graph off
twoway ///
(kdensity `x'_r if caste==1 & year==`y', bwidth(.5)) ///
(kdensity `x'_r if caste==2 & year==`y', bwidth(.5)) ///
(kdensity `x'_r if caste==3 & year==`y', bwidth(.5)) ///
, ///
xlabel(0(1)`maxv') ///
legend(order(1 "Dalits" 2 "Middle" 3 "Upper") col(3)) ///
name(`x'_`y', replace)
set graph on
}
}


********** Boxplot
foreach x in DSR_r ISR_r {
stripplot `x', over(time) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2009-10" 2 "2016-17" 3 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel(0(100)600) ymtick(0(50)600) ytitle("`x'") ///
legend(order(1 "Mean" 5 "Individual") off) name(box_`x', replace)
}



********** Violin plot
vioplot annualincome, over(year)
