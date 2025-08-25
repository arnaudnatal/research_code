*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "intraHHineq"
*Prepa loans
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\intraHHineq.do"
*-------------------------














****************************************
* RUME (2010)
****************************************
use"raw/RUME-loans_mainloans_new.dta", replace

gen dummymainloan=0
replace dummymainloan=1 if borrowerservices!=.
ta dummymainloan

keep HHID2010 loanid loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa plantorep_* dummymainloan othlendserv_* dummyinterest guarantee_* loanduration

merge m:m HHID2010 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

fre lender4
fre loanid

save"_temp_RUME-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-1 (2016-17)
****************************************
use"raw/NEEMSIS1-loans_mainloans_new.dta", replace

* 
ta loanid loan_database, m
tostring loanid, replace
replace loanid=goldid if loanid=="." & goldid!=""
replace loanid=marriageid if loanid=="." & marriageid!=""
ta loanid loan_database, m
drop goldid marriageid

*
gen dummymainloan=0
replace dummymainloan=1 if borrowerservices!=""
ta dummymainloan

ta loan_database
drop if loan_database=="MARRIAGE"
keep HHID2016 INDID2016 loanid loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa loan_database plantorep_* settlestrat_* dummymainloan othlendserv_* dummyinterest guarantee_* loanduration

merge m:m HHID2016 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge

save"_temp_NEEMSIS1-loans.dta", replace
****************************************
* END













****************************************
* NEEMSIS-2 (2020-21)
****************************************
use"raw/NEEMSIS2-loans_mainloans_new.dta", replace

* 
ta loanid loan_database, m
tostring loanid, replace
replace loanid=goldid if loanid=="." & goldid!=""
replace loanid=marriageid if loanid=="." & marriageid!=""
ta loanid loan_database, m
drop goldid marriageid

*
drop dummymainloan
gen dummymainloan=0
replace dummymainloan=1 if borrowerservices!=""
ta dummymainloan

drop effective_*
ta loaneffectivereason loan_database, m
ta loaneffectivereason, gen(effective_)
rename effective_1 effective_agri
rename effective_2 effective_fami
rename effective_3 effective_heal
rename effective_4 effective_repa
rename effective_5 effective_hous
rename effective_6 effective_inve
rename effective_7 effective_cere
rename effective_8 effective_marr
rename effective_9 effective_educ
rename effective_10 effective_rela
rename effective_11 effective_deat
rename effective_12 effective_nore
rename effective_13 effective_othe

fre loaneffectivereason2
gen effective_repa2=effective_repa
replace effective_repa2=1 if loaneffectivereason2==4 & effective_repa2!=. & effective_repa2!=1
ta effective_repa2

keep HHID2020 INDID2020 loanid loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_repa loan_database plantorep_* settlestrat_* dummymainloan othlendserv_* dummyinterest guarantee_* loanduration

merge m:m HHID2020 using "raw/keypanel-HH_wide.dta", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-Indiv_wide.dta", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* How many HH?
preserve
keep if effective_repa==1
keep HHID_panel effective_repa
duplicates drop
restore


save"_temp_NEEMSIS2-loans.dta", replace
****************************************
* END











****************************************
* Append
****************************************
use"_temp_NEEMSIS2-loans", replace

append using "_temp_NEEMSIS1-loans"
append using "_temp_RUME-loans"

* Souci label lender4
fre lender4
label define lender4 1"WKP" 2"Relatives" 3"Labour" 4"Pawn broker" 5"Shop keeper" 6"Moneylenders" 7"Friends" 8"Microcredit" 9"Bank" 10"Neighbor"
label values lender4 lender4
fre lender4


gen test=loanamount-loanamount2
ta test
drop test loanamount

foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
rename `x'2 `x'
}

order HHID_panel year loanamount loansettled loanreasongiven loanlender 


********** Selection of the 6 households
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020



*** Deflate and round
foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid {
replace `x'=`x'*(100/54) if year==2010
replace `x'=`x'*(100/86) if year==2016
replace `x'=round(`x',1)
replace `x'=`x'/1000
}



* New cat for lenders
ta loanlender lender_cat
fre lender4
gen lender4cat=.
replace lender4cat=1 if lender4==1
replace lender4cat=1 if lender4==2
replace lender4cat=1 if lender4==3
replace lender4cat=1 if lender4==4
replace lender4cat=1 if lender4==5
replace lender4cat=2 if lender4==6
replace lender4cat=1 if lender4==7
replace lender4cat=2 if lender4==8
replace lender4cat=2 if lender4==9
replace lender4cat=1 if lender4==10

label define lender4cat 1"Informal" 2"Formal"
label values lender4cat lender4cat


ta lender_cat lender4cat
drop lender_cat

order HHID_panel INDID_panel year

