cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 17, 2021
-----
Short trends and static vuln
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
* Static vulnerability
****************************************
cls
use"panel_v11_wide", clear


********** ML
***** 2010
cluster wardslinkage ihs_DSR2010 ihs_DAR2010 ihs_assets2010, measure(Euclidean) name(CAH2010)
*cluster dendrogram, cutnumber(100)
cluster gen CAHgrp2010=groups(2), name(CAH2010)
ta CAHgrp2010
cluster kmeans ihs_DSR2010 ihs_DAR2010 ihs_assets2010, k(2) start(g(CAHgrp2010)) measure(Euclidean) name(km2010)
tabstat DSR2010 DAR2010 assets2010, stat(n q) by(km2010)
drop CAH2010_id CAH2010_ord CAH2010_hgt CAHgrp2010

***** 2016-17
cluster wardslinkage ihs_DSR2016 ihs_DAR2016 ihs_assets2016, measure(Euclidean) name(CAH2016)
*cluster dendrogram, cutnumber(100)
cluster gen CAHgrp2016=groups(2), name(CAH2016)
ta CAHgrp2016
cluster kmeans ihs_DSR2016 ihs_DAR2016 ihs_assets2016, k(2) start(g(CAHgrp2016)) measure(Euclidean) name(km2016)
tabstat DSR2016 DAR2016 assets2016, stat(n q) by(km2016)
drop CAH2016_id CAH2016_ord CAH2016_hgt CAHgrp2016

***** 2020-21
cluster wardslinkage ihs_DSR2020 ihs_DAR2020 ihs_assets2020, measure(Euclidean) name(CAH2020)
*cluster dendrogram, cutnumber(100)
cluster gen CAHgrp2020=groups(2), name(CAH2020)
ta CAHgrp2020
cluster kmeans ihs_DSR2020 ihs_DAR2020 ihs_assets2020, k(2) start(g(CAHgrp2020)) measure(Euclidean) name(km2020)
tabstat DSR2020 DAR2020 assets2020, stat(n q) by(km2020)
drop CAH2020_id CAH2020_ord CAH2020_hgt CAHgrp2020


**********
/*
stripplot assets2010, over(_clus_2) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)
*/


