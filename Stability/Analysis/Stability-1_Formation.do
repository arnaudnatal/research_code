cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
August 17, 2021
-----
Stability over time of personality traits: merging des bases
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
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH_v9"
global wave3 "NEEMSIS2-HH_v9"
****************************************
* END







****************************************
* PANEL
***************************************
use"$directory\\$wave2", clear
keep HHID_panel INDID_panel egoid name age sex edulevel jatis caste villageid dummydemonetisation relationshiptohead maritalstatus year
foreach x in egoid name age sex edulevel jatis caste villageid dummydemonetisation relationshiptohead maritalstatus year {
rename `x' `x'_2016
}
save"$wave2-_tempego", replace

use"$directory\\$wave3", clear
keep HHID_panel INDID_panel egoid name age sex edulevel jatis caste villageid relationshiptohead maritalstatus year
foreach x in egoid name age sex edulevel jatis caste villageid relationshiptohead maritalstatus year {
rename `x' `x'_2020
}
save"$wave3-_tempego", replace



*Merge all
use"$directory\\$wave2-_tempego", clear
merge 1:1 HHID_panel INDID_panel using "$directory\\$wave3-_tempego"
rename _merge merge_1620
keep if egoid_2016>0 | egoid_2020>0
keep if year_2016==2016 & year_2020==2020
tab egoid_2016 egoid_2020
order HHID_panel INDID_panel name_2016 egoid_2016 name_2020 egoid_2020

tab egoid_2020


*One var
gen panel=0
replace panel=1 if year_2016!=. & egoid_2016!=0 & year_2020!=. & egoid_2020!=0
tab panel

save"panel", replace
****************************************
* END







****************************************
* PREPA 2016
****************************************
use "$wave2", clear
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag
drop tag

*Merge
merge 1:1 HHID_panel INDID_panel using "panel", keepusing(panel)
drop if _merge==2
drop _merge
recode panel (.=0)

global tokeep age edulevel sex caste jatis name address villageid villageareaid villageid_new villageid_new_comments username ///
dummydemonetisation demotrustneighborhood demotrustemployees_ego demotrustbank_ego demonetworkpeoplehelping_ego demonetworkhelpkinmember_ego demogeneralperception demogoodexpectations demobadexpectations ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking
keep HHINDID HHID_panel INDID_panel panel egoid year $tokeep


********** Rename 2016
/*
foreach x in $tokeep{
rename `x' `x'2016
}
*/

order HHINDID HHID_panel INDID_panel
sort HHINDID

save"$wave2-_ego", replace
****************************************
* END










****************************************
* PREPA 2020
****************************************
use"$wave3", clear
keep if egoid>0
egen HHINDID=concat(HHID_panel INDID_panel), p(/)
duplicates tag HHINDID, gen(tag)
tab tag
drop tag
drop username_str
gen username_str=username+1-1
tostring username_str, replace
drop username
rename username_str username

*Merge
merge 1:1 HHID_panel INDID_panel using "panel", keepusing(panel)
drop if _merge==2
drop _merge
recode panel (.=0)

global tokeep age edulevel sex caste jatis name address villageid villageareaid username ///
covsick ///
curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking
keep HHINDID HHID_panel INDID_panel panel egoid year $tokeep


********** Rename 2020
/*
foreach x in $tokeep{
rename `x' `x'2020
}
*/

order HHINDID HHID_panel INDID_panel
sort HHINDID

save"$wave3-_ego", replace
****************************************
* END










****************************************
* Panel 2016 2020
****************************************
use"$wave2-_ego", clear

drop villageid_new_comments

append using "$wave3-_ego"
tab panel

order HHINDID HHID_panel INDID_panel year egoid name sex age jatis caste edulevel address villageid villageareaid villageid_new username panel

order dummydemonetisation demotrustneighborhood demotrustemployees_ego demotrustbank_ego demonetworkpeoplehelping_ego demonetworkhelpkinmember_ego demogeneralperception demogoodexpectations demobadexpectations covsick, after(panel)

order curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking, after(covsick)

sort HHID_panel INDID_panel year

*Clean year
clonevar time=year
recode time (2016=1) (2020=2)
label define time 1"2016" 2"2020"
label values time time

save"panel_stab_v1", replace
****************************************
* END












****************************************
* Panel 2016 2020
****************************************
use"panel_stab_v1", clear

global big5 curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm 

