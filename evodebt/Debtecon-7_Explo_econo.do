cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 31, 2022
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
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid compact

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
* MERGE
****************************************
use"panel_v4", clear

drop DIR_r DAR_with_r DAR_without_r DSR_r ISR_r foodexpenses_raw healthexpenses_raw ceremoniesexpenses_raw deathexpenses_raw occinc_agri_raw occinc_agricasual_raw occinc_nonagricasual_raw occinc_nonagriregnonqual_raw occinc_nonagriregqual_raw occinc_selfemp_raw occinc_nrega_raw imp1_ds_tot_raw imp1_is_tot_raw marriageexpenses_raw educationexpenses_raw loanamount_raw annualincome_raw amountownland_raw assets_raw assets_noland_raw livestock_raw housevalue_raw goldquantityamount_raw goodtotalamount_raw agri_raw nagri_raw

********** Var to keep
*keep HHID_panel year annualincome DSR panel villageid caste religion ownland loans HHsize femtomale head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation assets_noland DAR_without DAR_with time ISR repay_nb_HH repay_amt_HH rel_repay_amt_HH dummyrepay MLborrowstrat_nb_HH MLborrowstrat_amt_HH rel_MLborrowstrat_amt_HH dummyborrowstrat yearly_expenses yearly_expenses_bis

ta panel year


********** Merge trends
merge m:1 HHID_panel using "trends"
drop _merge
ta panel



********** Merge trap
preserve
keep if panel==1
recode dummyrepay (.=0)
ta dummyrepay year, col nofreq
keep HHID_panel year dummyrepay
reshape wide dummyrepay, i(HHID_panel) j(year)

egen debttrap=group(dummyrepay2010 dummyrepay2016 dummyrepay2020), lab
fre debttrap

gen debttrap2=.
replace debttrap2=0 if debttrap==1
replace debttrap2=1 if debttrap==2
replace debttrap2=1 if debttrap==3
replace debttrap2=1 if debttrap==5
replace debttrap2=2 if debttrap==4
replace debttrap2=2 if debttrap==6
replace debttrap2=2 if debttrap==7
replace debttrap2=3 if debttrap==8

label define debttrap2 0"Zero" 1"One" 2"Two" 3"Three"
label values debttrap2 debttrap2

ta debttrap
keep HHID_panel debttrap debttrap2
save "debtrap_temp.dta", replace
restore

merge m:1 HHID_panel using "debtrap_temp"
erase "debtrap_temp.dta"
drop _merge
ta panel


********** Expenses to income ratio test
ta yearly_expenses
ta annualincome
replace yearly_expenses=yearly_expenses/1000
replace yearly_expenses_bis=yearly_expenses_bis/1000
gen EIR=yearly_expenses/annualincome
gen EIR_bis=yearly_expenses_bis/annualincome

tabstat EIR EIR_bis, stat(n mean sd q) by(year)


********** Reshape
/*
reshape wide time annualincome DSR panel villageid caste religion ownland loans HHsize femtomale head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation assets_noland DAR_without DAR_with, i(HHID_panel) j(year)
ta time2010
ta time2016
ta time2020
*/


*
save"panel_v10", replace
****************************************
* END









****************************************
* ANALYSIS
****************************************
use"panel_v10", clear

recode dummyrepay (.=0)
ta dummyrepay year, col nofreq

preserve
keep if dummyrepay==1
ta year
tabstat rel_repay_amt_HH, stat(n mean sd q) by(year)

tabstat rel_repay_amt_HH if year==2010, stat(n mean sd q) by(cl_vuln)
tabstat rel_repay_amt_HH if year==2016, stat(n mean sd q) by(cl_vuln)
tabstat rel_repay_amt_HH if year==2020, stat(n mean sd q) by(cl_vuln)

tabstat rel_repay_amt_HH if year==2010, stat(n mean sd q) by(caste)
tabstat rel_repay_amt_HH if year==2016, stat(n mean sd q) by(caste)
tabstat rel_repay_amt_HH if year==2020, stat(n mean sd q) by(caste)
restore

ta debttrap caste if year==2010, col nofreq
ta debttrap2 caste if year==2010, col nofreq


cls
tabstat informal_HH rel_informal_HH if year==2010, stat(mean q) by(dummyrepay)
tabstat informal_HH rel_informal_HH if year==2016, stat(mean q) by(dummyrepay)
tabstat informal_HH rel_informal_HH if year==2020, stat(mean q) by(dummyrepay)


