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
*screeplot, neigen(15) yline(1)

* Velicer Minimum Average Partial Correlation
*ssc install minap
minap $imcr_without
* Without Grit 3

* Horn Parallel Analysis
*ssc instal paran 
*paran $imcr_without, factor(pcf)
* Without Grit 6

*****
*
factor $imcr_without, pcf mineigen(1) fa(3)
putexcel set "new/EFA_pooled.xlsx", modify sheet("Scores")
putexcel (D2)=matrix(e(L))

*
rotate, quartimin
predict f1without_alt_ES f2without_alt_OP f3without_alt_CO f4without_alt_EXAG f5without_alt_EXES f6without_alt_AG
putexcel set "new/EFA_pooled.xlsx", modify sheet("Rotated")
putexcel (D2)=matrix(e(r_L))


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




********** Factors construction

***** Without
*
omegacoef $f1without
egen f1without=rowmean($f1without)
replace f1without=0 if f1without<0 & f1without!=. 
replace f1without=6 if f1without>6 & f1without!=.
rename f1without f1without_ES
*
omegacoef $f2without
egen f2without=rowmean($f2without)
replace f2without=0 if f2without<0 & f2without!=. 
replace f2without=6 if f2without>6 & f2without!=. 
rename f2without f2without_OP
*
omegacoef $f3without
egen f3without=rowmean($f3without)
replace f3without=0 if f3without<0 & f3without!=. 
replace f3without=6 if f3without>6 & f3without!=. 
rename f3without f3without_CO
*
*omegacoef $f4without
egen f4without=rowmean($f4without)
replace f4without=0 if f4without<0 & f4without!=. 
replace f4without=6 if f4without>6 & f4without!=. 
rename f4without f4without_EXAG
*
*omegacoef $f5without
egen f5without=rowmean($f5without)
replace f5without=0 if f5without<0 & f5without!=. 
replace f5without=6 if f5without>6 & f5without!=. 
rename f5without f5without_EXES
*
*omegacoef $f6without
egen f6without=rowmean($f6without)
replace f6without=0 if f6without<0 & f6without!=. 
replace f6without=6 if f6without>6 & f6without!=. 
rename f6without f6without_AG



save "panel_stab_v2_pooled", replace
****************************************
* END

















****************************************
* Stat pooled
****************************************
use "panel_stab_v2_pooled", clear


********** Clean
rename f1without_ES fES
rename f2without_OP fOP
rename f3without_CO fCO
rename f1without_alt_ES fESs
rename f2without_alt_OP fOPs
rename f3without_alt_CO fCOs

rename f1with_ES fbES
rename f2with_CO fbCO
rename f3with_OP fbOP
rename f1with_alt_ES fbESs
rename f2with_alt_CO fbCOs
rename f3with_alt_OP fbOPs

rename OP_imcr OP
rename CO_imcr CO
rename EX_imcr EX
rename AG_imcr AG
rename ES_imcr ES
rename Grit_imcr Grit

global fact fES fOP fCO fbES fbCO fbOP
global facts fESs fOPs fCOs fbESs fbCOs fbOPs
global naive OP CO EX AG ES Grit
global cogn num_tt lit_tt raven_tt
global perso $fact $facts $naive $cogn


keep HHID_panel INDID_panel year $perso $imcr_without



********** Rank order stability

***** ID
egen unique_id=group(HHID_panel INDID_panel)
gen wave=1 if year==2016
replace wave=2 if year==2020
fre wave

***** Stat
cls
icc fES unique_id
icc fOP unique_id
icc fCO unique_id




********** Reshape
drop unique_id wave
reshape wide $perso $imcr_without, i(HHID_panel INDID_panel) j(year)

pwcorr fES2016 fES2020, star(.05)
pwcorr fOP2016 fOP2020, star(.05)
pwcorr fCO2016 fCO2020, star(.05)