global big5grit curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking





********** Recode 1: replace 99 with missing
foreach x in $big5grit {
clonevar `x'_recode=`x'
replace `x'_recode=. if `x'_recode==99 | `x'_recode==6
}







********** Recode 2: all so that more is better! 
foreach x of varlist $big5grit {
clonevar `x'_rec_rev=`x'_recode 
recode `x'_rec_rev (5=1) (4=2) (3=3) (2=4) (1=5)
recode `x'_rec_rev (5=1) (4=2) (3=3) (2=4) (1=5)
}

label define big5n 1"5 - Almost never" 2"4 - Rarely" 3"3 - Sometimes" 4"2 - Quite often" 5"1 - Almost always"
foreach x in $big5grit {
label values `x'_rec_rev big5n
}






********** Passe-passe pour travailler
foreach x in $big5grit {
rename `x' `x'_backup 
rename `x'_rec_rev `x'
}







********** Check missings
foreach x in $big5grit {
forvalues i=16(4)20 {
mdesc `x' if year==20`i'
}
}







********** Imputation for missings
fre sex
fre caste
foreach x in $big5grit{
clonevar im`x'=`x'
}

forvalues i=1(1)2{
forvalues j=1(1)3{
forvalues k=16(4)20 {
foreach x in $big5grit{
sum im`x' if sex==`i' & caste==`j' & year==20`k'
replace im`x'=r(mean) if `x'==. & sex==`i' & caste==`j'  & year==20`k'
}
}
}
}







********** Acquiescence bias measure and correction
/*
Ca fonctionne par paire.
Il n'y a pas de biais, si chaque paire à une moyenne de 3:
- soit l'indiv a répondu une fois 5 et 1
- soit l'indiv a répondu une fois 4 et 2
- soit l'indiv a répondu deux fois 3

Donc plus simplement, pour mesurer le biais moyen, par individu, nous faisons la moyenne de toutes les questions. 
Plus on s'éloigne de 3, plus le biais est important.

Cependant, il ne faut pas oublier que 3 fait office de valeur tranchante : 1 et 2 sont assez similaires, 3 est neutre et 4 et 5 sont assez similaires.
Donc un individu qui répondu 5 et 2 n'a pas vraiment de biais (ou alors 1 et 4).
Si à l'une des questions, l'individu répond 3, le biais augmente, mais n'est pas non plus très grand car il reste neutre.

Le biais devient important lorsque l'individu répond deux choses allant dans le même sens : 1 et 2 (1 et 1, 2 et 2) ou 4 et 5 (4 et 4, 5 et 5).

Pour mieux voir, on retire 3 pour avoir comme base de comparaison 0 et on passe en val abs.

Symétrie à 3

Je calcul aussi le biais par trait de personnalité
*/

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
*Graph 
/*
set graph off
stripplot ars3, over(time) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle() ///
msymbol(oh oh oh) mcolor(plr1 plg1 ply1) 
*/
egen ars_AG_temp=rowmean(rudetoother helpfulwithothers)
egen ars_CO_temp=rowmean(putoffduties completeduties easilydistracted makeplans)
egen ars_EX_temp=rowmean(shywithpeople talktomanypeople)
egen ars_OP_temp=rowmean(repetitivetasks curious)
egen ars_ES_temp=rowmean(nervous staycalm worryalot managestress)

foreach x in AG CO EX OP ES {
gen ars_`x'=ars_`x'_temp-3
drop ars_`x'_temp
}

egen ars4=rowmean(ars_AG ars_CO ars_EX ars_OP ars_ES)
egen ars5=rowmedian(ars_AG ars_CO ars_EX ars_OP ars_ES)

*Stat
corr ars_AG ars_CO ars_EX ars_OP ars_ES if year==2016
corr ars_AG ars_CO ars_EX ars_OP ars_ES if year==2020
tabstat ars3, stat(n min p1 p5 p10 q p90 p95 p99 max) by(year) long



********** Recode 3: Reverse coded les items reverses pour que tu sois dans le même sens dans un seul et même trait: que les var tendent vers le traits pour lequel elles ont été posées

foreach x in $big5grit {
clonevar `x'_rec_rev=`x'
}
foreach x of varlist rudetoother putoffduties easilydistracted shywithpeople repetitive~s nervous changemood feeldepressed easilyupset worryalot {
recode `x' (5=1) (4=2) (3=3) (2=4) (1=5)
}
label define big5n2 5"5 - Almost never" 4"4 - Rarely" 3"3 - Sometimes" 2"2 - Quite often" 1"1 - Almost always"
foreach x in rudetoother putoffduties easilydistracted shywithpeople repetitive~s nervous changemood feeldepressed easilyupset worryalot {
label values `x' big5n2
}






