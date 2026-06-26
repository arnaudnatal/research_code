*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------

cd"D:\Ongoing_Diversity\Analysis"




****************************************
* Stat
****************************************
use"panel_HH_v1", clear

*
ta dps

* By year
tabstat dps, stat(n mean p50 cv) by(year)

* By caste
tabstat dps, stat(n mean p50) by(caste)
tabstat dps if year==2010, stat(n mean p50) by(caste)
tabstat dps if year==2016, stat(n mean p50) by(caste)
tabstat dps if year==2020, stat(n mean p50) by(caste)

* Demonetisation
tabstat dps if year==2016, stat(n mean q cv) by(dummydemonetisation)

* Lockdown
tabstat dps if year==2020, stat(n mean q cv) by(secondlockdownexposure)

* Marriage
tabstat dps if year!=2010, stat(n mean q cv) by(dummymarriage)

* Cross with other debt var
corr dps dsr dar isr
spearman dps dsr dar isr

* Lorenz
preserve
keep HHID year dps
reshape wide dps, i(HHID) j(year)
lorenz estimate dps2010 dps2016 dps2020, gini
lorenz graph, overlay noci
restore

****************************************
* END












****************************************
* Multidim index (AF indicators)
****************************************
use"panel_HH_v1", clear

* Total
mpi ///
d1(d_dsr d_isr d_dar d_curr) w1(0.13 0.13 0.13 0.13) ///
d2(d_land d_gold d_sav) w2(0.08 0.08 0.08) ///
d3(d_poor d_casu d_rem) w3(0.08 0.08 0.08) ///
, cutoff(0.33)

* By year
mpi ///
d1(d_dsr d_isr d_dar d_curr) w1(0.13 0.13 0.13 0.13) ///
d2(d_land d_gold d_sav) w2(0.08 0.08 0.08) ///
d3(d_poor d_casu d_rem) w3(0.08 0.08 0.08) ///
, cutoff(0.33) by(year)

* By caste
mpi ///
d1(d_dsr d_isr d_dar d_curr) w1(0.13 0.13 0.13 0.13) ///
d2(d_land d_gold d_sav) w2(0.08 0.08 0.08) ///
d3(d_poor d_casu d_rem) w3(0.08 0.08 0.08) ///
, cutoff(0.33) by(caste)

* By Jatis
preserve
bys jatis: gen n=_N
ta n
drop if n<100
mpi ///
d1(d_dsr d_isr d_dar d_curr) w1(0.13 0.13 0.13 0.13) ///
d2(d_land d_gold d_sav) w2(0.08 0.08 0.08) ///
d3(d_poor d_casu d_rem) w3(0.08 0.08 0.08) ///
, cutoff(0.33) by(jatis)
restore

****************************************
* END















****************************************
* Evo over time only for 3 points in time
****************************************
use"panel_HH_v1", clear

* Selection
keep HHID time caste dps
bys HHID: gen n=_N
keep if n==3
drop n

* Reshape
reshape wide dps, i(HHID) j(time)
order caste, after(HHID)

* Evolution
gen d1=dps2-dps1
gen d2=dps3-dps2

gen cat_d1=0
replace cat_d1=1 if d1>0

gen cat_d2=0
replace cat_d2=1 if d2>0

gen cat_d=0
replace cat_d=1 if dps3>dps1

ta cat_d1
ta cat_d2
ta cat_d1 cat_d2, row nofreq
ta cat_d caste, row nofreq

twoway ///
(scatter d2 d1, ms(oh) mcolor(black%30) xline(0) yline(0)) ///
(function y=-x, range(-.8 .8)) ///
, xlabel(-.8(.2).8) ylabel(-.8(.2).8)


****************************************
* END
















****************************************
* Econometrics
****************************************
use"panel_HH_v1", clear

***** Selection
keep HHID year caste dps villageid HHsize HH_count_child family head_sex head_age head_maritalstatus head_mocc_occupation head_edulevel nbworker_HH nbnonworker_HH secondlockdownexposure dummydemonetisation jatis caste dummymarriage

