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
set scheme plotplain

********** Path to folder "data" folder.
*** PC
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"
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
*canreadcard1a2016 canreadcard1b2016 canreadcard1c2016 canreadcard22016 numeracy12016 numeracy22016 numeracy32016 numeracy42016 
drop a12016 a22016 a32016 a42016 a52016 a62016 a72016 a82016 a92016 a102016 a112016 a122016 ab12016 ab22016 ab32016 ab42016 ab52016 ab62016 ab72016 ab82016 ab92016 ab102016 ab112016 ab122016 b12016 b22016 b32016 b42016 b52016 b62016 b72016 b82016 b92016 b102016 b112016 b122016

drop curious2016 interestedbyart2016 inventive2016 liketothink2016 newideas2016 activeimagination2016 organized2016 makeplans2016 workhard2016 appointmentontime2016 completeduties2016 enjoypeople2016 sharefeelings2016 enthusiastic2016 talktomanypeople2016 talkative2016 expressingthoughts2016 workwithother2016 understandotherfeeling2016 trustingofother2016 toleratefaults2016 forgiveother2016 helpfulwithothers2016 managestress2016 staycalm2016 tryhard2016 stickwithgoals2016 goaftergoal2016 finishwhatbegin2016 finishtasks2016 keepworking2016

drop cr_curious2016 cr_interestedbyart2016 cr_inventive2016 cr_liketothink2016 cr_newideas2016 cr_activeimagination2016 cr_organized2016 cr_makeplans2016 cr_workhard2016 cr_appointmentontime2016 cr_completeduties2016 cr_enjoypeople2016 cr_sharefeelings2016 cr_enthusiastic2016 cr_talktomanypeople2016 cr_talkative2016 cr_expressingthoughts2016 cr_workwithother2016 cr_understandotherfeeling2016 cr_trustingofother2016 cr_toleratefaults2016 cr_forgiveother2016 cr_helpfulwithothers2016 cr_managestress2016 cr_staycalm2016 cr_tryhard2016 cr_stickwithgoals2016 cr_goaftergoal2016 cr_finishwhatbegin2016 cr_finishtasks2016 cr_keepworking2016


drop ra12016 rab12016 rb12016 ra22016 rab22016 rb22016 ra32016 rab32016 rb32016 ra42016 rab42016 rb42016 ra52016 rab52016 rb52016 ra62016 rab62016 rb62016 ra72016 rab72016 rb72016 ra82016 rab82016 rb82016 ra92016 rab92016 rb92016 ra102016 rab102016 rb102016 ra112016 rab112016 rb112016 ra122016 rab122016 rb122016 set_a2016 set_ab2016 set_b2016

drop _1_ars2016 _1_ars22016 _1_ars32016 _2_ars2016 _2_ars22016 _2_ars32016 _3_ars2016 _3_ars22016 _3_ars32016 _4_ars2016 _4_ars22016 _4_ars32016 _5_ars2016 _5_ars22016 _5_ars32016 _6_ars2016 _6_ars22016 _6_ars32016 _7_ars2016 _7_ars22016 _7_ars32016 ars2_AG2016 ars3_AG2016 ars2_CO2016 ars3_CO2016 ars2_EX2016 ars3_EX2016 ars2_OP2016 ars3_OP2016 ars2_ES2016 ars3_ES2016



********** 2020
drop curious2020 interestedbyart2020 inventive2020 liketothink2020 newideas2020 activeimagination2020 organized2020 makeplans2020 workhard2020 appointmentontime2020 completeduties2020 enjoypeople2020 sharefeelings2020 enthusiastic2020 talktomanypeople2020 talkative2020 expressingthoughts2020 workwithother2020 understandotherfeeling2020 trustingofother2020 toleratefaults2020 forgiveother2020 helpfulwithothers2020 managestress2020 staycalm2020 tryhard2020 stickwithgoals2020 goaftergoal2020 finishwhatbegin2020 finishtasks2020 keepworking2020

