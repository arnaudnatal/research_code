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









****************************************
* Lenders
****************************************
use"Loans_v00", clear

preserve
keep lender
duplicates drop
restore

********** Tout en minuscule
gen lender_clean=lower(strtrim(lender))



********** Enlever les préfixes numériques du type "61 - "
replace lender_clean=regexr(lender_clean, "^[0-9]+[ ]*-[ ]*", "")


********** Nettoyage léger
replace lender_clean=subinstr(lender_clean, "  ", " ", .)
replace lender_clean=subinstr(lender_clean, "familiy", "family", .)
replace lender_clean=subinstr(lender_clean, "community  fund", "community fund", .)
replace lender_clean=subinstr(lender_clean, "other specify", "other, specify", .)
gen lender_cat=""


********* Catégories fines
* Banques publiques / développement
replace lender_cat="public_agricultural_bank" if strpos(lender_clean,"bank for agriculture and agricultural cooperatives") ///
| strpos(lender_clean,"bank for agriculture and rural development")

replace lender_cat="public_social_policy_bank" if strpos(lender_clean,"bank for social policy")

replace lender_cat="government_savings_bank" if strpos(lender_clean,"government savings bank")

replace lender_cat="government_housing_bank" if strpos(lender_clean,"government housing bank")

replace lender_cat="sme_development_bank" if strpos(lender_clean,"small industry finance") ///
| strpos(lender_clean,"sme development bank")

replace lender_cat="export_import_business_promotion_bank" if strpos(lender_clean,"export-import bank") ///
| strpos(lender_clean,"business promotion office")

* Banques commerciales
replace lender_cat="commercial_bank" if lender_clean=="commercial bank"

* Crédit formel non bancaire
replace lender_cat="credit_company" if strpos(lender_clean,"credit companies")

replace lender_cat="credit_organization" if strpos(lender_clean,"credit organization")

replace lender_cat="insurance_company" if strpos(lender_clean,"insurance company")

replace lender_cat="pawnshop" if lender_clean=="pawnshop"

* Coopératives / groupes de crédit
replace lender_cat="agricultural_cooperative" if lender_clean=="agricultural cooperatives"

replace lender_cat="saving_cooperative_credit_union" if strpos(lender_clean,"saving cooperative") ///
| strpos(lender_clean,"credit union")

replace lender_cat="self_help_credit_group" if lender_clean=="self help credit group"

replace lender_cat="informal_rotating_credit_group" if strpos(lender_clean,"credit group") ///
| strpos(lender_clean,"ho/hui") ///
| strpos(lender_clean,"phuong")

* Fonds villageois / communautaires / programmes publics
replace lender_cat="village_fund" if strpos(lender_clean,"village fund") ///
| strpos(lender_clean,"community fund")

replace lender_cat="village_bank" if lender_clean=="village bank"

replace lender_cat="poverty_eradication_project" if strpos(lender_clean,"poverty eradication")

replace lender_cat="urban_community_development_org" if strpos(lender_clean,"urban community development")

replace lender_cat="agricultural_restructuring_program" if strpos(lender_clean,"agricultural production restructuring")

replace lender_cat="agricultural_land_reform_office" if strpos(lender_clean,"agricultural land reform")

replace lender_cat="job_placement_support_fund" if strpos(lender_clean,"job placement support")

replace lender_cat="student_loan_fund" if strpos(lender_clean,"student loan fund") ///
| strpos(lender_clean,"student loan with payment")

replace lender_cat="local_government" if lender_clean=="local government"

* Organisations sociales / politiques / religieuses / école / bureau
replace lender_cat="socio_political_organization" if strpos(lender_clean,"socio-political organization") ///
| strpos(lender_clean,"vwu") ///
| strpos(lender_clean,"agricultural organization")

replace lender_cat="temple" if lender_clean=="temple"

replace lender_cat="school" if lender_clean=="school"

replace lender_cat="work_office" if lender_clean=="work office"