********** Correlation between questions of each trait
preserve
keep if year==2020
pwcorr curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination, star(.05)
pwcorr organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties, star(.05)
pwcorr enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts, star(.05)
pwcorr workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers, star(.05)
pwcorr managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm, star(.05)
restore






*********** Vérifier l'écart entre le biais moyen et le biais par trait
foreach x in AG CO EX OP ES {
gen `x'_diff=ars_`x'-ars2
}

tabstat AG_diff CO_diff EX_diff OP_diff ES_diff, stat(n mean cv p50 min max) by(year)

preserve
keep if year==2020
order ars_AG ars_CO ars_EX ars_OP ars_ES
sort ars_AG
restore





********** Recode 4: corr from acquiescence bias
foreach x of varlist $big5grit {
gen cr_`x'=`x'-ars2 if ars!=.
gen cr1_`x'=`x' if ars!=.
gen cr2_`x'=.
gen cr4_`x'=`x'-ars4 if ars!=.
gen cr5_`x'=`x'-ars5 if ars!=.
}

foreach x of varlist $big5grit {
replace cr1_`x'=`x'-ars2 if ars!=. & ars3>=1
}
foreach x in curious interestedbyart  repetitivetasks inventive liketothink newideas activeimagination {
replace cr2_`x'=`x'-ars_OP if ars!=.
}
foreach x in organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties {
replace cr2_`x'=`x'-ars_CO if ars!=.
}
foreach x in enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts {
replace cr2_`x'=`x'-ars_EX if ars!=.
}
foreach x in workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers {
replace cr2_`x'=`x'-ars_AG if ars!=.
}
foreach x in managestress nervous changemood feeldepressed easilyupset worryalot staycalm {
replace cr2_`x'=`x'-ars_ES if ars!=.
}

foreach x of varlist $big5grit {
replace cr2_`x'=0 if cr2_`x'<0
}






********** Bon, il faut que je procède avec les cr classiques je pense
/*
Sauf que, lorsque je corrige, les omega sautent
Il faut donc que je regarde qui sont ceux qui me font tout sauter
Ce sont ceux qui ont les plus grands écarts entre cr et non corrigés
Donc ceux qui ont le biais le plus élevés ?
*/




********** Test omega imput

preserve
keep if year==2020
keep if panel==1

***OP
omega curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination, rev(repetitivetasks)
omega cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination, rev(cr_repetitivetasks) 
omega cr1_curious cr1_interestedbyart cr1_repetitivetasks cr1_inventive cr1_liketothink cr1_newideas cr1_activeimagination, rev(cr1_repetitivetasks) 
omega cr2_curious cr2_interestedbyart cr2_repetitivetasks cr2_inventive cr2_liketothink cr2_newideas cr2_activeimagination, rev(cr2_repetitivetasks) 

***CO
omega organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties, rev(putoffduties easilydistracted)
omega cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties, rev(cr_putoffduties cr_easilydistracted) 
omega cr1_organized cr1_makeplans cr1_workhard cr1_appointmentontime cr1_putoffduties cr1_easilydistracted cr1_completeduties, rev(cr1_putoffduties cr1_easilydistracted) 
omega cr2_organized cr2_makeplans cr2_workhard cr2_appointmentontime cr2_putoffduties cr2_easilydistracted cr2_completeduties, rev(cr2_putoffduties cr2_easilydistracted) 

***EX
omega enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts, rev(shywithpeople) 
omega cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts, rev(cr_shywithpeople) 
omega cr1_enjoypeople cr1_sharefeelings cr1_shywithpeople cr1_enthusiastic cr1_talktomanypeople cr1_talkative cr1_expressingthoughts, rev(cr1_shywithpeople) 
omega cr2_enjoypeople cr2_sharefeelings cr2_shywithpeople cr2_enthusiastic cr2_talktomanypeople cr2_talkative cr2_expressingthoughts, rev(cr2_shywithpeople) 

