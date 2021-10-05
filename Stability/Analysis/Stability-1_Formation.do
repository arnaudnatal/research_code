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
recode year (2016=1) (2020=2)
label define year 1"2016" 2"2020"
label values year year

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
tabstat ars3, stat(n mean sd p50 min max) by(year)
*Graph 
set graph off
stripplot ars3, over(year) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.2)1.6) ymtick(0(.1)1.7) ytitle() ///
msymbol(oh oh oh) mcolor(plr1 plg1 ply1) 




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




********** Recode 4: corr from acquiescence bias
foreach x of varlist $big5grit {
gen cr_`x'=`x'-ars2 if ars!=. 
}


********** Big5 taxonomy
egen cr_OP = rowmean(cr_curious cr_interested~t   cr_repetitive~s cr_inventive cr_liketothink cr_newideas cr_activeimag~n)
egen cr_CO = rowmean(cr_organized  cr_makeplans cr_workhard cr_appointmen~e cr_putoffduties cr_easilydist~d cr_completedu~s) 
egen cr_EX = rowmean(cr_enjoypeople cr_sharefeeli~s cr_shywithpeo~e  cr_enthusiastic  cr_talktomany~e  cr_talkative cr_expressing~s ) 
egen cr_AG = rowmean(cr_workwithot~r   cr_understand~g cr_trustingof~r cr_rudetoother cr_toleratefa~s  cr_forgiveother  cr_helpfulwit~s) 
egen cr_ES = rowmean(cr_managestress  cr_nervous  cr_changemood cr_feeldepres~d cr_easilyupset cr_worryalot  cr_staycalm) 
egen cr_Grit = rowmean(cr_tryhard  cr_stickwithg~s   cr_goaftergoal cr_finishwhat~n cr_finishtasks  cr_keepworking)

egen OP = rowmean(curious interestedbyart  repetitivetasks inventive liketothink newideas activeimagination)
egen CO = rowmean(organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties) 
egen EX = rowmean(enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts) 
egen AG = rowmean(workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers) 
egen ES = rowmean(managestress nervous changemood feeldepressed easilyupset worryalot staycalm) 
egen Grit = rowmean(tryhard stickwithgoals  goaftergoal finishwhat~n finishtasks keepworking)



/*
********** IMPUTATION pour les missings
foreach x in $big5rr{
gen im`x'=`x'
}
forvalues j=1(1)3{
forvalues i=1(1)2{
foreach x in $big5rr{
sum im`x' if sex==`i' & caste==`j' & egoid!=0 & egoid!=.
replace im`x'=r(mean) if `x'==. & sex==`i' & caste==`j' & egoid!=0 & egoid!=.
}
}
}
*/



save"panel_stab_v2", replace
****************************************
* END















****************************************
* INTERNAL CONSISTENCY
****************************************
use"panel_stab_v2.dta", clear


********** Omega values
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

