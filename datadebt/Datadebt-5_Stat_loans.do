*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2023
*-----
gl link = "datadebt"
*Stat loan
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------








****************************************
* Formal/informal
****************************************
use"panel_loans", clear

*** loanlender
ta loanlender lender_cat

*** lender4
ta lender4 lender4_cat

*** Cat and cat
ta lender_cat lender4_cat


*** Over year
ta lender_cat year, col nofreq
ta lender4_cat year, col nofreq

****************************************
* END













****************************************
* Desc
****************************************
use"panel_loans", clear

********** Prepa
drop if loansettled==1
ta year
ta loan_database year
drop if loan_database=="MARRIAGE"
ta year
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020

*** Backup
gen loanamount_bc=loanamount
replace loanamount=loanamount/1000


*** Stat amount
cls
tabstat loanamount, stat(n mean cv q p90 p95) by(year)
tabstat loanamount if caste==1, stat(n mean cv q p90 p95) by(year)
tabstat loanamount if caste==2, stat(n mean cv q p90 p95) by(year)
tabstat loanamount if caste==3, stat(n mean cv q p90 p95) by(year)


*** %
ta year
ta lender4_cat year, col nofreq
ta reason_cat year, col nofreq


*** Amount
tabstat loanamount if year==2010, stat(mean) by(lender4_cat)
tabstat loanamount if year==2016, stat(mean) by(lender4_cat)
tabstat loanamount if year==2020, stat(mean) by(lender4_cat)

tabstat loanamount if year==2010, stat(mean) by(reason_cat)
tabstat loanamount if year==2016, stat(mean) by(reason_cat)
tabstat loanamount if year==2020, stat(mean) by(reason_cat)



*** % of HH using it: lender4_cat
fre lender4_cat
ta lender4_cat, gen(len)

*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)3{
bysort HHID_panel: egen lenHH_`i'=max(len`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lenHH_`i', m
}
restore

*2016-17
cls
preserve 
keep if year==2016
forvalues i=1(1)3{
bysort HHID_panel: egen lenHH_`i'=max(len`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lenHH_`i', m
}
restore


*2020-21
cls
preserve 
keep if year==2020
forvalues i=1(1)3{
bysort HHID_panel: egen lenHH_`i'=max(len`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lenHH_`i', m
}
restore

drop len1 len2 len3


*** % of HH using it: reason_cat
fre reason_cat
recode reason_cat (77=7)
ta reason_cat, gen(rea)

*2010
cls
preserve 
keep if year==2010
forvalues i=1(1)7{
bysort HHID_panel: egen reaHH_`i'=max(rea`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)7{
tab reaHH_`i', m
}
restore

*2016-17
cls
preserve 
keep if year==2016
forvalues i=1(1)7{
bysort HHID_panel: egen reaHH_`i'=max(rea`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)7{
tab reaHH_`i', m
}
restore

*2020-21
cls
preserve 
keep if year==2020
forvalues i=1(1)7{
bysort HHID_panel: egen reaHH_`i'=max(rea`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)7{
tab reaHH_`i', m
}
restore

****************************************
* END








****************************************
* Share formal/semi/informal in total
****************************************

********** Niveau de détail 1
use"panel_loans", clear

fre lender_cat
gen loanamount_info=loanamount if lender_cat==1
gen loanamount_semi=loanamount if lender_cat==2
gen loanamount_form=loanamount if lender_cat==3

foreach x in info semi form {
bysort HHID_panel year: egen sum_`x'=sum(loanamount_`x')
}

gen total_HH=sum_info+sum_semi+sum_form
bysort HHID_panel year: egen total_HH2=sum(loanamount)
gen test=total_HH-total_HH2
ta test
drop test total_HH2

foreach x in info semi form {
gen share_`x'=sum_`x'*100/total_HH
}

keep HHID_panel year sum_info sum_semi sum_form total_HH share_info share_semi share_form
duplicates drop
ta year

tabstat share_info share_semi share_form, stat(n mean cv q) by(y) long



********** Niveau de détail 2
use"panel_loans", clear

fre lender4
forvalues i=1/10 {
gen loanamount_`i'=loanamount if lender4==`i'
}

forvalues i=1/10 {
bysort HHID_panel year: egen sum_cat_`i'=sum(loanamount_`i')
}

egen total_HH=rowtotal(sum_cat_1 sum_cat_2 sum_cat_3 sum_cat_4 sum_cat_5 sum_cat_6 sum_cat_7 sum_cat_8 sum_cat_9 sum_cat_10)

forvalues i=1/10 {
gen share_`i'=sum_cat_`i'*100/total_HH
}

foreach x in share sum_cat {
rename `x'_1 `x'_wkp
rename `x'_2 `x'_rela
rename `x'_3 `x'_labo
rename `x'_4 `x'_pawn
rename `x'_5 `x'_shop
rename `x'_6 `x'_mone
rename `x'_7 `x'_frie
rename `x'_8 `x'_micr
rename `x'_9 `x'_bank
rename `x'_10 `x'_than
}

