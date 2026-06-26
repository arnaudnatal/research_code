*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 20, 2026
*-----
gl link = "evolutions"
*Prepa HH
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\evolutions.do"
*-------------------------





****************************************
* 2010
****************************************
use"raw/RUME-HH", clear

* Savings
sort HHID2010 INDID2010
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3)
bysort HHID2010: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2010 village villagearea ownland house housetitle savings_HH
fre house housetitle
gen livingarea=1

* Clean
decode village, gen(villageid)
drop village
rename villageid village
replace village="ELA" if village=="ELANTHALMPATTU"
replace village="GOV" if village=="GOVULAPURAM"
replace village="KOR" if village=="KORATTORE"
replace village="KAR" if village=="KARUMBUR"
replace village="KUV" if village=="KUVAGAM"
replace village="ORA" if village=="ORAIYURE"
replace village="SEM" if village=="SEMAKOTTAI"
replace village="MAN" if village=="MANAPAKKAM"
replace village="MANAM" if village=="MANAMTHAVIZHINTHAPUTHUR"
replace village="NAT" if village=="NATHAM"

decode villagearea, gen(vi)
drop villagearea
rename vi area
gen villageid=village

* Uniq HH
duplicates drop
count

* Family compo
merge 1:1 HHID2010 using "raw/RUME-family", keepusing(nbfemale nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge

* Add assets and expenses
merge 1:1 HHID2010 using "raw/RUME-assets", keepusing(assets_sizeownland assets_housevalue assets_livestock assets_goods assets_total)
drop _merge

* Add income
merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

* Add remittances
merge 1:1 HHID2010 using "raw/RUME-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH pension_HH)
drop _merge

* Gold
merge 1:1 HHID2010 using "raw/RUME-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Panel
merge 1:m HHID2010 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2010 HHID

*Year
gen year=2010
ta village livingarea


save"temp_RUME", replace
****************************************
* END












****************************************
* 2016-17
****************************************
use"raw/NEEMSIS1-HH", clear


* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2016: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2016 villagearea villageid dummydemonetisation dummymarriage ownland house housetitle savings_HH
fre house housetitle
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid

* Livingarea
merge 1:1 HHID2016 using "raw/NEEMSIS1-villages", keepusing(villagename2016 livingarea)
drop _merge
rename villagename2016 village
ta village livingarea

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2016 using "raw/NEEMSIS1-family",keepusing(nbfemale head_maritalstatus nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge

* Add assets and expenses
merge 1:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_sizeownland assets_housevalue assets_livestock assets_goods assets_total)
drop _merge

* Add income
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

* Add remittances
merge 1:1 HHID2016 using "raw/NEEMSIS1-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH pension_HH)
drop _merge 

* Gold
merge 1:1 HHID2016 using "raw/NEEMSIS1-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Panel
merge 1:m HHID2016 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2016 HHID

* Year
gen year=2016


save"temp_NEEMSIS1", replace
****************************************
* END



















****************************************
* 2020-21
****************************************
use"raw/NEEMSIS2-HH", clear

* Drop duplicates
drop if HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3 savingsamount4)
bysort HHID2020: egen savings_HH=sum(savings_indiv)

* Drop migrants
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
fre house
preserve
keep if house==""
ta dummyeverland2010
ta dummyeverhadland
restore

* To keep
keep HHID2020 villagearea villageid dummymarriage ownland ownland house housetitle compensation compensationamount savings_HH
fre house housetitle
destring house housetitle, replace
destring ownland, replace
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid


* Livingarea
merge 1:1 HHID2020 using "raw/NEEMSIS2-villages",keepusing(village_new livingarea)
drop _merge
rename village_new village
replace village="ELA" if village=="Elanthalmpattu"
replace village="GOV" if village=="Govulapuram"
replace village="KOR" if village=="Korattore"
replace village="KAR" if village=="Karumbur"
replace village="KUV" if village=="Kuvagam"
replace village="ORA" if village=="Oraiyure"
replace village="SEM" if village=="Semakottai"
replace village="MAN" if village=="Manapakkam"
replace village="MANAM" if village=="Manamthavizhinthaputhur"
replace village="NAT" if village=="Natham"
ta village livingarea

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2020 using "raw/NEEMSIS2-family", keepusing(nbfemale nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_maritalstatus head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge

* Add assets and expenses
merge 1:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_sizeownland assets_housevalue assets_livestock assets_goods assets_total)
drop _merge

