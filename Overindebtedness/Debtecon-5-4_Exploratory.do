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


set graph on

********** MCA without expenses
mca sbd_assets_noland sbd_dsr sbd_dar, meth(ind) normal(princ) dim(8) comp
/*
mcacontrib
matrix list e(F)
matrix list NewContrib
matrix coord=e(F)
svmat coord, names(varcoord)
mat mcamat=e(cGS)
mat colnames mcamat = mass qual inert co1 rel1 abs1 co2 rel2 abs2 co3 rel3 abs3 co4 rel4 abs4 
svmat2 mcamat, rname(varname) name(col)
gen varname2=""
gen n=_n
replace varname2="Debt" if n==1 | n==2 | n==3
replace varname2="Income" if n==4 | n==5 | n==6
replace varname2="Assets" if n==7 | n==8 | n==9
drop n
*/
predict d1_nf d2_nf

mcaplot, overlay xline(0) yline(0)
scatter d2_nf d1_nf, xline(0) yline(0) name(ind,replace)


/*
*** Inertia
input dim inertia perc totperc
1 0.43 	21.75 	21.75
2 0.40 	19.98 	41.72
3 0.36 	18.02 	59.74
4 0.29 	14.66 	74.40
5 0.27 	13.39 	87.79
6 0.24 	12.21 	100.00 
end
graph bar perc, over(dim) b1title("Dimension") ytitle("% of variance") note("Decomposition of the total inertia.", size(tiny)) name(inertia, replace)
*/


*** Plot var
egen labpos=mlabvpos(varcoord2 varcoord1)
replace labpos=3 if varname=="Inc-Inc" & varname2=="Debt"
replace labpos=3 if varname=="Inc-Sta" & varname2=="Income"
replace labpos=3 if varname=="Inc-Dec" & varname2=="Debt"
replace labpos=3 if varname=="Inc-Dec" & varname2=="Income"
replace labpos=1 if varname=="Dec-Dec" & varname2=="Assets"
replace labpos=9 if varname=="Dec-Inc" & varname2=="Assets"
replace labpos=9 if varname=="Dec-Inc" & varname2=="Debt"
replace labpos=3 if varname=="Dec-Inc" & varname2=="Income"

twoway ///
(scatter varcoord2 varcoord1 if varname2=="Assets", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="Debt", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
(scatter varcoord2 varcoord1 if varname2=="Income", xline(0) yline(0) mlab(varname) mlabvpos(labpos)) ///
, xtitle("Dimension 1 (21.7%)") ytitle("Dimension 2 (20.0%)") ///
legend(pos(7) col(3) order(1 "Assets" 2 "Debt" 3 "Income")) aspectratio(1) ///
name(var, replace)

*** Plot individual
scatter d2_nf d1_nf,  xline(0) yline(0) xtitle("Dimension 1 (21.7%)") ytitle("Dimension 2 (20.0%)") msym(o) aspectratio(1) name(indiv, replace)

*** Combine
grc1leg var indiv, name(mca_comb, replace) col(2)



********** Classification
cluster wardslinkage d1_nf d2_nf, measure(L2squared)


*** Plot branch
cluster dendrogram, cutnumber(20) xtitle("Group") ytitle("Squared euclidean dissimilarity measure") title("") xlabel(1(1)20, ang(0)) yline(150) name(htree, replace) aspectratio(1)
cluster gen cl_new=groups(3)
fre cl_new


*** Plot indiv
twoway ///
(scatter d2_nf d1_nf if cl_new==1, xline(0) yline(0) msym(o)) ///
(scatter d2_nf d1_nf if cl_new==2, msym(s)) ///
(scatter d2_nf d1_nf if cl_new==3, msym(d)) ///
, xtitle("Dimension 1 (21.7%)") ytitle("Dimension 2 (20.0%)") ///
legend(pos(6) col(3) order(1 "Cluster 1" 2 "Cluster 2" 3 "Cluster 3")) ///
name(clus, replace) aspectratio(1)

*** Combine
grc1leg htree clus, leg(clus) name(hac_comb, replace)


*** Characterise cluster
*Excel file directly



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
