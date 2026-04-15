*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 12, 2026
*-----
gl link = "genderofdebt"
*Prepa database Findex
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Findex 2011
****************************************
use"raw/Findex2011.dta", replace

keep ecnmycode wgt female age educ inc_q q14a-q14e q15a-q15e regionwb
drop q16 q17 q18

rename q14a l_finan
rename q14b l_store
rename q14c l_famil
rename q14d l_emplo
rename q14e l_privl

rename q15a r_home
rename q15b r_homecons
rename q15c r_school
rename q15d r_emerg
rename q15e r_funeral

rename ecnmycode economycode

gen year=2011

save"2011", replace
****************************************
* END








****************************************
* Findex 2014
****************************************
use"raw/Findex2014.dta", replace

keep economycode wgt female age educ inc_q borrowed q21a-q21d q22a-q22c q20 regionwb

rename q21a l_finan
rename q21b l_store
rename q21c l_famil
rename q21d l_emplo

rename q22a r_school
rename q22b r_medical
rename q22c r_farm
rename q20 r_finanhouse

gen year=2014

save"2014", replace
****************************************
* END






****************************************
* Findex 2017
****************************************
use"raw/Findex2017.dta", replace

keep economycode wgt female age educ inc_q borrowed fin22a fin22b fin22c fin20 fin21 fin19 regionwb

rename fin22a l_finan
rename fin22b l_famil
rename fin22c l_infclub

rename fin20 r_medical
rename fin21 r_farm
rename fin19 r_finanhouse

gen year=2017


save"2017", replace
****************************************
* END





  






****************************************
* Findex 2021
****************************************
use"raw/Findex2021.dta", replace


ta borrowed [iweight=wgt]

* Sources
ta fin22a [iweight=wgt]
ta fin22b [iweight=wgt]
ta fin22c [iweight=wgt]

* Reasons
ta fin20 [iweight=wgt]

* Mobile money
ta fin13c [iweight=wgt]

* Not pay credit in full
gen carddebt=0
*fin8 used a credit card
*fin8b paid credit card balances in full
replace carddebt=1 if fin8==1 & fin8b==2
ta carddebt [iweight=wgt]

***** Informal debt
fre fin22b fin22c
gen inf=.
replace inf=0 if fin22b==2
replace inf=0 if fin22c==2
replace inf=1 if fin22b==1
replace inf=1 if fin22c==1

***** One or the other
gen everydaydebt=0
replace everydaydebt=1 if inf==1 | carddebt==1


keep economycode wgt female age educ inc_q borrowed carddebt fin22a fin22b fin22c fin20 fin13c inf everydaydebt urbanicity_f2f emp_in regionwb

rename fin22a l_finan
rename fin22b l_famil
rename fin22c l_infclub

rename fin20 r_medical
rename fin13c mobilemoney

rename urbanicity_f2f area
rename emp_in workforce

gen year=2021

save"2021", replace
****************************************
* END














****************************************
* Findex 2024
****************************************
use"raw/Findex2024.dta", replace

ta borrowed [iweight=wgt]
ta fin23 [iweight=wgt]

* Sources
ta fin22a [iweight=wgt]
ta fin22a_1 [iweight=wgt]
ta fin22b [iweight=wgt]
ta fin22c [iweight=wgt]
ta fin20 [iweight=wgt]

* Reasons
ta fin22d [iweight=wgt]
ta fin22e [iweight=wgt]
ta fin22f [iweight=wgt]

* Not pay credit in full
gen carddebt=0
*fin22g used a credit card
*fin22h paid credit card balances in full
replace carddebt=1 if fin22g==1 & fin22h==2
ta carddebt [iweight=wgt]


***** Informal debt
fre fin22b fin22c
gen inf=.
replace inf=0 if fin22b==2
replace inf=0 if fin22c==2
replace inf=1 if fin22b==1
replace inf=1 if fin22c==1

***** One or the other
gen everydaydebt=0
replace everydaydebt=1 if inf==1 | carddebt==1


keep economycode wgt female age educ inc_q borrowed carddebt fin23 fin22a fin22a_1 fin22b fin22c fin20 fin22d fin22e fin22f emp_in urbanicity inf everydaydebt regionwb

rename fin22a l_finan
rename fin22a_1 l_mobilemoney
rename fin22b l_famil
rename fin22c l_infclub

rename fin22d r_medical
rename fin22e r_startbusi
rename fin22f foodcredit
rename fin20 mobilemoney

rename urbanicity area
rename emp_in workforce

drop fin23

gen year=2024

save"2024", replace
****************************************
* END

















****************************************
* Append
****************************************
use"2011.dta", replace

append using "2014"
append using "2017"
append using "2021"
append using "2024"

order economycode year female age educ inc_q wgt

fre economycode
encode economycode, gen(country)
drop economycode
order country, first

encode regionwb, gen(worldarea)
drop regionwb
order worldarea, after(country)

save"Findex.dta", replace
****************************************
* END
















****************************************
* Stats
****************************************
use"Findex.dta", replace

***** Missings
/*
mdesc if year==2011
mdesc if year==2014
mdesc if year==2017
mdesc if year==2021
mdesc if year==2024
*/


***** Probit loan from family
/*
recode l_famil (2=0) (3=0) (4=0)
fre l_famil
probit l_famil i.female i.year i.country [iweight=wgt]
*/

***** In rural Global South
fre worldarea
drop if worldarea==5
drop if worldarea==6
drop if worldarea==7
drop if worldarea==8
drop if worldarea==9

fre area
keep if area==1


probit everydaydebt i.female i.year age i.educ i.inc_q i.country [iweight=wgt]
probit everydaydebt i.female age i.educ i.inc_q i.country [iweight=wgt] if year==2021
probit everydaydebt i.female age i.educ i.inc_q i.country [iweight=wgt] if year==2024


********** Indiv with everyday debt in rural areas of the Global South in 2024
keep if year==2024

ta country everyday [iweight=wgt], row nofreq


****************************************
* END


