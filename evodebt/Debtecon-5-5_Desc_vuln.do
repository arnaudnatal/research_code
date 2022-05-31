cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
December 07, 2021
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
* CHARACT VULN
****************************************
cls
use "panel_v10_wide", clear

preserve
keep HHID_panel sbd_annualincome sbd_assets_noland sbd_dsr sbd_dar cl_vuln dummyvuln dummysust
duplicates drop
save"trends", replace
restore

********** Desc comp
ta caste			cl_vuln, row nofreq
ta cat_assets		cl_vuln, row nofreq
ta cat_income		cl_vuln, row nofreq

ta caste			cl_vuln, exp cchi2 chi2
ta cat_assets		cl_vuln, exp cchi2 chi2
ta cat_income		cl_vuln, exp cchi2 chi2

ta sbd_assets		cl_vuln, row nofreq
ta sbd_dar			cl_vuln, row nofreq
ta sbd_dsr			cl_vuln, row nofreq
ta sbd_loanamount	cl_vuln, row nofreq

ta sbd_assets		cl_vuln, exp cchi2 chi2
ta sbd_dar			cl_vuln, exp cchi2 chi2
ta sbd_dsr			cl_vuln, exp cchi2 chi2
ta sbd_loanamount	cl_vuln, exp cchi2 chi2


********** Desc dummy
ta caste			dummyvuln, row nofreq
ta cat_assets		dummyvuln, row nofreq
ta cat_income		dummyvuln, row nofreq

ta sbd_assets		dummyvuln, row nofreq
ta sbd_dar			dummyvuln, row nofreq
ta sbd_dsr			dummyvuln, row nofreq
ta sbd_loanamount	dummyvuln, row nofreq

ta caste cl_vuln

****************************************
* END












****************************************
* MORE COMPLETE
****************************************
cls
use "panel_v10_wide", clear

/*
Evolution of type and use of debt according to 
the vulnerability group.

Also, segmentation across caste.
*/

***** Var to keep
drop DSR30* DSR40* DSR50*

global suppvar cat_income cat_assets caste jatis villageid* villagearea*

keep HHID_panel panelvar cl_vuln dummyvuln dummysust $suppvar sbd_* loanamount* annualincome* assets_noland* DSR* ihs_DSR* ISR* ihs_ISR* DAR_without* ihs_DAR* ihs_annualincome* ihs_assets_noland* ihs_loanamount* rel_formal_HH* rel_informal_HH* rel_eco_HH* rel_current_HH* rel_humank_HH* rel_social_HH* rel_home_HH* rel_other_HH*


***** Reshape
reshape long annualincome DSR loanamount villageid assets_noland villagearea rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH DAR_without ISR ihs_ISR ihs_DAR ihs_DSR ihs_loanamount ihs_annualincome ihs_assets_noland, i(HHID_panel) j(year)

order HHID_panel panelvar year caste jatis cat_income cat_assets villageid villagearea cl_vuln dummyvuln dummysust

***** Panel declaration
xtset panelvar year

fre cl_vuln

forvalues i=1(1)4{
local d1="Unstable debt"
local d2="Sustainable debt"
local d3="Vulnerable"
local d4="Highly vulnerable"
local j="`d`i''"
twoway (line rel_informal_HH year if cl_vuln==`i', c(L) lcolor(black%10)) ///
, xlabel(2010 2016 2020) xmtick(2010(1)2020) xtitle("Year") ///
ylabel() ymtick() ytitle("Assets (ihs)") ///
title("`j'") ///
aspectratio(0.5) ///
name(gph_info`i', replace)
}


