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
* Reshape for one obs per year per indiv
****************************************
cls
use"panel_v11_wide", clear

keep HHID_panel caste* jatis* assets2010 assets2016 assets2020 income2010 income2016 income2020 DSR2010 DSR2016 DSR2020 DAR2010 DAR2016 DAR2020 // loanamount2010 loanamount2016 loanamount2020 DIR2010 DIR2016 DIR2020 ISR2010 ISR2016 ISR2020


***** Reshape
reshape long caste jatis income DSR assets DAR ISR DIR loanamount, i(HHID_panel) j(year)
label var year ""

***** Clean
drop if income==.
replace DSR=DSR*100
replace DAR=DAR*100
replace DIR=DIR*100
replace ISR=ISR*100

***** Std
foreach x in assets income DSR DAR loanamount ISR DIR {
clonevar `x'_BU=`x'
qui sum `x', det
replace `x'=r(p99) if `x'>r(p99)
egen std_`x'=std(`x')
}




********** Cluster
cluster wardslinkage std_assets std_income std_DSR std_DAR, measure(Euclidean)
*cluster dendrogram, cutnumber(100)
cluster gen cah_clust=groups(3)
cluster kmeans std_income std_assets std_DSR std_DAR, k(3) measure(Euclidean) name(clust) start(group(cah_clust))
drop _clus_* cah_clust
ta clust

recode clust (2=1) (3=0)

***** Interpretation of clusters
cls
ta clust year
ta clust year, col nofreq
tabstat assets income DSR DAR, stat(mean p50) by(clust)
tabstat assets income DSR DAR, stat(p1 p5 p10 q p90 p95 p99) by(clust)

***** Clean
label define clust 0"Non-weak" 1"Weak"
label values clust clust



***** Graph representation
program drop _all
program define stripgraph
stripplot `1' if `1'<`4', over(`2') by(`3', title("`1'")) vert ///
stack width(1) jitter(0) ///
box(barw(1)) boffset(-0.3) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)
end

*stripgraph assets year clust 2000
*stripgraph income year clust 500
*stripgraph DSR year clust 500
*stripgraph DAR year clust 500



********** Reshape for trajectory in wide
reshape wide income DSR assets DAR caste jatis std_assets std_income std_DSR std_DAR clust *_BU, i(HHID_panel) j(year)

***** Trajectory creation
ta clust2010 clust2016, row nofreq
ta clust2016 clust2020, row nofreq

egen weaktraj_1016=group(clust2010 clust2016), lab
egen weaktraj_1620=group(clust2016 clust2020), lab
egen weaktraj_101620=group(clust2010 clust2016 clust2020), lab


********** Keep and merge with whole dataset
keep HHID_panel clust2010 clust2016 clust2020 weaktraj_1016 weaktraj_1620 weaktraj_101620 std_assets2010 std_income2010 std_DSR2010 std_DAR2010 std_assets2016 std_income2016 std_DSR2016 std_DAR2016 std_assets2020 std_income2020 std_DSR2020 *_BU* std_DAR2020

merge 1:1 HHID_panel using "panel_v11_wide"
drop _merge

drop *ihs*

drop over30path_d1 over30path_d2 over40path_d1 over40path_d2 over50path_d1 over50path_d2 path_30 path_40 path_50 path_repay_d1 path_repay_d2 path_borrowstrat_d1 path_borrowstrat_d2 path_repay path_borrowstrat


********** Clean
foreach y in 2010 2016 2020 {

rename rel_repay_amt_HH`y' rel_repay`y'
rename repay_amt_HH`y' repay`y'


foreach x in formal informal eco current humank social home other {
rename rel_`x'_HH`y' rel_`x'`y'
rename `x'_HH`y' `x'`y'
}

foreach x in IMF bank moneylender {
rename rel_lf_`x'_amt_HH`y' rel_`x'`y'
rename lf_`x'_amt_HH`y' `x'`y'
}

drop rel_mainloan_amt_HH`y'
drop mainloan_amt_HH`y'

foreach x in borrowstrat baddebt gooddebt {
rename rel_ML`x'_amt_HH`y' rel_ML`x'`y'
rename ML`x'_amt_HH`y' ML`x'`y'
}

foreach x in asse migr {
rename rel_MLstrat_`x'_amt_HH`y' rel_MLstrat`x'`y'
rename MLstrat_`x'_amt_HH`y' MLstrat`x'`y'
}
}

drop lf_IMF_nb_HH2010 lf_bank_nb_HH2010 lf_moneylender_nb_HH2010 repay_nb_HH2010 MLborrowstrat_nb_HH2010 MLgooddebt_nb_HH2010 MLbaddebt_nb_HH2010 MLstrat_asse_nb_HH2010 MLstrat_migr_nb_HH2010 lf_IMF_nb_HH2016 lf_bank_nb_HH2016 lf_moneylender_nb_HH2016 repay_nb_HH2016 MLborrowstrat_nb_HH2016 MLgooddebt_nb_HH2016 MLbaddebt_nb_HH2016 MLstrat_asse_nb_HH2016 MLstrat_migr_nb_HH2016 lf_IMF_nb_HH2020 lf_bank_nb_HH2020 lf_moneylender_nb_HH2020 repay_nb_HH2020 MLborrowstrat_nb_HH2020 MLgooddebt_nb_HH2020 MLbaddebt_nb_HH2020 MLstrat_asse_nb_HH2020 MLstrat_migr_nb_HH2020


save"panel_v12_wide", replace


********** Reshape for long
reshape long DAR	DAR_BU	DAR_with	DIR	DIR_BU	DSR	DSR30	DSR40	DSR50	DSR_BU	HHsize	IMF	ISR	ISR_BU	MLbaddebt	MLborrowstrat	MLgooddebt	MLstratasse	MLstratmigr	agri	assets	assets_BU	bank	caste	cat_as	cat_in	clust	current	dummyIMF	dummyassestrat	dummybank	dummyborrowstrat	dummymarriage	dummymigrstrat	dummymoneylender	dummyrepay	eco	expenses	femtomale	formal	head_age	head_edulevel	head_female	head_married	head_occupation	home	housetitle	housetype	humank	income	income_BU	informal	jatis	loanamount	loanamount_BU	mainloan_HH	mainocc_occupation	moneylender	nagri	nbchildren	nontoworkers	other	ownland	rel_IMF	rel_MLbaddebt	rel_MLborrowstrat	rel_MLgooddebt	rel_MLstratasse	rel_MLstratmigr	rel_bank	rel_current	rel_eco	rel_formal	rel_home	rel_humank	rel_informal	rel_moneylender	rel_other	rel_repay	rel_social	repay	shareagri	sharenagri	sizeownland	social	std_DAR	std_DSR	std_assets	std_income	sum_loans_HH	village_ur	villagearea	villageid	wifehusb_age	wifehusb_edulevel	wifehusb_female	wifehusb_married	wifehusb_occupation, i(HHID_panel) j(year)

gen time=.
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020

label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

drop if income==.

save "panel_v12_long", replace
****************************************
* END
