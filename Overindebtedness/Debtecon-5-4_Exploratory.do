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
* Statistics following classification
****************************************
cls
graph drop _all
use"panel_v8_wide_cluster", clear

duplicates drop

set graph on

global var sbd_assets_noland sbd_dsr sbd_dar sbd_loanamount
fre $var

********** MCA without expenses
mca $var, meth(ind) normal(princ) dim(4) comp
*mcacontrib
matrix list e(F)
*matrix list NewContrib
matrix coord=e(F)
svmat coord, names(varcoord)
mat mcamat=e(cGS)
mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2 co3 rel3 abs3 co4 rel4 abs4 
svmat2 mcamat, rname(varname) name(col)
gen varname2=""
gen n=_n
replace varname2="Assets"	if n==1 	| n==2 	| n==3 	| n==4
replace varname2="DSR"		if n==5 	| n==6 	| n==7 	| n==8 	| n==9
replace varname2="DAR" 		if n==10 	| n==11 | n==12	| n==13
replace varname2="Debt"		if n==14	| n==15	| n==16 
drop n
predict d1 d2 d3 d4


*** Inertia
preserve
clear all
input dim inertia perc totperc
1	.4896937	16.32	16.32
2	.4322295	14.41	30.73
3	.3306488	11.02	41.75
4	.3076704	10.26	52.01
5	.2615378	8.72	60.73
6	.244503	8.15	68.88
7	.211925	7.06	75.94
8	.2080429	6.93	82.88
9	.1743264	5.81	88.69
10	.1645337	5.48	94.17
11	.103332	3.44	97.61
12	.071557	2.39	100.00
end

twoway ///
(bar totperc dim, barw(0.6) color(gs7)) ///
, ///
xlabel(1(1)12) xtitle("Dimension") ///
ylabel(0(10)100) ytitle("Cumul % of variance") ///
legend(off) name(inertiamca, replace) 
restore



***** Dimension 1 and 2
*** Plot var
egen labpos=mlabvpos(varcoord2 varcoord1)
replace labpos=5	if varname=="DEC-INC" & varname2=="Assets"
replace labpos=11	if varname=="Dec-Inc" & varname2=="Assets"
replace labpos=3	if varname=="Inc-Inc" & varname2=="Assets"
replace labpos=9	if varname=="Dec-Dec" & varname2=="Assets"
replace labpos=12	if varname=="Sta-Dec" & varname2=="DSR"
replace labpos=6	if varname=="Dec-Dec" & varname2=="DSR"
replace labpos=3	if varname=="INC-INC" & varname2=="DSR"
replace labpos=12	if varname=="Dec-Inc" & varname2=="DSR"
replace labpos=7 	if varname=="Dec-Inc" & varname2=="DAR"
replace labpos=5	if varname=="Inc-Dec" & varname2=="DAR"
replace labpos=7	if varname=="Dec-Dec" & varname2=="DAR"
replace labpos=11	if varname=="Inc-Inc" & varname2=="DAR"
replace labpos=12 	if varname=="Dec-Inc" & varname2=="Debt"
replace labpos=12	if varname=="Inc-Dec" & varname2=="Debt"

