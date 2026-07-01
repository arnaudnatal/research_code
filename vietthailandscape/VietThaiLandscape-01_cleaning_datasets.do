*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 27, 2026
*-----
gl link = "vietthailandscape"
*Cleaning TVSEP
*-----
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*cd"C:\Users\anatal\Documents\vtl\Ongoing_VietThaiLandscape\Analysis"
*-------------------------





****************************************
* 2007 - 2024
****************************************


********** Data
***** Thailand
* 2007 - ok
* 2008 - ok
* 2010 - ok
* 2011 - ok
* 2013 - beaucoup de manquants, mail envoyé
* 2016 - ok
* 2017 - ok
* 2019 - pas dispo pour VN donc je ne le prends pas
* 2022 - MCQ donc pas sûr de le prendre
* 2024 - beaucoup de manquants, mail envoyé

***** Vietnam
* 2007 - ok
* 2008 - ok
* 2010 - ok
* 2011 - ok
* 2013 - beaucoup de manquants, mail envoyé
* 2016 - ok
* 2017 - ok
* 2022 - MCQ donc pas sûr de le prendre
* 2024 - beaucoup de manquants, mail envoyé


/*
- append 2007, 2008, 2010, 2011, 2016, 2017
*/

********** Thailand 2007
use"raw/th07_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106 reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename _x71129 productive
rename _x71113 durationunit
rename _x71112n durationn

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2007
order country year hhid, first

save"_temp_th07", replace




********** Vietnam 2007
use"raw/vn07_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106 reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename _x71129 productive
rename _x71113 durationunit
rename _x71112n durationn


* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Viet"
gen year=2007
order country year hhid, first

save"_temp_vn07", replace





********** Thailand 2008
use"raw/th08_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2008
order country year hhid, first

save"_temp_th08", replace




********** Vietnam 2008
use"raw/vn08_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Viet"
gen year=2008
order country year hhid, first

save"_temp_vn08", replace





********** Thailand 2010
use"raw/th10_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2010
order country year hhid, first

save"_temp_th10", replace




********** Vietnam 2010
use"raw/vn10_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Viet"
gen year=2010
order country year hhid, first

save"_temp_vn10", replace




********** Thailand 2011
use"raw/th11_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2011
order country year hhid, first

save"_temp_th11", replace




********** Vietnam 2011
use"raw/vn11_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Viet"
gen year=2011
order country year hhid, first

save"_temp_vn11", replace




********** Thailand 2013
use"raw/th13_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Label
label define shock 1"yes" 2"no"
label values shock shock

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason shock {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}
rename lender lender_num
rename collateral collateral_num
rename secondcoll secondcoll_num

* Gen
gen country="Thai"
gen year=2013
order country year hhid, first

save"_temp_th13", replace




********** Vietnam 2013
use"raw/vn13_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename i_x71126 durationyear

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationyear

* Decode
foreach x in type reason {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}
rename lender lender_num
rename collateral collateral_num
rename secondcoll secondcoll_num
rename shock shock_num

* Gen
gen country="Viet"
gen year=2013
order country year hhid, first

save"_temp_vn13", replace




********** Thailand 2016
use"raw/th16_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename _x71113 durationunit
rename _x71112 durationn
 

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2016
order country year hhid, first

save"_temp_th16", replace



********** Vietnam 2016
use"raw/vn16_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename _x71113 durationunit
rename _x71112 durationn
 
* Replace lender
label define lender ///
    1  "01 - Bank for social policy" ///
    2  "02 - Bank for agriculture and rural development" ///
    3  "03 - Credit organization (e.g. PCF)" ///
    7  "07 - Job placement support fund" ///
    8  "08 - Socio-political organization (VWU, agricultural organization)" ///
    11 "11 - Business partner/trader/supplier" ///
    12 "12 - Money lender" ///
    13 "13 - Pawnshop" ///
    14 "14 - Commercial bank" ///
    20 "20 - Relative in village" ///
    21 "21 - Relative outside village (same province)" ///
    22 "22 - Relative other province" ///
    23 "23 - Relative abroad" ///
    24 "24 - Friends in village" ///
    25 "25 - Friends outside village (same province)" ///
    26 "26 - Friends other province" ///
    27 "27 - Friends abroad" ///
    28 "28 - Credit group (Ho/Hui or Phuong)" ///
    90 "90 - Other, specify" ///
    98 "98 - No answer"
label values lender lender
	
* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Viet"
gen year=2016
order country year hhid, first

save"_temp_vn16", replace



********** Thailand 2017
use"raw/th17_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename _x71113 durationunit
rename _x71112 durationn
 

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2017
order country year hhid, first

save"_temp_th17", replace




********** Vietnam 2017
use"raw/vn17_borrclean.dta", clear

