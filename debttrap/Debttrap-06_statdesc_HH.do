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


********** Mean test
use"panel_HH_v2", clear
keep if dummyloans_HH==1
*
reg trapamount_HH i.dalits if dummytrap_HH==1 & year==2010
reg trapamount_HH i.dalits if dummytrap_HH==1 & year==2016
reg trapamount_HH i.dalits if dummytrap_HH==1 & year==2020
*
reg gtdr_HH i.dalits if dummytrap_HH==1 & year==2010
reg gtdr_HH i.dalits if dummytrap_HH==1 & year==2016
reg gtdr_HH i.dalits if dummytrap_HH==1 & year==2020


********** Median test
use"panel_HH_v2", clear
keep if dummyloans_HH==1
*
sqreg trapamount_HH i.dalits if dummytrap_HH==1 & year==2010, quantile(.5) reps(100)
sqreg trapamount_HH i.dalits if dummytrap_HH==1 & year==2016, quantile(.5) reps(100)
sqreg trapamount_HH i.dalits if dummytrap_HH==1 & year==2020, quantile(.5) reps(100)
*
sqreg gtdr_HH i.dalits if dummytrap_HH==1 & year==2010, quantile(.5) reps(100)
sqreg gtdr_HH i.dalits if dummytrap_HH==1 & year==2016, quantile(.5) reps(100)
sqreg gtdr_HH i.dalits if dummytrap_HH==1 & year==2020, quantile(.5) reps(100)

****************************************
* END









****************************************
* Share, amount, and ratio by land ownership
****************************************

********** No land
use"panel_HH_v2", clear
fre dalits
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
fre dalits
keep if ownland==1
*
ta dummyloans_HH year, m
ta dummyloans_HH year, col
keep if dummyloans_HH==1
*
ta dummytrap_HH year, col
tabstat trapamount_HH if dummytrap_HH==1, stat(mean med) by(year)
tabstat gtdr_HH if dummytrap_HH==1, stat(mean med) by(year)


********** Mean test
use"panel_HH_v2", clear
keep if dummyloans_HH==1
*
reg trapamount_HH i.ownland if dummytrap_HH==1 & year==2010
reg trapamount_HH i.ownland if dummytrap_HH==1 & year==2016
reg trapamount_HH i.ownland if dummytrap_HH==1 & year==2020
*
reg gtdr_HH i.ownland if dummytrap_HH==1 & year==2010
reg gtdr_HH i.ownland if dummytrap_HH==1 & year==2016
reg gtdr_HH i.ownland if dummytrap_HH==1 & year==2020


********** Median test
use"panel_HH_v2", clear
keep if dummyloans_HH==1
*
sqreg trapamount_HH i.ownland if dummytrap_HH==1 & year==2010, quantile(.5) reps(100)
sqreg trapamount_HH i.ownland if dummytrap_HH==1 & year==2016, quantile(.5) reps(100)
sqreg trapamount_HH i.ownland if dummytrap_HH==1 & year==2020, quantile(.5) reps(100)
*
sqreg gtdr_HH i.ownland if dummytrap_HH==1 & year==2010, quantile(.5) reps(100)
sqreg gtdr_HH i.ownland if dummytrap_HH==1 & year==2016, quantile(.5) reps(100)
sqreg gtdr_HH i.ownland if dummytrap_HH==1 & year==2020, quantile(.5) reps(100)

****************************************
* END
















****************************************
* Income and trap
****************************************
use"panel_HH_v2", clear

replace annualincome_HH=annualincome_HH/1000


********** Dummy trap
*
tabstat annualincome_HH if year==2010, stat(n mean med) by(dummytrap_HH)
reg annualincome_HH i.dummytrap_HH if year==2010
sqreg annualincome_HH i.dummytrap_HH if year==2010, quantile(.5) reps(100)
*
tabstat annualincome_HH if year==2016, stat(n mean med) by(dummytrap_HH)
reg annualincome_HH i.dummytrap_HH if year==2016
sqreg annualincome_HH i.dummytrap_HH if year==2020, quantile(.5) reps(100)
*
tabstat annualincome_HH if year==2020, stat(n mean med) by(dummytrap_HH)
reg annualincome_HH i.dummytrap_HH if year==2020
sqreg annualincome_HH i.dummytrap_HH if year==2016, quantile(.5) reps(100)


