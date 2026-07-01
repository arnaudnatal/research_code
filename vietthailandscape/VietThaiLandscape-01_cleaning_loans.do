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









****************************************
* Cleaning
****************************************
use"Loans_v00", clear

********** Lender
gen lender2=""
replace lender2="Bank" if lender=="Bank for Agriculture and Agricultural Cooperatives (BAAC)"
replace lender2="Labour" if lender=="Business partner/trader/supplier"
replace lender2="Other informal" if lender=="Village Fund/Community  Fund(Taksin village fund)"
replace lender2="Moneylenders" if lender=="Money lender"
replace lender2="Family" if lender=="Family in village"
replace lender2="Cooperative" if lender=="Agricultural cooperatives"
replace lender2="SHG" if lender=="Self help credit group"
replace lender2="Family" if lender=="family outside village (same province)"
replace lender2="Bank" if lender=="commercial bank"
replace lender2="Bank" if lender=="Government Savings Bank"
replace lender2="Bank" if lender=="Credit companies (e.g. Easy Buy, Quick Cash, AEON etc.)"
replace lender2="Friends" if lender=="Friends in village"
replace lender2="Bank" if lender=="Village bank"
replace lender2="Other formal" if lender=="poverty eradication project"
replace lender2="Friends" if lender=="friends outside village (same province)"
replace lender2="Family" if lender=="family other province"
replace lender2="Bank" if lender=="Government Housing Bank"
replace lender2="Organization" if lender=="Other socio-political organization"
replace lender2="Other" if lender=="Other, specify"
replace lender2="Friends" if lender=="friends other province"
replace lender2="Pawnbroker" if lender=="pawnshop"
replace lender2="Other" if lender=="school"
replace lender2="Cooperative" if lender=="saving cooperative and credit union"
replace lender2="Labour" if lender=="work office"
replace lender2="Insurance" if lender=="insurance company"
replace lender2="Don't know" if lender=="don't know"
replace lender2="Other informal" if lender=="temple"
replace lender2="Family" if lender=="family abroad"
replace lender2="Other" if lender=="student loan fund"
replace lender2="Government" if lender=="local government"
replace lender2="Bank" if lender=="Small Industry Finance Corporation/ SME Development Bank"
replace lender2="Other" if lender=="student loan with payment related to future income"
replace lender2="Not applicable" if lender=="not applicable"
replace lender2="Other formal" if lender=="agricultural production restructuring program"
replace lender2="Bank" if lender=="Export-Import Bank of Thailand or Business Promotion Office at Department of Exp"
replace lender2="Other formal" if lender=="agricultural land reform office"
replace lender2="Other formal" if lender=="Job placement support fund"
replace lender2="Friends" if lender=="friends in village"
replace lender2="Family" if lender=="familiy outside village (same province)"
replace lender2="Bank" if lender=="Bank for agriculture and rural development"
replace lender2="Family" if lender=="family in village"
replace lender2="Labour" if lender=="Business partner/trader"
replace lender2="Bank" if lender=="Bank for social policy"
replace lender2="Organization" if lender=="Socio-political organization(VWU, agricultural organization)"
replace lender2="Moneylenders" if lender=="money lender"
replace lender2="Friends" if lender=="friends abroad"
replace lender2="Bank" if lender=="Commercial bank"
replace lender2="Credit group" if lender=="Credit organization (e.g. PCF)"
replace lender2="Credit group" if lender=="credit group (Ho/Hui or Phuong)"
replace lender2="Family" if lender=="relative in village"
replace lender2="Family" if lender=="relative other province"
replace lender2="Family" if lender=="Family in village"
replace lender2="Other" if lender=="Urban Community Development Organization"
replace lender2="Family" if lender=="Family in village"
/*
preserve
keep lender lender2
keep if lender2==""
drop lender2
duplicates drop
restore
ta lender
*/


