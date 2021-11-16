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
* Formation
****************************************
use"panel_stab_v2_wide", clear

merge 1:1 HHID_panel INDID_panel using "panel_stab_v2_2016"
drop _merge
merge 1:1 HHID_panel INDID_panel using "panel_stab_v2_2020"
drop _merge



********** 2016
drop canreadcard1a2016 canreadcard1b2016 canreadcard1c2016 canreadcard22016 numeracy12016 numeracy22016 numeracy32016 numeracy42016 a12016 a22016 a32016 a42016 a52016 a62016 a72016 a82016 a92016 a102016 a112016 a122016 ab12016 ab22016 ab32016 ab42016 ab52016 ab62016 ab72016 ab82016 ab92016 ab102016 ab112016 ab122016 b12016 b22016 b32016 b42016 b52016 b62016 b72016 b82016 b92016 b102016 b112016 b122016

drop curious2016 interestedbyart2016 repetitivetasks2016 inventive2016 liketothink2016 newideas2016 activeimagination2016 organized2016 makeplans2016 workhard2016 appointmentontime2016 putoffduties2016 easilydistracted2016 completeduties2016 enjoypeople2016 sharefeelings2016 shywithpeople2016 enthusiastic2016 talktomanypeople2016 talkative2016 expressingthoughts2016 workwithother2016 understandotherfeeling2016 trustingofother2016 rudetoother2016 toleratefaults2016 forgiveother2016 helpfulwithothers2016 managestress2016 nervous2016 changemood2016 feeldepressed2016 easilyupset2016 worryalot2016 staycalm2016 tryhard2016 stickwithgoals2016 goaftergoal2016 finishwhatbegin2016 finishtasks2016 keepworking2016

drop ra12016 rab12016 rb12016 ra22016 rab22016 rb22016 ra32016 rab32016 rb32016 ra42016 rab42016 rb42016 ra52016 rab52016 rb52016 ra62016 rab62016 rb62016 ra72016 rab72016 rb72016 ra82016 rab82016 rb82016 ra92016 rab92016 rb92016 ra102016 rab102016 rb102016 ra112016 rab112016 rb112016 ra122016 rab122016 rb122016 set_a2016 set_ab2016 set_b2016

drop _1_ars2016 _1_ars22016 _1_ars32016 _2_ars2016 _2_ars22016 _2_ars32016 _3_ars2016 _3_ars22016 _3_ars32016 _4_ars2016 _4_ars22016 _4_ars32016 _5_ars2016 _5_ars22016 _5_ars32016 _6_ars2016 _6_ars22016 _6_ars32016 _7_ars2016 _7_ars22016 _7_ars32016 ars2_AG2016 ars3_AG2016 ars2_CO2016 ars3_CO2016 ars2_EX2016 ars3_EX2016 ars2_OP2016 ars3_OP2016 ars2_ES2016 ars3_ES2016

drop cr_curious2016 cr_interestedbyart2016 cr_repetitivetasks2016 cr_inventive2016 cr_liketothink2016 cr_newideas2016 cr_activeimagination2016 cr_organized2016 cr_makeplans2016 cr_workhard2016 cr_appointmentontime2016 cr_putoffduties2016 cr_easilydistracted2016 cr_completeduties2016 cr_enjoypeople2016 cr_sharefeelings2016 cr_shywithpeople2016 cr_enthusiastic2016 cr_talktomanypeople2016 cr_talkative2016 cr_expressingthoughts2016 cr_workwithother2016 cr_understandotherfeeling2016 cr_trustingofother2016 cr_rudetoother2016 cr_toleratefaults2016 cr_forgiveother2016 cr_helpfulwithothers2016 cr_managestress2016 cr_nervous2016 cr_changemood2016 cr_feeldepressed2016 cr_easilyupset2016 cr_worryalot2016 cr_staycalm2016 cr_tryhard2016 cr_stickwithgoals2016 cr_goaftergoal2016 cr_finishwhatbegin2016 cr_finishtasks2016 cr_keepworking2016


********** 2020
drop canreadcard1a2020 canreadcard1b2020 canreadcard1c2020 canreadcard22020 numeracy12020 numeracy22020 numeracy32020 numeracy42020 a12020 a22020 a32020 a42020 a52020 a62020 a72020 a82020 a92020 a102020 a112020 a122020 ab12020 ab22020 ab32020 ab42020 ab52020 ab62020 ab72020 ab82020 ab92020 ab102020 ab112020 ab122020 b12020 b22020 b32020 b42020 b52020 b62020 b72020 b82020 b92020 b102020 b112020 b122020