********** Codage main
foreach x in 2010 2016 2020 {
tabstat DSR`x' DAR`x' assets`x', stat(n q) by(km`x')
}

gen static_ml_vuln2010=.
replace static_ml_vuln2010=0 if km2010==2
replace static_ml_vuln2010=1 if km2010==1

gen static_ml_vuln2016=.
replace static_ml_vuln2016=0 if km2016==2
replace static_ml_vuln2016=1 if km2016==1


gen static_ml_vuln2020=.
replace static_ml_vuln2020=0 if km2020==1
replace static_ml_vuln2020=1 if km2020==2

label define vuln 0"No" 1"Yes"
label values static_ml_vuln2010 vuln
label values static_ml_vuln2016 vuln
label values static_ml_vuln2020 vuln

tabstat DSR2010 DAR2010 assets2010, stat(n q) by(static_ml_vuln2010)
tabstat DSR2016 DAR2016 assets2016, stat(n q) by(static_ml_vuln2016)
tabstat DSR2020 DAR2020 assets2020, stat(n q) by(static_ml_vuln2020)






********* Program
program define stripgraph
stripplot `1', over(dummyvuln) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)
end

*stripgraph assets2010


********** Monte Carlo
/*
program define loinorm, rclass
syntax [, obs(integer 1) mu(real 0) sigma(real 1)]
drop _all
set obs `obs'
tempvar z
gen z=exp(`mu'+`sigma'*invnorm(uniform()))
sum `z'
return scalar mean=r(mean)
return scalar Var=r(Var)
end

clear all
loinorm
*/

save "panel_v12_wide", replace
****************************************
* END








****************************************
* Dyanmic between 2010-2016 and 2016-2020
****************************************
cls
use"panel_v12_wide", clear



********** Calcul diff and delta
foreach x in assets DAR DSR income ISR expenses {
gen de1_`x'=(`x'2016-`x'2010)*100/`x'2010
gen de2_`x'=(`x'2020-`x'2016)*100/`x'2016

replace de1_`x'=`x'2016 if `x'2010==0
replace de2_`x'=`x'2020 if `x'2016==0

gen di1_`x'=`x'2016-`x'2010
gen di2_`x'=`x'2020-`x'2016

}





********** Cat evolution
foreach x in assets DAR DSR income ISR expenses {
***** 5 level
egen cat1_`x'=cut(de1_`x'), at(-999999 -50 -10 10 50 9999999)
egen cat2_`x'=cut(de2_`x'), at(-999999 -50 -10 10 50 9999999)

recode cat1_`x' (-999999=-2) (-50=-1) (-10=0) (10=1) (50=2)
recode cat2_`x' (-999999=-2) (-50=-1) (-10=0) (10=1) (50=2)

label define cut1 -2"Hi dec" -1"Dec" 0"Stable" 1"Inc" 2"Hi inc", replace
label values cat1_`x' cut1
label values cat2_`x' cut1

***** 3 level
egen cat_`x'_b1=cut(de1_`x'), at(-999999 -10 10 9999999)
egen cat_`x'_b2=cut(de2_`x'), at(-999999 -10 10 9999999)

recode cat_`x'_b1 (-999999=-1) (-10=0) (10=1)
recode cat_`x'_b2 (-999999=-1) (-10=0) (10=1)

label define cut2 -1"Dec" 0"Sta" 1"Inc", replace
label values cat_`x'_b1 cut2
label values cat_`x'_b2 cut2
}


********** R 
preserve
keep HHID_panel cat_assets_b* cat_DAR_b* cat_DSR_b* cat_income_b* cat_ISR_b* cat_expenses_b*

/*
foreach i in 1 2 {
foreach x in assets DAR DSR income ISR expenses {
rename di`i'_`x' di_`x'`i'
rename de`i'_`x' de_`x'`i'
}
}
*/
reshape long cat_assets_b cat_DAR_b cat_DSR_b cat_income_b cat_ISR_b cat_expenses_b, i(HHID_panel) j(tempo)
export delimited using "$git\research_code\evodebt\debttrend_new_v1.csv", replace
restore

preserve
import delimited using "$git\research_code\evodebt\debttrend_new_v2.csv", clear
gen sdvuln=.
replace sdvuln=0 if clust==1
replace sdvuln=0 if clust==2
replace sdvuln=1 if clust==3
replace sdvuln=1 if clust==4
ta sdvuln tempo, col nofreq
keep hhid_panel tempo clust sdvuln
reshape wide clust sdvuln, i(hhid_panel) j(tempo)
ta sdvuln1 sdvuln2, row nofreq
rename hhid_panel HHID_panel
save"_temp_clust.dta", replace
restore


********** All diff var
***** Quanti: first diff
foreach x in income assets nbchildren HHsize rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH repay_amt_HH formal_HH informal_HH eco_HH current_HH humank_HH social_HH home_HH {
gen `x'_v1=`x'2016-`x'2010
gen `x'_v2=`x'2020-`x'2016

gen dummy_`x'_v1=0
replace dummy_`x'_v1=1 if `x'_v1>0

gen dummy_`x'_v2=0
replace dummy_`x'_v2=1 if `x'_v2>0
}


cls
***** Quali: change

***
/*
Before: agri agri
*/
fre mainocc_occupation2016
foreach x in 2010 2016 2020 {
clonevar occupation`x'=mainocc_occupation`x'
recode occupation`x' (2=1) (3=2) (4=2) (6=2) (7=2)
label define occup 1"Agri." 2"Non-agri.", replace
label values occupation`x' occup 
}
***
foreach x in mainocc_occupation housetype housetitle ownland occupation {
ta `x'2010 `x'2016
ta `x'2016 `x'2020
egen `x'_v1=group(`x'2010 `x'2016), label
egen `x'_v2=group(`x'2016 `x'2020), label
}

save "panel_v13_wide", replace
****************************************
* END









****************************************
* Reshape long --> one line, one year
****************************************
cls
use"panel_v13_wide", clear

merge 1:1 HHID_panel using "_temp_clust"
drop _merge


