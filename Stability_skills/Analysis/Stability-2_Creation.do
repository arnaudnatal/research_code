cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
October 1, 2021
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
set scheme plotplain

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




/*
Commencer par aborder le questionnaire
Puis la méthode de correction du biais d'acquiesement
Ca marche super bien pour 2016, mais pas pour 2020
Sauf pour ES, donc ES on va pouvoir regarder la stabilité dans le temps en corr
Pq est-ce que le biais est fort ? Enquêteur ? Caste ? Sexe ? Age ? Education ? Proximité au choc ?


Regarder stabilité
*/






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

********* Rename _backup 
foreach x in $big5grit {
rename `x' `x'_bkcl
rename `x'_backup `x'
}



********* Rename old cr to check if new cr is good
foreach x in cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking {
rename `x' `x'_bkcl
}


********** Recode 1: replace 99 with missing
foreach x in $big5grit {
replace `x'=. if `x'==99 | `x'==6
}





********** Recode 2: all so that more is better! 
foreach x of varlist $big5grit {
recode `x' (5=1) (4=2) (3=3) (2=4) (1=5)
}

label define big5n 1"5 - Almost never" 2"4 - Rarely" 3"3 - Sometimes" 4"2 - Quite often" 5"1 - Almost always", replace
foreach x in $big5grit {
label values `x' big5n
}






