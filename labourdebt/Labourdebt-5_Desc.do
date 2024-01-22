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





********** Deuxième sélection : vérifier les missings
mdesc hoursaweek_indiv DSR_lag age edulevel relation2 sex marital remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio work nonworkersratio

* 1303 ?
ta work panel, m
/*
1303 missings for hours a week --> 1303 who do not work = sample selection issue corrected with two stage Heckman procedure
*/

* 988 ?
ta panel year, m
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

***** Remittances
replace remittnet_HH=remittnet_HH/1000

***** Assets
replace assets_total=assets_total/1000



********** Stat desc
**** DSR
tabstat DSR, stat(n mean cv p50) by(year)
tabstat DSR_all, stat(n mean cv p50) by(year)

***** Remittances
tabstat remittnet_HH, stat(n mean cv p50) by(year)

***** Assets
tabstat assets_total, stat(n mean cv p50) by(year)

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
********** LFP
fre sexyear
fre work
ta work sexyear, col nofreq

tabplot work sexyear, percent(sexyear) showval frame(100) ///
subtitle("") xtitle("") ytitle("") ///
note("% by sex by year", size(vsmall)) ///
ylabel(1 "Worker" 2 "Non-worker") ///
xlabel(1 `" "Male" "2016-17" "' 2 `" "Male" "2020-21" "' 3 `" "Female" "2016-17" "' 4 `" "Female" "2020-21" "') ///
name(tabplot_work, replace)
graph export "Work_sex.pdf", as(pdf) replace


***** Multiple
ta multipleoccup sexyear, col nofreq

tabplot multipleoccup sexyear, percent(sexyear) showval frame(100) ///
subtitle("") xtitle("") ytitle("") ///
note("% by sex by year", size(vsmall)) ///
ylabel(1 "Several occupations" 2 "One occupation") ///
xlabel(1 `" "Male" "2016-17" "' 2 `" "Male" "2020-21" "' 3 `" "Female" "2016-17" "' 4 `" "Female" "2020-21" "') ///
name(tabplot_work, replace)
graph export "Multiple_sex.pdf", as(pdf) replace


***** Labour supply
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
graph export "LS_density.pdf", as(pdf) replace

* Stripplot
stripplot hoursamonth_indiv, over(sex) ///
stack width(10) jitter(2) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh) msize(small) mc(black%30) ///
xline(139 208.6) ///
xtitle("Monthly working hours") xlabel(0(50)600) xmtick(0(25)600) ///
ytitle("") ylabel(1 "Male" 2 "Female", noticks) ///
legend(order(4 "Whisker from 5% to 95%") pos(6) col(3) on) ///
name(stripplotls, replace)
graph export "LS_stripplot.pdf", as(pdf) replace


********** Occupation
fre sexyear
fre mainocc_occupation_indiv
ta mainocc_occupation_indiv sexyear, col nofreq

tabplot mainocc_occupation_indiv sexyear, percent(sexyear) showval frame(100) ///
subtitle("") xtitle("") ytitle("") ///
note("% by sex by year", size(vsmall)) ///
ylabel(7 "Agri SE" 6 "Agri casual" 5 "Casual" 4 "Reg non-quali" 3 "Reg quali" 2 "SE" 1 "MGNREGA") ///
xlabel(1 `" "Male" "2016-17" "' 2 `" "Male" "2020-21" "' 3 `" "Female" "2016-17" "' 4 `" "Female" "2020-21" "') ///
name(tabplot_moc, replace)
graph export "Occupation_sex.pdf", as(pdf) replace




********** Controls
foreach x in edulevel relation2 {
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



********* Labour characteristics
* Decision to work
ta working_pop1 working_pop2, chi2

* Main occupation
ta mainocc_occupation_indiv1 mainocc_occupation_indiv2, chi2 exp cchi2

* Nb of occupation
corr nboccupation_indiv1 nboccupation_indiv2

* Labour supply
corr hoursayear_indiv1 hoursayear_indiv2

* Income
corr annualincome_indiv1 annualincome_indiv2


****************************************
* END















****************************************
* Attrition individual level
****************************************
use"raw/keypanel-indiv_long", clear

* Var to keep
ta year
keep HHID_panel INDID_panel year
destring year, replace
drop if year==2010

* Var for regressions
global varreg hoursamonth_indiv DSR_lag age edulevel relation2 sex marital remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio work nonworkersratio
global varsup panel multipleoccup caste villageid hoursaweek_indiv hoursayear_indiv working_pop mainocc_occupation_indiv
merge 1:1 HHID_panel INDID_panel year using "panel_laboursupplyindiv_v2", keepusing($varreg $varsup)
/*
Je supprime les individus de 2010 car pas de y
Je supprime les morts
*/
keep if _merge==3
drop _merge
ta year

* Selection
drop if age<14
sort HHID_panel INDID_panel year

* Var for selection
merge 1:1 HHID_panel INDID_panel year using "ssizeindiv"
drop _merge
ta selection_indiv year, m
/*
selection_indiv permet la selection entre attrition et panel
*/

* Check for working status
ta selection_indiv
/*
Total sample - 	4330
Attrition - 	988
Panel - 		3342
*/

ta selection_indiv year if work==1
/*
Working individual - 	3027
Attrition -				673
Panel - 				2354
*/




********** Attrition
tabstat age hoursamonth_indiv, stat(min p1 p5 p10 q p90 p95 p99 max)
gen cat_age=.
replace cat_age=1 if age<25 & age!=.
replace cat_age=2 if age>=25 & age<35 & age!=.
replace cat_age=3 if age>=35 & age<45 & age!=.
replace cat_age=4 if age>=45 & age<60 & age!=.
replace cat_age=5 if age>=60 & age!=.

gen cat_hours=.
replace cat_hours=1 if hoursamonth_indiv<60 & hoursamonth_indiv!=.
replace cat_hours=2 if hoursamonth_indiv>=60 & hoursamonth_indiv<110 & hoursamonth_indiv!=.
replace cat_hours=3 if hoursamonth_indiv>=110 & hoursamonth_indiv<180 & hoursamonth_indiv!=.
replace cat_hours=4 if hoursamonth_indiv>=180 & hoursamonth_indiv<240 & hoursamonth_indiv!=.
replace cat_hours=5 if hoursamonth_indiv>=240 & hoursamonth_indiv!=.

cls
foreach x in cat_age sex relation2 caste edulevel work multipleoccup working_pop mainocc_occupation_indiv cat_hours {
ta `x' selection_indiv, exp cchi2 chi2
}

