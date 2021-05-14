*Arnaud NATAL, University of Bordeaux, 20/10/2020
*Debt, institutions and individuals
clear all
global name "anatal"

global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"



****************************************
* APPEND PANEL
****************************************
use"$directory\_temp\panel_NEEMSIS.dta", clear
append using "$directory\_temp\panel_RUME.dta", force
sort HHID
order villageid villageareaid HHID year, first
save"$directory\_temp\panel_v1.dta", replace
****************************************
* END



****************************************
* HH moc
****************************************
use"$directory\_temp\Panel_occupations_clean.dta", clear
tabstat annualincome, stat(n mean sd p50) by(year)
tab occupa_unemployed year, m
/*
From here, I can generate the main occupation per households
First, I need to generate one income var per occupation and then, collapse by households
*/
fre occupa_unemployed
/*
0 Unoccupied working age individuals
1 Agri self-employed
2 Agri casual workers
3 Non-agri casual workers
4 Non-agri regular non-qualified workers
5 Non-agri regular qualified workers
6 Non-agri self-employed
7 Public employment scheme workers (NREGA)
*/
forvalues i=0(1)7{
gen annualincome_`i'=. 
}
forvalues i=0(1)7{
replace annualincome_`i'=annualincome if occupa_unemployed==`i'
}
forvalues i=0(1)7{
gen source_`i'=. 
}
forvalues i=0(1)7{
replace source_`i'=1 if annualincome_`i'!=.
replace source_`i'=0 if annualincome_`i'==.
}
egen HHIDyear=concat(HHID year), p(/)
collapse (sum) annualincome_* annualincome source_*, by(HHIDyear)
split HHIDyear, p(/)
rename HHIDyear1 HHID
rename HHIDyear2 year
destring year, replace
order HHID year, first
bysort HHID : gen n=_N
keep if n==2
drop n HHIDyear
egen maxincome=rowmax(annualincome_0 annualincome_1 annualincome_2 annualincome_3 annualincome_4 annualincome_5 annualincome_6 annualincome_7)
gen mainoccupation_HH=.
forvalues i=0(1)7{
replace mainoccupation_HH=`i' if maxincome==annualincome_`i'
}
label define moc 0"\hspace*{0.2cm} Unoccupied working age individuals" 1"\hspace*{0.2cm} Agri. SE" 2"\hspace*{0.2cm} Agri. casual" 3"\hspace*{0.2cm} Non-agri. casual" 4"\hspace*{0.2cm} Non-agri. regular non-quali." 5"\hspace*{0.2cm} Non-agri. regular quali." 6"\hspace*{0.2cm} Non-agri. SE" 7"\hspace*{0.2cm} NREGA"
label values mainoccupation_HH moc
tab mainoccupation_HH year, m
egen nbsource=rowtotal(source_1 source_2 source_3 source_4 source_5 source_6 source_7)
save"$directory\_temp\panel_hhmoc.dta", replace
use"$directory\_temp\panel_v1.dta", clear
merge 1:1 HHID year using "$directory\_temp\panel_hhmoc.dta"
drop _merge
tab mainoccupation_HH, gen(mainoccupation_HH)
save"$directory\_temp\panel_v1.dta", replace
****************************************
* END




****************************************
* EGO CLEANING
****************************************
use"$directory\_temp\Panel_occupations_mainjob_balanced.dta", clear
keep HHID year sex age INDID HHID2016 INDID2010 dummynewHH egoid egoid2 mainoccupation mainoccupincome1 relationshiptohead educcode _1_d_relation
egen HHINDID=concat(HHID INDID), p(/)
bysort HHINDID : egen egoid_new=max(egoid)
keep if egoid_new!=0
drop if egoid_new==.
drop if dummynewHH==1
duplicates tag HHID INDID year, gen(tag)
tab tag
sort tag HHID INDID year
drop if tag==1 & mainoccupation==.
drop tag
duplicates tag HHID INDID year, gen(tag)
sort tag HHID INDID year
drop if mainoccupation==2 & tag==1 & HHID!="PSNAT347"
drop tag
duplicates tag HHID INDID year, gen(tag)
sort tag HHID INDID year
drop if mainoccupation==3 & tag==1
drop tag
duplicates tag HHID INDID year, gen(tag)
sort tag HHID INDID year
drop if mainoccupation==7 & tag==1
drop tag
duplicates drop HHID INDID year, force
/*
2010
1	Head (father)
2	Wife
3	Mother
4	Father
5	Son
6	Daughter
7	Daughter-in-law
8	Son-in-law
9	Sister
10	Mother-in-law
11	Father-in-law
12	Brother older
13	Brother younger
14	grand children
15	Nobody
66	Irrelevant
77	Other
88	Don't know
99	No response

2016
1	Head
2	Wife
3	Mother
4	Father
5	Son
6	Daughter
7	Son-in-law
8	Daughter-in	law
9	Sister
10	Brother
11	Mother-in-law
12	Father-in-law
13	Grandchild
16	Grandmother
17	Cousin
77	Other
*/
replace relationshiptohead=1 if _1_d_relation==1
replace relationshiptohead=2 if _1_d_relation==2
replace relationshiptohead=3 if _1_d_relation==3
replace relationshiptohead=4 if _1_d_relation==4
replace relationshiptohead=5 if _1_d_relation==5
replace relationshiptohead=6 if _1_d_relation==6
replace relationshiptohead=7 if _1_d_relation==8
replace relationshiptohead=8 if _1_d_relation==7
replace relationshiptohead=9 if _1_d_relation==9
replace relationshiptohead=10 if _1_d_relation==12
replace relationshiptohead=10 if _1_d_relation==13
replace relationshiptohead=11 if _1_d_relation==10
replace relationshiptohead=12 if _1_d_relation==11
replace relationshiptohead=13 if _1_d_relation==14
replace relationshiptohead=77 if _1_d_relation==77
drop HHID2016 INDID2010 dummynewHH egoid egoid2 _1_d_relation
rename mainoccupincome1 mainoccupincome

preserve
keep if year==2010
drop year
reshape wide HHINDID INDID sex age mainoccupation mainoccupincome educcode relationshiptohead,i(HHID) j(egoid_new)
nmissing mainoccupation1 mainoccupincome1
gen nmiss=1 if mainoccupation1==. & mainoccupincome1==.
tab nmiss
list HHID if nmiss==1
rename HHINDID1 HHINDID
*Puis je regarde mainocc et mainincome pour eux avec la base occupation rume
replace mainoccupincome1=0 if HHINDID=="ADGP198/4"
replace mainoccupincome1=84000 if HHINDID=="ADSEM117/1"
replace mainoccupincome1=0 if HHINDID=="ANDMTP322/2"
replace mainoccupincome1=12000 if HHINDID=="ANDNAT369/1"
replace mainoccupincome1=0 if HHINDID=="ANTGP162/3"
replace mainoccupincome1=0 if HHINDID=="ANTGP163/3"
replace mainoccupincome1=0 if HHINDID=="ANTGP238/1"
replace mainoccupincome1=20000 if HHINDID=="PSGP183/1"
replace mainoccupincome1=0 if HHINDID=="PSMTP307/3"
replace mainoccupincome1=0 if HHINDID=="PSNAT345/1"
replace mainoccupincome1=30000 if HHINDID=="RAGP173/1"
replace mainoccupincome1=33000 if HHINDID=="RAMPO25/1"
replace mainoccupincome1=120000 if HHINDID=="RAMTP302/1"
replace mainoccupincome1=30000 if HHINDID=="RAOR382/1"
replace mainoccupincome1=15000 if HHINDID=="RAOR383/1"
replace mainoccupincome1=40000 if HHINDID=="SIEP64/1"
replace mainoccupincome1=36000 if HHINDID=="SIGP185/1"
replace mainoccupincome1=0 if HHINDID=="SIGP192/3"
replace mainoccupincome1=10800 if HHINDID=="SINAT335/1"
replace mainoccupincome1=80000 if HHINDID=="SIOR372/1"
replace mainoccupincome1=36000 if HHINDID=="SIOR375/1"
replace mainoccupincome1=0 if HHINDID=="SISEM104/2"
replace mainoccupincome1=30000 if HHINDID=="VENKU244/1"
replace mainoccupincome1=0 if HHINDID=="VENMTP315/2"
replace mainoccupincome1=40000 if HHINDID=="VENOR391/1"
replace mainoccupation1=8 if HHINDID=="ADGP198/4"
replace mainoccupation1=9 if HHINDID=="ADSEM117/1"
replace mainoccupation1=8 if HHINDID=="ANDMTP322/2"
replace mainoccupation1=2 if HHINDID=="ANDNAT369/1"
replace mainoccupation1=8 if HHINDID=="ANTGP162/3"
replace mainoccupation1=8 if HHINDID=="ANTGP163/3"
replace mainoccupation1=8 if HHINDID=="ANTGP238/1"
replace mainoccupation1=10 if HHINDID=="PSGP183/1"
replace mainoccupation1=8 if HHINDID=="PSMTP307/3"
replace mainoccupation1=8 if HHINDID=="PSNAT345/1"
replace mainoccupation1=10 if HHINDID=="RAGP173/1"
replace mainoccupation1=45 if HHINDID=="RAMPO25/1"
replace mainoccupation1=45 if HHINDID=="RAMTP302/1"
replace mainoccupation1=3 if HHINDID=="RAOR382/1"
replace mainoccupation1=10 if HHINDID=="RAOR383/1"
replace mainoccupation1=3 if HHINDID=="SIEP64/1"
replace mainoccupation1=10 if HHINDID=="SIGP185/1"
replace mainoccupation1=8 if HHINDID=="SIGP192/3"
replace mainoccupation1=3 if HHINDID=="SINAT335/1"
replace mainoccupation1=10 if HHINDID=="SIOR372/1"
replace mainoccupation1=10 if HHINDID=="SIOR375/1"
replace mainoccupation1=8 if HHINDID=="SISEM104/2"
replace mainoccupation1=6 if HHINDID=="VENKU244/1"
replace mainoccupation1=8 if HHINDID=="VENMTP315/2"
replace mainoccupation1=1 if HHINDID=="VENOR391/1"
sort sex1 HHID
save"$directory\_temp\identifego2010.dta", replace
restore

