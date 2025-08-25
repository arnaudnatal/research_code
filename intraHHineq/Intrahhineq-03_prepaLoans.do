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

keep HHID2010 loanid loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_* plantorep_* dummymainloan othlendserv_* dummyinterest guarantee_* loanduration imp1_debt_service imp1_interest_service

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
keep HHID2016 INDID2016 loanid loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_* loan_database plantorep_* settlestrat_* dummymainloan othlendserv_* dummyinterest guarantee_* loanduration imp1_debt_service imp1_interest_service

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

keep HHID2020 INDID2020 loanid loanreasongiven loanlender loansettled loanamount lender_cat reason_cat lender4 loanamount2 loanbalance2 interestpaid2 totalrepaid2 principalpaid2 effective_* loan_database plantorep_* settlestrat_* dummymainloan othlendserv_* dummyinterest guarantee_* loanduration imp1_debt_service imp1_interest_service

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
merge m:1 HHID_panel year using "panel_v2", keepusing(caste)
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
* Loan to HH level
****************************************
use"panel_v2", clear
/*
Il y a dans la base ménage déjà le montant abs et rel de la dette
*/

*
use"panel_loans_v1", clear

* Debt trap
preserve
ta effective_repa year
keep if effective_repa==1
keep HHID_panel year effective_repa
duplicates drop
rename effective_repa dummytrap
save"_temp_trap", replace
restore

***** Database creation
drop if loan_database=="GOLD"
drop if loan_database=="MARRIAGE"
fre year
gen debt_prod=0
replace debt_prod=1 if effective_agri==1
replace debt_prod=1 if effective_inve==1
ta debt_prod
keep HHID_panel year debt_prod imp1_debt_service imp1_interest_service loanamount

foreach x in imp1_debt_service imp1_interest_service loanamount {
gen `x'_prod=`x' if debt_prod==1
gen `x'_nonprod=`x' if debt_prod==0
}

gen debt_nonprod=.
replace debt_nonprod=1 if debt_prod==0
replace debt_nonprod=0 if debt_prod==1
ta debt_nonprod debt_prod
order debt_nonprod, after(debt_prod)

collapse (sum) loanamount debt_prod debt_nonprod imp1_debt_service_prod imp1_debt_service_nonprod imp1_interest_service_prod imp1_interest_service_nonprod loanamount_prod loanamount_nonprod imp1_debt_service imp1_interest_service, by(HHID_panel year)
ta year

* Rename 
rename imp1_debt_service imp1_ds_tot_HH_v2
rename imp1_interest_service imp1_is_tot_HH_v2

* Recourse to different type of debt
gen cat_typeofdebt=.
replace cat_typeofdebt=1 if debt_prod==0 & debt_nonprod>0
replace cat_typeofdebt=2 if debt_prod>0 & debt_nonprod==0
replace cat_typeofdebt=3 if debt_prod>0 & debt_nonprod>0
label define cat_typeofdebt 1"Non-prod" 2"Prod" 3"Both"
label values cat_typeofdebt cat_typeofdebt
fre cat_typeofdebt

* Dummy prod debt
gen dummy_debt_prod=.
replace dummy_debt_prod=0 if debt_prod==0
replace dummy_debt_prod=1 if debt_prod>0
label define dummy_debt_prod 0"Prod: No" 1"Prod: Yes"
label values dummy_debt_prod dummy_debt_prod
fre dummy_debt_prod

* Dummy non prod debt
gen dummy_debt_nonprod=.
replace dummy_debt_nonprod=0 if debt_nonprod==0
replace dummy_debt_nonprod=1 if debt_nonprod>0
label define dummy_debt_nonprod 0"Non-prod: No" 1"Non-prod: Yes"
label values dummy_debt_nonprod dummy_debt_nonprod
fre dummy_debt_nonprod

* Share of in total amount
gen shareamount_prod=loanamount_prod/loanamount
gen shareamount_nonprod=loanamount_nonprod/loanamount

drop loanamount debt_prod debt_nonprod loanamount_prod loanamount_nonprod
order HHID_panel year cat_typeofdebt ///
dummy_debt_prod shareamount_prod imp1_debt_service_prod imp1_interest_service_prod ///
dummy_debt_nonprod shareamount_nonprod imp1_debt_service_nonprod imp1_interest_service_nonprod

rename imp1_interest_service_prod imp1_is_tot_HH_prod
rename imp1_debt_service_prod imp1_ds_tot_HH_prod
rename imp1_interest_service_nonprod imp1_is_tot_HH_nonprod
rename imp1_debt_service_nonprod imp1_ds_tot_HH_nonprod

drop imp1_ds_tot_HH_v2 imp1_is_tot_HH_v2

save"_temp_prod", replace


********** Merge with HH data
use"panel_v2", clear

* Dummy
gen debt_HH=0
replace debt_HH=1 if nbloans_HH>0 & nbloans_HH!=.
order debt_HH, before(nbloans_HH)
ta debt_HH year

* Trap
merge 1:1 HHID_panel year using "_temp_trap"
drop _merge
replace dummytrap=0 if debt_HH==1 & dummytrap==.
replace dummytrap=. if debt_HH==0

* Structure
merge 1:1 HHID_panel year using "_temp_prod"
drop _merge

* dsr et isr pour prod 
gen dsr_prod=imp1_ds_tot_HH_prod/annualincome_HH
gen isr_prod=imp1_is_tot_HH_prod/annualincome_HH

* dsr et isr pour non-prod 
gen dsr_nonprod=imp1_ds_tot_HH_nonprod/annualincome_HH
gen isr_nonprod=imp1_is_tot_HH_nonprod/annualincome_HH

tabstat dsr_prod dsr_nonprod, stat(n mean p50) by(year) long

* Clean
drop imp1_ds_tot_HH imp1_is_tot_HH imp1_ds_tot_HH_prod imp1_is_tot_HH_prod imp1_ds_tot_HH_nonprod imp1_is_tot_HH_nonprod
drop annualincome_HH shareincomeagri_HH shareincomenonagri_HH

order debt_HH nbloans_HH loanamount_HH, before(dsr)
order dummytrap cat_typeofdebt dummy_debt_prod shareamount_prod dummy_debt_nonprod shareamount_nonprod dsr_prod isr_prod dsr_nonprod isr_nonprod, after(dar)


save"panel_v3", replace
****************************************
* END
