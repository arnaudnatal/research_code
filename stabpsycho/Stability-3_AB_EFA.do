*-------------------------
cls
*XXXX XXXX
*XXXX@XXXX
*March 19, 2024
*-----
gl link = "stabpsycho"
*-----
do "C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------

*cd"C:\Users\anatal\Downloads\JDS_Stability\Analysis"




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


*********** Imputation 
global big5cr ///
cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination ///
cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties ///
cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts ///
cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers ///
cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm ///
cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts ///
workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers ///
managestress nervous changemood feeldepressed easilyupset worryalot staycalm ///
tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking

foreach x in $big5cr $big5{
gen im`x'=`x'
}

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr $big5{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}



********** Macro

***** Corr
global imcr_OP imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination 

global imcr_CO imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties

global imcr_EX imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts 

global imcr_AG imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers

global imcr_ES imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm

global imcr_Grit imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking


***** Non corr
global imOP imcurious iminterestedbyart imrepetitivetasks iminventive imliketothink imnewideas imactiveimagination 

global imCO imorganized immakeplans imworkhard imappointmentontime imputoffduties imeasilydistracted imcompleteduties

global imEX imenjoypeople imsharefeelings imshywithpeople imenthusiastic imtalktomanypeople imtalkative imexpressingthoughts 

global imAG imworkwithother imunderstandotherfeeling imtrustingofother imrudetoother imtoleratefaults imforgiveother imhelpfulwithothers

global imES immanagestress imnervous imchangemood imfeeldepressed imeasilyupset imworryalot imstaycalm

global imGrit imtryhard imstickwithgoals imgoaftergoal imfinishwhatbegin imfinishtasks imkeepworking






********** EFA corr

***** Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf

* Kaiser criterion (eigenvalue>1)

* Catell screeplot
*screeplot, neigen(15) yline(1)

* Velicer Minimum Average Partial Correlation
minap $imcr_without

* Horn Parallel Analysis
*paran $imcr_without, factor(pcf)



***** EFA
cls
factor $imcr_without, pcf fa(3)
rotate, quartimin
predict f1corr f2corr f3corr
*putexcel set "new/EFA_pooled.xlsx", modify sheet("Corr")
*putexcel (D2)=matrix(e(r_L))
rename f1corr fsES
rename f2corr fsOPEX
rename f3corr fsCO

***** Macro
* F1
global f1corr imcr_workwithother imcr_enjoypeople imcr_rudetoother imcr_shywithpeople imcr_repetitivetasks imcr_putoffduties imcr_feeldepressed imcr_changemood imcr_easilyupset imcr_nervous imcr_worryalot imcr_easilydistracted

* F2
global f2corr imcr_understandotherfeeling imcr_talktomanypeople imcr_interestedbyart imcr_curious imcr_talkative imcr_expressingthoughts imcr_sharefeelings imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination

* F3
global f3corr imcr_organized imcr_enthusiastic imcr_appointmentontime imcr_workhard imcr_completeduties imcr_makeplans


***** Construction
*
omegacoef $f1corr
egen f1corr_ES=rowmean($f1corr)
*
omegacoef $f2corr
egen f2corr_OPEX=rowmean($f2corr)
*
omegacoef $f3corr
egen f3corr_CO=rowmean($f3corr)







********** Big Five mode
omegacoef $imcr_OP
egen crOP=rowmean($imcr_OP)

omegacoef $imcr_CO
egen crCO=rowmean($imcr_CO)

omegacoef $imcr_EX
egen crEX=rowmean($imcr_EX)

omegacoef $imcr_AG
egen crAG=rowmean($imcr_AG)

omegacoef $imcr_ES
egen crES=rowmean($imcr_ES)





********** Correlation between factors and traits
corr f1corr_ES f2corr_OPEX f3corr_CO crOP crCO crEX crAG crES
spearman f1corr_ES f2corr_OPEX f3corr_CO crOP crCO crEX crAG crES, stats(rho p)


save "panel_stab_v2_pooled", replace
****************************************
* END

















****************************************
* Stat pooled
****************************************
use "panel_stab_v2_pooled", clear


********** Clean
rename f1corr_ES fES
rename f2corr_OP fOPEX
rename f3corr_CO fCO

