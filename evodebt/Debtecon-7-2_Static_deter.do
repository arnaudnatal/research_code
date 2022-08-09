cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 17, 2021
-----
Short trends and static vuln
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
* Deter
****************************************
cls
use"panel_v12_long", clear

ta clust dummymarriage if year==2016, row nofreq chi2
ta clust dummymarriage if year==2020, row nofreq chi2

ta clust dummymarriage if year==2016, cchi2 exp chi2
ta clust dummymarriage if year==2020, cchi2 exp chi2

xtset panelvar time
ta time clust

global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid
global shocks dummydemonetisation i.dummylock
global marglo dummymarriage
global marson dummymarriageson
global mardau dummymarriagedaughter

********** Cross section evidence
cls
probit clust i.caste $head $HH $shocks if year==2010, baselevel

cls
probit clust i.caste $head $HH $shocks $marglo if year==2016, baselevel
probit clust i.caste $head $HH $shocks $marson if year==2016, baselevel
probit clust i.caste $head $HH $shocks $mardau if year==2016, baselevel
probit clust i.caste $head $HH $shocks $marson $mardau if year==2016, baselevel

cls
probit clust i.caste $head $HH $shocks $marglo if year==2020, baselevel
probit clust i.caste $head $HH $shocks $marson if year==2020, baselevel
probit clust i.caste $head $HH $shocks $mardau if year==2020, baselevel
probit clust i.caste $head $HH $shocks $marson $mardau if year==2020, baselevel

********** STEP 1: xtprobit classic
gen clust_lag=L1.clust
order HHID_panel year clust clust_lag

cls
xtprobit clust clust_lag i.caste $head $HH $shocks $marglo, baselevel
xtprobit clust clust_lag i.caste $head $HH $shocks $marson, baselevel
xtprobit clust clust_lag i.caste $head $HH $shocks $mardau, baselevel
xtprobit clust clust_lag i.caste $head $HH $shocks $marson $mardau, baselevel

****************************************
* END
