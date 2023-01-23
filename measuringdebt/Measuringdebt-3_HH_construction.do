*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------










****************************************
* Construction: debt
****************************************
use"panel_v0", clear

* DSR
tabstat imp1_ds_tot_HH annualincome_HH, stat(min p1 p5 p10 q p90 p95 p99 max)
gen dsr=imp1_ds_tot_HH*100/annualincome_HH
replace dsr=0 if dsr==.
tabstat dsr, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if dsr>200
ta year if dsr>300
ta year if dsr>400
/*
stripplot dsr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
*replace dsr=400 if dsr>400


* ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.
tabstat isr, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if isr>150
ta year if isr>200
/*
stripplot isr, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
*replace isr=200 if isr>200  // 0.2%, 1.2%, 2.4%


* DAR
tabstat loanamount_HH assets_total assets_totalnoland assets_totalnoprop, stat(n mean cv p50) by(year)
gen dar=loanamount_HH*100/assets_totalnoprop
replace dar=0 if dar==.
tabstat dar, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if dar>200
ta year if dar>300
ta year if dar>400
/*
stripplot dar, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/
*replace dar=300 if dar>300  // 0.2%, 3.5%, 0.3%


* DIR
gen dir=loanamount_HH*100/annualincome_HH
replace dir=0 if dir==.
tabstat dir, stat(n mean cv q p90 p95 p99 max) by(year)
ta year if dir>600
ta year if dir>1400
/*
stripplot dir, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30)
*/
*replace dir=1400 if dir>1400  // 0.2%, 3.9%, 4.6%



* TDR
gen tdr=totHH_givenamt_repa*100/loanamount_HH
replace tdr=0 if tdr==.
tabstat tdr, stat(n mean cv q p90 p95 p99 max) by(year)
tabstat tdr if totHH_givenamt_repa!=0, stat(n mean cv q p90 p95 p99 max) by(year)
/*
stripplot tdr, over(year) vert refline ///
stack width(1) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30)

stripplot tdr if totHH_givenamt_repa!=0, over(year) vert refline ///
stack width(1) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(90) ///
ms(oh) msize(small) mc(black%30)
*/


* TAR
gen tar=totHH_givenamt_repa*100/assets_total
replace tar=0 if tar==.
tabstat tar, stat(n mean cv q p90 p95 p99 max) by(year)
/*
stripplot tar, over(year) vert refline ///
stack width(5) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(95) ///
ms(oh) msize(small) mc(black%30)
*/


* AFM - Absolut Financial Margin
gen temp=1 if imp1_ds_tot_HH==.
recode imp1_ds_tot_HH (.=0)
gen afm=annualincome_HH+remittnet_HH+goldreadyamount-imp1_ds_tot_HH-expenses_total
replace imp1_ds_tot_HH=. if temp==1
drop temp

gen dummyafmpos=0
replace dummyafmpos=1 if afm>0
ta dummyafmpos year, col
ta dummyafmpos caste if year==2010, row nofreq
ta dummyafmpos caste if year==2016, row nofreq
ta dummyafmpos caste if year==2020, row nofreq


* RFM - Relative Financial Margin
gen rfm=(afm*100)/annualincome_HH
ta rfm


* LPC - Loans per capita
gen lpc=nbloans_HH/squareroot_HHsize
ta lpc
replace lpc=0 if lpc==.

* LAPC - Loan amount per capita
gen lapc=loanamount_HH/squareroot_HHsize
ta lapc
replace lapc=0 if lapc==.


save"panel_v1", replace
****************************************
* END

















****************************************
* Pverty and other
****************************************
use"panel_v1", clear

********** Poverty
* HH income per capita
gen dailyincome_pc=(annualincome_HH/365)/squareroot_HHsize

* USD in 2010: 1 USD = 45.73 INR
gen dailyusdincome_pc=dailyincome_pc/45.73

* PL net
gen dailyplincome_pc=dailyusdincome_pc-1.9

* PL dummy
gen apl=0 if dailyplincome_pc<0

recode apl (.=1)
drop dailyplincome_pc

* Incpercpl
gen incpercpl=(dailyusdincome_pc-1.9)*100/1.9

* Assets pc
gen assets_pc=assets_total/squareroot_HHsize
corr assets_total assets_pc
plot assets_pc assets_total

********** Other var
* HH
encode HHID_panel, gen(panelvar)

* Village
encode villageid, gen(vill)

*Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Trap
gen dummytrap=0
replace dummytrap=1 if tdr>0

* Head sex
fre head_sex
gen head_female=.
replace head_female=0 if head_sex==1
replace head_female=1 if head_sex==2

ta head_sex head_female
label define head_female 0"Male" 1"Female"
label values head_female head_female

* Head occupation
fre head_mocc_occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)


* Head edulevel
fre head_edulevel
recode head_edulevel (3=2) (4=2) (5=2)
ta head_edulevel, gen(head_educ)


* Head age
tabstat head_age, stat(n mean sd q)
gen head_agesq=head_age*head_age