drop cr_curious2020 cr_interestedbyart2020 cr_inventive2020 cr_liketothink2020 cr_newideas2020 cr_activeimagination2020 cr_organized2020 cr_makeplans2020 cr_workhard2020 cr_appointmentontime2020 cr_completeduties2020 cr_enjoypeople2020 cr_sharefeelings2020 cr_enthusiastic2020 cr_talktomanypeople2020 cr_talkative2020 cr_expressingthoughts2020 cr_workwithother2020 cr_understandotherfeeling2020 cr_trustingofother2020 cr_toleratefaults2020 cr_forgiveother2020 cr_helpfulwithothers2020 cr_managestress2020 cr_staycalm2020 cr_tryhard2020 cr_stickwithgoals2020 cr_goaftergoal2020 cr_finishwhatbegin2020 cr_finishtasks2020 cr_keepworking2020

*canreadcard1a2020 canreadcard1b2020 canreadcard1c2020 canreadcard22020 numeracy12020 numeracy22020 numeracy32020 numeracy42020 numeracy52020 numeracy62020
drop a12020 a22020 a32020 a42020 a52020 a62020 a72020 a82020 a92020 a102020 a112020 a122020 ab12020 ab22020 ab32020 ab42020 ab52020 ab62020 ab72020 ab82020 ab92020 ab102020 ab112020 ab122020 b12020 b22020 b32020 b42020 b52020 b62020 b72020 b82020 b92020 b102020 b112020 b122020


drop ra12020 rab12020 rb12020 ra22020 rab22020 rb22020 ra32020 rab32020 rb32020 ra42020 rab42020 rb42020 ra52020 rab52020 rb52020 ra62020 rab62020 rb62020 ra72020 rab72020 rb72020 ra82020 rab82020 rb82020 ra92020 rab92020 rb92020 ra102020 rab102020 rb102020 ra112020 rab112020 rb112020 ra122020 rab122020 rb122020 set_a2020 set_ab2020 set_b2020

drop _1_ars2020 _1_ars22020 _1_ars32020 _2_ars2020 _2_ars22020 _2_ars32020 _3_ars2020 _3_ars22020 _3_ars32020 _4_ars2020 _4_ars22020 _4_ars32020 _5_ars2020 _5_ars22020 _5_ars32020 _6_ars2020 _6_ars22020 _6_ars32020 _7_ars2020 _7_ars22020 _7_ars32020 ars2_AG2020 ars3_AG2020 ars2_CO2020 ars3_CO2020 ars2_EX2020 ars3_EX2020 ars2_OP2020 ars3_OP2020 ars2_ES2020 ars3_ES2020


*** Username
* 2016
rename username_2016_code2016 username_neemsis1
desc username_neemsis1
fre username_neemsis1
label define username_2016_code 1"Enum: Ant" 2"Enum: Kum" 3"Enum: May" 4"Enum: Paz" 5"Enum: Raj" 6"Enum: Sit" 7"Enum: Viv", modify

* 2020
rename username_2020_code2020 username_neemsis2
fre username_neemsis2
desc username_neemsis2
recode username_neemsis2 (1=4)
fre username_neemsis2
label define userneemsis2 1"Chithra-Radhika" 2"Mayan" 3"Pazani" 4"Raichal" 5"Rajalakschmi" 6"Suganya-Malarvizhi" 7"Vivek-Radja"
fre username_neemsis2
replace username_neemsis2=username_neemsis2-1
label values username_neemsis2 userneemsis2
fre username_neemsis2

drop username2016 username_20162016 username_20202016 username_2020_code2016 username2020 username_20162020 username_20202020 username_2016_code2020

fre username_backup2016 username_neemsis1 username_backup2020 username_neemsis2

save "panel_stab_wide_v3", replace
****************************************
* END









****************************************
* Cognitive
****************************************
use "panel_stab_wide_v3", clear

