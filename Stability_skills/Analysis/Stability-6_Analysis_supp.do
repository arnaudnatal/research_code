cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
October 25, 2021
-----
Stability over time of personality traits
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme white_tableau

********** Path to folder "data" folder.
*** PC
global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH_v9"
global wave3 "NEEMSIS2-HH_v21"
****************************************
* END










****************************************
* CRE
****************************************
use "panel_stab_v2", clear
keep if egoid>0
keep if panel==1

encode HHINDID, gen(panelvar)
xtset panelvar year

********** Control var
tab sex year, m
tab caste year, m  // pb
tab edulevel year, m  // pb
tab mainocc_occupation_indiv year, m  // pb
tab maritalstatus year, m
tab villageid year, m
tab username year, m
tab relationshiptohead year, m


********** Correction
*** Caste and edulevel
foreach x in caste edulevel jatis {
bysort HHID_panel INDID_panel : egen _`x'=max(`x')
replace `x'=_`x'
drop _`x'
}
tab caste year, m  // ok
tab edulevel year, m  // ok
tab jatis year, m   // ok

tab edulevel year, m col nofreq
fre edulevel
clonevar education=edulevel
recode education (4=3)
label define edulevel 3"HSC or +", modify
ta education year, m


*** Username
replace username="Pazani" if username=="Pazhani"
tab username year
encode username, gen(username_code)

*** Occupation missing
recode mainocc_occupation_indiv (.=0)
rename mainocc_occupation_indiv moc_indiv

*** Relationshiptohead
recode relationshiptohead (.=77)
label define relationshiptohead 77"Other", modify
ta relationshiptohead year, m col nofreq
fre relationshiptohead
gen relation=.
replace relation=1 if relationshiptohead==1
replace relation=2 if relationshiptohead==2
replace relation=3 if relationshiptohead==5
replace relation=77 if relationshiptohead!=1 & relationshiptohead!=2 & relationshiptohead!=5
label define relation 1"Head" 2"Wife" 3"Son" 77"Other"
label values relation relation


********** Generating dummy
foreach x in sex caste jatis relation education moc_indiv maritalstatus dummydemonetisation covsellland villageid username_code {
tab `x', gen(`x'_)
}


********** Mean over time
*** Categorical
foreach x in relation_1 relation_2 relation_3 relation_4 education_1 education_2 education_3 education_4 moc_indiv_1 moc_indiv_2 moc_indiv_3 moc_indiv_4 moc_indiv_5 moc_indiv_6 moc_indiv_7 moc_indiv_8 maritalstatus_1 maritalstatus_2 maritalstatus_3 maritalstatus_4 dummydemonetisation_1 dummydemonetisation_2 covsellland_1 covsellland_2 covsellland_3 villageid_1 villageid_2 villageid_3 villageid_4 villageid_5 villageid_6 villageid_7 villageid_8 villageid_9 villageid_10 username_code_1 username_code_2 username_code_3 username_code_4 username_code_5 username_code_6 username_code_7 username_code_8 username_code_9 username_code_10 username_code_11 {
bysort HHID_panel INDID_panel : egen `x'_mean=mean(`x')
}

*** Continuous
foreach x in age annualincome_indiv assets {
bysort HHID_panel INDID_panel : egen `x'_mean=mean(`x')
}




********** Reg
xthybrid cr_ES age sex_2 caste_2 caste_3 relation_2 relation_3 relation_4 education_2 education_3 education_4 moc_indiv_1 moc_indiv_2 moc_indiv_4 moc_indiv_5 moc_indiv_6 moc_indiv_7 moc_indiv_8 maritalstatus_2 maritalstatus_3 maritalstatus_4 dummydemonetisation_2 annualincome_indiv assets, clusterid(panelvar) family(gaussian) link(identity) cre star 






****************************************
* END

















