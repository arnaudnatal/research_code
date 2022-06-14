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
* Prepa R for HCPC
****************************************
cls
graph drop _all
use"panel_v8_cluster", clear

keep HHID_panel sbd_annualincome sbd_assets_noland sbd_loanamount sbd_dsr sbd_dar sbd_dir sbd_expenses cat_income cat_assets jatis caste villageid villagearea
duplicates drop
export delimited using "$git\research_code\evodebt\debttrend_v3.csv", replace

save"panel_v9_cluster", replace
****************************************
* END







********** R analysis with debttrend_v3
********** R analysis with debttrend_v3
********** R analysis with debttrend_v3
********** R analysis with debttrend_v3
********** R analysis with debttrend_v3







****************************************
* Stata analysis with same setting as R 
* for graph representation
****************************************
cls
graph drop _all
use"panel_v9_cluster", clear

duplicates drop
set graph off

global var sbd_assets_noland sbd_dsr sbd_dar sbd_annualincome
fre $var


/*
********** MCA
mca $var, meth(ind) normal(princ) dim(5) comp
*mcacontrib
matrix list e(F)
*matrix list NewContrib
matrix coord=e(F)
svmat coord, names(varcoord)
mat mcamat=e(cGS)
mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2 co3 rel3 abs3 co4 rel4 abs4 co5 rel5 abs5
svmat2 mcamat, rname(varname) name(col)
gen varname2=""
gen n=_n
replace varname2="Assets"	if n==1 	| n==2 	| n==3 	| n==4
replace varname2="DSR"		if n==5 	| n==6 	| n==7 	| n==8 	| n==9
replace varname2="DAR" 		if n==10 	| n==11 | n==12	| n==13
replace varname2="Income"	if n==14	| n==15	| n==16	| n==17
drop n
predict d1 d2 d3 d4 d5


*** Inertia
preserve
clear all
input dim inertia perc totperc
1	.4647612	14.30	14.30
2	.3567872	10.98	25.28
3	.3082466	9.48	34.76
4	.2947951	9.07	43.83
5	.2759431	8.49	52.32
6	.261166	8.04	60.36
7	.2522397	7.76	68.12
8	.2290125	7.05	75.17
9	.2178336	6.70	81.87
10	.1833391	5.64	87.51
11	.1813671	5.58	93.09
12	.120982	3.72	96.81
13	.1035269	3.19	100.00
end

twoway ///
(bar totperc dim if dim!=5, barw(0.6) color(gs9)) ///
(bar totperc dim if dim==5, barw(0.6) color(gs1)) ///
, ///
xlabel(1(1)12) xtitle("Dimension") ///
ylabel(0(10)100) ytitle("Cumul % of variance") ///
legend(off) name(inertiamca, replace) 
restore



***** Dimension 1 and 2
*** Plot var
egen labpos=mlabvpos(varcoord2 varcoord1)
replace labpos=12	if varname=="DEC-INC" & varname2=="Assets"
replace labpos=9	if varname=="Dec-Inc" & varname2=="Assets"
replace labpos=12	if varname=="Inc-Inc" & varname2=="Assets"
replace labpos=9	if varname=="Dec-Dec" & varname2=="Assets"
replace labpos=12	if varname=="Sta-Dec" & varname2=="DSR"
replace labpos=12	if varname=="Dec-Dec" & varname2=="DSR"
replace labpos=3	if varname=="INC-INC" & varname2=="DSR"
replace labpos=12	if varname=="Dec-Inc" & varname2=="DSR"
replace labpos=1 	if varname=="Dec-Inc" & varname2=="DAR"
replace labpos=12	if varname=="Inc-Dec" & varname2=="DAR"
replace labpos=1	if varname=="Dec-Dec" & varname2=="DAR"
replace labpos=11	if varname=="Inc-Inc" & varname2=="DAR"
replace labpos=12 	if varname=="Dec-Sta" & varname2=="Income"
replace labpos=12 	if varname=="Dec-Dec" & varname2=="Income"
replace labpos=11	if varname=="Sta-Dec" & varname2=="Income"
replace labpos=12	if varname=="Dec-Inc" & varname2=="Income"

twoway ///
(scatter varcoord2 varcoord1 if varname2=="Assets", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="DSR", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="DAR", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="Income", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
, xtitle("Dimension 1 (14.3%)") ytitle("Dimension 2 (11.0%)") ///
legend(pos(6) col(4) order(1 "Assets" 2 "DSR" 3 "DAR" 4 "Income")) aspectratio(1) ///
title("Projection of variables") name(vard1, replace)

*** Plot individual
scatter d2 d1,  xline(0) yline(0) xtitle("Dimension 1 (14.3%)") ytitle("Dimension 2 (11.0%)") msym(+) aspectratio(1) title("Projection of individuals") name(indivd1, replace)

*** Combine
grc1leg vard1 indivd1, name(mca_combd12, replace) col(2)







********** Classification
cluster wardslinkage d1 d2 d3 d4 d5, measure(L2squared)


*** Plot branch
cluster dendrogram, cutnumber(50) xtitle("Group") ytitle("Squared euclidean dissimilarity measure") title("") xlabel(, labsize(tiny) ang(45)) yline(120) name(htree, replace) aspectratio(1)


*** Inertia gain
preserve
import delimited using "$git\research_code\evodebt\inertia.csv", clear
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
*/