twoway ///
(scatter varcoord2 varcoord1 if varname2=="Assets", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="DSR", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="DAR", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="Debt", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
, xtitle("Dimension 1 (16.3%)") ytitle("Dimension 2 (14.4%)") ///
legend(pos(6) col(4) order(1 "Assets" 2 "DSR" 3 "DAR" 4 "Debt")) aspectratio(0.5) ///
title("Projection of variables") name(vard1, replace)

*** Plot individual
scatter d2 d1,  xline(0) yline(0) xtitle("Dimension 1 (16.3%)") ytitle("Dimension 2 (14.4%)") msym(+) aspectratio(0.5) title("Projection of individuals") name(indivd1, replace)

*** Combine
grc1leg vard1 indivd1, name(mca_combd12, replace) col(2)


***** Dimension 3 and 4
*** Plot var
egen labpos2=mlabvpos(varcoord4 varcoord3)
replace labpos2=12	if varname=="DEC-INC" & varname2=="Assets"
replace labpos2=6	if varname=="Dec-Inc" & varname2=="Assets"
replace labpos2=12	if varname=="Inc-Inc" & varname2=="Assets"
replace labpos2=3	if varname=="Dec-Dec" & varname2=="Assets"
replace labpos2=3	if varname=="Sta-Dec" & varname2=="DSR"
replace labpos2=8	if varname=="Dec-Dec" & varname2=="DSR"
replace labpos2=9	if varname=="INC-INC" & varname2=="DSR"
replace labpos2=12	if varname=="Dec-Inc" & varname2=="DSR"
replace labpos2=1 	if varname=="Dec-Inc" & varname2=="DAR"
replace labpos2=5	if varname=="Inc-Dec" & varname2=="DAR"
replace labpos2=5	if varname=="Dec-Dec" & varname2=="DAR"
replace labpos2=1	if varname=="Inc-Inc" & varname2=="DAR"
replace labpos2=6 	if varname=="Dec-Inc" & varname2=="Debt"
replace labpos2=12	if varname=="Inc-Dec" & varname2=="Debt"
replace labpos2=5	if varname=="Inc-Inc" & varname2=="Debt"

twoway ///
(scatter varcoord4 varcoord3 if varname2=="Assets", xline(0) yline(0) mlab(varname) mlabvpos(labpos2)) ///
(scatter varcoord4 varcoord3 if varname2=="DSR", xline(0) yline(0) mlab(varname) mlabvpos(labpos2)) ///
(scatter varcoord4 varcoord3 if varname2=="DAR", xline(0) yline(0) mlab(varname) mlabvpos(labpos2)) ///
(scatter varcoord4 varcoord3 if varname2=="Debt", xline(0) yline(0) mlab(varname) mlabvpos(labpos2)) ///
, xtitle("Dimension 3 (11.0%)") ytitle("Dimension 4 (10.3%)") ///
legend(pos(6) col(4) order(1 "Assets" 2 "DSR" 3 "DAR" 4 "Debt")) aspectratio(0.5) ///
title("Projection of variables") name(vard3, replace)

*** Plot individual
scatter d4 d3,  xline(0) yline(0) xtitle("Dimension 3 (11.0%)") ytitle("Dimension 4 (10.3%)") msym(+) aspectratio(0.5) title("Projection of individuals") name(indivd3, replace)

*** Combine
grc1leg vard3 indivd3, name(mca_combd34, replace) col(2)




***** Combine all
grc1leg mca_combd12 mca_combd34, name(mca_comb, replace) col(1)



********** Classification
cluster wardslinkage d1 d2 d3 d4, measure(L2squared)


*** Plot branch
cluster dendrogram, cutnumber(50) xtitle("Group") ytitle("Squared euclidean dissimilarity measure") title("") xlabel(, labsize(tiny) ang(45)) yline(140) name(htree, replace) aspectratio(1)
cluster gen cl_vuln_raw=groups(4)
fre cl_vuln_raw


*** Inertia gain
preserve
import delimited using "$git\Analysis\Overindebtedness\inertia.csv", clear
drop if v1>15
twoway ///
(bar inert v1 if v1<=3, barw(0.6) color(gs1)) ///
(bar inert v1 if v1>3, barw(0.6) color(gs9)) ///
, ///
xlabel(1(1)15) xtitle("Class reduction") ///
yla() ytitle("Inertia gain") aspectratio(1) ///
name(inertia, replace) legend(off) 
restore

*** Combine
graph combine htree inertia, name(hac_comb, replace)



*** Plot indiv
twoway ///
(scatter d2 d1 if cl_vuln_raw==1, xline(0) yline(0) msym(+)) ///
(scatter d2 d1 if cl_vuln_raw==2, msym(o) mcolor(gs0)) ///
(scatter d2 d1 if cl_vuln_raw==3, msym(d)) ///
(scatter d2 d1 if cl_vuln_raw==4, msym(s) mcolor(gs5)) ///
, xtitle("Dimension 1 (16.3%)") ytitle("Dimension 2 (14.4%)") ///
legend(pos(6) col(2) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3" 4 "Cluster 4")) ///
name(clusd12, replace) aspectratio(1)

twoway ///
(scatter d4 d3 if cl_vuln_raw==1, xline(0) yline(0) msym(+)) ///
(scatter d4 d3 if cl_vuln_raw==2, msym(o) mcolor(gs0)) ///
(scatter d4 d3 if cl_vuln_raw==3, msym(d)) ///
(scatter d4 d3 if cl_vuln_raw==4, msym(s) mcolor(gs5)) ///
, xtitle("Dimension 3 (11.0%)") ytitle("Dimension 4 (10.3%)") ///
legend(pos(6) col(2) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3" 4 "Cluster 4")) ///
name(clusd34, replace) aspectratio(1)

*** Combine
grc1leg clusd12 clusd34, name(clus_t, replace)



*** Characterise cluster
preserve
import delimited using "$git\Analysis\Overindebtedness\HCPCshiny.csv", clear
rename cluster1 A
rename cluster2 B
rename cluster3 C
rename cluster4 D
rename A cluster2
rename B cluster4
rename C cluster1
rename D cluster3
order cluster1 cluster2 cluster3 cluster4
split v1, p("=")
drop v1
split v11, p("_")
drop v11 v111 v113
split v12, p("_")
drop v12 v121 v122
replace v123=v124 if v112=="assets"
drop v124
rename v112 varname
rename v123 mod
replace varname="Assets" if varname=="assets"
replace varname="DAR" if varname=="dar"
replace varname="DSR" if varname=="dsr"
replace varname="Debt" if varname=="loanamount"
order varname mod

egen max=rowmax(cluster1-cluster4)

forvalues i=1(1)4 {
gen cl`i'=max if cluster`i'==max
}

egen varmod=concat(varname mod), p(" ")

forvalues i=1(1)4{
local d1="Non-vulnerable"
local d2="Highly vulnerable"
local d3="Ex-vulnerable"
local d4="Vulnerable"
local j="`d`i''"
gsort -cluster`i'
gen n=_n
labmask n, values(varmod)
twoway ///
(bar cluster`i' n if cluster`i'>=3, yline(0) barw(0.6) color(gs1)) ///
(bar cluster`i' n if cluster`i'<3 & cluster`i'>-3, barw(0.6) color(gs9)) ///
(bar cluster`i' n if cluster`i'<=-3, barw(0.6) color(gs1)) ///
, ///
xlabel(1(1)16, valuelabel ang(90) labsize(small)) xtitle("") ///
yla() ytitle("v-test") ///
title("Cluster `i': `j'") name(char_cl`i', replace) legend(order(1 "p-value<=0.01" 2 "p-value>0.01") pos(6) col(2)) ///
aspectratio(0.5) graphregion(margin(zero))
drop n
}

grc1leg char_cl1 char_cl2 char_cl3 char_cl4, col(2) leg(char_cl1) name(char_comb, replace)
restore



***** Main graph
foreach x in inertiamca mca_comb hac_comb clus_t char_comb {
graph display `x'
graph export "graph/`x'.pdf", as(pdf) replace
}


********** Rename and label
rename cl_vuln_raw cl_vuln
label define cl_vuln 1"Non-vulnerable" 2"Highly vulnerable" 3"Ex-vulnerable" 4"Vulnerable", replace
label values cl_vuln cl_vuln
fre cl_vuln

fre cl_vuln
recode cl_vuln (1=1) (2=4) (3=2) (4=3)
label define cl_vuln 1"Non-vulnerable" 2"Ex-vulnerable" 3"Vulnerable" 4"Highly vulnerable", modify

save"panel_v8_wide_cluster", replace
****************************************
* END









****************************************
* Old var + descriptive var
****************************************
cls
graph drop _all
use"panel_v5_wide", clear


********** Merge
merge 1:1 HHID_panel using "panel_v8_wide_cluster", keepusing(sbd_annualincome sbd_assets_noland sbd_loanamount sbd_dsr sbd_dar cl_vuln) 

drop _merge

save "panel_v6_wide", replace


********** Desc
ta caste cl_vuln, row nofreq
ta cat_assets cl_vuln, row nofreq
ta cat_income cl_vuln, row nofreq

ta sbd_assets cl_vuln, row nofreq
ta sbd_dar cl_vuln, row nofreq
ta sbd_dsr cl_vuln, row nofreq
ta sbd_loanamount cl_vuln, row nofreq

****************************************
* END