preserve
keep if year==2016
drop year INDID 
rename HHINDID test
reshape wide sex age test mainoccupation mainoccupincome educcode relationshiptohead,i(HHID) j(egoid_new)
save"$directory\_temp\identifego2016.dta", replace
restore

save"$directory\_temp\Panel_modif_ego.dta", replace
*APPEND
use"$directory\_temp\identifego2010.dta", clear
gen year=2010
append using "$directory\_temp\identifego2016.dta"
recode year (.=2016)
tab sex1 year
merge 1:1 HHID year using "$directory\_temp\panel_v1.dta"
drop _merge
save"$directory\analysis\panel_v1.dta", replace
*EDUCATION
tab educcode1 year
*À partir des codes de Anne, je récupère l'éducation que j'applique pour 2010 et 2016 parce qu'elle est fausse là ici.
*use "NEEMSIS1\_temp\NEEMSIS-EGO_clean.dta" 
*keep if egoid==1 | egoid==2
*keep if dummynewHH==0
*keep parent_key egoid dummynewHH edulevel
*reshape wide edulevel, i(parent_key) j(egoid)
*save "$directory\_temp\panel_educ", replace
use"$directory\analysis\panel_v1.dta", clear
drop educcode*
merge m:1 parent_key using "$directory\_temp\panel_educ.dta"
drop _merge
bysort HHID (parent_key) : replace parent_key = parent_key[_N]
bysort HHID : egen educcode1=max(edulevel1)
bysort HHID : egen educcode2=max(edulevel2)
drop edulevel*
label define education 0"\hspace*{0.2cm} Below primary" 1"\hspace*{0.2cm} Primary completed" 2"\hspace*{0.2cm} High School" 3"\hspace*{0.2cm} HSC/Diploma" 4"\hspace*{0.2cm} Bachelors" 5"\hspace*{0.2cm} Post graduate"
label values educcode1 education
label values educcode2 education
save"$directory\analysis\panel_v2.dta", replace
****************************************
* END



****************************************
* BALANCED
****************************************
use"$directory\analysis\panel_v2.dta", clear
bysort HHID: gen nyear=[_N]
tab nyear
keep if nyear==2
drop nyear
save"$directory\analysis\panel_v2.dta", replace
use"$directory\analysis\panel_v2.dta", clear
*Retrouver education des ego ?
list parent_key if educcode1==. & year==2016
/*
uuid:ceb95ee7-8136-459e-b89c-32eaddf824a2
*/
sort sex1
list *1 if parent_key=="uuid:ceb95ee7-8136-459e-b89c-32eaddf824a2"
list parent_key if educcode1==.
save"$directory\analysis\panel_v2.dta", replace
****************************************
* END






****************************************
* PANEL CLEANING
****************************************
use"$directory\analysis\panel_v2.dta", clear
*HOUSING
tab1 house howbuyhouse rentalhouse housevalue housetype housesize houseroom housetitle
tab house
gen ownhouse=house
replace ownhouse=0 if house==2 | house==3 | house==4 | house==77
tab ownhouse
replace houseroom=7 if houseroom>=7
*PERSONALITY
forvalues i=1(1)2{
foreach x in EGOcrOP`i' EGOcrCO`i' EGOcrEX`i' EGOcrAG`i' EGOcrES`i' EGOcrGrit`i' EGOraven`i' EGOlit`i' EGOnum`i' {
bysort HHID : egen `x'_new=max(`x')
drop `x'
rename `x'_new `x'
} 
}
*NET OF LIFE CYCLE EVENTS
forvalues i=1(1)2{
foreach x in EGOcrOP`i' EGOcrCO`i' EGOcrEX`i' EGOcrAG`i' EGOcrES`i' EGOcrGrit`i' EGOraven`i' EGOlit`i' EGOnum`i' {
qui reg `x' age`i'
predict `x'_r, resid
egen `x'_r_std=std(`x'_r)
drop `x'_r
}
}
*Nyhus and Pons (2005), Heineck and Anger (2010) and Heineck (2011) + Brown et Taylor 2014 :  However,  as  Heineck  and  Anger (2010, p. 540) state, this approach is “far from perfect”. 
*ssc install fsum  
fsum EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOcrGrit1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std
*PROBLEM with HHID=ADGP197
*Maybe i can drop if..
gen ADGP197=1 if HHID=="ADGP197"
recode ADGP197 (.=0)
*MAIN OCCUPATION
tab mainoccupation1
list parent_key if mainoccupation1==. & year==2016
replace mainoccupation1=5 if parent_key=="uuid:4a71a117-e7af-4f8d-875d-5a3af05b5694" & year==2016  // construction supervisor en full time salaried job avec un bachelor
replace mainoccupation1=77 if mainoccupation1==. & year==2016
tab mainoccupation1 year, col
tab educcode1 HHID if mainoccupation1==45
gen mainoccupation1rec=mainoccupation1
recode mainoccupation1rec (45=5)
tab mainoccupation1rec year, col
replace mainoccupation1rec=7 if mainoccupation1rec>=7
tab mainoccupation1rec year, col
recode mainoccupation1rec (5=4)  // regular
recode mainoccupation1rec (6=5)
recode mainoccupation1rec (7=6)
tab mainoccupation1rec year, col nofreq
label define mainoccupation1rec 1"\hspace*{0.2cm} Agri. SE" 2"\hspace*{0.2cm} Agri. casual" 3"\hspace*{0.2cm} Non-agri. casual" 4"\hspace*{0.2cm} Non-agri. regular" 5"\hspace*{0.2cm} Non-agri. SE" 6"\hspace*{0.2cm} Other"
label values mainoccupation1rec mainoccupation1rec
tab mainoccupation1rec, gen(mainoccupation1rec)
gen mainoccupation2rec=mainoccupation2
recode mainoccupation2rec (45=5)
tab mainoccupation2rec year, col
replace mainoccupation2rec=7 if mainoccupation2rec>=7
tab mainoccupation2rec year, col
recode mainoccupation2rec (5=4)  // regular
recode mainoccupation2rec (6=5)
recode mainoccupation2rec (7=6)
tab mainoccupation2rec year, col nofreq
label values mainoccupation2rec mainoccupation1rec
tab mainoccupation2rec, gen(mainoccupation2rec)
*DEPENDENCY RATIO
gen dep_ratio=nonactiveHHmb/activeHHmb
list HHID year nonactiveHHmb activeHHmb nbHHmb if dep_ratio==.
replace dep_ratio=2 if HHID=="ANDNAT368" & year==2016  // pour le garder
gen dep_ratio_cat=.
replace dep_ratio_cat=1 if activeHHmb>nonactiveHHmb
replace dep_ratio_cat=2 if activeHHmb==nonactiveHHmb
replace dep_ratio_cat=3 if activeHHmb<nonactiveHHmb
label define dep_ratio_cat 1"\hspace*{0.2cm} More active" 2"\hspace*{0.2cm} Same nb." 3"\hspace*{0.2cm} More inact."
label values dep_ratio_cat dep_ratio_cat
tab dep_ratio_cat, gen(dep_ratio_cat)
*DEFLATOR
replace assets_NS=50000+800+500 if HHID=="RAMTP305" & year==2010  // house value + farm equip + cattle
foreach x in assets_NS annualincome_HH mainoccupincome1{
gen `x'DEF=`x'
replace `x'DEF=`x'*0.918905 if year==2016
}
*ssc install nmissing
nmissing mainoccupincome1
sort mainoccupincome1 mainoccupation1
sort mainoccupincome1 HHID
*LAND 
drop dummyeverhadland ownland land_own
recode sizeownland_acre (.=0)
tabstat sizeownland_acre, stat(n mean) by(year)
tab dummyownland year
*SEX RATIO
gen sex_ratio=nbmale/nbfemale
list HHID year nbmale nbfemale if sex_ratio==.
replace sex_ratio=2 if year==2016 & HHID=="SIGP186"
replace sex_ratio=3 if year==2010 & HHID=="VENGP166"
replace sex_ratio=2 if year==2016 & HHID=="RAMPO25"
gen sex_ratio_cat=.
replace sex_ratio_cat=1 if nbfemale>nbmale
replace sex_ratio_cat=2 if nbfemale==nbmale
replace sex_ratio_cat=3 if nbfemale<nbmale
label define sex_ratio_cat 1"\hspace*{0.2cm} More female" 2"\hspace*{0.2cm} Same nb." 3"\hspace*{0.2cm} More male"
label values sex_ratio_cat sex_ratio_cat
tab sex_ratio_cat, gen(sex_ratio_cat)
*CASTE GROUP
gen _caste=caste_group if year==2016
bysort HHID : egen _caste_group=max(_caste)
drop caste_group
drop _caste
rename _caste_group caste_group
tab caste_group, gen(caste_group)
*label variable imp1_debt_burden "Debt serv. r. (i)"
*label variable imp1_interest_burden "Int. serv. r. (i)"
*MARIAGE
merge 1:1 HHID year using "$directory\_temp\marriage.dta"
drop if _merge==2
drop _merge
bysort HHID: egen marriage=max(dummymarriage_HH)
gen dummymar=marriage
replace dummymar=1 if dummymar==2
replace dummymar=0 if year==2010
tab dummymar year
bysort HHID : egen dummymar_mean=mean(dummymar)
*EDUCATION
gen edulevel1=educcode1
replace edulevel1=3 if edulevel1>=3
tab edulevel1
tab edulevel1, gen(edulevel_ego1_)