* Add income
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

* Add remittances
merge 1:1 HHID2020 using "raw/NEEMSIS2-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH pension_HH)
drop _merge 

* Add gold
merge 1:1 HHID2020 using "raw/NEEMSIS2-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Add covid
merge 1:1 HHID2020 using "raw/NEEMSIS2-covid", keepusing(secondlockdownexposure dummysell dummyexposure)
drop _merge

* Panel
merge 1:m HHID2020 using"raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
rename HHID2020 HHID

* GPS
merge 1:1 HHID_panel using "raw/NEEMSIS2-GPS", keepusing(jatisdetails jatis)
keep if _merge==3
drop _merge

* Year
gen year=2020

*
decode jatis, gen(jatis2)
drop jatis
rename jatis2 jatis
drop jatisdetails

save"temp_NEEMSIS2", replace
****************************************
* END
















****************************************
* 2026
****************************************
use"raw/NEEMSIS3-HH", clear


*
drop if catindiv==2
drop if livinghome==3
drop if livinghome==4
drop if dummylefthousehold==1
drop if age==.

* Savings
egen savings_indiv=rowtotal(savingsamount1 savingsamount2 savingsamount3)
bysort HHID2026: egen savings_HH=sum(savings_indiv)

* To keep
keep HHID2026 HHID_panel villagearea villageid dummymarriage ownland ownland house housetitle savings_HH caste
fre house housetitle
destring house housetitle, replace
destring ownland, replace
duplicates drop
decode villagearea, gen(vi)
drop villagearea
rename vi area
decode villageid, gen(vi)
drop villageid
rename vi villageid

* Drop
duplicates drop
count

