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

tabstat repay1 repay2 repay3, stat(n mean sd p50)
tabstat rel_repay1 rel_repay2 rel_repay3, stat(n mean sd p50)

export delimited using "$git\Analysis\Overindebtedness\debttrend.csv", replace

********* R analysis

********* Hierarchical
/*
foreach var in annualincome assets_noland loanamount DSR ISR DAR {
cluster wardslinkage ihs_`var'1 ihs_`var'2 ihs_`var'3, measure(Euclidean)
cluster dendrogram, cutnumber(100) title("`var'") name(`var'_tree, replace)
}
*/


********** Graph cluster
import delimited using "$git\Analysis\Overindebtedness\debttrend_v2.csv", clear
drop panelvar
rename hhid_panel HHID_panel
encode HHID_panel, gen(panelvar)
drop v1
order HHID_panel panelvar
sort HHID_panel


******* Assign 2+5 to another category -->DSR
ta sbd_dsr
replace sbd_dsr=4 if sbd_dsr==5 & ihs_dsr2==0
replace sbd_dsr=1 if sbd_dsr==5 & ihs_dsr1==0 & ihs_dsr3!=0

dis 7*100/382


******* Assign 16+15+6 to another category -->DSR
ta sbd_isr
replace sbd_isr=1 if sbd_isr==5 & ihs_isr2==0
replace sbd_isr=4 if sbd_isr==5 & ihs_isr1==0 & ihs_isr3!=0
replace sbd_isr=4 if sbd_isr==5 & ihs_isr3>5
dis 37*100/382

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

global suppvar cat_income cat_assets caste jatis villageid1 villagearea1 villageid2 villagearea2 villageid3 villagearea3

keep HHID_panel panelvar $suppvar euc_* sbd_* loanamount1 loanamount2 loanamount3 annualincome1 annualincome2 annualincome3 assets_noland1 assets_noland2 assets_noland3 dsr1 ihs_dsr1 dsr2 ihs_dsr2 dsr3 ihs_dsr3 isr1 ihs_isr1 isr2 ihs_isr2 isr3 ihs_isr3 dar1 ihs_dar1 dar2 ihs_dar2 dar3 ihs_dar3 ihs_annualincome* ihs_assets_noland* ihs_loanamount*

***** Reshape
reshape long villageid villagearea annualincome dsr loanamount assets_noland dar isr ihs_isr ihs_dar ihs_dsr ihs_loanamount ihs_annualincome ihs_assets_noland, i(HHID_panel) j(time)

order HHID_panel panelvar time caste jatis cat_income cat_assets villageid villagearea

***** Panel declaration
xtset panelvar time

save"panel_v7_wide_cluster", replace
****************************************
* END









****************************************
* Clean line trends
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear


gen year=2010 if time==1
replace year=2016 if time==2
replace year=2020 if time==3


***** Panel declaration
xtset panelvar year

