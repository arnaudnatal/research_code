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
* Wealth, income and debt
****************************************
*net install panelstat, from("https://github.com/pguimaraes99/panelstat/raw/master/")

cls
use"panel_v5", clear

keep if panel==1

panelstat panelvar time

panelstat panelvar time, quantr(DSR)

panelstat panelvar time, flows(DSR)

panelstat panelvar time, demoby(DSR)


****************************************
* END

















****************************************
* Cross section evidence
****************************************
cls
use"panel_v5", clear

keep if panel==1


********** Graphs
foreach y in caste assetsq {
foreach x in ihs_annualincome ihs_assets_noland ihs_loanamount ihs_DSR_1000 ihs_DIR_1000 ihs_DAR_without_1000 ihs_ISR_1000 cro_annualincome cro_assets_noland cro_loanamount cro_DSR cro_DAR_without cro_DIR cro_ISR log_annualincome log_assets_noland log_loanamount log_DSR log_DAR_without log_DIR log_ISR annualincome assets_noland loanamount DSR DAR_without DIR ISR sum_loans_HH {
set graph off
stripplot `x', over(`y') by(year, note("") row(1)) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks) ///
name(`x'_`y', replace)
set graph on
}
}



********** Combine
foreach x in annualincome assets_noland loanamount {
foreach y in ihs cro log {
set graph off
graph combine `y'_`x'_caste `y'_`x'_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(`y'_`x', replace)
set graph on
}
}


foreach x in DSR ISR DAR_without DIR{
set graph off
graph combine ihs_`x'_1000_caste ihs_`x'_1000_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(ihs_`x', replace)
graph combine cro_`x'_caste cro_`x'_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(cro_`x', replace)
graph combine ihs_`x'_1000_caste ihs_`x'_1000_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(ihs_`x', replace)
set graph on
}






********** Wealth, income and debt

graph display ihs_annualincome
graph display ihs_assets_noland
graph display ihs_loanamount





********** Burden of debt

graph display ihs_DSR
graph display ihs_DAR_without

graph display ihs_ISR
graph display ihs_DIR


****************************************
* END
















****************************************
* RELATIVE EVOLUTION OF USE AND SOURCE OF DEBT
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1