gen edulevel2=educcode2
replace edulevel2=3 if edulevel2>=3
tab edulevel2
tab edulevel2, gen(edulevel_ego2_)


*1000 VARIABLES
drop assets_NS assets_NS_DEF1000
gen assets_NSDEF1000=assets_NSDEF/1000
gen annualincome_HHDEF1000=annualincome_HHDEF/1000
drop assets_NSDEF annualincome_HHDEF
*RELATIONSHIPTOHEAD
tab relationshiptohead1 year, col nofreq
/*
Les heads augmentent, tandis que les son diminuent : des fils devenus chefs de famille
Wife diminue et mother augmentent : les femmes sont devenus les mères
*/
gen relation1=1 if relationshiptohead1==1
replace relation1=2 if relationshiptohead1==2
replace relation1=77 if relationshiptohead1>=3
tab relation1 year, col nofreq
label define relation 1"\hspace*{0.2cm} Head" 2"\hspace*{0.2cm} Wife" 77"\hspace*{0.2cm} Other"
label values relation1 relation
tab relation1, gen(relation1_)
gen relation2=1 if relationshiptohead2==1
replace relation2=2 if relationshiptohead2==2
replace relation2=77 if relationshiptohead2>=3
tab relation2 year, col nofreq
label values relation2 relation
tab relation2, gen(relation2_)
save"$directory\analysis\panel_v3.dta", replace
****************************************
* END 



****************************************
* MEAN OVER TIME
****************************************
use"$directory\analysis\panel_v3.dta", clear
foreach x in mainoccupation1rec1 mainoccupation1rec2 mainoccupation1rec3 mainoccupation1rec4 mainoccupation1rec5 mainoccupation1rec6 ownhouse assets_NSDEF1000 annualincome_HHDEF1000 age1 age2 mainoccupincome1DEF dep_ratio sizeownland_acre dummyownland sex_ratio houseroom nbHHmb relation1_1 relation1_2 relation1_3 mainoccupation_HH1 mainoccupation_HH2 mainoccupation_HH3 mainoccupation_HH4 mainoccupation_HH5 mainoccupation_HH6 mainoccupation_HH7 dep_ratio_cat1 dep_ratio_cat2 dep_ratio_cat3 sex_ratio_cat1 sex_ratio_cat2 sex_ratio_cat3 mainoccupation2rec1 mainoccupation2rec2 mainoccupation2rec3 mainoccupation2rec4 mainoccupation2rec5 mainoccupation2rec6 relation2_1 relation2_2 relation2_3 nbsource{
bysort HHID : egen `x'_mean=mean(`x')
}
fsum *_mean if year==2010
nmissing *_mean // mainoccupation
save"$directory\analysis\panel_v4.dta", replace
****************************************
* END 



****************************************
* IMPUTATIONS ELENA
****************************************
*DS 2016 IMPUTATION ELENA
use"$directory\analysis\panel_v4.dta", clear
merge 1:m parent_key year using "$directory\_temp\NEEMSIS_imputation_Elena.dta"
drop if _merge==2
rename _merge _elena2016
*DS 2010 IMPUTATION ELENA
merge 1:1 HHID year using "$directory\_temp\RUME_imputation_Elena.dta"
drop if _merge==2
rename _merge _elena2010
*ONE VAR
gen imp1_ds_tot=.
replace imp1_ds_tot=imp1_ds_tot_2010 if year==2010
replace imp1_ds_tot=imp1_ds_tot_2016 if year==2016
gen imp1_is_tot=.
replace imp1_is_tot=imp1_is_tot_2010 if year==2010
replace imp1_is_tot=imp1_is_tot_2016 if year==2016
*BURDEN
gen imp1_debt_burden=imp1_ds_tot/annualincome_HH
gen imp1_interest_burden=imp1_is_tot/annualincome_HH
recode imp1_debt_burden(.=0)
recode imp1_interest_burden(.=0)
tabstat imp1_debt_burden imp1_interest_burden, stat(n mean sd q min max) by(year)
*DUMMY
gen 	imp1_debt_bin=1 if imp1_debt_burden>=0.4
replace imp1_debt_bin=0 if imp1_debt_burden<0.4
gen 	imp1_interest_bin=1 if imp1_interest_burden>=0.2
replace imp1_interest_bin=0 if imp1_interest_burden<0.2
tabstat imp1_debt_burden imp1_interest_burden, stat(n mean sd p50 min max) by(year)
tab imp1_debt_bin year, row nofreq
tab dsr_HH_bin year, row nofreq
tab imp1_interest_bin year, row nofreq
tab isr_HH_bin year, row nofreq
save"$directory\analysis\panel_v5.dta", replace
****************************************
* END 




****************************************
* ADD NB OF CHILD (-16y), demo, (appel Jalil 11/12/2020)
****************************************
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
use"$directory\_temp\nbchild2010", clear
append using "$directory\_temp\nbchild2016.dta"
save"$directory\_temp\panel_nbchild.dta", replace
use"$directory\analysis\panel_v5.dta", clear
merge 1:m HHID year using "$directory\_temp\panel_nbchild.dta"
drop if _merge==2
drop _merge
bysort HHID : egen nbchild_mean=mean(nbCHILD)
bysort HHID : egen dummydemonetisation_mean=mean(dummydemonetisation)
recode dummydemonetisation (.=0)
encode HHID, gen(panelvar)
*AGE
gen age1sq=age1*age1
gen age2sq=age2*age2
bysort HHID : egen age1sq_mean=mean(age1sq)
bysort HHID : egen age2sq_mean=mean(age2sq)
*LOG
gen log_nbHHmb=log(nbHHmb)
gen log_assets_NSDEF1000=log(assets_NSDEF1000)
gen log_annualincome_HHDEF1000=log(annualincome_HHDEF1000)
*GENDER
replace sex1=0 if sex1==1
replace sex1=1 if sex1==2
replace sex2=0 if sex2==1
replace sex2=1 if sex2==2
label define sexb 0"Male" 1"Female (=1)"
label values sex1 sexb
label values sex2 sexb
*VILLAGES
tab villageid, gen(villageid)
*PB
*recode pb(.=0)
save"$directory\analysis\panel_v6.dta", replace
****************************************
* END 




****************************************
* LABELING
****************************************
use"$directory\analysis\panel_v6.dta", clear
sort HHID year
gen year2016=1 if year==2016
replace year2016=0 if year==2010

