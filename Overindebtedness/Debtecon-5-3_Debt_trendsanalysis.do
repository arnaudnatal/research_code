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


***** Clean
drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020


***** Keep
keep HHID_panel panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* annualincome* assets_noland* yearly_expenses* ISR* DIR* $var $var2 $var3 $var4 $var5

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
foreach x in annualincome DSR loanamount DIR villageid yearly_expenses assets_noland villagearea DAR_without ISR log_yearly_expenses log_annualincome log_assets_noland log_assets log_loanamount {
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

export delimited using "$git\Analysis\Overindebtedness\debttrend.csv", replace

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
foreach x in assets_noland yearly_expenses  assets_noland {
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


***** Label of categories
label define cl_annualincome 1"/¯" 2"¯\" 3"\/"
label define cl_loanamount 1"/¯" 2"\/" 3"/\"
label define cl_assets_noland 1"_/" 2"\/" 3"\" 4"/¯"
label define cl_yearly_expenses 1"/¯" 2"\/" 3"\" 4"/\"

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

fre cl_*


save"panel_v7_wide_cluster", replace
****************************************
* END










****************************************
* Statistics following classification
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear


***** Cross tabulation
ta cl_loanamount caste, col nofreq
ta cl_assets_noland caste, col nofreq
ta cl_annualincome caste, col nofreq
ta cl_yearly_expenses caste, col nofreq




***** MCA
mca cl_loanamount cl_annualincome cl_assets_noland, meth(ind) normal(princ) dim(4) comp sup(caste)
mcacontrib
*matrix list e(A)
*matrix coord=e(A)
*svmat coord, names(varcoord)
*graph3d varcoord1 varcoord2 varcoord3, cuboid xlabel("Dim1 ") ylabel("Dim 2") zlabel("Dim 3")

***** Plot
mcaplot, overlay xline(0) yline(0) dim(2 1) 
mcaplot, overlay xline(0) yline(0) dim(3 1)


****************************************
* END










/*
****************************************
* Time trends analysis with continuous 
****************************************
*** Guerin et al 2015: income, assets and loanamount
*** Fareed et al 2019: DSR, DAR and income

cls
graph drop _all
use"panel_v5_wide_cluster", clear


***** HCA for nb of clust
foreach x in loanamount DSR ISR assets_noland annualincome DAR_without {
global var `x'std2010 `x'std2016 `x'std2020
*** HCA
cluster wardslinkage $var, measure(Euclidean)
*** Dendrogram
cluster dendrogram, horizontal cutnumber(15) countinline showcount name(dendro_`x', replace)
}


***** Kmeans: k=4
foreach x in loanamount ISR assets_noland annualincome {
global var `x'std2010 `x'std2016 `x'std2020
cluster kmeans $var, k(4) start(everyk) name(cl_`x')
}


***** Kmeans: k=3
foreach x in DSR DAR_without {
global var `x'std2010 `x'std2016 `x'std2020
cluster kmeans $var, k(3) start(everyk) name(cl_`x')
}


***** Center of cluster
foreach x in loanamount DSR ISR assets_noland annualincome DAR_without {
foreach t in 2010 2016 2020 {
bysort cl_`x': egen `x'stdmean`t'=mean(`x'std`t')
}
}


***** Reshape + panel
keep panelvar caste jatis villagearea villageid cl_* loanamount* DSR* ISR* assets_noland* annualincome* DAR_without*

reshape long loanamount annualincome DSR assets_noland DAR_without ISR DSRstd DAR_withoutstd annualincomestd assets_nolandstd ISRstd loanamountstd loanamountstdmean DSRstdmean ISRstdmean assets_nolandstdmean annualincomestdmean DAR_withoutstdmean, i(panelvar) j(year)

xtset panelvar year


set graph off
***** Line graph --> k=3
foreach x in DSR DAR_without{
foreach g in 1 2 3 {
sort cl_`x' panelvar year
twoway (line `x'std year if cl_`x'==`g', c(L) lcolor(red%10)) (line `x'stdmean year if cl_`x'==`g', c(L) lcolor(blue) lwidth(medium)), name(line_`x'_k`g', replace)
}
grc1leg line_`x'_k1 line_`x'_k2 line_`x'_k3, name(line_`x', replace)
}



***** Line graph --> k=4
foreach x in loanamount ISR assets_noland annualincome{
foreach g in 1 2 3 4 {
sort cl_`x' panelvar year
twoway (line `x'std year if cl_`x'==`g', c(L) lcolor(red%10)) (line `x'stdmean year if cl_`x'==`g', c(L) lcolor(blue) lwidth(medium)), name(line_`x'_k`g', replace)
}
grc1leg line_`x'_k1 line_`x'_k2 line_`x'_k3 line_`x'_k4, name(line_`x', replace)
}

set graph on


***** Display
graph display line_loanamount
graph display line_DSR
graph display line_ISR
graph display line_DAR_without
graph display line_assets_noland
graph display line_annualincome

****************************************
* END