* Rename
rename _x71103 loanid
rename _x71104 type
rename _x71105 amount
rename _x71106a reason
rename _x71107 shock
rename _x71109 lender
rename _x71116 interestrate
rename _x71120 collateral
rename _x71122 secondcoll
rename i_x71129 productive
rename _x71113 durationunit
rename _x71112 durationn
 

* Selection
keep hhid ///
loanid type amount reason shock lender interestrate collateral secondcoll productive durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in type reason shock lender collateral secondcoll {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Viet"
gen year=2017
order country year hhid, first

save"_temp_vn17", replace






********** Thailand 2019
use"raw/th19_borr.dta", clear

rename interview__id hhid
* Rename
rename borr__id loanid
rename v71104 type
rename v71105 amount
rename v71106__1 reason_busi1
rename v71106__2 reason_agri1
rename v71106__3 reason_busi2
rename v71106__4 reason_agri2
rename v71106__5 reason_repay
rename v71106__6 reason_housing
rename v71106__7 reason_durable
rename v71106__8 reason_improve
rename v71106__9 reason_buying
rename v71106__10 reason_health
rename v71106__11 reason_ceremony
rename v71106__12 reason_educ
rename v71106__14 reason_labour
rename v71106__18 reason_relend1
rename v71106__19 reason_relend2
rename v71106__90 reason_other
rename v71106__98 reason_noanswer
rename v71107 shock
rename v71109 lender
rename v71116 interestrate
rename v71120 collateral
rename v71122__0 secondcoll_no
rename v71122__1 secondcoll_credit
rename v71122__2 secondcoll_member
rename v71122__3 secondcoll_othermult
rename v71122__4 secondcoll_indiv
rename v71122__5 secondcoll_saving
rename v71122__6 secondcoll_curren
rename v71122__10 secondcoll_salary
rename v71122__90 secondcoll_other
rename v71122__98 secondcoll_noanswer
*rename i_x71129 productive
rename v71113 durationunit
rename v71112 durationn

* Selection
keep hhid ///
loanid type amount reason_* shock lender interestrate collateral secondcoll_* durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in shock lender collateral durationunit {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2019
order country year hhid, first

save"_temp_th19", replace






********** Thailand 2022
use"raw/th22_borr.dta", clear

rename interview__id hhid
* Rename
rename borr__id loanid
rename v71104 type
rename v71105 amount
rename v71106__1 reason_busi1
rename v71106__2 reason_agri1
rename v71106__3 reason_busi2
rename v71106__4 reason_agri2
rename v71106__5 reason_repay
rename v71106__6 reason_housing
rename v71106__7 reason_durable
rename v71106__8 reason_improve
rename v71106__9 reason_buying
rename v71106__10 reason_health
rename v71106__11 reason_ceremony
rename v71106__12 reason_educ
rename v71106__14 reason_labour
rename v71106__18 reason_relend1
rename v71106__19 reason_relend2
rename v71106__90 reason_other
rename v71106__98 reason_noanswer
rename v71107 shock
rename v71109 lender
rename v71116 interestrate
rename v71120__1 collateral_1
rename v71120__2 collateral_2
rename v71120__3 collateral_3
rename v71120__4 collateral_4
rename v71120__5 collateral_5
rename v71120__6 collateral_6
rename v71120__7 collateral_7
rename v71120__8 collateral_8
rename v71120__13 collateral_13
rename v71120__90 collateral_90
rename v71120__98 collateral_98
rename v71122__0 secondcoll_no
rename v71122__1 secondcoll_credit
rename v71122__2 secondcoll_member
rename v71122__3 secondcoll_othermult
rename v71122__4 secondcoll_indiv
rename v71122__5 secondcoll_saving
rename v71122__6 secondcoll_curren
rename v71122__10 secondcoll_salary
rename v71122__90 secondcoll_other
rename v71122__98 secondcoll_noanswer
*rename i_x71129 productive
rename v71113 durationunit
rename v71112 durationn

* Selection
keep hhid ///
loanid type amount reason_* shock lender interestrate collateral_* secondcoll_* durationunit durationn
order durationunit, before(durationn)

* Decode
foreach x in shock lender durationunit {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}

* Gen
gen country="Thai"
gen year=2022
order country year hhid, first

save"_temp_th22", replace


****************************************
* END




























****************************************
* Append
****************************************
use"_temp_th07", clear

append using "_temp_vn07"
append using "_temp_th08"
append using "_temp_vn08"
append using "_temp_th10"
append using "_temp_vn10"
append using "_temp_th11"
append using "_temp_vn11"
append using "_temp_th16"
append using "_temp_vn16"
append using "_temp_th17"
append using "_temp_vn17"


save"Loans_v00.dta", replace
****************************************
* END