***
save"panel_v10_cluster", replace
****************************************
* END













****************************************
* Import cluster from R
****************************************
cls
graph drop _all
use"panel_v10_cluster", clear

duplicates drop
set graph off

global var sbd_assets_noland sbd_dsr sbd_dar sbd_annualincome
fre $var


********** Import results
preserve
import delimited using "$git\research_code\evodebt\debttrend_v4.csv", clear
ta clust
keep hhid_panel clust
rename hhid_panel HHID_panel
save "_temp_HCPC_conso.dta", replace
restore

merge 1:1 HHID_panel using "_temp_HCPC_conso.dta"
drop _merge
erase "_temp_HCPC_conso.dta"
rename clust cl_vuln_raw

ta cl_vuln_raw
ta cl_vuln_raw caste, row nofreq
ta cl_vuln_raw caste, col nofreq

gen test=.
replace test=1 if cl_vuln_raw==1
replace test=1 if cl_vuln_raw==2
replace test=0 if cl_vuln_raw==3
replace test=1 if cl_vuln_raw==4
replace test=0 if cl_vuln_raw==5

ta test cl_vuln_raw
ta test caste, nofreq chi2
ta test caste, exp cchi2
ta test caste, row nofreq
ta test caste, col nofreq


********** Plot indiv
/*
twoway ///
(scatter d2 d1 if cl_vuln_raw==1, xline(0) yline(0) msym(+)) ///
(scatter d2 d1 if cl_vuln_raw==2, msym(o) mcolor(gs0)) ///
(scatter d2 d1 if cl_vuln_raw==3, msym(d)) ///
(scatter d2 d1 if cl_vuln_raw==4, msym(s) mcolor(gs5)) ///
, xtitle("Dimension 1 (16.3%)") ytitle("Dimension 2 (14.4%)") ///
legend(pos(6) col(2) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3" 4 "Cluster 4")) ///
name(clusd12, replace) aspectratio(1)
*/



********** Characterise cluster
/*
preserve
import delimited using "$git\research_code\evodebt\HCPCshiny.csv", clear
*rename cluster1 A
*rename cluster2 B
*rename cluster3 C
*rename cluster4 D
*rename A cluster2
*rename B cluster4
*rename C cluster1
*rename D cluster3
*order cluster1 cluster2 cluster3 cluster4
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
replace varname="Income" if varname=="annualincome"
order varname mod

egen max=rowmax(cluster1-cluster4)

forvalues i=1(1)4 {
gen cl`i'=max if cluster`i'==max
}

egen varmod=concat(varname mod), p(" ")

forvalues i=1(1)4{
local d1="Unstable debt"
local d2="Sustainable debt"
local d3="Vulnerable"
local d4="Highly vulnerable"
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
*/



********** Main graph
/*
foreach x in inertiamca mca_combd12 hac_comb clusd12 char_comb {
graph display `x'
graph export "graph/`x'.pdf", as(pdf) replace
}
*/



********** Rename and label
rename cl_vuln_raw cl_vuln
/*
label define cl_vuln 1"Unstable debt" 2"Sustainable debt" 3"Vulnerable" 4"Highly vulnerable", replace
label values cl_vuln cl_vuln
fre cl_vuln
*/


