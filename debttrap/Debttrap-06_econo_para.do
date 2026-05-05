*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Household level
****************************************
use"panel_HH_v2", clear

* 
gen dsr_inc=0
replace dsr_inc=1 if log_dsr1<log_dsr2
ta ownland dsr_inc, col chi2 nofreq

*
keep HHID_panel year log_dsr ownland dummymarriage villageid HHsize HH_count_child head_sex head_age head_mocc_occupation head_edulevel assets_totalnoland1000 annualincome_HH nbworker_HH nbnonworker_HH remittnet_HH secondlockdownexposure dummydemonetisation dalits head_nonmarried

*
bys HHID_panel: gen n=_N
ta n
drop if n==1
ta year

*
preserve
keep HHID_panel year log_dsr
drop if year==2010
ta year
recode year (2016=2010) (2020=2016) (2025=2020)
ta year
rename log_dsr log_dsr_t1
save"_temp", replace
restore
merge 1:1 HHID_panel year using "_temp"
drop if _merge==2
drop _merge
ta year

* Vars
encode HHID_panel, gen(HHFE)
order HHFE, after(HHID_panel)
gen log_wealth=log(assets_totalnoland1000)
gen log_income=log(annualincome_HH)
rename secondlockdownexposure dummylock
recode dummylock (1=0) (2=1) (3=1)
fre dummylock dummydemonetisation dummymarriage
gen shocks=dummylock+dummydemonetisation+dummymarriage
ta villageid
replace villageid="ELA" if villageid=="ELANTHALMPATTU"
replace villageid="GOV" if villageid=="GOVULAPURAM"
replace villageid="KAR" if villageid=="KARUMBUR"
replace villageid="KOR" if villageid=="KORATTORE"
replace villageid="KUV" if villageid=="KUVAGAM"
replace villageid="MANAM" if villageid=="MANAMTHAVIZHINTHAPUTHUR"
replace villageid="MAN" if villageid=="MANAPAKKAM"
replace villageid="NAT" if villageid=="NATHAM"
replace villageid="ORA" if villageid=="ORAIYURE"
replace villageid="SEM" if villageid=="SEMAKOTTAI"
ta villageid
rename villageid village
encode village, gen(villageid)

* Panel
xtset HHFE year

* First diff
gen d_dsr=log_dsr_t1-log_dsr

* OLS
reg d_dsr c.log_dsr##c.log_dsr##c.log_dsr##c.log_dsr ///
i.head_sex c.head_age##c.head_age i.head_mocc_occupation i.head_edulevel i.head_nonmarried ///
HHsize HH_count_child i.ownland log_wealth log_income remittnet_HH ///
shocks ///
i.dalits i.villageid i.year

* FE
xtreg d_dsr c.log_dsr##c.log_dsr##c.log_dsr##c.log_dsr ///
i.head_sex c.head_age##c.head_age i.head_mocc_occupation i.head_edulevel i.head_nonmarried ///
HHsize HH_count_child i.ownland log_wealth log_income remittnet_HH ///
shocks, fe



****************************************
* END

