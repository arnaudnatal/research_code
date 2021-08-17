cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
August 17, 2021
-----
Stability over time of personality traits: variables creation
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain, perm

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v7"
global wave3 "NEEMSIS2-HH_v17"
****************************************
* END











****************************************
* Cognitive skills
****************************************
cls
tab1 raven_tt raven_tt_2020 lit_tt lit_tt_2020 num_tt num_tt_2020
*Dénominateur commun pour num: 12
replace num_tt=num_tt*3
replace num_tt_2020=num_tt_2020*2
tab1 num_tt num_tt_2020

foreach x in lit_tt raven_tt num_tt {
gen diff_`x'=`x'_2020-`x'
tab diff_`x'
}

*** Decreasing
foreach x in lit_tt num_tt raven_tt {
gen dec_`x'=1 if diff_`x'!=.
}
replace dec_lit_tt=0 if diff_lit_tt>=-1 & diff_lit_tt!=.
replace dec_num_tt=0 if diff_num_tt>=-2 & diff_num_tt!=.
replace dec_raven_tt=0 if diff_raven_tt>=-4 & diff_raven_tt!=.

tab1 dec_lit_tt dec_num_tt dec_raven_tt 
/*
lit = 109/651
num = 116/808
rav = 362/835
*/
*Is for those who have one decrease, everything decrease?
egen nbdec=rowtotal(dec_lit_tt dec_num_tt dec_raven_tt)
replace nbdec=. if dec_raven_tt==.
tab nbdec
/*
      nbdec |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        403       48.26       48.26
          1 |        297       35.57       83.83
          2 |        115       13.77       97.60
          3 |         20        2.40      100.00
------------+-----------------------------------
      Total |        835      100.00
*/
tabstat age, stat(n mean sd p50 min max) by(nbdec)
drop diff_raven_tt diff_num_tt diff_lit_tt
*** Categories
foreach x in raven_tt num_tt lit_tt{
gen delta_`x'=((`x'_2020-`x')*100/`x')
gen diff_`x'=`x'_2020-`x'
gen absdelta_`x'=abs(delta_`x')
gen absdiff_`x'=abs(diff_`x')
gen cat_diff_`x'=0 if _merge==3
}
*Raven
replace cat_diff_raven_tt=1 if diff_raven_tt<=-36 & cat_diff_raven_tt==0  
replace cat_diff_raven_tt=2 if diff_raven_tt<=-14.4 & diff_raven_tt>-36 & cat_diff_raven_tt==0  
replace cat_diff_raven_tt=3 if diff_raven_tt<=-7.2 & diff_raven_tt>-14.4 & cat_diff_raven_tt==0 
replace cat_diff_raven_tt=4 if diff_raven_tt<=-3.6 & diff_raven_tt>-7.2 & cat_diff_raven_tt==0 
replace cat_diff_raven_tt=5 if diff_raven_tt>-3.6 & diff_raven_tt<3.6 & cat_diff_raven_tt==0
replace cat_diff_raven_tt=6 if diff_raven_tt>=3.6 & diff_raven_tt<7.2 & cat_diff_raven_tt==0
replace cat_diff_raven_tt=7 if diff_raven_tt>=7.2 & diff_raven_tt<14.4 & cat_diff_raven_tt==0
replace cat_diff_raven_tt=8 if diff_raven_tt>=14.4 & diff_raven_tt<36 & cat_diff_raven_tt==0
replace cat_diff_raven_tt=9 if diff_raven_tt>=2 & cat_diff_raven_tt==0
replace cat_diff_raven_tt=. if diff_raven_tt==.
*Num
replace cat_diff_num_tt=1 if diff_num_tt<=-6 & cat_diff_num_tt==0  
replace cat_diff_num_tt=2 if diff_num_tt<=-2.4 & diff_num_tt>-6 & cat_diff_num_tt==0  
replace cat_diff_num_tt=3 if diff_num_tt<=-1.2 & diff_num_tt>-2.4 & cat_diff_num_tt==0 
replace cat_diff_num_tt=4 if diff_num_tt<=-0.6 & diff_num_tt>-1.2 & cat_diff_num_tt==0 
replace cat_diff_num_tt=5 if diff_num_tt>-0.6 & diff_num_tt<0.6 & cat_diff_num_tt==0
replace cat_diff_num_tt=6 if diff_num_tt>=0.6 & diff_num_tt<1.2 & cat_diff_num_tt==0
replace cat_diff_num_tt=7 if diff_num_tt>=1.2 & diff_num_tt<2.4 & cat_diff_num_tt==0
replace cat_diff_num_tt=8 if diff_num_tt>=2.4 & diff_num_tt<6 & cat_diff_num_tt==0
replace cat_diff_num_tt=9 if diff_num_tt>=6 & cat_diff_num_tt==0
replace cat_diff_num_tt=. if diff_num_tt==.
*Lit
replace cat_diff_lit_tt=1 if diff_lit_tt<=-4 & cat_diff_lit_tt==0  
replace cat_diff_lit_tt=2 if diff_lit_tt<=-1.6 & diff_lit_tt>-4 & cat_diff_lit_tt==0  
replace cat_diff_lit_tt=3 if diff_lit_tt<=-0.8 & diff_lit_tt>-1.6 & cat_diff_lit_tt==0 
replace cat_diff_lit_tt=4 if diff_lit_tt<=-0.4 & diff_lit_tt>-0.8 & cat_diff_lit_tt==0 
replace cat_diff_lit_tt=5 if diff_lit_tt>-0.4 & diff_lit_tt<0.4 & cat_diff_lit_tt==0
replace cat_diff_lit_tt=6 if diff_lit_tt>=0.4 & diff_lit_tt<0.8 & cat_diff_lit_tt==0
replace cat_diff_lit_tt=7 if diff_lit_tt>=0.8 & diff_lit_tt<1.6 & cat_diff_lit_tt==0
replace cat_diff_lit_tt=8 if diff_lit_tt>=1.6 & diff_lit_tt<4 & cat_diff_lit_tt==0
replace cat_diff_lit_tt=9 if diff_lit_tt>=4 & cat_diff_lit_tt==0
replace cat_diff_lit_tt=. if diff_lit_tt==.
label define varcat 1"[-1;-0.5]" 2"]-0.5;-0.2]" 3"]-0.2;-0.1]" 4"]-0.1;-0.05]" 5"]-0.05;0.05[" 6"[0.05;0.1[" 7"[0.1;0.2[" 8"[0.2;0.5[" 9"[0.5;1]", replace
label values cat_diff_raven_tt varcat
label values cat_diff_num_tt varcat
label values cat_diff_lit_tt varcat
****************************************
* END










****************************************
* Personality traits
****************************************
foreach x in cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit ars ars2 ars3{
gen delta_`x'=((`x'_2020-`x')*100/`x')
gen diff_`x'=`x'_2020-`x'
gen absdelta_`x'=abs(delta_`x')
gen absdiff_`x'=abs(diff_`x')
gen cat_diff_`x'=0 if _merge==3
}

foreach x in diff_cr_OP diff_cr_CO diff_cr_EX diff_cr_AG diff_cr_ES diff_cr_Grit diff_OP diff_CO diff_EX diff_AG diff_ES diff_Grit {
replace cat_`x'=1 if `x'<=-2 & cat_`x'==0  // 				]-inf;-50]
replace cat_`x'=2 if `x'<=-0.8 & `x'>-2 & cat_`x'==0  // 	]-50;-20]
replace cat_`x'=3 if `x'<=-0.4 & `x'>-0.8 & cat_`x'==0 //		]-20;-10]
replace cat_`x'=4 if `x'<=-0.2 & `x'>-0.4 & cat_`x'==0 // 		]-10;-5]