***** Clean
foreach x in income DSR loanamount DIR villageid sizeownland mainocc_occupation head_female head_married head_age head_edulevel head_occupation wifehusb_female wifehusb_married wifehusb_age wifehusb_edulevel wifehusb_occupation expenses assets villagearea agri nagri shareagri sharenagri repay_amt_HH rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH informal_HH formal_HH eco_HH current_HH humank_HH social_HH home_HH other_HH lf_IMF_nb_HH lf_IMF_amt_HH lf_bank_nb_HH lf_bank_amt_HH lf_moneylender_nb_HH lf_moneylender_amt_HH repay_nb_HH MLborrowstrat_nb_HH MLborrowstrat_amt_HH MLgooddebt_nb_HH MLgooddebt_amt_HH MLbaddebt_nb_HH MLbaddebt_amt_HH MLstrat_asse_nb_HH MLstrat_asse_amt_HH MLstrat_migr_nb_HH MLstrat_migr_amt_HH mainloan_HH mainloan_amt_HH rel_lf_IMF_amt_HH rel_lf_bank_amt_HH rel_lf_moneylender_amt_HH rel_mainloan_amt_HH rel_MLborrowstrat_amt_HH rel_MLbaddebt_amt_HH rel_MLgooddebt_amt_HH rel_MLstrat_asse_amt_HH rel_MLstrat_migr_amt_HH dummyIMF dummybank dummymoneylender dummyrepay dummyborrowstrat dummymigrstrat dummyassestrat sum_loans_HH DAR DAR_with ISR DSR30 DSR40 DSR50 ihs_ISR ihs_DAR ihs_DSR ihs_DIR ihs_DIR10 ihs_DIR100 ihs_DIR1000 ihs_DIR10000 ihs_loanamount ihs_income ihs_assets ihs_yearly_expenses ihs_informal_HH ihs_rel_informal_HH ihs_formal_HH ihs_rel_formal_HH ihs_eco_HH ihs_rel_eco_HH ihs_current_HH ihs_rel_current_HH ihs_humank_HH ihs_rel_humank_HH ihs_social_HH ihs_rel_social_HH ihs_home_HH ihs_rel_home_HH ihs_repay_amt_HH ihs_rel_repay_amt_HH ownland dummymarriage housetype housetitle HHsize nbchildren nontoworkers femtomale village_ur static_vuln km static_ml_vuln occupation {
rename `x'2010 `x'1
rename `x'2016 `x'2
drop `x'2020
}



********** Reshape
reshape long clust sdvuln income_v assets_v nbchildren_v HHsize_v rel_repay_amt_HH_v rel_formal_HH_v rel_informal_HH_v rel_eco_HH_v rel_current_HH_v rel_humank_HH_v rel_social_HH_v rel_home_HH_v repay_amt_HH_v formal_HH_v informal_HH_v eco_HH_v current_HH_v humank_HH_v social_HH_v home_HH_v mainocc_occupation_v housetype_v housetitle_v ownland_v occupation_v income DSR loanamount DIR villageid sizeownland mainocc_occupation head_female head_married head_age head_edulevel head_occupation wifehusb_female wifehusb_married wifehusb_age wifehusb_edulevel wifehusb_occupation expenses assets villagearea agri nagri shareagri sharenagri repay_amt_HH rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH informal_HH formal_HH eco_HH current_HH humank_HH social_HH home_HH other_HH lf_IMF_nb_HH lf_IMF_amt_HH lf_bank_nb_HH lf_bank_amt_HH lf_moneylender_nb_HH lf_moneylender_amt_HH repay_nb_HH MLborrowstrat_nb_HH MLborrowstrat_amt_HH MLgooddebt_nb_HH MLgooddebt_amt_HH MLbaddebt_nb_HH MLbaddebt_amt_HH MLstrat_asse_nb_HH MLstrat_asse_amt_HH MLstrat_migr_nb_HH MLstrat_migr_amt_HH mainloan_HH mainloan_amt_HH rel_lf_IMF_amt_HH rel_lf_bank_amt_HH rel_lf_moneylender_amt_HH rel_mainloan_amt_HH rel_MLborrowstrat_amt_HH rel_MLbaddebt_amt_HH rel_MLgooddebt_amt_HH rel_MLstrat_asse_amt_HH rel_MLstrat_migr_amt_HH dummyIMF dummybank dummymoneylender dummyrepay dummyborrowstrat dummymigrstrat dummyassestrat sum_loans_HH DAR DAR_with ISR DSR30 DSR40 DSR50 ihs_ISR ihs_DAR ihs_DSR ihs_DIR ihs_DIR10 ihs_DIR100 ihs_DIR1000 ihs_DIR10000 ihs_loanamount ihs_income ihs_assets ihs_yearly_expenses ihs_informal_HH ihs_rel_informal_HH ihs_formal_HH ihs_rel_formal_HH ihs_eco_HH ihs_rel_eco_HH ihs_current_HH ihs_rel_current_HH ihs_humank_HH ihs_rel_humank_HH ihs_social_HH ihs_rel_social_HH ihs_home_HH ihs_rel_home_HH ihs_repay_amt_HH ihs_rel_repay_amt_HH ownland dummymarriage housetype housetitle HHsize nbchildren nontoworkers femtomale village_ur static_vuln km static_ml_vuln occupation dummy_income_v dummy_assets_v dummy_nbchildren_v dummy_HHsize_v dummy_rel_repay_amt_HH_v dummy_rel_formal_HH_v dummy_rel_eco_HH_v dummy_rel_current_HH_v dummy_rel_humank_HH_v dummy_rel_social_HH_v dummy_rel_home_HH_v, i(HHID_panel) j(p)

drop dummy_rel_informal_HH_v1 dummy_rel_informal_HH_v2 dummy_rel_eco_HH_v dummy_rel_current_HH_v dummy_rel_humank_HH_v dummy_rel_social_HH_v dummy_rel_home_HH_v dummy_repay_amt_HH_v1 dummy_repay_amt_HH_v2 dummy_formal_HH_v1 dummy_formal_HH_v2 dummy_informal_HH_v1 dummy_informal_HH_v2 dummy_eco_HH_v1 dummy_eco_HH_v2 dummy_current_HH_v1 dummy_current_HH_v2 dummy_humank_HH_v1 dummy_humank_HH_v2 dummy_social_HH_v1 dummy_social_HH_v2 dummy_home_HH_v1 dummy_home_HH_v2


xtset panelvar p

global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid

global varv dummy_nbchildren_v dummy_HHsize_v dummy_rel_repay_amt_HH_v dummy_rel_formal_HH_v


********** Cross section
preserve
keep if p==1
probit sdvuln i.caste $head $wealth $HH
probit sdvuln i.caste $varv
restore

preserve
keep if p==2
probit sdvuln i.caste $head $wealth $HH
restore


********** Panel model
xtprobit sdvuln i.caste $head $wealth $HH
xtprobit sdvuln i.caste $varv

*** CRE
/*
egen xbar=mean(x), by(HHID_panel)
xtprobit sdvuln , re  
*/


save "panel_v13_long", replace
****************************************
* END








****************************************
* Analysis 1
****************************************
cls
use"panel_v13_wide", clear


********** Step 1: Static analysis of financial vulnerability

ta static_vuln2010
ta static_vuln2016
ta static_vuln2020

/*
Why not CRO model for caste integration?
However, not take into account the fact that financial vulnerability is 
a dynamic phenomenon.
Thus, we investigate the dynamic of financial vulnerability in step 2
*/




********** Step 2: Dynamic analysis of financial vulnerability

ta dynadummyvuln1
ta dynadummyvuln2

ta static_vuln2010 dynadummyvuln1, row nofreq chi2
ta static_vuln2016 dynadummyvuln2, row nofreq chi2


/*
Same: CRE model with 2 obs/indv: d1 and d2
Vuln = a + b*change in occupation + c*change in income + e

Split the analysis between those who are financial vulnerable in t (with
static measure) and those who are not.
*/

***** X var
ta head_occupation2010 head_occupation2016


****************************************
* END







****************************************
* Analysis 2
****************************************
cls
use"panel_v13_wide", clear

/*
Level of financial vulnerability in 2010;
Look at the dynamic over 10 years
Then look at the level of financial vulnerability in 2020.
*/

ta static_vuln2010 dummyvuln, row
ta static_vuln2020 dummyvuln, row


****************************************
* END
