****************************
* Arnaud NATAL
* arnaud.natal@ifpindia.org
* 17 october 2026
* Tangled Up in Debt
****************************

cd"C:\Users\anatal\Documents\tangledup"


**********
********** RUME
**********
use"RUME-loans_mainloans_new", clear

*
drop if loansettled==1

* ML
gen dummymainloan=.
replace dummymainloan=0 if dummyguarantee==.
replace dummymainloan=1 if dummyguarantee==0 | dummyguarantee==1
ta dummymainloan

*
keep HHID2010 loanid year ///
loanreasongiven loanamount2 loanlender lender4 loanbalance2 loandate ///
plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_noth plantorep_othe ///
dummymainloan imp1_debt_service

* Date
gen date="01mar2010"
gen submissiondate=date(date, "DMY")
format submissiondate %td
*
gen loanyear=year(loandate)
gen submissionyear=year(submissiondate)

* Selection
drop date submissiondate loandate
order HHID2010 loanid year submissionyear loanyear 

* Panel
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2010
order HHID_panel

save"_temp1", replace
**********


















**********
********** NEEMSIS-1
**********
use"NEEMSIS1-loans_mainloans_new", clear

*
drop if loansettled==1
drop if loan_database=="MARRIAGE"

* ML
gen dummymainloan=.
replace dummymainloan=0 if termsofrepayment==.
replace dummymainloan=1 if termsofrepayment!=.
ta dummymainloan

*
keep HHID2016 INDID2016 loanid year ///
loanreasongiven loanamount2 loanlender lender4 loanbalance2 loandate ///
plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe ///
dummymainloan imp1_debt_service
tostring loanid, replace

* Date
preserve
use"NEEMSIS1-HH", clear
keep HHID2016 submissiondate
duplicates drop
gen n=dofc(submissiondate)
format n %td
drop submissiondate
rename n submissiondate
save"_temp", replace
restore
merge m:1 HHID2016 using "_temp"
keep if _merge==3
drop _merge
*
gen loanyear=year(loandate)
gen submissionyear=year(submissiondate)

* Selection
drop submissiondate loandate
order HHID2016 INDID2016 loanid year submissionyear loanyear

* Panel
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2016
order HHID_panel
*
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop INDID2016
order HHID_panel INDID_panel year

save"_temp2", replace
**********















**********
********** NEEMSIS-2
**********
use"NEEMSIS2-loans_mainloans_new", clear

*
drop if loansettled==1
drop if loan_database=="MARRIAGE"

* ML
drop dummymainloan
gen dummymainloan=.
replace dummymainloan=0 if termsofrepayment==.
replace dummymainloan=1 if termsofrepayment!=.
ta dummymainloan

*
gen year=2020
keep HHID2020 INDID2020 loanid year ///
loanreasongiven loanamount2 loanlender lender4 loanbalance2 loandate ///
plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe ///
dummymainloan imp1_debt_service
tostring loanid, replace

* Date
preserve
use"NEEMSIS2-HH", clear
keep HHID2020 submissiondate
duplicates drop
gen n=dofc(submissiondate)
format n %td
drop submissiondate
rename n submissiondate
save"_temp", replace
restore
merge m:1 HHID2020 using "_temp"
keep if _merge==3
drop _merge
*
gen loanyear=year(loandate)
gen submissionyear=year(submissiondate)

* Selection
drop submissiondate loandate
order HHID2020 INDID2020 loanid year submissionyear loanyear

* Panel
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
drop HHID2020
order HHID_panel
*
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop INDID2020
order HHID_panel INDID_panel year

save"_temp3", replace
**********

















**********
********** Append + var
**********
use"_temp3", clear

append using "_temp2"
append using "_temp1"

ta dummymainloan year

order HHID_panel INDID_panel loanid year dummymainloan
sort year HHID_panel INDID_panel loanid

* Label
codebook lender4
label define lender3 10"Neighbour", modify
fre lender4

* Microcredit
gen microcredit=.
replace microcredit=1 if loanlender==10 & lender4==8
replace microcredit=2 if loanlender!=10 & lender4==8
recode microcredit (.=0)
label define microcredit 0"Not a microcredit" 1"SHG" 2"NBFC-MFI"
label values microcredit microcredit
*
ta microcredit
*
ta lender4 microcredit, m
ta loanlender microcredit, m
*
clonevar lender5=lender4
fre lender5 microcredit
replace lender5=11 if microcredit==1 
replace lender5=12 if microcredit==2
label define lender3 11"SHG" 12"NBFC-MFI", add
ta lender5 lender4
order lender5, after(lender4)

