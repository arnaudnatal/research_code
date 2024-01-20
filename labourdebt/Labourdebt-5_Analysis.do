*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------










****************************************
* HH level stat
****************************************
use"panel_debt_noinvest", clear


********** Merge income
*
preserve
use"panel_cont_v1", clear
ta year
restore
*

merge 1:1 HHID_panel year using "panel_cont_v1"
keep if _merge==3
drop _merge


********** DSR
gen DSR=(imp1_ds_tot_HH/annualincome_HH)*100

tabstat DSR, stat(n mean cv q) by(year)
tabstat DSR if caste==1, stat(n mean cv q) by(year)
tabstat DSR if caste==2, stat(n mean cv q) by(year)
tabstat DSR if caste==3, stat(n mean cv q) by(year)


********** Remittances
tabstat remittnet_HH


********** Assets
tabstat assets_total


********** Mariage
ta dummymarriage 


********** HH size
tabstat HHsize


********** Nb child
tabstat  HH_count_child


********** Sex ratio
tabstat sexratio


********** Non workers ratio
tabstat nonworkersratio


****************************************
* END










****************************************
* Indiv level stat
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
sort HHID_panel INDID_panel year


********** LFP
ta work year, col nofreq
ta work year if sex==1, col nofreq
ta work year if sex==2, col nofreq




********** Multiple
ta multipleoccup year, col nofreq
ta multipleoccup year if sex==1, col nofreq
ta multipleoccup year if sex==2, col nofreq





********** Labour supply
tabstat hoursamonth_indiv, stat(n mean cv q p90 p95 p99 max) by(year)
tabstat hoursamonth_indiv if sex==1, stat(n mean cv p50) by(year)
tabstat hoursamonth_indiv if sex==2, stat(n mean cv p50) by(year)

