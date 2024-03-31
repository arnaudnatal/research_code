*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 14, 2023
*-----
gl link = "marriageagri"
*Base HH
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------








****************************************
* RUME
****************************************
use"raw/RUME-HH.dta", clear

keep HHID2010 ownland sizeownland 
duplicates drop

merge 1:1 HHID2010 using "raw/RUME-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

merge 1:1 HHID2010 using "raw/RUME-assets"
drop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000
drop _merge

merge 1:1 HHID2010 using "raw/RUME-loans_HH", keepusing(nbloans_HH loanamount_HH nbHH_given_agri dumHH_given_agri nbHH_given_fami dumHH_given_fami nbHH_given_heal dumHH_given_heal nbHH_given_repa dumHH_given_repa nbHH_given_hous dumHH_given_hous nbHH_given_inve dumHH_given_inve nbHH_given_cere dumHH_given_cere nbHH_given_marr dumHH_given_marr nbHH_given_educ dumHH_given_educ nbHH_given_rela dumHH_given_rela nbHH_given_deat dumHH_given_deat nbHH_givencat_econ dumHH_givencat_econ nbHH_givencat_curr dumHH_givencat_curr nbHH_givencat_huma dumHH_givencat_huma nbHH_givencat_soci dumHH_givencat_soci nbHH_givencat_hous dumHH_givencat_hous nbHH_effective_agri dumHH_effective_agri nbHH_effective_fami dumHH_effective_fami nbHH_effective_heal dumHH_effective_heal nbHH_effective_repa dumHH_effective_repa nbHH_effective_hous dumHH_effective_hous nbHH_effective_inve dumHH_effective_inve nbHH_effective_cere dumHH_effective_cere nbHH_effective_marr dumHH_effective_marr nbHH_effective_educ dumHH_effective_educ nbHH_effective_rela dumHH_effective_rela nbHH_effective_deat dumHH_effective_deat totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat)
drop _merge

gen year=2010

*** Panel
merge 1:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

rename HHID2010 HHID

save "RUME_v1.dta", replace
****************************************
* END









****************************************
* NEEMSIS-1
****************************************
use"raw/NEEMSIS1-HH.dta", clear

* Education expenses by sex
fre sex
gen educationexpenses_male=.
replace educationexpenses_male=educationexpenses if sex==1
gen educationexpenses_female=.
replace educationexpenses_female=educationexpenses if sex==2
bysort HHID2016: egen educexp_male_HH=sum(educationexpenses_male)
bysort HHID2016: egen educexp_female_HH=sum(educationexpenses_female)
bysort HHID2016: egen educexp_HH=sum(educationexpenses)


* Dummy marriage
fre dummymarriage
fre marriedlistdummy
fre sex
ta marriedlistdummy sex
gen dummymarriage_male=0
replace dummymarriage_male=1 if marriedlistdummy==1 & sex==1
gen dummymarriage_female=0
replace dummymarriage_female=1 if marriedlistdummy==1 & sex==2
bysort HHID2016: egen max_dummymarriage_male=max(dummymarriage_male)
bysort HHID2016: egen max_dummymarriage_female=max(dummymarriage_female)
drop dummymarriage_male dummymarriage_female
rename max_dummymarriage_male dummymarriage_male
rename max_dummymarriage_female dummymarriage_female


* Mariage expenses by sex
fre sex
gen marriageexpenses_male=.
replace marriageexpenses_male=marriageexpenses if sex==1
gen marriageexpenses_female=.
replace marriageexpenses_female=marriageexpenses if sex==2
bysort HHID2016: egen marrexp_male_HH=sum(marriageexpenses_male)
bysort HHID2016: egen marrexp_female_HH=sum(marriageexpenses_female)
bysort HHID2016: egen marrexp_HH=sum(marriageexpenses)

