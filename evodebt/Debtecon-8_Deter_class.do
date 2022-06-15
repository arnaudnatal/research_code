cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 31, 2022
-----
Stat for indebtedness and over-indebtedness
-----

-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid compact

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"


********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END









****************************************
* Desc
****************************************
cls
use"panel_v10_wide.dta", clear

ta dummyvuln


********** Caste and class
cls
foreach x in caste cat_income cat_assets {
ta `x' dummyvuln, row nofreq chi2
}


********** Burden of debt
cls
foreach x in DSR DAR_without DIR assets_noland annualincome loanamount {
tabstat `x'2010 `x'2016 `x'2020, stat(mean sd p50) by(dummyvuln)
}


********** Type and use of debt I
cls
foreach x in formal eco current humank social home {
tabstat rel_`x'_HH2010 rel_`x'_HH2016 rel_`x'_HH2020, stat(mean sd p50) by (dummyvuln)
}

********** Type and use of debt II
cls
foreach x in formal informal eco current humank social home {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by (dummyvuln)
}


********** Type and use of debt III
cls
foreach x in dummyincrel_formal dummyincrel_informal dummyincrel_repay_amt dummyincrel_eco dummyincrel_current dummyincrel_social dummyincrel_humank dummyinc_nagri {
ta `x' dummyvuln, col nofreq
}



********** Trap
cls
foreach x in repay_amt rel_repay_amt MLborrowstrat_amt rel_MLborrowstrat_amt {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by (dummyvuln)
}


********** SBD
cls
foreach x in sbd_assets_noland sbd_dsr sbd_dar sbd_annualincome sbd_dir {
ta `x' dummyvuln, nofreq row
}


********** Good // Bad
cls
foreach x in rel_MLgooddebt_amt rel_MLbaddebt_amt {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by(dummyvuln)
}


********** Multiple borrowing
cls
foreach x in rel_lf_IMF rel_lf_bank rel_lf_moneylender {
tabstat `x'_amt_HH2010 `x'_amt_HH2016 `x'_amt_HH2020, stat(mean sd p50) by(dummyvuln)
}


********** Threaten debt
cls
foreach x in rel_MLstrat_asse rel_MLstrat_migr {
tabstat `x'_amt_HH2010 `x'_amt_HH2016 `x'_amt_HH2020, stat(mean sd p50) by(dummyvuln)
}



********** Over
cls
foreach x in 30 40 50 {
tabstat DSR`x'2010 DSR`x'2016 DSR`x'2020, stat(mean) by(dummyvuln)
}


********** Head
cls
foreach x in edulevel occupation {
ta head_`x'2010 dummyvuln, nofreq row
*ta head_`x'2016 dummyvuln, nofreq row
*ta head_`x'2020 dummyvuln, nofreq row
}


********** Wife
cls
foreach x in edulevel occupation {
ta wifehusb_`x'2010 dummyvuln, nofreq row
*ta wifehusb_`x'2016 dummyvuln, nofreq row
*ta wifehusb_`x'2020 dummyvuln, nofreq row
}


****************************************
* END









****************************************
* ECONOMETRIC
****************************************
use"panel_v10_wide.dta", clear

ta cl_vuln dummyvuln
ta caste dummyvuln

********** store var from v4
preserve
use"panel_v4", clear
label define housetype 1"Concrete house (non-govt)" 2"Government/green house" 3"Thatched roof house"
label values housetype housetype
keep if panel==1
keep HHID_panel year housetype housetitle HHsize nbchildren dummymarriage ownland nontoworkers femtomale
reshape wide housetype housetitle HHsize nbchildren dummymarriage ownland nontoworkers femtomale, i(HHID_panel) j(year)
save"_temp_v4", replace
restore

merge 1:1 HHID_panel using "_temp_v4"
drop _merge
erase "_temp_v4.dta"

********** recode
foreach t in 2010 2016 2020 {
***** sex
recode head_sex`t' (1=0) (2=1)
rename head_sex`t' head_female`t'
label define sex2 0"Male" 1"Female", replace
label values head_female`t' sex2
recode wifehusb_sex`t' (1=0) (2=1)
rename wifehusb_sex`t' wifehusb_female`t'
label values wifehusb_female`t' sex2

***** occupation
recode head_occupation`t' (5=4)
recode wifehusb_occupation`t' (5=4)

***** education
recode head_edulevel`t' (3=2) (4=2) (5=2)
recode wifehusb_edulevel`t' (3=2) (4=2) (5=2)

***** marital status
label define marital 1"Married" 2"Unmarried" 3"Widowed" 4"Separated/divorced", replace
label values head_maritalstatus`t' marital
label values wifehusb_maritalstatus`t' marital
recode head_maritalstatus`t' (2=0) (3=0) (4=0)
recode wifehusb_maritalstatus`t' (2=0) (3=0) (4=0)
rename head_maritalstatus`t' head_married`t'
rename wifehusb_maritalstatus`t' wifehusb_married`t'

***** villagearea
gen village_ur`t'=.
replace village_ur`t'=0 if villagearea`t'=="Colony"
replace village_ur`t'=1 if villagearea`t'=="Ur"
}

********** var to keep
global id HHID_panel sbd_* dummyvuln cl_vuln dummymarriage*
global wealth assets_noland* annualincome*
global hhcharact HHsize* nbchildren* dummymarriage* villageid* village_ur* caste* jatis* ownland* nontoworkers* femtomale* housetype* housetitle*
global headwife head_* wifehusb_* 
global debt1 DSR* DIR* ISR* DAR* loanamount*
global debt2 rel_repay_amt_HH* rel_formal_HH* rel_informal_HH* rel_eco_HH* rel_current_HH* rel_humank_HH* rel_social_HH* rel_home_HH*
global debt3 dummyIMF* dummybank* dummymoneylender* dummyrepay* dummyborrowstrat* dummymigrstrat* dummyassestrat*

global var $id $wealth $hhcharact $headwife $debt1 $debt2 $debt3
keep $var 


save"panel_v11_wide.dta", replace

****************************************
* END











****************************************
* ECONOMETRIC
****************************************
use"panel_v11_wide.dta", clear

********** Spec 1
probit dummyvuln ib(2).caste i.villageid2010, baselevels




****************************************
* END