label variable assets_NSDEF1000 "\hspace*{0.2cm} Assets$\ssymbol{2}$"
label variable dummyownland "\hspace*{0.2cm} Land$\ssymbol{3}$ (=1)"
label variable sizeownland_acre "\hspace*{0.2cm} Size own land"
label variable sex_ratio "\hspace*{0.2cm} Sex ratio"
label variable ownhouse "\hspace*{0.2cm} House$\ssymbol{3}$ (=1)"
label variable annualincome_HHDEF1000 "\hspace*{0.2cm} Income$\ssymbol{2}$"
label variable dep_ratio "\hspace*{0.2cm} Dependency ratio"
label variable nbHHmb "\hspace*{0.2cm} Household size"
label variable dummymar "\hspace*{0.2cm} Marriage (=1)"
label variable dummydemonetisation "\hspace*{0.2cm} Demonetisation (=1)"
label variable nbCHILD "\hspace*{0.2cm} Nb. children"
label variable mainoccupation_HH7 "\hspace*{0.2cm} NREGA"
label variable EGOcrOP1_r_std "\hspace*{0.2cm} Openn."
label variable EGOcrCO1_r_std "\hspace*{0.2cm} Consc."
label variable EGOcrEX1_r_std "\hspace*{0.2cm} Extra."
label variable EGOcrAG1_r_std "\hspace*{0.2cm} Agree."
label variable EGOcrES1_r_std "\hspace*{0.2cm} Em. stab."
label variable EGOcrGrit1_r_std "\hspace*{0.2cm} Grit"
label variable EGOraven1_r_std "\hspace*{0.2cm} Raven"
label variable EGOlit1_r_std "\hspace*{0.2cm} Literacy"
label variable EGOnum1_r_std "\hspace*{0.2cm} Numeracy"
label variable age1 "\hspace*{0.2cm} Age"
label variable age1sq "\hspace*{0.2cm} Age square"
label variable sex1 "\hspace*{0.2cm} Female (=1)"

label variable imp1_debt_burden "DSR"
label variable imp1_interest_burden "ISR"
label variable dar_HH "DAR"
label variable dir_HH "DIR"
label variable ilr_amount_HH "ILR"
label variable niglr_amount_HH "NIGLR"
label variable prl_amount_HH "PRLR"
label variable hslr_amount_HH "HSLR"
label variable nbloan_HH "Nb. tot. loan"



label variable mainoccupation_HH1 "\hspace*{0.2cm} HH: Agri SE"
label variable mainoccupation_HH2 "\hspace*{0.2cm} HH: Agri cas"
label variable mainoccupation_HH3 "\hspace*{0.2cm} HH: N-agri cas"
label variable mainoccupation_HH4 "\hspace*{0.2cm} HH: N-agri reg n-quali"
label variable mainoccupation_HH5 "\hspace*{0.2cm} HH: N-agri reg quali"
label variable mainoccupation_HH6 "\hspace*{0.2cm} HH: N-agri SE"
label variable mainoccupation_HH7 "\hspace*{0.2cm} HH: NREGA"


label variable dep_ratio_cat1 "\hspace*{0.2cm} CW: More active"
label variable dep_ratio_cat2 "\hspace*{0.2cm} CW: Same nb"
label variable dep_ratio_cat3 "\hspace*{0.2cm} CW: More inact"

label variable caste_group1 "\hspace*{0.2cm} Caste: Dalit"
label variable caste_group2 "\hspace*{0.2cm} Caste: Middle"
label variable caste_group3 "\hspace*{0.2cm} Caste: Upper"

label variable mainoccupation1rec1 "\hspace*{0.2cm} Ind: Agri SE"
label variable mainoccupation1rec2 "\hspace*{0.2cm} Ind: Agri cas"
label variable mainoccupation1rec3 "\hspace*{0.2cm} Ind: N-agri cas"
label variable mainoccupation1rec4 "\hspace*{0.2cm} Ind: N-agri reg."
label variable mainoccupation1rec5 "\hspace*{0.2cm} Ind: N-agri SE"
label variable mainoccupation1rec6 "\hspace*{0.2cm} Ind: Other"

label variable sex_ratio_cat1 "\hspace*{0.2cm} CG: More female"
label variable sex_ratio_cat2 "\hspace*{0.2cm} CG: Same nb."
label variable sex_ratio_cat3 "\hspace*{0.2cm} CG: More male"

label variable edulevel_ego1_1 "\hspace*{0.2cm} Edu: No edu."
label variable edulevel_ego1_2 "\hspace*{0.2cm} Edu: Prim."
label variable edulevel_ego1_3 "\hspace*{0.2cm} Edu: High sch."
label variable edulevel_ego1_4 "\hspace*{0.2cm} Edu: Sec. or more"

label variable relation1_1 "\hspace*{0.2cm} Rel.: Head"
label variable relation1_2 "\hspace*{0.2cm} Rel.: Wife"
label variable relation1_3 "\hspace*{0.2cm} Rel.: Other"

save"$directory\analysis\panel_v7.dta", replace
****************************************
* END 



****************************************
* AJOUT NEW Y
****************************************
use"$directory\analysis\panel_v7.dta", clear

global yhh imp1_debt_burden imp1_interest_burden dar_HH dir_HH ilr_amount_HH niglr_amount_HH hslr_amount_HH prl_amount_HH imp1_ds_tot imp1_is_tot loanamount_HH nbloan_HH 

*A mettre dans cleaning
recode $yhh (.=0)
gen loanamount_HHDEF1000=.
gen imp1_ds_totDEF1000=.
gen imp1_is_totDEF1000=.
*
foreach x in loanamount_HH imp1_ds_tot imp1_is_tot {
replace `x'DEF1000=(`x'*0.918905)/1000 if year==2016
replace `x'DEF1000=`x'/1000 if year==2010
}
*
label variable imp1_ds_totDEF1000 	"DS$\ssymbol{2}$"
label variable imp1_is_totDEF1000 	"IS$\ssymbol{2}$"
label variable loanamount_HHDEF1000 "Tot. loan$\ssymbol{2}$"
*
gen year2010=1 if year==2010
replace year2010=0 if year==2016
*
replace imp1_debt_burden=0 if imp1_debt_burden<0
replace imp1_interest_burden=0 if imp1_interest_burden<0 
save"$directory\analysis\panel_v8.dta", replace
****************************************
* END 










****************************************
* FACTOR ANALYSIS FOR BIG FIVE
****************************************
use "$directory\_temp\NEEMSIS-ego.dta", clear
/*
global big5questions ///
curious interested~t   repetitive~s inventive liketothink newideas activeimag~n ///
organized  makeplans workhard appointmen~e putoffduties easilydist~d completedu~s ///
enjoypeople sharefeeli~s shywithpeo~e  enthusiastic  talktomany~e  talkative expressing~s ///
workwithot~r   understand~g trustingof~r rudetoother toleratefa~s  forgiveother  helpfulwit~s ///
managestress  nervous  changemood feeldepres~d easilyupset worryalot  staycalm 
**Acqui bias correction: 
*These are the pairs 
local varlist ///
rudetoother helpfulwit~s  ///
putoffduties 	completedut~s /// 
easilydistracted makeplans  ///
shywithpeople talktomany~e ///
repetitive~s curious  ///
nervous staycalm ///  
worryalot managestress 

egen ars = rowmean(`varlist') 
gen ars2 = ars-3 //how far away from acqui score are you. 

sum ars 
ta demo, sum(ars)

ttest ars = 3 

*recode reversely coded items 
foreach var of varlist rudetoother putoffduties easilydistracted shywithpeople repetitive~s nervous changemood feeldepres easilyupset worryalot {	
	gen raw_`var' = `var' 
	recode `var' (5=1) (4=2) (3=3) (2=4) (1=5)
	}
	
	*corrected items: 
foreach var of varlist $big5questions  {
	gen cr_`var' = `var' - ars2 if ars != . 
}
*/

global big5 ///
cr_curious cr_interestedbyart   cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination ///
cr_organized  cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties ///
cr_enjoypeople cr_sharefeelings cr_shywithpeople  cr_enthusiastic  cr_talktomanypeople  cr_talkative cr_expressingthoughts  ///
cr_workwithother  cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults  cr_forgiveother  cr_helpfulwithothers ///
cr_managestress  cr_nervous  cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot  cr_staycalm



/*
sort parent_key egoid
keep $big5
export delimited using "$directory\_temp\pcaR.csv", replace
*/