* Relations économiques
replace lender_cat = "business_partner_trader_supplier" if ///
    strpos(lender_clean,"business partner") | ///
    strpos(lender_clean,"trader") | ///
    strpos(lender_clean,"supplier")

* Prêteurs informels
replace lender_cat="money_lender" if lender_clean=="money lender"

* Famille / proches par localisation
replace lender_cat="relative_in_village" if lender_clean=="family in village" ///
| lender_clean=="relative in village"

replace lender_cat="relative_same_province_outside_village" if strpos(lender_clean,"family outside village") ///
| strpos(lender_clean,"relative outside village")

replace lender_cat="relative_other_province" if lender_clean=="family other province" ///
| lender_clean=="relative other province"

replace lender_cat="relative_abroad" if lender_clean=="family abroad" ///
| lender_clean=="relative abroad"

* Amis par localisation
replace lender_cat="friends_in_village" if lender_clean=="friends in village"

replace lender_cat="friends_same_province_outside_village" if lender_clean=="friends outside village (same province)"

replace lender_cat="friends_other_province" if lender_clean=="friends other province"

replace lender_cat="friends_abroad" if lender_clean=="friends abroad"

* Autres / manquants
replace lender_cat="other" if strpos(lender_clean,"other, specify")

replace lender_cat="dont_know" if lender_clean=="don't know"

replace lender_cat="not_applicable" if lender_clean=="not applicable"

* Vérification
ta lender_cat




********** Catégories agregées
gen lender_group = ""

* Banques publiques / programmes gouvernementaux
replace lender_group = "pubank_govprog" if lender_cat == "public_agricultural_bank"
replace lender_group = "pubank_govprog" if lender_cat == "public_social_policy_bank"
replace lender_group = "pubank_govprog" if lender_cat == "government_savings_bank"
replace lender_group = "pubank_govprog" if lender_cat == "government_housing_bank"
replace lender_group = "pubank_govprog" if lender_cat == "sme_development_bank"
replace lender_group = "pubank_govprog" if lender_cat == "export_import_business_promotion_bank"
replace lender_group = "pubank_govprog" if lender_cat == "poverty_eradication_project"
replace lender_group = "pubank_govprog" if lender_cat == "urban_community_development_org"
replace lender_group = "pubank_govprog" if lender_cat == "agricultural_restructuring_program"
replace lender_group = "pubank_govprog" if lender_cat == "agricultural_land_reform_office"
replace lender_group = "pubank_govprog" if lender_cat == "job_placement_support_fund"
replace lender_group = "pubank_govprog" if lender_cat == "student_loan_fund"
replace lender_group = "pubank_govprog" if lender_cat == "local_government"

* Crédit formel privé
replace lender_group = "formprivcredit" if lender_cat == "commercial_bank"
replace lender_group = "formprivcredit" if lender_cat == "credit_company"
replace lender_group = "formprivcredit" if lender_cat == "credit_organization"
replace lender_group = "formprivcredit" if lender_cat == "insurance_company"
replace lender_group = "formprivcredit" if lender_cat == "pawnshop"

* Coopératives / crédit communautaire
replace lender_group = "coopcommcredit" if lender_cat == "agricultural_cooperative"
replace lender_group = "coopcommcredit" if lender_cat == "saving_cooperative_credit_union"
replace lender_group = "coopcommcredit" if lender_cat == "self_help_credit_group"
replace lender_group = "coopcommcredit" if lender_cat == "informal_rotating_credit_group"
replace lender_group = "coopcommcredit" if lender_cat == "village_fund"
replace lender_group = "coopcommcredit" if lender_cat == "village_bank"

* Organisations sociales / institutionnelles
replace lender_group = "socinstorg" if lender_cat == "socio_political_organization"
replace lender_group = "socinstorg" if lender_cat == "temple"
replace lender_group = "socinstorg" if lender_cat == "school"
replace lender_group = "socinstorg" if lender_cat == "work_office"

