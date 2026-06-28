*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 5, 2026
*-----
*Cleaning
*-----

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_JatisInequalities\Analysis"
cd"$directory"
*-------------------------


/*
Trois sources de données : 
	- DHS pour avoir les bases (NFHS_India_20152016.zip)
	- Oxford Poverty and Human Development Initiative pour les codes MPI (NFHS_India_20152016.zip)
	- ComTer pour les castes (ComTer-NFHS_2015.zip)

Objectif :
	Avoir sur une seule base de données, l'ensemble des variables, les castes
	et les binaires de privation

Pour cela : 
	1. Lancer les codes OPHDI qui vont donner "mpivars.dta"
	2. Partant de la base "HH.dta" fournit par Guilmoto, ajouter les castes et
		les binaires de privation
	3. Compléter les binaires de privation avec deux dimensions manquants : 
		compte bancaire et XXXX

Dans "raw" :
	- HH.dta c'est la base de travail de Guilmoto
	- mpivars.dta pour les 10 premieres binaire de privation
	- new9 caste.dta avec la variable de jatis
	- IAIR74FL.dta pour calculer antenatal care
*/




****************************************
* Merge base HH
****************************************
use"raw/HH.dta", clear

* Duplicates
duplicates report hhid

* Destring, rename
destring hhid, gen(idhh)

* Merge avec la variable idhh
merge 1:1 idhh using "raw/new9 caste", keepusing(NEW9)
keep if _merge==3
drop _merge

* MPI
merge 1:1 hhid using "raw/mpivars"
rename _merge merge_mpivars

*
save"HH_caste_v0.dta", replace
****************************************
* END









****************************************
* Privation bancaire
****************************************
use"HH_caste_v0.dta", clear

fre hv247
gen d_bank=0
replace d_bank=1 if hv247==0
replace d_bank=1 if hv247==8
drop hv247
label var d_bank "RECODE of hv247 (Household has a bank account)"

save"HH_caste_v1.dta", replace
****************************************
* END









****************************************
* Antenatal care
****************************************
use"raw/IAIR74FL", clear

split caseid, p(" ")
rename caseid1 hhid
order hhid, first
drop caseid2 caseid3 caseid4 caseid5
destring hhid, gen(hhid_num)
order hhid_num, after(hhid)

/*
A household is deprived if any woman in the household who has given birth in the 5 years preceding the survey, has not received at least 4 antenatal care visits for the most recent birth, or has not received assistance from trained skilled medical personnel during the most recent childbirth.
*/

* Femme ayant eu une naissance dans les 5 ans
mdesc m14_1 m14_2 m14_3 m14_4 m14_5 m14_6
gen birth5=.
replace birth5=0 if m14_1==.
replace birth5=1 if m14_1!=.
ta birth5

* Moins de 4 visites ANC pour la naissance la plus récente
gen anc_less4=.
replace anc_less4=1 if birth5==1 & m14_1<4
replace anc_less4=0 if birth5==1 & m14_1>=4

* Assistance qualifiée à l’accouchement
gen skilled_birth=0 if birth5==1
replace skilled_birth=1 if m3a_1==1 | m3b_1==1 | m3c_1==1
*
gen no_skilled_birth=.
replace no_skilled_birth=1 if birth5==1 & skilled_birth==0
replace no_skilled_birth=0 if birth5==1 & skilled_birth==1

* Indicateur femme : privée si ANC < 4 OU pas d’assistance qualifiée
gen anc_dep_woman=.
replace anc_dep_woman=1 if birth5==1 & (anc_less4==1 | no_skilled_birth==1)
replace anc_dep_woman=0 if birth5==1 & anc_less4==0 & no_skilled_birth==0

* Agrégation ménage : privé si au moins une femme est privée
bys hhid: egen anc_dep_hh=max(anc_dep_woman)

* Ménages sans naissance dans les 5 ans dans IR = non privés pour cet indicateur
replace anc_dep_hh=0 if anc_dep_hh==.
ta anc_dep_hh

* Garder une ligne par ménage pour fusion avec HR
keep hhid anc_dep_hh hhid_num
rename anc_dep_hh d_anc
duplicates drop

save "_temp.dta", replace

********* Merging
use"HH_caste_v1.dta", clear

destring hhid, gen(hhid_num)
merge 1:1 hhid_num using "_temp"
drop hhid_num
drop _merge
recode d_anc (.=0)

save"HH_caste_v2.dta", replace
****************************************
* END










****************************************
* Deprivation score
****************************************
use"HH_caste_v2.dta", clear

***** Missings?
mdesc d_cm d_nutr d_satt d_educ d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank d_anc
egen nbmiss=rowmiss(d_cm d_nutr d_satt d_educ d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank d_anc)
ta nbmiss
keep if nbmiss==0
drop nbmiss

***** Deprivation score OPHDI (10 dim)
gen dp_score10=((1/6)*d_nutr) ///
+((1/6)*d_cm) ///
+((1/6)*d_educ) ///
+((1/6)*d_satt) ///
+((1/18)*d_elct) ///
+((1/18)*d_sani) ///
+((1/18)*d_wtr) ///
+((1/18)*d_hsg) ///
+((1/18)*d_ckfl) ///
+((1/18)*d_asst) 
tabstat dp_score10, stat(n mean q min max)
*
gen d_mpoor10=.
replace d_mpoor10=0 if dp_score10<0.333
replace d_mpoor10=1 if dp_score10>=0.333
replace d_mpoor10=. if dp_score10==.