fre sex
gen marriagecost_male=.
replace marriagecost_male=marriagetotalcost if sex==1
gen marriagecost_female=.
replace marriagecost_female=marriagetotalcost if sex==2
bysort HHID2016: egen marrcos_male_HH=sum(marriagecost_male)
bysort HHID2016: egen marrcos_female_HH=sum(marriagecost_female)
bysort HHID2016: egen marrcos_HH=sum(marriagetotalcost)

* Dowry by sex
fre sex
gen marriagedowry_male=.
replace marriagedowry_male=marriagedowry if sex==1
gen marriagedowry_female=.
replace marriagedowry_female=marriagedowry if sex==2
bysort HHID2016: egen marrdow_male_HH=sum(marriagedowry_male)
bysort HHID2016: egen marrdow_female_HH=sum(marriagedowry_female)
bysort HHID2016: egen marrdow_HH=sum(marriagedowry)


* As for RUME but with expenses
keep HHID2016 ownland sizeownland educexp_male_HH educexp_female_HH educexp_HH marrexp_male_HH marrexp_female_HH marrexp_HH marrcos_male_HH marrcos_female_HH marrcos_HH dummymarriage_male dummymarriage_female dummymarriage marrdow_male_HH marrdow_female_HH marrdow_HH
duplicates drop 

merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

merge 1:1 HHID2016 using "raw/NEEMSIS1-assets"
drop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000
drop _merge

merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbloans_HH loanamount_HH nbHH_given_agri dumHH_given_agri nbHH_given_fami dumHH_given_fami nbHH_given_heal dumHH_given_heal nbHH_given_repa dumHH_given_repa nbHH_given_hous dumHH_given_hous nbHH_given_inve dumHH_given_inve nbHH_given_cere dumHH_given_cere nbHH_given_marr dumHH_given_marr nbHH_given_educ dumHH_given_educ nbHH_given_rela dumHH_given_rela nbHH_given_deat dumHH_given_deat nbHH_givencat_econ dumHH_givencat_econ nbHH_givencat_curr dumHH_givencat_curr nbHH_givencat_huma dumHH_givencat_huma nbHH_givencat_soci dumHH_givencat_soci nbHH_givencat_hous dumHH_givencat_hous nbHH_effective_agri dumHH_effective_agri nbHH_effective_fami dumHH_effective_fami nbHH_effective_heal dumHH_effective_heal nbHH_effective_repa dumHH_effective_repa nbHH_effective_hous dumHH_effective_hous nbHH_effective_inve dumHH_effective_inve nbHH_effective_cere dumHH_effective_cere nbHH_effective_marr dumHH_effective_marr nbHH_effective_educ dumHH_effective_educ nbHH_effective_rela dumHH_effective_rela nbHH_effective_deat dumHH_effective_deat totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat)
drop _merge

gen year=2016

*** Panel
merge 1:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

rename HHID2016 HHID

save "NEEMSIS1_v1.dta", replace
****************************************
* END














****************************************
* NEEMSIS-2
****************************************
use"raw/NEEMSIS2-HH.dta", clear

* Education expenses by sex
fre sex
gen educationexpenses_male=.
replace educationexpenses_male=educationexpenses if sex==1
gen educationexpenses_female=.
replace educationexpenses_female=educationexpenses if sex==2
bysort HHID2020: egen educexp_male_HH=sum(educationexpenses_male)
bysort HHID2020: egen educexp_female_HH=sum(educationexpenses_female)
bysort HHID2020: egen educexp_HH=sum(educationexpenses)

* Dummy marriage
fre dummymarriage
fre dummy_marriedlist
fre sex
ta dummy_marriedlist sex
gen dummymarriage_male=0
replace dummymarriage_male=1 if dummy_marriedlist==1 & sex==1
gen dummymarriage_female=0
replace dummymarriage_female=1 if dummy_marriedlist==1 & sex==2
bysort HHID2020: egen max_dummymarriage_male=max(dummymarriage_male)
bysort HHID2020: egen max_dummymarriage_female=max(dummymarriage_female)
drop dummymarriage_male dummymarriage_female
rename max_dummymarriage_male dummymarriage_male
rename max_dummymarriage_female dummymarriage_female