* Given pour repayer
fre loanreasongiven
gen given_repa=1 if loanreasongiven==4
recode given_repa (.=0)

ta effective_repa year, col
ta loanreasongiven effective_repa if year==2016
ta loanreasongiven effective_repa if year==2020

*
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020

* Supprimer les morts et les migrants en 2016-17
destring INDID2016, replace
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(livinghome)
drop if _merge==2
drop _merge
drop if livinghome==3
drop if livinghome==4
drop livinghome

* Supprimer les morts et les migrants en 2020-21
destring INDID2020, replace
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(dummylefthousehold livinghome)
drop if _merge==2
drop _merge
drop if dummylefthousehold==1
drop if livinghome==3
drop if livinghome==4
drop dummylefthousehold livinghome

* INDID
drop HHID2010 HHID2016 HHID2020 INDID2016 INDID2020
order HHID_panel INDID_panel loanid year loanamount loanreasongiven loanlender dummymainloan othlendserv_6

* Check duplicates
preserve
keep if year==2010
keep HHID_panel loanid
duplicates tag, gen(tag)
ta tag
restore

preserve
keep if year==2016
keep HHID_panel INDID_panel loanid
duplicates tag, gen(tag)
ta tag
restore

preserve
keep if year==2020
keep HHID_panel INDID_panel loanid
duplicates tag, gen(tag)
ta tag
restore

*
replace loanduration=1 if loanduration<0

save"panel_loans_v0", replace
****************************************
* END












****************************************
* Loan level
****************************************
use"panel_loans_v0", clear

* Merge sex and drop died
merge m:1 HHID_panel INDID_panel year using "panelindiv_v1", keepusing(sex)
drop if _merge==2
drop _merge

* Merge caste
merge m:1 HHID_panel year using "panel_v1", keepusing(caste)
drop if _merge==2
drop _merge
order HHID_panel INDID_panel year caste sex 

* Cat of amount
xtile catloanamount=loanamount, n(5)
label define catloanamount 1"A: Vlow" 2"A: Low" 3"A: Int" 4"A: High" 5"A: Vhigh"
label values catloanamount catloanamount
tabstat loanamount, stat(min max) by(catloanamount)
order catloanamount, after(loanamount)

* Cat of amount for main loans
xtile catmainloanamount=loanamount if dummymainloan==1, n(5)
label define catmainloanamount 1"A: Vlow" 2"A: Low" 3"A: Int" 4"A: High" 5"A: Vhigh"
label values catmainloanamount catmainloanamount
tabstat loanamount, stat(min max) by(catmainloanamount)
order catmainloanamount, after(catloanamount)
ta catmainloanamount catloanamount


********** Prepa for R
*
fre catloanamount
*
fre loanreasongiven
recode loanreasongiven (8=7) (11=7)
drop if loanreasongiven==12
drop if loanreasongiven==77
label define loanreasongiven 1"R: Agri" 2"R: Fam" 3"R: Heal" 4"R: Rep" 5"R: Hou" 6"R: Inv" 7"R: Cere" 9"R: Educ" 10"R: Rela", modify
*
fre reason_cat
label define reason_cat 1"R: Eco" 2"R: Cur" 3"R: Hum" 4"R: Soc" 5"R: Hou", modify
*
fre lender4
recode lender4 (5=10)
label define lender4 1"L: WKP" 2"L: Rel" 3"L: Lab" 4"L: Paw" 6"L: Mon" 7"L: Fri" 8"L: Mic" 9"L: Ban" 10"L: Nei", modify
*
fre lender4cat
label define lender4cat 1"L: Inf" 2"L: For", modify
*
gen otherlenderservice=0
replace otherlenderservice=1 if othlendserv_poli==1 | othlendserv_guar==1 | othlendserv_gene==1 | othlendserv_othe==1
label var otherlenderservice "LenServ: Y"
label define otherlenderservice 0"LenServ: N" 1"LenServ: Y"
label values otherlenderservice otherlenderservice
ta otherlenderservice
*
gen guarantee=0
replace guarantee=1 if guarantee_docu==1
replace guarantee=1 if guarantee_chit==1
replace guarantee=1 if guarantee_shg==1
replace guarantee=1 if guarantee_pers==1
replace guarantee=1 if guarantee_jewe==1
replace guarantee=1 if guarantee_other==1
replace guarantee=1 if guarantee_doc==1
replace guarantee=1 if guarantee_othe==1
replace guarantee=1 if guarantee_both==1
replace guarantee=0 if guarantee_none==1
label var guarantee "Guar: Y"
label define guarantee 0"Guar: N" 1"Guar: Y"
label values guarantee guarantee
*
fre dummyinterest
recode dummyinterest (88=0)
label var dummyinterest "Int: Y"
label define dummyinterest 0"Int: N" 1"Int: Y", replace
label values dummyinterest dummyinterest
*


