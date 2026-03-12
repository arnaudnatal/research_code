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
* Stats
****************************************
use"clusters", clear


********** Classification
foreach x in reason_cat lender_cat dummyinterest dummyhelptosettleloan dummyborrowerservices{
ta `x' clust, col nofreq chi2
}


********** Selection
drop if HHID_panel=="GOV64" & year==2020
drop if HHID_panel=="GOV65" & year==2020
drop if HHID_panel=="GOV66" & year==2020  
drop if HHID_panel=="GOV67" & year==2020
drop if HHID_panel=="KUV66" & year==2020
drop if HHID_panel=="KUV67" & year==2020


********** Evolution over time
tabplot clust year, percent(year) showval frame(100) xlabel(1"2010" 2"2016-17" 3"2020-21") xtitle("") ytitle("Cluster") subtitle("") aspectratio(1.5) name(clustyear, replace)  note("Percentage by year", size(vsmall))
graph save "clustyear.gph", replace
graph export "clustyear.pdf", as(pdf) replace
graph export "clustyear.png", as(png) replace



********** Amount per year per type
gen loanamountlog=log(loanamount)

egen clustyear=group(clust year), label
fre clustyear
recode clustyear (4=5) (5=6) (6=7) (7=9) (8=10) (9=11) (10=13) (11=14) (12=15) (13=17) (14=18) (15=19) (16=21) (17=22) (18=23)
label define clustyear ///
1"2010" 2"Clust. 1   2016-17" 3"2020-21" 4"" ///
5"2010" 6"Clust. 2   2016-17" 7"2020-21" 8"" ///
9"2010" 10"Clust. 3   2016-17" 11"2020-21" 12"" ///
13"2010" 14"Clust. 4   2016-17" 15"2020-21" 16"" ///
17"2010" 18"Clust. 5   2016-17" 19"2020-21" 20"" ///
21"2010" 22"Clust. 6   2016-17" 23"2020-21", modify

stripplot loanamountlog, over(clustyear) ///
stack width(0.01) ///
box(barw(0.5)) boffset(-0.15) pctile(5) ///
mc(black%0) ///
yline(4 8 12 16 20, lpattern(shortdash) lcolor(black%15)) ///
xla(5(1)13, ang(h)) xmtick(4.5(.5)13.5) yla(, noticks) ymtick(4(4)20) ///
legend(order(4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("Loan amount (log INR)") ytitle("") name(amount, replace)
graph export "loanamount.pdf", as(pdf) replace
graph export "loanamount.png", as(png) replace
graph save "loanamount.gph", replace
drop loanamountlog


*********** Household characteristics
*** Caste
ta clust_lab caste, chi2 cchi2 exp
ta caste clust_lab, chi2 col nofreq

*** Class
encode HHID_panel, gen(HHcl)
reg assets_totalnoland1000 i.clust_lab i.year, clust(HHcl) base


****************************************
* END





