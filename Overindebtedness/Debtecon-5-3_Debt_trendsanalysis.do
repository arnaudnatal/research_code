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
* Descriptive statistics
****************************************
use"panel_v5", clear

********** Initialization
xtset panelvar time
keep if panel==1


********** Desc
tabstat annualincome assets_noland loanamount DAR_without DSR ISR, stat(mean median skewness kurtosis) by(year)

clear all
cls
****************************************
* END






****************************************
* Datasets preparation
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

encode HHID_panel, gen(panelvar)


********** Dummyownland
foreach y in 2010 2016 2020 {
gen dummyownland`y'=1
replace dummyownland`y'=0 if sizeownland`y'==.
}


********** Rename DSR30 40 50 as over
foreach y in 2010 2016 2020 {
rename DSR30`y' over30`y'
rename DSR40`y' over40`y'
rename DSR50`y' over50`y'
}

********** Var to use
global var1 cro_annualincome2010 cro_assets_noland2010 cro_loanamount2010 cro_DSR2010 cro_DAR_without2010 cro_DIR2010 cro_ISR2010 cro_annualincome2016 cro_assets_noland2016 cro_loanamount2016 cro_DSR2016 cro_DAR_without2016 cro_DIR2016 cro_ISR2016 cro_annualincome2020 cro_assets_noland2020 cro_loanamount2020 cro_DSR2020 cro_DAR_without2020 cro_DIR2020 cro_ISR2020 cro_yearly_expenses2010 cro_yearly_expenses2016 cro_yearly_expenses2020

global var2 ihs_ISR10002010 ihs_DAR10002010 ihs_DSR10002010 ihs_ISR10002016 ihs_DAR10002016 ihs_DSR10002016  ihs_ISR10002020    ihs_DAR10002020 ihs_DSR10002020

global var3 log_yearly_expenses2010 log_annualincome2010 log_assets_noland2010 log_assets2010 log_loanamount2010 log_yearly_expenses2016 log_annualincome2016 log_assets_noland2016 log_assets2016 log_loanamount2016 log_yearly_expenses2020 log_annualincome2020 log_assets_noland2020 log_assets2020 log_loanamount2020

global var4 ihs_annualincome2010 ihs_annualincome2016 ihs_annualincome2020 ihs_loanamount2010 ihs_loanamount2016 ihs_loanamount2020 ihs_assets_noland2010 ihs_assets_noland2016 ihs_assets_noland2020 ihs_yearly_expenses2010 ihs_yearly_expenses2016 ihs_yearly_expenses2020

global var5 head_edulevel2010 head_occupation2010 wifehusb_edulevel2010 wifehusb_occupation2010 mainocc_occupation2010 head_edulevel2016 head_occupation2016 wifehusb_edulevel2016 wifehusb_occupation2016 mainocc_occupation2016 head_edulevel2020 head_occupation2020 wifehusb_edulevel2020 wifehusb_occupation2020 mainocc_occupation2020 cat_income cat_assets sizeownland2010 sizeownland2016 sizeownland2020 over302010 over402010 over502010 over302016 over402016 over502016 over302020 over402020 over502020 dummyownland2010 dummyownland2016 dummyownland2020

global var6 agri2010 nagri2010 shareagri2010 sharenagri2010 agri2016 nagri2016 shareagri2016 sharenagri2016 agri2020 nagri2020 shareagri2020 sharenagri2020 

global var7 rel_formal_HH2010 rel_informal_HH2010 rel_eco_HH2010 rel_current_HH2010 rel_humank_HH2010 rel_social_HH2010 rel_home_HH2010 rel_other_HH2010 rel_repay_amt_HH2010 informal_HH2010 formal_HH2010 eco_HH2010 current_HH2010 humank_HH2010 social_HH2010 home_HH2010 other_HH2010 repay_amt_HH2010 rel_formal_HH2016 rel_informal_HH2016 rel_eco_HH2016 rel_current_HH2016 rel_humank_HH2016 rel_social_HH2016 rel_home_HH2016 rel_other_HH2016 rel_repay_amt_HH2016 informal_HH2016 formal_HH2016 eco_HH2016 current_HH2016 humank_HH2016 social_HH2016 home_HH2016 other_HH2016 repay_amt_HH2016 rel_formal_HH2020 rel_informal_HH2020 rel_eco_HH2020 rel_current_HH2020 rel_humank_HH2020 rel_social_HH2020 rel_home_HH2020 rel_other_HH2020 rel_repay_amt_HH2020 informal_HH2020 formal_HH2020 eco_HH2020 current_HH2020 humank_HH2020 social_HH2020 home_HH2020 other_HH2020 repay_amt_HH2020 ihs_informal_HH2010 ihs_formal_HH2010 ihs_eco_HH2010 ihs_current_HH2010 ihs_humank_HH2010 ihs_social_HH2010 ihs_home_HH2010 ihs_repay_amt_HH2010 ihs_informal_HH2016 ihs_formal_HH2016 ihs_eco_HH2016 ihs_current_HH2016 ihs_humank_HH2016 ihs_social_HH2016 ihs_home_HH2016 ihs_repay_amt_HH2016 ihs_informal_HH2020 ihs_formal_HH2020 ihs_eco_HH2020 ihs_current_HH2020 ihs_humank_HH2020 ihs_social_HH2020 ihs_home_HH2020 ihs_repay_amt_HH2020

