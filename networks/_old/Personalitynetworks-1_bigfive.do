*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*October 8, 2024
*-----
gl link = "networks"
*Correction base alters et bases couples
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\networks.do"
*-------------------------











****************************************
* Recoder les variables
****************************************
cls
use"raw/NEEMSIS2-ego", clear


* Add caste
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(caste)
keep if _merge==3
drop _merge
order HHID2020 INDID2020 egoid sex caste


********** Macro
global big5grit curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking

global locus locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6



********** Recode 1: replace 99 with missing
foreach x in $big5grit {
replace `x'=. if `x'==99 | `x'==6
}
foreach x in $locus {
replace `x'=. if `x'==99
}



********** Recode 2: all so that more is better! 
foreach x of varlist $big5grit {
recode `x' (5=1) (4=2) (3=3) (2=4) (1=5)
}

label define big5n 1"5 - Almost never" 2"4 - Rarely" 3"3 - Sometimes" 4"2 - Quite often" 5"1 - Almost always", replace
foreach x in $big5grit {
label values `x' big5n
}




***** Reverse locuscontrol4 5 6 for min=intern and max=extern as locuscontrol1 2 3
forvalues i=4(1)6 {
vreverse locuscontrol`i', gen(locuscontrol`i'_rv)
*rename locuscontrol`i' locuscontrol`i'_original
*rename locuscontrol`i'_rv locuscontrol`i'
}


save"_temp1", replace
****************************************
* END















****************************************
* Acquiescence bias
****************************************
use"_temp1", clear



********** Acquiescence bias measure and correction
local var ///
rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
nervous staycalm ///  
worryalot managestress 
egen ars=rowmean(`var') 
gen ars2=ars-3  
gen ars3=abs(ars2)

tabstat ars3, stat(n mean sd p50)
label var ars "bias at 3"
label var ars2 "bias at 0"
label var ars3 "abs bias at 0"
 




********** Recode 3: Reverse coded les items reverses pour que tout soit dans le même sens dans un seul et même trait: que les var tendent vers le traits pour lequel elles ont été posées

foreach x of varlist rudetoother putoffduties easilydistracted shywithpeople repetitive~s nervous changemood feeldepressed easilyupset worryalot {
recode `x' (5=1) (4=2) (3=3) (2=4) (1=5)
}
label define big5n2 5"5 - Almost never" 4"4 - Rarely" 3"3 - Sometimes" 2"2 - Quite often" 1"1 - Almost always", replace 
foreach x in rudetoother putoffduties easilydistracted shywithpeople repetitive~s nervous changemood feeldepressed easilyupset worryalot {
label values `x' big5n2
}

*corrected items: 
foreach var of varlist $big5grit {
gen cr_`var'=`var'-ars2 if ars!=. 
}
ta ars2



save"_temp2", replace
****************************************
* END















****************************************
* Imputation
****************************************
use"_temp2", clear


********** Check missings
mdesc $big5grit
mdesc $locus


********** Imputation for corrected
global big5cr cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking

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


save"_temp3", replace
****************************************
* END















****************************************
* Naive taxonomies
****************************************
use"_temp3", clear



********** Big5 taxonomy
egen cr_OP = rowmean(cr_curious cr_interested~t   cr_repetitive~s cr_inventive cr_liketothink cr_newideas cr_activeimag~n)
egen cr_CO = rowmean(cr_organized  cr_makeplans cr_workhard cr_appointmen~e cr_putoffduties cr_easilydist~d cr_completedu~s) 
egen cr_EX = rowmean(cr_enjoypeople cr_sharefeeli~s cr_shywithpeo~e  cr_enthusiastic  cr_talktomany~e  cr_talkative cr_expressing~s ) 
egen cr_AG = rowmean(cr_workwithot~r   cr_understand~g cr_trustingof~r cr_rudetoother cr_toleratefa~s  cr_forgiveother  cr_helpfulwit~s) 
egen cr_ES = rowmean(cr_managestress  cr_nervous  cr_changemood cr_feeldepres~d cr_easilyupset cr_worryalot  cr_staycalm) 
egen cr_Grit = rowmean(cr_tryhard  cr_stickwithgoals   cr_goaftergoal cr_finishwhatbegin cr_finishtasks  cr_keepworking)



********** Locus
global locus locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4_rv locuscontrol5_rv locuscontrol6_rv
fre $locus

egen locus=rowmean($locus)
replace locus=round(locus, .01)
label var locus "intern --> extern"


save"_temp4", replace
****************************************
* END















****************************************
* Factor analysis
****************************************
use"_temp4", clear


********** Macro
*global allvar imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm imcr_tryhard imcr_stickwithgoals imcr_goaftergoal imcr_finishwhatbegin imcr_finishtasks imcr_keepworking locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4_rv locuscontrol5_rv locuscontrol6_rv

global allvar imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm




********** Factor analyses
minap $allvar
factor $allvar, pcf fa(5)
rotate, quartimin
putexcel set "EFA_nogritnolocus.xlsx", modify sheet(Step1-SCORE)
putexcel (C2)=matrix(e(r_L))


********** omegacoef with Laajaj approach for factor analysis and Cobb Clark
** F1
global f1 imcr_easilyupset imcr_nervous imcr_worryalot imcr_feeldepressed imcr_changemood imcr_easilydistracted imcr_shywithpeople imcr_putoffduties imcr_rudetoother imcr_repetitivetasks
** F2
global f2 imcr_makeplans imcr_appointmentontime imcr_completeduties imcr_enthusiastic imcr_organized imcr_workhard imcr_workwithother
** F3
global f3 imcr_liketothink imcr_activeimagination imcr_expressingthoughts imcr_sharefeelings imcr_newideas imcr_inventive imcr_curious imcr_talktomanypeople imcr_talkative imcr_interestedbyart imcr_understandotherfeeling
** F4
global f4 imcr_staycalm imcr_managestress
** F5
global f5 imcr_forgiveother imcr_toleratefaults imcr_trustingofother imcr_enjoypeople imcr_helpfulwithothers

*** omegacoef
omegacoef $f1
omegacoef $f2
omegacoef $f3
alpha $f4
omegacoef $f5

*** Score
egen f1_2016=rowmean($f1)
egen f2_2016=rowmean($f2)
egen f3_2016=rowmean($f3)
egen f4_2016=rowmean($f4)
egen f5_2016=rowmean($f5)









****************************************
* END
