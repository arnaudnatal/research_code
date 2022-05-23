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

keep HHID_panel panelvar caste jatis cat_income cat_assets villageid villagearea sbd_*

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
legend(off) name(inertia, replace) 
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
legend(pos(6) col(4) order(1 "Assets" 2 "DSR" 3 "DAR" 4 "Debt")) aspectratio(1) ///
title("Projection of variables") name(vard1, replace)

*** Plot individual
scatter d2 d1,  xline(0) yline(0) xtitle("Dimension 1 (16.3%)") ytitle("Dimension 2 (14.4%)") msym(+) aspectratio(1) title("Projection of individuals") name(indivd1, replace)

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
legend(pos(6) col(4) order(1 "Assets" 2 "DSR" 3 "DAR" 4 "Debt")) aspectratio(1) ///
title("Projection of variables") name(vard3, replace)

*** Plot individual
scatter d4 d3,  xline(0) yline(0) xtitle("Dimension 3 (11.0%)") ytitle("Dimension 4 (10.3%)") msym(+) aspectratio(1) title("Projection of individuals") name(indivd3, replace)

*** Combine
grc1leg vard3 indivd3, name(mca_combd34, replace) col(2)




***** Combine all
grc1leg mca_combd12 mca_combd34, name(mca_comb, replace) col(1)



********** Classification
cluster wardslinkage d1 d2 d3 d4, measure(L2squared)


*** Plot branch
cluster dendrogram, cutnumber(50) xtitle("Group") ytitle("Squared euclidean dissimilarity measure") title("") xlabel(, labsize(tiny) ang(45)) yline(200) name(htree, replace) aspectratio(1)
cluster gen cl_new=groups(4)
fre cl_new


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
(scatter d2 d1 if cl_new==1, xline(0) yline(0) msym(+)) ///
(scatter d2 d1 if cl_new==2, msym(oh) mcolor(gs0)) ///
(scatter d2 d1 if cl_new==3, msym(dh)) ///
(scatter d2 d1 if cl_new==4, msym(sh) mcolor(gs5)) ///
, xtitle("Dimension 1 (16.3%)") ytitle("Dimension 2 (14.4%)") ///
legend(pos(6) col(2) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3" 4 "Cluster 4")) ///
name(clus, replace) aspectratio(1)

twoway ///
(scatter d4 d3 if cl_new==1, xline(0) yline(0) msym(+)) ///
(scatter d4 d3 if cl_new==2, msym(oh) mcolor(gs0)) ///
(scatter d4 d3 if cl_new==3, msym(dh)) ///
(scatter d4 d3 if cl_new==4, msym(sh) mcolor(gs5)) ///
, xtitle("Dimension 3 (11.0%)") ytitle("Dimension 4 (10.3%)") ///
legend(pos(6) col(2) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3" 4 "Cluster 4")) ///
name(clus, replace) aspectratio(1)


*** Characterise cluster
preserve
import delimited using "$git\Analysis\Overindebtedness\HCPCshiny.csv", clear
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
gsort -cluster`i'
gen n=_n
labmask n, values(varmod)
twoway ///
(function y=0, range(0 16)) ///
(bar cluster`i' n if cluster`i'>=3, barw(0.6) color(gs1)) ///
(bar cluster`i' n if cluster`i'<3 & cluster`i'>-3, barw(0.6) color(gs9)) ///
(bar cluster`i' n if cluster`i'<=-3, barw(0.6) color(gs1)) ///
, ///
xlabel(1(1)16, valuelabel ang(90) labsize()) xtitle("") ///
yla() ytitle("v-test") ///
title("Cluster `i'") name(char_cl`i', replace) legend(order(2 "p-value<=0.01" 3 "p-value>0.01") pos(6) col(2)) ///
aspectratio(0.5) graphregion(margin(zero))
drop n
}

grc1leg char_cl1 char_cl2 char_cl3 char_cl4, col(2) leg(char_cl1) name(char_comb, replace)
restore



********** Rename and label
rename cl_new vuln_cl

label define vuln_cl 1"Less-vulnerable" 2"Vulnerable" 3"Ex-vulnerable"
label values vuln_cl vuln_cl

set graph on


********** Graph export
/*
graph display inertia
graph export "graph/inertia.pdf", as(pdf)

graph display mca_comb
graph export "graph/mca_comb.pdf", as(pdf)

graph display hac_comb
graph export "graph/hac_comb.pdf", as(pdf)
*/


save"panel_v8_wide_cluster", replace

****************************************
* END









****************************************
* Exploratory analysis according to caste and cluster
****************************************
cls
graph drop _all
use"panel_v8_wide_cluster", clear

ta DSR2010
ta DSR2016
ta DSR2020

/*
replace DSR2010=DSR2010*100
replace DSR2016=DSR2016*100
replace DSR2020=DSR2020*100
ta DSR2010
ta DSR2016
ta DSR2020


foreach x in loanamount assets_noland yearly_expenses annualincome {
foreach i in 2010 2016 2020 {
replace `x'`i'=`x'`i'/1000
}
}

foreach x in DSR2010 DSR2016 DSR2020 ISR2010 ISR2016 ISR2020 {
qui count if `x'==0
dis r(N)*100/382
}
*/


********** Reshape
reshape long annualincome DSR loanamount DIR sizeownland head_edulevel head_occupation wifehusb_edulevel wifehusb_occupation mainocc_occupation yearly_expenses assets_noland DAR_without DAR_with ISR DSR30 DSR40 DSR50 ihs_annualincome ihs_assets_noland ihs_loanamount ihs_DSR_1000 ihs_DSR_100 cro_annualincome cro_assets_noland cro_loanamount cro_DSR log_yearly_expenses log_annualincome log_assets_noland log_assets log_loanamount dummyownland, j(year) i(panelvar)

gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

********** Check classification
ta vuln_cl caste if year==2010, nofreq row chi2
/*
No evident correlation = good for further sub analysis
*/

********** Type and use of debt


********** Burden of debt
foreach x in loanamount ISR DSR DAR_without annualincome assets_noland {
qui sum `x', d
local per99=r(p99)
local max=round(`per99',1)
stripplot `x' if `x'<`max', over(time) separate() by(vuln_cl, note("") row(1)) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks) ///
name(`x', replace)
}



********** Trends burden of debt
xtset panelvar year

***** DSR
sort vuln_cl panelvar year
sum DSR, d
drop if DSR>5
forvalues i=1(1)3{
twoway (line DSR year if vuln_cl==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel() ymtick() ytitle("") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_loanamount_`i', replace)
}

graph combine gph_loanamount_1 gph_loanamount_2 gph_loanamount_3, col(3) name(gph_loanamount, replace)



********** Debt trap


********** Overindebtedness



****************************************
* END