global var8 ihs_rel_informal_HH2010 ihs_rel_formal_HH2010 ihs_rel_eco_HH2010 ihs_rel_current_HH2010 ihs_rel_humank_HH2010 ihs_rel_social_HH2010 ihs_rel_home_HH2010 ihs_rel_repay_amt_HH2010 ihs_rel_informal_HH2016 ihs_rel_formal_HH2016 ihs_rel_eco_HH2016 ihs_rel_current_HH2016 ihs_rel_humank_HH2016 ihs_rel_social_HH2016 ihs_rel_home_HH2016 ihs_rel_repay_amt_HH2016 ihs_rel_informal_HH2020 ihs_rel_formal_HH2020 ihs_rel_eco_HH2020 ihs_rel_current_HH2020 ihs_rel_humank_HH2020 ihs_rel_social_HH2020 ihs_rel_home_HH2020 ihs_rel_repay_amt_HH2020

***** Keep
keep HHID_panel panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* DAR_with* annualincome* assets_noland* yearly_expenses* ISR* DIR* $var1 $var2 $var3 $var4 $var5 $var6 $var7 $var8


* Oups
drop DAR_with2010 DAR_with2016 DAR_with2020

* Order and sort
order panelvar caste jatis
sort panelvar

save"panel_v5_wide_cluster", replace
****************************************
* END








****************************************
* R prepa
****************************************
cls
graph drop _all
use"panel_v5_wide_cluster", clear
order HHID_panel

********** R preparation data
***** Rename
foreach y in 2010 2016 2020 {
rename cro_DAR_without`y' cro_DAR`y'
rename DAR_without`y' DAR`y'
}

foreach x in ISR DSR DAR {
rename ihs_`x'10002010 ihs_`x'2010
rename ihs_`x'10002016 ihs_`x'2016
rename ihs_`x'10002020 ihs_`x'2020
}


***** Macro
global var1 annualincome log_annualincome ihs_annualincome cro_annualincome assets_noland log_assets_noland ihs_assets_noland cro_assets_noland yearly_expenses log_yearly_expenses ihs_yearly_expenses cro_yearly_expenses

global var2 DAR cro_DAR ihs_DAR DSR cro_DSR ihs_DSR ISR cro_ISR ihs_ISR  loanamount cro_loanamount ihs_loanamount

global var3 shareagri sharenagri

global var4 rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_repay_amt_HH eco_HH current_HH humank_HH social_HH home_HH repay_amt_HH ihs_informal_HH ihs_formal_HH ihs_eco_HH ihs_current_HH ihs_humank_HH ihs_social_HH ihs_home_HH ihs_repay_amt_HH

global var5 rel_formal_HH rel_informal_HH formal_HH informal_HH

global var6 villageid villagearea

global var7 ihs_rel_informal_HH ihs_rel_formal_HH ihs_rel_eco_HH ihs_rel_current_HH ihs_rel_humank_HH ihs_rel_social_HH ihs_rel_home_HH ihs_rel_repay_amt_HH

***** Date format
foreach x in $var1 $var2 $var3 $var4 $var5 $var6 $var7 {
rename `x'2010 `x'1
rename `x'2016 `x'2
rename `x'2020 `x'3
}

***** 1K INR for amount
foreach x in annualincome loanamount yearly_expenses assets_noland {
replace `x'1=`x'1/1000
replace `x'2=`x'2/1000
replace `x'3=`x'3/1000
}

