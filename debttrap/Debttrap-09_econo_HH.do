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
* Prepa data
****************************************
use"panel_HH_v2", clear


********** Selection
keep HHID_panel year head_sex head_age head_edulevel head_maritalstatus ownland dummymarriage head_mocc_occupation dummydemonetisation nbmale nbfemale HHsize HH_count_child HH_count_adult assets_total1000 annualincome_HH nbworker_HH nbnonworker_HH remittnet_HH secondlockdownexposure loanamount_HH trapamount_HH dummytrap_HH gtdr_HH village_1 village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10 dalits dummyloans_HH


********** Rename
rename assets_total1000 assets_HH
rename HHsize size_HH
rename HH_count_child nbchildren_HH
rename HH_count_adult nbadult_HH

rename dummyloans_HH dummyloans
rename dummytrap_HH dummytrap
rename trapamount_HH trapamount
rename gtdr_HH gtdr


********** New var
* Dalits
label define dalits 0"Non-dalits" 1"Dalits (=1)", modify

* Share
replace gtdr=gtdr/100

* Edulevel
fre head_edulevel
ta head_edulevel, gen(edu_)
drop head_edulevel
label var edu_1 "Edu: Below primary"
label var edu_2 "Edu: Primary completed"
label var edu_3 "Edu: High-school or more"

* Occupation
rename head_mocc_occupation moccup
fre moccup
ta moccup, gen(moccup_)
drop moccup
label var moccup_1 "Occ: Unoccup"
label var moccup_2 "Occ: Agri SE"
label var moccup_3 "Occ: Agri casual"
label var moccup_4 "Occ: Casual"
label var moccup_5 "Occ: Regular"
label var moccup_6 "Occ: SE"
label var moccup_7 "Occ: MGNREGA"

* HHFE
encode HHID_panel, gen(HHFE)

* Women
gen women=.
replace women=0 if head_sex==1
replace women=1 if head_sex==2
drop head_sex
label define women 0"Man" 1"Woman (=1)"
label values women women

* Assets
egen assets_std=std(assets_HH)
drop assets_HH
label var assets_std "Wealth (std)"

* Income
egen income_std=std(annualincome_HH)
drop annualincome_HH
label var income_std "Income (std)"

* Loan amount
egen loan_std=std(loanamount_HH)
drop loanamount_HH
label var loan_std "Debt amount (std)"

* Age sq
rename head_age age
gen agesq=age*age
label var age "Age"
label var agesq "Age squared"

* Maritalstatus
fre head_maritalstatus
rename head_maritalstatus maritalstatus
gen married=1 if maritalstatus==1
replace married=0 if maritalstatus>1
drop maritalstatus
label var married "Married (=1)"

* Shock 1
fre dummydemonetisation
rename dummydemonetisation shock1
recode shock1 (.=0)
label var shock1 "Shock 1 (=1)"

* Shock 2
fre secondlockdownexposure
gen shock2=0 if secondlockdownexposure==1
replace shock2=0 if secondlockdownexposure==2
replace shock2=1 if secondlockdownexposure==3
recode shock2 (.=0)
drop secondlockdownexposure
label var shock2 "Shock 2 (=1)"

* Shock 3
fre dummymarriage
rename dummymarriage shock3
recode shock3 (.=0)
label var shock3 "Shock 3 (=1)"


********** Order
sort HHID_panel year
order HHID_panel HHFE year age agesq women married dalits edu_1 edu_2 edu_3 moccup_1 moccup_2 moccup_3 moccup_4 moccup_5 moccup_6 moccup_7 dummyloan dummytrap trapamount gtdr size_HH nbchildren_HH nbadult_HH nbmale nbfemale nbworker_HH nbnonworker_HH assets_std income_std loan_std remittnet_HH ownland shock1 shock2 shock3



********** Mean over time for FE
global headcont age agesq married edu_1 edu_2 edu_3 moccup_1 moccup_2 moccup_3 moccup_4 moccup_5 moccup_6 moccup_7
global hhcont size_HH nbchildren_HH nbadult_HH nbmale nbfemale nbworker_HH nbnonworker_HH assets_std income_std loan_std shock1 shock2 shock3

foreach x in $headcont $hhcont {
bysort HHID_panel: egen mean_`x'=mean(`x')
}




********** Var Bates, Papke, Wooldridge
bysort HHID_panel: gen nobs=_N

gen nobs1=nobs==1
gen nobs2=nobs==2
gen nobs3=nobs==3

gen year2010=year==2010
gen year2016=year==2016
gen year2020=year==2020


foreach x in year2010 year2016 year2020{
bysort HHID_panel: egen mean_`x'=mean(`x')
}

label var nobs1 "Nb obs: 1"
label var nobs2 "Nb obs: 2"
label var nobs3 "Nb obs: 3"
label var year2010 "Year: 2010"
label var year2016 "Year: 2016-17"
label var year2020 "Year: 2020-21"
label var mean_year2010 "Within year: 2010"
label var mean_year2016 "Within year: 2016-17"
label var mean_year2020 "Within year: 2020-21"


save"panel_HH_v2_econo", replace
****************************************
* END












****************************************
* Econo
****************************************
use"panel_HH_v2_econo", clear



********** Macro
global headcont ///
women ///
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
dalits ///
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
year2016 mean_year2016 ///
year2020 mean_year2020 ///
nobs1 nobs2






********** Incidence
keep if dummyloans==1
*
probit dummytrap $headcont $hhcont $invar $time ///
, vce(cl HHFE)
est store inc1


********** Intensity
keep if dummytrap==1
*
glm gtdr $headcont $hhcont $invar $time ///
, family(binomial) link(probit) cluster(HHFE)
est store int1

****************************************
* END

