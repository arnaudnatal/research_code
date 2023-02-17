*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* Financial Vulnerability Index
****************************************
use"panel_v0", clear


********** RRGPL
gen dailyincome_pc=(annualincome_HH/365)/squareroot_HHsize
gen dailyusdincome_pc=dailyincome_pc/45.73
gen rrgpl=((dailyusdincome_pc-1.9)/1.9)*(-1)*100
ta rrgpl
replace rrgpl=100 if rrgpl>100
replace rrgpl=-100 if rrgpl<-100
*the more is the poorer
gen rrgpl2=rrgpl
replace rrgpl2=0 if rrgpl2<0
ta rrgpl2

********** ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.
replace isr=100 if isr>100
ta isr

********** TDR
gen tdr=totHH_givenamt_repa*100/loanamount_HH
replace tdr=0 if tdr==.
ta tdr


********** TAR
gen tar=totHH_givenamt_repa*100/assets_total
replace tar=0 if tar==.
replace tar=100 if tar>100
ta tar


********** DAR
gen dar=loanamount_HH*100/assets_total
replace dar=0 if dar==.
replace dar=500 if dar>500
sum dar


********* FVI
/*
2*tdr+2*isr+rrgpl2
tar+isr+rrgpl
*/
gen fvi=(tar+isr+rrgpl2)/3
ta fvi
sum fvi
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
         fvi |      1,529    12.26407    14.40752          0   72.46169
*/




********** AMPI
*** Range 70-130
* TDR
ta tar
gen a_tar=((tar-0)/(100-0))*60+70
sum a_tar

* ISR
ta isr
gen a_isr=((isr-0)/(100-0))*60+70
sum a_isr

* RRGPL
ta rrgpl
gen a_rrgpl=((rrgpl+100)/(100+100))*60+70
sum a_rrgpl


*** Mean, CV, and STD
egen M=rowmean(a_tar a_isr a_rrgpl)
egen S=rowsd(a_tar a_isr a_rrgpl)
gen cv=S/M


*** AMPI
gen ampi=M+S*cv
ta ampi

*** Clean
drop a_tar a_isr a_rrgpl M S cv
drop rrgpl
rename rrgpl2 rrgpl



sum fvi ampi



save"panel_v1", replace 
****************************************
* END














****************************************
* Others variables
****************************************
use"panel_v1", clear


********** Other var
* HH
encode HHID_panel, gen(panelvar)

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

* Village
encode villageid, gen(vill)

*Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Trap
gen dummytrap=0
replace dummytrap=1 if tdr>0

* Head sex
fre head_sex
gen head_female=.
replace head_female=0 if head_sex==1
replace head_female=1 if head_sex==2

ta head_sex head_female
label define head_female 0"Male" 1"Female"
label values head_female head_female

* Head occupation
fre head_mocc_occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)


* Head edulevel
fre head_edulevel
recode head_edulevel (3=2) (4=2) (5=2)
ta head_edulevel, gen(head_educ)


* Head age
tabstat head_age, stat(n mean sd q)
gen head_agesq=head_age*head_age

gen head_agecat=0
replace head_agecat=1 if head_age<40
replace head_agecat=2 if head_age>=40 & head_age<50
replace head_agecat=3 if head_age>=50 & head_age<60
replace head_agecat=4 if head_age>=60

label define head_agecat 1"Less 40" 2"40-50" 3"50-60" 4"60 or more"
label values head_agecat head_agecat
ta head_agecat, gen(head_agecat)


* Head maritalstatus
fre head_maritalstatus
gen head_nonmarried=head_maritalstatus
recode head_nonmarried (1=0) (2=1) (3=1) (4=1) (.=0)
label define head_nonmarried 0"Married" 1"Non-married"
label values head_nonmarried head_nonmarried
fre head_nonmarried

* Class
** Categorize assets 
/*
by year to take into account the
increasing level of consumption
see ref on conspicuous consumption
*/
tabstat assets_total, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile assets_`i'=assets_total if year==`i', n(3) 
}
gen assets_cat=.
replace assets_cat=assets_2010 if year==2010
replace assets_cat=assets_2016 if year==2016
replace assets_cat=assets_2020 if year==2020
drop assets_2010 assets_2016 assets_2020
ta assets_cat
label define assets_cat 1"Wealth: Poor" 2"Wealth: Middle" 3"Wealth: Rich"
label values assets_cat assets_cat
fre assets_cat
ta assets_cat caste, chi2 cchi2 exp
ta assets_cat, gen(assets_cat)



save"panel_v2", replace 
****************************************
* END















****************************************
* Labour var: 2010
****************************************
use"raw/RUME-occupnew", clear

fre kindofwork
drop if kindofwork==9

