cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
May 13, 2021
-----
Personality traits
-----
help fvvarlist
-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Skills_and_debt\New_analysis"
cd"$directory"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v16"
****************************************
* END



****************************************
* WIDE
****************************************

**********
use"panel_wide", clear
rename sex_1 sex

********** Indebtedness measure
probit bin_d_loanamount_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste

probit bin_d_DSR_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste

reg loanamount_indiv_2 base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5  i.sex i.caste
*pe

reg DSR_indiv_2 base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5  i.sex i.caste





********** Interest measure
probit bin_d_ISR_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste

reg ISR_indiv_2 base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5  i.sex i.caste






********** Type of debt measure
probit bin_d_FormR_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste
*pe

probit cat_d_InformR_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste
*pe car corollaire

probit bin_d_IncogenR_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste
*pe

probit bin_d_NoincogenR_indiv base_raven_tt base_num_tt base_lit_tt base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 i.sex i.caste
*pe car corollaire





i.sex_1 assets_1 i.house_1 i.ownland_1 totalincome_indiv_1 hhsize_1 i.caste i.relationshiptohead_1 i.edulevel_1 i.mainoccupation_indiv_1 age_1 c.age_1#c.age_1 

i.villageid


****************************************
* END





****************************************
* LONG
****************************************

**********
use"panel_long", clear



xtset panelvar year

xtreg DSR_indiv i.HHFE, fe



****************************************
* END
