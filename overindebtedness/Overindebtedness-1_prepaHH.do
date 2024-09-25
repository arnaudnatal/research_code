*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 23, 2024
*-----
gl link = "overindebtedness"
*Prepa HH
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\overindebtedness.do"
*-------------------------





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* To keep
keep HHID2010 

* Uniq HH
duplicates drop
count

* Add debt
merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous)
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets"
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH"
drop _merge

* Panel
merge 1:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2010 HHID

*Year
gen year=2010

* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename jatisn jatis
rename casten caste

save"temp_RUME", replace
****************************************
* END


















****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear

* To keep
keep HHID2016

* Uniq HH
duplicates drop
count

* Add debt
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous)
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets"
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH"
drop _merge

* Panel
merge 1:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2016 HHID

*Year
gen year=2016

* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename jatisn jatis
rename casten caste

save"temp_NEEMSIS1", replace
****************************************
* END



















****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* To keep
keep HHID2020

* Uniq HH
duplicates drop
count

* Add debt
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous)
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets"
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH"
drop _merge

* Panel
merge 1:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2020 HHID

*Year
gen year=2020

* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge
rename jatisn jatis
rename casten caste

save"temp_NEEMSIS2", replace
****************************************
* END























****************************************
* Panel
****************************************
use"temp_NEEMSIS2", clear

* Append
append using "temp_NEEMSIS1"
append using "temp_RUME"

ta year
drop test

save"panel_v0", replace
****************************************
* END



















****************************************
* Construction variables
****************************************
use"panel_v0", clear

* DSR
gen dsr=imp1_ds_tot_HH*100/annualincome_HH
replace dsr=0 if dsr==.

* DAR
gen dar=loanamount_HH*100/assets_total
replace dar=0 if dar==.

gen dar_nl=loanamount_HH*100/assets_totalnoland
replace dar_nl=0 if dar_nl==.

* ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.

save "panel_v1", replace
****************************************
* END



















****************************************
* Debt by income decile for each year
****************************************
use"panel_v1", clear

* Decile
foreach i in 2010 2016 2020 {
xtile incgrp`i'=annualincome_HH if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}

collapse (mean) dsr dar dar_nl, by(year incgroup)



* DSR
twoway ///
(connected dsr incgroup if year==2010) ///
(connected dsr incgroup if year==2016) ///
(connected dsr incgroup if year==2020) ///
, ///
xlabel(1(1)10) xtitle("Decile of income per capita") ///
ylabel(0(50)350) ytitle("Percent") ///
title("DSR") ///
legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ///
name(compo1, replace)


****************************************
* END














****************************************
* Debt composition by debt decile for each year
****************************************
use"panel_v1", clear


* Decile of debt
foreach i in 2010 2016 2020 {
xtile loangrp`i'=loanamount_HH if year==`i', n(10)
}
gen loangroup=.
foreach i in 2010 2016 2020 {
replace loangroup=loangrp`i' if year==`i'
drop loangrp`i' 
}

* Decile of income
foreach i in 2010 2016 2020 {
xtile incgrp`i'=annualincome_HH if year==`i', n(10)
}
gen incgroup=.
foreach i in 2010 2016 2020 {
replace incgroup=incgrp`i' if year==`i'
drop incgrp`i' 
}

* Share source
rename totHH_lendercatamt_info info
rename totHH_lendercatamt_semi semi
rename totHH_lendercatamt_form form
gen s1=info+semi+form
foreach x in info semi form {
gen s_`x'=`x'*100/s1
}
drop s1
egen test=rowtotal(s_info s_semi s_form)
ta test
drop test

* Share use
rename totHH_givencatamt_econ econ
rename totHH_givencatamt_curr curr
rename totHH_givencatamt_huma huma
rename totHH_givencatamt_soci soci
rename totHH_givencatamt_hous hous
gen s2=econ+curr+huma+soci+hous
foreach x in econ curr huma soci hous {
gen s_`x'=`x'*100/s2
}
drop s2
egen test=rowtotal(s_econ s_curr s_huma s_soci s_hous)
ta test
drop test


********** By decile of debt
preserve
collapse (mean) s_info s_semi s_form s_econ s_curr s_huma s_soci s_hous, by(year loangroup)

gen sum1=s_info
gen sum2=sum1+s_semi
gen sum3=sum2+s_form

gen sum11=s_econ
gen sum21=sum11+s_curr
gen sum31=sum21+s_huma
gen sum41=sum31+s_soci
gen sum51=sum41+s_hous


***** Sources
foreach x in 2010 2016 2020 {
twoway ///
(area sum1 loangroup if year==`x') ///
(rarea sum1 sum2 loangroup if year==`x') ///
(rarea sum2 sum3 loangroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of loan amount per household") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Informal" 2 "Semi formal" 3 "Formal") pos(6) col(4)) ///
name(compo`x', replace)
}
grc1leg compo2010 compo2016 compo2020, name(compo_loan, replace) col(3)
graph export "Compo_loan.png", replace

***** Use
foreach x in 2010 2016 2020 {
twoway ///
(area sum11 loangroup if year==`x') ///
(rarea sum11 sum21 loangroup if year==`x') ///
(rarea sum21 sum31 loangroup if year==`x') ///
(rarea sum31 sum41 loangroup if year==`x') ///
(rarea sum41 sum51 loangroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of loan amount per household") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Econ" 2 "Curr" 3 "Huma" 4 "Soci" 5 "Hous") pos(6) col(5)) ///
name(use`x', replace)
}
grc1leg use2010 use2016 use2020, name(use_loan, replace) col(3)
graph export "Use_loan.png", replace
restore



********** By decile of income
preserve
collapse (mean) s_info s_semi s_form s_econ s_curr s_huma s_soci s_hous, by(year incgroup)

gen sum1=s_info
gen sum2=sum1+s_semi
gen sum3=sum2+s_form

gen sum11=s_econ
gen sum21=sum11+s_curr
gen sum31=sum21+s_huma
gen sum41=sum31+s_soci
gen sum51=sum41+s_hous


***** Sources
foreach x in 2010 2016 2020 {
twoway ///
(area sum1 incgroup if year==`x') ///
(rarea sum1 sum2 incgroup if year==`x') ///
(rarea sum2 sum3 incgroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of income") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Informal" 2 "Semi formal" 3 "Formal") pos(6) col(4)) ///
name(compo`x', replace)
}
grc1leg compo2010 compo2016 compo2020, name(compo_loan, replace) col(3)
graph export "Compo_inc.png", replace

***** Use
foreach x in 2010 2016 2020 {
twoway ///
(area sum11 incgroup if year==`x') ///
(rarea sum11 sum21 incgroup if year==`x') ///
(rarea sum21 sum31 incgroup if year==`x') ///
(rarea sum31 sum41 incgroup if year==`x') ///
(rarea sum41 sum51 incgroup if year==`x') ///
, ///
xlabel(1(1)10) xtitle("Decile of income") ///
ylabel(0(10)100) ytitle("Percent") ///
title("`x'") ///
legend(order(1 "Econ" 2 "Curr" 3 "Huma" 4 "Soci" 5 "Hous") pos(6) col(5)) ///
name(use`x', replace)
}
grc1leg use2010 use2016 use2020, name(use_loan, replace) col(3)
graph export "Use_inc.png", replace
restore

****************************************
* END