********** Amount trap
keep if dummytrap_HH==1
*
pwcorr trapamount_HH annualincome_HH if year==2010, sig
spearman trapamount_HH annualincome_HH if year==2010, stats(rho p)
*
pwcorr trapamount_HH annualincome_HH if year==2016, sig
spearman trapamount_HH annualincome_HH if year==2016, stats(rho p)
*
pwcorr trapamount_HH annualincome_HH if year==2020, sig
spearman trapamount_HH annualincome_HH if year==2020, stats(rho p)


********** Ratio trap
*
pwcorr gtdr_HH annualincome_HH if year==2010, sig
spearman gtdr_HH annualincome_HH if year==2010, stats(rho p)
*
pwcorr gtdr_HH annualincome_HH if year==2016, sig
spearman gtdr_HH annualincome_HH if year==2016, stats(rho p)
*
pwcorr gtdr_HH annualincome_HH if year==2020, sig
spearman gtdr_HH annualincome_HH if year==2020, stats(rho p)

****************************************
* END











****************************************
* Wealth and trap
****************************************
use"panel_HH_v2", clear

********** Dummy trap
*
tabstat assets_total1000 if year==2010, stat(n mean med) by(dummytrap_HH)
reg assets_total1000 i.dummytrap_HH if year==2010
sqreg assets_total1000 i.dummytrap_HH if year==2010, quantile(.5) reps(100)
*
tabstat assets_total1000 if year==2016, stat(n mean med) by(dummytrap_HH)
reg assets_total1000 i.dummytrap_HH if year==2016
sqreg assets_total1000 i.dummytrap_HH if year==2020, quantile(.5) reps(100)
*
tabstat assets_total1000 if year==2020, stat(n mean med) by(dummytrap_HH)
reg assets_total1000 i.dummytrap_HH if year==2020
sqreg assets_total1000 i.dummytrap_HH if year==2016, quantile(.5) reps(100)


********** Amount trap
keep if dummytrap_HH==1
*
pwcorr trapamount_HH assets_total1000 if year==2010, sig
spearman trapamount_HH assets_total1000 if year==2010, stats(rho p)
*
pwcorr trapamount_HH assets_total1000 if year==2016, sig
spearman trapamount_HH assets_total1000 if year==2016, stats(rho p)
*
pwcorr trapamount_HH assets_total1000 if year==2020, sig
spearman trapamount_HH assets_total1000 if year==2020, stats(rho p)


********** Ratio trap
*
pwcorr gtdr_HH assets_total1000 if year==2010, sig
spearman gtdr_HH assets_total1000 if year==2010, stats(rho p)
*
pwcorr gtdr_HH assets_total1000 if year==2016, sig
spearman gtdr_HH assets_total1000 if year==2016, stats(rho p)
*
pwcorr gtdr_HH assets_total1000 if year==2020, sig
spearman gtdr_HH assets_total1000 if year==2020, stats(rho p)

****************************************
* END











****************************************
* DSR and trap
****************************************
use"panel_HH_v2", clear

********** Dummy trap
*
tabstat dsr if year==2010, stat(n mean med) by(dummytrap_HH)
reg dsr i.dummytrap_HH if year==2010
sqreg dsr i.dummytrap_HH if year==2010, quantile(.5) reps(100)
*
tabstat dsr if year==2016, stat(n mean med) by(dummytrap_HH)
reg dsr i.dummytrap_HH if year==2016
sqreg dsr i.dummytrap_HH if year==2020, quantile(.5) reps(100)
*
tabstat dsr if year==2020, stat(n mean med) by(dummytrap_HH)
reg dsr i.dummytrap_HH if year==2020
sqreg dsr i.dummytrap_HH if year==2016, quantile(.5) reps(100)


********** Amount trap
keep if dummytrap_HH==1
*
pwcorr trapamount_HH dsr if year==2010, sig
spearman trapamount_HH dsr if year==2010, stats(rho p)
*
pwcorr trapamount_HH dsr if year==2016, sig
spearman trapamount_HH dsr if year==2016, stats(rho p)
*
pwcorr trapamount_HH dsr if year==2020, sig
spearman trapamount_HH dsr if year==2020, stats(rho p)


********** Ratio trap
*
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