*
foreach x in loanamount2 loanbalance2 imp1_debt_service {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
replace `x'=`x'/1000
}

*
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020

gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016" 3"2020"
label values time time
order time, after(year)

save"loans_v0", replace
**********



















**********
********** Table like in the paper
**********

***** Table 1
use"loans_v0", clear

ta loanreasongiven year
ta loanreasongiven year, col nofreq

tabstat loanamount2 if year==2010, stat(mean) by(loanreasongiven)
tabstat loanamount2 if year==2016, stat(mean) by(loanreasongiven)
tabstat loanamount2 if year==2020, stat(mean) by(loanreasongiven)


***** Table 2
use"loans_v0", clear

ta year if loanreasongiven==4
ta lender4 year if loanreasongiven==4, col nofreq
tabstat loanamount2 if loanreasongiven==4 & year==2010, stat(mean) by(lender4)
tabstat loanamount2 if loanreasongiven==4 & year==2016, stat(mean) by(lender4)
tabstat loanamount2 if loanreasongiven==4 & year==2020, stat(mean) by(lender4)


***** Table 3
use"loans_v0", clear

keep if dummymainloan==1

ta plantorep_chit year

foreach x in plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe plantorep_noth {
ta `x' year, col nofreq
}


***** Table 4
use"loans_v0", clear

keep if dummymainloan==1

ta loanreasongiven year if plantorep_borr==1
ta loanreasongiven year if plantorep_borr==1, col nofreq
ta lender4 year if plantorep_borr==1, col nofreq


***** Table S1
use"loans_v0", clear

gen repa=0
replace repa=1 if loanreasongiven==4

ta lender4 repa, chi2 cchi2 exp

ta lender4 repa, chi2 nofreq
ta lender4 repa
ta lender4 repa, exp nofreq
ta lender4 repa, cchi2 nofreq

ta lender5 repa, chi2 nofreq
ta lender5 repa
ta lender5 repa, exp nofreq
ta lender5 repa, cchi2 nofreq


**********












**********
********** Suite au retour du rapporteur
**********

***** Table 2
use"loans_v0", clear

ta lender4 year
ta lender4 year, col nofreq

tabstat loanamount2 if year==2010, stat(mean) by(lender4)
tabstat loanamount2 if year==2016, stat(mean) by(lender4)
tabstat loanamount2 if year==2020, stat(mean) by(lender4)


***** Table 2
use"loans_v0", clear

ta year if loanreasongiven==4
ta lender4 year if loanreasongiven==4, col nofreq
tabstat loanamount2 if loanreasongiven==4 & year==2010, stat(mean) by(lender4)
tabstat loanamount2 if loanreasongiven==4 & year==2016, stat(mean) by(lender4)
tabstat loanamount2 if loanreasongiven==4 & year==2020, stat(mean) by(lender4)



***** Table 2
use"loans_v0", clear

ta lender5 year if loanreasongiven==4, col nofreq
tabstat loanamount2 if loanreasongiven==4 & year==2010, stat(mean) by(lender5)
tabstat loanamount2 if loanreasongiven==4 & year==2016, stat(mean) by(lender5)
tabstat loanamount2 if loanreasongiven==4 & year==2020, stat(mean) by(lender5)


***** Table 4
use"loans_v0", clear

keep if dummymainloan==1

ta loanreasongiven year if plantorep_borr==1, col nofreq
ta lender5 year if plantorep_borr==1, col nofreq




**********













**********
********** Loan level to HH level
**********
use"loans_v0", clear

gen loan=1
gen repa=0
replace repa=1 if loanreasongiven==4
gen repa_amount=loanamount2 if repa==1
gen repa_balance=loanbalance2 if repa==1

rename imp1_debt_service debtservice

*
foreach x in loan repa repa_amount repa_balance loanamount2 loanbalance2 debtservice  {
bys HHID_panel year: egen `x'_HH=sum(`x')
} 
keep HHID_panel year loan_HH repa_HH repa_amount_HH repa_balance_HH loanamount2_HH loanbalance2_HH debtservice_HH
duplicates drop