foreach x in numeracy12016 numeracy22016 numeracy32016 numeracy42016 numeracy12020 numeracy22020 numeracy32020 numeracy42020 {
recode `x' (2=0)
}

egen num2_tt2016=rowtotal(numeracy12016 numeracy22016 numeracy32016 numeracy42016)
egen num2_tt2020=rowtotal(numeracy12020 numeracy22020 numeracy32020 numeracy42020)

***** Diff
sum num2_tt2016 num2_tt2020
sum lit_tt2016 lit_tt2020
sum raven_tt2016 raven_tt2020

gen diff_num=num2_tt2020-num2_tt2016
gen diff_lit=lit_tt2020-lit_tt2016
gen diff_raven=raven_tt2020-raven_tt2016

ta diff_num
ta diff_lit
ta diff_raven


********** Graph
set graph off

histogram diff_num, percent dis xline(0) ///
xtitle("Numeracy Score Difference" "=2020-2016") ytitle("%") ///
xlabel(-4(1)4) ylabel(0(5)30) ///
name(num, replace)
*graph save "diff_num.gph", replace
*graph export "diff_num.pdf", replace

histogram diff_lit, percent xline(0) ///
xtitle("Literacy Score Difference" "=2020-2016") ytitle("%") ///
xlabel(-4(1)4) ylabel(0(10)50) ///
xmtick(-4(.5)4) ymtick(0(5)50) ///
name(lit, replace)
*graph save "diff_lit.gph", replace
*graph export "diff_lit.pdf", replace

histogram diff_raven, percent dis xline(0) ///
xtitle("Raven Score Difference" "=2020-2016") ytitle("%") ///
xlabel(-40(10)30) ylabel(0(1)7) ///
xmtick(-40(5)30) ymtick() ///
name(raven, replace)
*graph save "diff_rav.gph", replace
*graph export "diff_rav.pdf", replace

***** Combine
graph combine num lit raven, col(3) name(cog_com, replace)

graph save "diff_cog.gph", replace
graph export "diff_cog.pdf", replace

set graph on

save "panel_stab_wide_v31", replace
****************************************
* END










****************************************
* Stability of ES
****************************************
use "panel_stab_wide_v31", clear


rename f1_2016 fa_ES2016
rename f1_2020 fa_ES2020

tab1 cr_ES2016 cr_ES2020
tab1 fa_ES2016 fa_ES2020

foreach x in cr_ES2016 cr_ES2020 fa_ES2016 fa_ES2020 {
replace `x'=5 if `x'>5
}

tabstat cr_ES2016 cr_ES2020 fa_ES2016 fa_ES2020, stat(n mean sd p50 min max)
* Min = 0
* Max = 5

********** DIFF
gen diff_cr_ES=cr_ES2020-cr_ES2016
gen diff_fa_ES=fa_ES2020-fa_ES2016

foreach x in diff_cr_ES diff_fa_ES {
gen abs_`x'=abs(`x')
}

tabstat diff_cr_ES diff_fa_ES abs_diff_cr_ES abs_diff_fa_ES, stat(n mean sd p50 min max range)
* Min = -5
* Max = +5
* Range = 10

egen diff_cr_ES_cat5=cut(diff_cr_ES), at(-5,-.25,.25,5) icodes
egen diff_cr_ES_cat10=cut(diff_cr_ES), at(-5,-.5,.5,5) icodes
egen diff_fa_ES_cat5=cut(diff_fa_ES), at(-5,-.25,.25,5) icodes
egen diff_fa_ES_cat10=cut(diff_fa_ES), at(-5,-.5,.5,5) icodes
fre diff_cr_ES_cat5 diff_cr_ES_cat10 diff_fa_ES_cat5 diff_fa_ES_cat10

egen abs_diff_cr_ES_cat5=cut(abs_diff_cr_ES), at(0,.25,5) icodes
egen abs_diff_cr_ES_cat10=cut(abs_diff_cr_ES), at(0,.5,5) icodes
egen abs_diff_fa_ES_cat5=cut(abs_diff_fa_ES), at(0,.25,5) icodes
egen abs_diff_fa_ES_cat10=cut(abs_diff_fa_ES), at(0,.5,5) icodes
fre abs_diff_cr_ES_cat5 abs_diff_cr_ES_cat10 abs_diff_fa_ES_cat5 abs_diff_fa_ES_cat10


gen abs_diff_fa_ES_cat10_cont=abs(diff_fa_ES)
replace abs_diff_fa_ES_cat10_cont=. if  abs_diff_fa_ES_cat10==0
ta abs_diff_fa_ES_cat10_cont