/*
********** Matrix to graph
tab diff_cr_ES_cat diff_fa_ES_cat, row nofreq matcell(Freq)
clear
svmat Freq
gen NA=_n
reshape long Freq, i(NA) j(FA)
bys NA: egen Freq_tot=total(Freq)
gen percent=(Freq/Freq_tot)*100
bys NA: egen Perc_tot=total(percent)

bys NA (FA): gen A=cond(FA==1, percent, 0)
bys NA (FA): gen B=cond(FA==2, percent, 0)
bys NA (FA): gen C=cond(FA==3, percent, 0)
bys NA (FA): gen D=cond(FA==4, percent, 0)
bys NA (FA): gen E=cond(FA==5, percent, 0)
bys NA (FA): gen F=cond(FA==6, percent, 0)
bys NA (FA): gen G=cond(FA==7, percent, 0)
bys NA (FA): gen H=cond(FA==8, percent, 0)
bys NA (FA): gen I=cond(FA==9, percent, 0)
bys NA (FA): gen J=cond(FA==10, percent, 0)

*Label
label define per 1"P0-10" 2"P10-20" 3"P20-30" 4"P30-40" 5"P40-50" 6"P50-60" 7"P60-70" 8"P70-80" 9"P80-90" 10"P90-100"
label values NA per
label values FA per

graph bar A B C D E F G H I J, ///
over(NA, label(angle(45)) ) stack ///
bar(1, color(black)) ///
bar(2, color(plr1)) ///
bar(3, color(ply1)) ///
bar(4, color(plg1)) ///
bar(5, color(plb1)) /// 
bar(6, color(pll1)) /// 
bar(7, color(plr2)) /// 
bar(8, color(ply2)) /// 
bar(9, color(plg2)) /// 
bar(10, color(plb2)) ///
legend(order(1 "P0-10" 2 "P10-20" 3 "P20-30" 4 "P30-40" 5 "P40-50" 6 "P50-60" 7 "P60-70" 8 "P70-80" 9 "P80-90" 10 "P90-100")) ///
b1title(Naïve Big-5 taxonomy) ///
ytitle("% in Factor analysis taxonomy") ylabel(0(1)10) ymtick(0(.5)10)









********** QUANTILE

sqreg abs_instab_cr ///
sex_2 ///
caste_2 caste_3 ///
age_cat_1 age_cat_2 age_cat_4 age_cat_5 ///
educode_1 educode_3 ///
moc_indiv_1 moc_indiv_2 moc_indiv_4 moc_indiv_5 moc_indiv_6 moc_indiv_7 moc_indiv_8 ///
marital ///
annualincome_indiv2016_q_1 annualincome_indiv2016_q_3 ///
ib(2).assets2016_q ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
i.dummydemonetisation2016##i.covsellland2020 ///
, quantile(.1 .2 .3 .4 .5 .6 .7 .8 .9) reps(50)

preserve
gen q = _n*10 in 1/9

foreach var of varlist sex_2 caste_2 caste_3 age_cat_1 age_cat_2 age_cat_4 age_cat_5 educode_1 educode_3 moc_indiv_1 moc_indiv_2 moc_indiv_4 moc_indiv_5 moc_indiv_6 moc_indiv_7 moc_indiv_8 annualincome_indiv2016_q_1 annualincome_indiv2016_q_3 {
gen _b_`var'=.
gen _lb_`var'=.
gen _ub_`var'=.

local i = 1
foreach q of numlist 10(10)90 {
replace _b_`var' = _b[q`q':`var'] in `i'
replace _lb_`var' = _b[q`q':`var'] - _se[q`q':`var']*invnormal(.975) in `i'
replace _ub_`var' = _b[q`q':`var'] + _se[q`q':`var']*invnormal(.975) in `i++'
}
}
keep q _b_* _lb_* _ub_*
keep in 1/9
reshape long _b_ _lb_ _ub_, i(q) j(var) string
twoway rarea _lb_ _ub_ q, astyle(ci) yline(0) acolor(%70) || ///
   line _b_ q,                                               ///
   by(var, yrescale xrescale note("") legend(at(14) pos(0)))  ///
   legend(order(2 "Effect" 1 "95% c.i.") cols(2) pos(6))   ///
   ytitle(effect on percentile of price)                       ///
   ylab(,angle(0) format(%7.0gc))                            ///    
   xlab(10(10)90) xtitle("Decile of emotional stability") ///
   name(qreg_decrease_fa, replace)
restore
