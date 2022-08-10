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
