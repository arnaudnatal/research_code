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

********** Var to use
global varcat ce_DSR ce_DAR_without ce_loanamount ce_income ce_assetsnl
foreach x in $varcat {
tab `x', gen(`x'_)
}

global var ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_DAR_without_1 ce_DAR_without_2 ce_DAR_without_3 ce_DAR_without_4 ce_DAR_without_5 ce_DAR_without_6 ce_loanamount_1 ce_loanamount_2 ce_loanamount_3 ce_loanamount_4 ce_loanamount_5 ce_loanamount_6 ce_assetsnl_1 ce_assetsnl_2 ce_assetsnl_3 ce_assetsnl_4 ce_assetsnl_5 ce_assetsnl_6 ce_income_1 ce_income_2 ce_income_3 ce_income_4 ce_income_5 ce_income_6 ce_DSR ce_DAR_without ce_loanamount ce_assetsnl ce_income

global var2 d1_loanamount d1_DIR d1_DAR_without d1_DSR d1_ISR d1_annualincome d1_assets_noland d1_yearly_expenses d2_loanamount d2_DIR d2_DAR_without d2_DSR d2_ISR d2_annualincome d2_assets_noland d2_yearly_expenses

global var3 cro_DSR2010 cro_DSR2016 cro_DSR2020 cro_annualincome2010 cro_annualincome2016 cro_annualincome2020 cro_loanamount2010 cro_loanamount2016 cro_loanamount2020 cro_assets_noland2010 cro_assets_noland2016 cro_assets_noland2020 cro_annualincome2010 cro_annualincome2016 cro_annualincome2020

global var4 ihs_DSR_10002010 ihs_DSR_10002016 ihs_DSR_10002020 ihs_annualincome2010 ihs_annualincome2016 ihs_annualincome2020 ihs_loanamount2010 ihs_loanamount2016 ihs_loanamount2020 ihs_assets_noland2010 ihs_assets_noland2016 ihs_assets_noland2020 ihs_annualincome2010 ihs_annualincome2016 ihs_annualincome2020 ihs_DSR_1002010 ihs_DSR_1002016 ihs_DSR_1002020


***** Clean
drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020


***** Keep
keep HHID_panel panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* annualincome* assets_noland* yearly_expenses* ISR* DIR* $var $var2 $var3 $var4

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

********** R preparation data
foreach x in annualincome DSR loanamount DIR villageid yearly_expenses assets_noland villagearea DAR_without ISR ihs_annualincome ihs_assets_noland ihs_loanamount ihs_DSR_1000 ihs_DSR_100 cro_annualincome cro_assets_noland cro_loanamount cro_DSR {
rename `x'2010 `x'1
rename `x'2016 `x'2
rename `x'2020 `x'3
}

/*
foreach t in 1 2 3 {
rename loanamount`t' loan`t'
rename annualincome`t' income`t'
rename yearly_expenses`t' expenses`t'
rename assets_noland`t' assets`t'
rename DAR_without`t' DAR`t'
rename DAR_withoutstd`t' DARstd`t'
rename annualincomestd`t' incomestd`t'
rename assets_nolandstd`t' assetsstd`t'
rename yearly_expensesstd`t' expensesstd`t'
rename loanamountstd`t' loanstd`t'
}
*/



export delimited using "$git\Analysis\Overindebtedness\debttrend.csv", replace

********* R analysis


********** Graph cluster
import delimited using "$git\Analysis\Overindebtedness\debttrendRreturn.csv", clear

tab1 cl_*

keep v1 cl_* loan1 loan2 loan3 income1 income2 income3 assets1 assets2 assets3 dsr1 dsr2 dsr3 dar1 dar2 dar3 expenses1 expenses2 expenses3

reshape long loan income assets dsr dar expenses, i(v1) j(time)

xtset v1 time