save"panel_loans_v1", replace
****************************************
* END













****************************************
* Long lender
****************************************
use"panel_loans_v1", clear

fre dummyinterest
drop if dummyinterest==88

ta lender4 year, col nofreq


********** All loans
preserve
keep lender4 reason_cat catloanamount
rename lender4 lender
rename reason_cat reason
rename catloanamount amount
export delimited using "Allloans.csv", replace
restore


********** All loans details
preserve
keep lender4 loanreasongiven catloanamount
rename lender4 lender
rename loanreasongiven reason
rename catloanamount amount
ta reason
export delimited using "Allloans2.csv", replace
restore


********** Main loans
preserve
keep if dummymainloan==1
keep lender4 reason_cat catmainloanamount dummyinterest guarantee otherlenderservice
rename lender4 lender
rename reason_cat reason
rename catmainloanamount amount
rename dummyinterest interest
rename otherlenderservice services
export delimited using "Mainloans.csv", replace
restore

****************************************
* END





















****************************************
* MCA 1
****************************************
use"panel_loans_v1", clear

* Selection
keep HHID_panel INDID_panel loanid year ///
lender4 reason_cat catloanamount

* Rename
rename lender4 lender
rename reason_cat reason
rename catloanamount amount

fre lender
fre reason
fre amount

* Macro
global var lender reason amount

* MCA
mca $var, method (indicator) normal(princ)

* Cluster
mca $var, method (indicator) normal(princ) dim(10)
predict a1 a2 a3 a4 a5 a6 a7 a8 a9 a10
cluster wardslinkage a1 a2 a3 a4 a5 a6 a7 a8 a9 a10, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clustloan1=groups(10)

* Keep
keep HHID_panel INDID_panel loanid year clustloan1 _clus_*

save"clustloan1", replace
****************************************
* END










****************************************
* MCA 2
****************************************
use"panel_loans_v1", clear

* Selection
keep if dummymainloan==1
keep HHID_panel INDID_panel loanid year ///
lender4 reason_cat catmainloanamount dummyinterest guarantee otherlenderservice

* Rename
rename lender4 lender
rename reason_cat reason
rename catmainloanamount amount
rename dummyinterest interest
rename otherlenderservice services

* Macro
global var lender reason amount interest guarantee services

* MCA
mca $var, method (indicator) normal(princ)

* Cluster
mca $var, method (indicator) normal(princ) dim(11)
predict a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11
cluster wardslinkage a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11, measure(Euclidean)
*cluster dendrogram, cutnumber(50)
cluster gen clustloan2=groups(9)

* Keep
keep HHID_panel INDID_panel loanid year clustloan2 _clus_*

save"clustloan2", replace
****************************************
* END










****************************************
* Merge with main database
****************************************

********** Separer 2010 du reste
foreach i in 1 2 {
use"clustloan`i'", clear
keep if year==2010
drop INDID_panel
rename _clus_1_id _clus`i'_id
rename _clus_1_ord _clus`i'_ord
rename _clus_1_hgt _clus`i'_hgt
save"clustloan`i'_2010", replace

use"clustloan`i'", clear
drop if year==2010
rename _clus_1_id _clus`i'_id
rename _clus_1_ord _clus`i'_ord
rename _clus_1_hgt _clus`i'_hgt
save"clustloan`i'_reste", replace
}



********** Aussi sur la base "main"
use"panel_loans_v1", clear
keep if year==2010
drop INDID_panel
save"panel_loans_v1_2010", replace

use"panel_loans_v1", clear
drop if year==2010
save"panel_loans_v1_reste", replace


********** Merger 2010
use"panel_loans_v1_2010", clear
*
merge 1:1 HHID_panel loanid using "clustloan1_2010"
drop _merge
*
merge 1:1 HHID_panel loanid using "clustloan2_2010"
drop _merge

save"panel_loans_v1_clust_2010", replace


********** Merger reste
use"panel_loans_v1_reste", clear

*
merge 1:1 HHID_panel INDID_panel loanid year using "clustloan1_reste"
drop _merge
*
merge 1:1 HHID_panel INDID_panel loanid year using "clustloan2_reste"
drop _merge

save"panel_loans_v1_clust_reste", replace



********** Append 2010 avec le reste
use"panel_loans_v1_clust_2010", clear

append using "panel_loans_v1_clust_reste"

save"panel_loans_v1_clust", replace
****************************************
* END















****************************************
* Loan to HH level
****************************************
use"panel_v1", clear
/*
Il y a dans la base ménage déjà le montant abs et rel de la dette
*/

*
use"panel_loans_v1", clear

* Debt trap




*


save"panel_loans_v1_HH", replace
****************************************
* END
