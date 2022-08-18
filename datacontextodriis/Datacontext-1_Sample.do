*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*September 30, 2021
*-----
gl link = "datacontextodriis"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Copy + paste
****************************************
********** RUME
use"$datarume\\$wave1", clear
save"$directory\\$wave1", replace
use"$datarume\\$loan1", clear
save"$directory\\$loan1", replace


********** NEEMSIS-1
use"$dataneemsis1\\$wave2", clear
save"$directory\\$wave2", replace
use"$dataneemsis1\\$loan2", clear
save"$directory\\$loan2", replace

********** NEEMSIS-2
use"$dataneemsis2\\$wave3", clear
save"$directory\\$wave3", replace
use"$dataneemsis2\\$loan3", clear
save"$directory\\$loan3", replace

********** Tracking 1
use"$datatracking1\NEEMSIS1-tracking.dta", clear
save"$directory\NEEMSIS1-tracking.dta", replace

********** ODRIIS HH and indiv
use"$datapanel\ODRIIS-HH_long.dta", clear
save"$directory\ODRIIS-HH_long.dta", replace
use"$datapanel\ODRIIS-HH_wide.dta", clear
save"$directory\ODRIIS-HH_wide.dta", replace
use"$datapanel\ODRIIS-indiv_long.dta", clear
save"$directory\ODRIIS-indiv_long.dta", replace



********** Caste new var
use"$directory\ODRIIS-HH_long.dta", clear
use"$directory\ODRIIS-indiv_long.dta", clear

use"$directory\\$wave1", clear
merge m:1 HHID_panel year using "$directory\ODRIIS-HH_long.dta", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr castecorr_HH
merge 1:1 HHID_panel INDID_panel year using "$directory\ODRIIS-indiv_long.dta", keepusing(castecorr jatiscorr agecorr)
keep if _merge==3
drop _merge
save"$directory\\$wave1~v2", replace

use"$directory\\$wave2", clear
merge m:1 HHID_panel year using "$directory\ODRIIS-HH_long.dta", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr castecorr_HH
merge 1:1 HHID_panel INDID_panel year using "$directory\ODRIIS-indiv_long.dta", keepusing(castecorr jatiscorr agecorr)
keep if _merge==3
drop _merge
save"$directory\\$wave2~v2", replace

use"$directory\\$wave3", clear
merge m:1 HHID_panel year using "$directory\ODRIIS-HH_long.dta", keepusing(castecorr)
keep if _merge==3
drop _merge
rename castecorr castecorr_HH
merge 1:1 HHID_panel INDID_panel year using "$directory\ODRIIS-indiv_long.dta", keepusing(castecorr jatiscorr agecorr)
keep if _merge==3
drop _merge
save"$directory\\$wave3~v2", replace

****************************************
* END









****************************************
* Sample
****************************************

********** RUME
use"$directory\\$wave1~v2", clear
duplicates drop HHID_panel, force
ta villageid



********** NEEMSIS-1
use"$directory\\$wave2~v2", clear
ta egoid sex if egoid!=0
duplicates drop HHID_panel, force
ta villageid
ta villageid_new

***** Clubbing
clonevar villageid_new2=villageid_new
replace villageid_new2="TIRUP_reg" if villageid_new=="Somanur" | villageid_new=="Tiruppur" | villageid_new=="Chinnaputhur"
fre villageid_new2

ta villageid villageid_new if tracked==1


********** NEEMSIS-2
use"$directory\\$wave3~v2", clear
ta egoid sex if egoid!=0
duplicates drop HHID_panel, force
ta villageid



********** Tracking-1
use"$directory\NEEMSIS1-tracking.dta", clear

keep if name==namemigrant
fre caste
ta casteother
rename caste jatis
gen caste=.
replace caste=1 if jatis==2

replace caste=2 if jatis==1
replace caste=2 if jatis==12
replace caste=2 if jatis==16

replace caste=3 if jatis==4
replace caste=3 if jatis==6
replace caste=3 if jatis==11
replace caste=3 if jatis==77 & casteother=="Yadhavar"

