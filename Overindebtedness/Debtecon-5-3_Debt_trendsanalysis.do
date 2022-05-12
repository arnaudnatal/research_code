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
* Datasets preparation
****************************************
cls
graph drop _all
use"panel_v5_wide", clear

encode HHID_panel, gen(panelvar)

********** Cross section verification of DSR/loanamount
tabstat loanamount2010 loanamount2016 loanamount2020, stat(n mean sd q)
tabstat DSR2010 DSR2016 DSR2020, stat(n mean sd q)

********** Var to use
global var3 cro_annualincome2010 cro_assets_noland2010 cro_loanamount2010 cro_DSR2010 cro_DAR_without2010 cro_DIR2010 cro_ISR2010 cro_DAR_with2010 cro_annualincome2016 cro_assets_noland2016 cro_loanamount2016 cro_DSR2016 cro_DAR_without2016 cro_DIR2016 cro_ISR2016 cro_DAR_with2016 cro_annualincome2020 cro_assets_noland2020 cro_loanamount2020 cro_DSR2020 cro_DAR_without2020 cro_DIR2020 cro_ISR2020 cro_DAR_with2020

global var4 ihs_ISR2010 ihs_ISR102010 ihs_ISR1002010 ihs_ISR10002010 ihs_ISR100002010 ihs_DAR2010 ihs_DAR102010 ihs_DAR1002010 ihs_DAR10002010 ihs_DAR100002010 ihs_DSR2010 ihs_DSR102010 ihs_DSR1002010 ihs_DSR10002010 ihs_DSR100002010 ihs_ISR2016 ihs_ISR102016 ihs_ISR1002016 ihs_ISR10002016 ihs_ISR100002016 ihs_DAR2016 ihs_DAR102016 ihs_DAR1002016 ihs_DAR10002016 ihs_DAR100002016 ihs_DSR2016 ihs_DSR102016 ihs_DSR1002016 ihs_DSR10002016 ihs_DSR100002016 ihs_ISR2020 ihs_ISR102020 ihs_ISR1002020 ihs_ISR10002020 ihs_ISR100002020 ihs_DAR2020 ihs_DAR102020 ihs_DAR1002020 ihs_DAR10002020 ihs_DAR100002020 ihs_DSR2020 ihs_DSR102020 ihs_DSR1002020 ihs_DSR10002020 ihs_DSR100002020

global var5 log_yearly_expenses2010 log_annualincome2010 log_assets_noland2010 log_assets2010 log_loanamount2010 log_ISR102010 log_ISR1002010 log_ISR10002010 log_ISR100002010 log_ISR2010 log_DAR102010 log_DAR1002010 log_DAR10002010 log_DAR100002010 log_DAR2010 log_DSR102010 log_DSR1002010 log_DSR10002010 log_DSR100002010 log_DSR2010 log_yearly_expenses2016 log_annualincome2016 log_assets_noland2016 log_assets2016 log_loanamount2016 log_ISR102016 log_ISR1002016 log_ISR10002016 log_ISR100002016 log_ISR2016 log_DAR102016 log_DAR1002016 log_DAR10002016 log_DAR100002016 log_DAR2016 log_DSR102016 log_DSR1002016 log_DSR10002016 log_DSR100002016 log_DSR2016 log_yearly_expenses2020 log_annualincome2020 log_assets_noland2020 log_assets2020 log_loanamount2020 log_ISR102020 log_ISR1002020 log_ISR10002020 log_ISR100002020 log_ISR2020 log_DAR102020 log_DAR1002020 log_DAR10002020 log_DAR100002020 log_DAR2020 log_DSR102020 log_DSR1002020 log_DSR10002020 log_DSR100002020 log_DSR2020 ihs_annualincome2010 ihs_annualincome2016 ihs_annualincome2020 ihs_loanamount2010 ihs_loanamount2016 ihs_loanamount2020 ihs_assets_noland2010 ihs_assets_noland2016 ihs_assets_noland2020