global fact fES fOPEX fCO
global b5 crOP crCO crEX crAG crES
global fs fsES fsOPEX fsCO
global cogn num_tt lit_tt raven_tt
global perso $fact $b5 $fs $cogn

save "panel_stab_v2_pooled_long", replace


********** Distribution of ars2
/*
twoway (kdensity ars2, bwidth(0.1) xline(0)) ///
, ///
xtitle("Acquiescence score") ytitle("Density") ///
note("Kernel: Epanechnikov" "Bandwidth: 0.1", size(vsmall)) ///
name(acqscore, replace)
graph save "new/AcqScore", replace
graph export "new/AcqScore.pdf", as(pdf) replace
*/


********** Reshape
keep HHID_panel INDID_panel year $perso $imcr_without
reshape wide $perso $imcr_without, i(HHID_panel INDID_panel) j(year)


foreach x in $perso {
order `x'2020, after(`x'2016)
}
order imcr_curious2016 imcr_interestedbyart2016 imcr_repetitivetasks2016 imcr_inventive2016 imcr_liketothink2016 imcr_newideas2016 imcr_activeimagination2016 imcr_organized2016 imcr_makeplans2016 imcr_workhard2016 imcr_appointmentontime2016 imcr_putoffduties2016 imcr_easilydistracted2016 imcr_completeduties2016 imcr_enjoypeople2016 imcr_sharefeelings2016 imcr_shywithpeople2016 imcr_enthusiastic2016 imcr_talktomanypeople2016 imcr_talkative2016 imcr_expressingthoughts2016 imcr_workwithother2016 imcr_understandotherfeeling2016 imcr_trustingofother2016 imcr_rudetoother2016 imcr_toleratefaults2016 imcr_forgiveother2016 imcr_helpfulwithothers2016 imcr_managestress2016 imcr_nervous2016 imcr_changemood2016 imcr_feeldepressed2016 imcr_easilyupset2016 imcr_worryalot2016 imcr_staycalm2016 imcr_curious2020 imcr_interestedbyart2020 imcr_repetitivetasks2020 imcr_inventive2020 imcr_liketothink2020 imcr_newideas2020 imcr_activeimagination2020 imcr_organized2020 imcr_makeplans2020 imcr_workhard2020 imcr_appointmentontime2020 imcr_putoffduties2020 imcr_easilydistracted2020 imcr_completeduties2020 imcr_enjoypeople2020 imcr_sharefeelings2020 imcr_shywithpeople2020 imcr_enthusiastic2020 imcr_talktomanypeople2020 imcr_talkative2020 imcr_expressingthoughts2020 imcr_workwithother2020 imcr_understandotherfeeling2020 imcr_trustingofother2020 imcr_rudetoother2020 imcr_toleratefaults2020 imcr_forgiveother2020 imcr_helpfulwithothers2020 imcr_managestress2020 imcr_nervous2020 imcr_changemood2020 imcr_feeldepressed2020 imcr_easilyupset2020 imcr_worryalot2020 imcr_staycalm2020, last


********** Var
*
foreach x in $perso {
gen var_`x'=(`x'2020-`x'2016)*100/`x'2016
gen abs_var_`x'=abs(var_`x')
order var_`x' abs_var_`x', after(`x'2020)
}

* 
foreach x in $perso {
gen catvar_`x'=.
order catvar_`x', after(abs_var_`x')
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





********** Diff
*
foreach x in $perso {
gen diff_`x'=`x'2020-`x'2016
gen abs_diff_`x'=abs(diff_`x')
order diff_`x' abs_diff_`x', after(`x'2020)
}