replace cat_`x'=5 if `x'>-0.2 & `x'<0.2 & cat_`x'==0 //		]-5;5[

replace cat_`x'=6 if `x'>=0.2 & `x'<0.4 & cat_`x'==0 //			[5;10[
replace cat_`x'=7 if `x'>=0.4 & `x'<0.8 & cat_`x'==0
replace cat_`x'=8 if `x'>=0.8 & `x'<2 & cat_`x'==0
replace cat_`x'=9 if `x'>=2 & cat_`x'==0

replace cat_`x'=. if `x'==.

label values cat_`x' varcat

}

********* Age
gen agecat1=0 		if age_2020<=34
replace agecat1=1 	if age_2020>34 & age_2020!=.
label define age 0"];30] 2016-17" 1"]30;[ 2016-17"
label values agecat1 age

****************************************
* END











****************************************
* BIAS
****************************************
*** Variation
gen pathars=.
replace pathars=1 if ars3>=0.5 & ars3_2020>=0.5 & ars3!=. & ars3_2020!=.  // tjrs
replace pathars=2 if ars3<0.5 & ars3_2020>=0.5 & ars3!=. & ars3_2020!=.  // devenu
replace pathars=3 if ars3>=0.5 & ars3_2020<0.5 & ars3!=. & ars3_2020!=.  // sort
replace pathars=4 if ars3<0.5 & ars3_2020<0.5 & ars3!=. & ars3_2020!=.  // jamais
tab pathars sex

label define pathars 1"Always biased" 2"Becomes biased" 3"Leave bias" 4"Never biased"
label values pathars pathars


****************************************
* END