********** DELTA
gen delta_cr_ES=(cr_ES2020-cr_ES2016)/cr_ES2016
gen delta_fa_ES=(fa_ES2020-fa_ES2016)/fa_ES2016

foreach x in delta_cr_ES delta_fa_ES {
gen abs_`x'=abs(`x')
}

tabstat delta_cr_ES delta_fa_ES abs_delta_cr_ES abs_delta_fa_ES, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max)

egen delta_cr_ES_cat5=cut(delta_cr_ES), at(-2,-.05,.05,7) icodes
egen delta_cr_ES_cat10=cut(delta_cr_ES), at(-2,-.1,.1,7) icodes
egen delta_fa_ES_cat5=cut(delta_fa_ES), at(-2,-.05,.05,7) icodes
egen delta_fa_ES_cat10=cut(delta_fa_ES), at(-2,-.1,.1,7) icodes
fre delta_cr_ES_cat5 delta_cr_ES_cat10 delta_fa_ES_cat5 delta_fa_ES_cat10

egen abs_delta_cr_ES_cat5=cut(abs_delta_cr_ES), at(0,.05,7) icodes
egen abs_delta_cr_ES_cat10=cut(abs_delta_cr_ES), at(0,.1,7) icodes
egen abs_delta_fa_ES_cat5=cut(abs_delta_fa_ES), at(0,.05,7) icodes
egen abs_delta_fa_ES_cat10=cut(abs_delta_fa_ES), at(0,.1,7) icodes
fre abs_delta_cr_ES_cat5 abs_delta_cr_ES_cat10 abs_delta_fa_ES_cat5 abs_delta_fa_ES_cat10


********** LABEL
label define stab 0"Decrease" 1"Stable" 2"Increase"
foreach x in diff_cr_ES_cat5 diff_cr_ES_cat10 diff_fa_ES_cat5 diff_fa_ES_cat10 delta_cr_ES_cat5 delta_cr_ES_cat10 delta_fa_ES_cat5 delta_fa_ES_cat10 {
label values `x' stab
}
fre diff_cr_ES_cat5 diff_cr_ES_cat10 diff_fa_ES_cat5 diff_fa_ES_cat10 delta_cr_ES_cat5 delta_cr_ES_cat10 delta_fa_ES_cat5 delta_fa_ES_cat10

label define stab2 0"Stable" 1"Instable"
foreach x in abs_diff_cr_ES_cat5 abs_diff_cr_ES_cat10 abs_diff_fa_ES_cat5 abs_diff_fa_ES_cat10 abs_delta_cr_ES_cat5 abs_delta_cr_ES_cat10 abs_delta_fa_ES_cat5 abs_delta_fa_ES_cat10 {
label values `x' stab2
}
fre abs_diff_cr_ES_cat5 abs_diff_cr_ES_cat10 abs_diff_fa_ES_cat5 abs_diff_fa_ES_cat10 abs_delta_cr_ES_cat5 abs_delta_cr_ES_cat10 abs_delta_fa_ES_cat5 abs_delta_fa_ES_cat10


********** INSTAB
/*
gen abs_diff_instab5=0
gen abs_diff_instab10=0
gen abs_delta_instab5=0
gen abs_delta_instab10=0

replace abs_diff_instab5=1 if abs_diff_cr_ES_cat5==1 & abs_diff_fa_ES_cat5==1
replace abs_diff_instab10=1 if abs_diff_cr_ES_cat10==1 & abs_diff_fa_ES_cat10==1

replace abs_delta_instab5=1 if abs_delta_cr_ES_cat5==1 & abs_delta_fa_ES_cat5==1
replace abs_delta_instab10=1 if abs_delta_cr_ES_cat10==1 & abs_delta_fa_ES_cat10==1

label define stab3 0"Stable" 1"Instable"
foreach x in abs_diff_instab5 abs_diff_instab10 abs_delta_instab5 abs_delta_instab10 {
label values `x' stab3
} 
fre abs_diff_instab5 abs_diff_instab10 abs_delta_instab5 abs_delta_instab10
*/

*** Increase or decrease
gen pathabs_diff_cr_cat5=0
gen pathabs_diff_cr_cat10=0
gen pathabs_delta_cr_cat5=0
gen pathabs_delta_cr_cat10=0