keep HHID2010 INDID2010 profession sector occupation nboccupation_indiv annualincome
fre occupation

*** Merge charact
merge m:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge HHID_panel
merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010

save"RUME-newoccvar", replace
****************************************
* END










****************************************
* Labour var: 2016-17
****************************************
use"raw/NEEMSIS1-occupnew", clear

fre kindofwork

keep HHID2016 INDID2016 profession sector occupation nboccupation_indiv annualincome hoursayear
fre occupation

*** Merge charact
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge HHID_panel
merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016


save"NEEMSIS1-newoccvar", replace
****************************************
* END








****************************************
* Labour var: 2020-21
****************************************
use"raw/NEEMSIS2-occupnew", clear

fre kindofwork

keep HHID2020 INDID2020 profession sector occupation nboccupation_indiv annualincome hoursayear
fre occupation

*** Merge charact
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge HHID_panel
merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020


save"NEEMSIS2-newoccvar", replace
****************************************
* END













****************************************
* Append all
****************************************
use"RUME-newoccvar", clear

append using "NEEMSIS1-newoccvar"
append using "NEEMSIS2-newoccvar"

order HHID_panel year INDID2010 INDID2016 INDID2020
sort HHID_panel year

tostring INDID2016, replace
tostring INDID2020, replace

gen INDID=""
replace INDID=INDID2010 if year==2010
replace INDID=INDID2016 if year==2016
replace INDID=INDID2020 if year==2020
drop INDID2010 INDID2016 INDID2020

order HHID_panel INDID year

* Merge INDID_panel
tostring year, replace
merge m:1 HHID_panel INDID year using "raw/ODRIIS-indiv_long", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring year, replace
order HHID_panel INDID_panel INDID year name sex age dep
sort HHID_panel INDID_panel year
drop INDID


save"panel-newoccvar", replace
****************************************
* END











****************************************
* Var
****************************************
use"panel-newoccvar", clear


********** Occupations
* Precise
fre occupation

* Agri vs non-agri
gen occupation2=0
replace occupation2=1 if occupation==1
replace occupation2=1 if occupation==2
replace occupation2=2 if occupation==3
replace occupation2=2 if occupation==4
replace occupation2=2 if occupation==5
replace occupation2=2 if occupation==6
replace occupation2=2 if occupation==7
label define occupation2 1"Agri" 2"Non-agri"
label values occupation2 occupation2
ta occupation occupation2

* Casual vs regular
gen occupation3=0
replace occupation3=1 if occupation==1
replace occupation3=2 if occupation==2
replace occupation3=2 if occupation==3
replace occupation3=1 if occupation==4
replace occupation3=1 if occupation==5
replace occupation3=1 if occupation==6
replace occupation3=2 if occupation==7
label define occupation3 1"Regular" 2"Casual"
label values occupation3 occupation3
ta occupation occupation3

* Casual vs regular
gen occupation4=0
replace occupation4=1 if occupation==1
replace occupation4=2 if occupation==2
replace occupation4=2 if occupation==3
replace occupation4=2 if occupation==4
replace occupation4=2 if occupation==5
replace occupation4=1 if occupation==6
replace occupation4=2 if occupation==7
label define occupation4 1"Self-employed" 2"Other"
label values occupation4 occupation4
ta occupation occupation4


********** Dummies
ta occupation, gen(occ1_)
rename occ1_1 occ_agriself
rename occ1_2 occ_agricasual
rename occ1_3 occ_casual
rename occ1_4 occ_regnonquali
rename occ1_5 occ_regquali
rename occ1_6 occ_selfemp
rename occ1_7 occ_nrega

ta occupation2, gen(occ2_)
rename occ2_1 occ_agri
rename occ2_2 occ_nona

ta occupation3, gen(occ3_)
rename occ3_1 occ_regu
rename occ3_2 occ_casu

ta occupation4, gen(occ4_)
rename occ4_1 occ_self
rename occ4_2 occ_othe


********** Macro
global total occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe



********** Hours a year by occupation, at indiv level
foreach x in $total {
local name=substr("`x'",5,32)
gen hoursayear_`name'=0
}

replace hoursayear_agriself=hoursayear if occupation==1
replace hoursayear_agricasual=hoursayear if occupation==2
replace hoursayear_casual=hoursayear if occupation==3
replace hoursayear_regnonquali=hoursayear if occupation==4
replace hoursayear_regquali=hoursayear if occupation==5
replace hoursayear_selfemp=hoursayear if occupation==6
replace hoursayear_nrega=hoursayear if occupation==7

replace hoursayear_agri=hoursayear if occupation2==1
replace hoursayear_nona=hoursayear if occupation2==2

replace hoursayear_regu=hoursayear if occupation3==1
replace hoursayear_casu=hoursayear if occupation3==2

replace hoursayear_self=hoursayear if occupation4==1
replace hoursayear_othe=hoursayear if occupation4==2

global hay hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear

foreach x in $hay {
recode `x' (.=0)
}