********** Dummy for financial vulnerability
/*
gen dummyvuln=.
replace dummyvuln=1 if cl_vuln==1
replace dummyvuln=0 if cl_vuln==2
replace dummyvuln=1 if cl_vuln==3
replace dummyvuln=1 if cl_vuln==4


label define yesno 0"No" 1"Yes"
label values dummyvuln yesno
*/
rename test dummyvuln


save"panel_v11_cluster", replace
****************************************
* END









****************************************
* Old var + descriptive var
****************************************
cls
graph drop _all
use"panel_v5_wide", clear


********** Merge
merge 1:1 HHID_panel using "panel_v11_cluster", keepusing(sbd_annualincome sbd_assets_noland sbd_loanamount sbd_dsr sbd_dar sbd_dir cl_vuln dummyvuln) 

drop _merge


********** Clean
***** Drop
drop log_ISR102010 log_DAR102010 log_DSR102010 ihs_ISR102010 ihs_DAR102010 ihs_DSR102010 log_ISR102016 log_DAR102016 log_DSR102016 ihs_ISR102016 ihs_DAR102016 ihs_DSR102016 log_ISR102020 log_DAR102020 log_DSR102020 ihs_ISR102020 ihs_DAR102020 ihs_DSR102020 log_ISR1002010 log_DAR1002010 log_DSR1002010 ihs_ISR1002010 ihs_DAR1002010 ihs_DSR1002010 log_ISR1002016 log_DAR1002016 log_DSR1002016 ihs_ISR1002016 ihs_DAR1002016 ihs_DSR1002016 log_ISR1002020 log_DAR1002020 log_DSR1002020 ihs_ISR1002020 ihs_DAR1002020 ihs_DSR1002020 log_ISR100002010 log_DAR100002010 log_DSR100002010 ihs_ISR100002010 ihs_DAR100002010 ihs_DSR100002010 log_ISR100002016 log_DAR100002016 log_DSR100002016 ihs_ISR100002016 ihs_DAR100002016 ihs_DSR100002016 log_ISR100002020 log_DAR100002020 log_DSR100002020 ihs_ISR100002020 ihs_DAR100002020 ihs_DSR100002020 log_ISR2010 log_DAR10002010 log_DAR2010 log_DSR10002010 log_DSR2010 log_yearly_expenses2016 log_annualincome2016 log_assets_noland2016 log_assets2016 log_loanamount2016 log_ISR10002016 log_ISR2016 log_DAR10002016 log_DAR2016 log_DSR10002016 log_DSR2016 log_yearly_expenses2020 log_annualincome2020 log_assets_noland2020 log_assets2020 log_loanamount2020 log_ISR10002020 log_ISR2020 log_DAR10002020 log_DAR2020 log_DSR10002020 log_DSR2020 ihs_DAR2010 ihs_DAR2016 ihs_DAR2020 ihs_DSR2010 ihs_DSR2016 ihs_DSR2020 ihs_ISR2010 ihs_ISR2016 ihs_ISR2020 cro_annualincome2010 cro_assets_noland2010 cro_loanamount2010 cro_DSR2010 cro_DAR_without2010 cro_DIR2010 cro_ISR2010 cro_DAR_with2010 cro_yearly_expenses2010 cro_annualincome2016 cro_assets_noland2016 cro_loanamount2016 cro_DSR2016 cro_DAR_without2016 cro_DIR2016 cro_ISR2016 cro_DAR_with2016 cro_yearly_expenses2016 cro_annualincome2020 cro_assets_noland2020 cro_loanamount2020 cro_DSR2020 cro_DAR_without2020 cro_DIR2020 cro_ISR2020 cro_DAR_with2020 cro_yearly_expenses2020 log_yearly_expenses2010 log_annualincome2010 log_assets_noland2010 log_assets2010 log_loanamount2010 log_ISR10002010

***** Rename
foreach x in ISR DSR DAR {
rename ihs_`x'10002010 ihs_`x'2010
rename ihs_`x'10002016 ihs_`x'2016
rename ihs_`x'10002020 ihs_`x'2020
}


***** panelvar
encode HHID_panel, gen(panelvar)


***** 1k
foreach i in 2010 2016 2020 {
foreach x in formal informal eco current humank social home repay_amt {
replace `x'_HH`i'=`x'_HH`i'/1000
}
replace annualincome`i'=annualincome`i'/1000
replace loanamount`i'=loanamount`i'/1000
}

***** Value loan amount already deflate



save "panel_v10_wide", replace
****************************************
* END