global var6 head_edulevel2010 head_occupation2010 wifehusb_edulevel2010 wifehusb_occupation2010 mainocc_occupation2010 cat_income cat_assets sizeownland2010 DSR302010 DSR402010 DSR502010 path_30 path_40 path_50

ta sizeownland2010
gen dummyownland2010=1
replace dummyownland2010=0 if sizeownland2010==.
ta dummyownland2010

***** Clean
drop DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020


***** Keep
keep HHID_panel panelvar caste jatis villagearea* villageid* loanamount* DSR* DAR_without* DAR_with* annualincome* assets_noland* yearly_expenses* ISR* DIR* $var2 $var3 $var4 $var5 $var6 dummyownland2010

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
drop panelvar
order HHID_panel

********** R preparation data
foreach x in annualincome DSR loanamount DIR villageid yearly_expenses assets_noland villagearea DAR_without DAR_with ISR log_yearly_expenses log_annualincome log_assets_noland log_assets log_loanamount cro_annualincome cro_assets_noland cro_DSR cro_ISR cro_DAR_without ihs_DSR1000 ihs_DAR1000 ihs_ISR1000 ihs_annualincome ihs_assets_noland ihs_loanamount {
rename `x'2010 `x'1
rename `x'2016 `x'2
rename `x'2020 `x'3
}

foreach x in annualincome loanamount yearly_expenses assets_noland {
replace `x'1=`x'1/1000
replace `x'2=`x'2/1000
replace `x'3=`x'3/1000
}


*** For debt
preserve
drop if log_loanamount1==0
drop if log_loanamount2==0
drop if log_loanamount3==0
export delimited using "$git\Analysis\Overindebtedness\debttrend_v2.csv", replace
restore


*** Clean 100 10 10 000, etc.
drop log_ISR100002010 log_DAR100002010 log_DSR100002010 ihs_ISR100002010 ihs_DAR100002010 ihs_DSR100002010 log_ISR100002016 log_DAR100002016 log_DSR100002016 ihs_ISR100002016 ihs_DAR100002016 ihs_DSR100002016 log_ISR100002020 log_DAR100002020 log_DSR100002020 ihs_ISR100002020 ihs_DAR100002020 ihs_DSR100002020
drop log_ISR1002010 log_DAR1002010 log_DSR1002010 ihs_ISR1002010 ihs_DAR1002010 ihs_DSR1002010 log_ISR1002016 log_DAR1002016 log_DSR1002016 ihs_ISR1002016 ihs_DAR1002016 ihs_DSR1002016 log_ISR1002020 log_DAR1002020 log_DSR1002020 ihs_ISR1002020 ihs_DAR1002020 ihs_DSR1002020
drop log_ISR102010 log_DAR102010 log_DSR102010 ihs_ISR102010 ihs_DAR102010 ihs_DSR102010 log_ISR102016 log_DAR102016 log_DSR102016 ihs_ISR102016 ihs_DAR102016 ihs_DSR102016 log_ISR102020 log_DAR102020 log_DSR102020 ihs_ISR102020 ihs_DAR102020 ihs_DSR102020
drop log_ISR10002010 log_DAR10002010 log_DSR10002010 log_ISR10002016 log_DAR10002016 log_DSR10002016 log_ISR10002020 log_DAR10002020 log_DSR10002020
drop ihs_DAR2010 ihs_DAR2016 ihs_DAR2020 ihs_DSR2010 ihs_DSR2016 ihs_DSR2020 ihs_ISR2010 ihs_ISR2016 ihs_ISR2020
drop cro_DAR_with2010 cro_DAR_with2016 cro_DAR_with2020

forvalues i=1(1)3 {
rename cro_DAR_without`i' cro_DAR`i'
}

foreach x in ISR DSR DAR {
rename ihs_`x'10001 ihs_`x'1
rename ihs_`x'10002 ihs_`x'2
rename ihs_`x'10003 ihs_`x'3
}

export delimited using "$git\Analysis\Overindebtedness\debttrend.csv", replace


*****
*****
********* R analysis
*****
*****