* Mariage expenses by sex
fre sex
gen marriageexpenses_male=.
replace marriageexpenses_male=marriageexpenses if sex==1
gen marriageexpenses_female=.
replace marriageexpenses_female=marriageexpenses if sex==2
bysort HHID2020: egen marrexp_male_HH=sum(marriageexpenses_male)
bysort HHID2020: egen marrexp_female_HH=sum(marriageexpenses_female)
bysort HHID2020: egen marrexp_HH=sum(marriageexpenses)

fre sex
gen marriagecost_male=.
replace marriagecost_male=marriagetotalcost if sex==1
gen marriagecost_female=.
replace marriagecost_female=marriagetotalcost if sex==2
bysort HHID2020: egen marrcos_male_HH=sum(marriagecost_male)
bysort HHID2020: egen marrcos_female_HH=sum(marriagecost_female)
bysort HHID2020: egen marrcos_HH=sum(marriagetotalcost)

* Dowry by sex
fre sex
gen marriagedowry_male=.
replace marriagedowry_male=marriagedowry if sex==1
gen marriagedowry_female=.
replace marriagedowry_female=marriagedowry if sex==2
bysort HHID2020: egen marrdow_male_HH=sum(marriagedowry_male)
bysort HHID2020: egen marrdow_female_HH=sum(marriagedowry_female)
bysort HHID2020: egen marrdow_HH=sum(marriagedowry)


* As for RUME but with expenses
keep HHID2020 ownland sizeownland educexp_male_HH educexp_female_HH educexp_HH marrexp_male_HH marrexp_female_HH marrexp_HH marrcos_male_HH marrcos_female_HH marrcos_HH dummymarriage_male dummymarriage_female dummymarriage marrdow_male_HH marrdow_female_HH marrdow_HH
duplicates drop

merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(incomeagri_HH incomenonagri_HH annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

merge 1:1 HHID2020 using "raw/NEEMSIS2-assets"
drop assets_total1000 assets_totalnoland1000 assets_totalnoprop1000
drop _merge

merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbloans_HH loanamount_HH nbHH_given_agri dumHH_given_agri nbHH_given_fami dumHH_given_fami nbHH_given_heal dumHH_given_heal nbHH_given_repa dumHH_given_repa nbHH_given_hous dumHH_given_hous nbHH_given_inve dumHH_given_inve nbHH_given_cere dumHH_given_cere nbHH_given_marr dumHH_given_marr nbHH_given_educ dumHH_given_educ nbHH_given_rela dumHH_given_rela nbHH_given_deat dumHH_given_deat nbHH_givencat_econ dumHH_givencat_econ nbHH_givencat_curr dumHH_givencat_curr nbHH_givencat_huma dumHH_givencat_huma nbHH_givencat_soci dumHH_givencat_soci nbHH_givencat_hous dumHH_givencat_hous nbHH_effective_agri dumHH_effective_agri nbHH_effective_fami dumHH_effective_fami nbHH_effective_heal dumHH_effective_heal nbHH_effective_repa dumHH_effective_repa nbHH_effective_hous dumHH_effective_hous nbHH_effective_inve dumHH_effective_inve nbHH_effective_cere dumHH_effective_cere nbHH_effective_marr dumHH_effective_marr nbHH_effective_educ dumHH_effective_educ nbHH_effective_rela dumHH_effective_rela nbHH_effective_deat dumHH_effective_deat totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat)
drop _merge

gen year=2020

*** Panel
merge 1:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

rename HHID2020 HHID

save "NEEMSIS2_v1.dta", replace
****************************************
* END










****************************************
* Append
****************************************
use"RUME_v1", clear

