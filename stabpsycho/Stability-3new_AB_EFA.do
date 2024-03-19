*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------










****************************************
* Acquiescence bias
****************************************
use"panel_stab_v2", clear

fre panel
********** Graph
*** General
codebook time
label define time 1"2016-17" 2"2020-21", modify

/*
stripplot ars3 if panel==1, over(time) ///
stack width(0.01) jitter(1) /// //refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.2)1.6, ang(h)) yla(, valuelabel noticks) ///
xmtick(0(.1)1.7) ymtick(0.9(0)2.5) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%" 5 "Individual") pos(6) col(3) on) ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
xtitle("") ytitle("") name(biaspanel, replace)
graph export bias_panel.pdf, replace
*/

****************************************
* END











****************************************
* Impact of enumerators on bias
****************************************
use"panel_stab_v2", clear


*** 2016-17
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid if year==2016
est store ars1_1
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid i.username_2016_code if year==2016
est store ars1_2


*** 2016-17
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid if year==2020
est store ars2_1
qui reg ars3 i.sex i.caste age ib(0).edulevel i.villageid i.username_2020_code if year==2020
est store ars2_2

esttab ars1_1 ars1_2 ars2_1 ars2_2, ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2) star)" se(par fmt(2))) ///
	drop() ///	
	legend label varlabels(_cons constant) ///
	stats(N r2, fmt(0 3) labels(`"Observations"' `"\$R^2$"'))

****************************************
* END











****************************************
* EFA pooled sample
****************************************
use"panel_stab_v2", clear

ta year



********** Imputation for corrected one
global big5cr ///
cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination ///
cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties ///
cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts ///
cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers ///
cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm ///
cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

foreach x in $big5cr{
gen im`x'=`x'
}

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}



********** Macro
global imcr_OP imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination 

global imcr_CO imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties

global imcr_EX imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts 

global imcr_AG imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers

global imcr_ES imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm

global imcr_Grit imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking





********** Without Grit
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES


*****
factortest $imcr_without
factor $imcr_without, pcf

***** How many factors to keep?
* Kaiser criterion (eigenvalue>1) : 8  (without Grit)

* Catell screeplot
*screeplot
*screeplot, neigen(15) yline(1)

* Velicer Minimum Average Partial Correlation
*ssc install minap 
*minap $imcr_without
* Without Grit 3

* Horn Parallel Analysis
*ssc instal paran 
*paran $imcr_without, factor(pcf)
* Without Grit 6

*****
factor $imcr_without, pcf fa(6)
rotate, quartimin
*putexcel set "EFA_pooled.xlsx", modify sheet("Without_Grit")
*putexcel (E2)=matrix(e(r_L))


***** Factors
* F1
global f1without imcr_enjoypeople imcr_rudetoother imcr_shywithpeople imcr_repetitivetasks imcr_putoffduties imcr_feeldepressed imcr_changemood imcr_nervous imcr_easilyupset imcr_easilydistracted imcr_worryalot

* F2
global f2without imcr_interestedbyart imcr_liketothink imcr_activeimagination imcr_inventive imcr_newideas imcr_curious

* F3
global f3without imcr_workwithother imcr_organized imcr_appointmentontime imcr_workhard imcr_makeplans imcr_completeduties imcr_enthusiastic

* F4
global f4without imcr_understandotherfeeling imcr_talktomanypeople imcr_helpfulwithothers imcr_talkative

* F5
global f5without imcr_expressingthoughts imcr_sharefeelings imcr_staycalm imcr_managestress

* F6
global f6without imcr_toleratefaults imcr_trustingofother imcr_forgiveother







********** With Grit
global imcr_with $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES $imcr_Grit

*****
factortest $imcr_with
factor $imcr_with, pcf

***** How many factors to keep?
* Kaiser criterion (eigenvalue>1) : 10 (with Grit)

* Catell screeplot
*screeplot
*screeplot, neigen(15) yline(1)

* Velicer Minimum Average Partial Correlation
*ssc install minap 
*minap $imcr_with
* With Grit 3


* Horn Parallel Analysis
*ssc instal paran 
*paran $imcr_with, factor(pcf)
* With Grit 7


*****
factor $imcr_with, pcf fa(7)
rotate, quartimin
*putexcel set "EFA_pooled.xlsx", modify sheet("With_Grit")
*putexcel (E2)=matrix(e(r_L))



***** Factors
* F1
global f1with imcr_tryhard imcr_enjoypeople imcr_rudetoother imcr_shywithpeople imcr_repetitivetasks imcr_putoffduties imcr_feeldepressed imcr_changemood imcr_nervous imcr_easilyupset imcr_easilydistracted imcr_worryalot

* F2
global f2with imcr_goaftergoal imcr_finishtasks imcr_workwithother imcr_organized imcr_workhard imcr_appointmentontime imcr_finishwhatbegin imcr_makeplans imcr_completeduties imcr_enthusiastic

* F3
global f3with imcr_understandotherfeeling imcr_liketothink imcr_activeimagination imcr_inventive imcr_newideas imcr_curious

* F4
global f4with imcr_talktomanypeople imcr_helpfulwithothers imcr_talkative

* F5
global f5with imcr_trustingofother imcr_expressingthoughts imcr_sharefeelings imcr_managestress imcr_staycalm

* F6
global f6with imcr_toleratefaults imcr_stickwithgoals imcr_forgiveother imcr_keepworking

* F7
global f7with imcr_interestedbyart













********** Factors construction

***** Without
*
omegacoef $f1without
egen f1without=rowmean($f1without)
*
omegacoef $f2without
egen f2without=rowmean($f2without)
*
omegacoef $f3without
egen f3without=rowmean($f3without)
*
*omegacoef $f4without
egen f4without=rowmean($f4without)
*
*omegacoef $f5without
egen f5without=rowmean($f5without)
*
*omegacoef $f6without
egen f6without=rowmean($f6without)



***** With
*
omegacoef $f1with
egen f1with=rowmean($f1with)
*
omegacoef $f2with
egen f2with=rowmean($f2with)
*
omegacoef $f3with
egen f3with=rowmean($f3with)
*
*omegacoef $f4with
egen f4with=rowmean($f4with)
*
*omegacoef $f5with
egen f5with=rowmean($f5with)
*
*omegacoef $f6with
egen f6with=rowmean($f6with)
*
*omegacoef $f7with
egen f7with=rowmean($f7with)





********** Naive
* 
omegacoef $imcr_OP
egen OP_imcr=rowmean($imcr_OP)
* 
omegacoef $imcr_CO
egen CO_imcr=rowmean($imcr_CO)
*
omegacoef $imcr_EX
egen EX_imcr=rowmean($imcr_EX)
*
omegacoef $imcr_AG
egen AG_imcr=rowmean($imcr_AG)
*
omegacoef $imcr_ES
egen ES_imcr=rowmean($imcr_ES)
*
omegacoef $imcr_Grit
egen Grit_imcr=rowmean($imcr_Grit)


save "panel_stab_v2_pooled", replace
****************************************
* END

















****************************************
* Stat pooled
****************************************
use "panel_stab_v2_pooled", clear

********** Reshape the data base
global traits f1without f2without f3without f4without f5without f6without f1with f2with f3with f4with f5with f6with f7with OP_imcr CO_imcr EX_imcr AG_imcr ES_imcr Grit_imcr


********** Clean
rename f1without fES
rename f2without fOP
rename f3without fCO

rename f1with fbES
rename f2with fbCO
rename f3with fbOP

rename OP_imcr OP
rename CO_imcr CO
rename EX_imcr EX
rename AG_imcr AG
rename ES_imcr ES
rename Grit_imcr Grit

keep HHID_panel INDID_panel year ///
fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit $f1without $f2without $f3without

reshape wide fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit $f1without $f2without $f3without, i(HHID_panel INDID_panel) j(year)


********** Diff
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
gen diff_`x'=`x'2020-`x'2016
gen abs_diff_`x'=abs(`x'2020-`x'2016)
gen var_`x'=(`x'2020-`x'2016)*100/`x'2016
gen abs_var_`x'=abs((`x'2020-`x'2016)*100/`x'2016)
}