* Friends
replace lender_group = "friends" if lender_cat == "friends_abroad"
replace lender_group = "friends" if lender_cat == "friends_in_village"
replace lender_group = "friends" if lender_cat == "friends_other_province"
replace lender_group = "friends" if lender_cat == "friends_same_province_outside_village"

* Relatives
replace lender_group = "relatives" if lender_cat == "relative_abroad"
replace lender_group = "relatives" if lender_cat == "relative_in_village"
replace lender_group = "relatives" if lender_cat == "relative_other_province"
replace lender_group = "relatives" if lender_cat == "relative_same_province_outside_village"

* Relations commerciales
replace lender_group = "businetw" if lender_cat == "business_partner_trader_supplier"

* Moneylenders
replace lender_group = "moneylender" if lender_cat == "money_lender"

* Autre
replace lender_group = "other" if lender_cat == "other"
replace lender_group = "other" if lender_cat == "dont_know"
replace lender_group = "other" if lender_cat == "not_applicable"



********** Vérification
ta lender_group

ta lender if lender_group=="businetw"
ta lender if lender_group=="coopcommcredit"
ta lender if lender_group=="formprivcredit"
ta lender if lender_group=="friends"
ta lender if lender_group=="moneylender"
ta lender if lender_group=="other"
ta lender if lender_group=="pubank_govprog"
ta lender if lender_group=="relatives"
ta lender if lender_group=="socinstorg"

save"Loans_v01.dta", replace
****************************************
* END













****************************************
* Reason
****************************************
use"Loans_v01.dta", clear

preserve
keep reason
duplicates drop
restore


********** Minuscule
gen reason_clean = lower(strtrim(reason))


********** Enlever les préfixes numériques : "7 - ..."
replace reason_clean = regexr(reason_clean, "^[0-9]+[ ]*-[ ]*", "")


********** Nettoyage léger
replace reason_clean = subinstr(reason_clean, "  ", " ", .)
replace reason_clean = subinstr(reason_clean, "machinne", "machine", .)
replace reason_clean = subinstr(reason_clean, "sanitation etc.)", "sanitation etc)", .)



********** Catégorie
gen reason_group = ""

* 1. Agriculture
replace reason_group = "agriculture" if reason_clean == "agricultural investments"
replace reason_group = "agriculture" if strpos(reason_clean,"agriculture related expenses")

* 2. Business / activité productive
replace reason_group = "business_productive" if reason_clean == "business investments"
replace reason_group = "business_productive" if reason_clean == "business related expenses"
replace reason_group = "business_productive" if reason_clean == "buy machine for production"

* 3. Consommation / biens durables
replace reason_group = "consumption" if strpos(reason_clean,"buy durable household goods")
replace reason_group = "consumption" if strpos(reason_clean,"buying consumption good")

* 4. Logement / terre / infrastructure
replace reason_group = "housing_land_infrastructure" if strpos(reason_clean,"house or land purchase")
replace reason_group = "housing_land_infrastructure" if reason_clean == "buy the land"
replace reason_group = "housing_land_infrastructure" if reason_clean == "land ownership transfer fee"
replace reason_group = "housing_land_infrastructure" if strpos(reason_clean,"improving infrastructure")
replace reason_group = "housing_land_infrastructure" if reason_clean == "house and car repair"

* 5. Éducation / santé
replace reason_group = "education_health" if reason_clean == "study"
replace reason_group = "education_health" if reason_clean == "medical treatment"
replace reason_group = "education_health" if reason_clean == "give birth"

* 6. Dette / remboursement / garantie
replace reason_group = "debt_repayment" if reason_clean == "pay back other debt"
replace reason_group = "debt_repayment" if strpos(reason_clean,"pay back debt as guarantor")

* 7. Relending
replace reason_group = "relending" if strpos(reason_clean,"relend to family")
replace reason_group = "relending" if strpos(reason_clean,"relend to non-relatives")

* 8. Migration / travail
replace reason_group = "work_migration" if reason_clean == "work abroad"
replace reason_group = "work_migration" if reason_clean == "work related travelling expense"
replace reason_group = "work_migration" if reason_clean == "job fee"

