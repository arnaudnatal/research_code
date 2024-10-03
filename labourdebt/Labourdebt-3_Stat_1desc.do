*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Stat desc 1
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------






****************************************
* Verification sample size
****************************************
use"raw/keypanel-indiv_long", clear

ta year
keep HHID_panel INDID_panel year
destring year, replace

merge 1:1 HHID_panel INDID_panel year using "panel_laboursupplyindiv_v2", keepusing(hoursaweek_indiv DSR_lag age edulevel relation2 sex marital remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio work nonworkersratio panel)
fre _merge
rename _merge selection
recode selection (3=2)
label define selection 1"Attrition" 2"Selection"
label values selection selection
fre selection
order HHID_panel INDID_panel year selection


********** Qui est dans l'échantillon ?
ta selection year
/*
Analyse à l'échelle individuelle avec l'offre de travail en Y qu'on observe qu'en 2016-17 et 2020-21, donc rien en 2010.
On supprime les individus qui sont morts ou absents ca donne bien : 
2301 individus en 2016-17
3005 individus en 2020-21
5306 individus en tout donc
*/
drop if selection==1




********** Première sélection : supprimer les moins de 14
drop if age<14
/*
On en supprime 976 qui ont moins de 14 ans, l'âge légal pour travailler. 
*/

ta year
bysort HHID_panel INDID_panel: gen n=_N
ta n



********** Deuxième sélection : vérifier les missings
mdesc hoursaweek_indiv DSR_lag age edulevel relation2 sex marital remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio work nonworkersratio

* 1303 ?
ta work, m
/*
1303 missings for hours a week --> 1303 who do not work = sample selection issue corrected with two stage Heckman procedure
*/

* 988 ?
ta panel year, m
preserve
keep if panel==.
keep HHID_panel year
duplicates drop
ta year
restore
ta panel work, m
/*
988 missings
Ils correspondent à l'attrition car variable en lag
401 individus en 2016
587 individus en 2020

Ca représente combien de ménages ?
*/
preserve
keep HHID_panel year panel
duplicates drop
ta panel year, m
restore
/*
104 ménages en 2016
147 ménages en 2020
*/



********** Indiv level
keep HHID_panel INDID_panel year panel
rename panel selection_indiv
recode selection_indiv (.=0)
ta selection_indiv year, m
save"ssizeindiv", replace

drop INDID_panel
duplicates drop
ta year
ta selection_indiv year


********** HH level

drop INDID_panel
duplicates drop
rename selection_indiv selection_HH
recode selection_HH (.=0)
ta selection_HH year, m
save"ssizeHH", replace

****************************************
* END













****************************************
* HH level stat
****************************************
use"raw/keypanel-HH_long", clear


ta year
drop if HHID==""
ta year
keep HHID_panel year
destring year, replace


********** Merging
***** Selection
merge 1:1 HHID_panel year using "ssizeHH"
drop _merge
ta selection_HH year, m

***** Debt
merge 1:1 HHID_panel year using "panel_debt_noinvest"
drop _merge

***** Income
merge 1:1 HHID_panel year using "panel_cont_v1"
keep if _merge==3
drop _merge


********** Variables
***** Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

***** DSR
gen DSR=(imp1_ds_tot_HH/annualincome_HH)*100
gen DSR_all=DSR
recode DSR_all (.=0)
tabstat DSR_all, stat(n mean cv p50) by(year)
ta selection_HH

***** Remittances
replace remittnet_HH=remittnet_HH/1000

***** Assets
replace assets_total=assets_total/1000



********** Stat desc
use"panel_laboursupplyindiv_v2", clear

preserve
keep HHID_panel year
duplicates drop
ta year
restore

keep HHID_panel year time DSR DSR_lag remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio nonworkersratio annualincome_HH
duplicates drop
ta year
drop if DSR_lag==.
ta year


**** DSR
tabstat DSR_lag, stat(n mean cv q p90 p95) by(year)

tabstat DSR_lag, stat(n p90 p95 p99 max) by(year)

* Stripplot
preserve
fre time
label define time 2"2010" 3"2016-17", replace
violinplot DSR_lag, over(time) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
xtitle("Debt service ratio (%)") xlabel(0(20)200) ///
ylabel(,grid) ///
legend(order(3 "IQR" 5 "Median" 7 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(vio, replace) range(0 200) ///
note("{it:Note:} For 388 households in 2010 and 485 in 2016-17." "{it:Source:} RUME (2010) and NEEMSIS-1 (2016-17); authors' calculations.", size(vsmall))
graph export "DSR.png", as(png) replace
restore


***** Remittances
tabstat remittnet_HH, stat(n mean cv p50) by(year)

***** Assets
tabstat assets_total, stat(n mean cv p50) by(year)

***** Income
tabstat annualincome_HH, stat(n mean cv p50) by(year)

***** Marriage
ta dummymarriage year, col nofreq

***** HH size
tabstat HHsize, stat(n mean cv p50) by(year)

***** Number of children
tabstat HH_count_child, stat(n mean cv p50) by(year)

***** Sex ratio
tabstat sexratio, stat(n mean cv p50) by(year)

***** Non workers ratio
tabstat nonworkersratio, stat(n mean cv p50) by(year)


****************************************
* END





















****************************************
* Indiv level stat
****************************************
use"panel_laboursupplyindiv_v2", clear


********** Merging
merge 1:1 HHID_panel INDID_panel year using "ssizeindiv"
drop _merge
ta selection_indiv year, m
keep if selection_indiv==1


********** Selection
drop if age<14
sort HHID_panel INDID_panel year
ta selection_indiv year, m


********** Stat desc
ta year
ta sexyear


***** Labour supply
tabstat hoursamonth_indiv, stat(n mean cv p50) by(year)
tabstat hoursamonth_indiv, stat(n mean cv p50) by(sexyear)

ta hoursaweek_indiv if sex==1 & time==3
ta hoursaweek_indiv if sex==2 & time==3

* Violin
fre sexyear
codebook sexyear
label define sexyear 1"Men in 2016-17" 2"Men in 2020-21" 3"Women in 2016-17" 4"Women in 2020-21", replace
violinplot hoursamonth_indiv, over(sexyear) horizontal left dscale(4) noline now ///
fill(color(black%10)) ///
box(t(b)) bcolors(plb1) ///
mean(t(m)) meancolors(plr1) ///
med(t(m)) medcolors(ananas) ///
xtitle("Monthly working hours") xlabel(0(50)400) ///
ylabel(,grid) ///
legend(order(7 "IQR" 10 "Median" 13 "Mean") pos(6) col(3) on) ///
aspectratio() scale(1.2) name(vio, replace) range(0 400) ///
note("{it:Note:} For 1047 individuals in 2016-17 and 1307 in 2020-21." "{it:Source:} NEEMSIS-1 (2016-17) and NEEMSIS-2 (2020-21); authors' calculations.", size(vsmall))
graph export "LS_stripplot.png", as(png) replace


****************************************
* END

