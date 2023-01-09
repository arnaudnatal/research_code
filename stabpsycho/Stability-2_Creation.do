*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*April 23, 2021
*-----
gl link = "stabpsycho"
*Stab
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------





****************************************
* Panel 2016 2020
****************************************
use"panel_stab_v1", clear

global big5grit curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination ///
organized  makeplans workhard appointmentontime putoffduties easilydistracted completeduties ///
enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople  talkative expressingthoughts  ///
workwithother  understandotherfeeling trustingofother rudetoother toleratefaults  forgiveother  helpfulwithothers ///
managestress  nervous  changemood feeldepressed easilyupset worryalot  staycalm ///
tryhard  stickwithgoals   goaftergoal finishwhatbegin finishtasks  keepworking


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



********** Big5 taxonomy
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
*keep if panel==1

drop HHID2016 INDID2016 HHID2020 INDID2020

save"panel_stab_v3", replace

***
reshape wide HHID_panel INDID_panel egoid name sex age jatis caste edulevel villageid username panel dummydemonetisation relationshiptohead maritalstatus aspirationminimumwage dummyaspirationmorehours aspirationminimumwage2 canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 numeracy5 numeracy6 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 annualincome_indiv annualincome_HH mainocc_occupation_indiv assets_total1000 assets_totalnoland1000 ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt time curious interestedbyart repetitivetasks inventive liketothink newideas activeimagination organized makeplans workhard appointmentontime putoffduties easilydistracted completeduties enjoypeople sharefeelings shywithpeople enthusiastic talktomanypeople talkative expressingthoughts workwithother understandotherfeeling trustingofother rudetoother toleratefaults forgiveother helpfulwithothers managestress nervous changemood feeldepressed easilyupset worryalot staycalm tryhard stickwithgoals goaftergoal finishwhatbegin finishtasks keepworking ars ars2 ars3 cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit  username_backup username_2016 username_2020 username_2016_code username_2020_code edulevel_backup submissiondate HHsize typeoffamily dummyexposure dummysell villagename villagename2016_club, i(HHINDID) j(year)

********** Cleaning
*** ID
drop HHID_panel2020 INDID_panel2020
rename HHID_panel2016 HHID_panel
rename INDID_panel2016 INDID_panel

save"panel_stab_v2_wide", replace
****************************************
* END
