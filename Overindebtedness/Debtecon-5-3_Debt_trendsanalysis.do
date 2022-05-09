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
* Datasets preparation
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

encode HHID_panel, gen(panelvar)

********** Cross section verification of DSR/loanamount
tabstat loanamount2010 loanamount2016 loanamount2020, stat(n mean sd q)
tabstat DSR2010 DSR2016 DSR2020, stat(n mean sd q)

********** Var to use
global varcat ce_DSR ce_DAR_without ce_loanamount ce_income ce_assetsnl
foreach x in $varcat {
tab `x', gen(`x'_)
}

global var ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_DAR_without_1 ce_DAR_without_2 ce_DAR_without_3 ce_DAR_without_4 ce_DAR_without_5 ce_DAR_without_6 ce_loanamount_1 ce_loanamount_2 ce_loanamount_3 ce_loanamount_4 ce_loanamount_5 ce_loanamount_6 ce_assetsnl_1 ce_assetsnl_2 ce_assetsnl_3 ce_assetsnl_4 ce_assetsnl_5 ce_assetsnl_6 ce_income_1 ce_income_2 ce_income_3 ce_income_4 ce_income_5 ce_income_6 ce_DSR ce_DAR_without ce_loanamount ce_assetsnl ce_income

global var2 d1_loanamount d1_DIR d1_DAR_without d1_DSR d1_ISR d1_annualincome d1_assets_noland d1_yearly_expenses d2_loanamount d2_DIR d2_DAR_without d2_DSR d2_ISR d2_annualincome d2_assets_noland d2_yearly_expenses

global var3 cro_DSR2010 cro_DSR2016 cro_DSR2020 cro_annualincome2010 cro_annualincome2016 cro_annualincome2020 cro_loanamount2010 cro_loanamount2016 cro_loanamount2020 cro_assets_noland2010 cro_assets_noland2016 cro_assets_noland2020 cro_annualincome2010 cro_annualincome2016 cro_annualincome2020

global var4 ihs_DSR_10002010 ihs_DSR_10002016 ihs_DSR_10002020 ihs_annualincome2010 ihs_annualincome2016 ihs_annualincome2020 ihs_loanamount2010 ihs_loanamount2016 ihs_loanamount2020 ihs_assets_noland2010 ihs_assets_noland2016 ihs_assets_noland2020 ihs_annualincome2010 ihs_annualincome2016 ihs_annualincome2020 ihs_DSR_1002010 ihs_DSR_1002016 ihs_DSR_1002020

global var5 log_yearly_expenses2010 log_annualincome2010 log_assets_noland2010 log_assets2010 log_loanamount2010 log_yearly_expenses2016 log_annualincome2016 log_assets_noland2016 log_assets2016 log_loanamount2016 log_yearly_expenses2020 log_annualincome2020 log_assets_noland2020 log_assets2020 log_loanamount2020

global var6 head_edulevel2010 head_occupation2010 wifehusb_edulevel2010 wifehusb_occupation2010 mainocc_occupation2010 cat_income cat_assets sizeownland2010 DSR302010 DSR402010 DSR502010 path_30 path_40 path_50

ta sizeownland2010
gen dummyownland2010=1
replace dummyownland2010=0 if sizeownland2010==.
ta dummyownland2010

***** Clean
drop DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020


***** Keep
keep HHID_panel panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* DAR_with* annualincome* assets_noland* yearly_expenses* ISR* DIR* $var $var2 $var3 $var4 $var5 $var6 dummyownland2010

/*
reshape long villagearea villageid DSR DAR_without annualincome assets_noland yearly_expenses ISR loanamount DIR cro_DSR cro_annualincome cro_loanamount cro_assets_noland ihs_DSR_1000 ihs_DSR_100 ihs_annualincome ihs_loanamount ihs_assets_noland, i(panelvar) j(year)



* By year
foreach x in DSR DAR_without annualincome assets_noland yearly_expenses ISR loanamount DIR {
sum `x'
gen `x'std=.
replace `x'std=(`x'-r(mean))/r(sd)
}


*Reshape
reshape wide DSR* DAR_without* annualincome* assets_noland* yearly_expenses* ISR* loanamount* DIR*, i(panelvar) j(year)
*/

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
drop panelvar
order HHID_panel

********** R preparation data
foreach x in annualincome DSR loanamount DIR villageid yearly_expenses assets_noland villagearea DAR_without DAR_with ISR log_yearly_expenses log_annualincome log_assets_noland log_assets log_loanamount {
rename `x'2010 `x'1
rename `x'2016 `x'2
rename `x'2020 `x'3
}

foreach x in annualincome loanamount yearly_expenses assets_noland {
replace `x'1=`x'1/1000
replace `x'2=`x'2/1000
replace `x'3=`x'3/1000
}

/*
order HHID_panel loanamount1 log_loanamount1 loanamount2 log_loanamount2 loanamount3 log_loanamount3
sort loanamount1
sort loanamount2
sort loanamount3
*/

/*
replace log_loanamount1=4.6051702 if log_loanamount1==0
replace log_loanamount2=4.6051702 if log_loanamount2==0
replace log_loanamount3=4.6051702 if log_loanamount3==0
*/

*** For debt
preserve
drop if log_loanamount1==0
drop if log_loanamount2==0
drop if log_loanamount3==0

export delimited using "$git\Analysis\Overindebtedness\debttrend_v2.csv", replace
restore

tabstat DAR_without1 DAR_without2 DAR_without3,stat(min p1 p5 p10 q p90 p95 p99 max)

tabstat DAR_with1 DAR_with2 DAR_with3,stat(min p1 p5 p10 q p90 p95 p99 max)

export delimited using "$git\Analysis\Overindebtedness\debttrend.csv", replace