/*
**Deal with missings : use https://stats.idre.ucla.edu/stat/data/fa_missing
count  /* count total number of observations */
corr $big5, cov  /* complete case covariance matrix */
/*
Sur les 953, il y en a seulement 889 de complet
Il y a des manquants sur toutes les variables, et c'est manage stress qui a le plus de manquants : 929 répondants sur les 953 soit 24 missings
*/
mi set mlong
mi register imputed $big5  // il y a 64 HH qui sautent en tout
mi impute mvn $big5, emonly // et 130 missings
dis r(M)
matrix cov_em = r(Sigma_em)
matrix list cov_em
factormat cov_em, n(953) fa(5) pcf  // n() le nb d'obs associé à la var qui a le plus de miss, ici c'est manage stress
rotate, promax
*Imput to indiv
qui predict f1 f2 f3 f4 f5
global factorimput f1 f2 f3 f4 f5  
*Interpretation of axis
pwcorr $factorimput $big5, star(.01)
fsum $factorimput
*/
**************Et si je remplace juste pour les moyennes ?
gen nmiss=0
foreach x in $big5{
replace nmiss=nmiss+1 if `x'==.
}
tab nmiss
/*
Between one and three
54
Between four and seven
+7
More than seven
+2
Outlier
+1
*/

foreach x in $big5{
gen im`x'=`x'
}
global big5i imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother ///
imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm
*Imputation par la moyenne du sexe car assez grande différence entre les deux
forvalues i=1(1)2{
foreach x in $big5i{
sum `x' if sex==`i'
replace `x'=r(mean) if `x'==. & sex==`i'
}
}

*preserve
keep if nmiss<=35
factor $big5i, pcf fa(5)
rotate, promax 
*screeplot, neigen(10) yline(1) ylabel(1[1]10) xlabel(1[1]10) 
*loadingplot, legend(off) xline(0) yline(0) scale(.8)
*scoreplot
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput4)
*putexcel (E2) = matrix( e(r_L) ) 
predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5
sum $factor
sum $big5, sep(50)
sum $big5i, sep(50)
global naivebig5 EGOcrOP EGOcrEX EGOcrES EGOcrCO EGOcrAG
pwcorr $factor $big5i, star(.001)
pwcorr $naivebig5 $factor, star(.01)
*restore

rename f1 new_CO
rename f2 new_ES
rename f3 new_OPEX
rename f4 new_ESCO
rename f5 new_AG






*********************************POST ESTIMATION

*Cronbach's alpha for new categorization
*CO -> 0.8861
alpha imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults ///
imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm
*ES -> 0.8861
alpha imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_shywithpeople imcr_enthusiastic imcr_expressingthoughts ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother ///
imcr_helpfulwithothers imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm
*OPEX -> 0.8224
alpha imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties ///
imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts ///
imcr_understandotherfeeling imcr_toleratefaults imcr_forgiveother ///
imcr_managestress imcr_feeldepressed imcr_staycalm
*ESCO -> 0.8615
alpha imcr_interestedbyart imcr_repetitivetasks imcr_liketothink imcr_newideas ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_talkative imcr_expressingthoughts ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults ///
imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_staycalm
*AG -> 0.8733
alpha imcr_curious imcr_interestedbyart imcr_inventive imcr_newideas imcr_activeimagination ///
imcr_makeplans imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother ///
imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm


*En version plus soft
*60 CO -> 0.85
alpha imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_workhard imcr_organized imcr_putoffduties
*60 ES -> 0.90
alpha imcr_nervous imcr_easilyupset imcr_feeldepressed imcr_worryalot imcr_easilydistracted imcr_changemood imcr_shywithpeople
*60 OPEX -> 0.85
alpha imcr_liketothink imcr_activeimagination imcr_expressingthoughts imcr_sharefeelings imcr_newidea imcr_inventive imcr_curious
*50 ESCO -> 0.79
alpha imcr_staycalm imcr_changemood imcr_managestress imcr_easilydistracted imcr_putoffduties
*40 AG -> 0.67
alpha imcr_toleratefaults imcr_forgiveother imcr_trustingofother imcr_rudetoother imcr_enjoypeople



*NET OF LIFE CYCLE EVENTS
foreach x in new_CO new_ES new_OPEX new_ESCO new_AG EGOcrOP EGOcrCO EGOcrEX EGOcrAG EGOcrES EGOraven EGOlit EGOnum {
qui reg `x' age
predict `x'_r, resid
egen `x'_r_std=std(`x'_r)
drop `x'_r
}


global ego1new new_CO_r_std new_ES_r_std new_OPEX_r_std new_ESCO_r_std new_AG_r_std
global ego1 EGOcrOP_r_std EGOcrCO_r_std EGOcrEX_r_std EGOcrAG_r_std EGOcrES_r_std

sum $ego1 $ego1new, sep(5)


pwcorr $ego1new $ego1, star(.01)
/*
graph drop _all
set graph off
foreach x in $ego1new{
kdensity `x' if sex==1, bwidth(0.3) plot(kdensity `x' if sex==2, bwidth(0.3)) title ("") note("") legend(ring(0) pos(2) label(1 "Male") label(2 "Female")) name(k_`x', replace)
}
graph dir 
set graph on
grc1leg k_EGOlit_r_std k_EGOnum_r_std k_EGOraven_r_std k_new_CO_r_std k_new_OPEX_r_std k_new_ESCO_r_std k_new_AG_r_std k_new_ES_r_std, leg(k_new_ESCO_r_std) pos(3)
*/

keep parent_key egoid new_CO_r_std new_ES_r_std new_OPEX_r_std new_ESCO_r_std new_AG_r_std 
reshape wide new_CO_r_std new_ES_r_std new_OPEX_r_std new_ESCO_r_std new_AG_r_std, i(parent_key) j(egoid)
save "$directory\_temp\NEEMSIS_newFFM.dta", replace
***************************************************
use"$directory\analysis\panel_v8.dta", clear
merge m:1 parent_key using "$directory\_temp\NEEMSIS_newFFM.dta"
drop if _merge==2
rename _merge merging_newFFM
label variable new_CO_r_std1 "CO?"
label variable new_ES_r_std1 "ES?"
label variable new_OPEX_r_std1 "OPEX?"
label variable new_ESCO_r_std1 "ESCO?"
label variable new_AG_r_std1 "AG?"
label variable new_CO_r_std2 "CO?"
label variable new_ES_r_std2 "ES?"
label variable new_OPEX_r_std2 "OPEX?"
label variable new_ESCO_r_std2 "ESCO?"
label variable new_AG_r_std2 "AG?"
save"$directory\analysis\panel_v9.dta", replace
****************************************
* END 







****************************************
* FACTOR ANALYSIS TEST FOR WEALTH/PRESTIGIOUS DICHOTOMY: mca MCA
****************************************
use"$directory\analysis\panel_v9.dta", clear
*land owner in 2010
gen _landowner2010=0
replace _landowner2010=1 if dummyownland==1 & year==2010
bysort HHID : egen landowner2010=max(_landowner2010)
drop _landowner2010
tab landowner2010 year
*wealth level far assets and income
xtile _income_mca=annualincome_HHDEF1000 if year==2010, nq(4)
xtile _assets_mca=assets_NSDEF1000 if year==2010, nq(4)
bysort HHID: egen income_mca=max(_income_mca)
bysort HHID: egen assets_mca=max(_assets_mca)
tab income_mca year
tab assets_mca year
*label
label define land 0"No land" 1"Land owner"
label values landowner2010 land
label values dummyownland land
label define casta 1"Dalits" 2"Middle" 3"Upper"
label values caste_group casta
label define mocc 0"Unoccupied working age individuals" 1"Agri. SE" 2"Agri. casual" 3"Non-agri. casual" 4"Non-agri. regular non" 5"Non-agri. regular quali." 6"Non-agri. SE" 7"NREGA"
label values mainoccupation_HH mocc
label define qassa 1"Q1-Assets" 2"Q2-Assets" 3"Q3-Assets" 4"Q4-Assets"
label define qinca 1"Q1-Income" 2"Q2-Income" 3"Q3-Income" 4"Q4-Income"
label values income_mca qinca
label values assets_mca qassa
global pcatest mainoccupation_HH1 mainoccupation_HH2 mainoccupation_HH3 mainoccupation_HH4 mainoccupation_HH5 mainoccupation_HH6 mainoccupation_HH7 dummyownland_1 dummyownland_2 caste_group_1 caste_group_2 caste_group_3 income_mca_1 income_mca_2 income_mca_3 income_mca_4 assets_mca_1 assets_mca_2 assets_mca_3 assets_mca_4
*With caste
mca income_mca assets_mca caste_group mainoccupation_HH dummyownland, method (indicator) normal(princ)
mcacontrib
predict _f1 if year==2010
*pwcorr _f1 $pcatest if year==2010, star(.01)
bysort HHID: egen f1=max(_f1)
drop _f1 
gen efa_rich=1 if f1<0
replace efa_rich=0 if f1>0
tab efa_rich year
drop f1

*Without caste
mca income_mca assets_mca mainoccupation_HH dummyownland, method (indicator) normal(princ)
mcacontrib
predict _f1 if year==2010
bysort HHID: egen f1=max(_f1)
drop _f1 
gen efa_rich_nocaste=1 if f1>0
replace efa_rich_nocaste=0 if f1<0
tab efa_rich_nocaste year
tab efa_rich_nocaste efa_rich
drop f1


save"$directory\analysis\panel_v10.dta", replace
****************************************
* END






****************************************
* VERIF MISSING PANEL
****************************************
use"$directory\analysis\panel_v10.dta", clear
*VERIF EGO entre 2010 et 2016-17
sort sex1 year HHID
*10 ego ANTMP36 ANTOR399 PSKOR203 RAEP68 RAGP172 RAKOR208 RAKOR209 VENKOR223 sont absents en 2010
gen pb=.
foreach x in ADGP197 RAGP172 VENKOR223 RAEP68 RAKOR209 ANTOR399 RAKOR208 PSKOR203 ANTMP36 {
replace pb=1 if HHID=="`x'"
}
recode pb (.=0)
*Qui sont-ils en 2016 ?
list HHID parent_key INDID1 year sex1 age1 relationshiptohead1 mainoccupation1 edulevel1 caste_group if pb==1, clean