********** Check missings
forvalues i=16(4)20 {
mdesc $big5grit if year==20`i'
}

mdesc $big5grit if year==2020
mdesc rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
nervous staycalm ///  
worryalot managestress if year==2020







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

tabstat ars3, stat(n mean sd p50) by(year)
tabstat ars3 if panel==1, stat(n mean sd p50) by(year)

/*
Regarde la correction par groupe de question.
Ci-dessous l'ordre des questions avec les paires.

Idée de correction qui aurait du sens par rapport à la façon dont les questions sont posées :
Il y a une pause dans l'administration du questionnaire entre changemood et understandotherfeeling.
Donc il peut être intéressant de corriger le biais par groupe de question.
Pb: les reverses questions ne sont pas dans le même groupe, donc la moyenne n'a pas vraiment de sens........



enjoypeople 
curious (1+)
organized
managestress (6-)
interestedbyart
workwithother
makeplans (2+)
sharefeelings
nervous (7+)
repetitivetasks (1-)
shywithpeople (4-)
workhard
changemood

Total: 1(+-), 2(+), 3(), 4(-), 5(), 6(-), 7(+).

-----------------------------

understandotherfeeling
inventive
enthusiastic
feeldepressed
appointmentontime
trustingofother
easilyupset
talktomanypeople (4+)
liketothink
putoffduties (3-)
rudetoother (5-)
toleratefaults
worryalot (6+)
easilydistracted (2-)
completeduties (3+)
talkative
newideas
staycalm (7-)
forgiveother
activeimagination
expressingthoughts
helpfulwithothers (5+)

Total: 1(), 2(-), 3(+-), 4(+), 5(+-), 6(+), 7(-).
*/












********** Bias by dropping pairs of questions to check the stability of the mean
local var ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
nervous staycalm ///  
worryalot managestress 
egen _1_ars=rowmean(`var') 
gen _1_ars2=_1_ars-3  
gen _1_ars3=abs(_1_ars2)

local var ///
rudetoother helpfulwithothers  ///
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
nervous staycalm ///  
worryalot managestress 
egen _2_ars=rowmean(`var') 
gen _2_ars2=_2_ars-3  
gen _2_ars3=abs(_2_ars2)

local var ///
rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
nervous staycalm ///  
worryalot managestress 
egen _3_ars=rowmean(`var') 
gen _3_ars2=_3_ars-3  
gen _3_ars3=abs(_3_ars2)

local var ///
rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
repetitivetasks curious  ///
nervous staycalm ///  
worryalot managestress 
egen _4_ars=rowmean(`var') 
gen _4_ars2=_4_ars-3  
gen _4_ars3=abs(_4_ars2)

local var ///
rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
nervous staycalm ///  
worryalot managestress 
egen _5_ars=rowmean(`var') 
gen _5_ars2=_5_ars-3  
gen _5_ars3=abs(_5_ars2)

local var ///
rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
worryalot managestress 
egen _6_ars=rowmean(`var') 
gen _6_ars2=_6_ars-3  
gen _6_ars3=abs(_6_ars2)

local var ///
rudetoother helpfulwithothers  ///
putoffduties completeduties /// 
easilydistracted makeplans  ///
shywithpeople talktomanypeople ///
repetitivetasks curious  ///
nervous staycalm
egen _7_ars=rowmean(`var') 
gen _7_ars2=_7_ars-3  
gen _7_ars3=abs(_7_ars2)






********** Bias by trait
/*
We can also check a bias per Big-5 trait, but it is a non-sense with our data:
In the survey, questions to a certain traits are not asking in order.
Thus, the "bored bias per trait" does not exist.
*/


egen ars_AG_temp=rowmean(rudetoother helpfulwithothers)
egen ars_CO_temp=rowmean(putoffduties completeduties easilydistracted makeplans)
egen ars_EX_temp=rowmean(shywithpeople talktomanypeople)
egen ars_OP_temp=rowmean(repetitivetasks curious)
egen ars_ES_temp=rowmean(nervous staycalm worryalot managestress)

egen ars_CO1_temp=rowmean(putoffduties completeduties)
egen ars_CO2_temp=rowmean(easilydistracted makeplans)
egen ars_ES1_temp=rowmean(nervous staycalm)
egen ars_ES2_temp=rowmean(worryalot managestress)

foreach x in AG CO EX OP ES {
gen ars2_`x'=ars_`x'_temp-3
drop ars_`x'_temp
gen ars3_`x'=abs(ars2_`x')
}

/*
foreach x in CO ES {
forvalues i=1(1)2{
gen ars2_`x'`i'=ars_`x'`i'_temp-3
drop ars_`x'`i'_temp
gen ars3_`x'`i'=abs(ars2_`x'`i')
}
}

egen ars4=rowmean(ars2_AG ars2_CO ars2_EX ars2_OP ars2_ES)
egen ars5=rowmedian(ars2_AG ars2_CO ars2_EX ars2_OP ars2_ES)


label var _1_ars "bias at 3 without pair 1 of rev question"
label var _1_ars2 "bias at 0 without pair 1 of rev question"
label var _1_ars3 "abs bias at 0 without pair 1 of rev question"
label var _2_ars "bias at 3 without pair 2 of rev question"
label var _2_ars2 "bias at 0 without pair 2 of rev question"
label var _2_ars3 "abs bias at 0 without pair 2 of rev question"
label var _3_ars "bias at 3 without pair 3 of rev question"
label var _3_ars2 "bias at 0 without pair 3 of rev question"
label var _3_ars3 "abs bias at 0 without pair 3 of rev question"
label var _4_ars "bias at 3 without pair 4 of rev question"
label var _4_ars2 "bias at 0 without pair 4 of rev question"
label var _4_ars3 "abs bias at 0 without pair 4 of rev question"
label var _5_ars "bias at 3 without pair 5 of rev question"
label var _5_ars2 "bias at 0 without pair 5 of rev question"
label var _5_ars3 "abs bias at 0 without pair 5 of rev question"
label var _6_ars "bias at 3 without pair 6 of rev question"
label var _6_ars2 "bias at 0 without pair 6 of rev question"
label var _6_ars3 "abs bias at 0 without pair 6 of rev question"
label var _7_ars "bias at 3 without pair 7 of rev question"
label var _7_ars2 "bias at 0 without pair 7 of rev question"
label var _7_ars3 "abs bias at 0 without pair 7 of rev question"

label var ars2_AG "bias at 0 for AG"
label var ars3_AG "abs bias at 0 for AG"
label var ars2_CO "bias at 0 for CO"
label var ars3_CO "abs bias at 0 for CO"
label var ars2_EX "bias at 0 for EX"
label var ars3_EX "abs bias at 0 for EX"
label var ars2_OP "bias at 0 for OP"
label var ars3_OP "abs bias at 0 for OP"
label var ars2_ES "bias at 0 for ES"
label var ars3_ES "abs bias at 0 for ES"
label var ars2_CO1 "bias at 0 for CO1"
label var ars3_CO1 "abs bias at 0 for CO1"
label var ars2_CO2 "bias at 0 for CO2"
label var ars3_CO2 "abs bias at 0 for CO2"
label var ars2_ES1 "bias at 0 for ES1"
label var ars3_ES1 "abs bias at 0 for ES1"
label var ars2_ES2 "bias at 0 for ES2"
label var ars3_ES2 "abs bias at 0 for ES2"
label var ars4 "Mean bias of bias by traits"
label var ars5 "Median bias of bias by traits"
*/
label var ars "bias at 3"
label var ars2 "bias at 0"
label var ars3 "abs bias at 0"
 









********** Questions on bias
cls
forvalues i=1(1)7{
ttest ars3==_`i'_ars3 if year==2016
}
*pb avec 1 (AG)
cls
forvalues i=1(1)7{
ttest ars3==_`i'_ars3 if year==2020
}
*pb avec 3 (CO2), 5 (OP) et 7 (ES2)

/*
rudetoother helpfulwithothers  // _1_--> AG
putoffduties completeduties  // _2_--> CO1
easilydistracted makeplans  // _3_--> CO2
shywithpeople talktomanypeople  // _4_--> EX
repetitivetasks curious  // _5_--> OP
nervous staycalm  // _6_--> ES1
worryalot managestress  // _7_--> ES2
*/




********** Recode 3: Reverse coded les items reverses pour que tu sois dans le même sens dans un seul et même trait: que les var tendent vers le traits pour lequel elles ont été posées

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




********** Correlation
***2016
preserve
keep if year==2016
*OP
pwcorr curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination, star(.01)

*CO
pwcorr organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties, star(.01)

*EX
pwcorr enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts, star(.01)

*AG
pwcorr workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers, star(.01)

*ES
pwcorr managestress nervous changemood feeldepressed easilyupset worryalot  staycalm, star(.01)

*Grit
pwcorr tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking, star(.01)
restore

***2020
preserve
keep if year==2020
*OP
pwcorr curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination, star(.01)

*CO
pwcorr organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties, star(.01)

*EX
pwcorr enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts, star(.01)

*AG
pwcorr workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers, star(.01)

*ES
pwcorr managestress nervous changemood feeldepressed easilyupset worryalot  staycalm, star(.01)

*Grit
pwcorr tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking, star(.01)
restore












********** Test omega imput
/*
preserve
keep if year==2020
keep if panel==1
putexcel set "omega.xlsx", modify sheet(draft)

***OP
omega curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination, rev(repetitivetasks)
putexcel (E2)=matrix(r(omega))
omega cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination, rev(cr_repetitivetasks) 
putexcel (E3)=matrix(r(omega))
*omega cr2_curious cr2_interestedbyart cr2_repetitivetasks cr2_inventive cr2_liketothink cr2_newideas cr2_activeimagination, rev(cr2_repetitivetasks) 
*putexcel (E4)=matrix(r(omega))

***CO
omega organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties, rev(putoffduties easilydistracted)
putexcel (E4)=matrix(r(omega))
omega cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties, rev(cr_putoffduties cr_easilydistracted) 
putexcel (E5)=matrix(r(omega))
*omega cr2_organized cr2_makeplans cr2_workhard cr2_appointmentontime cr2_putoffduties cr2_easilydistracted cr2_completeduties, rev(cr2_putoffduties cr2_easilydistracted) 
*putexcel (E7)=matrix(r(omega))

***EX
omega enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts, rev(shywithpeople) 
putexcel (E6)=matrix(r(omega))
omega cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts, rev(cr_shywithpeople) 
putexcel (E7)=matrix(r(omega))
*omega cr2_enjoypeople cr2_sharefeelings cr2_shywithpeople cr2_enthusiastic cr2_talktomanypeople cr2_talkative cr2_expressingthoughts, rev(cr2_shywithpeople) 
*putexcel (E10)=matrix(r(omega))

***AG
*alpha workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers
omega workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers, rev(rudetoother) 
putexcel (E8)=matrix(r(omega))
omega cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers, rev(cr_rudetoother) 
putexcel (E9)=matrix(r(omega))
*omega cr2_workwithother cr2_understandotherfeeling cr2_trustingofother cr2_rudetoother cr2_toleratefaults cr2_forgiveother cr2_helpfulwithothers, rev(cr2_rudetoother) 
*putexcel (E13)=matrix(r(omega))

***ES
omega managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm, rev(managestress staycalm) 
putexcel (E10)=matrix(r(omega))
omega cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot  cr_staycalm, rev(cr_managestress cr_staycalm)  
putexcel (E11)=matrix(r(omega))
*omega cr2_managestress cr2_nervous cr2_changemood cr2_feeldepressed cr2_easilyupset cr2_worryalot  cr2_staycalm, rev(cr2_managestress cr2_staycalm)  
*putexcel (E16)=matrix(r(omega))

*** Grit
omega tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking
putexcel (E12)=matrix(r(omega))
omega cr_tryhard  cr_stickwithgoals  cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking
putexcel (E13)=matrix(r(omega))
restore
*/




********** Omega as data
preserve
clear all

/*
input 

end
*/

import delimited "omega.csv", delimiter(";") varnames(1) clear 
rename corrected correction
label define panel 0"No panel" 1"Panel" 2"All"
label define correction 0"Raw" 1"Corrected", modify
label define alpha 0"Omega" 1"Alpha"
label values panel panel
label values correction correction
label values alpha alpha
*
replace traits="1" if traits=="OP"
replace traits="2" if traits=="CO"
replace traits="3" if traits=="EX"
replace traits="4" if traits=="AG"
replace traits="5" if traits=="ES"
replace traits="6" if traits=="Grit"
destring traits, replace
label define traits 1"OP" 2"CO" 3"EX" 4"AG" 5"ES" 6"Grit"
label values traits traits



set graph off
graph bar omega if panel==0, over(correction) over(year, gap(100)) over(traits) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
ytitle("McDonald's ω") ylabel(0(.1)1) ymtick(0(.05)1) ///
note("Individuals not in panel." "2016: n=118" "2020: n=826", size(vsmall)) ///
legend(pos(6) col(3))
graph export omega_notpanel.pdf, replace

*graph bar omega if panel==1, over(correction) over(year, gap(100)) over(traits) ///
*bar(1, fcolor(plr1) lcolor(plr1)) ///
*bar(2, fcolor(ply1) lcolor(ply1)) ///
*bar(3, fcolor(plg1) lcolor(plg1)) ///
*bargap(0) intensity(inten30) ///
*ytitle("McDonald's ω") ylabel(0(.1)1) ymtick(0(.05)1) ///
*note("Individuals in panel." "2016: n=835" "2020: n=835", size(vsmall)) ///
*legend(pos(6) col(3))

*graph bar omega if panel==1 & correction==1, over(year) over(traits) ///
*blabel(total, position(inside) format(%4.2f) size(2)) ///
*ytitle("McDonald's ω") ylabel(0(.1)1) ymtick(0(.05)1) ///
*note("2016: n=835" "2020: n=835", size(vsmall)) ///
*legend(pos(6) col(3))

graph bar omega if panel==1 & correction==1, over(year) over(traits) ///
ytitle("McDonald's ω") ylabel(0(.1)1) ymtick(0(.05)1) ///
note("2016: n=835" "2020: n=835", size(vsmall)) ///
legend(pos(6) col(3))
graph export omega_panel.pdf, replace


graph bar omega if panel==2, over(correction) over(year, gap(100)) over(traits) ///
bar(1, fcolor(plr1) lcolor(plr1)) ///
bar(2, fcolor(ply1) lcolor(ply1)) ///
bar(3, fcolor(plg1) lcolor(plg1)) ///
bargap(0) intensity(inten30) ///
ytitle("McDonald's ω") ylabel(0(.1)1) ymtick(0(.05)1) ///
note("All individuals." "2016: n=953" "2020: n=1661", size(vsmall)) ///
legend(pos(6) col(3))
graph export omega_all.pdf, replace
restore
*/





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
egen cr_Grit = rowmean(cr_tryhard  cr_stickwithgoals   cr_goaftergoal cr_finishwhatbegin cr_finishtasks  cr_keepworking)





********** username
tab username if year==2016
tab username if year==2020
clonevar username_backup=username
replace username="Antoni" if username=="Antoni - Vivek Radja"
replace username="Kumaresh" if username=="Kumaresh - Raja Annamalai"
replace username="Kumaresh" if username=="Kumaresh - Sithanantham"
replace username="Raja Annamalai" if username=="Mayan - Raja Annamalai"
replace username="Raja Annamalai" if username=="Raja Annamalai - Pazhani"
replace username="Raja Annamalai" if username=="Sithanantham - Raja Annamalai"
replace username="Raja Annamalai" if username=="Vivek Radja - Raja Annamalai"
replace username="Mayan" if username=="Vivek Radja - Mayan"

clonevar username_2016=username
replace username_2016="" if year==2020

clonevar username_2020=username
replace username_2020="" if year==2016

encode username_2016, gen(username_2016_code)
encode username_2020, gen(username_2020_code)

fre username_2016_code username_2020_code


********** edulevel
fre edulevel
ta edulevel year, m col nofreq
clonevar edulevel_backup=edulevel
recode edulevel (5=4) (.=0)
tab edulevel year, m col nofreq


save"panel_stab_v2", replace
****************************************
* END







****************************************
* RESHAPE
****************************************
use"panel_stab_v2", clear
keep if panel==1

drop curious_bkcl interestedbyart_bkcl repetitivetasks_bkcl inventive_bkcl liketothink_bkcl newideas_bkcl activeimagination_bkcl organized_bkcl makeplans_bkcl workhard_bkcl appointmentontime_bkcl putoffduties_bkcl easilydistracted_bkcl completeduties_bkcl enjoypeople_bkcl sharefeelings_bkcl shywithpeople_bkcl enthusiastic_bkcl talktomanypeople_bkcl talkative_bkcl expressingthoughts_bkcl workwithother_bkcl understandotherfeeling_bkcl trustingofother_bkcl rudetoother_bkcl toleratefaults_bkcl forgiveother_bkcl helpfulwithothers_bkcl managestress_bkcl nervous_bkcl changemood_bkcl feeldepressed_bkcl easilyupset_bkcl worryalot_bkcl staycalm_bkcl tryhard_bkcl stickwithgoals_bkcl goaftergoal_bkcl finishwhatbegin_bkcl finishtasks_bkcl keepworking_bkcl cr_curious_bkcl cr_interestedbyart_bkcl cr_repetitivetasks_bkcl cr_inventive_bkcl cr_liketothink_bkcl cr_newideas_bkcl cr_activeimagination_bkcl cr_organized_bkcl cr_makeplans_bkcl cr_workhard_bkcl cr_appointmentontime_bkcl cr_putoffduties_bkcl cr_easilydistracted_bkcl cr_completeduties_bkcl cr_enjoypeople_bkcl cr_sharefeelings_bkcl cr_shywithpeople_bkcl cr_enthusiastic_bkcl cr_talktomanypeople_bkcl cr_talkative_bkcl cr_expressingthoughts_bkcl cr_workwithother_bkcl cr_understandotherfeeling_bkcl cr_trustingofother_bkcl cr_rudetoother_bkcl cr_toleratefaults_bkcl cr_forgiveother_bkcl cr_helpfulwithothers_bkcl cr_managestress_bkcl cr_nervous_bkcl cr_changemood_bkcl cr_feeldepressed_bkcl cr_easilyupset_bkcl cr_worryalot_bkcl cr_staycalm_bkcl cr_tryhard_bkcl cr_stickwithgoals_bkcl cr_goaftergoal_bkcl cr_finishwhatbegin_bkcl cr_finishtasks_bkcl cr_keepworking_bkcl ars_CO1_temp ars_CO2_temp ars_ES1_temp ars_ES2_temp

reshape wide HHID_panel INDID_panel egoid name sex age jatis caste edulevel villageid villageareaid villageid_new username panel dummydemonetisation relationshiptohead maritalstatus canread everattendedschool reasonneverattendedschool converseinenglish house housetype electricity water toiletfacility noowntoilet readystartjob aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 nbercontactphone nberpersonfamilyevent contactlist dummycontactleaders contactleaders trustneighborhood trustemployees networkpeoplehelping networkhelpkinmember demotrustneighborhood demotrustemployees_ego demotrustbank_ego demonetworkpeoplehelping_ego demonetworkhelpkinmember_ego canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 demogeneralperception demogoodexpectations demobadexpectations annualincome_indiv annualincome_HH mainocc_kindofwork_indiv mainocc_occupation_indiv assets ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt covsellland covsubsistence covsick time curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking ars ars2 ars3 _1_ars _1_ars2 _1_ars3 _2_ars _2_ars2 _2_ars3 _3_ars _3_ars2 _3_ars3 _4_ars _4_ars2 _4_ars3 _5_ars _5_ars2 _5_ars3 _6_ars _6_ars2 _6_ars3 _7_ars _7_ars2 _7_ars3 cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking OP CO EX AG ES Grit cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit  username_backup username_2016 username_2020 username_2016_code username_2020_code edulevel_backup ars2_AG ars3_AG ars2_CO ars2_EX ars2_ES ars2_OP ars3_CO ars3_EX ars3_OP ars3_ES healthexpenses dummymarriage, i(HHINDID) j(year)

********** Cleaning
*** ID
drop HHID_panel2020 INDID_panel2020
rename HHID_panel2016 HHID_panel
rename INDID_panel2016 INDID_panel

*** Characteristics
* Age, sex, name, caste, 
replace age2020=age2016+4 if age2020==.
drop name2020 sex2020 caste2020 jatis2020
rename name2016 name
rename sex2016 sex
rename caste2016 caste
rename jatis2016 jatis


save"panel_stab_v2_wide", replace
****************************************
* END
