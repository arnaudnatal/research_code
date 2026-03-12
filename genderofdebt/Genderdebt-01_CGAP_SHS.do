*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 12, 2026
*-----
gl link = "genderofdebt"
*Prepa database Smallholder Survey
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------





****************************************
* Bangladesh
****************************************
use"raw/CGAP_Smallholder_Household_Survey/Bangladesh_2016/cgap_national_survey_of_sh_hh_bgd_data_set_single_26_oct_16.dta", clear

* Rename indiv charact
rename I4 INDID
rename M_D2 relationshiptohead
rename M_D3 sex
rename M_D4 maritalstatus
rename M_D5 age
rename M_D6 everattendedschool
rename M_D7 currentlyatschool
rename A99 participateagriHH

* Debt
rename F58 indebt
rename F53_1 r_startbusi
rename F53_2 r_impcashbu
rename F53_3 r_buyinputs
rename F53_4 r_bigpurcha
rename F53_5 r_otheragri
rename F53_6 r_emergency
rename F53_7 r_schoolfee
rename F53_8 r_dailyexpe

* HH
rename Urb_rur area
rename INDSINGL_WGT indiv_weight
rename I7 interviewdate
rename I8 region
rename I9 district

*
keep HHID INDID relationshiptohead sex maritalstatus age everattendedschool currentlyatschool indebt r_* area indiv_weight interviewdate region district participateagriHH

gen country="Bangladesh"
gen year=2016



* To string
foreach x in region district {
decode `x', gen(`x'_str)
drop `x'
rename `x'_str `x'
}

save"BAN", replace
****************************************
* END






****************************************
* Côte d'Ivoire
****************************************
use"raw/CGAP_Smallholder_Household_Survey/Cotedivoire_2016/SH_CDI_Single.dta", clear

* Rename indiv charact
rename I4 INDID
rename D2 relationshiptohead
rename D3 sex
rename D4 maritalstatus
rename D5 age
rename D6 everattendedschool
rename D7 currentlyatschool
rename A99 participateagriHH

* Debt
rename F58 indebt
rename F53_1 r_startbusi
rename F53_2 r_impcashbu
rename F53_3 r_buyinputs
rename F53_4 r_bigpurcha
rename F53_5 r_otheragri
rename F53_6 r_emergency
rename F53_7 r_schoolfee
rename F53_8 r_dailyexpe

* HH
rename Urb_Rur area
rename INDSINGL_WGT indiv_weight
rename I7 interviewdate
rename I8 region

*
keep HHID INDID relationshiptohead sex maritalstatus age everattendedschool currentlyatschool indebt r_* area indiv_weight interviewdate region participateagriHH

gen country="Côte d'Ivoire"
gen year=2016



* To string
foreach x in region {
decode `x', gen(`x'_str)
drop `x'
rename `x'_str `x'
}

save"CIV", replace
****************************************
* END






****************************************
* Mozambique
****************************************
use"raw/CGAP_Smallholder_Household_Survey/Mozambique_2015/cgap_smallholder_household_survey_mzo_2015_single_feb_16.dta", clear

* Rename indiv charact
rename D2 relationshiptohead
rename D3 sex
rename D4 maritalstatus
rename D5 age
rename D6 everattendedschool
rename D7 currentlyatschool
rename A99 participateagriHH

* Debt
rename F58 indebt
rename F53_1 r_startbusi
rename F53_2 r_impcashbu
rename F53_3 r_buyinputs
rename F53_4 r_bigpurcha
rename F53_5 r_otheragri
rename F53_6 r_emergency
rename F53_7 r_schoolfee
rename F53_8 r_dailyexpe

* HH
rename urb_rur area
rename INDSIN_weight indiv_weight
rename I7 interviewdate
rename I8 region
rename I9 district

*
keep HHID relationshiptohead sex maritalstatus age everattendedschool currentlyatschool indebt r_* area indiv_weight interviewdate region district participateagriHH

gen country="Mozambique"
gen year=2015


* To string
foreach x in region district {
decode `x', gen(`x'_str)
drop `x'
rename `x'_str `x'
}

save"MZO", replace
****************************************
* END







****************************************
* Nigeria
****************************************
use"raw/CGAP_Smallholder_Household_Survey/Nigeria_2016/cgap_smallholder_household_survey_nga_2016_single_respondent_may_17.sav.dta", clear

* Rename indiv charact
rename I4 INDID
rename D2 relationshiptohead
rename D3 sex
rename D4 maritalstatus
rename D5 age
rename D6 everattendedschool
rename D7 currentlyatschool
rename A99 participateagriHH

* Debt
rename F58 indebt
rename F53_1 r_startbusi
rename F53_2 r_impcashbu
rename F53_3 r_buyinputs
rename F53_4 r_bigpurcha
rename F53_5 r_otheragri
rename F53_6 r_emergency
rename F53_7 r_schoolfee
rename F53_8 r_dailyexpe