foreach x in $hay {
bysort HHID_panel INDID_panel year: egen indiv_`x'=sum(`x')
drop `x'
rename indiv_`x' `x'
}





********** Annual income by occupation, at indiv level
foreach x in $total {
local name=substr("`x'",5,32)
gen annualincome_`name'=0
}

replace annualincome_agriself=annualincome if occupation==1
replace annualincome_agricasual=annualincome if occupation==2
replace annualincome_casual=annualincome if occupation==3
replace annualincome_regnonquali=annualincome if occupation==4
replace annualincome_regquali=annualincome if occupation==5
replace annualincome_selfemp=annualincome if occupation==6
replace annualincome_nrega=annualincome if occupation==7

replace annualincome_agri=annualincome if occupation2==1
replace annualincome_nona=annualincome if occupation2==2

replace annualincome_regu=annualincome if occupation3==1
replace annualincome_casu=annualincome if occupation3==2

replace annualincome_self=annualincome if occupation4==1
replace annualincome_othe=annualincome if occupation4==2

global ai annualincome_agriself annualincome_agricasual annualincome_casual annualincome_regnonquali annualincome_regquali annualincome_selfemp annualincome_nrega annualincome_agri annualincome_nona annualincome_regu annualincome_casu annualincome_self annualincome_othe annualincome

foreach x in $ai {
recode `x' (.=0)
}

foreach x in $ai {
bysort HHID_panel INDID_panel year: egen indiv_`x'=sum(`x')
drop `x'
rename indiv_`x' `x'
}








********** Occupation no at individual level
foreach x in $total {
bysort HHID_panel INDID_panel year: egen indiv_`x'=sum(`x')
drop `x'
rename indiv_`x' `x'
}



********** Indiv level
keep HHID_panel HHID2010 HHID2016 HHID2020 INDID_panel year name sex age dep $total $hay $ai
duplicates drop
duplicates report HHID_panel INDID_panel year


********** Dummies by sex
foreach x in $total {
gen `x'_male=0
gen `x'_female=0
}

foreach x in $total {
replace `x'_male=`x' if sex==1
replace `x'_female=`x' if sex==2
}


********** Dummies by dep
foreach x in $total {
gen `x'_dep=0
}

foreach x in $total {
replace `x'_dep=`x' if dep==1
}


********* Dummies total
gen occ_total=0
replace occ_total=occ_agri+occ_nona

gen occ_female=0
replace occ_female=occ_agri+occ_nona if sex==2

gen occ_male=0
replace occ_male=occ_agri+occ_nona if sex==1

gen occ_dep=0
replace occ_dep=occ_agri+occ_nona if dep==1






********** Hours by sex
gen hoursayear_male=0
replace hoursayear_male=hoursayear if sex==1
gen hoursayear_female=0
replace hoursayear_female=hoursayear if sex==2
gen hoursayear_dep=0
replace hoursayear_dep=hoursayear if dep==1

foreach x in agri nona regu casu self othe {
gen hoursayear_`x'_male=0
gen hoursayear_`x'_female=0
}

foreach x in agri nona regu casu self othe {
replace hoursayear_`x'_male=hoursayear_`x' if sex==1
replace hoursayear_`x'_female=hoursayear_`x' if sex==2
}



********** Income by sex
gen annualincome_male=0
replace annualincome_male=annualincome if sex==1
gen annualincome_female=0
replace annualincome_female=annualincome if sex==2
gen annualincome_dep=0
replace annualincome_dep=annualincome if dep==1

foreach x in agri nona regu casu self othe {
gen annualincome_`x'_male=0
gen annualincome_`x'_female=0
}

foreach x in agri nona regu casu self othe {
replace annualincome_`x'_male=annualincome_`x' if sex==1
replace annualincome_`x'_female=annualincome_`x' if sex==2
}






********** Order
order HHID_panel INDID_panel year name sex age dep occ_total occ_female occ_male occ_dep


********** Indiv level var
global totalocc occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agriself_male occ_agriself_female occ_agricasual_male occ_agricasual_female occ_casual_male occ_casual_female occ_regnonquali_male occ_regnonquali_female occ_regquali_male occ_regquali_female occ_selfemp_male occ_selfemp_female occ_nrega_male occ_nrega_female occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agriself_dep occ_agricasual_dep occ_casual_dep occ_regnonquali_dep occ_regquali_dep occ_selfemp_dep occ_nrega_dep occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep

foreach x in $totalocc {
gen `x'_indiv=0
}


foreach x in $totalocc {
replace `x'_indiv=1 if `x'!=0
}

