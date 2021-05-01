/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
19 avril 2021
-----
TITLE: CLEANING OVERINDEBTEDNESS


-------------------------
*/


clear all
global name "Arnaud"
set scheme plottig

global directory "D:\Documents\_Thesis\Research-Overindebtedness\New_version"
cd"$directory"


****************************************
* HH in panel
****************************************
*RUME
use "$directory\RUME\RUME-HH_v7_loans.dta", clear
bysort HHID2010: gen n=_n
keep if n==1
rename year year2010
keep HHID2010 year2010
save"$directory\_paneldata\RUME-HH.dta", replace

use "$directory\NEEMSIS1\NEEMSIS1-HH_v6_loans.dta", clear
bysort HHID2010: gen n=_n
keep if n==1
gen year2016=2016
keep HHID2010 year2016
save"$directory\_paneldata\NEEMSIS1-HH.dta", replace

use "$directory\NEEMSIS2\NEEMSIS2-HH_v14_loans.dta", clear
keep if version_HH!=.
bysort HHID2010: gen n=_n
keep if n==1
tab version_HH
gen year2020=2020
keep HHID2010 year2020
save"$directory\_paneldata\NEEMSIS2-HH.dta", replace

use"$directory\_paneldata\RUME-HH.dta", clear
merge 1:1 HHID2010 using "$directory\_paneldata\NEEMSIS1-HH.dta"
rename _merge RUME_NEEMSIS1

merge 1:1 HHID2010 using "$directory\_paneldata\NEEMSIS2-HH.dta"
rename _merge RUME_NEEMSIS2

tab year2010
*405
tab year2016
*492
tab year2020
*415

gen panel_2010_2016=0
replace panel_2010_2016=1 if year2010!=. & year2016!=.
tab panel_2010_2016
*388

gen panel_2010_2020=0
replace panel_2010_2020=1 if year2010!=. & year2020!=.
tab panel_2010_2020
*321

gen panel_2016_2020=0
replace panel_2016_2020=1 if year2016!=. & year2020!=.
tab panel_2016_2020
*407

gen panel_2010_2016_2020=0
replace panel_2010_2016_2020=1 if year2010!=. & year2016!=. & year2020!=.
tab panel_2010_2016_2020
*313

drop RUME_NEEMSIS1 RUME_NEEMSIS2
drop year2010 year2016 year2020
save"$directory\_paneldata\panel_comp.dta", replace
****************************************
* END










****************************************
* ALL LOANS in same db
****************************************
use"$directory\RUME\RUME-loans_v3.dta", clear

*Add 2016
append using "$directory\NEEMSIS1\NEEMSIS1-loans_mainloans_v4.dta"
*Add 2020
append using "$directory\NEEMSIS2\NEEMSIS2_loan_v5.dta", force
tab HHID2010, m
keep if loanamount!=.
tab loanreasongiven year, m
tab year
/*
       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2010 |      2,396       28.17       28.17
       2016 |      2,349       27.61       55.78
       2020 |      3,762       44.22      100.00
------------+-----------------------------------
      Total |      8,507      100.00
*/
drop _merge
save"$directory\_paneldata\panel-all_loans.dta", replace
****************************************
* END












****************************************
* CLEANING
****************************************
use"$directory\_paneldata\panel-all_loans.dta", clear

*Merge les HH en panel
merge m:1 HHID2010 using"$directory\_paneldata\panel_comp.dta"
drop _merge

fre loansettled
*drop if loansettled==1

*Type of loan
gen informal=.
gen semiformal=.
gen formal=.
foreach i in 1 2 3 4 5 7 9 13{
replace informal=1 if loanlender==`i'
}
foreach i in 6 10{
replace semiformal=1 if loanlender==`i'
}
foreach i in 8 11 12 14{
replace formal=1 if loanlender==`i'
}

*Purpose of loan
tab loanreasongiven year, m

gen economic=.
gen current=.
gen humancap=.
gen social=.
gen house=.
gen other=.
foreach i in 1 6{
replace economic=1 if loanreasongiven==`i'
}
foreach i in 2 4 10{
replace current=1 if loanreasongiven==`i'
}
foreach i in 3 9{
replace humancap=1 if loanreasongiven==`i'
}
foreach i in 7 8 11{
replace social=1 if loanreasongiven==`i'
}
foreach i in 5{
replace house=1 if loanreasongiven==`i'
}
replace other=1 if loanreasongiven==77

