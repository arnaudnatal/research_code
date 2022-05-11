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
* Exploratory analysis according to caste and cluster
****************************************
cls
graph drop _all
use"panel_v8_wide_cluster", clear

ta DSR2010
ta DSR2016
ta DSR2020

replace DSR2010=DSR2010*100
replace DSR2016=DSR2016*100
replace DSR2020=DSR2020*100

ta DSR2010
ta DSR2016
ta DSR2020

foreach x in loanamount assets_noland yearly_expenses annualincome {
foreach i in 2010 2016 2020 {
replace `x'`i'=`x'`i'/1000
}
}

foreach x in DSR2010 DSR2016 DSR2020 ISR2010 ISR2016 ISR2020 {
qui count if `x'==0
dis r(N)*100/382
}



********** Reshape
reshape long annualincome DSR loanamount DIR sizeownland head_edulevel head_occupation wifehusb_edulevel wifehusb_occupation mainocc_occupation yearly_expenses assets_noland DAR_without DAR_with ISR DSR30 DSR40 DSR50 ihs_annualincome ihs_assets_noland ihs_loanamount ihs_DSR_1000 ihs_DSR_100 cro_annualincome cro_assets_noland cro_loanamount cro_DSR log_yearly_expenses log_annualincome log_assets_noland log_assets log_loanamount dummyownland, j(year) i(panelvar)

gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

********** Check classification
ta vuln_cl caste if year==2010, nofreq row chi2
/*
No evident correlation = good for further sub analysis
*/

********** Type and use of debt


********** Burden of debt
stripplot ihs_DSR_1000, over(time) separate() by(vuln_cl, note("") row(1)) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks) ///
name(`x'_`y', replace)

stripplot ihs_DAR_1000, over(time) separate() by(vuln_cl, note("") row(1)) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks) ///
name(`x'_`y', replace)



tabstat DSR2010 DSR2016 DSR2020, stat(n mean sd q min max) by(vuln_cl)


********** Debt trap


********** Overindebtedness



****************************************
* END