foreach x in $totalocc {
local new=substr("`x'",5,32)
rename `x'_indiv ind_`new'
}


********** Household level for all
global fulltotal occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agriself_male occ_agriself_female occ_agricasual_male occ_agricasual_female occ_casual_male occ_casual_female occ_regnonquali_male occ_regnonquali_female occ_regquali_male occ_regquali_female occ_selfemp_male occ_selfemp_female occ_nrega_male occ_nrega_female occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agriself_dep occ_agricasual_dep occ_casual_dep occ_regnonquali_dep occ_regquali_dep occ_selfemp_dep occ_nrega_dep occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agriself_male ind_agriself_female ind_agricasual_male ind_agricasual_female ind_casual_male ind_casual_female ind_regnonquali_male ind_regnonquali_female ind_regquali_male ind_regquali_female ind_selfemp_male ind_selfemp_female ind_nrega_male ind_nrega_female ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agriself_dep ind_agricasual_dep ind_casual_dep ind_regnonquali_dep ind_regquali_dep ind_selfemp_dep ind_nrega_dep ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female annualincome_agriself annualincome_agricasual annualincome_casual annualincome_regnonquali annualincome_regquali annualincome_selfemp annualincome_nrega annualincome_agri annualincome_nona annualincome_regu annualincome_casu annualincome_self annualincome_othe annualincome annualincome_male annualincome_female annualincome_dep annualincome_agri_male annualincome_agri_female annualincome_nona_male annualincome_nona_female annualincome_regu_male annualincome_regu_female annualincome_casu_male annualincome_casu_female annualincome_self_male annualincome_self_female annualincome_othe_male annualincome_othe_female

foreach x in $fulltotal {
bysort HHID_panel year: egen _`x'=sum(`x')
drop `x'
rename _`x' `x'
}

keep HHID_panel HHID2010 HHID2016 HHID2020 year $fulltotal
duplicates drop
duplicates report HHID_panel year
ta year


********** Save
save"panel-newoccvar", replace

****************************************
* END









****************************************
* Merge with main dataset
****************************************
use"panel_v2", clear

merge 1:1 HHID_panel year using "panel-newoccvar"
drop _merge


********** Share
global fulltotal occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agriself_male occ_agriself_female occ_agricasual_male occ_agricasual_female occ_casual_male occ_casual_female occ_regnonquali_male occ_regnonquali_female occ_regquali_male occ_regquali_female occ_selfemp_male occ_selfemp_female occ_nrega_male occ_nrega_female occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agriself_dep occ_agricasual_dep occ_casual_dep occ_regnonquali_dep occ_regquali_dep occ_selfemp_dep occ_nrega_dep occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agriself_male ind_agriself_female ind_agricasual_male ind_agricasual_female ind_casual_male ind_casual_female ind_regnonquali_male ind_regnonquali_female ind_regquali_male ind_regquali_female ind_selfemp_male ind_selfemp_female ind_nrega_male ind_nrega_female ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agriself_dep ind_agricasual_dep ind_casual_dep ind_regnonquali_dep ind_regquali_dep ind_selfemp_dep ind_nrega_dep ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female annualincome_agriself annualincome_agricasual annualincome_casual annualincome_regnonquali annualincome_regquali annualincome_selfemp annualincome_nrega annualincome_agri annualincome_nona annualincome_regu annualincome_casu annualincome_self annualincome_othe annualincome annualincome_male annualincome_female annualincome_dep annualincome_agri_male annualincome_agri_female annualincome_nona_male annualincome_nona_female annualincome_regu_male annualincome_regu_female annualincome_casu_male annualincome_casu_female annualincome_self_male annualincome_self_female annualincome_othe_male annualincome_othe_female

foreach x in $fulltotal {
replace `x'=0 if `x'==.
}



drop hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH



********** Last minute var crea
gen head_educ=head_edulevel
recode head_educ (2=1)

* Rem + Assets
foreach x in assets_total remittnet_HH annualincome_HH {
egen `x'_std=std(`x')
drop `x'
rename `x'_std `x'
}

ta villageid, gen(village_)


*** Fafchamps and Quisumbing, 1998

* Log HH size
gen log_HHsize=log(HHsize)

* Share children
gen share_children=agegrp_0_13/HHsize

* Share female
gen share_female2=nbfemale/HHsize

* Share old
gen share_old=(agegrp_70_79+agegrp_80_100)/HHsize

* Share young
gen share_young=agegrp_14_17/HHsize

* Stock mdo en age de travailler, qui ne travaille pas, en %
gen share_stock=nbworker_HH/HHsize


* Caste
ta caste, gen(caste_)
label var caste_1 "Caste: Dalits"
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"


save"panel_v3", replace
****************************************
* END
