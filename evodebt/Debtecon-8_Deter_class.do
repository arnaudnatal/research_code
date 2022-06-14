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

ta cl_vuln caste, col nofreq


********** Caste and class
foreach x in caste cat_income cat_assets {
ta `x' dummyvuln, row nofreq chi2
}


********** Burden of debt
cls
foreach x in DSR DAR_without DIR assets_noland annualincome loanamount {
tabstat `x'2010 `x'2016 `x'2020, stat(mean sd p50) by(dummyvuln)
}
cls
foreach x in DSR DAR_without DIR assets_noland annualincome loanamount {
tabstat `x'2010 `x'2016 `x'2020, stat(mean sd p50) by(cl_vuln)
}

********** Type and use of debt I
cls
foreach x in formal informal eco current humank social home {
tabstat rel_`x'_HH2010 rel_`x'_HH2016 rel_`x'_HH2020, stat(mean sd p50) by (dummyvuln)
}

********** Type and use of debt II
cls
foreach x in formal informal eco current humank social home {
tabstat `x'_HH2010 `x'_HH2016 `x'_HH2020, stat(mean sd p50) by (dummyvuln)
}

/*
********** Type and use of debt III
foreach x in dummyincrel_formal dummyincrel_informal dummyincrel_repay_amt dummyincrel_eco dummyincrel_current dummyincrel_social dummyincrel_humank dummyinc_nagri {
ta `x' dummyvuln, col nofreq
}
*/




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



*informal + current + humank 
****************************************
* END









****************************************
* ECONOMETRIC
****************************************
use"panel_v10_wide.dta", clear

ta cl_vuln dummyvuln
ta caste dummyvuln


********** Test econometrisc
global head head_age2010 i.head_edulevel2010 i.head_occupation2010##i.head_changeocc_gl

global wife i.wifehusb_sex2010 wifehusb_age2010 i.wifehusb_edulevel2010 i.wifehusb_occupation2010

probit dummyvuln i.caste i.villageid2010, baselevels



********** Evo type and use of debt
probit dummyvuln i.dummyincrel_formal i.dummyincrel_eco 


dummyinc_current dummyincrel_current dummyinc_social dummyincrel_social dummyinc_humank dummyincrel_humank dummyinc_agri dummyinc_nagri

****************************************
* END