*
gen dummyrepa_HH=repa_HH
replace dummyrepa_HH=1 if repa_HH>1 & repa_HH!=0 & repa_HH!=.

rename repa_HH nbrepa_HH
rename loan_HH nbloan_HH

order HHID_panel year nbloan_HH dummyrepa_HH nbrepa_HH

save"loans_HH", replace
**********












**********
********** Annual income
**********
*
use"RUME-occup_HH", clear
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel annualincome_HH
gen year=2010
save"_temp1", replace

*
use"NEEMSIS1-occup_HH", clear
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel annualincome_HH
gen year=2016
save"_temp2", replace

*
use"NEEMSIS2-occup_HH", clear
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel annualincome_HH
gen year=2020
save"_temp3", replace

*
use"_temp1", clear
append using "_temp2"
append using "_temp3"
ta year

foreach x in annualincome_HH {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
replace `x'=`x'/1000
}

*
merge 1:1 HHID_panel year using "JatisCastePanel", keepusing(casten)
keep if _merge==3
drop _merge
rename casten caste
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

*
merge 1:1 HHID_panel year using "loans_HH"
drop _merge
order HHID_panel year caste dalits

gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016" 3"2020"
label values time time
order time, after(year)

gen monthlyincome=annualincome_HH/12

save"loans_HH_v2", replace

**********













**********
********** Wealth and expenses
**********
*
use"RUME-assets", clear
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel assets_total1000 assets_totalnoland1000 expenses_food expenses_educ expenses_heal
gen year=2010
save"_temp1", replace

*
use"NEEMSIS1-assets", clear
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel assets_total1000 assets_totalnoland1000 expenses_food expenses_educ expenses_heal
gen year=2016
save"_temp2", replace

*
use"NEEMSIS2-assets", clear
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel assets_total1000 assets_totalnoland1000 expenses_food expenses_educ expenses_heal
gen year=2020
save"_temp3", replace

*
use"_temp1", clear
append using "_temp2"
append using "_temp3"
ta year

foreach x in assets_total1000 assets_totalnoland1000 expenses_food expenses_educ expenses_heal {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
}

*
save"_temp", replace

*** Merge
use"loans_HH_v2", clear

merge 1:1 HHID_panel year using "_temp"
keep if _merge==3
drop _merge

*** Ratio
gen amount_to_amount=repa_amount_HH*100/loanamount2_HH
gen balance_to_balance=repa_balance_HH*100/loanbalance2_HH
gen dsr=debtservice_HH*100/annualincome_HH
gen amount_to_income=repa_amount_HH*100/annualincome_HH
gen balance_to_income=repa_balance_HH*100/annualincome_HH


save"loans_HH_v3", replace

**********















**********
********** Stat HH
**********
use"loans_HH_v3", clear


***** Table 5
* Part
ta dummyrepa_HH year, col
ta dummyrepa_HH dalits if year==2010, col
ta dummyrepa_HH dalits if year==2016, col
ta dummyrepa_HH dalits if year==2020, col

* Absolut
tabstat repa_balance_HH if dummyrepa_HH==1, stat(mean median) by(year) long
tabstat repa_balance_HH if year==2010 & dummyrepa_HH==1, stat(mean median) by(dalits) long
tabstat repa_balance_HH if year==2016 & dummyrepa_HH==1, stat(mean median) by(dalits) long
tabstat repa_balance_HH if year==2020 & dummyrepa_HH==1, stat(mean median) by(dalits) long

* Relative to debt
tabstat balance_to_balance if dummyrepa_HH==1, stat(mean median) by(year) long
tabstat balance_to_balance if year==2010 & dummyrepa_HH==1, stat(mean median) by(dalits) long
tabstat balance_to_balance if year==2016 & dummyrepa_HH==1, stat(mean median) by(dalits) long
tabstat balance_to_balance if year==2020 & dummyrepa_HH==1, stat(mean median) by(dalits) long

* Relative to income
tabstat balance_to_income if dummyrepa_HH==1, stat(mean median) by(year) long
tabstat balance_to_income if year==2010 & dummyrepa_HH==1, stat(mean median) by(dalits) long
tabstat balance_to_income if year==2016 & dummyrepa_HH==1, stat(mean median) by(dalits) long
tabstat balance_to_income if year==2020 & dummyrepa_HH==1, stat(mean median) by(dalits) long


