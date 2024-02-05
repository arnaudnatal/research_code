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

* Density
twoway ///
(kdensity DSR_lag if time==2 & DSR_lag<400, bwidth(5)) ///
(kdensity DSR_lag if time==3 & DSR_lag<400, bwidth(5)) ///
, ///
xtitle("Lag DSR (%)") xlabel(0(50)400) xmtick(0(25)400) ///
ytitle("Density") ///
legend(order(1 "2016-17 (i.e., 2010 values)" 2 "2020-21 (i.e., 2016-17 values)") pos(6) col(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 5", size(vsmall)) ///
name(densitydsr, replace)
graph export "DSR_density.pdf", as(pdf) replace


* Stripplot
stripplot DSR_lag if DSR_lag<400, over(time) ///
stack width(5) jitter(2) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh) msize(small) mc(gs8%30) ///
xtitle("Lag DSR (%)") xlabel(0(50)400) xmtick(0(25)400) ///
ytitle("") ylabel(2 "2016-17 (i.e., 2010 values)" 3 "2020-21 (i.e., 2016-17 values)", noticks) ///
legend(order(4 "Whisker from 5% to 95%") pos(6) col(3) on) ///
name(stripplotdsr, replace)
graph export "DSR_stripplot.pdf", as(pdf) replace



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

********** LFP
fre work
ta work year
ta work year, col nofreq
ta work sexyear, col nofreq
tabplot work sexyear, percent(sexyear) showval frame(100) ///
subtitle("") xtitle("") ytitle("") ///
note("% by sex by year", size(vsmall)) ///
ylabel(1 "Worker" 2 "Non-worker") ///
xlabel(1 `" "Male" "2016-17" "' 2 `" "Male" "2020-21" "' 3 `" "Female" "2016-17" "' 4 `" "Female" "2020-21" "') ///
name(tabplot_work, replace)
graph export "Work_sex.pdf", as(pdf) replace


***** Multiple
fre multipleoccup
ta multipleoccup year, col nofreq
ta multipleoccup sexyear, col nofreq

tabplot multipleoccup sexyear, percent(sexyear) showval frame(100) ///
subtitle("") xtitle("") ytitle("") ///
note("% by sex by year", size(vsmall)) ///
ylabel(1 "Several occupations" 2 "One occupation") ///
xlabel(1 `" "Male" "2016-17" "' 2 `" "Male" "2020-21" "' 3 `" "Female" "2016-17" "' 4 `" "Female" "2020-21" "') ///
name(tabplot_work, replace)
graph export "Multiple_sex.pdf", as(pdf) replace


***** Labour supply
tabstat hoursamonth_indiv, stat(n mean cv p50) by(year)
tabstat hoursamonth_indiv, stat(n mean cv p50) by(sexyear)

ta hoursaweek_indiv if sex==1 & time==3
ta hoursaweek_indiv if sex==2 & time==3

* Density
twoway ///
(kdensity hoursamonth_indiv if sexyear==1, bwidth(20) lpattern(solid) lcolor(gs0)) ///
(kdensity hoursamonth_indiv if sexyear==2, bwidth(20) lpattern(dash) lcolor(gs0)) ///
(kdensity hoursamonth_indiv if sexyear==3, bwidth(20) lpattern(solid) lcolor(gs10)) ///
(kdensity hoursamonth_indiv if sexyear==4, bwidth(20) lpattern(dash) lcolor(gs10)) ///
, ///
xtitle("Monthly working hours") xlabel(0(50)600) xmtick(0(25)600) ///
ytitle("Density") ///
legend(order(1 "Male in 2016-17" 2 "Male in 2020-21" 3 "Female in 2016-17" 4 "Female in 2020-21") pos(6) col(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 20", size(vsmall)) ///
name(densityls, replace)
graph export "LS_density.pdf", as(pdf) replace

* Stripplot
stripplot hoursamonth_indiv, over(sexyear) ///
stack width(10) jitter(2) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh) msize(small) mc(gs8%30) ///
xtitle("Monthly working hours") xlabel(0(50)600) xmtick(0(25)600) ///
ytitle("") ylabel(1 "Male in 2016-17" 2 "Male in 2020-21" 3 "Female in 2016-17" 4 "Female in 2020-21", noticks) ///
legend(order(4 "Whisker from 5% to 95%") pos(6) col(3) on) ///
name(stripplotls, replace)
graph export "LS_stripplot.pdf", as(pdf) replace


********** Occupation
fre mainocc_occupation_indiv

ta mainocc_occupation_indiv sexyear
ta mainocc_occupation_indiv sexyear, col nofreq

ta mainocc_occupation_indiv year
ta mainocc_occupation_indiv year, col nofreq
ta mainocc_occupation_indiv sex, exp cchi2 chi2 col

ta mainocc_occupation_indiv sex if year==2016, exp cchi2 chi2
ta mainocc_occupation_indiv sex if year==2020, exp cchi2 chi2
ta mainocc_occupation_indiv sexyear, exp cchi2 chi2

ta mainocc_occupation_indiv year, col nofreq
ta mainocc_occupation_indiv sexyear, col nofreq

tabplot mainocc_occupation_indiv sexyear, percent(sexyear) showval frame(100) ///
subtitle("") xtitle("") ytitle("") ///
note("% by sex by year", size(vsmall)) ///
ylabel(7 "Agri SE" 6 "Agri casual" 5 "Casual" 4 "Reg non-quali" 3 "Reg quali" 2 "SE" 1 "MGNREGA") ///
xlabel(1 `" "Male" "2016-17" "' 2 `" "Male" "2020-21" "' 3 `" "Female" "2016-17" "' 4 `" "Female" "2020-21" "') ///
name(tabplot_moc, replace)
graph export "Occupation_sex.pdf", as(pdf) replace



********** Controls
cls
foreach x in edulevel relation2 marital {
ta `x' year, col nofreq
ta `x' sexyear, col nofreq
}
tabstat age, stat(n mean cv p50) by(year)
tabstat age, stat(n mean cv p50) by(sexyear)


****************************************
* END











****************************************
* Correlation families : LFP
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
keep HHID_panel INDID_panel year relationshiptohead2 work
fre relationshiptohead2

* Var tot 
bysort HHID_panel year relationshiptohead2: egen sum_rel=sum(1)
ta sum_rel

* Var LFP
bysort HHID_panel year relationshiptohead2: egen sum_LFP=sum(work)
ta sum_LFP

* Share LFP
gen shareLFP=sum_LFP/sum_rel

* Selection
keep HHID_panel year relationshiptohead2 sum_rel sum_LFP shareLFP
duplicates drop
ta year
sort HHID_panel year relationshiptohead2

* Reshape
drop sum_rel sum_LFP
rename shareLFP var
reshape wide var, i(HHID_panel year) j(relationshiptohead2)
rename var1 Head
rename var2 Wife
rename var3 Parents
rename var4 Son
rename var5 Daughter
rename var6 Son_in_law
rename var7 Daughter_in_law
rename var8 Siblings
rename var9 Grandchild
rename var10 Others

* Table
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.01)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.05)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.1)

****************************************
* END














****************************************
* Correlation families : hours
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if hoursayear_indiv==.
keep HHID_panel INDID_panel year relationshiptohead2 hoursayear_indiv
fre relationshiptohead2

* Selection
keep HHID_panel year relationshiptohead2 hoursayear_indiv
duplicates drop
ta year
sort HHID_panel year relationshiptohead2

* Var tot 
bysort HHID_panel year relationshiptohead2: egen sum_hours=sum(hoursayear_indiv)

* Selection
keep HHID_panel year relationshiptohead2 sum_hours
duplicates drop
ta year
sort HHID_panel year relationshiptohead2


* Reshape
rename sum_hours var
reshape wide var, i(HHID_panel year) j(relationshiptohead2)
rename var1 Head
rename var2 Wife
rename var3 Parents
rename var4 Son
rename var5 Daughter
rename var6 Son_in_law
rename var7 Daughter_in_law
rename var8 Siblings
rename var9 Grandchild
rename var10 Others

* Table
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.01)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.05)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.1)


****************************************
* END











****************************************
* Correlation families : occupations
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if work==0
keep HHID_panel INDID_panel year relationshiptohead2 mainocc_occupation_indiv
fre relationshiptohead2
rename mainocc_occupation_indiv occupation
fre occupation

* Var tot 
bysort HHID_panel year relationshiptohead2: egen sum_rel=sum(1)
ta sum_rel

* Var occ
ta occupation, gen(occ)
forvalues i=1/7 {
bysort HHID_panel year relationshiptohead2: egen sum_occ`i'=sum(occ`i')
}

* Share occ
forvalues i=1/7{
gen share_occ`i'=(sum_occ`i'/sum_rel)*100
}


* Selection
keep HHID_panel year relationshiptohead2 share_occ1 share_occ2 share_occ3 share_occ4 share_occ5 share_occ6 share_occ7
duplicates drop
ta year
sort HHID_panel year relationshiptohead2

* Reshape
rename share_occ1 agrise 
rename share_occ2 agrica
rename share_occ3 casual
rename share_occ4 regnon
rename share_occ5 regqua
rename share_occ6 selfem
rename share_occ7 mgnreg

reshape wide agrise agrica casual regnon regqua selfem mgnreg, i(HHID_panel year) j(relationshiptohead2)

foreach x in agrise agrica casual regnon regqua selfem mgnreg {
rename `x'1 hea_`x'
rename `x'2 wif_`x'
rename `x'3 par_`x'
rename `x'4 son_`x'
rename `x'5 dau_`x'
rename `x'6 sil_`x'
rename `x'7 dil_`x'
rename `x'8 sib_`x'
rename `x'9 gra_`x'
rename `x'10 oth_`x'
}


* Table
global varhea hea_agrise hea_agrica hea_casual hea_regnon hea_regqua hea_selfem hea_mgnreg
global varwif wif_agrise wif_agrica wif_casual wif_regnon wif_regqua wif_selfem wif_mgnreg
global varpar par_agrise par_agrica par_casual par_regnon par_regqua par_selfem par_mgnreg
global varson son_agrise son_agrica son_casual son_regnon son_regqua son_selfem son_mgnreg
global vardau dau_agrise dau_agrica dau_casual dau_regnon dau_regqua dau_selfem dau_mgnreg
global varsil sil_agrise sil_agrica sil_casual sil_regnon sil_regqua sil_selfem sil_mgnreg
global vardil dil_agrise dil_agrica dil_casual dil_regnon dil_regqua dil_selfem dil_mgnreg
global varsib sib_agrise sib_agrica sib_casual sib_regnon sib_regqua sib_selfem sib_mgnreg
global vargra gra_agrise gra_agrica gra_casual gra_regnon gra_regqua gra_selfem gra_mgnreg
global varoth oth_agrise oth_agrica oth_casual oth_regnon oth_regqua oth_selfem oth_mgnreg
global var $varhea $varwif $varpar $varson $vardau $varsil $vardil $varsib $vargra $varoth


cls
cpcorr $varhea \ $varwif, f(%4.2f)
cpcorr $varhea \ $varpar, f(%4.2f)
cpcorr $varhea \ $varson, f(%4.2f)
cpcorr $varhea \ $vardau, f(%4.2f)
cpcorr $varhea \ $varsil, f(%4.2f)
cpcorr $varhea \ $vardil, f(%4.2f)
cpcorr $varhea \ $varsib, f(%4.2f)
cpcorr $varhea \ $vargra, f(%4.2f)
cpcorr $varhea \ $varoth, f(%4.2f)

cpcorr $varwif \ $varpar, f(%4.2f)
cpcorr $varwif \ $varson, f(%4.2f)
cpcorr $varwif \ $vardau, f(%4.2f)
cpcorr $varwif \ $varsil, f(%4.2f)
cpcorr $varwif \ $vardil, f(%4.2f)
cpcorr $varwif \ $varsib, f(%4.2f)
cpcorr $varwif \ $vargra, f(%4.2f)
cpcorr $varwif \ $varoth, f(%4.2f)

cpcorr $varpar \ $varson, f(%4.2f)
cpcorr $varpar \ $vardau, f(%4.2f)
cpcorr $varpar \ $varsil, f(%4.2f)
cpcorr $varpar \ $vardil, f(%4.2f)
cpcorr $varpar \ $varsib, f(%4.2f)
cpcorr $varpar \ $vargra, f(%4.2f)
cpcorr $varpar \ $varoth, f(%4.2f)

cpcorr $varson \ $vardau, f(%4.2f)
cpcorr $varson \ $varsil, f(%4.2f)
cpcorr $varson \ $vardil, f(%4.2f)
cpcorr $varson \ $varsib, f(%4.2f)
cpcorr $varson \ $vargra, f(%4.2f)
cpcorr $varson \ $varoth, f(%4.2f)

cls
pwcorr $var

cls
pwcorr $var, star(0.01)

cls
pwcorr $var, star(0.05)

cls
pwcorr $var, star(0.1)

****************************************
* END


















****************************************
* Correlation families : occupations MCA
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if work==0
keep HHID_panel year relationshiptohead2 mainocc_occupation_indiv
fre relationshiptohead2
rename mainocc_occupation_indiv occupation
rename relationshiptohead2 relation
bysort HHID_panel year relation: gen n=_n

egen relan=group(relation n), label
drop relation n

reshape wide occupation, i(HHID_panel year) j(relan)


* Chi2
cls
forvalues i=1/25 {
local j=`i'+1
forvalues k=`j'/25 {
ta occupation`i' occupation`k', chi2
}
}

****************************************
* END










****************************************
* Correlation sex : occupations
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if work==0
keep HHID_panel INDID_panel year sex mainocc_occupation_indiv
fre sex
rename mainocc_occupation_indiv occupation
fre occupation

* Var tot 
bysort HHID_panel year sex: egen sum_rel=sum(1)
ta sum_rel

* Var occ
ta occupation, gen(occ)
forvalues i=1/7 {
bysort HHID_panel year sex: egen sum_occ`i'=sum(occ`i')
}

* Share occ
forvalues i=1/7{
gen share_occ`i'=(sum_occ`i'/sum_rel)*100
}


* Selection
keep HHID_panel year sex share_occ1 share_occ2 share_occ3 share_occ4 share_occ5 share_occ6 share_occ7
duplicates drop
ta year
sort HHID_panel year sex

* Reshape
rename share_occ1 agrise 
rename share_occ2 agrica
rename share_occ3 casual
rename share_occ4 regnon
rename share_occ5 regqua
rename share_occ6 selfem
rename share_occ7 mgnreg

reshape wide agrise agrica casual regnon regqua selfem mgnreg, i(HHID_panel year) j(sex)

foreach x in agrise agrica casual regnon regqua selfem mgnreg {
rename `x'1 male_`x'
rename `x'2 fema_`x'
}


* Table
global varmale male_agrise male_agrica male_casual male_regnon male_regqua male_selfem male_mgnreg
global varfema fema_agrise fema_agrica fema_casual fema_regnon fema_regqua fema_selfem fema_mgnreg
global var $varmale $varfema

* 2016-17
cls
cpcorr $varmale \ $varfema if year==2016, f(%4.2f)
matrix pval=r(p)
matrix list pval

* 2020-21
cls
cpcorr $varmale \ $varfema if year==2020, f(%4.2f)
matrix pval=r(p)
matrix list pval

* Pooled
cls
cpcorr $varmale \ $varfema, f(%4.2f)
matrix pval=r(p)
matrix list pval

****************************************
* END





















****************************************
* Correlation couples
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
keep HHID_panel INDID_panel year relationshiptohead2 work hoursayear_indiv mainocc_occupation_indiv annualincome_indiv nboccupation_indiv
fre relationshiptohead2

* Keep head and wife
keep if relationshiptohead2==1 | relationshiptohead2==2

* Check duplicates head
ta relationshiptohead2, gen(rela)
forvalues i=1/2 {
bysort HHID_panel year: egen sum_rela`i'=sum(rela`i')
drop rela`i'
}
drop if sum_rela1==0 
drop if sum_rela2==0
drop if sum_rela1==2
drop if sum_rela2==2
drop sum_rela1 sum_rela2

* Reshape
reshape wide INDID_panel mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv work, i(HHID_panel year) j(relationshiptohead2)
ta year



********* Labour characteristics
* Decision to work
ta work1 work2, chi2 exp cchi2

* Main occupation
ta mainocc_occupation_indiv1 mainocc_occupation_indiv2, chi2 exp cchi2

* Nb of occupation
pwcorr nboccupation_indiv1 nboccupation_indiv2, sig

* Labour supply
pwcorr hoursayear_indiv1 hoursayear_indiv2, sig

* Income
pwcorr annualincome_indiv1 annualincome_indiv2, sig


****************************************
* END