*
foreach x in $perso {
gen catdiff_`x'=.
order catdiff_`x', after(abs_diff_`x')
}
foreach x in $perso {
replace catdiff_`x'=1 if diff_`x'<-0.6 & diff_`x'!=.
replace catdiff_`x'=2 if diff_`x'>=-0.6 & diff_`x'<=0.6 & diff_`x'!=.
replace catdiff_`x'=3 if diff_`x'>=0.6 & diff_`x'!=.
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

save "panel_stab_v2_pooled_wide", replace
****************************************
* END















****************************************
* Attrition
****************************************
use"panel_stab_v2_pooled_wide", clear


keep HHID_panel fES2016 fES2020 fOPEX2016 fOPEX2020 fCO2016 fCO2020 

gen attrition2016=0
replace attrition2016=1 if fES2016!=. & fES2020==.
replace attrition2016=. if fES2016==.
label define attrition2016 0"Recovered in 2020-21" 1"Lost in 2020-21"
label values attrition2016 attrition2016


* ES
tabstat fES2016 fOPEX2016 fCO2016, stat(mean median) by(attrition2016)
reg fES2016 i.attrition2016
qreg fES2016 i.attrition2016, q(.5)

reg fOPEX2016 i.attrition2016
qreg fOPEX2016 i.attrition2016, q(.5)

reg fCO2016 i.attrition2016
qreg fCO2016 i.attrition2016, q(.5)

****************************************
* END















****************************************
* EFA pooled sample with selections
****************************************
use"panel_stab_v2", clear

********** Non educ VS educ
gen educ=.
replace educ=0 if edulevel==0
replace educ=0 if edulevel==1
replace educ=1 if edulevel==2
replace educ=1 if edulevel==3
replace educ=1 if edulevel==4
ta edulevel educ, m
fre educ


********** Income
xtile decinc=annualincome_HH, n(10)
gen richinc=0 if decinc<=5
replace richinc=1 if decinc>5
ta decinc richinc, m


********** Wealth
xtile decwea=assets_total1000, n(10)
gen richwea=0 if decwea<=5
replace richwea=1 if decwea>5
ta decwea richwea, m


*********** Imputation 
global big5cr ///
cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination ///
cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties ///
cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts ///
cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers ///
cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm ///
cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

global big5 ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts ///
workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers ///
managestress nervous changemood feeldepressed easilyupset worryalot staycalm ///
tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking

foreach x in $big5cr $big5{
gen im`x'=`x'
}

forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5cr $big5{
qui sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if im`x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}



********** Macro

***** Corr
global imcr_OP imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination 

global imcr_CO imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties

global imcr_EX imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts 

global imcr_AG imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers

global imcr_ES imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm




********** NB FACT

preserve
********** Nb fact No educ
* Selection
keep if educ==0
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore



preserve
********** Nb fact Educ
* Selection
keep if educ==1
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore



preserve
********** Nb fact Income poor
* Selection
keep if richinc==0
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore



preserve
********** Nb fact Income rich
* Selection
keep if richinc==1
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore




preserve
********** Nb fact Neemsis 1
* Selection
keep if year==2016
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore


preserve
********** Nb fact Neemsis 2
* Selection
keep if year==2020
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore



/*
preserve
********** Nb fact Wealth poor
* Selection
keep if richwea==0
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore



preserve
********** Nb fact Wealth rich
* Selection
keep if richwea==1
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
restore
*/








********** EFA


preserve
********** EFA No educ
* Selection
keep if educ==0
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(3)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("Non_educ")
putexcel (D2)=matrix(e(r_L))
restore



preserve
********** EFA Educ
* Selection
keep if educ==1
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(2)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("Educ")
putexcel (D2)=matrix(e(r_L))
restore


/*
preserve
********** EFA Wealth poor
* Selection
keep if richwea==0
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(3)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("Wealth_poor")
putexcel (D2)=matrix(e(r_L))
restore



preserve
********** EFA Wealth rich
* Selection
keep if richwea==1
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(3)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("Wealth_rich")
putexcel (D2)=matrix(e(r_L))
restore
*/

preserve
********** EFA Income poor
* Selection
keep if richinc==0
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(3)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("Income_poor")
putexcel (D2)=matrix(e(r_L))
restore



preserve
********** EFA Income rich
* Selection
keep if richinc==1
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(3)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("Income_rich")
putexcel (D2)=matrix(e(r_L))
restore




preserve
********** EFA Neemsis 1
* Selection
keep if year==2016
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(5)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("N1")
putexcel (D2)=matrix(e(r_L))
restore


preserve
********** EFA Neemsis 2
* Selection
keep if year==2020
* Nb factors
global imcr_without $imcr_OP $imcr_CO $imcr_EX $imcr_AG $imcr_ES
factortest $imcr_without
factor $imcr_without, pcf
* Velicer Minimum Average Partial Correlation
minap $imcr_without
* EFA
factor $imcr_without, pcf fa(2)
rotate, quartimin
predict f1corr f2corr f3corr
putexcel set "new/EFA_pooled.xlsx", modify sheet("N2")
putexcel (D2)=matrix(e(r_L))
restore


****************************************
* END