gen head_agecat=0
replace head_agecat=1 if head_age<40
replace head_agecat=2 if head_age>=40 & head_age<50
replace head_agecat=3 if head_age>=50 & head_age<60
replace head_agecat=4 if head_age>=60

label define head_agecat 1"Less 40" 2"40-50" 3"50-60" 4"60 or more"
label values head_agecat head_agecat
ta head_agecat, gen(head_agecat)


* Head maritalstatus
fre head_maritalstatus
gen head_nonmarried=head_maritalstatus
recode head_nonmarried (1=0) (2=1) (3=1) (4=1) (.=0)
label define head_nonmarried 0"Married" 1"Non-married"
label values head_nonmarried head_nonmarried
fre head_nonmarried

* Class
** Categorize assets 
/*
by year to take into account the
increasing level of consumption
see ref on conspicuous consumption
*/
tabstat assets_total, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile assets_`i'=assets_total if year==`i', n(3) 
}
gen assets_cat=.
replace assets_cat=assets_2010 if year==2010
replace assets_cat=assets_2016 if year==2016
replace assets_cat=assets_2020 if year==2020
drop assets_2010 assets_2016 assets_2020
ta assets_cat
label define assets_cat 1"Wealth: Poor" 2"Wealth: Middle" 3"Wealth: Rich"
label values assets_cat assets_cat
fre assets_cat
ta assets_cat caste, chi2 cchi2 exp
ta assets_cat, gen(assets_cat)


********** CRE
global head head_female head_occ1 head_occ2 head_occ3 head_occ4 head_occ5 head_occ6 head_occ7 head_educ1 head_educ2 head_educ3 head_agesq head_agecat head_agecat1 head_agecat2 head_agecat3 head_agecat4 head_nonmarried head_age
global income annualincome_HH dailyincome_pc shareincomeagri_HH incomeagri_HH incomenonagri_HH shareincomenonagri_HH
global assets assets_total assets_pc assets_cat1 assets_cat2 assets_cat3
global expenses expenses_total shareexpenses_food shareexpenses_educ shareexpenses_heal shareexpenses_cere
global rest dummytrap dummymarriage stem HH_count_child HH_count_adult HHsize

global all $head $income $assets $expenses $rest

foreach x in $all {
bysort HHID_panel: egen `x'_mean=mean(`x')
}


save"panel_v2", replace
****************************************
* END








****************************************
* Construction: clean
****************************************
use"panel_v2", clear

tabstat dsr isr dar dir tdr tar rfm dailyincome_pc assets_total goldreadyamount afm incpercpl assets_pc lpc , stat(n mean cv min p1 p5 p10 q p90 p95 p99 max)


replace dsr=430 if dsr>430
replace isr=190 if isr>190
replace dar=420 if dar>420
replace dir=2800 if dir>2800
replace tar=39 if tar>39
replace rfm=700 if rfm>700
replace rfm=-1000 if rfm<-1000
replace dailyincome_pc=600 if dailyincome_pc>600
replace assets_total=6000000 if assets_total>6000000
replace assets_pc=3000000 if assets_pc>3000000
replace goldreadyamount=400000 if goldreadyamount>400000
replace afm=570000 if afm>570000
replace afm=-150000 if afm<-150000
replace incpercpl=600 if incpercpl>600


foreach x in loanamount_HH annualincome_HH assets_total imp1_ds_tot_HH imp1_is_tot_HH totHH_givenamt_repa dsr isr dar dir tdr tar afm rfm expenses_total remreceived_HH remsent_HH remittnet_HH dailyincome_pc assets_gold goldquantity_HH goldreadyamount nbloans_HH incpercpl assets_pc lpc lapc {
egen `x'_std=std(`x')
}

*** Label
label var dar_std "DAR (std)"
label var dsr_std "DSR (std)"
label var afm_std "AFM (std)"
label var rfm_std "RFM (std)"
label var tdr_std "TDR (std)"
label var tar_std "TAR (std)"
label var isr_std "ISR (std)"
label var dailyincome_pc_std "Livelihood (std)"
label var assets_total_std "Wealth (std)"
label var nbloans_HH_std "Nb loans (std)"
label var lpc_std "Loans pc (std)"
label var lapc_std "Loan amount pc (std)"


* Inc better to worse
gen incomerev=dailyincome_pc*(-1)
tabstat dailyincome_pc incomerev, stat(n q)
egen incomerev_std=std(incomerev)

* RFM better to worse
gen rfmrev=rfm*(-1)
tabstat rfm rfmrev, stat(n q)
egen rfmrev_std=std(rfmrev)
label var rfmrev_std "RFM rev. (std)"

* Assets better to worse
gen assetsrev=assets_total*(-1)
tabstat assets_total assetsrev, stat(n q)
egen assetsrev_std=std(assetsrev)

* AFM better to worse
gen afmrev=afm*(-1)
tabstat afm afmrev, stat(n q)
egen afmrev_std=std(afmrev)

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

label define dalits 0"Non-dalits" 1"Dalits"
label values dalits dalits


*** Order
order HHID_panel year
sort HHID_panel year

save"panel_v3", replace
****************************************
* END