append using "NEEMSIS1_v1"
append using "NEEMSIS2_v1"

********** Caste
merge 1:1 HHID_panel year using "raw/Panel-Caste_HH_long.dta", keepusing(jatiscorr caste)
drop _merge

rename jatiscorr jatis

order HHID_panel HHID year jatis caste
sort HHID_panel year


********** Diversified household?
* 
label define divHH 1"Agricultural household" 2"Non-agricultural household" 3"Diversified household"
gen divHH0=.
replace divHH0=1 if shareincomeagri_HH==1
replace divHH0=2 if shareincomeagri_HH==0
replace divHH0=3 if shareincomeagri_HH!=0 & shareincomeagri_HH!=1 & shareincomeagri_HH!=.
label values divHH0 divHH
fre divHH0
gen divHH5=.
replace divHH5=1 if shareincomeagri_HH>=0.95
replace divHH5=2 if shareincomeagri_HH<=0.05
replace divHH5=3 if shareincomeagri_HH>0.05 & shareincomeagri_HH<0.95 & shareincomeagri_HH!=.
label values divHH5 divHH
fre divHH5
gen divHH10=.
replace divHH10=1 if shareincomeagri_HH>=0.9
replace divHH10=2 if shareincomeagri_HH<=0.1
replace divHH10=3 if shareincomeagri_HH>0.1 & shareincomeagri_HH<0.9 & shareincomeagri_HH!=.
label values divHH10 divHH
fre divHH10


********** Deflate
foreach x in incomeagri_HH incomenonagri_HH annualincome_HH expenses_total expenses_food expenses_educ expenses_heal expenses_cere expenses_agri assets_housevalue assets_livestock assets_goods assets_ownland assets_gold assets_total assets_totalnoland assets_totalnoprop totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat educexp_male_HH educexp_female_HH educexp_HH marrexp_male_HH marrexp_female_HH marrexp_HH marrcos_male_HH marrcos_female_HH marrcos_HH expenses_marr marrdow_male_HH marrdow_female_HH marrdow_HH {
replace `x'=`x'*(100/158) if year==2016
replace `x'=`x'*(100/184) if year==2020
}



********** Cleaning 
drop expenses_educ
recode ownland (.=0)



********** Dummy invest educ
gen dumeducexp_male_HH=0
replace dumeducexp_male_HH=1 if educexp_male_HH!=. & educexp_male_HH>0

gen dumeducexp_female_HH=0
replace dumeducexp_female_HH=1 if educexp_female_HH!=. & educexp_female_HH>0

label values dumeducexp_male_HH yesno
label values dumeducexp_female_HH yesno




* Time
gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

* Assets class
xtile assets2010=assets_total if year==2010, n(3)
xtile assets2016=assets_total if year==2016, n(3)
xtile assets2020=assets_total if year==2020, n(3)
gen assets_q=.
replace assets_q=assets2010 if year==2010
replace assets_q=assets2016 if year==2016
replace assets_q=assets2020 if year==2020
label define tercass 1"Assets: T1" 2"Assets: T2" 3"Assets: T3"
label values assets_q tercass
drop assets2010 assets2016 assets2020

* Income class
xtile income2010=annualincome_HH if year==2010, n(3)
xtile income2016=annualincome_HH if year==2016, n(3)
xtile income2020=annualincome_HH if year==2020, n(3)
gen income_q=.
replace income_q=income2010 if year==2010
replace income_q=income2016 if year==2016
replace income_q=income2020 if year==2020
label define tercinc 1"Income: T1" 2"Income: T2" 3"Income: T3"
label values income_q tercinc
drop income2010 income2016 income2020

ta income_q year, col nofreq
ta assets_q year, col nofreq

* Caste
label define caste2 1"Dalits" 2"Middle castes" 3"Upper castes"
label values caste caste2


save"panel_HH", replace
****************************************
* END