gen edulevel=.
replace edulevel = 0 if  everattendedschool == 0
replace edulevel = 0 if classcompleted < 5 & classcompleted != .
replace edulevel= 1 if classcompleted>=5 & classcompleted != .
replace edulevel= 2 if classcompleted>=8 & classcompleted != .
replace edulevel= 3 if classcompleted>=11 & classcompleted != .
replace edulevel= 4 if classcompleted>=15  & classcompleted != .
replace edulevel= 5 if classcompleted>=16  & classcompleted != . //Attention! I recoded here cause otherwise all missing are in 5 (Anne, 20/06/17)
label define edulevel 0 "Below primary" 1 "Primary completed", modify
label define edulevel 2 "High school (8th-10th)", modify
label define edulevel 3 "HSC/Diploma (11th-12th)", modify
label define edulevel 4 "Bachelors (13th-15th)", modify
label define edulevel 5 "Post graduate (15th and more)", modify
label values edulevel edulevel
ta edulevel

ta sex
ta caste
sum age
ta edulevel

fre migrationareatype
fre migmigration1type
fre migmigration1type2

ta migmigration1reason

foreach i in 1 2 3 4 5 6 7 8 9 10 77 {
gen reason`i'=0 if migmigration1type2==2
replace reason`i'=1 if strpos(migmigration1reason, "`i'")
ta reason`i'
}

****************************************
* END









****************************************
* Individual level stat
****************************************

********** RUME
use"$directory\\$wave1~v2", clear

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq
tabstat age, stat(n mean) by(sex)

********** NEEMSIS-1
use"$directory\\$wave2~v2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq
tabstat age, stat(n mean) by(sex)

********** NEEMSIS-2
use"$directory\\$wave3~v2", clear

fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.

fre working_pop
drop if working_pop==1
fre worker

ta sex
ta mainocc_occupation_indiv sex, col nofreq
ta edulevel sex, col nofreq
tabstat age, stat(n mean) by(sex)
****************************************
* END









****************************************
* Household level: RUME
****************************************
use"$directory\\$wave1~v2", clear

bysort HHID_panel : egen HHsize=sum(1)

fre sex
gen male=0
replace male=1 if sex==1
gen female=0
replace female=1 if sex==2
bysort HHID_panel: egen nbmale=sum(male)
bysort HHID_panel: egen nbfemale=sum(female)
gen SR=nbmale/nbfemale
replace SR=nbmale if nbfemale==0

fre working_pop
gen actif=0
replace actif=1 if working_pop==2
replace actif=1 if working_pop==3
gen nonactif=0
replace nonactif=1 if working_pop==1
bysort HHID_panel: egen nbactif=sum(actif)
bysort HHID_panel: egen nbnonactif=sum(nonactif)
gen DR=nbnonactif/nbactif
ta DR

ta loans_HH
gen dummyloan=0
replace dummyloan=1 if loans_HH>=1 

gen shareagri=(occinc_HH_agri+occinc_HH_agricasual)*100/annualincome_HH
gen sharenonagri=(occinc_HH_nonagricasual+occinc_HH_nonagriregnonqual+occinc_HH_nonagriregqual+occinc_HH_selfemp+occinc_HH_nrega)*100/annualincome_HH
gen test=shareagri+sharenonagri
ta test
replace sharenonagri=100-shareagri if test<99 & shareagri!=0
replace shareagri=100-sharenonagri if test<99 & sharenonagri!=0
drop test

keep HHID_panel castecorr_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype dummyloan shareagri sharenonagri
duplicates drop HHID_panel, force
replace assets=assets/1000
replace assets_noland=assets_noland/1000
replace annualincome_HH=annualincome_HH/1000
replace loanamount_HH=loanamount_HH/1000
recode ownland (.=0)

***** Tables
cls
ta castecorr_HH
tabstat HHsize SR DR, stat(mean) by(castecorr_HH)
ta housetype castecorr_HH, col nofreq
ta ownland castecorr_HH, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(castecorr_HH)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(castecorr_HH)
tabstat sharenonagri, stat(n mean sd p50) by(castecorr_HH)
ta dummyloan castecorr_HH, col nofreq
tabstat loanamount_HH if dummyloan==1, stat(n mean sd p50) by(castecorr_HH)
****************************************
* END








****************************************
* Household level: NEEMSIS-1
****************************************
use"$directory\\$wave2~v2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4

bysort HHID_panel : egen HHsize=sum(1)

fre sex
gen male=0
replace male=1 if sex==1
gen female=0
replace female=1 if sex==2
bysort HHID_panel: egen nbmale=sum(male)
bysort HHID_panel: egen nbfemale=sum(female)
gen SR=nbmale/nbfemale
replace SR=nbmale if nbfemale==0

fre working_pop
gen actif=0
replace actif=1 if working_pop==2
replace actif=1 if working_pop==3
gen nonactif=0
replace nonactif=1 if working_pop==1
bysort HHID_panel: egen nbactif=sum(actif)
bysort HHID_panel: egen nbnonactif=sum(nonactif)
gen DR=nbnonactif/nbactif
ta DR

ta loans_HH
gen dummyloan=0
replace dummyloan=1 if loans_HH>=1 

gen shareagri=(occinc_HH_agri+occinc_HH_agricasual)*100/annualincome_HH
gen sharenonagri=(occinc_HH_nonagricasual+occinc_HH_nonagriregnonqual+occinc_HH_nonagriregqual+occinc_HH_selfemp+occinc_HH_nrega)*100/annualincome_HH
gen test=shareagri+sharenonagri
ta test
drop test

keep HHID_panel castecorr_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype dummyloan shareagri sharenonagri
duplicates drop HHID_panel, force
replace assets=(assets/1000)*(100/158)
replace assets_noland=(assets_noland/1000)*(100/158)
replace annualincome_HH=(annualincome_HH/1000)*(100/158)
replace loanamount_HH=(loanamount_HH/1000)*(100/158)
recode ownland (.=0)

***** Tables
cls
ta castecorr_HH
tabstat HHsize SR DR, stat(mean) by(castecorr_HH)
ta housetype castecorr_HH, col nofreq
ta ownland castecorr_HH, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(castecorr_HH)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(castecorr_HH)
tabstat sharenonagri, stat(n mean sd p50) by(castecorr_HH)
ta dummyloan castecorr_HH, col nofreq
tabstat loanamount_HH if dummyloan==1, stat(n mean sd p50) by(castecorr_HH)
****************************************
* END







****************************************
* Household level: NEEMSIS-2
****************************************
use"$directory\\$wave3~v2", clear
fre livinghome
drop if livinghome==3
drop if livinghome==4
drop if INDID_left!=.

bysort HHID_panel : egen HHsize=sum(1)

fre sex
gen male=0
replace male=1 if sex==1
gen female=0
replace female=1 if sex==2
bysort HHID_panel: egen nbmale=sum(male)
bysort HHID_panel: egen nbfemale=sum(female)
gen SR=nbmale/nbfemale
replace SR=nbmale if nbfemale==0

fre working_pop
gen actif=0
replace actif=1 if working_pop==2
replace actif=1 if working_pop==3
gen nonactif=0
replace nonactif=1 if working_pop==1
bysort HHID_panel: egen nbactif=sum(actif)
bysort HHID_panel: egen nbnonactif=sum(nonactif)
gen DR=nbnonactif/nbactif
ta DR

ta loans_HH
gen dummyloan=0
replace dummyloan=1 if loans_HH>=1 

gen shareagri=(occinc_HH_agri+occinc_HH_agricasual)*100/annualincome_HH
gen sharenonagri=(occinc_HH_nonagricasual+occinc_HH_nonagriregnonqual+occinc_HH_nonagriregqual+occinc_HH_selfemp+occinc_HH_nrega)*100/annualincome_HH
gen test=shareagri+sharenonagri
ta test
drop test

keep HHID_panel castecorr_HH villageid HHsize ownland leaseland sizeownland assets_noland assets annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega loanamount_HH loans_HH SR DR housetype freehousescheme dummyloan shareagri sharenonagri
duplicates drop HHID_panel, force
replace assets=(assets/1000)*(100/184)
replace assets_noland=(assets_noland/1000)*(100/184)
replace annualincome_HH=(annualincome_HH/1000)*(100/184)
replace loanamount_HH=(loanamount_HH/1000)*(100/184)
destring ownland, replace
recode ownland (.=0)
destring housetype, replace
recode housetype (2=3)
replace housetype=2 if freehousescheme==1

***** Tables
cls
ta castecorr_HH
tabstat HHsize SR DR, stat(mean) by(castecorr_HH)
ta housetype castecorr_HH, col nofreq
ta ownland castecorr_HH, col nofreq
tabstat sizeownland if ownland==1, stat(n mean sd p50) by(castecorr_HH)
tabstat assets_noland annualincome_HH, stat(n mean sd p50) by(castecorr_HH)
tabstat sharenonagri, stat(n mean sd p50) by(castecorr_HH)
ta dummyloan castecorr_HH, col nofreq
tabstat loanamount_HH if dummyloan==1, stat(n mean sd p50) by(castecorr_HH)
****************************************
* END













****************************************
* Loan level: RUME
****************************************
use"$loan1", clear

preserve
use"ODRIIS-HH_wide.dta", clear
keep HHID_panel HHID2010 castecorr2010
rename castecorr2010 caste
keep if HHID2010!=""
save"ODRIIS-HH_wide2010", replace
restore

merge m:1 HHID2010 using "ODRIIS-HH_wide2010"
keep if _merge==3
drop _merge

drop if loansettled==1

*** Clientele using it
fre lender_cat
forvalues i=1(1)3{
gen lenders_`i'=0	
}
forvalues i=1(1)3{
replace lenders_`i'=1 if lender_cat==`i'
}
*
cls
preserve 
forvalues i=1(1)3{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lendersHH_`i' caste, m col nofreq
}
restore

*** Reason given
fre reason_cat
forvalues i=1(1)5{
gen reason_`i'=0
}
forvalues i=1(1)5{
replace reason_`i'=1 if reason_cat==`i'
}
*
cls
preserve 
forvalues i=1(1)5{
bysort HHID_panel: egen reasonHH_`i'=max(reason_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
tab caste year
cls
forvalues i=1(1)5{
tab reasonHH_`i' caste, m col nofreq
}
restore
****************************************
* END







