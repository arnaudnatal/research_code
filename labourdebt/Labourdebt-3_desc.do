*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*January 12, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* Stat desc: Y
****************************************
cls
use"panel_v3", clear


********** Panel declaration
xtset panelvar time
set matsize 10000, perm


********** Variables
global yvar ind_total ind_female ind_male ind_agri ind_nona occ_total occ_female occ_male occ_agri occ_nona



********** Histogram Indiv

*** Total
twoway (histogram ind_total if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("Total") ///
title("2010") name(ind_total_2010, replace)

twoway (histogram ind_total if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
title("2016-17") name(ind_total_2016, replace)

twoway (histogram ind_total if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
title("2020-21") name(ind_total_2020, replace)



*** Male
twoway (histogram ind_male if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("Male") ///
name(ind_male_2010, replace)

twoway (histogram ind_male if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_male_2016, replace)

twoway (histogram ind_male if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_male_2020, replace)



*** Female
twoway (histogram ind_female if year==2010, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ytitle("Female") ///
name(ind_female_2010, replace)

twoway (histogram ind_female if year==2016, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_female_2016, replace)

twoway (histogram ind_female if year==2020, discrete percent), ///
xtitle("Number of workers") xlabel(0(1)8) ///
ylabel(0(20)100) ymtick(0(10)100) ///
name(ind_female_2020, replace)


graph combine ind_total_2010 ind_total_2016 ind_total_2020 ind_male_2010 ind_male_2016 ind_male_2020 ind_female_2010 ind_female_2016 ind_female_2020, col(3) name(ind, replace)



****************************************
* END













****************************************
* Stat desc: X
****************************************
cls
use"panel_v3", clear


********** Panel declaration
xtset panelvar time
set matsize 10000, perm

global nonvar dalits village_2 village_3 village_4 village_5 village_6 village_7 village_8 village_9 village_10
global head head_female head_age head_educ
global econ remittnet_HH assets_total annualincome_HH shareform

global compo1 stem log_HHsize share_female share_children share_young share_old share_stock

global compo2 stem HHsize HH_count_child sexratio dependencyratio share_stock





********** Histogram over time




****************************************
* END