***AG
omega workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers, rev(rudetoother) 
omega cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers, rev(cr_rudetoother) 
omega cr1_workwithother cr1_understandotherfeeling cr1_trustingofother cr1_rudetoother cr1_toleratefaults cr1_forgiveother cr1_helpfulwithothers, rev(cr1_rudetoother) 
omega cr2_workwithother cr2_understandotherfeeling cr2_trustingofother cr2_rudetoother cr2_toleratefaults cr2_forgiveother cr2_helpfulwithothers, rev(cr2_rudetoother) 

***ES
omega managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm, rev(managestress staycalm) 
omega cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot  cr_staycalm, rev(cr_managestress cr_staycalm)  
omega cr1_managestress cr1_nervous cr1_changemood cr1_feeldepressed cr1_easilyupset cr1_worryalot  cr1_staycalm, rev(cr1_managestress cr1_staycalm)  
omega cr2_managestress cr2_nervous cr2_changemood cr2_feeldepressed cr2_easilyupset cr2_worryalot  cr2_staycalm, rev(cr2_managestress cr2_staycalm)  
restore





********** Big5 taxonomy
egen OP = rowmean(curious interestedbyart  repetitivetasks inventive liketothink newideas activeimagination)
egen CO = rowmean(organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties) 
egen EX = rowmean(enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts) 
egen AG = rowmean(workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers) 
egen ES = rowmean(managestress nervous changemood feeldepressed easilyupset worryalot staycalm) 
egen Grit = rowmean(tryhard stickwithgoals  goaftergoal finishwhat~n finishtasks keepworking)

egen cr_OP = rowmean(cr_curious cr_interested~t   cr_repetitive~s cr_inventive cr_liketothink cr_newideas cr_activeimag~n)
egen cr_CO = rowmean(cr_organized  cr_makeplans cr_workhard cr_appointmen~e cr_putoffduties cr_easilydist~d cr_completedu~s) 
egen cr_EX = rowmean(cr_enjoypeople cr_sharefeeli~s cr_shywithpeo~e  cr_enthusiastic  cr_talktomany~e  cr_talkative cr_expressing~s ) 
egen cr_AG = rowmean(cr_workwithot~r   cr_understand~g cr_trustingof~r cr_rudetoother cr_toleratefa~s  cr_forgiveother  cr_helpfulwit~s) 
egen cr_ES = rowmean(cr_managestress  cr_nervous  cr_changemood cr_feeldepres~d cr_easilyupset cr_worryalot  cr_staycalm) 
egen cr_Grit = rowmean(cr_tryhard  cr_stickwithg~s   cr_goaftergoal cr_finishwhat~n cr_finishtasks  cr_keepworking)

egen cr1_OP = rowmean(cr1_curious cr1_interested~t   cr1_repetitive~s cr1_inventive cr1_liketothink cr1_newideas cr1_activeimag~n)
egen cr1_CO = rowmean(cr1_organized  cr1_makeplans cr1_workhard cr1_appointmen~e cr1_putoffduties cr1_easilydist~d cr1_completedu~s) 
egen cr1_EX = rowmean(cr1_enjoypeople cr1_sharefeeli~s cr1_shywithpeo~e  cr1_enthusiastic  cr1_talktomany~e  cr1_talkative cr1_expressing~s ) 
egen cr1_AG = rowmean(cr1_workwithot~r   cr1_understand~g cr1_trustingof~r cr1_rudetoother cr1_toleratefa~s  cr1_forgiveother  cr1_helpfulwit~s) 
egen cr1_ES = rowmean(cr1_managestress  cr1_nervous  cr1_changemood cr1_feeldepres~d cr1_easilyupset cr1_worryalot  cr1_staycalm) 
egen cr1_Grit = rowmean(cr1_tryhard  cr1_stickwithg~s   cr1_goaftergoal cr1_finishwhat~n cr1_finishtasks  cr1_keepworking)

