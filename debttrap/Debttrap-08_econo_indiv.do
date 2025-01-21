*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 9, 2025
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Econo 1
****************************************
use"panel_indiv_v3", clear



********** Rename
rename assets_total1000 assets_HH
rename HHsize size_HH
rename sexratio sexratio_HH
rename nonworkersratio nonworkersratio_HH
rename totindiv_effectiveamt_repa efftrapamount
rename totindiv_givenamt_repa givtrapamount
rename dumHH_effective_repa dummytrap_HH
rename totHH_effectiveamt_repa trapamount_HH
rename dummyloans_indiv dummyloans
rename loanamount_indiv loanamount
rename nbloans_indiv nbloans
rename etdr etdr_HH
rename etdr_indiv etdr
rename etir_indiv etir
rename mainocc_occupation_indiv moccup
rename mainocc_annualincome_indiv moccupannualincome
rename mainocc_occupationname_indiv moccupname
rename annualincome_indiv totalannualincome
rename nboccupation_indiv nboccupation
rename hoursayear_indiv totalhoursayear
rename mainocc_hoursayear_indiv moccuphoursayear
rename mainocc_tenureday_indiv moccuptenure
rename HH_count_child nbchildren_HH

order HHID_panel INDID_panel year name age sex relationshiptohead edulevel caste dummypanel_HH


********** Création var
*** Panel indiv
bysort HHID_panel INDID_panel: gen obs=_N
ta obs year

*** Edulevel
fre edulevel
recode edulevel (5=2) (4=2) (3=2)
ta edulevel, gen(edu_)


*** Occupation
fre moccup
recode moccup (.=0) (5=4)
ta moccup, gen(moccup_)


*** HHFE
encode HHID_panel, gen(HHFE)

*** Women
gen women=.
replace women=0 if sex==1
replace women=1 if sex==2

*** Assets
egen assets_std=std(assets_HH)

*** Income
egen income_std=std(annualincome_HH)

*** Loan amount
egen loan_std=std(loanamount_HH)

*** Age sq
gen agesq=age*age

*** Maritalstatus
fre maritalstatus
gen married=1 if maritalstatus==1
replace married=0 if maritalstatus>1

ta married maritalstatus

*** Head sex
fre headsex
gen headwoman=0 if headsex==1
replace headwoman=1 if headsex==2

*** Shock 1
fre dummydemonetisation
rename dummydemonetisation shock1
recode shock1 (.=0)

*** Shock 2
fre secondlockdownexposure
gen shock2=0 if secondlockdownexposure==1
replace shock2=0 if secondlockdownexposure==2
replace shock2=1 if secondlockdownexposure==3
recode shock2 (.=0)

*** Shock 3
fre dummymarriage
rename dummymarriage shock3
recode shock3 (.=0)





********** Macro
global yvar etdr efftrapamount givtrapamount etir share_etdr share_gtdr dummygtrap_indiv dummyetrap_indiv
global identity women caste_1 caste_2 caste_3 dalits
global indivcont age agesq edu_1 edu_2 edu_3 moccup_1 moccup_2 moccup_3 moccup_4 moccup_5 moccup_6 moccup_7 married
global hhcont size_HH sexratio_HH assets_std income_std nonworkersratio_HH loan_std nbchildren_HH headwoman shock1 shock2 shock3

global hhinvar village_1 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10


********** To keep
keep HHID_panel INDID_panel year HHFE panelvar dummyloans $yvar $identity $indivcont $hhcont $hhinvar




********** Mean over time
foreach x in $indivcont $hhcont {
bysort HHID_panel INDID_panel: egen mean_`x'=mean(`x')
}




********** Var Bates, Papke, Wooldridge
bysort HHID_panel INDID_panel: gen nobs=_N

gen nobs1=nobs==1
gen nobs2=nobs==2

gen year2016=year==2016
gen year2020=year==2020

foreach x in year2016 year2020 {
bysort HHID_panel INDID_panel: egen mean_`x'=mean(`x')
}

*** Label
label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"

label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"





********** Macro
global indivcont ///
age mean_age ///
agesq mean_agesq ///
married mean_married ///
edu_2 mean_edu_2 ///
edu_3 mean_edu_3 ///
moccup_1 mean_moccup_1 ///
moccup_2 mean_moccup_2 ///
moccup_4 mean_moccup_4 ///
moccup_5 mean_moccup_5 ///
moccup_6 mean_moccup_6 ///
moccup_7 mean_moccup_7 ///

global hhcont ///
size_HH mean_size_HH ///
nbchildren_HH mean_nbchildren_HH ///
income_std mean_income_std ///
assets_std mean_assets_std ///
shock1 mean_shock1 ///
shock2 mean_shock2 ///
shock3 mean_shock3

global invar ///
village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10

global time ///
year2020 mean_year2020 ///
nobs2





********** Given
preserve
*** Step 1: Dummy
keep if dummyloans==1
*
probit dummygtrap_indiv i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)
est store prg1
*
probit dummygtrap_indiv i.women##i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)
est store prg2

*** Step 2: Intensity
keep if dummygtrap_indiv==1
*
glm share_gtdr i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
est store glg1
*
glm share_gtdr i.women##i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
est store glg2
restore

esttab prg1 prg2 glg1 glg2 using "Given_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N N_clust r2_p, fmt(0 0 2)	labels(`"Observations"' `"Number of clust"'))



********** Effective
preserve
*** Step 1: Dummy
keep if dummyloans==1
*
probit dummyetrap_indiv i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)
est store pre1
*
probit dummygtrap_indiv i.women##i.dalits ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)
est store pre2

*** Step 2: Intensity
keep if dummyetrap_indiv==1
*
glm share_etdr i.women i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
est store gle1
*
glm share_etdr i.women##i.dalits ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)
est store gle2
restore



esttab pre1 pre2 gle1 gle2 using "Effective_reg.csv", replace ///
	label b(3) p(3) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///
	refcat(, nolabel) ///
	stats(N N_clust r2_p, fmt(0 0 2)	labels(`"Observations"' `"Number of clust"'))




****************************************
* END

