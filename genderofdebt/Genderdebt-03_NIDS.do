*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 12, 2026
*-----
gl link = "genderofdebt"
*Prepa database National Income Dynamics Study
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* 2008
****************************************
use"raw/National_Income_Dynamics/NIDS_w1_2008/Adult_W1_Anon_V7.0.0.dta", clear

* Indiv
rename w1_hhid hhid
rename w1_a_gen sex
rename w1_a_lng lang
rename w1_a_marstt maritalstatus
rename w1_a_dob_y dob_y
rename w1_a_popgrp popgroup
rename w1_a_bhlive bhlive
rename w1_a_bhlive_n bhlive_n

* Debt
rename w1_a_dtcre_b creditcarddebtamount
rename w1_a_dtbnd homeloan
rename w1_a_dtbnd_b homeloan_b
rename w1_a_dtbnk persobank
rename w1_a_dtbnk_b persobank_b
rename w1_a_dtmic microlen
rename w1_a_dtmic_b microlen_b
rename w1_a_dtmsh mashonisa
rename w1_a_dtmsh_b mashonisa_b
rename w1_a_dtstubnk studybank
rename w1_a_dtstubnk_b studybank_b
rename w1_a_dtstuo studyinstit
rename w1_a_dtstuo_b studyinstit_b
rename w1_a_dtloan famfriloan
rename w1_a_dtloan_b famfriloan_b

* Finance
rename w1_a_asacc bankaccount
rename w1_a_asfin shares

* keep
keep hhid pid sex lang maritalstatus dob_y popgroup bhlive bhlive_n creditcarddebtamount homeloan homeloan_b persobank persobank_b microlen microlen_b mashonisa mashonisa_b studybank studybank_b studyinstit studyinstit_b famfriloan famfriloan_b bankaccount shares
gen year=2008

fre sex

save"NIDS_2008.dta", replace
****************************************
* END






****************************************
* 2010
****************************************
use"raw/National_Income_Dynamics/NIDS_w2_2010/Adult_W2_Anon_V4.0.0.dta", clear

* Indiv
rename w2_hhid hhid
rename w2_a_gen sex
rename w2_a_lng lang
rename w2_a_marstt maritalstatus
rename w2_a_dob_y dob_y
rename w2_a_popgrp popgroup
rename w2_a_bhlive bhlive
rename w2_a_bhlive_n bhlive_n

* Debt
rename w2_a_dtcre_b creditcarddebtamount
rename w2_a_dtbnd homeloan
rename w2_a_dtbnd_b homeloan_b
rename w2_a_dtbnk persobank
rename w2_a_dtbnk_b persobank_b
rename w2_a_dtmic microlen
rename w2_a_dtmic_b microlen_b
rename w2_a_dtmsh mashonisa
rename w2_a_dtmsh_b mashonisa_b
rename w2_a_dtstubnk studybank
rename w2_a_dtstubnk_b studybank_b
rename w2_a_dtstuo studyinstit
rename w2_a_dtstuo_b studyinstit_b
rename w2_a_dtflloan famloan
rename w2_a_dtflloan_b famloan_b
rename w2_a_dtfrloan friloan
rename w2_a_dtfrloan_b friloan_b
rename w2_a_dtemploan emploan
rename w2_a_dtemploan_b emploan_b

* Finance
rename w2_a_asacc bankaccount
rename w2_a_aslifeins lifeinsur
rename w2_a_aspen pension
rename w2_a_asfin shares

* keep
keep hhid pid sex lang maritalstatus dob_y popgroup bhlive bhlive_n creditcarddebtamount homeloan homeloan_b persobank persobank_b microlen microlen_b mashonisa mashonisa_b studybank studybank_b studyinstit studyinstit_b famloan famloan_b friloan friloan_b emploan emploan_b bankaccount lifeinsur pension shares
gen year=2010

fre sex

save"NIDS_2010.dta", replace
****************************************
* END






****************************************
* 2012
****************************************
use"raw/National_Income_Dynamics/NIDS_w3_2012/Adult_W3_Anon_V3.0.0.dta", clear

* Indiv
rename w3_hhid hhid
rename w3_a_gen sex
rename w3_a_lng lang
rename w3_a_marstt maritalstatus
rename w3_a_dob_y dob_y
rename w3_a_popgrp popgroup
rename w3_a_bhlive bhlive
rename w3_a_bhlive_n bhlive_n

* Debt
rename w3_a_dtcre_b creditcarddebtamount
rename w3_a_dtbnd homeloan
rename w3_a_dtbnd_b homeloan_b
rename w3_a_dtbnk persobank
rename w3_a_dtbnk_b persobank_b
rename w3_a_dtmic microlen
rename w3_a_dtmic_b microlen_b
rename w3_a_dtmsh mashonisa
rename w3_a_dtmsh_b mashonisa_b
rename w3_a_dtstubnk studybank
rename w3_a_dtstubnk_b studybank_b
rename w3_a_dtstuo studyinstit
rename w3_a_dtstuo_b studyinstit_b
rename w3_a_dtloan famfriloan
rename w3_a_dtloan_b famfriloan_b

* Finance
rename w3_a_asacc bankaccount
rename w3_a_aspen pension
rename w3_a_asfin shares

* keep
keep hhid pid sex lang maritalstatus dob_y popgroup bhlive bhlive_n creditcarddebtamount homeloan homeloan_b persobank persobank_b microlen microlen_b mashonisa mashonisa_b studybank studybank_b studyinstit studyinstit_b famfriloan famfriloan_b bankaccount pension shares
gen year=2012

fre sex

save"NIDS_2012.dta", replace
****************************************
* END






****************************************
* 2014
****************************************
use"raw/National_Income_Dynamics/NIDS_w4_2014/Adult_W4_Anon_V2.0.0.dta", clear

