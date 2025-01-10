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
rename totindiv_effectiveamt_repa trapamount
rename dumHH_effective_repa dummytrap_HH
rename dumindiv_effective_repa dummytrap
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
recode moccup (5=4)
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

*** Class
xtile assq3=assets_HH,n(3)
ta assq3, gen(assq3_)

xtile assq5=assets_HH,n(5)
ta assq5, gen(assq5_)

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
global yvar etdr dummytrap trapamount etir share_etdr share_gtdr
global identity women caste_1 caste_2 caste_3
global indivcont age agesq edu_1 edu_2 edu_3 moccup_1 moccup_2 moccup_3 moccup_4 moccup_5 moccup_6 married
global hhcont size_HH sexratio_HH assets_std income_std nonworkersratio_HH loan_std village_1 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 assq3_1 assq3_2 assq3_3 assq5_1 assq5_2 assq5_3 assq5_4 assq5_5 nbchildren_HH headwoman shock1 shock2 shock3



********** To keep
keep HHID_panel INDID_panel year HHFE panelvar dummyloans $yvar $identity $indivcont $hhcont




********** Mean over time
foreach x in $identity $indivcont $hhcont {
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
global varint ///
women caste_2 caste_3 ///

global indivcont ///
age mean_age ///
agesq mean_agesq ///
married mean_married ///
edu_2 mean_edu_2 ///
edu_3 mean_edu_3 ///
moccup_1 mean_moccup_1 ///
moccup_3 mean_moccup_3 ///
moccup_4 mean_moccup_4 ///
moccup_5 mean_moccup_5 ///
moccup_6 mean_moccup_6

global hhcont ///
headwoman mean_headwoman ///
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





********** Reg

*** Step 1: Dummy
keep if dummyloans==1

probit dummytrap $varint ///
$indivcont $hhcont $invar $time ///
, vce(cl panelvar)


*** Step 2: Intensity
keep if dummytrap==1

glm etdr $varint ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)

glm share_etdr $varint ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)

glm share_gtdr $varint ///
$indivcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(panelvar)

reg trapamount $varint ///
$indivcont $hhcont $invar $time ///
, cluster(panelvar)




****************************************
* END

