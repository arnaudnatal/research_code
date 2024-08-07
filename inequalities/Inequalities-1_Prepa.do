*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 2, 2024
*-----
gl link = "inequalities"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------








****************************************
* RUME
****************************************
use"raw\RUME-HH.dta", clear

* Selection
keep HHID2010 INDID2010 village name sex age relationshiptohead 

* Merge income
merge 1:1 HHID2010 INDID2010 using "raw\RUME-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
drop _merge

merge m:1 HHID2010 using "raw\RUME-occup_HH", keepusing(nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge
bysort HHID2010: egen annualincome_HH=sum(annualincome_indiv)
recode annualincome_HH (.=0)

* Merge assets
merge m:1 HHID2010 using "raw\RUME-assets", keepusing(expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000)
drop _merge

* Merge education + kilm
merge 1:1 HHID2010 INDID2010 using "raw\RUME-education"
drop _merge
merge 1:1 HHID2010 INDID2010 using "raw\RUME-kilm", keepusing(educ_attainment educ_attainment2 agecat)
drop _merge

* Merge family
merge m:1 HHID2010 using "raw\RUME-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize family typeoffamily nbgeneration waystem dummypolygamous head_name head_sex head_relationshiptohead head_age head_dummyhead head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge

* Merge caste
merge 1:1 HHID2010 INDID2010 using "raw\RUME-caste", keepusing(jatiscorr caste)
drop _merge

* Merge IDpanel
merge m:m HHID2010 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

merge m:m HHID2010 INDID2010 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

* Order
gen year=2010
order HHID_panel INDID_panel year HHID2010 INDID2010

* Share income by indiv and sex
gen inc_men=annualincome_indiv  if sex==1
gen inc_women=annualincome_indiv if sex==2
bysort HHID2010: egen suminc_men=sum(inc_men)
bysort HHID2010: egen suminc_women=sum(inc_women)
gen test=annualincome_HH-suminc_men-suminc_women
ta test
drop test
gen sharemen=suminc_men*100/annualincome_HH
gen sharewomen=suminc_women*100/annualincome_HH
gen shareindiv=annualincome_indiv*100/annualincome_HH
bysort HHID2010: egen test=sum(shareindiv)
ta test
drop test

save"RUME_1",replace
*************************************
* END











****************************************
* NEEMSIS-1
****************************************
use"raw\NEEMSIS1-HH.dta", clear


* Merge IDpanel
merge m:m HHID2016 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2016, replace
merge m:m HHID2016 INDID2016 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2016, replace


* Selection
ta livinghome egoid
drop if livinghome>=3
keep HHID_panel INDID_panel HHID2016 INDID2016 villageid name sex age relationshiptohead


* Merge income
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

merge m:1 HHID2016 using "raw\NEEMSIS1-occup_HH", keepusing(nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge
bysort HHID2016: egen annualincome_HH=sum(annualincome_indiv)
recode annualincome_HH (.=0)


* Merge assets
merge m:1 HHID2016 using "raw\NEEMSIS1-assets", keepusing(expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000)
drop _merge


* Merge education + kilm
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-education"
keep if _merge==3
drop _merge
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-kilm", keepusing(educ_attainment educ_attainment2 agecat)
keep if _merge==3
drop _merge


* Merge family
merge m:1 HHID2016 using "raw\NEEMSIS1-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize family typeoffamily nbgeneration waystem dummypolygamous head_name head_sex head_relationshiptohead head_age head_dummyhead head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge


* Merge caste
merge 1:1 HHID2016 INDID2016 using "raw\NEEMSIS1-caste", keepusing(jatiscorr caste)
keep if _merge==3
drop _merge


*
gen year=2016
order HHID_panel INDID_panel year HHID2016 INDID2016


* Share income by indiv and sex
gen inc_men=annualincome_indiv  if sex==1
gen inc_women=annualincome_indiv if sex==2
bysort HHID2016: egen suminc_men=sum(inc_men)
bysort HHID2016: egen suminc_women=sum(inc_women)
gen test=annualincome_HH-suminc_men-suminc_women
ta test
drop test
gen sharemen=suminc_men*100/annualincome_HH
replace sharemen=0 if sharemen==.
gen sharewomen=suminc_women*100/annualincome_HH
replace sharewomen=0 if sharewomen==.
gen shareindiv=annualincome_indiv*100/annualincome_HH
bysort HHID2016: egen test=sum(shareindiv)
ta test
drop test


save"NEEMSIS1_2",replace
*************************************
* END
















****************************************
* NEEMSIS-2
****************************************
use"raw\NEEMSIS2-HH.dta", clear

* Merge IDpanel
merge m:m HHID2020 using "raw\keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID2020 INDID2020 using "raw\keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2020, replace


* Selection
drop if dummylefthousehold==1
drop if livinghome>=3
keep HHID_panel INDID_panel HHID2020 INDID2020 villageid name sex age relationshiptohead


* Merge income
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv)
keep if _merge==3
drop _merge

merge m:1 HHID2020 using "raw\NEEMSIS2-occup_HH", keepusing(nbworker_HH nbnonworker_HH nonworkersratio)
drop _merge
bysort HHID2020: egen annualincome_HH=sum(annualincome_indiv)
recode annualincome_HH (.=0)


* Merge assets
merge m:1 HHID2020 using "raw\NEEMSIS2-assets", keepusing(expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000)
drop _merge


* Merge education + kilm
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-education"
keep if _merge==3
drop _merge
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-kilm", keepusing(educ_attainment educ_attainment2 agecat)
keep if _merge==3
drop _merge


* Merge family
merge m:1 HHID2020 using "raw\NEEMSIS2-family", keepusing(nbfemale nbmale HHsize HH_count_child HH_count_adult equiscale_HHsize equimodiscale_HHsize squareroot_HHsize family typeoffamily nbgeneration waystem dummypolygamous head_name head_sex head_relationshiptohead head_age head_dummyhead head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio)
drop _merge


* Merge caste
merge 1:1 HHID2020 INDID2020 using "raw\NEEMSIS2-caste", keepusing(jatiscorr caste)
keep if _merge==3
drop _merge

*
gen year=2020
order HHID_panel INDID_panel year HHID2020 INDID2020


* Share income by indiv and sex
gen inc_men=annualincome_indiv  if sex==1
gen inc_women=annualincome_indiv if sex==2
bysort HHID2020: egen suminc_men=sum(inc_men)
bysort HHID2020: egen suminc_women=sum(inc_women)
gen test=annualincome_HH-suminc_men-suminc_women
ta test
drop test
gen sharemen=suminc_men*100/annualincome_HH
replace sharemen=0 if sharemen==.
gen sharewomen=suminc_women*100/annualincome_HH
replace sharewomen=0 if sharewomen==.
gen shareindiv=annualincome_indiv*100/annualincome_HH
bysort HHID2020: egen test=sum(shareindiv)
ta test
drop test


save"NEEMSIS2_3",replace
*************************************
* END











****************************************
* Append
****************************************
use"RUME_1.dta", clear

append using "NEEMSIS1_2"
append using "NEEMSIS2_3"

order HHID_panel INDID_panel HHID2010 INDID2010 HHID2016 INDID2016 HHID2020 INDID2020 year

* Selection
fre mainocc_occupation_indiv
recode mainocc_occupation_indiv (0=.)
replace annualincome_indiv=. if mainocc_occupation_indiv==.

drop HHID2010 INDID2010 HHID2016 INDID2016 HHID2020 INDID2020

egen HHINDID=group(HHID_panel INDID_panel)
order HHINDID
sort HHINDID year

compress
save "Panel_v0", replace
****************************************
* END










****************************************
* Construction des variables
****************************************
use"Panel_v0", clear


* Poverty HH
gen annualincome_HH2=annualincome_HH
replace annualincome_HH2=annualincome_HH2*(100/62.81) if year==2010
replace annualincome_HH2=annualincome_HH2*(100/114.95) if year==2020
replace annualincome_HH2=round(annualincome_HH2,1)
gen dayinc_pc=(annualincome_HH2/365)/HHsize
gen dayinc_pc_usd_ppp=dayinc_pc/20.65
gen poor_HH=0
replace poor_HH=1 if dayinc_pc_usd_ppp<=2.15
gen sopl_HH=dayinc_pc_usd_ppp/2.15
label define poor 0"Non-poor" 1"Poor"
label values poor_HH poor


* Poverty indiv
gen annualincome_indiv2=annualincome_indiv
replace annualincome_indiv2=annualincome_indiv2*(100/62.81) if year==2010
replace annualincome_indiv2=annualincome_indiv2*(100/114.95) if year==2020
replace annualincome_indiv2=round(annualincome_indiv2,1)
gen dayinc=annualincome_indiv2/365
gen dayinc_usd_ppp=dayinc/20.65
gen poor_indiv=0
replace poor_indiv=1 if dayinc_usd_ppp<=2.15
gen sopl_indiv=dayinc_usd_ppp/2.15
label values poor_indiv poor

* Quantile of income and assets
preserve
keep HHID_panel year assets_total1000 annualincome_HH
duplicates drop
ta year

xtile q_assets2010=assets_total1000 if year==2010, n(3)
xtile q_assets2016=assets_total1000 if year==2016, n(3)
xtile q_assets2020=assets_total1000 if year==2020, n(3)
gen q_assets=.
replace q_assets=q_assets2010 if year==2010
replace q_assets=q_assets2016 if year==2016
replace q_assets=q_assets2020 if year==2020
drop q_assets2010 q_assets2016 q_assets2020

xtile q_income2010=annualincome_HH if year==2010, n(3)
xtile q_income2016=annualincome_HH if year==2016, n(3)
xtile q_income2020=annualincome_HH if year==2020, n(3)
gen q_income=.
replace q_income=q_income2010 if year==2010
replace q_income=q_income2016 if year==2016
replace q_income=q_income2020 if year==2020
drop q_income2010 q_income2016 q_income2020
save "quantiles", replace
restore

merge m:1 HHID_panel year using "quantiles", keepusing(q_assets q_income)
drop _merge

* Villages
fre village
fre villageid
replace villageid=1 if village==1
replace villageid=2 if village==2
replace villageid=3 if village==3
replace villageid=4 if village==4
replace villageid=5 if village==5
replace villageid=6 if village==7
replace villageid=7 if village==6
replace villageid=8 if village==8
replace villageid=9 if village==9
replace villageid=10 if village==10

* HHFE
encode HHID_panel, gen(HHFE)

* Income
gen logincomeindiv=log(annualincome_indiv)

* Type of family
fre typeoffamily
drop family
encode typeoffamily, gen(family)
fre family

* Cleaning
drop village inc_men inc_women annualincome_HH2 dayinc_pc annualincome_indiv2 dayinc


save "Panel_v1", replace
****************************************
* END













****************************************
* Base HH
****************************************
use"Panel_v1", clear

keep HHID_panel year villageid annualincome_HH nbworker_HH nbnonworker_HH nonworkersratio expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri assets_sizeownland assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 nbfemale nbmale HHsize HH_count_child HH_count_adult family typeoffamily nbgeneration waystem dummypolygamous head_name head_sex head_relationshiptohead head_age head_dummyhead head_dummyworkedpastyear head_working_pop head_mocc_profession head_mocc_occupation head_mocc_sector head_mocc_annualincome head_mocc_occupationname head_annualincome head_nboccupation head_edulevel pop_workingage pop_dependents dependencyratio dummyheadfemale dummyoneadult sexratio jatiscorr caste dayinc_pc dayinc_pc_usd_ppp poor_HH sopl_HH q_assets q_income sharemen sharewomen suminc_men suminc_women

duplicates drop
ta year

* Ineq HH
gen diffsharemenwomen=sharemen-sharewomen
ta diffsharemenwomen
gen catdiffshare=.
replace catdiffshare=1 if diffsharemenwomen<=-10
replace catdiffshare=2 if diffsharemenwomen>-10 & diffsharemenwomen<10
replace catdiffshare=3 if diffsharemenwomen>=10
label define catdiffshare 1"W > M" 2"W = M" 3"W > M"
label values catdiffshare catdiffshare


save "Panel_HH_v0", replace
****************************************
* END










****************************************
* Stat HH
****************************************
use"Panel_HH_v0", clear

* Lorenz
preserve
keep HHID_panel year sharewomen
rename sharewomen var
reshape wide var, i(HHID_panel) j(year)
lorenz estimate var2010 var2016 var2020
lorenz graph, noci overlay legend(pos(6) col(3) order(2 "2010" 3 "2016-17" 4 "2020-21")) xtitle("Population share") ytitle("Cumulative monthly income proportion")
restore


* Desc
tabstat sharewomen, stat(mean q) by(year)

tabstat sharewomen if caste==1, stat(mean q) by(year)
tabstat sharewomen if caste==2, stat(mean q) by(year)
tabstat sharewomen if caste==3, stat(mean q) by(year)

tabstat sharewomen if poor_HH==0, stat(mean q) by(year)
tabstat sharewomen if poor_HH==1, stat(mean q) by(year)

tabstat sharewomen if q_assets==1, stat(mean q) by(year)
tabstat sharewomen if q_assets==2, stat(mean q) by(year)
tabstat sharewomen if q_assets==3, stat(mean q) by(year)

tabstat sharewomen if q_income==1, stat(mean q) by(year)
tabstat sharewomen if q_income==2, stat(mean q) by(year)
tabstat sharewomen if q_income==3, stat(mean q) by(year)


* Theil
ineqdeco sharewomen

* Prepa database trends R
preserve
rename sharewomen index
tabstat index, stat(min max range)
bysort HHID_panel: gen n=_N
keep if n==3
keep HHID_panel year index

reshape wide index, i(HHID_panel) j(year)
corr index2010 index2016 index2020
export delimited "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Inequalities\Analysis\index.csv", replace
restore

* Browning, Bourguignon, Chiappori and Lechene (1993) estimate the share of household income going to the wife.
* Haddad and Kanbur (1990a) calculate the difference between the higher and lower income spouse's share of household income. The advantage of the Haddad Kanbur index is that it gives a direct indication of the amount of inequality within households.
* Ratio of average female incomes (or consumption) to average male incomes (see, for example, Fuchs, 1986).


* Deter
reg sharewomen i.caste 


****************************************
* END












****************************************
* Stat indiv
****************************************
use"Panel_v1", clear

cls
* Theil
ineqdeco shareindiv, by(HHFE)


ineqdeco shareindiv if year==2010, by(HHFE)
ineqdeco shareindiv if year==2016, by(HHFE)
ineqdeco shareindiv if year==2020, by(HHFE)


lorenz estimate shareindiv
lorenz graph, noci overlay legend(pos(6) col(3) order(2 "2010" 3 "2016-17" 4 "2020-21")) xtitle("Population share") ytitle("Cumulative monthly income proportion")




****************************************
* END
