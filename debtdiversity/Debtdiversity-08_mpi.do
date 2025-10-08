*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* dummy privation
****************************************
use"panel_HH_v0", clear

* DSR
gen dsr=imp1_ds_tot_HH/annualincome_HH
gen d_dsr=0
replace d_dsr=1 if dsr>.3

* Current
recode dumHH_givencat_curr (.=0)
fre dumHH_givencat_curr
rename dumHH_givencat_curr d_curr

* Land
fre assets_ownland
recode ownland (.=0)
recode ownland (1=0) (0=1)
rename ownland d_land

* Income
ta annualincome_HH
xtile inc10=annualincome_HH if year==2010, n(3)
xtile inc16=annualincome_HH if year==2016, n(3)
xtile inc20=annualincome_HH if year==2020, n(3)
gen d_poor=0
replace d_poor=1 if inc10==1
replace d_poor=1 if inc16==1
replace d_poor=1 if inc20==1
drop inc10 inc16 inc20

* Diversification
ta shareincomeagri_HH
gen d_div=0
replace d_div=1 if shareincomeagri_HH>.9
ta d_div year

* Remittances
gen d_rem=0
replace d_rem=1 if remittnet_HH<0


***** Selection
keep HHID_panel year d_dsr d_curr d_land d_poor d_div d_rem


***** Deprivation indicator
gen dp_score=(0.25*d_dsr) ///
+(0.25*d_curr) ///
+(0.125*d_land) ///
+(0.125*d_poor) ///
+(0.125*d_div) ///
+(0.125*d_rem)
*
tabstat dp_score, stat(n mean q min max) by(year)
*
twoway ///
(kdensity dp_score if year==2010) ///
(kdensity dp_score if year==2016) ///
(kdensity dp_score if year==2020) 
*
ta dp_score

*
mpi ///
d1(d_dsr d_curr) w1(0.25 0.25) ///
d2(d_land d_poor d_div d_rem) w2(0.125 0.125 0.125 0.125) ///
, cutoff(0.5)

*
mpi ///
d1(d_dsr d_curr) w1(0.25 0.25) ///
d2(d_land d_poor d_div d_rem) w2(0.125 0.125 0.125 0.125) ///
, cutoff(0.5) by(year)


****************************************
* END