* 9. Cérémonies / obligations sociales
replace reason_group = "ceremony_social_obligations" if strpos(reason_clean,"ceremony")
replace reason_group = "ceremony_social_obligations" if reason_clean == "funeral"
replace reason_group = "ceremony_social_obligations" if reason_clean == "compensation"
replace reason_group = "ceremony_social_obligations" if reason_clean == "contribution to public transport project"

* 10. Autres / inconnus / non applicable
replace reason_group = "other_unknown_na" if strpos(reason_clean,"other, specify")
replace reason_group = "other_unknown_na" if reason_clean == "don't know"
replace reason_group = "other_unknown_na" if reason_clean == "not applicable"
replace reason_group = "other_unknown_na" if reason_clean == "no second usage"

* 11. Autres cas spécifiques
replace reason_group = "legal_political_insurance" if reason_clean == "lawsuit expenses"
replace reason_group = "legal_political_insurance" if reason_clean == "insurance payment"
replace reason_group = "legal_political_insurance" if reason_clean == "run for an election"

replace reason_group = "savings" if reason_clean == "savings"



********** Group 2
gen reason_group2 = ""

* 1. Activités productives
replace reason_group2 = "productive" if reason_group == "agriculture"
replace reason_group2 = "productive" if reason_group == "business_productive"

* 2. Logement / terrain
replace reason_group2 = "housing_land" if reason_group == "housing_land_infrastructure"

* 3. Consommation
replace reason_group2 = "consumption" if reason_group == "consumption"

* 4. Capital humain
replace reason_group2 = "human_capital" if reason_group == "education_health"

* 5. Remboursement de dettes
replace reason_group2 = "debt_repayment" if reason_group == "debt_repayment"

* 6. Transferts et obligations sociales
replace reason_group2 = "transfers" if reason_group == "relending"
replace reason_group2 = "transfers" if reason_group == "ceremony_social_obligations"

* 7. Travail / migration
replace reason_group2 = "work_migration" if reason_group == "work_migration"

* 8. Autres
replace reason_group2 = "other_unknown" if reason_group == "legal_political_insurance"
replace reason_group2 = "other_unknown" if reason_group == "savings"
replace reason_group2 = "other_unknown" if reason_group == "other_unknown_na"



save"Loans_v02.dta", replace
****************************************
* END













****************************************
* Collateral
****************************************
use"Loans_v02.dta", clear

preserve
keep collateral
duplicates drop
restore




********** Minuscule
gen collateral_clean = lower(strtrim(collateral))


********** Enlever les préfixes numériques : "7 - ..."
replace collateral_clean = regexr(collateral_clean, "^[0-9]+[ ]*-[ ]*", "")

********** Nettoyage léger
replace collateral_clean = subinstr(collateral_clean, "  ", " ", .)
replace collateral_clean = subinstr(collateral_clean, "guanrantee", "guarantee", .)
replace collateral_clean = subinstr(collateral_clean, "sterio", "stereo", .)
replace collateral_clean = subinstr(collateral_clean, "salary /work", "salary/work", .)
replace collateral_clean = subinstr(collateral_clean, "other specify", "other, specify", .)


********** Group
gen collateral_group = ""

* Version fine
replace collateral_group = "land" if collateral_clean == "land"
replace collateral_group = "land" if collateral_clean == "land tax document"

replace collateral_group = "physical_assets" if strpos(collateral_clean,"other assets")
replace collateral_group = "physical_assets" if collateral_clean == "radio, stereo, vcd/dvd player"
replace collateral_group = "physical_assets" if collateral_clean == "car, pick-up car, truck"
replace collateral_group = "physical_assets" if collateral_clean == "stock"

replace collateral_group = "future_crops" if strpos(collateral_clean,"future crops")
replace collateral_group = "savings" if strpos(collateral_clean,"savings")
replace collateral_group = "life_insurance" if collateral_clean == "life insurance"

