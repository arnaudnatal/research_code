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
* Time trends analysis with continuous 
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

********** Std
forvalues j=1(1)2{
foreach x in DSR DAR_without annualincome assets_noland yearly_expenses ISR loanamount DIR {
egen d`j'_`x'_std=std(d`j'_`x')
replace d`j'_`x'_std=3 if d`j'_`x'_std>3
replace d`j'_`x'_std=-3 if d`j'_`x'_std<-3
}
}


********** HCA
local i=0
foreach x in annualincome assets_noland loanamount DSR DAR_without ISR DIR {
local i=`i'+1
cluster wardslinkage d1_`x'_std d2_`x'_std, measure(Euclidean)
set graph off
cluster dendrogram, horizontal cutnumber(15) countinline showcount name(gph_cl_x`i', replace) title("Dendrogram of `x'")
set graph on
}

/*
forvalues i=1(1)7{
graph display gph_cl_x`i'
}
*/

********** kmeans
foreach x in annualincome assets_noland {
cluster kmeans d1_`x'_std d2_`x'_std, k(3) start(everyk) name(cl_`x')
}

foreach x in DSR loanamount DAR_without {
cluster kmeans d1_`x'_std d2_`x'_std, k(2) start(everyk) name(cl_`x')
}


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