********** Graph cluster
import delimited using "$git\Analysis\Overindebtedness\debttrendRreturn.csv", clear

rename hhid_panel HHID_panel
encode HHID_panel, gen(panelvar)
drop v1

preserve
import delimited using "$git\Analysis\Overindebtedness\debttrendRreturn_v2.csv", clear
rename hhid_panel HHID_panel
keep HHID_panel cl_loan
save"$git\Analysis\Overindebtedness\debttrendRreturn_v2.dta", replace
restore

merge 1:1 HHID_panel using "$git\Analysis\Overindebtedness\debttrendRreturn_v2.dta"
drop _merge

erase "$git\Analysis\Overindebtedness\debttrendRreturn_v2.dta"

order HHID_panel panelvar
sort HHID_panel

save"panel_v6_wide_cluster", replace
****************************************
* END








****************************************
* Line following classification
****************************************
cls
graph drop _all
use"panel_v6_wide_cluster", clear


***** Var to keep
keep HHID_panel panelvar cl_* loanamount1 loanamount2 loanamount3 annualincome1 annualincome2 annualincome3 assets_noland1 assets_noland2 assets_noland3 yearly_expenses1 yearly_expenses2 yearly_expenses3 log_*


***** Reshape
reshape long loanamount annualincome assets_noland yearly_expenses log_loanamount log_annualincome log_assets_noland log_yearly_expenses, i(HHID_panel) j(time)


***** Panel declaration
xtset panelvar time


***** Add 6 missings in loanamount
order HHID_panel time cl_loanamount log_loanamount
sort cl_loanamount HHID_panel time
replace cl_loanamount=2 if HHID_panel=="GOV29"
replace cl_loanamount=2 if HHID_panel=="KAR29"
replace cl_loanamount=2 if HHID_panel=="KAR3"
replace cl_loanamount=2 if HHID_panel=="ORA52"

replace cl_loanamount=3 if HHID_panel=="GOV22"
replace cl_loanamount=3 if HHID_panel=="GOV4"

ta cl_assets_noland time
recode cl_assets_noland (2=1) (3=2) (4=3)


***** Label of categories
label define cl_annualincome 1"Inc-Sta" 2"Inc-Dec" 3"Dec-Inc"
label define cl_loanamount 1"Inc-Inc" 2"Dec-Inc" 3"Inc-Dec"
label define cl_assets_noland 1"Dec-Inc" 2"Dec-Dec" 3"Inc-Dec"
label define cl_yearly_expenses 1"Inc-Sta" 2"Dec-Inc" 3"Dec-Dec" 4"Inc-Dec"

label values cl_annualincome cl_annualincome
label values cl_loanamount cl_loanamount
label values cl_assets_noland cl_assets_noland
label values cl_yearly_expenses cl_yearly_expenses


***** Reshape for merging
keep HHID_panel cl_*
duplicates drop

rename cl_loanamount cl_loanamount_clean
rename cl_annualincome cl_annualincome_clean
rename cl_assets_noland cl_assets_noland_clean
rename cl_yearly_expenses cl_yearly_expenses_clean

merge 1:1 HHID_panel using "panel_v5_wide_cluster"
drop _merge

*drop ce_DSR_1 ce_DSR_2 ce_DSR_3 ce_DSR_4 ce_DSR_5 ce_DSR_6 ce_DAR_without_1 ce_DAR_without_2 ce_DAR_without_3 ce_DAR_without_4 ce_DAR_without_5 ce_DAR_without_6 ce_loanamount_1 ce_loanamount_2 ce_loanamount_3 ce_loanamount_4 ce_loanamount_5 ce_loanamount_6 ce_income_1 ce_income_2 ce_income_3 ce_income_4 ce_income_5 ce_income_6 ce_assetsnl_1 ce_assetsnl_2 ce_assetsnl_3 ce_assetsnl_4 ce_assetsnl_5 ce_assetsnl_6

order cl_*, last

rename cl_loanamount_clean cl_loanamount
rename cl_annualincome_clean cl_annualincome
rename cl_assets_noland_clean cl_assets_noland
rename cl_yearly_expenses_clean cl_yearly_expenses

