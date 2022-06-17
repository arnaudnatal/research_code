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
/*
cluster wardslinkage ihs_DSR2010 ihs_DAR2010 ihs_assets2010, measure(Euclidean) name(CAH)
*cluster dendrogram, cutnumber(100)
cluster gen CAHgrp=groups(2), name(CAH)
cluster kmeans ihs_DSR2010 ihs_DAR2010 ihs_assets2010, k(2) start(g(CAHgrp)) measure(Euclidean) name(km2010)

cluster kmeans ihs_DSR2016 ihs_DAR2016 ihs_assets2016, k(2) start(g(CAHgrp)) measure(Euclidean) name(km2016)
cluster kmeans ihs_DSR2020 ihs_DAR2020 ihs_assets2020, k(2) start(g(CAHgrp)) measure(Euclidean) name(km2020)

ta km2010
ta km2016
ta km2020

foreach x in 2010 2016 2020 {
tabstat DSR`x' DAR`x' assets`x', stat(n mean p50 min max) by(km`x')
}

stripplot DSR2010, over(_clus_2) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)

stripplot DAR2010, over(_clus_2) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)

stripplot assets2010, over(_clus_2) vert ///
stack width(0.05) jitter(0) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)
*/



***** Verif main
ta static_vuln2010 caste, chi2 col nofreq
ta static_vuln2016 caste, chi2 col nofreq
ta static_vuln2020 caste, chi2 col nofreq


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
egen catb1_`x'=cut(de1_`x'), at(-999999 -10 10 9999999)
egen catb2_`x'=cut(de2_`x'), at(-999999 -10 10 9999999)

recode catb1_`x' (-999999=-1) (-10=0) (10=1)
recode catb2_`x' (-999999=-1) (-10=0) (10=1)

label define cut2 -1"Dec" 0"Sta" 1"Inc", replace
label values catb1_`x' cut2
label values catb2_`x' cut2
}


********** Vuln variable
forvalues i=1(1)2 {
egen grp_vuln`i'=group(catb`i'_assets catb`i'_DSR catb`i'_DAR), label

gen dynadummyvuln`i'=.
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==-1 & catb`i'_DSR==-1
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==-1 & catb`i'_DSR==0
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==-1 & catb`i'_DSR==1
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==0 & catb`i'_DSR==-1
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==0 & catb`i'_DSR==0
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==0 & catb`i'_DSR==1
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==1 & catb`i'_DSR==-1
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==1 & catb`i'_DSR==0
replace dynadummyvuln`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==1 & catb`i'_DSR==1
replace dynadummyvuln`i'=0 if catb`i'_assets==0 & catb`i'_DAR==-1 & catb`i'_DSR==-1
replace dynadummyvuln`i'=0 if catb`i'_assets==0 & catb`i'_DAR==-1 & catb`i'_DSR==0
replace dynadummyvuln`i'=0 if catb`i'_assets==0 & catb`i'_DAR==-1 & catb`i'_DSR==1
replace dynadummyvuln`i'=0 if catb`i'_assets==0 & catb`i'_DAR==0 & catb`i'_DSR==-1
replace dynadummyvuln`i'=0 if catb`i'_assets==0 & catb`i'_DAR==0 & catb`i'_DSR==0
replace dynadummyvuln`i'=1 if catb`i'_assets==0 & catb`i'_DAR==0 & catb`i'_DSR==1
replace dynadummyvuln`i'=1 if catb`i'_assets==0 & catb`i'_DAR==1 & catb`i'_DSR==-1
replace dynadummyvuln`i'=1 if catb`i'_assets==0 & catb`i'_DAR==1 & catb`i'_DSR==0
replace dynadummyvuln`i'=1 if catb`i'_assets==0 & catb`i'_DAR==1 & catb`i'_DSR==1
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==-1 & catb`i'_DSR==-1
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==-1 & catb`i'_DSR==0
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==-1 & catb`i'_DSR==1
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==0 & catb`i'_DSR==-1
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==0 & catb`i'_DSR==0
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==0 & catb`i'_DSR==1
replace dynadummyvuln`i'=0 if catb`i'_assets==1 & catb`i'_DAR==1 & catb`i'_DSR==-1
replace dynadummyvuln`i'=1 if catb`i'_assets==1 & catb`i'_DAR==1 & catb`i'_DSR==0
replace dynadummyvuln`i'=1 if catb`i'_assets==1 & catb`i'_DAR==1 & catb`i'_DSR==1
}

ta dynadummyvuln1, m
ta dynadummyvuln2, m
ta dynadummyvuln1 dynadummyvuln2, row nofreq

ta dynadummyvuln1 caste, m exp cchi2
ta dynadummyvuln2 caste, m exp cchi2



***** Tercile assets and income 
foreach t in 2010 2016 2020 {
xtile t_income`t'=income`t', n(3)
xtile t_assets`t'=assets`t', n(3)
}


ta dynadummyvuln1 t_income2010, chi2 exp cchi2
ta dynadummyvuln1 t_assets2010, chi2 exp cchi2

ta dynadummyvuln2 t_income2016, chi2 exp cchi2
ta dynadummyvuln2 t_assets2016, chi2 exp cchi2

ta t_assets2010 t_assets2016 if dynadummyvuln1==1, row nofreq



********** All diff var
***** Quanti: first diff
foreach x in income assets nbchildren HHsize rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH repay_amt_HH formal_HH informal_HH eco_HH current_HH humank_HH social_HH home_HH {
gen `x'_v1=`x'2016-`x'2010
gen `x'_v2=`x'2020-`x'2016
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

reshape long grp_vuln dynadummyvuln income_v assets_v nbchildren_v HHsize_v rel_repay_amt_HH_v rel_formal_HH_v rel_informal_HH_v rel_eco_HH_v rel_current_HH_v rel_humank_HH_v rel_social_HH_v rel_home_HH_v repay_amt_HH_v formal_HH_v informal_HH_v eco_HH_v current_HH_v humank_HH_v social_HH_v home_HH_v mainocc_occupation_v housetype_v housetitle_v ownland_v occupation_v, i(HHID_panel) j(p)
xtset panelvar p

fre occupation_v
xtprobit dynadummyvuln i.caste i.occupation_v, baselevel


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
