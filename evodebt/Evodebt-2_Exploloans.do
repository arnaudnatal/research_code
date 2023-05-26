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

********** Prepa
*** Selection
fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77
drop if otherlenderservices==.
drop if otherlenderservices==77
drop if otherlenderservices==99
ta dummyml
ta year

*** Dummy
fre otherlenderservices
gen lenderservices=.
replace lenderservices=1 if otherlenderservices==1
replace lenderservices=1 if otherlenderservices==2
replace lenderservices=1 if otherlenderservices==3
replace lenderservices=1 if otherlenderservices==4
replace lenderservices=0 if otherlenderservices==5
replace lenderservices=1 if otherlenderservices==6
label define lenderservices 0"No_serv" 1"Serv"
label values lenderservices lenderservices
ta otherlenderservices lenderservices
fre lenderservices


*** Amount
gen catamount=.
replace catamount=1 if loanamount<5000
replace catamount=2 if loanamount>=5000 & loanamount<20000
replace catamount=3 if loanamount>=20000 & loanamount<40000
replace catamount=4 if loanamount>=40000 & loanamount<100000
replace catamount=5 if loanamount>=100000
label define catamount 1"Low" 2"Average" 3"Quite high" 4"High" 5"Very high"
label values catamount catamount


*** Lender5
gen lender5=lender4
recode lender5 (4=11) (5=11)
fre lender5
label values lender5 lender3
label define lender3 11"Other", modify


********** MCA
global var reason_cat lender5 otherlenderservices
fre $var
*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Ok, what is the interpretation?
mca $var, meth(ind) normal(princ) comp dim(3)
mcaplot, dim(2 1) overlay legend(off) xline(0) yline(0)
*mcaplot, dim(3 1) overlay legend(off) xline(0) yline(0)


*** Retains for the HAC
qui mca $var, meth(ind) normal(princ) comp dim(9)
predict d1 d2 d3 d4 d5 d6 d7 d8 d9



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

drop cs1* cs2* cs3* cs4* cs5* cs6* cs7* cs8* cs9*

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



********** Cluster
cluster kmeans $var, k(5) start(random) name(clust)
ta clust
ta clust year, col nofreq
foreach x in $var{
ta `x' clust, col nofreq
}
foreach x in $var{
ta `x' clust, row nofreq
}
drop clust
 

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
drop if borrowerservices==77
drop if borrowerservices==99
drop if termsofrepayment==.
drop if otherlenderservices==.
drop if otherlenderservices==77
drop if otherlenderservices==99
drop if lender4==4
drop if lender4==5
ta dummyml
keep if dummyml==1
ta year


********** Var
fre otherlenderservices
fre borrowerservices
fre dummyinterest
fre dummyguarantor
fre dummyrecommendation
fre termsofrepayment
fre dummyhelptosettleloan


********** MCA
global var reason_cat lender4 otherlenderservices borrowerservices
*** How many axes to interpret?
mca $var, meth(ind) normal(princ) comp

*** Ok, what is the interpretation?
qui mca $var, meth(ind) normal(princ) comp dim(4)
*mcaplot, dim(2 1) overlay legend(off) xline(0) yline(0)
*mcaplot, dim(3 1) overlay legend(off) xline(0) yline(0)
*mcaplot, dim(4 1) overlay legend(off) xline(0) yline(0)


*** Retains for the HAC
qui mca $var, meth(ind) normal(princ) comp dim(11)
predict d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11




********** HAC
cluster wardslinkage d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11
cluster dendrogram, cutnumber(100)
cluster gen clust=groups(11)

ta clust
ta clust year, col nofreq
foreach x in $var{
ta `x' clust, col nofreq
}

****************************************
* END