drop curious2020 interestedbyart2020 repetitivetasks2020 inventive2020 liketothink2020 newideas2020 activeimagination2020 organized2020 makeplans2020 workhard2020 appointmentontime2020 putoffduties2020 easilydistracted2020 completeduties2020 enjoypeople2020 sharefeelings2020 shywithpeople2020 enthusiastic2020 talktomanypeople2020 talkative2020 expressingthoughts2020 workwithother2020 understandotherfeeling2020 trustingofother2020 rudetoother2020 toleratefaults2020 forgiveother2020 helpfulwithothers2020 managestress2020 nervous2020 changemood2020 feeldepressed2020 easilyupset2020 worryalot2020 staycalm2020 tryhard2020 stickwithgoals2020 goaftergoal2020 finishwhatbegin2020 finishtasks2020 keepworking2020

drop ra12020 rab12020 rb12020 ra22020 rab22020 rb22020 ra32020 rab32020 rb32020 ra42020 rab42020 rb42020 ra52020 rab52020 rb52020 ra62020 rab62020 rb62020 ra72020 rab72020 rb72020 ra82020 rab82020 rb82020 ra92020 rab92020 rb92020 ra102020 rab102020 rb102020 ra112020 rab112020 rb112020 ra122020 rab122020 rb122020 set_a2020 set_ab2020 set_b2020

drop _1_ars2020 _1_ars22020 _1_ars32020 _2_ars2020 _2_ars22020 _2_ars32020 _3_ars2020 _3_ars22020 _3_ars32020 _4_ars2020 _4_ars22020 _4_ars32020 _5_ars2020 _5_ars22020 _5_ars32020 _6_ars2020 _6_ars22020 _6_ars32020 _7_ars2020 _7_ars22020 _7_ars32020 ars2_AG2020 ars3_AG2020 ars2_CO2020 ars3_CO2020 ars2_EX2020 ars3_EX2020 ars2_OP2020 ars3_OP2020 ars2_ES2020 ars3_ES2020

drop cr_curious2020 cr_interestedbyart2020 cr_repetitivetasks2020 cr_inventive2020 cr_liketothink2020 cr_newideas2020 cr_activeimagination2020 cr_organized2020 cr_makeplans2020 cr_workhard2020 cr_appointmentontime2020 cr_putoffduties2020 cr_easilydistracted2020 cr_completeduties2020 cr_enjoypeople2020 cr_sharefeelings2020 cr_shywithpeople2020 cr_enthusiastic2020 cr_talktomanypeople2020 cr_talkative2020 cr_expressingthoughts2020 cr_workwithother2020 cr_understandotherfeeling2020 cr_trustingofother2020 cr_rudetoother2020 cr_toleratefaults2020 cr_forgiveother2020 cr_helpfulwithothers2020 cr_managestress2020 cr_nervous2020 cr_changemood2020 cr_feeldepressed2020 cr_easilyupset2020 cr_worryalot2020 cr_staycalm2020 cr_tryhard2020 cr_stickwithgoals2020 cr_goaftergoal2020 cr_finishwhatbegin2020 cr_finishtasks2020 cr_keepworking2020


save "panel_stab_wide_v3", replace
****************************************
* END







****************************************
* Stability of ES
****************************************
use "panel_stab_wide_v3", clear

********** Gen new var
*** Evo traits
rename f2_without_2016 fa_ES2016
rename f1_without_2020 fa_ES2020
gen diff_cr_ES=cr_ES2020-cr_ES2016
gen diff_fa_ES=fa_ES2020-fa_ES2016

foreach x in cr_ES2016 cr_ES2020 fa_ES2016 fa_ES2020 {
xtile `x'_cat=`x', n(10)
}


tabstat cr_ES2016 cr_ES2020 fa_ES2016 fa_ES2020, stat(n mean sd p50 min max range)
egen cr_ES2016_cut=cut(cr_ES2016), at(0,1,2,3,4,5,6)
egen cr_ES2020_cut=cut(cr_ES2020), at(0,1,2,3,4,5,6)
egen fa_ES2016_cut=cut(fa_ES2016), at(-4,-3,-2,-1,0,1,2,3,4)
egen fa_ES2020_cut=cut(fa_ES2020), at(-4,-3,-2,-1,0,1,2,3,4)