********** Abs cat
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
gen cat_abs_var_`x'=.
}

label define catvar 1"Less than 1%" 2"1-5%" 3"5-10%" 4"10-20%" 5"20-50%" 6"50-100%" 7"More than 100%"

foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
replace cat_abs_var_`x'=1 if abs_var_`x'<1 & abs_var_`x'!=.
replace cat_abs_var_`x'=2 if abs_var_`x'>=1 & abs_var_`x'<5 & abs_var_`x'!=.
replace cat_abs_var_`x'=3 if abs_var_`x'>=5 & abs_var_`x'<10 & abs_var_`x'!=.
replace cat_abs_var_`x'=4 if abs_var_`x'>=10 & abs_var_`x'<20 & abs_var_`x'!=.
replace cat_abs_var_`x'=5 if abs_var_`x'>=20 & abs_var_`x'<50 & abs_var_`x'!=.
replace cat_abs_var_`x'=6 if abs_var_`x'>=50 & abs_var_`x'<100 & abs_var_`x'!=.
replace cat_abs_var_`x'=7 if abs_var_`x'>=100 & abs_var_`x'!=.
label values cat_abs_var_`x' catvar
}


********** Catvar
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
gen catvar_`x'=.
}
label define catvar2 1"Decrease" 2"Stable" 3"Increase"
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
replace catvar_`x'=1 if var_`x'<-10 & var_`x'!=.
replace catvar_`x'=2 if var_`x'>=-10 & var_`x'<=10 & var_`x'!=.
replace catvar_`x'=3 if var_`x'>=10 & var_`x'!=.
label values catvar_`x' catvar2
}
*
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
gen dumvar_`x'=.
}
label define dumvar2 0"Stable" 1"Instable"
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
replace dumvar_`x'=0 if catvar_`x'==2
replace dumvar_`x'=1 if catvar_`x'==1 | catvar_`x'==3
label values dumvar_`x' dumvar2
}






********** Catdiff
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
gen catdiff_`x'=.
}
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
replace catdiff_`x'=1 if diff_`x'<-0.5 & diff_`x'!=.
replace catdiff_`x'=2 if diff_`x'>=-0.5 & diff_`x'<=0.5 & diff_`x'!=.
replace catdiff_`x'=3 if diff_`x'>=0.5 & diff_`x'!=.
label values catdiff_`x' catvar2
}
*
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
gen dumdiff_`x'=.
}
foreach x in fES fOP fCO fbES fbCO fbOP OP CO EX AG ES Grit {
replace dumdiff_`x'=0 if catdiff_`x'==2
replace dumdiff_`x'=1 if catdiff_`x'==1 | catdiff_`x'==3
label values dumdiff_`x' dumvar2
}


cls
ta catdiff_fES catvar_fES
ta catdiff_fOP catvar_fOP
ta catdiff_fCO catvar_fCO

cls
ta dumdiff_fES dumvar_fES
ta dumdiff_fOP dumvar_fOP
ta dumdiff_fCO dumvar_fCO


********** Replace abs diff by 0 if diff is below 0.5
foreach x in ES OP CO {
gen abs_diff_rec_f`x'=abs_diff_f`x'
}

foreach x in ES OP CO {
replace abs_diff_rec_f`x'=0 if catdiff_f`x'==2
}


save "panel_stab_v2_pooled_wide", replace
****************************************
* END