*Deux solutions. 
*1. J'inverse EGO 1 et EGO 2 car j'ai les renseignements pour EGO 2. 
*2. Je reconstitue age, sex education, personnalité de EGO 1 2010 puis je cherche à la main sa main occupation de 2010. Le souci vient du fait qu'en faisant ça, je crois qu'ils n'existent pas pour 2010.. donc je n'aurai pas de main occupation. Je vérifie quand même 

*VERIF SOLUTION 1
sort HHID year
list HHID INDID2 year sex2 age2 relationshiptohead2 mainoccupation2 edulevel2 caste_group if pb==1, clean
save"$directory\analysis\panel_v10.dta", replace
/*
*VERIF SOLUTION 2
*a. identifier le prénom et le INDID en 2016 pour regarder dans la base 2010
use "$directory\_temp\NEEMSIS-ego.dta", clear
keep if egoid==1
global pb uuid:a6097c43-dd3b-40d0-9d42-7350ecbd35ab uuid:709865ef-e61f-4030-bc45-01da6d7f912d uuid:7d58fca3-952b-44b7-93a4-b4a30e7b5b95 uuid:22697a91-f33b-4983-809b-c4cfd2041a6f uuid:fbe2328b-890f-4bcd-82a1-d033c9986aed uuid:af76f1c4-624b-4da6-a888-26ec666cd4ca uuid:ceb95ee7-8136-459e-b89c-32eaddf824a2 uuid:0bd2d8b2-5a95-4f16-b9cc-5414151710d1 uuid:813a12d2-a425-496e-9441-e3991adb8c30
gen prob=.
foreach x in $pb{
replace prob=1 if parent_key=="`x'"
}
list parent_key name if prob==1

*b. verif dans la base 2010
use"\RUME\_temp\RUME_familymembers.dta", clear
global pb ADGP197 ANTMP36 ANTOR399 PSKOR203 RAEP68 RAGP172 RAKOR208 RAKOR209 VENKOR223
gen prob=.
foreach x in $pb{
replace prob=1 if HHID=="`x'"
}
list HHID namenumber name relationshiptohead if prob==1, clean
*Ce sont des individus qui n'existent pas en 2010
****************************************
* END 
*/



****************************************
* CLEANING encore
****************************************
use"$directory\analysis\panel_v10.dta", clear

egen ego1miss=rowmiss(sex1 age1 relation1 edulevel1 mainoccupation1rec EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std)
egen ego2miss=rowmiss(sex2 age2 relation2 edulevel2 mainoccupation2rec EGOcrOP2_r_std EGOcrCO2_r_std EGOcrEX2_r_std EGOcrAG2_r_std EGOcrES2_r_std EGOraven2_r_std EGOlit2_r_std EGOnum2_r_std)

bysort HHID : egen _ego1miss=sum(ego1miss)
bysort HHID : egen _ego2miss=sum(ego2miss)


foreach x in ego1miss ego2miss {
replace _`x'=1 if _`x'>=1
drop `x'
rename _`x' `x'
}

global ego1 EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std
global ego1cont age1 age1sq sex1 mainoccupation1rec2 mainoccupation1rec3 mainoccupation1rec4 mainoccupation1rec5 mainoccupation1rec6 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 relation1_2 relation1_3
global ego1mean age1_mean age1sq_mean mainoccupation1rec2_mean mainoccupation1rec3_mean mainoccupation1rec4_mean mainoccupation1rec5_mean mainoccupation1rec6_mean relation1_2_mean relation1_3_mean

global ego2 EGOcrOP2_r_std EGOcrCO2_r_std EGOcrEX2_r_std EGOcrAG2_r_std EGOcrES2_r_std EGOraven2_r_std EGOlit2_r_std EGOnum2_r_std
global ego2cont age2 age2sq sex2 mainoccupation2rec2 mainoccupation2rec3 mainoccupation2rec4 mainoccupation2rec5 mainoccupation2rec6 edulevel_ego2_2 edulevel_ego2_3 edulevel_ego2_4 relation2_2 relation2_3
global ego2mean age2_mean age2sq_mean mainoccupation2rec2_mean mainoccupation2rec3_mean mainoccupation2rec4_mean mainoccupation2rec5_mean mainoccupation2rec6_mean relation2_2_mean relation2_3_mean

fsum $ego1 $ego1cont $ego1mean if ego1miss==0
fsum $ego2 $ego2cont $ego2mean if ego2miss==0

gen shock=dummymar+dummydemonetisation


*Median
*tabstat assets_NSDEF1000, stat(n p50) by(year)
egen assets_2016= median(assets_NSDEF1000) if year==2016
egen assets_2010= median(assets_NSDEF1000) if year==2010
gen assets_2016above=.
gen assets_2010above=.
replace assets_2016above=1 if assets_NSDEF1000>=assets_2016
replace assets_2016above=0 if assets_NSDEF1000<assets_2016
replace assets_2010above=1 if assets_NSDEF1000>=assets_2010
replace assets_2010above=0 if assets_NSDEF1000<assets_2010
tab assets_2016above if year==2016
*tab assets_2010above if year==2010
*tab assets_2010above assets_2016above if year==2016 
*tab assets_2010above assets_2016above if year==2010
bysort HHID: egen assets_2016cat=max(assets_2016above)
*tab assets_2016cat year
bysort HHID: egen assets_2010cat=max(assets_2010above)
*tab assets_2010cat year

*Shock
gen shock2=shock
recode shock2 (2=1)
bysort HHID: egen shock2_mean=mean(shock2)
label variable shock2 "Shock(s) (=1)"

*Test formal incomegen
gen flr_HH=formal_amount_HH/loanamount_HH
recode flr_HH (.=0)
gen iglr_HH=incomegen_amount_HH/loanamount_HH
recode iglr_HH (.=0)

gen ilr2_HH=(informal_amount_HH+semiformal_amount_HH)/loanamount_HH
recode ilr2_HH (.=0)

label variable flr_HH "FLR"
label variable iglr_HH "IGLR"
label variable ilr2_HH "ILR"
label variable niglr_amount_HH "NIGLR"


*Test female and assets
tab sex1 assets_2010cat if year==2010, nofreq cell
tab sex1 assets_2010cat if year==2010, nofreq col
*Effect assez élevé

*New sex-ratio cat for 2010 to regress
gen _sex_ratio_cat2010=1 if sex_ratio_cat==1 & year==2010
bysort HHID: egen sex_ratio_cat2010=max(_sex_ratio_cat2010)
recode sex_ratio_cat2010 (.=0)
tab sex_ratio_cat2010 if year==2010
tab sex_ratio_cat if year==2010

tab sex_ratio_cat2010

*Gen women ratio
gen female_ratio=nbfemale/nbHHmb
bysort HHID: egen female_ratio_mean=mean(female_ratio)

save"$directory\analysis\panel_v11.dta", replace
****************************************
* END 


****************************************
* VILLAGES + LABEL
****************************************
use"$directory\analysis\panel_v11.dta", clear
merge 1:1 parent_key year using "$directory\_temp\NEEMSIS-HH_May2019.dta", keepusing(villageid_new)
drop if _merge==2
drop _merge
*Clubbing Nordman.do:
gen villagearea=""
replace villagearea=villageid_new if year==2016

* CJ: I club some villages depending on some main regions of survey (especially the new one: Tiruppur region)
* There is additional clubbing we coud do but I prefer not to do too much for now, as some villages with few HHs are really
* quite distant from each others, and may face great differences in terms of access to bank/infrastructure.
* Two HHs were found for instance near Chennai (i.e. the suburb, Ponamallee) and so clubbing it with others doesn't make sense to me

