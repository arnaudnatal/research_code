*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*March 19, 2024
*-----
gl link = "stabpsycho"
*Stab
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------







****************************************
* Probit stable vs unstable
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv c.age2016 i.sex ib(0).educode ib(3).moc_indiv i.marital
global cogni fES2016 fOPEX2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste ib(2).assets2016_q ib(2).annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockdebt2 dummyshockhealth2
*dummyshockincome dummyshockland

fre dumdiff_fES dumdiff_fOPEX dumdiff_fCO

***** ES
probit dumdiff_fES $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg1
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1



***** OPEX
probit dumdiff_fOPEX $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg2
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2

***** CO
probit dumdiff_fCO $indiv $cogni $house $shock $contr, cluster(cluster) baselevel
est store reg3
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3


***** Tables
esttab reg1 reg2 reg3 using "new/probit.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N r2_p, fmt(0 2) ///
	labels(`"Observations"' `"Pseudo R2"'))

****************************************
* END




















****************************************
* Multi probit stable vs dec vs inc
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv c.age2016 i.sex ib(0).educode ib(3).moc_indiv i.marital
global cogni fES2016 fOPEX2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste ib(2).assets2016_q ib(2).annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockdebt2 dummyshockhealth2
*dummyshockincome dummyshockland



***** ES
cls
mprobit catdiff_fES $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg1
*margins, dydx($indiv $cogni $house $shock) atmeans post
*est store mar1


***** OPEX
mprobit catdiff_fOPEX $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg2
*margins, dydx($indiv $cogni $house $shock) atmeans post
*est store mar2


***** CO
mprobit catdiff_fCO $indiv $cogni $house $shock $contr, cluster(cluster) baselevel baseoutcome(2)
est store reg3
*margins, dydx($indiv $cogni $house $shock) atmeans post
*est store mar3



***** Tables
esttab reg1 reg2 reg3 using "new/mprobit.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))

/*
esttab mar1 mar2 mar3 using "mprobit_margins.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
*/
****************************************
* END
















****************************************
* Degree of instability
****************************************
use "panel_stab_pooled_wide_v3", clear
est clear
graph drop _all


***** Macro
global indiv i.sex ib(0).educode ib(2).age_cat ib(2).moc_indiv i.marital
global cogni fES2016 fOPEX2016 fCO2016 num_tt2016 lit_tt2016 raven_tt2016
global house i.caste ib(2).assets2016_q ib(2).annualincome_HH2016_q c.HHsize2016 i.typeoffamily2016
global contr i.username_neemsis1 i.username_neemsis2 i.diff_ars3_cat5 i.villageid2016
global shock dummysell2020 dummydemonetisation2016 dummyshockdebt2 dummyshockhealth2
*dummyshockincome dummyshockland


***** ES
* Unstable
glm abs_diff_fES $indiv $cogni $house $shock $contr ///
if catdiff_fES==1 | catdiff_fES==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1ES
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1ES

* Increasing
glm abs_diff_fES $indiv $cogni $house $shock $contr ///
if catdiff_fES==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2ES
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2ES

* Decreasing
glm abs_diff_fES $indiv $cogni $house $shock $contr ///
if catdiff_fES==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3ES
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3ES





***** OPEX
* Unstable
glm abs_diff_fOPEX $indiv $cogni $house $shock $contr ///
if catdiff_fOPEX==1 | catdiff_fOPEX==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1OPEX
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1OPEX

* Increasing
glm abs_diff_fOPEX $indiv $cogni $house $shock $contr ///
if catdiff_fOPEX==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2OPEX
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2OPEX

* Decreasing
glm abs_diff_fOPEX $indiv $cogni $house $shock $contr ///
if catdiff_fOPEX==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3OPEX
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3OPEX




***** CO
* Unstable
glm abs_diff_fCO $indiv $cogni $house $shock $contr ///
if catdiff_fCO==1 | catdiff_fCO==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg1CO
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar1CO

* Increasing
glm abs_diff_fCO $indiv $cogni $house $shock $contr ///
if catdiff_fCO==3 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg2CO
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar2CO

* Decreasing
glm abs_diff_fCO $indiv $cogni $house $shock $contr ///
if catdiff_fCO==1 ///
, link(log) family(igaussian) cluster(cluster) allbase
est store reg3CO
margins, dydx($indiv $cogni $house $shock) atmeans post
est store mar3CO



********** Format
/*
esttab ///
reg1ES mar1ES reg2ES mar2ES reg3ES mar3ES ///
reg1OPEX mar1OPEX reg2OPEX mar2OPEX reg3OPEX mar3OPEX ///
reg1CO mar1CO reg2CO mar2CO reg3CO mar3CO ///
*/

esttab ///
mar1ES mar2ES mar3ES ///
mar1OPEX mar2OPEX mar3OPEX ///
mar1CO mar2CO mar3CO ///
using "new/glm.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))
****************************************
* END














/*



****************************************
* FE model
****************************************


********** Reshape
use "panel_stab_pooled_wide_v3", clear

drop age25 educode educode20

reshape long egoid age jatiscorr edulevel villageid panel dummydemonetisation relationshiptohead maritalstatus mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_occupationname_indiv annualincome_indiv annualincome_HH expenses_heal shareexpenses_heal assets_sizeownland ownland assets_total1000 assets_totalnoland1000 HHsize typeoffamily villagename villagename_club loanamount_HH raven_tt num_tt lit_tt aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 dummymarriage dummy_marriedlist dummyexposure secondlockdownexposure dummysell submissiondate ars ars2 ars3 username_backup edulevel_backup fES fOPEX fCO curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm, i(HHID_panel INDID_panel) j(year)

drop if egoid==.
ta year

egen HHINDID_panel=group(HHID_panel INDID_panel)
ta HHINDID_panel


save"_temp_FE", replace


********** Econometrics
use"_temp_FE", clear
est clear
graph drop _all
xtset HHINDID_panel year


***** Macro
global indiv c.age i.edulevel ib(2).mainocc_occupation_indiv i.maritalstatus
global house c.assets_total1000 c.annualincome_HH c.HHsize i.typeoffamily
global contr i.username_neemsis1 i.username_neemsis2 c.ars3 i.villageid
global shock dummyshockland dummyshockdebt dummyshockhealth dummyshockincome

***** ES
xtreg fES $indiv $house $shock $contr, fe
est store feES

***** OPEX
xtreg fOPEX $indiv $house $shock $contr, fe
est store feOPEX

***** CO
xtreg fCO $indiv $house $shock $contr, fe
est store feCO





********** Format
esttab ///
feES feOPEX feCO ///
using "new/fe.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N ll, fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Log-pseudo likelihood"'))

****************************************
* END