tabstat diff_cr_ES diff_fa_ES, stat(n mean sd p50 min max range)
dis 6.285715*0.05
dis 8.883403*0.05
egen diff_cr_ES_cat5=cut(diff_cr_ES), at(-4,-.314,.314,7) icodes
egen diff_fa_ES_cat5=cut(diff_fa_ES), at(-4,-.444,.444,9) icodes
egen diff_cr_ES_cat10=cut(diff_cr_ES), at(-4,-.628,.628,7) icodes
egen diff_fa_ES_cat10=cut(diff_fa_ES), at(-4,-.888,.888,9) icodes

label define stab 0"Decrease" 1"Stable" 2"Increase"
foreach x in diff_cr_ES_cat5 diff_cr_ES_cat10 diff_fa_ES_cat5 diff_fa_ES_cat10{
label values `x' stab
}

* Gen path in one var
gen decrease_cr_ES=.
gen increase_cr_ES=.
gen decrease_fa_ES=.
gen increase_fa_ES=.

replace decrease_cr_ES=diff_cr_ES if diff_cr_ES_cat5==0
replace decrease_cr_ES=abs(decrease_cr_ES)
replace increase_cr_ES=diff_cr_ES if diff_cr_ES_cat5==2
replace decrease_fa_ES=diff_fa_ES if diff_fa_ES_cat5==0
replace decrease_fa_ES=abs(decrease_fa_ES)
replace increase_fa_ES=diff_fa_ES if diff_fa_ES_cat5==2

gen abs_instab_cr=.
replace abs_instab_cr=decrease_cr_ES if decrease_cr_ES!=.
replace abs_instab_cr=increase_cr_ES if increase_cr_ES!=.
tab abs_instab_cr diff_cr_ES_cat5, m

gen abs_instab_fa=.
replace abs_instab_fa=decrease_fa_ES if decrease_fa_ES!=.
replace abs_instab_fa=increase_fa_ES if increase_fa_ES!=.
tab abs_instab_fa diff_fa_ES_cat5, m


*** Controle var
* Age
egen age_cat=cut(age2016), at(18,25,35,45,55,65,82) icodes
label define age 0"Age: [18;25[" 1"Age: [25;35[" 2"Age: [35;45[" 3"Age: [45;55[" 4"Age: [55;65[" 5"Age: [65;]", modify
label values age_cat age
recode age_cat (5=4)
label define age 0"Age: [18;25[" 1"Age: [25;35[" 2"Age: [35;45[" 3"Age: [45;55[" 4"Age: [55;+]", modify
tab age2016 age_cat
* Edu
clonevar educode=edulevel2016
recode educode (3=2) (4=2)
label define edulevel 0"Edu: Below prim" 1"Edu: Primary" 2"Edu: High school", modify 
* MOC
rename mainocc_occupation_indiv2016 moc_indiv
label define occupcode 0"Occ: No occup" 1"Occ: Agri" 2"Occ: Agri coolie" 3"Occ: Coolie" 4"Occ: Reg non-qual" 5"Occ: Reg qualif" 6"Occ: SE" 7"Occ: NREGA", modify
* Bias
gen diff_ars3=ars32020-ars32016
tabstat diff_ars3, stat(n mean sd p50 min max range)
dis 2.428571*0.05
egen diff_ars3_cat5=cut(diff_ars3), at(-1,-.121,.121,1.5) icodes
label define ars3cat 0"Bias: Decrease" 1"Bias: Stable" 2"Bias: Increase"
label values diff_ars3_cat5 ars3cat
* HH
encode HHID_panel, gen(cluster)
* Marital
fre maritalstatus2016
clonevar marital=maritalstatus2016
recode marital (3=2) (4=2)
recode marital (1=0) (2=1)
ta maritalstatus2016 marital
label define maritalstatus 0"Married: Yes" 1"Married: No", modify 
* Female
fre sex
gen female=sex-1
fre female
label define female 0"Sex: Male" 1"Sex: Female"
label values female female
* Username
encode username_backup2016, gen(username_encode_2016)
encode username_backup2020, gen(username_encode_2020)
* Caste
label define castecat 1"Caste: Dalits" 2"Caste: Middle" 3"Caste: Upper", modify
* Demonetisation
label define demo 0"Demo: No" 1"Demo: Yes"
label values dummydemonetisation2016 demo
* Villages
label define villageid 1"Vill: ELA" 2"Vill: GOV" 3"Vill: KAR" 4"Vill: KOR" 5"Vill: KUV" 6"Vill: MAN" 7"Vill: MANAM" 8"Vill: NAT" 9"Vill: ORA" 10"Vill: SEM", modify
* Wealth
xtile assets2016_q=assets2016, n(3)
xtile annualincome_HH2016_q=annualincome_HH2016, n(3)
xtile annualincome_indiv2016_q=annualincome_indiv2016, n(3)
label define assets 1"Assets: T1" 2"Assets: T2" 3"Assets: T3"
label values assets2016_q assets
label define income 1"Income: T1" 2"Income: T2" 3"Income: T3"
label values annualincome_HH2016_q income
label values annualincome_indiv2016_q income
* Username
label define username_2020_code 1"Enum: Ant" 2"Enum: Chi" 3"Enum: May" 4"Enum: Paz" 5"Enum: Rai" 6"Enum: Raj" 7"Enum: Sug" 8"Enum: Viv", modify
label values username_encode_2020 username_2020_code
* Cov expo
destring covsellland2020, replace
recode covsellland2020 (66=2)
recode covsellland2020 (2=0)
label define cov 0 "Cov: Not exp" 1 "Cov: Exposed"
label values covsellland2020 cov
fre covsellland2020
* Marriage
fre dummymarriage2016 dummymarriage2020
label define marriage 0"Marriage: No" 1"Marriage: Yes"
label values dummymarriage2020 marriage
* Health
gen shockhealth=.
replace shockhealth=0 if healthexpenses2020<=healthexpenses2016
replace shockhealth=1 if healthexpenses2020>healthexpenses2016
label define shockhealth 0"Health: No shock" 1"Health: Shock"
label values shockhealth shockhealth
* General shock
gen shock=shockhealth+dummydemonetisation2016+covsellland2020
fre shock
* Dummy shock
gen dummyshock=shock
recode dummyshock (4=1) (3=1) (2=1)
label define dummyshock 0"Shock: No" 1"Shock: Yes"
label values dummyshock dummyshock
* Recode shock
gen shock_recode=shock
recode shock_recode (4=2) (3=2)
label define shock_recode 0"Shock: No" 1"Shock: One" 2"Shock: Two or more"
label values shock_recode shock_recode

* Dummy
foreach x in sex age_cat educode moc_indiv caste annualincome_indiv2016_q {
tab `x', gen(`x'_)
}