***** HH and amt rename
foreach x in informal formal eco current humank social home repay_amt {
rename `x'_HH1 `x'1
rename `x'_HH2 `x'2
rename `x'_HH3 `x'3

rename rel_`x'_HH1 rel_`x'1
rename rel_`x'_HH2 rel_`x'2
rename rel_`x'_HH3 rel_`x'3

rename ihs_`x'_HH1 ihs_`x'1
rename ihs_`x'_HH2 ihs_`x'2
rename ihs_`x'_HH3 ihs_`x'3

rename ihs_rel_`x'_HH1 ihs_rel_`x'1
rename ihs_rel_`x'_HH2 ihs_rel_`x'2
rename ihs_rel_`x'_HH3 ihs_rel_`x'3
}

foreach x in repay {
rename `x'_amt1 `x'1
rename rel_`x'_amt1 rel_`x'1
rename ihs_rel_`x'_amt1 ihs_rel_`x'1

rename `x'_amt2 `x'2
rename rel_`x'_amt2 rel_`x'2
rename ihs_rel_`x'_amt2 ihs_rel_`x'2

rename `x'_amt3 `x'3
rename rel_`x'_amt3 rel_`x'3
rename ihs_rel_`x'_amt3 ihs_rel_`x'3
}


***** N/A
foreach x in ihs_ISR1 ihs_DAR1 ihs_DSR1 ihs_loanamount1 ihs_annualincome1 ihs_assets_noland1 ihs_yearly_expenses1 ihs_informal1 ihs_rel_informal1 ihs_formal1 ihs_rel_formal1 ihs_eco1 ihs_rel_eco1 ihs_current1 ihs_rel_current1 ihs_humank1 ihs_rel_humank1 ihs_social1 ihs_rel_social1 ihs_home1 ihs_rel_home1 ihs_repay_amt1 ihs_rel_repay1 ihs_ISR2 ihs_DAR2 ihs_DSR2 ihs_loanamount2 ihs_annualincome2 ihs_assets_noland2 ihs_yearly_expenses2 ihs_informal2 ihs_rel_informal2 ihs_formal2 ihs_rel_formal2 ihs_eco2 ihs_rel_eco2 ihs_current2 ihs_rel_current2 ihs_humank2 ihs_rel_humank2 ihs_social2 ihs_rel_social2 ihs_home2 ihs_rel_home2 ihs_repay_amt2 ihs_rel_repay2 ihs_ISR3 ihs_DAR3 ihs_DSR3 ihs_loanamount3 ihs_annualincome3 ihs_assets_noland3 ihs_yearly_expenses3 ihs_informal3 ihs_rel_informal3 ihs_formal3 ihs_rel_formal3 ihs_eco3 ihs_rel_eco3 ihs_current3 ihs_rel_current3 ihs_humank3 ihs_rel_humank3 ihs_social3 ihs_rel_social3 ihs_home3 ihs_rel_home3 ihs_repay_amt3 ihs_rel_repay3  rel_formal2 rel_informal2 rel_eco2 rel_current2 rel_humank2 rel_social2 rel_home2 rel_other_HH2016 rel_repay2 rel_formal2 rel_informal2 rel_eco2 rel_current2 rel_humank2 rel_social2 rel_home2 rel_other_HH2016 rel_repay2 rel_formal3 rel_informal3 rel_eco3 rel_current3 rel_humank3 rel_social3 rel_home3 rel_other_HH2020 rel_repay3 {
replace `x'=0 if `x'==.
}



********** Files
/*
foreach x in formal informal eco current humank social home repay {
***** Data
preserve
keep HHID_panel rel_`x'1 rel_`x'2 rel_`x'3
drop if rel_`x'1==0 & rel_`x'2==0 & rel_`x'3==0
drop if rel_`x'1==100 & rel_`x'2==100 & rel_`x'3==100

rename rel_`x'1 rel_var1
rename rel_`x'2 rel_var2
rename rel_`x'3 rel_var3

export delimited using "$git\Analysis\Overindebtedness\dt_`x'.csv", replace
restore
}
*/


********* R analysis

********* Hierarchical
***** IHS
foreach var in annualincome assets_noland loanamount DSR ISR DAR {
cluster wardslinkage ihs_`var'1 ihs_`var'2 ihs_`var'3, measure(Euclidean)
cluster dendrogram, cutnumber(100) title("`var'") name(`var'_tree, replace)
}

***** Relative
foreach var in formal eco current humank social home repay {
cluster wardslinkage rel_`var'1 rel_`var'2 rel_`var'3, measure(Euclidean)
cluster dendrogram, cutnumber(100) title("`var'") name(`var'_tree, replace)
}