egen cr2_OP = rowmean(cr2_curious cr2_interested~t   cr2_repetitive~s cr2_inventive cr2_liketothink cr2_newideas cr2_activeimag~n)
egen cr2_CO = rowmean(cr2_organized  cr2_makeplans cr2_workhard cr2_appointmen~e cr2_putoffduties cr2_easilydist~d cr2_completedu~s) 
egen cr2_EX = rowmean(cr2_enjoypeople cr2_sharefeeli~s cr2_shywithpeo~e  cr2_enthusiastic  cr2_talktomany~e  cr2_talkative cr2_expressing~s ) 
egen cr2_AG = rowmean(cr2_workwithot~r   cr2_understand~g cr2_trustingof~r cr2_rudetoother cr2_toleratefa~s  cr2_forgiveother  cr2_helpfulwit~s) 
egen cr2_ES = rowmean(cr2_managestress  cr2_nervous  cr2_changemood cr2_feeldepres~d cr2_easilyupset cr2_worryalot  cr2_staycalm) 
egen cr2_Grit = rowmean(cr2_tryhard  cr2_stickwithg~s   cr2_goaftergoal cr2_finishwhat~n cr2_finishtasks  cr2_keepworking)

save"panel_stab_v2", replace
****************************************
* END







****************************************
* Verif des scores corrigés selon la correction effectuée
****************************************
use"panel_stab_v2", clear
cls
foreach x in OP CO EX ES AG {
tabstat `x' cr_`x' cr1_`x' cr2_`x', stat(n mean cv p50 min max) by(year)
}

save"panel_stab_v2", replace
****************************************
* END







****************************************
* INTERNAL CONSISTENCY
****************************************
use"panel_stab_v2.dta", clear

sort ars3

*Bias
gen indiv_biased=0
replace indiv_biased=1 if ars3>=1

preserve
fre panel
keep if panel==1
tab indiv_biased year
restore




********** Omega values real
/*
forvalues i=1(1)2{
putexcel set "Desc.xlsx", modify sheet(omega_`i')
preserve
keep if year==`i'
***OP
omega curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination, rev(repetitivetasks)
putexcel (C2)=matrix(r(omega))
omega cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination, rev(cr_repetitivetasks) 
putexcel (C3)=matrix(r(omega))
***CO
omega organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties, rev(putoffduties easilydistracted)
putexcel (C4)=matrix(r(omega))
omega cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties, rev(cr_putoffduties cr_easilydistracted) 
putexcel (C5)=matrix(r(omega))
***EX
omega enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts, rev(shywithpeople) 
putexcel (C6)=matrix(r(omega))
omega cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts, rev(cr_shywithpeople) 
putexcel (C7)=matrix(r(omega))
***AG
omega workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers, rev(rudetoother) 
putexcel (C8)=matrix(r(omega))
omega cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers, rev(cr_rudetoother) 
putexcel (C9)=matrix(r(omega))
***ES
omega managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm, rev(managestress staycalm) 
putexcel (C10)=matrix(r(omega))
omega cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot  cr_staycalm, rev(cr_managestress cr_staycalm)  
putexcel (C11)=matrix(r(omega))
***Grit
omega tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking
putexcel (C12)=matrix(r(omega))
omega cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking
putexcel (C13)=matrix(r(omega))
restore
}
*/


********** Excel to dta
/*
import excel "D:\Documents\_Thesis\Research-Stability_skills\Analysis\Desc.xlsx", sheet("omega_tot") firstrow clear


*Sample
replace sample="1" if sample=="panel"
replace sample="2" if sample=="total"
destring sample, replace
label define sample 1"panel" 2"total"
label values sample sample

*Traits
replace traits="1" if traits=="OP"
replace traits="2" if traits=="CO"
replace traits="3" if traits=="EX"
replace traits="4" if traits=="AG"
replace traits="5" if traits=="ES"
replace traits="6" if traits=="Grit"
destring traits, replace
label define traits 1"OP" 2"CO" 3"EX" 4"AG" 5"ES" 6"Grit"
label values traits traits

*correction
label define correction 0"No corr" 1"Corr"
label values correction correction

*rename
rename year2016 omega2016
rename year2020 omega2020

*Newbar
foreach x in sample traits correction {
decode `x', gen(`x'_str)
}
egen unique=concat(sample_str traits_str correction_str), p(_)
reshape long omega, i(unique) j(year)
drop unique sample_str traits_str correction_str


save "omega", replace
*/



********** Graph
use"omega", clear

preserve
fre sample
keep if sample==1
graph bar omega, over(correction) over(year) over(traits) blabel(bar, format(%4.2f) size(tiny)) 
restore

preserve
fre sample
keep if sample==2
graph bar omega, over(correction) over(year) over(traits) blabel(bar, format(%4.2f) size(tiny)) 
restore

****************************************
* END