keep HHID_panel year sum_cat_wkp sum_cat_rela sum_cat_labo sum_cat_pawn sum_cat_shop sum_cat_mone sum_cat_frie sum_cat_micr sum_cat_bank sum_cat_than total_HH share_wkp share_rela share_labo share_pawn share_shop share_mone share_frie share_micr share_bank share_than
duplicates drop
ta year

tabstat share_wkp share_rela share_labo share_pawn share_shop share_mone share_frie share_micr share_bank share_than, stat(n mean cv q) by(y) long

****************************************
* END










****************************************
* Chi2 test
****************************************
use"panel_loans", clear

********** Prepa
drop if loansettled==1
ta year
ta loan_database year
drop if loan_database=="MARRIAGE"
ta year
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020



*** Chi2
ta lender4 lender4_cat
ta reason_cat lender4_cat, chi2 exp cchi2
ta reason_cat lender4_cat
ta reason_cat lender4_cat, exp nofreq
ta reason_cat lender4_cat, cchi2 nofreq

****************************************
* END














****************************************
* Each cat over time
****************************************
use"panel_loans", clear

********** Prepa
drop if loansettled==1
ta year
ta loan_database year
drop if loan_database=="MARRIAGE"
ta year
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020


keep HHID_panel year reason_cat lender4_cat

egen grp=group(lender4_cat reason_cat), label
ta grp year, col nofreq

gen grp2=grp
recode grp2 (1=23) (2=22) (3=21) (4=20) (5=19) (6=18) (7=17) (8=15) (9=14) (10=13) (11=12) (12=11) (13=10) (14=9) (15=7) (16=6) (17=5) (18=4) (19=3) (20=2) (21=1)

label define grp2 ///
23"Inf Econ" 22"Inf Curr" 21"Inf Huma" 20"Inf Soci" 19"Inf Hous" 18"Inf No r" 17"Inf Othe" 16" " ///
15"Semi Econ" 14"Semi Curr" 13"Semi Huma" 12"Semi Soci" 11"Semi Hous" 10"Semi No r" 9"Semi Othe" 8" " ///
7"Form Econ" 6"Form Curr" 5"Form Huma" 4"Form Soci" 3"Form Hous" 2"Form No r" 1"Form Othe" 
label values grp2 grp2

ta grp2 grp

ta grp2 year
ta grp2 year, col nofreq

ta grp, gen(grp_)
global var grp_1 grp_2 grp_3 grp_4 grp_5 grp_6 grp_7 grp_8 grp_9 grp_10 grp_11 grp_12 grp_13 grp_14 grp_15 grp_16 grp_17 grp_18 grp_19 grp_20 grp_21

*** Arranger la base pour avoir une variable par année
collapse (mean) $var, by(year)
foreach x in $var {
replace `x'=`x'*100
}
reshape long grp_, i(year) j(grp)
rename grp_ mean
reshape wide mean, i(grp) j(year)

*** Remettre les labels
label define var ///
1"Inf Econ" 2"Inf Curr" 3"Inf Huma" 4"Inf Soci" 5"Inf Hous" 6"Inf No r" 7"Inf Othe" ///
8"Semi Econ" 9"Semi Curr" 10"Semi Huma" 11"Semi Soci" 12"Semi Hous" 13"Semi No r" 14"Semi Othe" ///
15"Form Econ" 16"Form Curr" 17"Form Huma" 18"Form Soci" 19"Form Hous" 20"Form No r" 21"Form Othe" 
label values grp var

*** Graph
graph bar (sum) mean2010 mean2016 mean2020, over(grp, lab(ticks angle(45) valuelabel labsize(vsmall))) legend(order(1 "2010" 2 "2016-17" 3 "2020-21") pos(6) col(3)) ytitle("%*") note("*Percentage by year", size(vsmall)) ylabel(0(5)35) ymtick(0(2.5)35) name(howmuch, replace)
graph save "howmuch.gph", replace
graph export "howmuch.pdf", as(pdf) replace
graph export "howmuch.png", as(png) replace


****************************************
* END


















****************************************
* Services
****************************************
use"panel_loans", clear

********** Prepa
drop if loansettled==1
ta year
ta loan_database year
drop if loan_database=="MARRIAGE"
drop if loan_database=="GOLD"
ta year
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020




********** By lenders
cls
foreach x in otherlenderservices_poli otherlenderservices_fina otherlenderservices_guar otherlenderservices_gene otherlenderservices_none otherlenderservices_othe {
ta `x' year, col nofreq
*ta `x' year if caste==1, col nofreq
*ta `x' year if caste==2, col nofreq
*ta `x' year if caste==3, col nofreq
}




********** By borrowers
cls
keep if dummyml==1
foreach x in borrowerservices_free borrowerservices_less borrowerservices_supp borrowerservices_none borrowerservices_othe {
ta `x' year, col nofreq
*ta `x' year if caste==1, col nofreq
*ta `x' year if caste==2, col nofreq
*ta `x' year if caste==3, col nofreq
}


****************************************
* END


