* MPI censuré
gen mpi_cens10=dp_score10 if d_mpoor10==1
replace mpi_cens10=0 if d_mpoor10==0
replace mpi_cens10=. if dp_score10==.



***** Deprivation score Niti Ayog (12 dim)
gen dp_score12=((1/6)*d_nutr) ///
+((1/12)*d_cm) ///
+((1/12)*d_anc) ///
+((1/6)*d_educ) ///
+((1/6)*d_satt) ///
+((1/21)*d_elct) ///
+((1/21)*d_sani) ///
+((1/21)*d_wtr) ///
+((1/21)*d_hsg) ///
+((1/21)*d_ckfl) ///
+((1/21)*d_asst) ///
+((1/21)*d_bank)
tabstat dp_score12, stat(n mean q min max)
*
gen d_mpoor12=.
replace d_mpoor12=0 if dp_score12<0.333
replace d_mpoor12=1 if dp_score12>=0.333
replace d_mpoor12=. if dp_score12==.

* MPI censuré
gen mpi_cens12=dp_score12 if d_mpoor12==1
replace mpi_cens12=0 if d_mpoor12==0
replace mpi_cens12=. if dp_score10==.


save"HH_caste_v3.dta", replace
****************************************
* END












****************************************
* Controls
****************************************
use"HH_caste_v3.dta", clear


***** Weight
generate wgt = hv005/1000000


***** Head characteristics
* Sex
clonevar head_sex=hv219
* Age
clonevar head_age=hv220
replace head_age=. if head_age==98
* Marital status
clonevar head_marital=hv115_01
fre head_marital
recode head_marital (0=3) (3=2) (5=4) (8=4)
label define head_marital 1"married" 2"widowed" 3"non-married" 4"other"
label values head_marital head_marital
ta hv115_01 head_marital
* Jatis
clonevar head_jatis=NEW9
* Caste
clonevar head_caste=sh36
recode head_caste (8=4) (.=4)
label define head_caste 1"SC" 2"ST" 3"OBC" 4"Other"
label values head_caste head_caste
ta head_caste
* Religion
clonevar head_religion=sh34
fre head_religion
recode head_religion (6=96) (7=96) (8=96) (9=96)
fre head_religion
* Langage
clonevar head_lang=shlangrm
ta head_lang


***** Household characteristics
* Household size
clonevar hh_size=hhsize
replace hh_size=15 if hh_size>15
* Household structure
clonevar hh_struct=hv217
fre hh_struct
recode hh_struct (0=5)
label define hh_struct 1"one adult" 2"two adults (diff sex)" 3"two adults (same sex)" 4"three related adults" 5"other"
label values hh_struct hh_struct
* Family
clonevar hh_family=shstruc
* Wealth cat
clonevar hh_wealthcat=hv270
* Wealth cont
clonevar hh_wealth=hv271
* Wealth cont postitive
qui sum hv271, det
gen hh_wealthpos=hv271+abs(`r(min)')
* Gender of houseowner
clonevar hh_genderhouseowner=sh47


***** Location
* State
clonevar loc_state=hv024 
* District
clonevar loc_district=shdistri
* Rural / urban
clonevar loc_rururb=hv025



save"HH_caste_v4.dta", replace
****************************************
* END









****************************************
* Selection
****************************************
use"HH_caste_v4.dta", clear

keep hhid wgt d_cm d_nutr d_satt d_educ d_elct d_wtr d_sani d_hsg d_ckfl d_asst d_bank d_anc dp_score10 d_mpoor10 dp_score12 d_mpoor12 wgt head_sex head_age head_marital head_jatis head_caste head_religion head_lang hh_size hh_struct hh_family hh_wealthcat hh_wealth hh_wealthpos hh_genderhouseowner loc_state loc_district loc_rururb mpi_cens10 mpi_cens12

order hhid wgt ///
loc_state loc_district loc_rururb ///
hh_* ///
head_* 

* Jatis with more than 1000 hh
bysort head_jatis: gen n=_N
gen jatis1000=.
replace jatis1000=0 if n<1000
replace jatis1000=1 if n>=1000
drop n
order jatis1000, after(head_jatis)
ta jatis1000

* 5000
bysort head_jatis: gen n=_N
gen jatis5000=.
replace jatis5000=0 if n<5000
replace jatis5000=1 if n>=5000
drop n
order jatis5000, after(jatis1000)


save"HH_caste_v5.dta", replace
****************************************
* END













****************************************
* Indiv level for MPI
****************************************
use"raw/IAPR74FL.dta", clear

* Selection
keep hhid hvidx hv101 hv102 hv103 hv104 hv105 hv109 hv115
rename hv102 usualresident
fre usualresident
drop if usualresident==0
drop usualresident

* Rename
rename hv101 relationshiptohead
rename hv103 sleptlastnight
rename hv104 sex
rename hv105 age
rename hv109 educ
rename hv115 maritalstatus

* Merge HH infos
merge m:1 hhid using "HH_caste_v5"
keep if _merge==3
drop _merge
ta head_caste
fre head_caste

* Order
order hhid hvidx wgt

save"Indiv_mpi.dta", replace
****************************************
* END