label var cl_loanamount "Debt"
label var cl_annualincome "Income"
label var cl_assets_noland "Assets"
label var cl_yearly_expenses "Expenses"

fre cl_*


*** Check supplementary variables
rename villageid2016 villageid
drop villageid2010 villageid2020

ta villagearea2010 villagearea2016
ta villagearea2016 villagearea2020
gen villagearea=villagearea2016
drop villagearea2010 villagearea2016 villagearea2020

ta caste
ta jatis


save"panel_v7_wide_cluster", replace

export delimited using "$git\Analysis\Overindebtedness\debttrend_v3.csv", replace
****************************************
* END









****************************************
* Clean line trends
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear

***** Var to keep
keep HHID_panel panelvar cl_* loanamount2010 loanamount2016 loanamount2020 annualincome2010 annualincome2016 annualincome2020 assets_noland2010 assets_noland2016 assets_noland2020 yearly_expenses2010 yearly_expenses2016 yearly_expenses2020 log_* DSR2010 DSR2016 DSR2020 ISR2010 ISR2016 ISR2020 DAR_without2010 DAR_without2016 DAR_without2020


***** Reshape
reshape long loanamount annualincome assets_noland yearly_expenses log_loanamount log_annualincome log_assets_noland log_yearly_expenses ISR DSR DAR_without, i(HHID_panel) j(year)


***** Panel declaration
xtset panelvar year


***** Line graph
tabstat log_loanamount log_annualincome log_assets_noland log_yearly_expenses, stat(n mean sd p50 min max)
fre cl_*

set graph off

*** Loan amount
sort cl_loanamount panelvar year
forvalues i=1(1)3{
twoway (line log_loanamount year if cl_loanamount==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(0(3)15) ymtick(0(1)15) ytitle("log(Loan amount)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_loanamount_`i', replace)
}
graph combine gph_loanamount_1 gph_loanamount_2 gph_loanamount_3, col(3) name(gph_loanamount, replace)



*** Annual income
sort cl_annualincome panelvar year
forvalues i=1(1)3{
twoway (line log_annualincome year if cl_annualincome==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(6(2)14) ymtick(6(1)14) ytitle("log(Income)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_annualincome_`i', replace)
}
graph combine gph_annualincome_1 gph_annualincome_2 gph_annualincome_3, col(3) name(gph_annualincome, replace) 



*** Assets
sort cl_assets_noland panelvar year
forvalues i=1(1)3{
twoway (line log_assets_noland year if cl_assets_noland==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(6(2)16) ymtick(6(1)16) ytitle("log(Assets)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_assets_noland_`i', replace)
}
graph combine gph_assets_noland_1 gph_assets_noland_2 gph_assets_noland_3, col(4) name(gph_assets_noland, replace)



*** Expenses
sort cl_yearly_expenses panelvar year
forvalues i=1(1)4{
twoway (line log_yearly_expenses year if cl_yearly_expenses==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel(8(2)14) ymtick(8(1)14) ytitle("log(Expenses)") ///
title("Cluster `i'") ///
aspectratio(0.5) graphregion(margin(zero)) plotregion(margin(zero))  ///
name(gph_yearly_expenses_`i', replace)
}
graph combine gph_yearly_expenses_1 gph_yearly_expenses_2 gph_yearly_expenses_3 gph_yearly_expenses_4, col(4) name(gph_yearly_expenses, replace)

set graph on



*** Combine all in the same
graph combine gph_assets_noland gph_annualincome gph_loanamount, col(1) name(comb_gph, replace)
graph export "graph/comb_gph.pdf", as(pdf) replace

****************************************
* END
*/










****************************************
* Statistics following classification
****************************************
cls
graph drop _all
use"panel_v7_wide_cluster", clear


set graph off

********** MCA without expenses
mca cl_loanamount cl_annualincome cl_assets_noland, meth(ind) normal(princ) dim(4) comp
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
predict d1_nf d2_nf

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