foreach x in $perso {
order `x'2020, after(`x'2016)
}
order imcr_curious2016 imcr_interestedbyart2016 imcr_repetitivetasks2016 imcr_inventive2016 imcr_liketothink2016 imcr_newideas2016 imcr_activeimagination2016 imcr_organized2016 imcr_makeplans2016 imcr_workhard2016 imcr_appointmentontime2016 imcr_putoffduties2016 imcr_easilydistracted2016 imcr_completeduties2016 imcr_enjoypeople2016 imcr_sharefeelings2016 imcr_shywithpeople2016 imcr_enthusiastic2016 imcr_talktomanypeople2016 imcr_talkative2016 imcr_expressingthoughts2016 imcr_workwithother2016 imcr_understandotherfeeling2016 imcr_trustingofother2016 imcr_rudetoother2016 imcr_toleratefaults2016 imcr_forgiveother2016 imcr_helpfulwithothers2016 imcr_managestress2016 imcr_nervous2016 imcr_changemood2016 imcr_feeldepressed2016 imcr_easilyupset2016 imcr_worryalot2016 imcr_staycalm2016 imcr_curious2020 imcr_interestedbyart2020 imcr_repetitivetasks2020 imcr_inventive2020 imcr_liketothink2020 imcr_newideas2020 imcr_activeimagination2020 imcr_organized2020 imcr_makeplans2020 imcr_workhard2020 imcr_appointmentontime2020 imcr_putoffduties2020 imcr_easilydistracted2020 imcr_completeduties2020 imcr_enjoypeople2020 imcr_sharefeelings2020 imcr_shywithpeople2020 imcr_enthusiastic2020 imcr_talktomanypeople2020 imcr_talkative2020 imcr_expressingthoughts2020 imcr_workwithother2020 imcr_understandotherfeeling2020 imcr_trustingofother2020 imcr_rudetoother2020 imcr_toleratefaults2020 imcr_forgiveother2020 imcr_helpfulwithothers2020 imcr_managestress2020 imcr_nervous2020 imcr_changemood2020 imcr_feeldepressed2020 imcr_easilyupset2020 imcr_worryalot2020 imcr_staycalm2020, last


********** Diff
foreach x in $perso {
gen diff_`x'=`x'2020-`x'2016
gen abs_diff_`x'=abs(`x'2020-`x'2016)
gen var_`x'=(`x'2020-`x'2016)*100/`x'2016
gen abs_var_`x'=abs((`x'2020-`x'2016)*100/`x'2016)
order diff_`x' abs_diff_`x' var_`x' abs_var_`x', after(`x'2020)
}



********** Abs cat
foreach x in $perso {
gen cat_abs_var_`x'=.
order cat_abs_var_`x', after(abs_var_`x')
}

label define catvar 1"Less than 1%" 2"1-5%" 3"5-10%" 4"10-20%" 5"20-50%" 6"50-100%" 7"More than 100%"