*** Gen instability
fre diff_cr_ES_cat5
gen instab_cr_ES=diff_cr_ES_cat5
gen instab_fa_ES=diff_fa_ES_cat5

recode instab_cr_ES instab_fa_ES (1=.)

tab diff_cr_ES instab_cr_ES, m



********** Are individuals at the same place with EFA and naive?
*** Cross table in 2016 and 2020 between EFA and naïve
tab cr_ES2016_cat fa_ES2016_cat, row nofreq
tab cr_ES2020_cat fa_ES2020_cat, row nofreq



********** Difference
*** Stat
tabstat diff_cr_ES diff_fa_ES, stat(n mean sd p50 min max range)

*** Graph: histogram
/*
twoway__histogram_gen diff_fa_ES, percent width(0.1) gen(h x, replace)
twoway ///
(bar h x if x<-.444, color(gs8) barwidth(0.1)) ///
(bar h x if x>=-.444 & x<=.444, color(gs10) barwidth(0.1)) ///
(bar h x if x>.444, color(gs4) barwidth(0.1)) ///
(kdensity diff_fa_ES, bwidth(0.15) lcolor(gs1) lpattern(solid) yaxis(2)) ///
, ///
xlabel(-4(1)5) xmtick(-4.5(.5)5.5) xtitle("ΔES") ///
ytitle("%", axis(1))  ///
ytitle("Density", axis(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 0.15" "Histogram can be read with the left-hand y-axis." "Kernel curve can be read with the right-hand y-axis.", size(tiny)) ///
plotregion(margin(none)) legend(pos(6) col(4) order(1 "Decrease" 2 "Stable" 3 "Increase" 4 "Kernel density")) name(histo, replace) 
graph export "Histo_kernel_instab.pdf", replace


twoway__histogram_gen diff_cr_ES, percent width(0.1) gen(h x, replace)
twoway ///
(bar h x if x<-.314, color(gs8) barwidth(0.1)) ///
(bar h x if x>=-.314 & x<=.314, color(gs10) barwidth(0.1)) ///
(bar h x if x>.314, color(gs4) barwidth(0.1)) ///
(kdensity diff_cr_ES, bwidth(0.15) lcolor(gs1) lpattern(solid) yaxis(2)) ///
, ///
xlabel(-3(1)3) xmtick(-3.5(.5)3) xtitle("ΔES") ///
ytitle("%", axis(1))  ///
ytitle("Density", axis(2)) ///
note("Kernel: Epanechnikov" "Bandwidth: 0.15" "Histogram can be read with the left-hand y-axis." "Kernel curve can be read with the right-hand y-axis.", size(tiny)) ///
plotregion(margin(none)) legend(pos(6) col(4) order(1 "Decrease" 2 "Stable" 3 "Increase" 4 "Kernel density")) name(histo, replace) 
graph export "Histo_kernel_instab_naive.pdf", replace
*/



