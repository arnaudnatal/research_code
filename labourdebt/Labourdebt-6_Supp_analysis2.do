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
* Lag Share dsr
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Check year
ta share_dsr year
ta lag_share_dsr year


********** Selection
drop if age<14
keep if year==2020


********** Sort
sort HHID_panel INDID_panel year



********** Controls
global nonvar i.caste i.villageid
global econ remittnet_HH assets_total dummymarriage 
global compo HHsize HH_count_child sexratio nonworkersratio
global indiv c.age##c.age i.edulevel i.relation2 i.sex

********** Total
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_total.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))


	
********** Males
preserve
fre sex
keep if sex==1
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_males.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore



********** Females
preserve
fre sex
keep if sex==2
* Work
qui reg work lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store work
* Hours a year
qui reg hoursayear_indiv lag_share_dsr $indiv $econ $compo, cluster(HHFE)
est store hour
* Tables
esttab work hour using "Sharedsr_females.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	drop(_cons $econ $compo) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N, fmt(0) ///
	labels(`"Observations"'))
restore
	
****************************************
* END





















****************************************
* Caractéristiques de l'emploi des femmes
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Selection
drop if age<14


********** Type of employment
cls
preserve
keep if work==1
ta mainocc_occupation_indiv sex, col nofreq
ta mainocc_occupation_indiv sex, cchi2 exp chi2
restore
/*
Femmes sur-représentés dans les activités agri casual et MGNREGA.
*/



********** Hourly income
cls
preserve
keep if work==1
gen hourlyincome=mainocc_annualincome_indiv/mainocc_hoursayear_indiv
tabstat hourlyincome, stat(n mean cv p50) by(sex) long
tabstat hourlyincome, stat(n mean cv p50) by(mainocc_occupation_indiv) long
reg hourlyincome i.sex##i.mainocc_occupation_indiv, clust(HHFE) baselevel
restore

/*
Femmes ont un hourly income beaucoup plus faible que celui des hommes
Agri casual et MGNREGA ont un hourly income beaucoup plus faible que les autres occupations
*/



********** WEC
cls
preserve
keep if work==1
global var executionwork problemwork workexposure wec
tabstat $var, stat(n mean cv p50) by(sex) long
tabstat $var, stat(n mean cv p50) by(mainocc_occupation_indiv) long
foreach x in $var {
reg `x' i.sex##i.mainocc_occupation_indiv, clust(HHFE) allbaselevels
}
restore



********** Discrimination
cls
preserve
keep if work==1
global var respect workmate agreementatwork1 agreementatwork2 agreementatwork3 agreementatwork4 happywork verbalaggression physicalaggression sexualharassment discrimination discrimination_dummy
tabstat $var, stat(n mean cv p50) by(sex) long
tabstat $var, stat(n mean cv p50) by(mainocc_occupation_indiv) long
foreach x in $var {
reg `x' i.sex##i.mainocc_occupation_indiv, clust(HHFE) allbaselevels
}
restore



****************************************
* END


