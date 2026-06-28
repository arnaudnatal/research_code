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
* 2007 - 2013
****************************************

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

* Gen
gen country="Viet"
gen year=2013
order country year hhid, first

save"_temp_vn13", replace

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
append using "_temp_th13"
append using "_temp_vn13"


mdesc


ta country year if interestrate==.
ta country year if lender==. // 2013 th and vn
ta country year if reason==. // 2013 vn

save"Loans_v00.dta"
****************************************
* END









****************************************
* Cleaning
****************************************
use"Loans_v00", clear

fre lender
gen lender2=.
label define lender2 1"Formal" 2"Informal" 3"Other"
* Formal
foreach i in ///
1 2 3 14 51 52 53 54 55 56 57 58 59 64 65 80 81 82 83 84 85 86 100 101 102 ///
{
replace lender2=1 if lender==`i'
}
* Informal
foreach i in ///
11 12 20 21 22 23 24 25 26 27 60 61 62 63 70 71 72 73 74 75 76 ///
{
replace lender2=2 if lender==`i'
}
* Other
foreach i in ///
7 8 28 78 79 87 88 90 97 98 99 ///
{
replace lender2=3 if lender==`i'
}

fre lender if lender2==.
ta lender2


****************************************
* END