gen pathabs_diff_fa_cat5=0
gen pathabs_diff_fa_cat10=0
gen pathabs_delta_fa_cat5=0
gen pathabs_delta_fa_cat10=0

replace pathabs_diff_cr_cat5=1 if cr_ES2016>cr_ES2020 & abs_diff_cr_ES_cat5==1
replace pathabs_diff_cr_cat10=1 if cr_ES2016>cr_ES2020 & abs_diff_cr_ES_cat10==1
replace pathabs_delta_cr_cat5=1 if cr_ES2016>cr_ES2020 & abs_delta_cr_ES_cat5==1
replace pathabs_delta_cr_cat10=1 if cr_ES2016>cr_ES2020 & abs_delta_cr_ES_cat10==1
replace pathabs_diff_cr_cat5=2 if cr_ES2016<cr_ES2020 & abs_diff_cr_ES_cat5==1
replace pathabs_diff_cr_cat10=2 if cr_ES2016<cr_ES2020 & abs_diff_cr_ES_cat10==1
replace pathabs_delta_cr_cat5=2 if cr_ES2016<cr_ES2020 & abs_delta_cr_ES_cat5==1
replace pathabs_delta_cr_cat10=2 if cr_ES2016<cr_ES2020 & abs_delta_cr_ES_cat10==1

replace pathabs_diff_fa_cat5=1 if fa_ES2016>fa_ES2020 & abs_diff_fa_ES_cat5==1
replace pathabs_diff_fa_cat10=1 if fa_ES2016>fa_ES2020 & abs_diff_fa_ES_cat10==1
replace pathabs_delta_fa_cat5=1 if fa_ES2016>fa_ES2020 & abs_delta_fa_ES_cat5==1
replace pathabs_delta_fa_cat10=1 if fa_ES2016>fa_ES2020 & abs_delta_fa_ES_cat10==1
replace pathabs_diff_fa_cat5=2 if fa_ES2016<fa_ES2020 & abs_diff_fa_ES_cat5==1
replace pathabs_diff_fa_cat10=2 if fa_ES2016<fa_ES2020 & abs_diff_fa_ES_cat10==1
replace pathabs_delta_fa_cat5=2 if fa_ES2016<fa_ES2020 & abs_delta_fa_ES_cat5==1
replace pathabs_delta_fa_cat10=2 if fa_ES2016<fa_ES2020 & abs_delta_fa_ES_cat10==1


label define path 1 "Decreasing" 2 "Increasing"
foreach x in pathabs_diff_cr_cat5 pathabs_diff_cr_cat10 pathabs_delta_cr_cat5 pathabs_delta_cr_cat10 pathabs_diff_fa_cat5 pathabs_diff_fa_cat10 pathabs_delta_fa_cat5 pathabs_delta_fa_cat10 {
recode `x' (0=.)
label values `x' path
}
fre pathabs_diff_cr_cat5 pathabs_diff_cr_cat10 pathabs_delta_cr_cat5 pathabs_delta_cr_cat10 pathabs_diff_fa_cat5 pathabs_diff_fa_cat10 pathabs_delta_fa_cat5 pathabs_delta_fa_cat10


save "panel_stab_wide_v4", replace
****************************************
* END










****************************************
* Control var
****************************************
use "panel_stab_wide_v4", clear

*** Controle var
* Sex
desc sex
label define sex 1"Sex: Male" 2"Sex: Female", modify
fre sex


* Age
egen age_cat=cut(age2016), at(18,25,35,45,55,65,82) icodes
label define age 0"Age: [18;25[" 1"Age: [25;35[" 2"Age: [35;45[" 3"Age: [45;55[" 4"Age: [55;65[" 5"Age: [65;]", modify
label values age_cat age
recode age_cat (5=4)
label define age 0"Age: [18;25[" 1"Age: [25;35[" 2"Age: [35;45[" 3"Age: [45;55[" 4"Age: [55;+]", modify
tab age2016 age_cat


* Age2
gen age25=0 if age2016<25
replace age25=1 if age2016>=25


