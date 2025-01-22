*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debttrap"
*Stat desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Share, amount, and ratio total
****************************************

********** Total
use"panel_HH_v2", clear
*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1
*
ta dummytrap_HH year, col
tabstat trapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gtdr_HH if dummytrap_HH==1, stat(mean med) by(year)

* Supplement
tabstat balancetrapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gbtdr_HH if dummytrap_HH==1, stat(mean med) by(year)

****************************************
* END












****************************************
* Share, amount, and ratio by caste
****************************************

********** Non-Dalits
use"panel_HH_v2", clear
fre dalits
keep if dalits==0
*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1
*
ta dummytrap_HH year, col
tabstat trapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gtdr_HH if dummytrap_HH==1, stat(mean med) by(year)


********** Dalits
use"panel_HH_v2", clear
fre dalits
keep if dalits==1
*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1
*
ta dummytrap_HH year, col
tabstat trapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gtdr_HH if dummytrap_HH==1, stat(mean med) by(year)


********** Diff 2010
use"panel_HH_v2", clear
keep if dummyloans_HH==1
keep if year==2010
*
probit dummytrap_HH i.dalits
*
keep if dummytrap_HH==1
reg trapamount_HH i.dalits
qreg trapamount_HH i.dalits, quantile(.5)
reg gtdr_HH i.dalits
qreg gtdr_HH i.dalits, quantile(.5)


********** Diff 2016-17
use"panel_HH_v2", clear
keep if dummyloans_HH==1
keep if year==2016
*
probit dummytrap_HH i.dalits
*
keep if dummytrap_HH==1
reg trapamount_HH i.dalits
qreg trapamount_HH i.dalits, quantile(.5)
reg gtdr_HH i.dalits
qreg gtdr_HH i.dalits, quantile(.5)


********** Diff 2020-21
use"panel_HH_v2", clear
keep if dummyloans_HH==1
keep if year==2020
*
probit dummytrap_HH i.dalits
*
keep if dummytrap_HH==1
reg trapamount_HH i.dalits
qreg trapamount_HH i.dalits, quantile(.5)
reg gtdr_HH i.dalits
qreg gtdr_HH i.dalits, quantile(.5)

****************************************
* END











****************************************
* Share, amount, and ratio by land ownership
****************************************

********** No land
use"panel_HH_v2", clear
fre ownland
keep if ownland==0
*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1
*
ta dummytrap_HH year, col
tabstat trapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gtdr_HH if dummytrap_HH==1, stat(mean med) by(year)



********** Land owner
use"panel_HH_v2", clear
fre ownland
keep if ownland==1
*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1
*
ta dummytrap_HH year, col
tabstat trapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gtdr_HH if dummytrap_HH==1, stat(mean med) by(year)


********** Diff 2010
use"panel_HH_v2", clear
keep if dummyloans_HH==1
keep if year==2010
*
probit dummytrap_HH i.ownland
*
keep if dummytrap_HH==1
reg trapamount_HH i.ownland
qreg trapamount_HH i.ownland, quantile(.5)
reg gtdr_HH i.ownland
qreg gtdr_HH i.ownland, quantile(.5)


********** Diff 2016-17
use"panel_HH_v2", clear
keep if dummyloans_HH==1
keep if year==2016
*
probit dummytrap_HH i.ownland
*
keep if dummytrap_HH==1
reg trapamount_HH i.ownland
qreg trapamount_HH i.ownland, quantile(.5)
reg gtdr_HH i.ownland
qreg gtdr_HH i.ownland, quantile(.5)


********** Diff 2020-21
use"panel_HH_v2", clear
keep if dummyloans_HH==1
keep if year==2020
*
probit dummytrap_HH i.ownland
*
keep if dummytrap_HH==1
reg trapamount_HH i.ownland
qreg trapamount_HH i.ownland, quantile(.5)
reg gtdr_HH i.ownland
qreg gtdr_HH i.ownland, quantile(.5)

****************************************
* END

















****************************************
* Dummy trap with continuous variables
****************************************
use"panel_HH_v2", clear

replace annualincome_HH=annualincome_HH/1000


********** Income
*
tabstat annualincome_HH if year==2010, stat(n mean med) by(dummytrap_HH)
reg annualincome_HH i.dummytrap_HH if year==2010
qreg annualincome_HH i.dummytrap_HH if year==2010, quantile(.5)
*
tabstat annualincome_HH if year==2016, stat(n mean med) by(dummytrap_HH)
reg annualincome_HH i.dummytrap_HH if year==2016
qreg annualincome_HH i.dummytrap_HH if year==2016, quantile(.5)
*
tabstat annualincome_HH if year==2020, stat(n mean med) by(dummytrap_HH)
reg annualincome_HH i.dummytrap_HH if year==2020
qreg annualincome_HH i.dummytrap_HH if year==2020, quantile(.5)


