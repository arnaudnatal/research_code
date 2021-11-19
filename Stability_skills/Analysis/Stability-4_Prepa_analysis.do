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


********** Absolute evolution
foreach x in cr_ES fa_ES{
gen abs_`x'=abs(diff_`x')
tabstat abs_`x', stat(n mean sd min max range)
}

ta fa_ES2016
ge fa_ES2016_r=round(fa_ES2016,.1)
ge fa_ES2020_r=round(fa_ES2020,.1)



gen absdelta_cr_ES=abs((cr_ES2020-cr_ES2016)/cr_ES2016)
gen absdelta_fa_ES=abs((fa_ES2020-fa_ES2016)/fa_ES2016)
gen absdelta_fa_r_ES=abs((fa_ES2020_r-fa_ES2016_r)/fa_ES2016_r)

tabstat absdelta_cr_ES absdelta_fa_ES absdelta_fa_r_ES, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max)


/*
Changer le 5%, prendre le 5% de l'amplitude de la variable et non de l'amplitude de
la distribution de la variable
*/

gen abs_cr_ES_cat5=0
gen abs_fa_ES_cat5=0
gen abs_cr_ES_cat10=0
gen abs_fa_ES_cat10=0
replace abs_cr_ES_cat5=1 if abs_cr_ES>.25
replace abs_fa_ES_cat5=1 if abs_fa_ES>.3
replace abs_cr_ES_cat10=1 if abs_cr_ES>.5
replace abs_fa_ES_cat10=1 if abs_fa_ES>.6

gen absdelta_cr_ES_cat5=0
gen absdelta_fa_ES_cat5=0
gen absdelta_cr_ES_cat10=0
gen absdelta_fa_ES_cat10=0
replace absdelta_cr_ES_cat5=1 if absdelta_cr_ES>.05
replace absdelta_fa_ES_cat5=1 if absdelta_fa_ES>.05
replace absdelta_cr_ES_cat10=1 if absdelta_cr_ES>.1
replace absdelta_fa_ES_cat10=1 if absdelta_fa_ES>.1

fre absdelta_cr_ES_cat5 absdelta_cr_ES_cat10 absdelta_fa_ES_cat5 absdelta_fa_ES_cat10

gen abs_instab5=0
gen abs_instab10=0
replace abs_instab5=1 if abs_cr_ES_cat5==1 & abs_fa_ES_cat5==1
replace abs_instab10=1 if abs_cr_ES_cat10==1 & abs_fa_ES_cat10==1

tab abs_cr_ES_cat5 abs_fa_ES_cat5
ta abs_instab5
tab abs_cr_ES_cat10 abs_fa_ES_cat10
ta abs_instab10

*** Increase or decrease
gen path_abs_cr5=0
gen path_abs_fa5=0
gen path_abs_cr10=0
gen path_abs_fa10=0

replace path_abs_cr5=1 if cr_ES2016>cr_ES2020 & abs_cr_ES_cat5==1
replace path_abs_cr5=2 if cr_ES2016<cr_ES2020 & abs_cr_ES_cat5==1
replace path_abs_cr10=1 if cr_ES2016>cr_ES2020 & abs_cr_ES_cat10==1
replace path_abs_cr10=2 if cr_ES2016<cr_ES2020 & abs_cr_ES_cat10==1

replace path_abs_fa5=1 if fa_ES2016>fa_ES2020 & abs_fa_ES_cat5==1
replace path_abs_fa5=2 if fa_ES2016<fa_ES2020 & abs_fa_ES_cat5==1
replace path_abs_fa10=1 if fa_ES2016>fa_ES2020 & abs_fa_ES_cat10==1
replace path_abs_fa10=2 if fa_ES2016<fa_ES2020 & abs_fa_ES_cat10==1

label define path 0 "Stability" 1 "Decreasing" 2 "Increasing"
foreach x in path_abs_cr5 path_abs_fa5 path_abs_cr10 path_abs_fa10{
label values `x' path
recode `x' (0=.)
}

fre abs_cr_ES_cat5
fre path_abs_cr5 path_abs_fa5 path_abs_cr10 path_abs_fa10



*** Controle var
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



save "panel_stab_wide_v4", replace
****************************************
* END