* Edu
clonevar educode=edulevel2016
clonevar educode20=edulevel2020
recode educode educode20 (4=3)
fre educode educode20
label define edulevel 0"Edu: Below prim" 1"Edu: Primary" 2"Edu: High school" 3"Edu: HSC/Diploma or more", modify 



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
recode annualincome_indiv2016 (.=0)
xtile annualincome_indiv2016_q=annualincome_indiv2016, n(3)
label define assets 1"Assets: T1" 2"Assets: T2" 3"Assets: T3"
label values assets2016_q assets
label define income 1"Income: T1" 2"Income: T2" 3"Income: T3"
label values annualincome_HH2016_q income
label values annualincome_indiv2016_q income


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

* Recode moc_indiv
recode moc_indiv (5=4)
des moc_indiv
fre moc_indiv
label define occupcode 4"Occ: Reg", modify
fre moc_indiv

save "panel_stab_wide_v5", replace
****************************************
* END











****************************************
* ENUMERATORS RESPONDENT
****************************************
use "panel_stab_wide_v5", clear


********** Enumerator / respondent
ta sex username_neemsis1, col nofreq
ta caste username_neemsis1, col nofreq
ta edulevel2016 username_neemsis1, col nofreq
ta moc_indiv username_neemsis1, col nofreq

ta username_neemsis1 sex


****************************************
* END













****************************************
* Heatmap / transition matrix
****************************************
use "panel_stab_wide_v5", clear


*** Heatmap
preserve
macro drop _all
****
**** Enter Varname
global varx fa_ES2016
global vary fa_ES2020
****
**** Enter nb of bin
global nbin 5
****
**** Calculations
xtile x=$varx, n($nbin)
xtile y=$vary, n($nbin)
ta x y, row nofreq
qui ta x, gen(x_)
qui ta y, gen(y_)
forvalues i=1(1)$nbin {
bysort x y: egen n_tot`i'=sum(x_`i')
qui count if n_tot`i'!=0
gen perc_`i'=n_tot`i'/r(N)
}
gen perc=.
forvalues i=1(1)$nbin{
replace perc=perc_`i' if perc_`i'!=0
}
grstyle init
grstyle set plain, nogrid box
****
**** Modifications for graph aspect
heatplot perc x y, ///
colors(HSV grays, reverse) ///
statistic(mean) ///
xscale(alt) xbwidth(1) xlab(0(1)$nbin) xtitle("Decile of the emotional stability score in 2020-21") ///
yscale(reverse) ybwidth(1) ylab(0(1)$nbin) ytitle("Decile of the emotional stability score in 2016-17") ///
legend(off) title("")
graph save "heatmap_ES.gph", replace
graph export "heatmap_ES.pdf", as(pdf) replace
ta x y, row nofreq
drop  x_* y_* n_tot* perc_* perc
restore

*values(format(%4.2f) color(red)) ///


save "panel_stab_wide_v6", replace
****************************************
* END














****************************************
* reshape + intraclass correlation
****************************************
use "panel_stab_wide_v6", clear

keep HHID_panel INDID_panel fa_ES2016 fa_ES2020 sex age2016 caste jatis edulevel2016 edulevel2020 villageid2016 mainocc_occupation_indiv2020

reshape long fa_ES edulevel, i(HHID_panel INDID_panel) j(year)

egen HHINDID=concat(HHID_panel INDID_panel), p(/)
encode HHINDID, gen(HHINDID2)
drop HHINDID
rename HHINDID2 HHINDID

xtset HHINDID year

icc fa_ES HHINDID
/*
Intraclass correlations
One-way random-effects model
Absolute agreement

Random effects: HHINDID          Number of targets =       835
                                 Number of raters  =         2

--------------------------------------------------------------
                 fa_ES |        ICC       [95% Conf. Interval]
-----------------------+--------------------------------------
            Individual |  -.2116272      -.2754639   -.1459294
               Average |  -.5368708      -.7603871   -.3417269
--------------------------------------------------------------
F test that
  ICC=0.00: F(834.0, 835.0) = 0.65            Prob > F = 1.000

Note: ICCs estimate correlations between individual measurements
      and between average measurements made on the same target.
*/


save "panel_stab_v6", replace
****************************************
* END