***** Cleaning
*
fre head_sex
rename head_sex head_fem
recode head_fem (1=0) (2=1)
label define head_fem 0"Male" 1"Female"
label values head_fem head_fem
fre head_fem
*
fre head_maritalstatus
rename head_maritalstatus head_nmarried
recode head_nmarried (1=0) (2=1) (3=1) (4=1)
ta head_nmarried
label define head_nmarried 0"Married" 1"Non-married"
label values head_nmarried head_nmarried
fre head_nmarried
*
fre head_mocc_occupation
rename head_mocc_occupation head_occ
*
fre head_edulevel
rename head_edulevel head_edu
*
fre secondlockdownexposure
rename secondlockdownexposure lock
recode lock (.=1)
*
fre dummymarriage
*
fre dummydemonetisation
*
fre family
recode family (3=1) (2=0)
rename family stem
label define stem 0"Nuclear" 1"Joint or Stem"
label values stem stem
fre stem

***** Dummies
foreach x in head_occ head_edu {
ta `x', gen(`x')
}
foreach x in lock caste villageid {
ta `x', gen(`x'_)
}


***** Mean over time
foreach x in head_occ1 head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_occ8 head_edu1 head_edu2 head_edu3 head_edu4 head_edu5 head_edu6 lock_1 lock_2 lock_3 dummymarriage HHsize HH_count_child head_fem head_age head_nmarried dummydemonetisation stem {
bysort HHID: egen mean_`x'=mean(`x')
}


***** Macro
global family ///
HHsize mean_HHsize ///
HH_count_child mean_HH_count_child ///
stem mean_stem


global head ///
head_fem mean_head_fem ///
head_age mean_head_age ///
head_occ1 mean_head_occ1 ///
head_occ2 mean_head_occ2 ///
head_occ4 mean_head_occ4 ///
head_occ5 mean_head_occ5 ///
head_occ6 mean_head_occ6 ///
head_occ7 mean_head_occ7 ///
head_occ8 mean_head_occ8 ///
head_edu2 mean_head_edu2 ///
head_edu3 mean_head_edu3 ///
head_edu4 mean_head_edu4 ///
head_edu5 mean_head_edu5 ///
head_edu6 mean_head_edu6 ///
head_nmarried mean_head_nmarried

global shock ///
dummymarriage mean_dummymarriage ///
dummydemonetisation mean_dummydemonetisation ///
lock_2 mean_lock_2 ///
lock_3 mean_lock_3

global invar ///
caste_2 caste_3 ///
villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10


***** Other var
bysort HHID: gen nobs=_N
gen nobs1=nobs==1
gen nobs2=nobs==2
gen nobs3=nobs==3
gen year2010=year==2010
gen year2016=year==2016
gen year2020=year==2020
foreach x in year2010 year2016 year2020 {
bysort HHID: egen mean_`x'=mean(`x')
}
*
label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var nobs3 "Nb obs: 3"
label var year2010 "Year: 2010"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"
label var mean_year2010 "Within year: 2010"
label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"
*
global time ///
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs2 nobs3


***** Multicollinerarity
corr $family $head $shock $invar $time



***** CRE
glm dps $head $family $shock $invar $time , family(binomial) link(probit) cluster(HHID)
est store spec1


***** Impact demo
preserve
keep if year==2016
glm dps head_fem head_age head_nmarried i.head_occ i.head_edu HHsize HH_count_child stem dummymarriage dummydemonetisation i.lock i.caste i.villageid, family(binomial) link(probit)
restore


***** Impact COVID
preserve
keep if year==2020
glm dps head_fem head_age head_nmarried i.head_occ i.head_edu HHsize HH_count_child stem dummymarriage dummydemonetisation i.lock i.caste i.villageid, family(binomial) link(probit)
restore


****************************************
* END