tabstat DAR_without1 DAR_without2 DAR_without3 DAR_with1 DAR_with2 DAR_with3, stat(n mean sd p50 min max)

foreach x in DAR_without1 DAR_without2 DAR_without3 DAR_with1 DAR_with2 DAR_with3 {
count if `x'==0
}

tabstat assets_noland1 assets_noland2 assets_noland3, stat(n mean sd p50 min max)


********* R analysis


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


/*
***** Desc
tabstat log_loanamount log_annualincome log_assets_noland log_yearly_expenses, stat(n mean sd min max)



***** Line graph
foreach x in loanamount annualincome assets_noland yearly_expenses {
forvalues i=1(1)5 {
capture confirm v cl_`x'_`i'
if _rc==0 {
drop cl_`x'_`i'
}
}
}

set graph off
foreach x in loanamount annualincome assets_noland yearly_expenses {
ta cl_`x', gen(cl_`x'_)
forvalues i=1(1)5 {
capture confirm v cl_`x'_`i'
if _rc==0 {
sort cl_`x' panelvar time
*twoway (line `x' time if cl_`x'==`i', c(L) lcolor(red%10)), name(`x'_cl`i', replace)
sum log_`x'
local min=r(min)
local max=r(max)
twoway (line log_`x' time if cl_`x'==`i', c(L) lcolor(red%10)), ylabel(`min'(1)`max') aspectratio(1) name(log_`x'_cl`i', replace)
}
}
}


***** Combine
graph dir
foreach x in assets_noland yearly_expenses {
graph combine log_`x'_cl1 log_`x'_cl2 log_`x'_cl3 log_`x'_cl4, col(2) name(comb_log_`x', replace)
}

foreach x in  annualincome loanamount {
graph combine log_`x'_cl1 log_`x'_cl2 log_`x'_cl3, col(2) name(comb_log_`x', replace)
}


***** Display
/*
set graph on
foreach x in loanamount annualincome assets_noland yearly_expenses {
graph display comb_log_`x'
}
*/
*/


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

drop ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_DAR_without_1 ce_DAR_without_2 ce_DAR_without_3 ce_DAR_without_4 ce_DAR_without_5 ce_DAR_without_6 ce_loanamount_1 ce_loanamount_2 ce_loanamount_3 ce_loanamount_4 ce_loanamount_5 ce_loanamount_6 ce_income_1 ce_income_2 ce_income_3 ce_income_4 ce_income_5 ce_income_6 ce_assetsnl_1 ce_assetsnl_2 ce_assetsnl_3 ce_assetsnl_4 ce_assetsnl_5 ce_assetsnl_6

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
* Statistics following classification
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear


********** MCA without expenses
mca cl_loanamount cl_annualincome cl_assets_noland, meth(ind) normal(princ) dim(4) comp
mcacontrib
matrix list e(A)
matrix list NewContrib
*matrix coord=e(A)
*svmat coord, names(varcoord)
*mat mcamat=e(cGS)
*mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2 co3 rel3 abs3 co4 rel4 abs4 
*svmat2 mcamat, rname(varname) name(col)
predict d1_nf d2_nf

*** Statistics
*tabstat mass rel1 abs1 rel2 abs2 rel3 abs3 rel4 abs4, stat(mean sum)

*** Plot var
mcaplot, overlay xline(0) yline(0) dim(2 1) legend(pos(6) col(3) order(1 "Debt" 2 "Income" 3 "Assets")) note("") name(mca_var_4, replace)

*** Plot individual
scatter d2_nf d1_nf,  xline(0) yline(0) name(indiv, replace)


********** Classification
cluster wardslinkage d1_nf d2_nf
cluster dendrogram, cutnumber(20)
cluster gen cl_new=groups(3)
fre cl_new


********** Graph rpz
twoway ///
(scatter d2_nf d1_nf if cl_new==1, xline(0) yline(0)) ///
(scatter d2_nf d1_nf if cl_new==2, msymbol(+)) ///
(scatter d2_nf d1_nf if cl_new==3, msymbol(oh))

ta cl_new cl_assets_noland, row nofreq
ta cl_new cl_annualincome, row nofreq
ta cl_new cl_loanamount, row nofreq


****************************************
* END











/*
****************************************
* Clean line trends
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear

***** Var to keep
keep HHID_panel panelvar cl_* loanamount2010 loanamount2016 loanamount2020 annualincome2010 annualincome2016 annualincome2020 assets_noland2010 assets_noland2016 assets_noland2020 yearly_expenses2010 yearly_expenses2016 yearly_expenses2020 log_*


***** Reshape
reshape long loanamount annualincome assets_noland yearly_expenses log_loanamount log_annualincome log_assets_noland log_yearly_expenses, i(HHID_panel) j(year)


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


***** Display
/*
graph display gph_loanamount
graph export "graph/gph_loanamount.pdf", as(pdf) replace

graph display gph_assets_noland
graph export "graph/gph_assets_noland.pdf", as(pdf) replace

graph display gph_annualincome
graph export "graph/gph_annualincome.pdf", as(pdf) replace

graph display gph_yearly_expenses
graph export "graph/gph_yearly_expenses.pdf", as(pdf) replace
*/
****************************************
* END
*/






****************************************
* Vulnerable groups
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear

foreach x in loanamount assets_noland yearly_expenses annualincome {
foreach i in 2010 2016 2020 {
replace `x'`i'=`x'`i'/1000
}
}

***** Path verif
fre cl_loanamount cl_assets_noland cl_annualincome


***** Values
foreach x in loanamount annualincome assets_noland yearly_expenses {
tabstat `x'2010 `x'2016 `x'2020, stat(n mean q) by(cl_`x')
}

ta cl_loanamount cl_assets_noland, cell nofreq



****************************************
* END