********** Transition matrix
tab cr_ES2016_cut cr_ES2020_cut
tab cr_ES2016_cut cr_ES2020_cut, nofreq row

tab fa_ES2016_cut fa_ES2020_cut
tab fa_ES2016_cut fa_ES2020_cut, nofreq row

tab diff_cr_ES_cat5 diff_fa_ES_cat5
tab diff_cr_ES_cat5 diff_fa_ES_cat5, row nofreq
tab diff_cr_ES_cat5 diff_fa_ES_cat5, col nofreq


*** Descriptive statistics for naïve Big-5
tab sex diff_cr_ES_cat5, col nofreq
tab caste diff_cr_ES_cat5, col nofreq
tab age_cat diff_cr_ES_cat5, col nofreq
tab edulevel2016 diff_cr_ES_cat5, col nofreq
tab username_backup2020 diff_cr_ES_cat5, col nofreq
tab diff_ars3_cat5 diff_cr_ES_cat5, col nofreq
tab shock_recode diff_cr_ES_cat5, col nofreq


*** Descriptive statistics for factor Big-5
tab sex diff_fa_ES_cat5, col nofreq
tab caste diff_fa_ES_cat5, col nofreq
tab age_cat diff_fa_ES_cat5, col nofreq
tab edulevel2016 diff_fa_ES_cat5, col nofreq
tab username_backup2020 diff_fa_ES_cat5, col nofreq
tab diff_ars3_cat5 diff_fa_ES_cat5, col nofreq
tab shock_recode diff_fa_ES_cat5, col nofreq




********** Cross EFA and naïve Big-5
tab diff_cr_ES_cat5 diff_fa_ES_cat5, m
fre diff_cr_ES_cat5 diff_fa_ES_cat5

save "panel_stab_wide_v4", replace
****************************************
* END












****************************************
* Graph
****************************************
use "panel_stab_wide_v4", clear

label define castecat 1"Dalits" 2"Middle" 3"Upper", modify

*** Caste and sex
egen caste_sex=group(sex caste), lab
fre caste_sex

********** Decrease, naïve
*** Boxplot
* Sex
stripplot decrease_cr_ES, over(sex) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste
stripplot decrease_cr_ES, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste & sex
stripplot decrease_cr_ES, over(caste_sex) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(45))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Moc
stripplot decrease_cr_ES, over(moc_indiv) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(45))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste
stripplot decrease_cr_ES, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))

* Caste
stripplot decrease_cr_ES, over(caste) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))




*** Kernel
twoway ///
(kdensity decrease_cr_ES if caste==1, bwidth(.4)) ///
(kdensity decrease_cr_ES if caste==2, bwidth(.4)) ///
(kdensity decrease_cr_ES if caste==3, bwidth(.4)) ///
, legend(order(1 "Dalits" 2 "Middle" 3 "Upper"))



****************************************
* END













****************************************
* ECON OLS
****************************************
use "panel_stab_wide_v4", clear

********** Clean
**** Username
* 2016
rename username_2016_code2016 username_neemsis1
desc username_neemsis1
fre username_neemsis1
label define username_2016_code 1"Enum: Ant" 2"Enum: Kum" 3"Enum: May" 4"Enum: Paz" 5"Enum: Raj" 6"Enum: Sit" 7"Enum: Viv", modify
* 2020
rename username_encode_2020 username_neemsis2
fre username_neemsis2