*Verif
egen test=rowtotal(informal semiformal formal economic current humancap social house)
tab test
sort test
tabstat loanamount, stat(n mean cv p50 p75 p90 min max) by(test)
tab year if test==1
*drop other et no reason pour le moment mais je dois bien garder à l'esprit que ce sont des prêts importants car ils ont des montants très élevés
*drop if test==1 
*drop test

*Purpose of loan 2
gen incomegen=.
gen noincomegen=.
replace incomegen=1 if economic==1
replace noincomegen=1 if current==1 | humancap==1 | social==1 | house==1

*In amount
foreach x in economic current humancap social house incomegen noincomegen informal formal semiformal{
gen `x'_amount=loanamount if `x'==1
}

gen loanreasongiven_rec=.
replace loanreasongiven_rec=1 if economic==1
replace loanreasongiven_rec=2 if current==1
replace loanreasongiven_rec=3 if humancap==1
replace loanreasongiven_rec=4 if social==1
replace loanreasongiven_rec=5 if house==1
replace loanreasongiven_rec=6 if other==1

label define loanreasongiven_rec 1"Economic investment" 2"Current expenses" 3"Human capital" 4"Social expenses" 5"Housing" 6"Other"
label values loanreasongiven_rec loanreasongiven_rec

gen loanreasongiven_rec2=.
replace loanreasongiven_rec2=1 if incomegen==1
replace loanreasongiven_rec2=2 if noincomegen==1
label define loanreasongiven_rec2 1"Income generating debt" 2"No income generating"
label values loanreasongiven_rec2 loanreasongiven_rec2


gen loanlender_rec=.
replace loanlender_rec=1 if informal==1
replace loanlender_rec=2 if semiformal==1
replace loanlender_rec=3 if formal==1
label define loanlender_rec 1"Informal loan" 2"Semi-formal loan" 3"Formal loan"
label values loanlender_rec loanlender_rec


save"$directory\_paneldata\panel-all_loans_v2.dta", replace
****************************************
* END











****************************************
* HH panel formation
****************************************
use"$directory\RUME\RUME-HH_v7_loans.dta", clear
append using "$directory\NEEMSIS1\NEEMSIS1-HH_v6_loans.dta", force
append using "$directory\NEEMSIS2\NEEMSIS2-HH_v14_loans.dta", force

*Indiv
drop INDID2010
egen INDID2010=concat(HHID2010 INDID), p(/)
tab INDID2010
bysort INDID2010: gen n=_N
tab n

*Cylindrer
keep if n==3
drop n


*Only HH level var
bysort HHID2010 year: gen n=_n
keep if n==1
replace caste=. if year==2010 & year==2020
replace jatis=. if year==2010 & year==2020

*Only ratios var : total income, assets and loan amount
keep HHID2010 year totalloanamount totalnumberloans totalloanbalance totalincome_HH assets assets_noland caste jatis dummydemonetisation 

bysort HHID2010 : egen caste_2016=max(caste)
bysort HHID2010 : egen jatis_2016=max(jatis)
drop caste jatis
rename caste_2016 caste
rename jatis_2016 jatis

label values caste castecat
label values jatis caste

tab jatis caste

gen time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

replace totalincome_HH=18000 if totalincome_HH==0
replace totalincome_HH=18000 if totalincome_HH==.

gen DAR=totalloanamount/assets
gen DIR=totalloanamount/totalincome_HH

*Demo
bysort HHID2010 : egen dummydemo=max(dummydemonetisation)
tab dummydemo year
drop dummydemonetisation
rename dummydemo dummydemonetisation

*Panel
encode HHID2010, gen(panelvar)
xtset panelvar year 

save"$directory\_paneldata\panel_ratio_long.dta", replace


*Reshape
drop time
reshape wide DIR DAR totalloanamount totalnumberloans totalloanbalance totalincome_HH assets assets_noland, i(HHID2010) j(year)

save"$directory\_paneldata\panel_ratio_wide.dta", replace
****************************************
* END