/*
Qui sont les individus attrition ?
- "25 35 ans" surreprésentés dans l'attrition et sous-représentés dans le panel
- Rien sur le sexe
- "Parents" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Middles" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Uppers" sous-représentés dans l'attrition et surreprésentés dans le panel
- "HSC or more" surreprésentés dans l'attrition et sous-représentés dans le panel
- Rien sur le statut dans l'emploi
- Rien sur les occupations multiples
- "Casual" sous-représentés dans l'attrition et surreprésentés dans le panel
- "MGNREGA" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Q3 LS" sous-représentés dans l'attrition et surreprésentés dans le panel
- "Q5 LS" surreprésentés dans l'attrition et sous-représentés dans le panel
*/

****************************************
* END














****************************************
* Attrition household level
****************************************
use"raw/keypanel-HH_long", clear

* Var to keep
ta year
keep HHID_panel year
destring year, replace
drop if year==2010

* Var for regressions
global varreg DSR_lag remittnet_HH assets_total dummymarriage HHsize HH_count_child sexratio nonworkersratio
global varsup panel caste villageid
merge 1:m HHID_panel year using "panel_laboursupplyindiv_v2", keepusing($varreg $varsup)
/*
Je supprime les ménages de 2010 car pas de y
Je supprime les doublons pour être à l'échelle du ménage
*/
keep if _merge==3
drop _merge
duplicates drop
ta year

* Var for selection
merge 1:1 HHID_panel year using "ssizeHH"
drop _merge
ta selection_HH year, m
/*
selection_HH permet la selection entre attrition et panel
*/

* Sample size
ta selection_HH
/*
Total sample - 	1124
Attrition - 	251
Panel - 		873
*/



********** Attrition
foreach x in HHsize HH_count_child sexratio assets_total nonworkersratio remittnet_HH DSR_lag {
xtile q_`x'=`x', n(3)
}

cls
foreach x in q_HHsize q_HH_count_child q_sexratio q_assets_total q_nonworkersratio q_remittnet_HH q_DSR_lag dummymarriage caste villageid {
ta `x' selection_HH, exp cchi2 chi2
}

/*
Qui sont les ménages attrition ?
- Rien sur la taille du ménage
- "Q1 nb child" sous-représentés dans l'attrition et surreprésentés dans le panel
- "Q3 nb child" surreprésentés dans l'attrition et sous-représenéts dans le panel
- Rien sur le sex ratio
- "Q1 assets" sous-représentés dans l'attrition et surreprésentés dans le panel
- "Q3 non workers ratio" surreprésentés dans l'attrition et sous-représentés dans le panel
- Rien sur les remittances
- Rien sur le mariage
- "Middles" surreprésentés dans l'attrition et sous-représentés dans le panel
- "Uppers" sous-représentés dans l'attrition et surreprésentés dans le panel
- Rien sur les villages
*/

****************************************
* END





