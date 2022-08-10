*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 07, 2021
*-----
gl link = "evodebt"
*Long database stat desc
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------










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
foreach x in ihs_annualincome ihs_assets_noland ihs_loanamount ihs_DSR_1000 ihs_DIR_1000 ihs_DAR_without_1000 ihs_ISR_1000 cro_annualincome cro_assets_noland cro_loanamount cro_DSR cro_DAR_without cro_DIR cro_ISR log_annualincome log_assets_noland log_loanamount log_DSR log_DAR_without log_DIR log_ISR annualincome assets_noland loanamount DSR DAR_without DIR ISR sum_loans_HH annualincome_std assets_noland_std loanamount_std DSR_std DAR_without_std DIR_std ISR_std {
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
***** Wealth
foreach x in annualincome assets_noland loanamount {
set graph off
foreach y in ihs cro log {
graph combine `y'_`x'_caste `y'_`x'_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(`y'_`x', replace)
}
graph combine `x'_std_caste `x'_std_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(std_`x', replace)
set graph on
}


***** Burden
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
graph combine `x'_std_caste `x'_std_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(std_`x', replace)
set graph on
}

***** Multiple
set graph off
graph combine sum_loans_HH_caste sum_loans_HH_assetsq, ///
graphregion(margin(zero)) plotregion(margin(zero)) ///
col(1) name(sums, replace)
set graph on




********** Display
***** Wealth
graph display ihs_annualincome
graph display ihs_assets_noland
graph display ihs_loanamount

graph display cro_annualincome
graph display cro_assets_noland
graph display cro_loanamount

graph display std_annualincome
graph display std_assets_noland
graph display std_loanamount

preserve 
keep if year==2010
order HHID_panel assets_noland ihs_assets_noland cro_assets_noland log_assets_noland assets_noland_std
sort assets_noland
restore


***** Burden
graph display ihs_DSR
graph display ihs_DAR_without

graph display ihs_ISR
graph display ihs_DIR

***** Multiple borrowing
graph display sums

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
foreach ca in assetsq caste {
forvalues i=1(1)3{
preserve
keep if time==`i'
rename `ca' cat_p

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
xlabel(1(1)3) xmtick() ///
name(using`i'_`ca',replace)
restore
}
grc1leg using1_`ca' using2_`ca' using3_`ca', col(3) name(use_`ca', replace)
set graph on
}
graph dir


********* INCOME, WEALTH AND SOURCE OF DEBT
foreach ca in assetsq caste {
forvalues i=1(1)3{
preserve
keep if time==`i'
rename `ca' cat_p
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




********** Combine
grc1leg use_caste use_assetsq, col(1) name(use, replace)
grc1leg source_caste source_assetsq, col(1) name(source, replace)



********** Display
graph display use
graph display source


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
set graph off
graph bar dummyborrowstrat, over(caste) by(year, col(3) note("")) name(borrow_caste, replace)
graph bar dummyborrowstrat, over(assetsq) by(year, col(3) note("")) name(borrow_assets, replace)

graph combine borrow_caste borrow_assets, name(borrow, replace) col(1)
set graph on


********** Debt to repay
set graph off
graph bar dummyrepay, over(caste) by(year, col(3) note("")) name(repay_caste, replace)
graph bar dummyrepay, over(assetsq) by(year, col(3) note("")) name(repay_assets, replace)

graph combine repay_caste repay_assets, name(repay, replace) col(1)
set graph on


********** Display graph
graph display borrow
graph display repay


****************************************
* END










****************************************
* OVERINDEBTEDNESS
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1

********** DSR at 30%
set graph off
graph bar DSR30, over(caste) by(year, col(3) note("")) name(D30_caste, replace)
graph bar DSR30, over(assetsq) by(year, col(3) note("")) name(D30_assets, replace)

graph combine D30_caste D30_assets, name(D30, replace) col(1)
set graph on


********** DSR at 40%
set graph off
graph bar DSR40, over(caste) by(year, col(3) note("")) name(D40_caste, replace)
graph bar DSR40, over(assetsq) by(year, col(3) note("")) name(D40_assets, replace)

graph combine D40_caste D40_assets, name(D40, replace) col(1)
set graph on


********** DSR at 50%
set graph off
graph bar DSR50, over(caste) by(year, col(3) note("")) name(D50_caste, replace)
graph bar DSR50, over(assetsq) by(year, col(3) note("")) name(D50_assets, replace)

graph combine D50_caste D50_assets, name(D50, replace) col(1)
set graph on



********** Display graph
graph display D30
graph display D40
graph display D50


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