********** Partitional
***** IHS
*** k=3
foreach var in annualincome assets_noland loanamount ISR {
cluster kmeans ihs_`var'1 ihs_`var'2 ihs_`var'3, k(3) measure(Euclidean) start(everyk) name(cl_`var')
}
*** k=4
foreach var in DSR DAR {
cluster kmeans ihs_`var'1 ihs_`var'2 ihs_`var'3, k(4) measure(Euclidean) start(everyk) name(cl_`var')
}

***** Rel
*** k=3
foreach var in formal eco humank social home {
cluster kmeans rel_`var'1 rel_`var'2 rel_`var'3, k(3) measure(Euclidean) start(everyk) name(cl_`var')
}

*** k=4
foreach var in current repay {
cluster kmeans rel_`var'1 rel_`var'2 rel_`var'3, k(4) measure(Euclidean) start(everyk) name(cl_`var')
}


********** Reshape
*** k=3
reshape long ihs_annualincome ihs_assets_noland ihs_loanamount ihs_DSR ihs_ISR ihs_DAR rel_formal rel_eco rel_current rel_humank rel_social rel_home rel_repay, i(panelvar) j(time)

foreach var in annualincome assets_noland loanamount ISR formal eco humank social home {
sort cl_`var' panelvar time
forvalues i=1(1)3{
twoway (line ihs_`var' time if cl_`var'==`i', c(L) lcolor(black%10)) ///
, xtitle("Time") ///
ylabel() ymtick() ytitle("`var'") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_`var'_`i', replace)
}
}

*** k=4
foreach var in DSR DAR current repay {
sort cl_`var' panelvar time
forvalues i=1(1)4{
twoway (line ihs_`var' time if cl_`var'==`i', c(L) lcolor(black%10)) ///
, xtitle("Time") ///
ylabel() ymtick() ytitle("`var'") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_`var'_`i', replace)
}
}










********** Graph cluster
import delimited using "$git\Analysis\Overindebtedness\debttrendRreturn.csv", clear

rename hhid_panel HHID_panel
encode HHID_panel, gen(panelvar)
drop v1

preserve
import delimited using "$git\Analysis\Overindebtedness\debttrendRreturn_v2.csv", clear
rename hhid_panel HHID_panel
keep HHID_panel cl_loan
save"$git\Analysis\Overindebtedness\debttrendRreturn_v2.dta", replace
restore

merge 1:1 HHID_panel using "$git\Analysis\Overindebtedness\debttrendRreturn_v2.dta"
drop _merge

erase "$git\Analysis\Overindebtedness\debttrendRreturn_v2.dta"

order HHID_panel panelvar
sort HHID_panel

save"panel_v6_wide_cluster", replace
****************************************
* END








****************************************
* Line following classification
****************************************
cls
graph drop _all
use"panel_v6_wide_cluster", clear


***** Var to keep
keep HHID_panel panelvar cl_* loanamount1 loanamount2 loanamount3 annualincome1 annualincome2 annualincome3 assets_noland1 assets_noland2 assets_noland3 yearly_expenses1 yearly_expenses2 yearly_expenses3 log_*


***** Reshape
reshape long loanamount annualincome assets_noland yearly_expenses log_loanamount log_annualincome log_assets_noland log_yearly_expenses, i(HHID_panel) j(time)


***** Panel declaration
xtset panelvar time


***** Add 6 missings in loanamount
order HHID_panel time cl_loanamount log_loanamount
sort cl_loanamount HHID_panel time
replace cl_loanamount=2 if HHID_panel=="GOV29"
replace cl_loanamount=2 if HHID_panel=="KAR29"
replace cl_loanamount=2 if HHID_panel=="KAR3"
replace cl_loanamount=2 if HHID_panel=="ORA52"

replace cl_loanamount=3 if HHID_panel=="GOV22"
replace cl_loanamount=3 if HHID_panel=="GOV4"

ta cl_assets_noland time
recode cl_assets_noland (2=1) (3=2) (4=3)


***** Label of categories
label define cl_annualincome 1"Inc-Sta" 2"Inc-Dec" 3"Dec-Inc"
label define cl_loanamount 1"Inc-Inc" 2"Dec-Inc" 3"Inc-Dec"
label define cl_assets_noland 1"Dec-Inc" 2"Dec-Dec" 3"Inc-Dec"
label define cl_yearly_expenses 1"Inc-Sta" 2"Dec-Inc" 3"Dec-Dec" 4"Inc-Dec"

label values cl_annualincome cl_annualincome
label values cl_loanamount cl_loanamount
label values cl_assets_noland cl_assets_noland
label values cl_yearly_expenses cl_yearly_expenses


***** Reshape for merging
keep HHID_panel cl_*
duplicates drop

rename cl_loanamount cl_loanamount_clean
rename cl_annualincome cl_annualincome_clean
rename cl_assets_noland cl_assets_noland_clean
rename cl_yearly_expenses cl_yearly_expenses_clean

merge 1:1 HHID_panel using "panel_v5_wide_cluster"
drop _merge

*drop ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_DAR_without_1 ce_DAR_without_2 ce_DAR_without_3 ce_DAR_without_4 ce_DAR_without_5 ce_DAR_without_6 ce_loanamount_1 ce_loanamount_2 ce_loanamount_3 ce_loanamount_4 ce_loanamount_5 ce_loanamount_6 ce_income_1 ce_income_2 ce_income_3 ce_income_4 ce_income_5 ce_income_6 ce_assetsnl_1 ce_assetsnl_2 ce_assetsnl_3 ce_assetsnl_4 ce_assetsnl_5 ce_assetsnl_6

order cl_*, last

rename cl_loanamount_clean cl_loanamount
rename cl_annualincome_clean cl_annualincome
rename cl_assets_noland_clean cl_assets_noland
rename cl_yearly_expenses_clean cl_yearly_expenses

label var cl_loanamount "Debt"
label var cl_annualincome "Income"
label var cl_assets_noland "Assets"
label var cl_yearly_expenses "Expenses"

fre cl_*


*** Check supplementary variables
rename villageid2016 villageid
drop villageid2010 villageid2020

ta villagearea2010 villagearea2016
ta villagearea2016 villagearea2020
gen villagearea=villagearea2016
drop villagearea2010 villagearea2016 villagearea2020

ta caste
ta jatis


save"panel_v7_wide_cluster", replace

export delimited using "$git\Analysis\Overindebtedness\debttrend_v3.csv", replace
****************************************
* END









****************************************
* Clean line trends
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear

***** Var to keep
keep HHID_panel panelvar cl_* loanamount2010 loanamount2016 loanamount2020 annualincome2010 annualincome2016 annualincome2020 assets_noland2010 assets_noland2016 assets_noland2020 yearly_expenses2010 yearly_expenses2016 yearly_expenses2020 log_* DSR2010 DSR2016 DSR2020 ISR2010 ISR2016 ISR2020 DAR_without2010 DAR_without2016 DAR_without2020


***** Reshape
reshape long loanamount annualincome assets_noland yearly_expenses log_loanamount log_annualincome log_assets_noland log_yearly_expenses ISR DSR DAR_without, i(HHID_panel) j(year)


***** Panel declaration
xtset panelvar year


***** Line graph
tabstat log_loanamount log_annualincome log_assets_noland log_yearly_expenses, stat(n mean sd p50 min max)
fre cl_*

set graph off

*** Loan amount
sort cl_loanamount panelvar year
forvalues i=1(1)3{
twoway (line log_loanamount year if cl_loanamount==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(3)15) ymtick(0(1)15) ytitle("log(Loan amount)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_loanamount_`i', replace)
}
graph combine gph_loanamount_1 gph_loanamount_2 gph_loanamount_3, col(3) name(gph_loanamount, replace)



*** Annual income
sort cl_annualincome panelvar year
forvalues i=1(1)3{
twoway (line log_annualincome year if cl_annualincome==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(6(2)14) ymtick(6(1)14) ytitle("log(Income)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_annualincome_`i', replace)
}
graph combine gph_annualincome_1 gph_annualincome_2 gph_annualincome_3, col(3) name(gph_annualincome, replace) 



*** Assets
sort cl_assets_noland panelvar year
forvalues i=1(1)3{
twoway (line log_assets_noland year if cl_assets_noland==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(6(2)16) ymtick(6(1)16) ytitle("log(Assets)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_assets_noland_`i', replace)
}
graph combine gph_assets_noland_1 gph_assets_noland_2 gph_assets_noland_3, col(4) name(gph_assets_noland, replace)



*** Expenses
sort cl_yearly_expenses panelvar year
forvalues i=1(1)4{
twoway (line log_yearly_expenses year if cl_yearly_expenses==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(8(2)14) ymtick(8(1)14) ytitle("log(Expenses)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_yearly_expenses_`i', replace)
}
graph combine gph_yearly_expenses_1 gph_yearly_expenses_2 gph_yearly_expenses_3 gph_yearly_expenses_4, col(4) name(gph_yearly_expenses, replace)

set graph on



*** Combine all in the same
graph combine gph_assets_noland gph_annualincome gph_loanamount, col(1) name(comb_gph, replace)
graph export "graph/comb_gph.pdf", as(pdf) replace

****************************************
* END
*/










****************************************
* Statistics following classification
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear


set graph off

********** MCA without expenses
mca cl_loanamount cl_annualincome cl_assets_noland, meth(ind) normal(princ) dim(4) comp
mcacontrib
matrix list e(F)
matrix list NewContrib
matrix coord=e(F)
svmat coord, names(varcoord)
mat mcamat=e(cGS)
mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2 co3 rel3 abs3 co4 rel4 abs4 
svmat2 mcamat, rname(varname) name(col)
gen varname2=""
gen n=_n
replace varname2="Debt" if n==1 | n==2 | n==3
replace varname2="Income" if n==4 | n==5 | n==6
replace varname2="Assets" if n==7 | n==8 | n==9
drop n
predict d1_nf d2_nf

*** Inertia
input dim inertia perc totperc
1 0.43 	21.75 	21.75
2 0.40 	19.98 	41.72
3 0.36 	18.02 	59.74
4 0.29 	14.66 	74.40
5 0.27 	13.39 	87.79
6 0.24 	12.21 	100.00 
end

graph bar perc, over(dim) b1title("Dimension") ytitle("% of variance") note("Decomposition of the total inertia.", size(tiny)) name(inertia, replace)


*** Plot var
egen labpos=mlabvpos(varcoord2 varcoord1)
replace labpos=3 if varname=="Inc-Inc" & varname2=="Debt"
replace labpos=3 if varname=="Inc-Sta" & varname2=="Income"
replace labpos=3 if varname=="Inc-Dec" & varname2=="Debt"
replace labpos=3 if varname=="Inc-Dec" & varname2=="Income"
replace labpos=1 if varname=="Dec-Dec" & varname2=="Assets"
replace labpos=9 if varname=="Dec-Inc" & varname2=="Assets"
replace labpos=9 if varname=="Dec-Inc" & varname2=="Debt"
replace labpos=3 if varname=="Dec-Inc" & varname2=="Income"

twoway ///
(scatter varcoord2 varcoord1 if varname2=="Assets", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="Debt", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="Income", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
, xtitle("Dimension 1 (21.7%)") ytitle("Dimension 2 (20.0%)") ///
legend(pos(7) col(3) order(1 "Assets" 2 "Debt" 3 "Income")) aspectratio(1) ///
name(var, replace)

*** Plot individual
scatter d2_nf d1_nf,  xline(0) yline(0) xtitle("Dimension 1 (21.7%)") ytitle("Dimension 2 (20.0%)") msym(o) aspectratio(1) name(indiv, replace)

*** Combine
grc1leg var indiv, name(mca_comb, replace) col(2)



********** Classification
cluster wardslinkage d1_nf d2_nf, measure(L2squared)


*** Plot branch
cluster dendrogram, cutnumber(20) xtitle("Group") ytitle("Squared euclidean dissimilarity measure") title("") xlabel(1(1)20, ang(0)) yline(150) name(htree, replace) aspectratio(1)
cluster gen cl_new=groups(3)
fre cl_new


*** Plot indiv
twoway ///
(scatter d2_nf d1_nf if cl_new==1, xline(0) yline(0) msym(o)) ///
(scatter d2_nf d1_nf if cl_new==2, msym(s)) ///
(scatter d2_nf d1_nf if cl_new==3, msym(d)) ///
, xtitle("Dimension 1 (21.7%)") ytitle("Dimension 2 (20.0%)") ///
legend(pos(6) col(3) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3")) ///
name(clus, replace) aspectratio(1)

*** Combine
grc1leg htree clus, leg(clus) name(hac_comb, replace)


*** Characterise cluster
*Excel file directly



********** Rename and label
rename cl_new vuln_cl

label define vuln_cl 1"Less-vulnerable" 2"Vulnerable" 3"Ex-vulnerable"
label values vuln_cl vuln_cl

set graph on


********** Graph export
/*
graph display inertia
graph export "graph/inertia.pdf", as(pdf)

graph display mca_comb
graph export "graph/mca_comb.pdf", as(pdf)

graph display hac_comb
graph export "graph/hac_comb.pdf", as(pdf)
*/


save"panel_v8_wide_cluster", replace

****************************************
* END