***** Line graph
set graph off
*** Assets
tabstat ihs_assets, stat(n mean p50 min max)
fre sbd_assets
forvalues i=1(1)4{
local d1="Dec-Dec"
local d2="Inc-Inc"
local d3="Dec-Inc"
local d4="DEC-INC"
local j="`d`i''"
twoway (line ihs_assets year if sbd_assets==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(7(2)17) ymtick() ytitle("Assets (ihs)") ///
title("Cluster `i': `j'") ///
aspectratio(0.5) ///
name(gph_assets_`i', replace)
}


*** DSR
tabstat ihs_dsr, stat(n mean p50 min max)
fre sbd_dsr
forvalues i=1(1)5{
local d1="INC-INC"
local d2="Inc-Inc"
local d3="Dec-Dec"
local d4="Dec-Inc"
local d5="Sta-Dec"
local j="`d`i''"
twoway (line ihs_dsr year if sbd_dsr==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(2)12) ymtick() ytitle("DSR (ihs)") ///
title("Cluster `i': `j'") ///
aspectratio(0.5) ///
name(gph_DSR_`i', replace)
}


*** DAR
tabstat ihs_dar, stat(n mean p50 min max)
fre sbd_dar
forvalues i=1(1)4{
local d1="Inc-Dec"
local d2="Inc-Inc"
local d3="Dec-Dec"
local d4="Dec-Inc"
local j="`d`i''"
twoway (line ihs_dar year if sbd_dar==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(2)12) ymtick() ytitle("DAR (ihs)") ///
title("Cluster `i': `j'") ///
aspectratio(0.5) ///
name(gph_DAR_`i', replace)
}


*** Debt
tabstat ihs_loanamount, stat(n mean p50 min max)
fre sbd_loanamount
forvalues i=1(1)3{
local d1="Inc-Dec"
local d2="Inc-Inc"
local d3="Dec-Inc"
local j="`d`i''"
twoway (line ihs_loanamount year if sbd_loanamount==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(2)16) ymtick() ytitle("Loan amount (ihs)") ///
title("Cluster `i': `j'") ///
aspectratio(0.5) ///
name(gph_loanamount_`i', replace)
}


***** Combine
set graph on
graph combine gph_assets_1 gph_assets_2 gph_assets_3 gph_assets_4, col(2) name(gph_assets, replace)
graph combine gph_DAR_1 gph_DAR_2 gph_DAR_3 gph_DAR_4, col(2) name(gph_DAR, replace)
graph combine gph_DSR_1 gph_DSR_2 gph_DSR_3 gph_DSR_4 gph_DSR_5, col(3) name(gph_DSR, replace)
graph combine gph_loanamount_1 gph_loanamount_2 gph_loanamount_3, col(2) name(gph_loanamount, replace)

***** Display
set graph on
foreach var in assets loanamount DAR DSR {
graph display gph_`var'
graph export "graph/trend_`var'.pdf", as(pdf)
}


********** Name
label define sbd_annualincome 	1"Dec-Inc" 2"Inc-Dec" 3"Sta-Dec" 4"Dec-Sta"
label define sbd_dar 			1"Inc-Dec" 2"Inc-Inc" 3"Dec-Dec" 4"Dec-Inc"
label define sbd_dsr 			1"INC-INC" 2"Inc-Inc" 3"Dec-Dec" 4"Dec-Inc" 5"Sta-Dec"
label define sbd_assets_noland 	1"Dec-Dec" 2"Inc-Inc" 3"Dec-Inc" 4"DEC-INC"
label define sbd_loanamount 	1"Inc-Dec" 2"Inc-Inc" 3"Dec-Inc"

label values sbd_annualincome sbd_annualincome
label values sbd_dar sbd_dar
label values sbd_dsr sbd_dsr
label values sbd_assets_noland sbd_assets_noland
label values sbd_loanamount sbd_loanamount

preserve
keep HHID_panel sbd_annualincome sbd_assets_noland sbd_loanamount sbd_dsr sbd_dar cat_income cat_assets jatis caste villageid villagearea
duplicates drop
export delimited using "$git\Analysis\Overindebtedness\debttrend_v3.csv", replace


save"panel_v8_wide_cluster", replace
****************************************
* END










/*
set graph off
foreach var in annualincome assets_noland loanamount dsr isr dar {
foreach type in euc sbd {

qui ta `type'_`var', gen(`type'_`var'_)
sort `type'_`var' panelvar year

qui sum ihs_`var'
local min=r(min)
local max=r(max)

forvalues i=1(1)6{

capture confirm v `type'_`var'_`i'
if _rc==0 {

twoway (line ihs_`var' year if `type'_`var'==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(`min'(1)`max') ymtick() ytitle("`var' with `type'") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_`type'_`var'_`i', replace)

drop `type'_`var'_`i'
}
}
}
}

*** if 3 graph
foreach x in euc_isr sbd_loanamount {
graph combine gph_`x'_1 gph_`x'_2 gph_`x'_3, col(3) name(gph_`x', replace)
}

*** if 4 graph
foreach x in euc_annualincome euc_assets_noland euc_dar euc_loanamount sbd_annualincome sbd_assets_noland sbd_dar {
graph combine gph_`x'_1 gph_`x'_2 gph_`x'_3 gph_`x'_4, col(2) name(gph_`x', replace)
}

*** if 5 graph
foreach x in euc_dsr sbd_dsr sbd_isr {
graph combine gph_`x'_1 gph_`x'_2 gph_`x'_3 gph_`x'_4 gph_`x'_5, col(2) name(gph_`x', replace)
}
*/