replace villagearea="TIRUP_reg" if year==2016 & (villageid_new=="Somanur"|villageid_new=="Tiruppur"|villageid_new=="Chinnaputhur")
tab villagearea
rename villageid villageid2010
gen villagename2016=villageid_new
gen villagename2016_club=villagename2016
tab villagename2016_club

replace villagename2016_club="TIRUP_reg" if year==2016 & (villageid_new=="Somanur"|villageid_new=="Tiruppur"|villageid_new=="Chinnaputhur")

tab villagename2016_club

* CJ: I thought we might need to club the only HH found in Chengapattu with the near big village (Villiambakkam),
* clubbing them all with nearby Athur
* Otherwise we may not identify a dummy for Chengalpattu
* But after matching, it happens that this HH is dropped. So I deactivate this line.
replace villagename2016_club="VILLIAM_reg" if year==2016 & (villageid_new=="Villiambakkam"|villageid_new=="Chengalpattu"|villageid_new=="Athur")

* CJ: I generate dummies for closeness to main agglomerations, so that we test effects depending on access to city Banks
gen town_close=0
replace town_close=1 if (villageid_new=="Chengalpattu"|villageid_new=="Poonamallee"|villageid_new=="Tiruppur"|villageid_new=="Somanur"|villageid_new=="ELA"|villageid_new=="MAN"|villageid_new=="NAT"|villageid_new=="ORA"|villageid_new=="SEM"|villageid_new=="MANAM"|villageid_new=="KAR")
* The 10 origin villages are rather all close to cities, but two different ones:
* Panruti : "ELA"|"MAN"|"NAT"|"ORA"|"SEM"|"MANAM"|"KAR"
* Villupuram for KUV, KOR, GOV
* So I don't expect so great difference using the previous 'town_close'
* instead I create dummies for closeness to certain cities (all villages are included,
* except one: Chinnaputhur which is distant to all towns with at least 1h30 drive to any towns)
gen near_panruti=0
replace near_panruti=1 if (villageid_new=="ELA"|villageid_new=="MAN"|villageid_new=="NAT"|villageid_new=="ORA"|villageid_new=="SEM"|villageid_new=="MANAM"|villageid_new=="KAR")
gen near_villupur=0
replace near_villupur=1 if (villageid_new=="KUV"|villageid_new=="KOR"|villageid_new=="GOV")
gen near_tirup=0
replace near_tirup=1 if (villageid_new=="Tiruppur"|villageid_new=="Somanur")
gen near_chengal=0
replace near_chengal=1 if (villageid_new=="Chengalpattu"|villageid_new=="Athur"|villageid_new=="Villiambakkam")
gen near_kanchip=0
replace near_kanchip=1 if (villageid_new=="Sembarambakkam"|villageid_new=="Walajabad")
gen near_chennai=0
replace near_chennai=1 if (villageid_new=="Poonamallee")
gen most_remote=0
replace most_remote=1 if (villageid_new=="Chinnaputhur")

tab villageid2010
tab villagename2016_club

gen villageidclub=.
replace villageidclub=1 if villagename2016_club=="ELA"
replace villageidclub=2 if villagename2016_club=="GOV"
replace villageidclub=3 if villagename2016_club=="KAR"
replace villageidclub=4 if villagename2016_club=="KOR"
replace villageidclub=5 if villagename2016_club=="KUV"
replace villageidclub=6 if villagename2016_club=="MAN"
replace villageidclub=7 if villagename2016_club=="MANAM"
replace villageidclub=8 if villagename2016_club=="NAT"
replace villageidclub=9 if villagename2016_club=="ORA"
replace villageidclub=10 if villagename2016_club=="SEM"
replace villageidclub=11 if villagename2016_club=="Poonamallee"
replace villageidclub=12 if villagename2016_club=="Sembarambakkam"
replace villageidclub=13 if villagename2016_club=="TIRUP_reg"
replace villageidclub=14 if villagename2016_club=="VILLIAM_reg"
replace villageidclub=15 if villagename2016_club=="Walajabad"
replace villageidclub=villageid2010 if year==2010
rename villageid2010 villageid
tab villageidclub villageid if year==2016
label define villageidclub /// 
1"Elanthalmpattu" ///
2"Govulapuram" ///
3"Karumbur" ///
4"Korattore" ///
5"Kuvagam" ///
6"Manapakham" ///
7"Manamtha." ///
8"Natham" ///
9"Oraiyure" ///
10"Semakottai" ///
11"Poonamallee" ///
12"Sembarambakkam" ///
13"Tiruppur reg." ///
14"Villiambakkam reg." ///
15"Walajabad" 
label values villageidclub villageidclub
label values villageid villageidclub
tab villageid
tab villageidclub year


*identify young HH
gen tooyoungego1=.
replace tooyoungego1=1 if age1<25
tab tooyoungego1 
*Qui sont-ils ?
sort HHID year
list HHID year pb age1 age2 if tooyoungego1==1, clean


*caste group
gen caste_club=1 if caste_group==1
replace caste_club=2 if caste_group==2
replace caste_club=2 if caste_group==3
label define caste_club 1"Dalits" 2"Middle-upper"
label values caste_club caste_club

*HH main occ 
gen mainoccupation_HH_agri=1 if mainoccupation_HH==1
replace mainoccupation_HH_agri=1 if mainoccupation_HH==2
replace mainoccupation_HH_agri=0 if mainoccupation_HH==3
replace mainoccupation_HH_agri=0 if mainoccupation_HH==4
replace mainoccupation_HH_agri=0 if mainoccupation_HH==5
replace mainoccupation_HH_agri=0 if mainoccupation_HH==6
replace mainoccupation_HH_agri=0 if mainoccupation_HH==7

*Indiv main occ
gen mainoccupation1rec_agri=1 if mainoccupation1rec==1 | mainoccupation1rec==2
replace mainoccupation1rec_agri=0 if mainoccupation1rec!=. & mainoccupation1rec_agri!=1

*Test
tab mainoccupation1rec_agri year
tab mainoccupation_HH_agri year

tab mainoccupation1rec_agri mainoccupation_HH_agri if year==2016, chi2

*label
label variable nbsource"Nb. of income"
save"$directory\analysis\panel_v12.dta", replace
****************************************
* END 




****************************************
* TYPE AND USE OF DEBT AS X + BINAIRE
****************************************
use"$directory\analysis\panel_v12.dta", clear

gen dummy_formal=1 if flr_HH>0
replace dummy_formal=0 if flr_HH==0

gen dummy_informal=1 if ilr2_HH>0
replace dummy_informal=0 if ilr2_HH==0

gen dummy_income=1 if iglr_HH>0
replace dummy_income=0 if iglr_HH==0

gen dummy_noincome=1 if niglr_amount_HH>0
replace dummy_noincome=0 if niglr_amount_HH==0

foreach x in dummy_formal dummy_informal dummy_income dummy_noincome{
bysort HHID: egen `x'_mean=mean(`x')
}


replace dar_HH_bin=1 if dar_HH>=0.4
replace dar_HH_bin=0 if dar_HH<0.4

replace dir_HH_bin=1 if dir_HH>=1
replace dir_HH_bin=0 if dir_HH<1

save"$directory\analysis\panel_v13.dta", replace
****************************************
* END 









****************************************
* CAMBOUIS
****************************************
use"$directory\analysis\panel_v13.dta", clear

*Drop 
global todrop1 ADGP197 ANTMP36 ANTOR399 PSKOR203 RAEP68 RAGP172 RAKOR208 RAKOR209 VENKOR223 SIGP192 PSGP183 ADGP198 VENKOR219 ANTGP162
global todrop3 ADGP197 RAGP172 SIGP192 ADGP198 VENKOR219 ANTGP162
gen dropego1=0
gen dropego3=0
foreach x in $todrop1{
replace dropego1=1 if HHID=="`x'"
}
foreach x in $todrop3{
replace dropego3=1 if HHID=="`x'"
}

*MACRO
global ego1 EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std
global ego1new new_CO_r_std1 new_ES_r_std1 new_OPEX_r_std1 new_ESCO_r_std1 new_AG_r_std1
global ego1cont age1 age1sq sex1 mainoccupation1rec2 mainoccupation1rec3 mainoccupation1rec4 mainoccupation1rec5 mainoccupation1rec6 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 relation1_2 relation1_3
global ego1mean age1_mean age1sq_mean mainoccupation1rec2_mean mainoccupation1rec3_mean mainoccupation1rec4_mean mainoccupation1rec5_mean mainoccupation1rec6_mean relation1_2_mean relation1_3_mean
*CAMBOUIS: MISSING et AGE pour PSGP183 
global camb ANTMP36 ANTOR399 PSKOR203 RAEP68 RAKOR208 RAKOR209 VENKOR223 PSGP183 
gen cambouisego1ego2=0
foreach x in $camb{
replace cambouisego1ego2=1 if HHID=="`x'"
}