***** Line graph
set graph off
foreach x in loan income assets dsr dar expenses {
foreach stat in sbd {
ta cl_`x'_`stat', gen(cl_`x'_`stat'_)
forvalues i=1(1)8 {
capture confirm v cl_`x'_`stat'_`i'
if _rc==0 {
sort cl_`x'_`stat' v1 time
twoway (line `x' time if cl_`x'_`stat'==`i', c(L) lcolor(red%10)), name(`x'_`stat'_cl`i', replace)
}
}
}
}

***** Loan
graph combine loan_sbd_cl1 loan_sbd_cl2 loan_sbd_cl3 loan_sbd_cl4 loan_sbd_cl5 loan_sbd_cl6, name(comb_sbd_loan, replace)

*graph combine loan_dtw_cl1 loan_dtw_cl2 loan_dtw_cl3 loan_dtw_cl4, name(comb_dtw_loan, replace)

***** Income
graph combine income_sbd_cl1 income_sbd_cl2 income_sbd_cl3 income_sbd_cl4 income_sbd_cl5 income_sbd_cl6 income_sbd_cl7, name(comb_sbd_income, replace)

*graph combine income_dtw_cl1 income_dtw_cl2 income_dtw_cl3 income_dtw_cl4 income_dtw_cl5, name(comb_dtw_income, replace)

***** Assets
graph combine assets_sbd_cl1 assets_sbd_cl2 assets_sbd_cl3 assets_sbd_cl4 assets_sbd_cl5 assets_sbd_cl6, name(comb_sbd_assets, replace)

*graph combine assets_dtw_cl1 assets_dtw_cl2 assets_dtw_cl3 assets_dtw_cl4 assets_dtw_cl5, name(comb_dtw_assets, replace)

***** DSR
graph combine dsr_sbd_cl1 dsr_sbd_cl2 dsr_sbd_cl3 dsr_sbd_cl4, name(comb_sbd_dsr, replace)

*graph combine dsr_dtw_cl1 dsr_dtw_cl2 dsr_dtw_cl3 dsr_dtw_cl4 dsr_dtw_cl5 dsr_dtw_cl6 dsr_dtw_cl7, name(comb_dtw_dsr, replace)

***** DAR
graph combine dar_sbd_cl1 dar_sbd_cl2 dar_sbd_cl3 dar_sbd_cl4 dar_sbd_cl5 dar_sbd_cl6 dar_sbd_cl7, name(comb_sbd_dar, replace)

*graph combine dar_dtw_cl1 dar_dtw_cl2 dar_dtw_cl3 dar_dtw_cl4 dar_dtw_cl5, name(comb_dtw_dar, replace)

***** Expenses
graph combine expenses_sbd_cl1 expenses_sbd_cl2 expenses_sbd_cl3 expenses_sbd_cl4, name(comb_sbd_expenses, replace)

*graph combine expenses_dtw_cl1 expenses_dtw_cl2 expenses_dtw_cl3 expenses_dtw_cl4 expenses_dtw_cl5, name(comb_dtw_expenses, replace)



********** Display
set graph on

graph display comb_sbd_loan
*graph display comb_dtw_loan

graph display comb_sbd_income
*graph display comb_dtw_income

graph display comb_sbd_assets
*graph display comb_dtw_assets

graph display comb_sbd_dsr
*graph display comb_dtw_dsr

graph display comb_sbd_dar
*graph display comb_dtw_dar

graph display comb_sbd_expenses
*graph display comb_dtw_expenses

****************************************
* END












****************************************
* MCA test
****************************************
cls
graph drop _all
use"panel_v6_wide", clear

global var ce_assetsnl ce_loanamount ce_DSR

mca $var, method (indicator) normal(princ) dim(6)
mcacontrib
mcaplot, overlay xline(0) yline(0) scale(.8) dim(2 1)
mcaplot, overlay xline(0) yline(0) scale(.8) dim(3 4)
mcaplot, overlay xline(0) yline(0) scale(.8) dim(6 5)

mat mcamat=e(cGS)
mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2
svmat2 mcamat, rname(varname) name(col)

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
*/











****************************************
* Lines
****************************************
cls
graph drop _all
use"panel_v5_wide_cluster", clear


***** Keep + Reshape + panel
keep panelvar caste jatis villagearea* villageid* loanamount* DSR* ISR* assets_noland* annualincome* DAR_without* ce_*
reshape long loanamount annualincome DSR assets_noland DAR_without ISR DSRstd DAR_withoutstd annualincomestd assets_nolandstd ISRstd loanamountstd loanamountstdmean DSRstdmean ISRstdmean assets_nolandstdmean annualincomestdmean DAR_withoutstdmean, i(panelvar) j(year)

replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020

xtset panelvar year


***** Line graph
fre ce_loanamount
sort ce_loanamount panelvar year
twoway (line loanamountstd year if ce_loanamount==1, c(L) lcolor(red%10)) 
twoway (line loanamountstd year if ce_loanamount==2, c(L) lcolor(red%10)) 
twoway (line loanamountstd year if ce_loanamount==3, c(L) lcolor(red%10)) 
twoway (line loanamountstd year if ce_loanamount==4, c(L) lcolor(red%10)) 
twoway (line loanamountstd year if ce_loanamount==5, c(L) lcolor(red%10)) 
twoway (line loanamountstd year if ce_loanamount==6, c(L) lcolor(red%10)) 
****************************************
* END
