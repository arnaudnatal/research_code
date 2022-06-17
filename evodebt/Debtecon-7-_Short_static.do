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
use"panel_v10_wide", clear


********** Rename 
foreach x in 2010 2016 2020 {
rename DAR_without`x' DAR`x'
rename assets_noland`x' assets`x'
rename annualincome`x' income`x'
rename yearly_expenses`x' expenses`x'
rename ihs_annualincome`x' ihs_income`x'
rename ihs_assets_noland`x' ihs_assets`x'
}



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



********** Main
foreach x in 2010 2016 2020 {
gen mainvuln`x'=.
replace mainvuln`x'=0 if DSR`x'<.4 | DAR`x'<.5
replace mainvuln`x'=1 if DSR`x'>=.4 | DAR`x'>=.5
}

ta mainvuln2010 caste, chi2 col nofreq
ta mainvuln2016 caste, chi2 col nofreq
ta mainvuln2020 caste, chi2 col nofreq


save "panel_v11_wide", replace
****************************************
* END








****************************************
* Dyanmic between 2010-2016 and 2016-2020
****************************************
cls
use"panel_v11_wide", clear



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
egen vuln_c`i'=group(catb`i'_assets catb`i'_DSR catb`i'_DAR), label

gen dummyvuln_c`i'=.
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==-1 & catb`i'_DSR==-1
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==-1 & catb`i'_DSR==0
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==-1 & catb`i'_DSR==1
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==0 & catb`i'_DSR==-1
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==0 & catb`i'_DSR==0
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==0 & catb`i'_DSR==1
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==1 & catb`i'_DSR==-1
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==1 & catb`i'_DSR==0
replace dummyvuln_c`i'=1 if catb`i'_assets==-1 & catb`i'_DAR==1 & catb`i'_DSR==1
replace dummyvuln_c`i'=0 if catb`i'_assets==0 & catb`i'_DAR==-1 & catb`i'_DSR==-1
replace dummyvuln_c`i'=0 if catb`i'_assets==0 & catb`i'_DAR==-1 & catb`i'_DSR==0
replace dummyvuln_c`i'=0 if catb`i'_assets==0 & catb`i'_DAR==-1 & catb`i'_DSR==1
replace dummyvuln_c`i'=0 if catb`i'_assets==0 & catb`i'_DAR==0 & catb`i'_DSR==-1
replace dummyvuln_c`i'=0 if catb`i'_assets==0 & catb`i'_DAR==0 & catb`i'_DSR==0
replace dummyvuln_c`i'=1 if catb`i'_assets==0 & catb`i'_DAR==0 & catb`i'_DSR==1
replace dummyvuln_c`i'=1 if catb`i'_assets==0 & catb`i'_DAR==1 & catb`i'_DSR==-1
replace dummyvuln_c`i'=1 if catb`i'_assets==0 & catb`i'_DAR==1 & catb`i'_DSR==0
replace dummyvuln_c`i'=1 if catb`i'_assets==0 & catb`i'_DAR==1 & catb`i'_DSR==1
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==-1 & catb`i'_DSR==-1
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==-1 & catb`i'_DSR==0
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==-1 & catb`i'_DSR==1
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==0 & catb`i'_DSR==-1
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==0 & catb`i'_DSR==0
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==0 & catb`i'_DSR==1
replace dummyvuln_c`i'=0 if catb`i'_assets==1 & catb`i'_DAR==1 & catb`i'_DSR==-1
replace dummyvuln_c`i'=1 if catb`i'_assets==1 & catb`i'_DAR==1 & catb`i'_DSR==0
replace dummyvuln_c`i'=1 if catb`i'_assets==1 & catb`i'_DAR==1 & catb`i'_DSR==1
}

ta dummyvuln_c1, m
ta dummyvuln_c2, m
ta dummyvuln_c1 dummyvuln_c2, row nofreq

ta dummyvuln_c1 caste, m exp cchi2
ta dummyvuln_c2 caste, m exp cchi2



***** Tercile assets and income 
foreach t in 2010 2016 2020 {
xtile t_income`t'=income`t', n(3)
xtile t_assets`t'=assets`t', n(3)
}


ta dummyvuln_c1 t_income2010, chi2 exp cchi2
ta dummyvuln_c1 t_assets2010, chi2 exp cchi2

ta dummyvuln_c2 t_income2016, chi2 exp cchi2
ta dummyvuln_c2 t_assets2016, chi2 exp cchi2

ta t_assets2010 t_assets2016 if dummyvuln_c1==1, row nofreq


save "panel_v12_wide", replace
****************************************
* END










****************************************
* Desc
****************************************
cls
use"panel_v12_wide", clear


ta mainvuln2010 dummyvuln_c1, row nofreq
ta mainvuln2016 dummyvuln_c1, row nofreq

ta mainvuln2016 dummyvuln_c2, row nofreq
ta mainvuln2020 dummyvuln_c2, row nofreq






****************************************
* END