* Family compo
merge 1:1 HHID2026 using "raw/NEEMSIS3-family", keepusing(nbfemale head_maritalstatus nbmale HHsize HH_count_child typeoffamily head_sex head_age head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge

* Add assets and expenses
merge 1:1 HHID2026 using "raw/NEEMSIS3-assets", keepusing(assets_sizeownland assets_housevalue assets_livestock assets_goods assets_total)
drop _merge
destring assets_sizeownland, replace

* Add income
merge 1:1 HHID2026 using "raw/NEEMSIS3-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge

* Add remittances
merge 1:1 HHID2026 using "raw/NEEMSIS3-transferts_HH", keepusing(remreceived_HH remsent_HH remittnet_HH pension_HH)
drop _merge

* Add gold
merge 1:1 HHID2026 using "raw/NEEMSIS3-gold_HH", keepusing(goldquantity_HH)
drop _merge

* Year
gen year=2026


*
fre caste
decode caste, gen(jatis)
drop caste
fre jatis

rename HHID2026 HHID


save"temp_NEEMSIS3", replace
****************************************
* END










****************************************
* Debt measure
****************************************

********** 2010
use"raw/RUME-loans_mainloans_new", clear
keep HHID2010 imp1_interest_service imp1_debt_service loanbalance2 loanamount2
drop if imp1_debt_service==.
foreach x in imp1_interest_service imp1_debt_service loanbalance2 loanamount2 {
bys HHID2010: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}
rename HHID2010 HHID
duplicates drop
save"_temp", replace
*
use"temp_RUME", clear
merge 1:1 HHID using "_temp"
drop _merge
save"temp_RUME", replace



********** 2016
use"raw/NEEMSIS1-loans_mainloans_new", clear
keep HHID2016 imp1_interest_service imp1_debt_service loanbalance2 loanamount2
drop if imp1_debt_service==.
foreach x in imp1_interest_service imp1_debt_service loanbalance2 loanamount2 {
bys HHID2016: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}
rename HHID2016 HHID
duplicates drop
save"_temp", replace
*
use"temp_NEEMSIS1", clear
merge 1:1 HHID using "_temp"
drop _merge
save"temp_NEEMSIS1", replace


********** 2020
use"raw/NEEMSIS2-loans_mainloans_new", clear
keep HHID2020 imp1_interest_service imp1_debt_service loanbalance2 loanamount2
drop if imp1_debt_service==.
foreach x in imp1_interest_service imp1_debt_service loanbalance2 loanamount2 {
bys HHID2020: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}
rename HHID2020 HHID
duplicates drop
save"_temp", replace
*
use"temp_NEEMSIS2", clear
merge 1:1 HHID using "_temp"
drop _merge
save"temp_NEEMSIS2", replace


********** 2026
use"raw/NEEMSIS3-loans_mainloans_new", clear
keep HHID2026 imp1_interest_service imp1_debt_service loanbalance2 loanamount2
drop if imp1_debt_service==.
foreach x in imp1_interest_service imp1_debt_service loanbalance2 loanamount2 {
bys HHID2026: egen `x'_HH=sum(`x')
drop `x'
rename `x'_HH `x'
}
rename HHID2026 HHID
duplicates drop
save"_temp", replace
*
use"temp_NEEMSIS3", clear
merge 1:1 HHID using "_temp"
drop _merge
save"temp_NEEMSIS3", replace


****************************************
* END














****************************************
* Panel
****************************************
use"temp_NEEMSIS3", clear

* Append
append using "temp_NEEMSIS2"
append using "temp_NEEMSIS1"
append using "temp_RUME"


*
drop if HHID_panel=="KUV65"

* Housing pour selection
fre house
label define house 1"Own house" 2"Joint house" 3"Family property" 4"Rental" 77"Others", modify
label values house house
ta house year, m
list HHID_panel year if house==., clean noobs
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV67" & year==2020
drop if HHID_panel=="GOV65" & year==2020
fre housetitle
label values housetitle housetitle
ta housetitle year, m

* Dummy panel
bysort HHID_panel: gen n=_N
recode n (1=0) (2=0) (3=1)
rename n dummypanel
ta dummypanel
order HHID_panel HHID year dummypanel
sort HHID_panel year

* Shock
recode secondlockdownexposure (.=1)
recode dummydemonetisation (.=0)
recode dummymarriage (.=0)

* Quanti defalte and round
global quanti savings_HH head_mocc_annualincome head_annualincome imp1_interest_service imp1_debt_service loanbalance2 assets_housevalue assets_livestock assets_goods assets_total incomeagri_HH incomenonagri_HH annualincome_HH remreceived_HH remsent_HH remittnet_HH pension_HH

foreach x in $quanti {
replace `x'=`x'*(100/40) if year==2010
replace `x'=`x'*(100/63.2) if year==2016
replace `x'=`x'*(100/73.6) if year==2020
replace `x'=round(`x',1)
}

* Recode and replace
recode dummyexposure (.=0)
recode head_mocc_occupation (.=0)
recode head_nboccupation (.=0)

* Gen
gen dsr=imp1_debt_service*100/annualincome_HH
gen isr=imp1_interest_service*100/annualincome_HH
gen dar=loanbalance2*100/assets_total

tabstat dsr isr dar, stat(n mean p50) by(year)

* Selection
drop if housetitle==.
bysort HHID_panel: gen n=_N
ta n
dis 1146/3
drop n


save"panel_v0", replace
****************************************
* END



















****************************************
* Construction variables
****************************************
use"panel_v0", clear


********** Controls
* HH
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)
fre village villageid vill
ta vill, gen(village_)

* Caste
merge 1:1 HHID_panel year using "raw/JatisCastePanel"
drop if _merge==2
drop _merge

*
replace jatis=jatisn if jatis==""
ta jatis
encode jatis, gen(jatis_code)
drop jatis
rename jatis_code jatis
fre jatis

gen dalits=0
replace dalits=1 if jatis==1
replace dalits=1 if jatis==2
replace dalits=1 if jatis==19

replace dalits=1 if HHID_panel=="ELA11" & year==2026
replace dalits=1 if HHID_panel=="ELA3" & year==2026
replace dalits=0 if HHID_panel=="MANAM65" & year==2026
replace dalits=1 if HHID_panel=="MANAM7" & year==2026
replace dalits=1 if HHID_panel=="SEM6" & year==2026


* Time
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
replace time=4 if year==2026
label define time 1"2010" 2"2016-2017" 3"2020-2021" 4"2026"
label values time time
order time, after(year)


*** Head characteristics
*
fre head_maritalstatus
gen head_married=0
replace head_married=1 if head_maritalstatus==1
ta head_maritalstatus head_married
ta head_married
*
fre head_sex
gen head_female=0
replace head_female=1 if head_sex==2
ta head_sex head_female
*
fre head_edulevel
recode head_edulevel (4=3) (5=3)
ta head_edulevel, gen(head_edu)
*
fre head_mocc_occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)