replace collateral_group = "guarantor" if collateral_clean == "single guarantor"
replace collateral_group = "guarantor" if collateral_clean == "multiple guarantors"

replace collateral_group = "salary_work_contract" if collateral_clean == "salary/work contract"

replace collateral_group = "no_collateral" if collateral_clean == "no collateral required"

replace collateral_group = "other_unknown_na" if collateral_clean == "other, specify"
replace collateral_group = "other_unknown_na" if collateral_clean == "don't know"
replace collateral_group = "other_unknown_na" if collateral_clean == "not applicable"




********** Version agrégée
gen collateral_group2 = ""

replace collateral_group2 = "asset_collateral" if collateral_group == "land"
replace collateral_group2 = "asset_collateral" if collateral_group == "physical_assets"
replace collateral_group2 = "asset_collateral" if collateral_group == "future_crops"
replace collateral_group2 = "asset_collateral" if collateral_group == "savings"
replace collateral_group2 = "asset_collateral" if collateral_group == "life_insurance"

replace collateral_group2 = "personal_guarantee" if collateral_group == "guarantor"
replace collateral_group2 = "income_contract" if collateral_group == "salary_work_contract"
replace collateral_group2 = "no_collateral" if collateral_group == "no_collateral"
replace collateral_group2 = "other_unknown_na" if collateral_group == "other_unknown_na"



save"Loans_v03.dta", replace
****************************************
* END

























****************************************
* Second collateral
****************************************
use"Loans_v03.dta", clear

preserve
keep secondcoll
duplicates drop
restore

********** Variable source
gen secondcoll_clean = lower(strtrim(secondcoll))


********** Enlever les préfixes numériques : "3 - ..."
replace secondcoll_clean = regexr(secondcoll_clean, "^[0-9]+[ ]*-[ ]*", "")

********** Nettoyage léger
replace secondcoll_clean = subinstr(secondcoll_clean, "  ", " ", .)
replace secondcoll_clean = subinstr(secondcoll_clean, "garantor", "guarantor", .)
replace secondcoll_clean = subinstr(secondcoll_clean, "garantors", "guarantors", .)
replace secondcoll_clean = subinstr(secondcoll_clean, "farmers' union", "farmers union", .)
replace secondcoll_clean = subinstr(secondcoll_clean, "salary (work contract) or retired salary", "salary/work contract", .)
replace secondcoll_clean = subinstr(secondcoll_clean, "other specify", "other, specify", .)

********** Cat
gen secondcoll_group = ""

replace secondcoll_group = "no_other_requirement" if secondcoll_clean == "no other requirement"

replace secondcoll_group = "guarantor" if secondcoll_clean == "individual guarantor"
replace secondcoll_group = "guarantor" if secondcoll_clean == "other multiple guarantors"

replace secondcoll_group = "credit_group_membership" if secondcoll_clean == "credit group membership"

replace secondcoll_group = "social_political_membership" if ///
    strpos(secondcoll_clean,"membership in social/political group")

replace secondcoll_group = "savings_account" if secondcoll_clean == "savings account at the bank"

replace secondcoll_group = "school_enrollment" if secondcoll_clean == "currently enrolled in school or university"

replace secondcoll_group = "income_contract" if secondcoll_clean == "salary/work contract"

replace secondcoll_group = "residential_land" if secondcoll_clean == "residential land"

replace secondcoll_group = "relative_in_bank" if secondcoll_clean == "has relative working in the bank"

replace secondcoll_group = "poor_household_status" if secondcoll_clean == "poor household"

replace secondcoll_group = "insurance" if strpos(secondcoll_clean,"insurance")

replace secondcoll_group = "other_unknown_na" if secondcoll_clean == "other, specify"
replace secondcoll_group = "other_unknown_na" if secondcoll_clean == "don't know"
replace secondcoll_group = "other_unknown_na" if secondcoll_clean == "no answer"
replace secondcoll_group = "other_unknown_na" if secondcoll_clean == "not applicable"


