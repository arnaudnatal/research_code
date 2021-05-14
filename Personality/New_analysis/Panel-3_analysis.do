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


********** Stata package

*coefplot, horizontal xline(0) drop(_cons) levels(95 90 ) ciopts(recast(. rcap))mlabel mlabposition(12) mlabgap(*2)

****************************************
* END








****************************************
* WIDE
****************************************

**********
use"panel_wide", clear

gen female=0 if sex_1==1
replace female=1 if sex_1==2

gen agesq_1=age_1*age_1
gen agesq_2=age_2*age_2

tab caste, gen(caste_)
tab cat_mainoccupation_indiv_1,gen(cat_mainoccupation_indiv_1_)

tab sexratiocat_1, gen(sexratiocat_1_)



********** Macros
global efa base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5
global cog base_raven_tt base_num_tt base_lit_tt

global indivcontrol female age_1 agesq_1 caste_1 caste_3 cat_mainoccupation_indiv_1_1 cat_mainoccupation_indiv_1_2 cat_mainoccupation_indiv_1_3 cat_mainoccupation_indiv_1_4 dummyedulevel 

global hhcontrol assets ownland_1 ownhouse_1 sexratiocat_1_1 sexratiocat_1_3 hhsize_1 shock_1

********** Indebtedness measure
*Is egos in debt?
mprobit debtpath $efa $cog $indivcontrol


*Loan amount
probit bin_d_loanamount_indiv $efa $cog $indivcontrol

reg loanamount_indiv_2 $efa $cog $indivcontrol
*pas mal
reg loanamount_indiv_2 $efa $cog $indivcontrol 
reg loanamount_indiv_2 $efa $cog $indivcontrol i.female#c.base_nocorrf1 i.female#c.base_nocorrf2 i.female#c.base_nocorrf3 i.female#c.base_nocorrf4 i.female#c.base_nocorrf5


*Debt service
probit bin_d_imp1_ds_tot_indiv $efa $cog $indivcontrol

reg imp1_ds_tot_indiv_2 $efa $cog $indivcontrol


*DSR
probit bin_d_DSR_indiv  $efa $cog $indivcontrol
reg DSR_indiv_2  $efa $cog $indivcontrol



********** Interest measure
probit bin_d_ISR_indiv  $efa $cog $indivcontrol

reg ISR_indiv_2  $efa $cog $indivcontrol

probit bin_d_mean_yratepaid_indiv $efa $cog $indivcontrol

reg mean_yratepaid_indiv_2 $efa $cog $indivcontrol




********** Type of debt measure
probit bin_d_FormR_indiv 

probit bin_d_InformR_indiv 

probit bin_d_IncogenR_indiv 

probit bin_d_NoincogenR_indiv 


****************************************
* END










****************************************
* LONG
****************************************

**********
use"panel_long", clear
xtset panelvar year

*graph box totalincome_indiv, by(cat_mainoccupation_indiv) noout


********** Macros
global meantime mean_assets mean_sexratio mean_sexratiocat_1 mean_sexratiocat_2 mean_sexratiocat_3 mean_hhsize mean_shock  mean_age mean_agesq mean_cat_mainoccupation_indiv_1 mean_cat_mainoccupation_indiv_2 mean_cat_mainoccupation_indiv_3 mean_cat_mainoccupation_indiv_4 mean_cat_mainoccupation_indiv_5

global indepvar base_nocorrf1 base_nocorrf2 base_nocorrf3 base_nocorrf4 base_nocorrf5 base_raven_tt base_num_tt base_lit_tt

global controlvar i.cat_mainoccupation_indiv assets hhsize i.shock

global controlinvar i.caste i.sex c.age c.agesq  i.dummyedulevel


********** CRE
cls
*In debt?
xtprobit indebt_indiv $indepvar $controlinvar $controlvar $meantime, re
*F3

xtreg loanamount_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*Nope

xtreg DSR_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*F1 & F2

xtreg ISR_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*Nope

xtreg mean_yratepaid_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*Nope

xtreg FormR_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*F2 & num

xtreg InformR_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*F3

xtreg IncogenR_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*Nope

xtreg NoincogenR_indiv $indepvar $controlinvar $controlvar $meantime, re cluste(panelvar)
*Nope


****************************************
* END