********** Assessment: bias higher in 2020-21 than in 2016-17.
stripplot ars32016 ars32020, over() separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(1 "2016-17" 2 "2020-21",angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual") off) name(ars_global, replace)

stripplot ars32016, over(username_neemsis1) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("2016-17") xlabel(,angle(45))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel(0(.2)1.7) ymtick(0(.1)1.7) ytitle("") ///
legend(order(1 "Mean" 5 "Individual") off) name(ars_2016, replace)

stripplot ars32020, over(username_neemsis2) separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("2020-21") xlabel(,angle(45))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle("") ///
legend(order(1 "Mean" 5 "Individual") off) name(ars_2020, replace)

graph combine ars_2016 ars_2020, name(ars_enumyear_box, replace)

*** Kernel
* 2016-17
twoway ///
(kdensity ars32016 if username_neemsis1==1, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==2, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==3, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==4, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==5, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==6, bwidth(.1)) ///
(kdensity ars32016 if username_neemsis1==7, bwidth(.1)) ///
, ///
xtitle("Absolut acquiescence score") ///
ytitle("Kernel") ///
title("2016-17") ///
legend(order(1 "Enum 1" 2 "Enum 2" 3 "Enum 3" 4 "Enum 4" 5 "Enum 5" 6 "Enum 6" 7 "Enum 7") col(4) pos(6)) ///
name(ars_2016_kernel, replace)

* 2020-21
twoway ///
(kdensity ars32020 if username_neemsis2==1, bwidth(.3)) ///
(kdensity ars32020 if username_neemsis2==2, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==3, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==4, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==5, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==6, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==7, bwidth(.2)) ///
(kdensity ars32020 if username_neemsis2==8, bwidth(.2)) ///
, ///
xtitle("Absolut acquiescence score") ///
ytitle("Kernel") ///
title("2020-21") ///
legend(order(1 "Enum 1" 2 "Enum 2" 3 "Enum 3" 4 "Enum 4" 5 "Enum 5" 6 "Enum 6" 7 "Enum 7" 8 "Enum 8") col(4) pos(6)) ///
name(ars_2020_kernel, replace)

graph combine ars_2016_kernel ars_2020_kernel, name(ars_enumyear_kernel, replace)


*** Role of enumerator in 2016-17
reg ars32016 i.sex i.caste i.age_cat ib(0).educode i.villageid2016, allbase
*--> R2=3.7
reg ars32016 i.sex i.caste i.age_cat ib(0).educode i.villageid2016 ib(4).username_neemsis1, allbase
*--> R2=26.3
dis (26.3-3.7)*100/3.7
*610.8%


*** Role of enumerator in 2020-21
reg ars32020 i.sex i.caste i.age_cat ib(0).educode i.villageid2020, allbase
*--> R2=6.3
reg ars32020 i.sex i.caste i.age_cat ib(0).educode i.villageid2020 ib(4).username_neemsis2, allbase
*--> R2=15.4
dis (15.4-6.3)*100/6.3
*144.4%

********** ES distribution
stripplot cr_ES2016 cr_ES2020 fa_ES2016 fa_ES2020 , over() separate() ///
cumul cumprob box centre vertical refline /// 
xsize(5) xtitle("") xlabel(,angle(0))  ///
msymbol(oh oh oh oh oh oh oh) mcolor()  ///
ylabel() ymtick() ytitle("") ///
legend(order(1 "Mean" 5 "Individual"))



********** Naïve Big-5
*** Abs instability 
reg abs_instab_cr ///
i.female ///
b(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store cr_abs

*** Decrease
reg decrease_cr_ES ///
i.female ///
b(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store cr_dec

*** Increase
reg increase_cr_ES ///
i.female ///
ib(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store cr_inc





********** EFA
*** Abs instability
reg abs_instab_fa ///
i.female ///
b(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store fa_abs

*** Decrease
reg decrease_fa_ES ///
i.female ///
ib(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store fa_dec

*** Increase
reg increase_fa_ES ///
i.female ///
ib(1).caste ///
ib(0).age_cat ///
ib(0).educode ///
ib(2).moc_indiv ///
ib(2).annualincome_indiv2016_q ///
i.dummydemonetisation2016 ///
i.villageid2016 ///
ib(1).diff_ars3_cat5 ///
i.username_encode_2020 ///
, cluster(cluster) allbase
est store fa_inc

esttab cr_abs cr_dec cr_inc fa_abs fa_dec fa_inc using "_reg.csv", ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star) se(fmt(2)par)") /// 
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2 F, fmt(0 3 3) labels(`"Observations"' `"\$R^2$"' `"F"')) ///
	replace
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