********** Reason
gen reason2=""
replace reason2="Agriculture" if reason=="Agricultural investments"
replace reason2="Durable goods" if reason=="Buy durable household goods"
replace reason2="Consumption" if reason=="buying consumption good (e.g. food)"
replace reason2="Ceremony" if reason=="Ceremony (wedding, funeral, tet)"
replace reason2="Agriculture" if reason=="Agriculture related expenses  (e.g. fertilizer pesticides)"
replace reason2="Repay" if reason=="Pay back other debt"
replace reason2="Housing" if reason=="House or land purchase/construction"
replace reason2="Education" if reason=="Study"
replace reason2="Investment" if reason=="Business investments"
replace reason2="Repay guarantor" if reason=="pay back debt as guarantor (borrower default)"
replace reason2="Non-relatives" if reason=="relend to non-relatives"
replace reason2="Health" if reason=="Medical treatment"
replace reason2="Investment" if reason=="Business related expenses"
replace reason2="Infrastructure" if reason=="Improving infrastructure (water supply, sanitation etc.)"
replace reason2="Other" if reason=="Other, specify"
replace reason2="Don't know" if reason=="don't know"
replace reason2="Other" if reason=="lawsuit expenses"
replace reason2="Relatives" if reason=="relend to family members or relatives"
replace reason2="Labour" if reason=="work abroad"
replace reason2="Not applicable" if reason=="not applicable"
replace reason2="Labour" if reason=="work related travelling expense"
replace reason2="Insurance" if reason=="insurance payment"
replace reason2="Housing" if reason=="land ownership transfer fee"
replace reason2="Other" if reason=="compensation"
replace reason2="Other" if reason=="run for an election"
replace reason2="Housing" if reason=="house and car repair"
replace reason2="Investment" if reason=="buy machinne for production"
replace reason2="Other" if reason=="contribution to public transport project"
replace reason2="Health" if reason=="give birth"
replace reason2="Ceremony" if reason=="funeral"
replace reason2="Labour" if reason=="job fee"
replace reason2="Housing" if reason=="buy the land"
replace reason2="Saving" if reason=="Savings"
/*
preserve
keep reason reason2
keep if reason2==""
drop reason2
duplicates drop
restore
ta reason
*/


***** Collateral
gen collateral2=""
replace collateral2="Land" if collateral=="land"
replace collateral2="Assets" if collateral=="other assets (e.g. farm equipment, livestock, valuables)"
replace collateral2="Crops/stock" if collateral=="use future crops to guanrantee credit"
replace collateral2="Third person" if collateral=="multiple guarantors"
replace collateral2="Nothing" if collateral=="no collateral required"
replace collateral2="Saving" if collateral=="use savings to guanrantee credit"
replace collateral2="Not applicable" if collateral=="not applicable"
replace collateral2="Third person" if collateral=="single guarantor"
replace collateral2="Goods" if collateral=="radio, sterio, VCD/DVD player"
replace collateral2="Don't know" if collateral=="don't know"
replace collateral2="Land tax doc" if collateral=="land tax document"
replace collateral2="Life insurance" if collateral=="life insurance"
replace collateral2="Assets" if collateral=="car, pick-up car, truck"
replace collateral2="Crops/stock" if collateral=="stock"
replace collateral2="Job contract" if collateral=="Salary /work contract"
replace collateral2="Job contract" if collateral=="salary/work contract"
replace collateral2="Other" if collateral=="Other, specify"
/*
preserve
keep collateral collateral2
keep if collateral2==""
drop collateral2
duplicates drop
restore
ta collateral
*/


***** Second collateral
gen secondcoll2=""
replace collateral2="Nothing" if collateral=="no other requirement"
replace collateral2="Third person" if collateral=="other multiple garantors"
replace collateral2="Not applicable" if collateral=="not applicable"
replace collateral2="Membership" if collateral=="credit group membership"
replace collateral2="Third person" if collateral=="individual garantor"
replace collateral2="Membership" if collateral=="membership in social/political group  (e.g. VWU, farmers' union, party, church)"
replace collateral2="Saving" if collateral=="savings account at the bank"
replace collateral2="Don't know" if collateral=="don't know"
replace collateral2="School" if collateral=="currently enrolled in school or university"
replace collateral2="Salary" if collateral=="Salary (work contract) or retired salary"
replace collateral2="No answer" if collateral=="no answer"
replace collateral2="Land" if collateral=="residential land"
replace collateral2="Connection" if collateral=="Has relative working in the Bank"
replace collateral2="Other" if collateral=="poor household"
replace collateral2="Work contract" if collateral=="salary/work contract"
replace collateral2="Other" if collateral=="Other, specify"
replace collateral2="Insurance" if collateral=="Insurance (Life, accident etc.)"
/*
preserve
keep secondcoll secondcoll2
keep if secondcoll2==""
drop secondcoll2
duplicates drop
restore
ta secondcoll
*/


***** Type
ta type
gen type2=.
label define type2 1"Cash" 2"Other"
label values type2 type2
replace type2=1 if type=="Cash"
replace type2=1 if type=="a loan"
replace type2=2 if type!="Cash"
replace type2=2 if type=="a loan"
*
ta type type2, m
drop type

***** Shock
ta shock
gen shock2=.
label define shock2 0"No" 1"Yes"
label values shock2 shock2
replace shock2=0 if shock=="no"
replace shock2=0 if shock=="don't know"
replace shock2=0 if shock=="not applicable"
replace shock2=1 if shock=="yes"
*
ta shock shock2, m
drop shock



****************************************
* END
