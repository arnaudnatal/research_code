*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 14, 2023
*-----
gl link = "evodebt"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------











****************************************
* Diff loans and main loans
****************************************
cls
use"panel_loans_nonsettled", clear

ta dummyml

ta loanreasongiven dummyml, col nofreq
ta loanlender dummyml, col nofreq
tabstat loanamount, stat(mean q) by(dummyml)


****************************************
* END













****************************************
* MCA + HAC for all loans
****************************************
use"panel_loans_nonsettled", clear

********** Selection
fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77
ta dummyml
ta year


********** Cleaning var
*** Amount
gen catamount=.
replace catamount=1 if loanamount<5000
replace catamount=2 if loanamount>=5000 & loanamount<20000
replace catamount=3 if loanamount>=20000 & loanamount<40000
replace catamount=4 if loanamount>=40000 & loanamount<100000
replace catamount=5 if loanamount>=100000
label define catamount 1"Low" 2"Average" 3"Quite high" 4"High" 5"Very high"
label values catamount catamount

*** Services
drop if otherlenderservices==.
drop if otherlenderservices==77
drop if otherlenderservices==99

********** MCA
global var reason_cat lender4 otherlenderservices catamount
*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Ok, what is the interpretation?
/*
mca $var, meth(ind) normal(princ) comp dim(5)
mcaplot, dim(2 1) overlay legend(off) xline(0) yline(0)
mcaplot, dim(3 1) overlay legend(off) xline(0) yline(0)
*/

*** Retains for the HAC
qui mca $var, meth(ind) normal(princ) comp dim(13)
predict d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13


********** Kmeans
global val 1 2 4 8 16 32 64 128 256 512 1024
foreach sp in $val {
local list2 "$var"
forvalues k = 1(1)20 {
cluster kmeans `list2', k(`k') start(random(`sp')) name(cs`k'_`sp')
}

* WSS matrix
matrix WSS = J(20,5,.)
matrix colnames WSS = k WSS log(WSS) eta-squared PRE

* WSS for each clustering
forvalues k = 1(1)20 {
scalar ws`k'_`sp' = 0
foreach v of varlist `list2'{
quietly anova `v' cs`k'_`sp'
scalar ws`k'_`sp'= ws`k'_`sp' + e(rss)
}
matrix WSS[`k', 1] = `k'
matrix WSS[`k', 2] = ws`k'_`sp'
matrix WSS[`k', 3] = log(ws`k'_`sp')
matrix WSS[`k', 4] = 1 - ws`k'_`sp'/WSS[1,2]
matrix WSS[`k', 5] = (WSS[`k'-1,2] - ws`k'_`sp')/WSS[`k'-1,2]
}

* Display matrix
matrix list WSS

* Graph
local squared = char(178)
_matplot WSS, columns(2 1) connect(l) xlabel(#10) name(plot1`sp', replace) nodraw noname
_matplot WSS, columns(3 1) connect(l) xlabel(#10) name(plot2`sp', replace) nodraw noname
_matplot WSS, columns(4 1) connect(l) xlabel(#10) name(plot3`sp', replace) nodraw noname ytitle({&eta}`squared')
_matplot WSS, columns(5 1) connect(l) xlabel(#10) name(plot4`sp', replace) nodraw noname
set graph off
graph combine plot1`sp' plot2`sp' plot3`sp' plot4`sp', name(gph_`sp', replace)
}

set graph on
graph display gph_1
graph display gph_2
graph display gph_4
graph display gph_8
graph display gph_16
graph display gph_32
graph display gph_64
graph display gph_128
graph display gph_256
graph display gph_512
graph display gph_1024


********** 4 groups
cluster kmeans $var, k(5) start(random(2)) name(clust)
ta clust
ta lender4 clust, col nofreq
ta reason_cat clust, col nofreq
ta catamount clust, col nofreq
ta otherlenderservices clust, col nofreq

 

****************************************
* END















****************************************
* MCA + HAC for main loans
****************************************
use"panel_loans_nonsettled", clear

********** Selection
fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77
ta dummyml
keep if dummyml==1
ta year


********** Var
fre borrowerservices
fre dummyinterest
fre dummyguarantor
fre dummyrecommendation
fre termsofrepayment
fre dummyhelptosettleloan


********** MCA
global var reason_cat lender4 otherlenderservices borrowerservices dummyinterest dummyhelptosettleloan termsofrepayment
*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Ok, what is the interpretation?
qui mca $var, meth(ind) normal(princ) comp dim(4)
mcaplot, dim(2 1) overlay legend(off) xline(0) yline(0)
mcaplot, dim(3 1) overlay legend(off) xline(0) yline(0)
mcaplot, dim(4 1) overlay legend(off) xline(0) yline(0)


*** Retains for the HAC
qui mca $var, meth(ind) normal(princ) comp dim(15)
predict d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15





********** HAC
cluster wardslinkage d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15
cluster dendrogram, cutnumber(100)
cluster gen clust=groups(2)

ta reason_cat clust, col nofreq
ta lender4 clust, col nofreq

****************************************
* END