*** Households
* 
fre villageid
ta villageid, gen(vill)

save "panel_v1", replace
****************************************
* END
















****************************************
* Pooled sample for debt trap
****************************************
use"panel_v1", clear

* Assets and income
gen logassets=log(assets_total+1)
gen logincome=log(annualincome_HH+1)

* Debt
rename loanamount2 debt
rename loanbalance2 debtbal


mdesc dsr isr dar logassets logincome debt debtbal
recode dsr isr dar debt debtbal (.=0)

global var dsr isr dar debt debtbal logassets logincome
keep HHID_panel year $var
reshape wide $var, i(HHID_panel) j(year)
*
foreach x in $var {
preserve
keep HHID_panel `x'2010 `x'2016
gen timeperiod=1
rename `x'2010 `x'_t
rename `x'2016 `x'_t1
save"_tp1_`x'", replace
restore
preserve
keep HHID_panel `x'2016 `x'2020
gen timeperiod=2
rename `x'2016 `x'_t
rename `x'2020 `x'_t1
save"_tp2_`x'", replace
restore
preserve
keep HHID_panel `x'2020 `x'2026
gen timeperiod=3
rename `x'2020 `x'_t
rename `x'2026 `x'_t1
save"_tp3_`x'", replace
restore
}

foreach x in $var {
use"_tp1_`x'", clear
append using "_tp2_`x'"
append using "_tp3_`x'"
label define timeperiod 1"2010 - 2016" 2"2016 - 2020" 3"2020 - 2026"
label values timeperiod timeperiod
order HHID_panel timeperiod
drop if `x'_t==.
drop if `x'_t1==.
ta timeperiod

gen year=.
replace year=2010 if timeperiod==1
replace year=2016 if timeperiod==2
replace year=2020 if timeperiod==3
order HHID_panel timeperiod year
save"_temp_`x'", replace
}

* Merge
use"_temp_dsr", clear
*
merge 1:1 HHID year using "_temp_isr"
keep if _merge==3
drop _merge
*
merge 1:1 HHID year using "_temp_dar"
keep if _merge==3
drop _merge
*
merge 1:1 HHID year using "_temp_debt"
keep if _merge==3
drop _merge
*
merge 1:1 HHID year using "_temp_debtbal"
keep if _merge==3
drop _merge
*
merge 1:1 HHID year using "_temp_logassets"
keep if _merge==3
drop _merge
*
merge 1:1 HHID year using "_temp_logincome"
keep if _merge==3
drop _merge
*
merge 1:1 HHID_panel year using "panel_v1"
keep if _merge==3
drop _merge
ta timeperiod


*
ta dsr_t if dsr_t==0
ta dsr_t1 if dsr_t1==0
ta isr_t if isr_t==0
ta isr_t1 if isr_t1==0
ta dar_t if dar_t==0
ta dar_t1 if dar_t1==0

*
foreach x in dsr_t dsr_t1 isr_t isr_t1 dar_t dar_t1 debt_t debt_t1 debtbal_t debtbal_t1 {
gen temp`x'=`x'+1
gen log`x'=log(temp`x')
drop temp`x'
}


foreach x in dsr_t dsr_t1 isr_t isr_t1 dar_t dar_t1 debt_t debt_t1 debtbal_t debtbal_t1 {
qui sum `x', det
replace `x'=`r(p95)' if `x'>`r(p95)'
}


* Poor and rich in terms of wealth and income
forvalues i=1/3 {
xtile wealth`i'=assets_total if timeperiod==`i', n(3)
xtile income`i'=annualincome_HH if timeperiod==`i', n(3)
}

foreach x in wealth income {
gen `x'_grp=.
forvalues i=1/3 {
replace `x'_grp=`x'`i' if timeperiod==`i'
}
}
drop wealth1 wealth2 wealth3
drop income1 income2 income3

* Agri vs non-agri hh ?
gen shareagri=incomeagri_HH*100/annualincome_HH
*
gen catinc=.
label define catinc 1"Non-agri" 2"Agri" 3"Both"
label values catinc catinc
replace catinc=1 if shareagri<=30
replace catinc=2 if shareagri>=70
replace catinc=3 if shareagri>30 & shareagri<70
ta catinc year, m col nofreq
drop shareagri



save "pooled_v1", replace
****************************************
* END