* Test 2010
cls
preserve
keep if year==2010
probit dummyrepa_HH i.dalits
keep if dummyrepa_HH==1
reg repa_balance_HH i.dalits
qreg repa_balance_HH i.dalits, quantile(.5)
reg balance_to_balance i.dalits
qreg balance_to_balance i.dalits, quantile(.5)
reg balance_to_income i.dalits
qreg balance_to_income i.dalits, quantile(.5)
restore

* Test 2016
cls
preserve
keep if year==2016
probit dummyrepa_HH i.dalits
keep if dummyrepa_HH==1
reg repa_balance_HH i.dalits
qreg repa_balance_HH i.dalits, quantile(.5)
reg balance_to_balance i.dalits
qreg balance_to_balance i.dalits, quantile(.5)
reg balance_to_income i.dalits
qreg balance_to_income i.dalits, quantile(.5)
restore

* Test 2020
cls
preserve
keep if year==2020
probit dummyrepa_HH i.dalits
keep if dummyrepa_HH==1
reg repa_balance_HH i.dalits
qreg repa_balance_HH i.dalits, quantile(.5)
reg balance_to_balance i.dalits
qreg balance_to_balance i.dalits, quantile(.5)
reg balance_to_income i.dalits
qreg balance_to_income i.dalits, quantile(.5)
restore



***** Table 6
tabstat monthlyincome assets_total1000 dsr if year==2010, stat(n mean median) by(dummyrepa_HH)
tabstat monthlyincome assets_total1000 dsr if year==2016, stat(n mean median) by(dummyrepa_HH)
tabstat monthlyincome assets_total1000 dsr if year==2020, stat(n mean median) by(dummyrepa_HH)


* Test 2010
cls
preserve
keep if year==2010
reg monthlyincome i.dummyrepa_HH
qreg monthlyincome i.dummyrepa_HH, quantile(.5)
reg assets_total1000 i.dummyrepa_HH
qreg assets_total1000 i.dummyrepa_HH, quantile(.5)
reg dsr i.dummyrepa_HH
qreg dsr i.dummyrepa_HH, quantile(.5)
restore

* Test 2016
cls
preserve
keep if year==2016
reg monthlyincome i.dummyrepa_HH
qreg monthlyincome i.dummyrepa_HH, quantile(.5)
reg assets_total1000 i.dummyrepa_HH
qreg assets_total1000 i.dummyrepa_HH, quantile(.5)
reg dsr i.dummyrepa_HH
qreg dsr i.dummyrepa_HH, quantile(.5)
restore

* Test 2020
cls
preserve
keep if year==2020
reg monthlyincome i.dummyrepa_HH
qreg monthlyincome i.dummyrepa_HH, quantile(.5)
reg assets_total1000 i.dummyrepa_HH
qreg assets_total1000 i.dummyrepa_HH, quantile(.5)
reg dsr i.dummyrepa_HH
qreg dsr i.dummyrepa_HH, quantile(.5)
restore


***** Table 7
preserve
keep if dummyrepa_HH==1
*
pwcorr repa_balance_HH monthlyincome if year==2010, sig
pwcorr repa_balance_HH assets_total1000 if year==2010, sig
pwcorr repa_balance_HH dsr if year==2010, sig
pwcorr balance_to_balance monthlyincome if year==2010, sig
pwcorr balance_to_balance assets_total1000 if year==2010, sig
pwcorr balance_to_balance dsr if year==2010, sig
pwcorr balance_to_income monthlyincome if year==2010, sig
pwcorr balance_to_income assets_total1000 if year==2010, sig
pwcorr balance_to_income dsr if year==2010, sig
*
pwcorr repa_balance_HH monthlyincome if year==2016, sig
pwcorr repa_balance_HH assets_total1000 if year==2016, sig
pwcorr repa_balance_HH dsr if year==2016, sig
pwcorr balance_to_balance monthlyincome if year==2016, sig
pwcorr balance_to_balance assets_total1000 if year==2016, sig
pwcorr balance_to_balance dsr if year==2016, sig
pwcorr balance_to_income monthlyincome if year==2016, sig
pwcorr balance_to_income assets_total1000 if year==2016, sig
pwcorr balance_to_income dsr if year==2016, sig
*
pwcorr repa_balance_HH monthlyincome if year==2020, sig
pwcorr repa_balance_HH assets_total1000 if year==2020, sig
pwcorr repa_balance_HH dsr if year==2020, sig
pwcorr balance_to_balance monthlyincome if year==2020, sig
pwcorr balance_to_balance assets_total1000 if year==2020, sig
pwcorr balance_to_balance dsr if year==2020, sig
pwcorr balance_to_income monthlyincome if year==2020, sig
pwcorr balance_to_income assets_total1000 if year==2020, sig
pwcorr balance_to_income dsr if year==2020, sig
restore