*Gen ego "3"
foreach x in $ego1 $ego1new $ego1cont $ego1mean{
gen `x'_ego3=`x'
}

*list HHID year age1_ego3 if tooyoungego1==1, clean

replace EGOcrOP1_r_std_ego3=EGOcrOP2_r_std if cambouisego1ego2==1
replace EGOcrCO1_r_std_ego3=EGOcrCO2_r_std if cambouisego1ego2==1
replace EGOcrEX1_r_std_ego3=EGOcrEX2_r_std if cambouisego1ego2==1
replace EGOcrAG1_r_std_ego3=EGOcrAG2_r_std if cambouisego1ego2==1
replace EGOcrES1_r_std_ego3=EGOcrES2_r_std if cambouisego1ego2==1
replace EGOraven1_r_std_ego3=EGOraven2_r_std if cambouisego1ego2==1
replace EGOlit1_r_std_ego3=EGOlit2_r_std if cambouisego1ego2==1
replace EGOnum1_r_std_ego3=EGOnum2_r_std if cambouisego1ego2==1
replace new_CO_r_std1_ego3=		new_CO_r_std2 	if cambouisego1ego2==1
replace new_ES_r_std1_ego3=		new_ES_r_std2 	if cambouisego1ego2==1
replace new_OPEX_r_std1_ego3=	new_OPEX_r_std2 if cambouisego1ego2==1
replace new_ESCO_r_std1_ego3=	new_ESCO_r_std2 if cambouisego1ego2==1
replace new_AG_r_std1_ego3=		new_AG_r_std2	if cambouisego1ego2==1
replace age1_ego3=age2 if cambouisego1ego2==1
replace age1sq_ego3=age2sq if cambouisego1ego2==1
replace sex1_ego3=sex2 if cambouisego1ego2==1
replace mainoccupation1rec2_ego3=mainoccupation2rec2 if cambouisego1ego2==1
replace mainoccupation1rec3_ego3=mainoccupation2rec3 if cambouisego1ego2==1
replace mainoccupation1rec4_ego3=mainoccupation2rec4 if cambouisego1ego2==1
replace mainoccupation1rec5_ego3=mainoccupation2rec5 if cambouisego1ego2==1
replace mainoccupation1rec6_ego3=mainoccupation2rec6 if cambouisego1ego2==1
replace edulevel_ego1_2_ego3=edulevel_ego2_2 if cambouisego1ego2==1
replace edulevel_ego1_3_ego3=edulevel_ego2_3 if cambouisego1ego2==1
replace edulevel_ego1_4_ego3=edulevel_ego2_4 if cambouisego1ego2==1
replace relation1_2_ego3=relation2_2 if cambouisego1ego2==1
replace relation1_3_ego3=relation2_3 if cambouisego1ego2==1
replace age1_mean_ego3=age2_mean if cambouisego1ego2==1
replace age1sq_mean_ego3=age2sq_mean if cambouisego1ego2==1
replace mainoccupation1rec2_mean_ego3=mainoccupation2rec2_mean if cambouisego1ego2==1
replace mainoccupation1rec3_mean_ego3=mainoccupation2rec3_mean if cambouisego1ego2==1
replace mainoccupation1rec4_mean_ego3=mainoccupation2rec4_mean if cambouisego1ego2==1
replace mainoccupation1rec5_mean_ego3=mainoccupation2rec5_mean if cambouisego1ego2==1
replace mainoccupation1rec6_mean_ego3=mainoccupation2rec6_mean if cambouisego1ego2==1
replace relation1_2_mean_ego3=relation2_2_mean if cambouisego1ego2==1
replace relation1_3_mean_ego3=relation2_3_mean if cambouisego1ego2==1

gen 	relation1_ego3=relation1
replace relation1_ego3=relation2 if cambouisego1ego2==1

gen 	edulevel1_ego3=edulevel1
replace edulevel1_ego3=edulevel2 if cambouisego1ego2==1

gen		mainoccupation1_ego3rec=mainoccupation1rec
replace mainoccupation1_ego3rec=mainoccupation2rec if cambouisego1ego2==1

gen _tooyoungego3=.
replace _tooyoungego3=1 if age1_ego3<25 & year==2010
replace _tooyoungego3=0 if age1_ego3>=25 & year==2010
bysort HHID : egen tooyoungego3=max(_tooyoungego3)
drop _tooyoungego3
tab tooyoungego1 tooyoungego3

tabstat age1 age1_ego3, stat(n mean sd p50 min max)

save"$directory\analysis\panel_v14.dta", replace
****************************************
* END 


****************************************
* LABELING
****************************************
use"$directory\analysis\panel_v14.dta", clear

label variable	female_ratio	"\hspace*{0.2cm} Female ratio"
label variable	EGOcrOP1_r_std_ego3	"\hspace*{0.2cm} Openn."
label variable	EGOcrCO1_r_std_ego3	"\hspace*{0.2cm} Consc."
label variable	EGOcrEX1_r_std_ego3	"\hspace*{0.2cm} Extra."
label variable	EGOcrAG1_r_std_ego3	"\hspace*{0.2cm} Agree."
label variable	EGOcrES1_r_std_ego3	"\hspace*{0.2cm} Em. stab."
label variable	EGOraven1_r_std_ego3	"\hspace*{0.2cm} Raven"
label variable	EGOlit1_r_std_ego3	"\hspace*{0.2cm} Literacy"
label variable	EGOnum1_r_std_ego3	"\hspace*{0.2cm} Numeracy"
label variable	age1_ego3	"\hspace*{0.2cm} Age"
label variable	age1sq_ego3	"\hspace*{0.2cm} Age square"
label variable	sex1_ego3	"\hspace*{0.2cm} Female (=1)"
label variable	mainoccupation1rec2_ego3	"\hspace*{0.2cm} Ind: Agri cas"
label variable	mainoccupation1rec3_ego3	"\hspace*{0.2cm} Ind: N-agri cas"
label variable	mainoccupation1rec4_ego3	"\hspace*{0.2cm} Ind: N-agri reg."
label variable	mainoccupation1rec5_ego3	"\hspace*{0.2cm} Ind: N-agri SE"
label variable	mainoccupation1rec6_ego3	"\hspace*{0.2cm} Ind: Other"
label variable	edulevel_ego1_2_ego3	"\hspace*{0.2cm} Edu: Prim."
label variable	edulevel_ego1_3_ego3	"\hspace*{0.2cm} Edu: High sch."
label variable	edulevel_ego1_4_ego3	"\hspace*{0.2cm} Edu: Sec. or more"
label variable	relation1_2_ego3	"\hspace*{0.2cm} Relation: Wife"
label variable	relation1_3_ego3	"\hspace*{0.2cm} Relation: Other"
label variable	new_CO_r_std1_ego3	"\hspace*{0.2cm} Consc."
label variable	new_ES_r_std1_ego3	"\hspace*{0.2cm} Em. stab."
label variable	new_OPEX_r_std1_ego3"\hspace*{0.2cm} Extra. Openn."
label variable	new_AG_r_std1_ego3	"\hspace*{0.2cm} Agree."
label variable	new_ESCO_r_std1_ego3	"\hspace*{0.2cm} Em. stab. Consc."

save"$directory\analysis\panel_v15.dta", replace
****************************************
* END 


/*
****************************************
* EXPOSURE TO SHOCK
****************************************
use"$directory\analysis\panel_v14.dta", clear
foreach x in $ego1{
eststo: qui reg `x' dummymar
}
esttab using "$directory\_temp\ttest.csv", ///
	cells(b(fmt(3)) t(fmt(2)) p(fmt(2))) ///
	drop(_cons) replace
estimates clear
foreach x in $ego1{
eststo: qui reg `x' dummydemonetisation
}
esttab using "$directory\_temp\ttest.csv", ///
	cells(b(fmt(3)) t(fmt(2)) p(fmt(2))) ///
	drop(_cons) replace
estimates clear
foreach x in $ego1{
eststo: qui reg `x' shock2
}
esttab using "$directory\_temp\ttest.csv", ///
	cells(b(fmt(3)) t(fmt(2)) p(fmt(2))) ///
	drop(_cons) replace
*Ok
****************************************
* END
*/


/*
****************************************
* PERFECT BALANCE
****************************************
use"$directory\analysis\panel_v14.dta", clear
egen nmissing = rowmiss(imp1_debt_burden imp1_interest_burden dar_HH dir_HH $ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont caste_group)
bysort HHID: gen n=_N
tab nmissing n
keep if n==2
drop n
cls
****************************************
* END
*/