********** Version agrégée
gen secondcoll_group2 = ""

replace secondcoll_group2 = "no_other_requirement" if secondcoll_group == "no_other_requirement"

replace secondcoll_group2 = "personal_guarantee" if secondcoll_group == "guarantor"
replace secondcoll_group2 = "membership_requirement" if secondcoll_group == "credit_group_membership"
replace secondcoll_group2 = "membership_requirement" if secondcoll_group == "social_political_membership"

replace secondcoll_group2 = "financial_or_asset_requirement" if secondcoll_group == "savings_account"
replace secondcoll_group2 = "financial_or_asset_requirement" if secondcoll_group == "residential_land"
replace secondcoll_group2 = "financial_or_asset_requirement" if secondcoll_group == "insurance"

replace secondcoll_group2 = "income_or_status_requirement" if secondcoll_group == "income_contract"
replace secondcoll_group2 = "income_or_status_requirement" if secondcoll_group == "school_enrollment"
replace secondcoll_group2 = "income_or_status_requirement" if secondcoll_group == "poor_household_status"
replace secondcoll_group2 = "income_or_status_requirement" if secondcoll_group == "relative_in_bank"

replace secondcoll_group2 = "other_unknown_na" if secondcoll_group == "other_unknown_na"



save"Loans_v04.dta", replace
****************************************
* END













****************************************
* Reste
****************************************
use"Loans_v04.dta", clear


***** Type
ta type
gen type2=2
label define type2 1"Cash" 2"Other"
label values type2 type2
replace type2=1 if type=="Cash"
replace type2=1 if type=="a loan"
replace type2=1 if type=="5 - Cash"
replace type2=1 if type=="USD"
*
ta type type2, m
drop type

***** Shock
ta shock
gen shock2=0
label define shock2 0"No" 1"Yes"
label values shock2 shock2
replace shock2=1 if shock=="yes"
replace shock2=1 if shock=="1 - Yes"
*
ta shock shock2, m
drop shock

ta year country

***** Duration year
gen durationyear2=.
replace durationyear2=durationyear if durationyear!=.
replace durationyear2=durationn if durationunit==1
replace durationyear2=durationn/12 if durationunit==2
replace durationyear2=durationn/52 if durationunit==3
replace durationyear2=durationn/365 if durationunit==4

mdesc durationyear2


save"Loans_v05.dta", replace
****************************************
* END













****************************************
* Selection
****************************************
use"Loans_v05", clear


global loanvar ///
loanid ///
amount ///
interestrate ///
productive ///
lender_group ///
reason_group reason_group2 ///
collateral_group collateral_group2 ///
secondcoll_group secondcoll_group2 ///
type2 ///
shock2 ///
durationyear2

* Selection
keep country year hhid $loanvar

* Missings
mdesc $loanvar
ta country year if interestrate==.
ta country year if durationyear2==.
ta country year if secondcoll_group==""

* Trop missings
egen nbmiss=rowmiss($loanvar)
ta nbmiss
keep if nbmiss==0
drop nbmiss

ta year country

save"Loans_v06.dta", replace
****************************************
* END












****************************************
* Cleaning and encode
****************************************
use"Loans_v06", clear

*** Country
ta country
replace country="Thailand" if country=="Thai"
replace country="Vietnam" if country=="Viet"
encode country, gen(country_en)
drop country
rename country_en country
fre country
order country, first

*** Deflate
ta amount
gen amount2=amount
*
replace amount2=amount*(100/92.6) if country==1 & year==2007
replace amount2=amount*(100/97.7) if country==1 & year==2008
replace amount2=amount*(100/100) if country==1 & year==2010
replace amount2=amount*(100/103.8) if country==1 & year==2011
replace amount2=amount*(100/110.5) if country==1 & year==2016
replace amount2=amount*(100/111.3) if country==1 & year==2017
*
replace amount2=amount*(100/69.7) if country==2 & year==2007
replace amount2=amount*(100/85.8) if country==2 & year==2008
replace amount2=amount*(100/100) if country==2 & year==2010
replace amount2=amount*(100/118.7) if country==2 & year==2011
replace amount2=amount*(100/148.4) if country==2 & year==2016
replace amount2=amount*(100/153.6) if country==2 & year==2017
order amount2, after(amount)
drop amount
rename amount2 amount