foreach x in $perso {
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
foreach x in $perso {
gen catvar_`x'=.
order catvar_`x', after(cat_abs_var_`x')
}
label define catvar2 1"Decrease" 2"Stable" 3"Increase"
foreach x in $perso {
replace catvar_`x'=1 if var_`x'<-10 & var_`x'!=.
replace catvar_`x'=2 if var_`x'>=-10 & var_`x'<=10 & var_`x'!=.
replace catvar_`x'=3 if var_`x'>=10 & var_`x'!=.
label values catvar_`x' catvar2
}
*
foreach x in $perso {
gen dumvar_`x'=.
order dumvar_`x', after(catvar_`x')
}
label define dumvar2 0"Stable" 1"Instable"
foreach x in $perso {
replace dumvar_`x'=0 if catvar_`x'==2
replace dumvar_`x'=1 if catvar_`x'==1 | catvar_`x'==3
label values dumvar_`x' dumvar2
}






********** Catdiff
foreach x in $perso {
gen catdiff_`x'=.
order catdiff_`x', after(abs_diff_`x')
}
foreach x in $perso {
replace catdiff_`x'=1 if diff_`x'<-0.4 & diff_`x'!=.
replace catdiff_`x'=2 if diff_`x'>=-0.4 & diff_`x'<=0.4 & diff_`x'!=.
replace catdiff_`x'=3 if diff_`x'>=0.4 & diff_`x'!=.
label values catdiff_`x' catvar2
}
*
foreach x in $perso {
gen dumdiff_`x'=.
order dumdiff_`x', after(catdiff_`x')
}
foreach x in $perso {
replace dumdiff_`x'=0 if catdiff_`x'==2
replace dumdiff_`x'=1 if catdiff_`x'==1 | catdiff_`x'==3
label values dumdiff_`x' dumvar2
}



********** Stat

preserve
drop if fES2016==.
drop if fES2020==.

ta catdiff_fES catvar_fES
ta catdiff_fESs catvar_fESs

ta catdiff_fOP catvar_fOP
ta catdiff_fOPs catvar_fOPs

ta catdiff_fCO catvar_fCO
ta catdiff_fCOs catvar_fCOs
restore
/*
Le plus pertinent, selon moi, c'est de regarder la simple différence sur les moyennes plutôt que la variation et le score.
*/



save "panel_stab_v2_pooled_wide", replace
****************************************
* END



/*
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
predict f1with_alt_ES f2with_alt_COGrit f3with_alt_OP f4with_alt_EXAG f5with_alt_EXES f6with_alt_AGGrit f7with_alt_OP
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


***** With
*
omegacoef $f1with
egen f1with=rowmean($f1with)
replace f1with=0 if f1with<0 & f1with!=. 
replace f1with=6 if f1with>6 & f1with!=. 
rename f1with f1with_ES
*
omegacoef $f2with
egen f2with=rowmean($f2with)
replace f2with=0 if f2with<0 & f2with!=. 
replace f2with=6 if f2with>6 & f2with!=.
rename f2with f2with_COGrit
*
omegacoef $f3with
egen f3with=rowmean($f3with)
replace f3with=0 if f3with<0 & f3with!=. 
replace f3with=6 if f3with>6 & f3with!=.
rename f3with f3with_OP
*
*omegacoef $f4with
egen f4with=rowmean($f4with)
replace f4with=0 if f4with<0 & f4with!=. 
replace f4with=6 if f4with>6 & f4with!=.
rename f4with f4with_EXAG
*
*omegacoef $f5with
egen f5with=rowmean($f5with)
replace f5with=0 if f5with<0 & f5with!=. 
replace f5with=6 if f5with>6 & f5with!=.
rename f5with f5with_EXES
*
*omegacoef $f6with
egen f6with=rowmean($f6with)
replace f6with=0 if f6with<0 & f6with!=. 
replace f6with=6 if f6with>6 & f6with!=.
rename f6with f6with_AGGrit
*
*omegacoef $f7with
egen f7with=rowmean($f7with)
replace f7with=0 if f7with<0 & f7with!=. 
replace f7with=6 if f7with>6 & f7with!=.
rename f7with f7with_OP









********** Naive
* 
omegacoef $imcr_OP
egen OP_imcr=rowmean($imcr_OP)
replace OP_imcr=0 if OP_imcr<0 & OP_imcr!=.
replace OP_imcr=6 if OP_imcr>6 & OP_imcr!=.
* 
omegacoef $imcr_CO
egen CO_imcr=rowmean($imcr_CO)
replace CO_imcr=0 if CO_imcr<0 & CO_imcr!=.
replace CO_imcr=6 if CO_imcr>6 & CO_imcr!=.
*
omegacoef $imcr_EX
egen EX_imcr=rowmean($imcr_EX)
replace EX_imcr=0 if EX_imcr<0 & EX_imcr!=.
replace EX_imcr=6 if EX_imcr>6 & EX_imcr!=.
*
omegacoef $imcr_AG
egen AG_imcr=rowmean($imcr_AG)
replace AG_imcr=0 if AG_imcr<0 & AG_imcr!=.
replace AG_imcr=6 if AG_imcr>6 & AG_imcr!=.
*
omegacoef $imcr_ES
egen ES_imcr=rowmean($imcr_ES)
replace ES_imcr=0 if ES_imcr<0 & ES_imcr!=.
replace ES_imcr=6 if ES_imcr>6 & ES_imcr!=.
*
omegacoef $imcr_Grit
egen Grit_imcr=rowmean($imcr_Grit)
replace Grit_imcr=0 if Grit_imcr<0 & Grit_imcr!=.
replace Grit_imcr=6 if Grit_imcr>6 & Grit_imcr!=.