****************************************
* Loan level: NEEMSIS-1
****************************************
use"$loan2", clear

preserve
use"ODRIIS-HH_wide.dta", clear
keep HHID_panel HHID2016 castecorr2016
rename castecorr2016 caste
keep if HHID2016!=""
save"ODRIIS-HH_wide2016", replace
restore

merge m:1 HHID2016 using "ODRIIS-HH_wide2016"
keep if _merge==3
drop _merge

drop if loansettled==1

*** Clientele using it
fre lender_cat
forvalues i=1(1)3{
gen lenders_`i'=0	
}
forvalues i=1(1)3{
replace lenders_`i'=1 if lender_cat==`i'
}
*
cls
preserve 
forvalues i=1(1)3{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lendersHH_`i' caste, m col nofreq
}
restore

*** Reason given
fre reason_cat
forvalues i=1(1)5{
gen reason_`i'=0
}
forvalues i=1(1)5{
replace reason_`i'=1 if reason_cat==`i'
}
*
cls
preserve 
forvalues i=1(1)5{
bysort HHID_panel: egen reasonHH_`i'=max(reason_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
tab caste year
cls
forvalues i=1(1)5{
tab reasonHH_`i' caste, m col nofreq
}
restore
****************************************
* END







****************************************
* Loan level: NEEMSIS-2
****************************************
use"$loan3", clear
drop caste

preserve
use"ODRIIS-HH_wide.dta", clear
keep HHID_panel HHID2020 castecorr2020
rename castecorr2020 caste
keep if HHID2020!=""
save"ODRIIS-HH_wide2020", replace
restore

merge m:1 HHID_panel using "ODRIIS-HH_wide2020"
keep if _merge==3
drop _merge

drop if loansettled==1

*** Clientele using it
fre lender_cat
forvalues i=1(1)3{
gen lenders_`i'=0	
}
forvalues i=1(1)3{
replace lenders_`i'=1 if lender_cat==`i'
}
*
cls
preserve 
forvalues i=1(1)3{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)3{
tab lendersHH_`i' caste, m col nofreq
}
restore

*** Reason given
fre reason_cat
forvalues i=1(1)5{
gen reason_`i'=0
}
forvalues i=1(1)5{
replace reason_`i'=1 if reason_cat==`i'
}
*
cls
preserve 
forvalues i=1(1)5{
bysort HHID_panel: egen reasonHH_`i'=max(reason_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
tab caste year
cls
forvalues i=1(1)5{
tab reasonHH_`i' caste, m col nofreq
}
restore
****************************************
* END