**********

















**********
********** Figure 1
**********
use"loans_HH_v3", clear

keep if dummyrepa_HH==1

********** Absolut intensity
local var repa_balance_HH

bys time: egen med=median(`var')
bys time: egen lqt=pctile(`var'), p(25)
bys time: egen uqt=pctile(`var'), p(75)
bys time: egen iqr=iqr(`var')
bys time: egen mean=mean(`var')
gen l=`var' if(`var'>=lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u=`var' if(`var'<=uqt+1.5*iqr)
bys time: egen us=max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "2010" 2 "2016-2017" 3 "2020-2021", angle(45)) ///
	   ylabel(0(10)100) ///
       ytitle("1,000 rupees") xtitle("") title("Debt rollover" "amount", size(medium)) scale(1) name(abs, replace)
drop med lqt uqt iqr mean l ls u us	   

	   
********** Relative intensity (to debt)
local var balance_to_balance

bys time: egen med=median(`var')
bys time: egen lqt=pctile(`var'), p(25)
bys time: egen uqt=pctile(`var'), p(75)
bys time: egen iqr=iqr(`var')
bys time: egen mean=mean(`var')
gen l=`var' if(`var'>=lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u=`var' if(`var'<=uqt+1.5*iqr)
bys time: egen us=max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "2010" 2 "2016-2017" 3 "2020-2021", angle(45)) ///
	   ylabel(0(10)100) ///
       ytitle("Per cent") xtitle("") title("Share of debt rollover" "in household debt", size(medium)) scale(1) name(rel, replace)
drop med lqt uqt iqr mean l ls u us	   
*yscale(titlegap(7))	  
	   
********** Relative intensity (to income)
local var balance_to_income

bys time: egen med=median(`var')
bys time: egen lqt=pctile(`var'), p(25)
bys time: egen uqt=pctile(`var'), p(75)
bys time: egen iqr=iqr(`var')
bys time: egen mean=mean(`var')
gen l=`var' if(`var'>=lqt-1.5*iqr)
bys time: egen ls = min(l)
gen u=`var' if(`var'<=uqt+1.5*iqr)
bys time: egen us=max(u)
*
twoway rbar lqt med time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rbar med uqt time, fcolor(gs12) lcolor(black) barw(.5) || ///
       rspike lqt ls time, lcolor(black) || ///
       rspike uqt us time, lcolor(black) || ///
       rcap ls ls time, msize(*6) lcolor(black) || ///
       rcap us us time, msize(*6) pstyle(p1) || ///
       scatter mean time, msymbol(Oh) msize(*1) mcolor(black) ///
       legend(off)  xlabel( 1 "2010" 2 "2016-2017" 3 "2020-2021", angle(45)) ///
	   ylabel(0(10)100) ///
       ytitle("Per cent") xtitle("") title("Share of debt rollover" "in annual income", size(medium)) scale(1) name(relinc, replace)
drop med lqt uqt iqr mean l ls u us	   



********** Combine
graph combine abs rel relinc, col(3) name(comb, replace)
graph export "boxplot.png", as(png) replace

**********




























**********
********** Loan level to Indiv level
**********
use"loans_v0", clear

gen loan=1
gen repa=0
replace repa=1 if loanreasongiven==4
gen repa_amount=loanamount2 if repa==1
gen repa_balance=loanbalance2 if repa==1

rename imp1_debt_service debtservice

drop if year==2010

*
foreach x in loan repa repa_amount repa_balance loanamount2 loanbalance2 debtservice  {
bys HHID_panel INDID_panel year: egen `x'_indiv=sum(`x')
} 
keep HHID_panel INDID_panel year loan_indiv repa_indiv repa_amount_indiv repa_balance_indiv loanamount2_indiv loanbalance2_indiv debtservice_indiv
duplicates drop

*
gen dummyrepa_indiv=repa_indiv
replace dummyrepa_indiv=1 if repa_indiv>1 & repa_indiv!=0 & repa_indiv!=.

rename repa_indiv nbrepa_indiv
rename loan_indiv nbloan_indiv

order HHID_panel INDID_panel year nbloan_indiv dummyrepa_indiv nbrepa_indiv

save"loans_indiv", replace
**********











**********
********** Sex
**********
*
use"NEEMSIS1-HH", clear
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel INDID2016 sex
gen year=2016
tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop INDID2016
order HHID_panel INDID_panel year sex
save"_temp1", replace

*
use"NEEMSIS2-HH", clear
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel INDID2020 sex
gen year=2020
tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
drop INDID2020
order HHID_panel INDID_panel year sex
save"_temp2", replace

*
use"_temp1", clear
append using "_temp2"

*
merge 1:1 HHID_panel INDID_panel year using "loans_indiv"
keep if _merge==3
drop _merge


* Merge HH charact
merge m:m HHID_panel year using "loans_HH_v3", keepusing(dummyrepa_HH repa_balance_HH repa_amount_HH)
keep if _merge==3
drop _merge

* Var
gen share_balance=repa_balance_indiv*100/repa_balance_HH
gen share_amount=repa_amount_indiv*100/repa_amount_HH

save"loans_indiv_v2", replace
**********













**********
********** Table 8
**********
use"loans_indiv_v2", replace

keep if dummyrepa_HH==1

* Combien sont rollover ?
ta sex year
ta dummyrepa_indiv year, col nofreq
ta dummyrepa_indiv sex if year==2016, col nofreq
ta dummyrepa_indiv sex if year==2020, col nofreq

* Part détenue
keep if dummyrepa_indiv==1
ta sex year


tabstat share_balance share_amount, stat(n mean median) by(year)
tabstat share_balance share_amount if year==2016, stat(n mean median) by(sex)
tabstat share_balance share_amount if year==2020, stat(n mean median) by(sex)

reg share_balance i.sex if year==2016
reg share_balance i.sex if year==2020
reg share_amount i.sex if year==2016
reg share_amount i.sex if year==2020

*qreg share_balance i.sex if year==2016, quantile(.5)
*qreg share_balance i.sex if year==2020, quantile(.5)
*qreg share_amount i.sex if year==2016, quantile(.5)
*qreg share_amount i.sex if year==2020, quantile(.5)

**********

















**********
********** Econo: var de rollover retardée
**********
use"loans_v0", replace

* Delta pour reverse causality
gen deltayear2=.
replace deltayear2=1 if submissionyear==2010 & loanyear<=2008
replace deltayear2=1 if submissionyear==2016 & loanyear<=2014
replace deltayear2=1 if submissionyear==2017 & loanyear<=2015
replace deltayear2=1 if submissionyear==2020 & loanyear<=2018
replace deltayear2=1 if submissionyear==2021 & loanyear<=2019
recode deltayear2 (.=0)
ta deltayear2

* Dummy trap two year
gen rolldelta2year=1 if loanreasongiven==4 & deltayear2==1
ta rolldelta2year year
gen rollpamountdelta2year=loanbalance2 if rolldelta2year==1


* HH level
bysort HHID_panel year: egen rolldelta2year_HH=sum(rolldelta2year)
replace rolldelta2year_HH=1 if rolldelta2year_HH>1
bys HHID_panel year: egen rollpamountdelta2year_HH=sum(rollpamountdelta2year)

keep HHID_panel year rolldelta2year_HH rollpamountdelta2year_HH        
duplicates drop
ta year

save"_temp_rollHH", replace
**********
















**********
********** Family and head
**********
*
use"RUME-family", clear
merge m:m HHID2010 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel head_sex head_age head_mocc_occupation head_edulevel HHsize HH_count_child
gen year=2010
save"_temp1", replace

*
use"NEEMSIS1-family", clear
*
preserve
use"NEEMSIS1-HH", clear
keep HHID2016 dummydemonetisation
duplicates drop
save"_tempdemo", replace
restore
merge 1:1 HHID2016 using "_tempdemo", keepusing(dummydemonetisation)
drop _merge
*
merge m:m HHID2016 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel head_sex head_age head_mocc_occupation head_edulevel HHsize HH_count_child head_maritalstatus ///
dummydemonetisation
gen year=2016
save"_temp2", replace

*
use"NEEMSIS2-family", clear
*
merge 1:1 HHID2020 using "NEEMSIS2-covid", keepusing(secondlockdownexposure)
drop _merge
*
merge m:m HHID2020 using "keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
keep HHID_panel head_sex head_age head_mocc_occupation head_edulevel HHsize HH_count_child head_maritalstatus ///
secondlockdownexposure
gen year=2020
save"_temp3", replace

*
use"_temp1", clear
append using "_temp2"
append using "_temp3"
ta year

*
fre head_maritalstatus
gen head_married=0
replace head_married=1 if year==2010
replace head_married=1 if head_maritalstatus==1
ta head_married year, col nofreq
drop head_maritalstatus

*
recode dummydemonetisation (.=0)
rename secondlockdownexposure dummylockdown
recode dummylockdown (.=0) (1=0) (2=0) (3=1)
label define dummylockdown 0"No" 1"Yes"
label values dummylockdown dummylockdown
ta dummylockdown year, col nofreq
ta dummydemonetisation year, col nofreq

*
save"_temp", replace

*** Merge
use"loans_HH_v3", clear

*
merge 1:1 HHID_panel year using "_temp"
keep if _merge==3
drop _merge

*
merge 1:1 HHID_panel year using "_temp_rollHH"
drop _merge
ta year


* Exp per head
foreach x in expenses_educ expenses_food expenses_heal {
replace `x'=1 if `x'==0
replace `x'=1 if `x'==.
gen `x'_pc=`x'/HHsize
gen log_`x'_pc=log(`x'_pc)
}

* Encode
encode HHID_panel, gen(HHFE)
order HHFE, after(HHID_panel)


save"loans_HH_v4", replace
**********









**********
********** Stat desc Econo
**********
use"loans_HH_v4", clear

*
drop if nbloan_HH==.
drop if nbloan_HH==0
ta year

*
keep HHFE year ///
expenses_educ_pc expenses_food_pc expenses_heal_pc ///
rolldelta2year_HH rollpamountdelta2year_HH ///
head_sex head_age head_married head_edulevel head_mocc_occupation ///
HHsize HH_count_child annualincome_HH assets_total1000 dummydemonetisation dummylockdown caste

cls

tabstat expenses_food_pc expenses_heal_pc expenses_educ_pc, stat(mean) by(year)

ta head_sex year, col nofreq

tabstat head_age, stat(mean) by(year)

ta head_married year, col nofreq

recode head_edulevel (3=2) (4=2) (5=2)
ta head_edulevel year, col nofreq

recode head_mocc_occupation (.=0) (5=4)
ta head_mocc_occupation year, col nofreq

tabstat HHsize HH_count_child annualincome_HH assets_total1000, stat(mean) by(year)

ta dummydemonetisation year, col nofreq

ta dummylockdown year, col nofreq

ta caste year, col nofreq

**********










**********
********** Econo
**********
use"loans_HH_v4", clear

*
drop if nbloan_HH==.
drop if nbloan_HH==0
ta year

*
keep HHFE year ///
log_expenses_educ_pc log_expenses_food_pc log_expenses_heal_pc ///
rolldelta2year_HH rollpamountdelta2year_HH ///
head_sex head_age head_married head_edulevel head_mocc_occupation ///
HHsize HH_count_child annualincome_HH assets_total1000 dummydemonetisation dummylockdown caste dalits

* 
xtset HHFE year
mdesc
fre head_mocc_occupation
recode head_mocc_occupation (.=0)
fre head_mocc_occupation
mdesc

***** Table 9
* Food
xtreg log_expenses_food_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Health
xtreg log_expenses_heal_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Educ
xtreg log_expenses_educ_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)



***** Table supp econom interactions CASTE
cls
* Food
xtreg log_expenses_food_pc i.rolldelta2year_HH##i.dalits ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Health
xtreg log_expenses_heal_pc i.rolldelta2year_HH##i.dalits ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Educ
xtreg log_expenses_educ_pc i.rolldelta2year_HH##i.dalits ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)



***** Table supp econom interactions INCOME
egen annualincome=std(annualincome_HH)
drop annualincome_HH
rename annualincome annualincome_HH
* Food
xtreg log_expenses_food_pc i.rolldelta2year_HH##c.annualincome_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Health
xtreg log_expenses_heal_pc i.rolldelta2year_HH##c.annualincome_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Educ
xtreg log_expenses_educ_pc i.rolldelta2year_HH##c.annualincome_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)





***** Table supp econom interactions WEALTH
egen assets_total=std(assets_total1000)
drop assets_total1000
rename assets_total assets_total1000
* Food
xtreg log_expenses_food_pc i.rolldelta2year_HH##c.assets_total1000 ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Health
xtreg log_expenses_heal_pc i.rolldelta2year_HH##c.assets_total1000 ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Educ
xtreg log_expenses_educ_pc i.rolldelta2year_HH##c.assets_total1000 ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)




***** Table supp econom rollover amount
preserve
keep if rolldelta2year_HH==1
* Food
xtreg log_expenses_food_pc c.rollpamountdelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Health
xtreg log_expenses_heal_pc c.rollpamountdelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)

* Educ
xtreg log_expenses_educ_pc c.rollpamountdelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)
restore



***** Table supp econom outliers

* Food
preserve
sum log_expenses_food_pc, det
local min=`r(p1)'
local max=`r(p99)'
drop if log_expenses_food_pc<`min'
drop if log_expenses_food_pc>`max'
xtreg log_expenses_food_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)
restore

* Health
preserve
sum log_expenses_heal_pc, det
local min=`r(p1)'
local max=`r(p99)'
drop if log_expenses_heal_pc<`min'
drop if log_expenses_heal_pc>`max'
xtreg log_expenses_heal_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)
restore

* Educ
preserve
sum log_expenses_educ_pc, det
local min=`r(p1)'
local max=`r(p99)'
drop if log_expenses_educ_pc<`min'
drop if log_expenses_educ_pc>`max'
xtreg log_expenses_educ_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, fe vce(cluster HHFE)
restore
**********













**********
********** Econo quantiles
**********
use"loans_HH_v4", clear

*
drop if nbloan_HH==.
drop if nbloan_HH==0
ta year

*
keep HHFE year ///
log_expenses_educ_pc log_expenses_food_pc log_expenses_heal_pc ///
rolldelta2year_HH rollpamountdelta2year_HH ///
head_sex head_age head_married head_edulevel head_mocc_occupation ///
HHsize HH_count_child annualincome_HH assets_total1000 dummydemonetisation dummylockdown caste

* 
mdesc
fre head_mocc_occupation
recode head_mocc_occupation (.=0)
fre head_mocc_occupation
mdesc



***** Figure quantiles
*** Food
cls
forvalues i=1/9 {
mmqreg log_expenses_food_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, abs(HHFE) q(.`i') cluster(HHFE) nols
}

*** Health
cls
forvalues i=1/9 {
mmqreg log_expenses_heal_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, abs(HHFE) q(.`i') cluster(HHFE) nols
}

*** Education
cls
forvalues i=1/9 {
mmqreg log_expenses_educ_pc i.rolldelta2year_HH ///
i.head_sex c.head_age i.head_married i.head_edulevel i.head_mocc_occupation ///
c.HHsize c.HH_count_child c.annualincome_HH c.assets_total1000 i.dummydemonetisation i.dummylockdown i.caste ///
, abs(HHFE) q(.`i') cluster(HHFE) nols
}


********** Graph
*** Food
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
keep if var=="food"
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Food") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(food, replace) scale (1.2) aspectratio(3)

*** Health
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
keep if var=="health"
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Health") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(health, replace) scale (1.2) aspectratio(3)

*** Education
import excel "Qreg.xlsx", sheet("Sheet1") firstrow clear
keep if var=="educ"
*
twoway ///
(rarea max min quantile, color(gs5%30)) ///
(line coef quantile, lcolor(gs5) yline(0, lcolor(black))) ///
, xlabel(1(1)9) ylabel(-.9(.3)1.5) ///
xtitle("Quantile") ///
title("Education") ///
legend(order(2 "Effect" 1 "95 per cent confidence interval") pos(6) col(2)) ///
name(educ, replace) scale (1.2) aspectratio(3)


*** Comb
grc1leg food health educ, col(3) name(comb, replace)
graph export "xtqreg.png", as(png) replace

**********


