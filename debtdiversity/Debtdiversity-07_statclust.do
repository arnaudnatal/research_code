*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Characteristics of clusters
****************************************
use"panel_loans_v1_clust", clear

********** MCA 1
global mca1 lender4 reason_cat catloanamount
cls
foreach x in $mca1 {
ta clustloan1 `x', row nofreq
}
foreach x in $mca1 {
ta clustloan1 `x', col nofreq
}


********** MCA 2
keep if dummymainloan==1
global mca2 lender4 reason_cat catmainloanamount dummyinterest guarantee otherlenderservice
cls
foreach x in $mca2 {
ta clustloan2 `x', row nofreq
}


****************************************
* END











****************************************
* Label
****************************************
use"panel_loans_v1_clust", clear

label define clustloan1 1"Housing" 2"Moneylenders" 3"Small non-eco invest" 4"Daily pawn" 5"Small human invest" 6"Invest" 7"Social" 8"Emergency" 9"TBD" 10"Daily WKP"
label values clustloan1 clustloan1

*label define clustloan2 1"Housing" 2"Emergency" 3"H invest" 4"Smoothing" 5"Daily" 6"Smoothing" 7"Daily" 8"S invest" 9"Emergency"
*label values clustloan2 clustloan2




save"panel_loans_v1_clust_v2", replace
****************************************
* END












****************************************
* Stat
****************************************
use"panel_loans_v1_clust_v2", clear

* Merger income and assets
preserve
use"panel_HH_v1", clear
keep HHID_panel year annualincome_HH assets_total1000
*
foreach y in 2010 2016 2020 {
xtile catincome`y'=annualincome_HH if year==`y', n(5)
recode catincome`y' (3=2) (4=2) (5=3)
}
gen catincome=.
foreach y in 2010 2016 2020 {
replace catincome=catincome`y' if year==`y'
drop catincome`y'
}
ta catincome
*
foreach y in 2010 2016 2020 {
xtile catwealth`y'=assets_total1000 if year==`y', n(5)
recode catwealth`y' (3=2) (4=2) (5=3)
}
gen catwealth=.
foreach y in 2010 2016 2020 {
replace catwealth=catwealth`y' if year==`y'
drop catwealth`y'
}
ta catwealth
*
keep HHID_panel year catincome catwealth
save"_tempcat", replace
restore

merge m:1 HHID_panel year using "_tempcat"
keep if _merge==3
drop _merge



********** Evo over time
*
ta clustloan1 year, col nofreq chi2

*
ta clustloan1 caste, col nofreq chi2
ta clustloan1 caste if year==2010, col nofreq chi2
ta clustloan1 caste if year==2016, col nofreq chi2
ta clustloan1 caste if year==2020, col nofreq chi2

*
ta clustloan1 catincome, col nofreq chi2
ta clustloan1 catincome if year==2010, col nofreq chi2
ta clustloan1 catincome if year==2016, col nofreq chi2
ta clustloan1 catincome if year==2020, col nofreq chi2

*
ta clustloan1 catwealth, col nofreq chi2
ta clustloan1 catwealth if year==2010, col nofreq chi2
ta clustloan1 catwealth if year==2016, col nofreq chi2
ta clustloan1 catwealth if year==2020, col nofreq chi2

*
ta clustloan1 sex if year!=2010, col nofreq chi2
ta clustloan1 sex if year==2016, col nofreq chi2
ta clustloan1 sex if year==2020, col nofreq chi2

*





****************************************
* END