* Density
twoway ///
(kdensity hoursamonth_indiv if sex==1, bwidth(20) xline(139 208.6)) ///
(kdensity hoursamonth_indiv if sex==2, bwidth(20)) ///
, ///
xtitle("Monthly working hours") xlabel(0(50)600) xmtick(0(25)600) ///
ytitle("Density") ///
legend(order(1 "Male" 2 "Female") pos(6) col(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 20", size(vsmall)) ///
name(densityls, replace)

* Stripplot
stripplot hoursamonth_indiv, over(sex) ///
stack width(10) jitter(2) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh) msize(small) mc(black%30) ///
xline(139 208.6) ///
xtitle("Monthly working hours") xlabel(0(50)600) xmtick(0(25)600) ///
ytitle("") ylabel(, noticks) ///
legend(order(4 "Whisker from 5% to 95%") pos(6) col(3) on) ///
name(stripplotls, replace)



********** Education
ta edulevel



********** Relationship to head
ta relation2



********** Main occupation
ta mainocc_occupation_indiv







********** Controls
*** Indiv level
foreach x in edulevel relation2 mainocc_occupation_indiv {
ta `x' year, col nofreq
ta `x' year if sex==1, col nofreq
ta `x' year if sex==2, col nofreq
}



****************************************
* END











****************************************
* Correlation couples
****************************************
use"hoursindiv_v2", clear


********** Cleaning
* Removing those who cannot be in a couple
fre relationshiptohead
drop if relationshiptohead==9
drop if relationshiptohead==12
drop if relationshiptohead==13
drop if relationshiptohead==14
drop if relationshiptohead==15
drop if relationshiptohead==16
drop if relationshiptohead==17
drop if relationshiptohead==77

* Creating groups of couples
fre relationshiptohead
gen couplegrp=.
replace couplegrp=1 if relationshiptohead==1
replace couplegrp=1 if relationshiptohead==2
replace couplegrp=2 if relationshiptohead==3
replace couplegrp=2 if relationshiptohead==4
replace couplegrp=3 if relationshiptohead==5
replace couplegrp=3 if relationshiptohead==7
replace couplegrp=4 if relationshiptohead==6
replace couplegrp=4 if relationshiptohead==8
replace couplegrp=5 if relationshiptohead==10
replace couplegrp=5 if relationshiptohead==11


* Identify the partners in each group
fre relationshiptohead
gen partner=.
replace partner=1 if relationshiptohead==1
replace partner=2 if relationshiptohead==2
replace partner=1 if relationshiptohead==3
replace partner=2 if relationshiptohead==4
replace partner=1 if relationshiptohead==5
replace partner=2 if relationshiptohead==7
replace partner=1 if relationshiptohead==6
replace partner=2 if relationshiptohead==8
replace partner=1 if relationshiptohead==10
replace partner=2 if relationshiptohead==11



********** Reshape
* Check duplicates for sons and daughters
fre relationshiptohead
ta relationshiptohead, gen(rela)
forvalues i=1/10 {
bysort HHID_panel year: egen sum_rela`i'=sum(rela`i')
drop rela`i'
}

tab1 sum_rela1 sum_rela2 sum_rela3 sum_rela4 sum_rela5 sum_rela6 sum_rela7 sum_rela8 sum_rela9 sum_rela10
drop sum_rela1 sum_rela2 sum_rela3 sum_rela4 sum_rela5 sum_rela6 sum_rela7 sum_rela8 sum_rela9 sum_rela10

/*
There are too many sons and daughters in each household to re-couple so quickly, so I'm only keeping the chef.
*/

keep if relationshiptohead==1 | relationshiptohead==2
drop couplegrp partner

* Check duplicates head
ta relationshiptohead, gen(rela)
forvalues i=1/2 {
bysort HHID_panel year: egen sum_rela`i'=sum(rela`i')
drop rela`i'
}

tab1 sum_rela1 sum_rela2
preserve
keep if sum_rela1==2 | sum_rela2==2
sort HHID_panel year
restore

drop if sum_rela1==2 
drop if sum_rela2==2
drop if sum_rela1==0 
drop if sum_rela2==0
drop sum_rela*
/*
I've decided to delete the ones with duplicates to go faster, but I'll have to look into this further next time.
I also delete those for which there is no partner.
*/

* Keep
keep HHID_panel year relationshiptohead INDID_panel age sex working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv mainocc_hoursayear_indiv

* Reshape
reshape wide INDID_panel age sex working_pop mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_annualincome_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv mainocc_hoursayear_indiv, i(HHID_panel year) j(relationshiptohead)

ta year



********** Demographic characteristics
ta sex1 sex2
corr age1 age2
ta caste1 caste2



********* Labour characteristics
* Decision to work
ta working_pop1 working_pop2, chi2

* Main occupation
ta mainocc_occupation_indiv1 mainocc_occupation_indiv2, chi2 exp cchi2

* Nb of occupation
corr nboccupation_indiv1 nboccupation_indiv2

* Labour supply
corr hoursayear_indiv1 hoursayear_indiv2
corr hoursayearagri_indiv1 hoursayearagri_indiv2
corr hoursayearnonagri_indiv1 hoursayearnonagri_indiv2

* Income
corr annualincome_indiv1 annualincome_indiv2


****************************************
* END













****************************************
* Instruments
****************************************


/*
********** Exclusion 1
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.landowner i.relation2 c.monthlyexpenses) ///
id(panelvar) time(year) reps(30)
est store excl_1
*/

/*
********** Exclusion 2
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.sex i.relation2 ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.marital c.HH_count_child c.HH_count_adult) ///
id(panelvar) time(year) reps(30)
est store excl_2
*/

/*
********** Exclusion 3
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = i.dummyremrec) ///
id(panelvar) time(year) reps(30)
est store excl_3
*/


/*
********** Exclusion 5
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio nonworkersratio ///
, selection(work = c.age##c.age) ///
id(panelvar) time(year) reps(30)
est store excl_5
*/


/*
********** Exclusion 6
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = i.head_edulevel HH_count_child annualincome_HH) ///
id(panelvar) time(year) reps(30)
est store excl_6
*/

/*
********** Exclusion 7
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize sexratio nonworkersratio ///
, selection(work = c.HH_count_child) ///
id(panelvar) time(year) reps(30)
est store excl_7
*/

****************************************
* END


















/*
****************************************
* Heckman total sample
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_4


********** Tables
esttab excl_4 using "Heckman_Total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
	
****************************************
* END
*/













/*
****************************************
* Heckman males
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if sex==1


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital


********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_4



********** Tables
esttab excl_4 using "Heckman_males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
*/











/*
****************************************
* Heckman females
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
keep if sex==2


********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital


********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_4


********** Tables
esttab excl_4 using "Heckman_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
*/







/*
****************************************
* Heckman old
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14
drop if age<58

********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 4
capture noisily xtheckmanfe hoursaweek_indiv DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_4



********** Tables
esttab excl_4 using "Heckman_old.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END
*/










****************************************
* Heckman type of jobs
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14

********** Panel
sort HHID_panel INDID_panel year
xtset panelvar year


********** Controls brut
global rawnonvar i.caste i.villageid
global rawecon remittnet_HH assets_total dummymarriage 
global rawcompo HHsize HH_count_child sexratio nonworkersratio
global rawindiv c.age##c.age i.edulevel i.relation2 i.sex i.marital



********** Exclusion 4
*hours_agriself hours_agricasu hours_casua hours_regnonqu hours_regquali hours_self hours_nrega
foreach x in hours_agri hours_nonagri hours_selfemp hours_casu {
capture noisily xtheckmanfe `x' DSR_lag ///
c.age##c.age i.edulevel i.relation2 i.sex i.marital ///
remittnet_HH assets_total dummymarriage ///
HHsize HH_count_child sexratio ///
, selection(work = c.nonworkersratio) ///
id(panelvar) time(year) reps(30)
est store excl_`x'
}


********** Tables
esttab excl_* using "Heckman_jobs.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

****************************************
* END