* Indiv
rename w4_hhid hhid
rename w4_a_gen sex
rename w4_a_lng lang
rename w4_a_dob_y dob_y
rename w4_a_popgrp popgroup
rename w4_a_bhlive bhlive
rename w4_a_bhlive_n bhlive_n

* Debt
rename w4_a_dtcre_b creditcarddebtamount
rename w4_a_dtbnd homeloan
rename w4_a_dtbnd_b homeloan_b
rename w4_a_dtbnk persobank
rename w4_a_dtbnk_b persobank_b
rename w4_a_dtmic microlen
rename w4_a_dtmic_b microlen_b
rename w4_a_dtmsh mashonisa
rename w4_a_dtmsh_b mashonisa_b
rename w4_a_dtstubnk studybank
rename w4_a_dtstubnk_b studybank_b
rename w4_a_dtstuo studyinstit
rename w4_a_dtstuo_b studyinstit_b
rename w4_a_dtflloan famloan
rename w4_a_dtflloan_b famloan_b
rename w4_a_dtfrloan friloan
rename w4_a_dtfrloanbal friloan_b
rename w4_a_dtemploan emploan
rename w4_a_dtemploan_b emploan_b

* Finance
rename w4_a_asacc bankaccount
rename w4_a_aslifeins lifeinsur
rename w4_a_aspen pension
rename w4_a_asfin shares

* keep
keep hhid pid sex lang dob_y popgroup bhlive bhlive_n creditcarddebtamount homeloan homeloan_b persobank persobank_b microlen microlen_b mashonisa mashonisa_b studybank studybank_b studyinstit studyinstit_b famloan famloan_b friloan friloan_b emploan emploan_b bankaccount lifeinsur pension shares
gen year=2014


save"NIDS_2014.dta", replace
****************************************
* END









****************************************
* 2017
****************************************
use"raw/National_Income_Dynamics/NIDS_w5_2017/Adult_W5_Anon_V1.0.0.dta", clear


* Indiv
rename w5_hhid hhid
rename w5_a_gen sex
rename w5_a_lng lang
rename w5_a_dob_y dob_y
rename w5_a_popgrp popgroup
rename w5_a_bhlive bhlive
rename w5_a_bhlive_n bhlive_n

* Debt
rename w5_a_dtcre_b creditcarddebtamount
rename w5_a_dtbnd homeloan
rename w5_a_dtbnd_b homeloan_b
rename w5_a_dtbnk persobank
rename w5_a_dtbnk_b persobank_b
rename w5_a_dtmic microlen
rename w5_a_dtmic_b microlen_b
rename w5_a_dtmsh mashonisa
rename w5_a_dtmsh_b mashonisa_b
rename w5_a_dtstubnk studybank
rename w5_a_dtstubnk_b studybank_b
rename w5_a_dtstuo studyinstit
rename w5_a_dtstuo_b studyinstit_b
rename w5_a_dtflloan famloan
rename w5_a_dtflloan_b famloan_b
rename w5_a_dtfrloan friloan
rename w5_a_dtfrloanbal friloan_b
rename w5_a_dtemploan emploan
rename w5_a_dtemploan_b emploan_b

* Finance
rename w5_a_asacc bankaccount
rename w5_a_aslifeins lifeinsur
rename w5_a_aspen pension
rename w5_a_asfin shares

* keep
keep hhid pid sex lang dob_y popgroup bhlive bhlive_n creditcarddebtamount homeloan homeloan_b persobank persobank_b microlen microlen_b mashonisa mashonisa_b studybank studybank_b studyinstit studyinstit_b famloan famloan_b friloan friloan_b emploan emploan_b bankaccount lifeinsur pension shares
gen year=2017


save"NIDS_2017.dta", replace
****************************************
* END











****************************************
* Append
****************************************
use"NIDS_2008.dta", clear

append using "NIDS_2010"
append using "NIDS_2012"
append using "NIDS_2014"
append using "NIDS_2017"

order hhid year pid
sort year hhid pid

* Selection
fre sex
drop if sex==-8
drop if sex==.


***** Cleaning
* Fam fri
replace famfriloan=1 if famloan==1 & famfriloan==.
replace famfriloan=2 if famloan==2 & famfriloan==.
replace famfriloan=1 if friloan==1 & famfriloan==.
replace famfriloan=2 if friloan==2 & famfriloan==.
replace famfriloan_b=famloan_b if famfriloan_b==. & famloan_b!=.
replace famfriloan_b=friloan_b if famfriloan_b==. & friloan_b!=.

* Y var
foreach x in homeloan persobank microlen mashonisa studybank studyinstit famfriloan {
gen `x'_n=.
}
foreach x in homeloan persobank microlen mashonisa studybank studyinstit famfriloan {
replace `x'_n=0 if `x'==2
replace `x'_n=1 if `x'==1
drop `x'
rename `x'_n `x'
}

* Age
gen age=year-dob_y
ta age
drop if age<18
drop if age>90

save"NIDS_panel_v0.dta", replace
****************************************
* END










****************************************
* Diff
****************************************
use"NIDS_panel_v0.dta", clear

* Cleaning
drop if popgroup<0
drop if lang<0
drop if maritalstatus<0

* Probit recourse to certain sources of loan
cls
foreach y in homeloan persobank microlen mashonisa studybank studyinstit famfriloan {
probit `y' i.sex c.age i.popgroup i.lang i.maritalstatus i.year, cluster(hhid)
}

* Reg amount
cls
foreach y in homeloan_b persobank_b microlen_b mashonisa_b studybank_b studyinstit_b famfriloan_b creditcarddebtamount {
reg `y' i.sex c.age i.popgroup i.lang i.maritalstatus i.year, cluster(hhid)
}


****************************************
* END