*** Lender
ta lender_group
ta lender_group country, col nofreq
gen lender=.
label define lender 1"Formal private" 2"Formal public" 3"Formal organization" 4"Cooperative/community" 5"Business network" 6"Money lender" 7"Relatives" 8"Friends" 9"Other"
label values lender lender
replace lender=1 if lender_group=="formprivcredit"
replace lender=2 if lender_group=="pubank_govprog"
replace lender=3 if lender_group=="socinstorg"
replace lender=4 if lender_group=="coopcommcredit"
replace lender=5 if lender_group=="businetw"
replace lender=6 if lender_group=="moneylender"
replace lender=7 if lender_group=="relatives"
replace lender=8 if lender_group=="friends"
replace lender=9 if lender_group=="other"
ta lender_group lender
drop lender_group

*** Reason
ta reason_group country, col nofreq
ta reason_group2 country, col nofreq
drop reason_group
gen reason=.
label define reason 1"Investment" 2"Housing/land" 3"Human capital" 4"Consumption" 5"Debt repayment" 6"Ceremony or relend" 7"Migration" 8"Other"
label values reason reason
replace reason=1 if reason_group2=="productive"
replace reason=2 if reason_group2=="housing_land"
replace reason=3 if reason_group2=="human_capital"
replace reason=4 if reason_group2=="consumption"
replace reason=5 if reason_group2=="debt_repayment"
replace reason=6 if reason_group2=="transfers"
replace reason=7 if reason_group2=="work_migration"
replace reason=8 if reason_group2=="other_unknown"
ta reason
drop reason_group2
drop productive

*** Type
rename type2 type

*** Shock
rename shock2 shock

*** Colleral
ta collateral_group
ta collateral_group2
drop collateral_group
gen collateral=.
label define collateral 1"Personal" 2"Asset" 3"Other" 4"No collateral"
label values collateral collateral
replace collateral=1 if collateral_group2=="personal_guarantee"
replace collateral=2 if collateral_group2=="asset_collateral"
replace collateral=3 if collateral_group2=="income_contract"
replace collateral=3 if collateral_group2=="other_unknown_na"
replace collateral=4 if collateral_group2=="no_collateral"
ta collateral
drop collateral_group2

*** Second collateral
ta secondcoll_group
ta secondcoll_group2
drop secondcoll_group
gen secondcollateral=.
label define secondcollateral 1"Membership" 2"Personal" 3"Asset" 4"Income/stats" 5"Other" 6"No other coll"
label values secondcollateral secondcollateral
replace secondcollateral=1 if secondcoll_group2=="membership_requirement"
replace secondcollateral=2 if secondcoll_group2=="personal_guarantee"
replace secondcollateral=3 if secondcoll_group2=="financial_or_asset_requirement"
replace secondcollateral=4 if secondcoll_group2=="income_or_status_requirement"
replace secondcollateral=5 if secondcoll_group2=="other_unknown_na"
replace secondcollateral=6 if secondcoll_group2=="no_other_requirement"
ta secondcollateral
drop secondcoll_group2

*** Durationyear2
ta durationyear2
rename durationyear2 durationyear
gen duration=.
label define duration 1"Duration: Less than 1y" 2"Duration: [1;2[" 3"Duration: [2;5[" 4"Duration: 5y or more"
label values duration duration
replace duration=1 if durationyear<1
replace duration=2 if durationyear>=1 & durationyear<2
replace duration=3 if durationyear>=2 & durationyear<5
replace duration=4 if durationyear>=5
ta duration
drop durationyear

*** Interest rate


*** Order
order country year hhid loanid type amount lender reason shock collateral secondcollateral duration interestrate

****************************************
* END