* HH
rename Urb_Rur area
rename INDSINGL_WGT indiv_weight
rename I7 interviewdate
rename I8 region
rename I9 district

*
keep HHID INDID relationshiptohead sex maritalstatus age everattendedschool currentlyatschool indebt r_* area indiv_weight interviewdate region district participateagriHH

gen country="Nigeria"
gen year=2016



save"NIG", replace
****************************************
* END






****************************************
* Tanzania
****************************************
use"raw/CGAP_Smallholder_Household_Survey/Tanzania_2016/cgap_smallholder_household_survey_tza_2015_single_may_16.dta", clear

* Rename indiv charact
rename I2 HHID
rename I4 INDID
rename D2 relationshiptohead
rename D3 sex
rename D4 maritalstatus
rename D5 age
rename D6 everattendedschool
rename D7 currentlyatschool
rename A99 participateagriHH

* Debt
rename F58 indebt
rename F53_1 r_startbusi
rename F53_2 r_impcashbu
rename F53_3 r_buyinputs
rename F53_4 r_bigpurcha
rename F53_5 r_otheragri
rename F53_6 r_emergency
rename F53_7 r_schoolfee
rename F53_8 r_dailyexpe

* HH
rename Urb_rur area
rename INDSINGL_WGT indiv_weight
rename I7 interviewdate
rename I8 region
rename I9 district

*
keep HHID INDID relationshiptohead sex maritalstatus age everattendedschool currentlyatschool indebt r_* area indiv_weight interviewdate region district participateagriHH

gen country="Tanzania"
gen year=2016


* To string
foreach x in region district {
decode `x', gen(`x'_str)
drop `x'
rename `x'_str `x'
}

save"TZN", replace
****************************************
* END







****************************************
* Uganda
****************************************
use"raw/CGAP_Smallholder_Household_Survey/Uganda_2015/CGAP Smallholder Household Survey_UGA 2015_Single_Mar18.dta", clear

* Rename indiv charact
rename D2 relationshiptohead
rename D3 sex
rename D4 maritalstatus
rename D5 age
rename D6 everattendedschool
rename D7 currentlyatschool
rename A99 participateagriHH

* Debt
rename F58 indebt
rename F53_1 r_startbusi
rename F53_2 r_impcashbu
rename F53_3 r_buyinputs
rename F53_4 r_bigpurcha
rename F53_5 r_otheragri
rename F53_6 r_emergency
rename F53_7 r_schoolfee
rename F53_8 r_dailyexpe

* HH
rename Urb_rur area
rename INDSING_weight indiv_weight
rename I7 interviewdate
rename I8 region
rename I9 district

*
keep HHID relationshiptohead sex maritalstatus age everattendedschool currentlyatschool indebt r_* area indiv_weight interviewdate region district participateagriHH

gen country="Uganda"
gen year=2015


save"UGA", replace
****************************************
* END






****************************************
* Append
****************************************
use"BAN", clear

foreach x in CIV MZO UGA TZN NIG {
append using "`x'.dta"
}

*
drop interviewdate

* Cat en dummies
foreach x in r_startbusi r_impcashbu r_buyinputs r_bigpurcha r_otheragri r_emergency r_schoolfee r_dailyexpe {
recode `x' (2=0)
}


* Cat debt
gen daily=.
label define daily 0"Productive debt" 1"Daily indebtedness"
label values daily daily
foreach x in startbusi impcashbu buyinputs bigpurcha otheragri {
replace daily=0 if r_`x'==1
}
foreach x in emergency schoolfee dailyexpe {
replace daily=1 if r_`x'==1
}

* Encode country
encode country, gen(country_code)
drop country
rename country_code country

* Encode region
encode region, gen(region_code)
drop region
rename region_code region

* Dummymarried
gen married=0
replace married=1 if maritalstatus==2
ta maritalstatus married

save"CGAP_SHS_debt.dta", replace
erase"BAN.dta"
erase"CIV.dta"
erase"MZO.dta"
erase"UGA.dta"
erase"TZN.dta"
erase"NIG.dta"
****************************************
* END









****************************************
* Stat
****************************************
use"CGAP_SHS_debt.dta", clear


* Khi-2 (without weight)
ta daily sex, col nofreq chi2
ta daily sex, exp cchi2 chi2

ta r_dailyexpe sex, col nofreq chi2
ta r_dailyexpe sex, exp cchi2 chi2

*
probit r_dailyexpe i.sex i.married age i.everattendedschool i.country [iweight=indiv_weight]

*
probit r_emergency i.sex i.married age i.everattendedschool i.country [iweight=indiv_weight]

*
probit r_schoolfee i.sex i.married age i.everattendedschool i.country [iweight=indiv_weight]

*
probit daily i.sex i.married age i.everattendedschool i.country [iweight=indiv_weight]


****************************************
* END
