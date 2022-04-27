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








/*
****************************************
* Generic test
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

foreach x in loanamount {
foreach t in 2010 2016 2020 {
egen `x'std`t'=std(`x'`t')
}
}

global test loanamountstd2010 loanamountstd2016 loanamountstd2020
*** HCA
cluster wardslinkage $test, measure(Euclidean)
*** Dendrogram
*cluster dendrogram, horizontal cutnumber(15) countinline showcount name(, replace)
*** Kmeans
cluster kmeans $test, k(3) start(everyk) name(cl)
*** Check
tabstat $test, stat(n mean sd p50) by(cl)
***
foreach t in 2010 2016 2020 {
bysort cl: egen loanamountstdmean`t'=mean(loanamountstd`t')
}
*** 
encode HHID_panel, gen(panelvar)
keep panelvar cl loanamountstd*
reshape long loanamountstd loanamountstdmean, i(panelvar) j(year)
xtset panelvar year

sort cl panelvar year
twoway (line loanamountstd year if cl==1, c(L) lcolor(red%10)) (line loanamountstdmean year if cl==1, c(L) lcolor(blue) lwidth(medium))
****************************************
* END
*/











****************************************
* Standardisation
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

encode HHID_panel, gen(panelvar)

drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020

keep panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* annualincome* assets_noland* yearly_expenses* ISR* DIR*

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
* Choose algorithm
****************************************
cls
graph drop _all
use"panel_v5_wide_cluster", clear


keep panelvar loanamount2010 loanamountstd2010 loanamount2016 loanamountstd2016 loanamount2020 loanamountstd2020

keep loanamountstd2010 loanamountstd2016 loanamountstd2020
rename loanamountstd2010 loan1
rename loanamountstd2016 loan2
rename loanamountstd2020 loan3

rename loanamount2010 loan2010
rename loanamount2016 loan2016
rename loanamount2020 loan2020



global var loanstd2010 loanstd2016 loanstd2020

***** HCA for nb of clust
cluster wardslinkage $var, measure(Euclidean)


***** Dendrogram
*cluster dendrogram, horizontal cutnumber(15) countinline showcount name(dendro_loan, replace)
cluster gen cl_loan_hca=groups(4)


***** Kmeans
cluster kmeans $var, k(4) start(everyk) name(cl_loan_k)
ta cl_loan_k cl_loan_hca


***** Center of cluster
foreach t in 2010 2016 2020 {
bysort cl_loan_k: egen loanstdmean_k_`t'=mean(loanstd`t')
bysort cl_loan_hca: egen loanstdmean_hca_`t'=mean(loanstd`t')
}



***** Reshape + panel
keep panelvar loan* cl_loan_*
reshape long loan loanstd loanstd_hca_mean loanstd_k_mean, i(panelvar) j(year)
xtset panelvar year



***** Line graph
*** hca
set graph off
foreach g in 1 2 3 4 {
sort cl_loan_hca panelvar year
twoway (line loanstd year if cl_loan_hca==`g', c(L) lcolor(red%10)) (line loanstd_hca_mean year if cl_loan_hca==`g', c(L) lcolor(blue) lwidth(medium)), name(line_loan`g', replace)
}
grc1leg line_loan1 line_loan2 line_loan3 line_loan4, name(line_loan_hca, replace)
set graph on


*** k
set graph off
foreach g in 1 2 3 4 {
sort cl_loan_k panelvar year
twoway (line loanstd year if cl_loan_k==`g', c(L) lcolor(red%10)) (line loanstd_k_mean year if cl_loan_k==`g', c(L) lcolor(blue) lwidth(medium)), name(line_loan`g', replace)
}
grc1leg line_loan1 line_loan2 line_loan3 line_loan4, name(line_loan_k, replace)
set graph on


***** Display
graph display line_loan_hca
graph display line_loan_k

****************************************
* END



















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



/*
********** Representation
foreach x in assets_noland loanamount annualincome DSR  {
forvalues i=1(1)2 {
set graph off
stripplot d`i'_`x', over(cl_`x') vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks) ///
yline(0) ///
name(std`i'_`x', replace)
set graph on
}
}

***** Combine
foreach x in assets_noland loanamount annualincome DSR {
set graph off
graph combine std1_`x' std2_`x', col(2) name(comb_`x', replace)
set graph on
}
*/
****************************************
* END












****************************************
* Time trends analysis with qualitative 
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

********** Var to use
global varcat ce_DSR ce_DAR_without
foreach x in $varcat {
tab `x', gen(`x'_)
}

global var ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_DAR_without_1 ce_DAR_without_2 ce_DAR_without_3 ce_DAR_without_4 ce_DAR_without_5 ce_DAR_without_6

********** HCA
cluster wardslinkage $var, measure(Jaccard)
cluster dendrogram, horizontal cutnumber(20) countinline showcount title("Dendrogram")

********** kmeans
cluster kmeans $var, k(3) measure(Jaccard) start(everyk) name(cl_)


********** Representation
qui colorpalette hue, hue(0 200) chroma(70) luminance(50) n(6) globals
foreach x in $varcat {
set graph off
preserve 
bysort `x' cl_: gen n=_N
bysort cl_: gen N=_N
gen perc=round(n*100/N,1)

spineplot `x' cl_, ///
bar1(bcolor($p1)) bar2(bcolor($p2)) bar3(bcolor($p3)) bar4(bcolor($p4)) bar5(bcolor($p5)) bar6(bcolor($p6)) ///
text(perc) percent ///
xtitle("", axis(1)) ///
xtitle("", axis(2)) ytitle("") ///
xlab(,ang(0) axis(2)) ///
title("") subtitle("") ///
legend(pos(6) col(3)) ///
name(sp_`x', replace)
restore
set graph on
}


***** Combine
graph combine sp_ce_DSR sp_ce_DAR_without, col(2)





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