********* INCOME, WEALTH AND USING OF DEBT
graph drop _all
foreach ca in annualincome assets_noland loanamount {
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=`ca', n(3)

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
name(using`i'_`ca',replace)
restore
}
grc1leg using1_`ca' using2_`ca' using3_`ca', col(3) name(use_`ca', replace)
set graph on
}
graph dir
/*
graph display use_annualincome
graph display use_assets_noland
graph display use_loanamount
*/



********* INCOME, WEALTH AND SOURCE OF DEBT
graph drop _all
foreach ca in annualincome assets_noland loanamount {
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=`ca', n(3)

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
name(source`i'_`ca',replace)
restore
}
grc1leg source1_`ca' source2_`ca' source3_`ca', col(3) name(source_`ca', replace)
set graph on
}
graph dir
/*
grc1leg source_annualincome, col(3)
grc1leg source_assets_noland, col(3)
grc1leg source_loanamount, col(3)
*/
****************************************
* END





















****************************************
* DEBT TRAP
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1


tabstat dummyborrowstrat MLborrowstrat_nb_HH MLborrowstrat_amt_HH rel_MLborrowstrat_amt_HH loanforrepayment_nb_HH loanforrepayment_amt_HH rel_loanforrepayment_amt_HH, stat(n mean sd q) by(year)



********** Borrow elsewhere as strategy
***** Nb of HH concern
graph bar dummyborrowstrat, over(caste) by(year, col(3) note(""))



********** Debt to repay
***** Nb of HH concern
graph bar dummyrepay, over(caste) by(year,col(3)note(""))


***** Stat
tabstat rel_loanforrepayment_amt_HH if year==2010, stat(n mean sd q) by(caste)
tabstat rel_loanforrepayment_amt_HH if year==2016, stat(n mean sd q) by(caste)
tabstat rel_loanforrepayment_amt_HH if year==2020, stat(n mean sd q) by(caste)


****************************************
* END










****************************************
* OVERINDEBTEDNESS
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1

ta DSR30 caste if year==2010, col nofreq
ta DSR30 caste if year==2016, col nofreq
ta DSR30 caste if year==2020, col nofreq


********** Borrow elsewhere as strategy
***** Nb of HH concern
graph bar DSR30, over(caste) by(year, col(3) note(""))
graph bar DSR40, over(caste) by(year, col(3) note(""))
graph bar DSR50, over(caste) by(year, col(3) note(""))



********** Debt to repay
***** Nb of HH concern
graph bar dummyrepay, over(caste) by(year,col(3)note(""))


***** Stat
tabstat rel_loanforrepayment_amt_HH if year==2010, stat(n mean sd q) by(caste)
tabstat rel_loanforrepayment_amt_HH if year==2016, stat(n mean sd q) by(caste)
tabstat rel_loanforrepayment_amt_HH if year==2020, stat(n mean sd q) by(caste)


****************************************
* END












/*
****************************************
* ABSOLUT EVOLUTION
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1



********** INCOME, WEALTH AND DEBT AMOUNT
graph drop _all
foreach ca in annualincome assets_noland {
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=`ca', n(5)
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
(connected `x'_`ca' n) ///
, ///
title("t=`i'") ///
ylabel(#5) ymtick(#10) ///
leg(col(3) pos(6)) ///
name(`x'`i'_`ca', replace)
}
restore
}
grc1leg mean1_`ca' mean2_`ca' mean3_`ca', col(3) name(mean_`ca', replace)
grc1leg median1_`ca' median2_`ca' median3_`ca', col(3) name(median_`ca', replace)
set graph on
}
graph dir
/*
graph display mean_annualincome
graph display median_annualincome
graph display mean_assets_noland
graph display median_assets_noland
*/



********** INCOME, WEALTH AND DEBT/INTEREST SERVICE
graph drop _all
foreach ca in annualincome assets_noland {
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=`ca', n(5)
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
, ///
title("t=`i'") ///
ylabel() ymtick() ///
leg(col(3) pos(6)) ///
name(`x'`i'_`ca', replace)
}
restore
}
grc1leg mean1_`ca' mean2_`ca' mean3_`ca', col(3) name(mean_`ca', replace)
grc1leg median1_`ca' median2_`ca' median3_`ca', col(3) name(median_`ca', replace)
set graph on
}
graph dir
/*
graph display mean_annualincome
graph display median_annualincome
graph display mean_assets_noland
graph display median_assets_noland
*/



********** INCOME, WEALTH AND USING OF DEBT
graph drop _all
foreach ca in annualincome assets_noland {
*set trace on
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=`ca', n(5)
foreach x in annualincome assets_noland eco_HH current_HH humank_HH social_HH home_HH other_HH formal_HH informal_HH {
bysort cat_p: egen mean_`x'=mean(`x')
bysort cat_p: egen median_`x'=median(`x')
}
keep cat_p mean_annualincome median_annualincome mean_assets_noland median_assets_noland mean_formal_HH median_formal_HH mean_informal_HH median_informal_HH mean_eco_HH median_eco_HH mean_current_HH median_current_HH mean_humank_HH median_humank_HH mean_social_HH median_social_HH mean_home_HH median_home_HH mean_other_HH median_other_HH
foreach x in mean median {
label var `x'_annualincome "Income"
label var `x'_assets_noland "Assets"
label var `x'_formal_HH "Formal debt"
label var `x'_informal_HH "Informal debt"
label var `x'_eco_HH "Economic"
label var `x'_current_HH "Current exp"
label var `x'_humank_HH "Human capital"
label var `x'_social_HH "Social exp"
label var `x'_home_HH "Housing"
label var `x'_other_HH "Other exp"
}
duplicates drop
rename cat_p n
set graph off
foreach x in mean median {
twoway ///
(connected `x'_eco_HH n) ///
(connected `x'_current_HH n) ///
(connected `x'_humank_HH n) ///
(connected `x'_social_HH n) ///
(connected `x'_home_HH n) ///
(connected `x'_other_HH n) ///
, ///
title("t=`i'") ///
ylabel(#5) ymtick(#10) ///
leg(col(3) pos(6)) ///
name(`x'`i'_`ca', replace)
}
restore
}
foreach x in mean median {
grc1leg `x'1_`ca' `x'2_`ca' `x'3_`ca', col(3) title("`x'") name(`x'_`ca', replace)
}
set graph on
}
graph dir
/*
graph display mean_annualincome
graph display median_annualincome
graph display mean_assets_noland
graph display median_assets_noland
*/



********** INCOME, WEALTH AND SOURCE OF DEBT
graph drop _all
foreach ca in annualincome assets_noland {
*set trace on
forvalues i=1(1)3{
preserve
keep if time==`i'
xtile cat_p=`ca', n(5)
foreach x in annualincome assets_noland eco_HH current_HH humank_HH social_HH home_HH other_HH formal_HH informal_HH {
bysort cat_p: egen mean_`x'=mean(`x')
bysort cat_p: egen median_`x'=median(`x')
}
keep cat_p mean_annualincome median_annualincome mean_assets_noland median_assets_noland mean_formal_HH median_formal_HH mean_informal_HH median_informal_HH mean_eco_HH median_eco_HH mean_current_HH median_current_HH mean_humank_HH median_humank_HH mean_social_HH median_social_HH mean_home_HH median_home_HH mean_other_HH median_other_HH
foreach x in mean median {
label var `x'_annualincome "Income"
label var `x'_assets_noland "Assets"
label var `x'_formal_HH "Formal debt"
label var `x'_informal_HH "Informal debt"
label var `x'_eco_HH "Economic"
label var `x'_current_HH "Current exp"
label var `x'_humank_HH "Human capital"
label var `x'_social_HH "Social exp"
label var `x'_home_HH "Housing"
label var `x'_other_HH "Other exp"
}
duplicates drop
rename cat_p n
set graph off
foreach x in mean median {
twoway ///
(connected `x'_formal_HH n) ///
(connected `x'_informal_HH n) ///
, ///
title("t=`i'") ///
ylabel(#5) ymtick(#10) ///
leg(col(3) pos(6)) ///
name(`x'`i'_`ca', replace)
}
restore
}
foreach x in mean median {
grc1leg `x'1_`ca' `x'2_`ca' `x'3_`ca', col(3) title("`x'") name(`x'_`ca', replace)
}
set graph on
}
graph dir
/*
graph display mean_annualincome
graph display median_annualincome
graph display mean_assets_noland
graph display median_assets_noland
*/
****************************************
* END
