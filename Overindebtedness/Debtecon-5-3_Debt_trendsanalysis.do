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
* Standardisation
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

tabstat $var2, stat(min p1 p5 p10 q p90 p95 p99 max cv)

*** Drop
drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020

*** To keep
keep panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* annualincome* assets_noland* yearly_expenses* ISR* DIR* $var $var2


***** STD ABS SIGN + STD
*** STD ABS SIGN
foreach x in loanamount DIR DAR_without DSR ISR annualincome assets_noland yearly_expenses {
gen d1_sign_`x'=""
replace d1_sign_`x'="POS" if d1_`x'>=0
replace d1_sign_`x'="NEG" if d1_`x'<0

gen d2_sign_`x'=""
replace d2_sign_`x'="POS" if d2_`x'>=0
replace d2_sign_`x'="NEG" if d2_`x'<0

egen std_abs_d1_`x'=std(abs(d1_`x'))
egen std_abs_d2_`x'=std(abs(d2_`x'))
}

*** STD
foreach x in loanamount DIR DAR_without DSR ISR annualincome assets_noland yearly_expenses {
sum d1_`x'
gen temp_d1_`x'=d1_`x'+abs(r(min))
sum d2_`x'
gen temp_d2_`x'=d2_`x'+abs(r(min))
}
foreach x in loanamount DIR DAR_without DSR ISR annualincome assets_noland yearly_expenses {
egen abs_d1_`x'=std(temp_d1_`x')
egen abs_d2_`x'=std(temp_d2_`x')
}




save"panel_v6_wide_cluster", replace



reshape long villagearea villageid DSR DAR_without annualincome assets_noland yearly_expenses ISR loanamount DIR, i(panelvar) j(year)


* By year
foreach x in DSR DAR_without annualincome assets_noland yearly_expenses ISR loanamount DIR {
sum `x'
gen `x'std=.
replace `x'std=(`x'-r(mean))/r(sd)
}

*Reshape
reshape wide DSR* DAR_without* annualincome* assets_noland* yearly_expenses* ISR* loanamount* DIR*, i(panelvar) j(year)

* Order and sort
order panelvar villageid villagearea caste jatis
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

foreach x in loanamount annualincome DSR DIR yearly_expenses assets_noland DAR_without ISR DSRstd DAR_withoutstd annualincomestd assets_nolandstd yearly_expensesstd ISRstd loanamountstd DIRstd {
rename `x'2010 `x'1
rename `x'2016 `x'2
rename `x'2020 `x'3
}

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

export delimited using "C:\Users\Arnaud\Documents\GitHub\Analysis\Overindebtedness\debttrend.csv", replace

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
* Time trends analysis with qualitative 
****************************************
cls
graph drop _all
use"panel_v5_wide_cluster", clear


***** Keep + Reshape + panel
keep panelvar caste jatis villagearea* villageid* loanamount* DSR* ISR* assets_noland* annualincome* DAR_without* ce_*
reshape long loanamount annualincome DSR assets_noland DAR_without ISR DSRstd DAR_withoutstd annualincomestd assets_nolandstd ISRstd loanamountstd loanamountstdmean DSRstdmean ISRstdmean assets_nolandstdmean annualincomestdmean DAR_withoutstdmean, i(panelvar) j(year)
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






/*
********** MCA for group
global var cl_loanamount cl_DSR cl_DAR_without
fre $var
mca $var, method (indicator) normal(princ)
mcacontrib
mcaplot, overlay legend(off) xline(0) yline(0) scale(.8)

mat mcamat=e(cGS)
mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2
svmat2 mcamat, rname(varname) name(col)

tabstat mass rel1 abs1 rel2 abs2, stat(mean sum)

twoway (scatter co2 co1 [aweight=mass], xline(0) yline(0)  mlabsize(vsmall) msymbol(oh) msize(small) legend(off)) (scatter co2 co1, mlabsize(vsmall) msymbol(i) mlabel(varname) legend(off))

****************************************
* END