********** Wealth
*
tabstat assets_total1000 if year==2010, stat(n mean med) by(dummytrap_HH)
reg assets_total1000 i.dummytrap_HH if year==2010
qreg assets_total1000 i.dummytrap_HH if year==2010, quantile(.5)
*
tabstat assets_total1000 if year==2016, stat(n mean med) by(dummytrap_HH)
reg assets_total1000 i.dummytrap_HH if year==2016
qreg assets_total1000 i.dummytrap_HH if year==2016, quantile(.5)
*
tabstat assets_total1000 if year==2020, stat(n mean med) by(dummytrap_HH)
reg assets_total1000 i.dummytrap_HH if year==2020
qreg assets_total1000 i.dummytrap_HH if year==2020, quantile(.5)


********** DSR
*
tabstat dsr if year==2010, stat(n mean med) by(dummytrap_HH)
reg dsr i.dummytrap_HH if year==2010
qreg dsr i.dummytrap_HH if year==2010, quantile(.5)
*
tabstat dsr if year==2016, stat(n mean med) by(dummytrap_HH)
reg dsr i.dummytrap_HH if year==2016
qreg dsr i.dummytrap_HH if year==2016, quantile(.5)
*
tabstat dsr if year==2020, stat(n mean med) by(dummytrap_HH)
reg dsr i.dummytrap_HH if year==2020
qreg dsr i.dummytrap_HH if year==2020, quantile(.5)


****************************************
* END










****************************************
* Trap amount and continuous variables
****************************************
use"panel_HH_v2", clear

keep if dummytrap_HH==1

********** Annual income
pwcorr trapamount_HH annualincome_HH if year==2010, sig
spearman trapamount_HH annualincome_HH if year==2010, stats(rho p)
*
pwcorr trapamount_HH annualincome_HH if year==2016, sig
spearman trapamount_HH annualincome_HH if year==2016, stats(rho p)
*
pwcorr trapamount_HH annualincome_HH if year==2020, sig
spearman trapamount_HH annualincome_HH if year==2020, stats(rho p)


********** Wealth
pwcorr trapamount_HH assets_total1000 if year==2010, sig
spearman trapamount_HH assets_total1000 if year==2010, stats(rho p)
*
pwcorr trapamount_HH assets_total1000 if year==2016, sig
spearman trapamount_HH assets_total1000 if year==2016, stats(rho p)
*
pwcorr trapamount_HH assets_total1000 if year==2020, sig
spearman trapamount_HH assets_total1000 if year==2020, stats(rho p)


********** DSR
pwcorr trapamount_HH dsr if year==2010, sig
spearman trapamount_HH dsr if year==2010, stats(rho p)
*
pwcorr trapamount_HH dsr if year==2016, sig
spearman trapamount_HH dsr if year==2016, stats(rho p)
*
pwcorr trapamount_HH dsr if year==2020, sig
spearman trapamount_HH dsr if year==2020, stats(rho p)


****************************************
* END










****************************************
* Trap ratio and continuous variables
****************************************
use"panel_HH_v2", clear

keep if dummytrap_HH==1

********** Annual income
pwcorr gtdr_HH annualincome_HH if year==2010, sig
spearman gtdr_HH annualincome_HH if year==2010, stats(rho p)
*
pwcorr gtdr_HH annualincome_HH if year==2016, sig
spearman gtdr_HH annualincome_HH if year==2016, stats(rho p)
*
pwcorr gtdr_HH annualincome_HH if year==2020, sig
spearman gtdr_HH annualincome_HH if year==2020, stats(rho p)


********** Wealth
pwcorr gtdr_HH assets_total1000 if year==2010, sig
spearman gtdr_HH assets_total1000 if year==2010, stats(rho p)
*
pwcorr gtdr_HH assets_total1000 if year==2016, sig
spearman gtdr_HH assets_total1000 if year==2016, stats(rho p)
*
pwcorr gtdr_HH assets_total1000 if year==2020, sig
spearman gtdr_HH assets_total1000 if year==2020, stats(rho p)


********** DSR
pwcorr gtdr_HH dsr if year==2010, sig
spearman gtdr_HH dsr if year==2010, stats(rho p)
*
pwcorr gtdr_HH dsr if year==2016, sig
spearman gtdr_HH dsr if year==2016, stats(rho p)
*
pwcorr gtdr_HH dsr if year==2020, sig
spearman gtdr_HH dsr if year==2020, stats(rho p)

****************************************
* END















****************************************
* Trap over time for longitudinal hh
****************************************
use"panel_HH_v2", clear

keep HHID_panel year caste dummyloans_HH dummytrap_HH
rename dummyloans_HH indebted
rename dummytrap_HH intrapped
bysort HHID_panel: gen n=_N
ta n
drop if n==1
drop n

reshape wide caste indebted intrapped, i(HHID_panel) j(year)
gen caste=.
replace caste=caste2010 if caste2010!=. & caste==.
replace caste=caste2016 if caste2016!=. & caste==.
replace caste=caste2020 if caste2020!=. & caste==.
drop caste2010 caste2016 caste2020
order HHID_panel caste

* 
ta indebted2010 indebted2016, row chi2
ta indebted2016 indebted2020, row chi2
ta indebted2010 indebted2020, row chi2

*
ta intrapped2010 intrapped2016, row chi2
ta intrapped2016 intrapped2020, row chi2
ta intrapped2010 intrapped2020, row chi2

/*
Not very interesting I think
*/

****************************************
* END