cls
probit dummyrepay rel_informal_HH loanamount i.caste##i.cl_vuln if year==2010
probit dummyrepay rel_informal_HH loanamount i.caste##i.cl_vuln if year==2016
probit dummyrepay rel_informal_HH loanamount i.caste##i.cl_vuln if year==2020


xtset panelvar year
xtprobit dummyrepay rel_informal_HH loanamount


ta dummyrepay dummydemonetisation if year==2016, col nofreq
ta dummyrepay dummydemonetisation if year==2016, row nofreq



********** Strat
ta dummymigrstrat year
ta dummyassestrat year


********** Over
cls
ta DSR30 caste if year==2010, col nofreq
ta DSR30 caste if year==2016, col nofreq
ta DSR30 caste if year==2020, col nofreq


****************************************
* END












****************************************
* DEBT AND OCCUPATION
****************************************
use"panel_v10", clear

keep HHID_panel year caste jatis villagearea villageid cl_vuln dummyvuln dummysust wifehusb_* head_* sbd_* DSR DAR_with DAR_without assets_noland annualincome loanamount rel_informal_HH rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH

reshape wide annualincome DSR loanamount villageid caste head_sex head_maritalstatus head_age head_edulevel head_occupation wifehusb_sex wifehusb_maritalstatus wifehusb_age wifehusb_edulevel wifehusb_occupation assets_noland jatis villagearea rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH DAR_without DAR_with, i(HHID_panel) j(year)


********** Change occupation head and husb
fre head_occupation2010 wifehusb_occupation2010 head_occupation2016 wifehusb_occupation2016 head_occupation2020 wifehusb_occupation2020

foreach x in head wifehusb {
gen `x'_changeocc_1=.
gen `x'_changeocc_2=.

replace `x'_changeocc_1=0 if `x'_occupation2010==`x'_occupation2016
replace `x'_changeocc_2=0 if `x'_occupation2016==`x'_occupation2020

replace `x'_changeocc_1=1 if `x'_occupation2010!=`x'_occupation2016
replace `x'_changeocc_2=1 if `x'_occupation2016!=`x'_occupation2020
}

foreach x in head wifehusb {
gen `x'_changeocc_gl=.

replace `x'_changeocc_gl=0 if `x'_changeocc_1==0 & `x'_changeocc_2==0

replace `x'_changeocc_gl=1 if `x'_changeocc_1==1 & `x'_changeocc_2==0
replace `x'_changeocc_gl=1 if `x'_changeocc_1==0 & `x'_changeocc_2==1

replace `x'_changeocc_gl=2 if `x'_changeocc_1==1 & `x'_changeocc_2==1
}

fre head_changeocc_1 head_changeocc_2 head_changeocc_gl
fre wifehusb_changeocc_1 wifehusb_changeocc_2 wifehusb_changeocc_gl

********** Test econometrisc
set maxiter 50
probit dummyvuln i.head_occupation2010 i.wifehusb_occupation2010, baselevels

mprobit wifehusb_occupation2016 i.wifehusb_occupation2010 i.cl_vuln

****************************************
* END






/*
****************************************
* SHOCK AND DEBT
****************************************

********** Keep 2016-17
preserve 
use "NEEMSIS1-HH.dta", clear
keep HHID_panel dummydemonetisation
duplicates drop
save "NEEMSIS1-HH_temp", replace
restore

preserve
keep if year==2016
merge 1:1 HHID_panel using "NEEMSIS1-HH_temp.dta"
drop _merge
erase "NEEMSIS1-HH_temp.dta"

ta cl_vuln dummydemonetisation, m
ta cl_vuln dummydemonetisation

tabstat DSR ISR DAR_without DAR_with, stat(n mean sd p50) by(dummydemonetisation)

restore


********** Keep 2020-21
preserve 
use "NEEMSIS2-HH.dta", clear
gen tos=dofc(start_HH_quest)
format tos %td
*
gen swt=.
replace swt=1 if tos<d(05apr2021)
replace swt=2 if tos>=d(05apr2021) & tos<=d(15jun2021)
replace swt=3 if tos>d(15jun2021)
*
gen treat=.
replace treat=0 if tos<d(05apr2021)
replace treat=1 if tos>d(15jun2021)
*
keep HHID_panel start_HH_quest tos swt treat
duplicates drop
save "NEEMSIS2-HH_temp", replace
restore

preserve
keep if year==2020
merge 1:1 HHID_panel using "NEEMSIS2-HH_temp.dta"
drop _merge
erase "NEEMSIS2-HH_temp.dta"

ta cl_vuln treat, m
ta cl_vuln treat

tabstat DSR ISR DAR_without DAR_with, stat(n mean sd p50) by(treat)
restore
****************************************
* END
