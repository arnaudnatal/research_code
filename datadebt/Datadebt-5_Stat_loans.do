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

ta lender_cat lender4_cat

ta lender_cat year, col nofreq

ta lender4_cat year, col nofreq

clonevar lender5=lender4
fre lender5
recode lender5 (2=1) (3=1) (5=1) (6=1) (7=1) (10=1)

ta lender5 lender4_cat

ta lender5 year, col nofreq

ta lender_cat year, col nofreq

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
ta lender_cat year, col nofreq
ta reason_cat year, col nofreq


*** Amount
tabstat loanamount if year==2010, stat(mean) by(lender_cat)
tabstat loanamount if year==2016, stat(mean) by(lender_cat)
tabstat loanamount if year==2020, stat(mean) by(lender_cat)

tabstat loanamount if year==2010, stat(mean) by(reason_cat)
tabstat loanamount if year==2016, stat(mean) by(reason_cat)
tabstat loanamount if year==2020, stat(mean) by(reason_cat)



*** % of HH using it: lender_cat
fre lender_cat
ta lender_cat, gen(len)

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
ta loanreasongiven reason_cat
ta loanlender lender_cat
ta reason_cat lender_cat, chi2 exp cchi2
ta reason_cat lender_cat
ta reason_cat lender_cat, exp nofreq
ta reason_cat lender_cat, cchi2 nofreq

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


keep HHID_panel year reason_cat lender_cat

egen grp=group(lender_cat reason_cat), label
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





***
import excel "C:\Users\Arnaud\Documents\MEGA\Thesis\Thesis_2-Context_debt\Analysis\Stat.xlsx", sheet("graphtest2") firstrow clear

gen var2=var
recode var2 (8=9) (9=10) (10=11) (11=12) (12=13) (13=14) (14=15) (15=17) (16=18) (17=19) (18=20) (19=21) (20=22) (21=23)

label define var ///
1"Inf Econ" 2"Inf Curr" 3"Inf Huma" 4"Inf Soci" 5"Inf Hous" 6"Inf No r" 7"Inf Othe" ///
8"Semi Econ" 9"Semi Curr" 10"Semi Huma" 11"Semi Soci" 12"Semi Hous" 13"Semi No r" 14"Semi Othe" ///
15"Form Econ" 16"Form Curr" 17"Form Huma" 18"Form Soci" 19"Form Hous" 20"Form No r" 21"Form Othe" 
label values var var

label define var2 ///
1"Inf Econ" 2"Inf Curr" 3"Inf Huma" 4"Inf Soci" 5"Inf Hous" 6"Inf No r" 7"Inf Othe" 8" " ///
9"Semi Econ" 10"Semi Curr" 11"Semi Huma" 12"Semi Soci" 13"Semi Hous" 14"Semi No r" 15"Semi Othe" 16" " ///
17"Form Econ" 18"Form Curr" 19"Form Huma" 20"Form Soci" 21"Form Hous" 22"Form No r" 23"Form Othe" 
label values var2 var2

label define diff 1"(2016-2010)" 2"(2020-2016)" 3"(2020-2010)"
label values diff diff

/*
twoway (bar val var2 if diff==1, horiz barw(0.9)) ///
, xline(0) yline(8 16) ///
ylabel(1(1)23, valuelabel) ///
ytitle("") xtitle("(2) - (1)") name(gph1, replace)

twoway (bar val var2 if diff==2, horiz barw(0.9)) ///
, xline(0) yline(8 16) ///
ylabel(1(1)23, valuelabel) ///
ytitle("") xtitle("(3) - (2)") name(gph2, replace)

twoway (bar val var2 if diff==3, horiz barw(0.9)) ///
, xline(0) yline(8 16) ///
ylabel(1(1)23, valuelabel) ///
ytitle("") xtitle("(3) - (1)") name(gph3, replace)

gen x=1
twby x diff: twoway (bar val var2, horiz barw(0.9)), xline(0) yline(8 16) ylabel(1(1)23, valuelabel) name(comb, replace)

graph combine howmuch comb, col(2) name(diffcomb, replace)
*/

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
ta year
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020




********** By lenders
cls
drop if dummyml==0
foreach x in otherlenderservices_poli otherlenderservices_fina otherlenderservices_guar otherlenderservices_gene otherlenderservices_none otherlenderservices_othe {
ta `x' year, col nofreq
ta `x' year if caste==1, col nofreq
ta `x' year if caste==2, col nofreq
ta `x' year if caste==3, col nofreq
}




********** By borrowers
cls
keep if dummyml==1
foreach x in borrowerservices_free borrowerservices_less borrowerservices_supp borrowerservices_none borrowerservices_othe {
ta `x' year, col nofreq
ta `x' year if caste==1, col nofreq
ta `x' year if caste==2, col nofreq
ta `x' year if caste==3, col nofreq
}


****************************************
* END


























