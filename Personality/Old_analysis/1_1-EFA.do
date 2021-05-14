*Arnaud NATAL, University of Bordeaux, 20/10/2020
*Debt, institutions and individuals
clear all
global name "anatal"

global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"


***************************************
* FACTOR ANALYSIS FOR BIG FIVE
****************************************
use "$directory\_temp\NEEMSIS-ego.dta", clear

global big5 ///
cr_curious cr_interestedbyart   cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination ///
cr_organized  cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties ///
cr_enjoypeople cr_sharefeelings cr_shywithpeople  cr_enthusiastic  cr_talktomanypeople  cr_talkative cr_expressingthoughts  ///
cr_workwithother  cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults  cr_forgiveother  cr_helpfulwithothers ///
cr_managestress  cr_nervous  cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot  cr_staycalm

**************Et si je remplace juste pour les moyennes ?
gen nmiss=0
foreach x in $big5{
replace nmiss=nmiss+1 if `x'==.
}
tab nmiss


foreach x in $big5{
gen im`x'=`x'
}
global big5i imcr_curious imcr_interestedbyart imcr_repetitivetasks imcr_inventive imcr_liketothink imcr_newideas imcr_activeimagination ///
imcr_organized imcr_makeplans imcr_workhard imcr_appointmentontime imcr_putoffduties imcr_easilydistracted imcr_completeduties ///
imcr_enjoypeople imcr_sharefeelings imcr_shywithpeople imcr_enthusiastic imcr_talktomanypeople imcr_talkative imcr_expressingthoughts ///
imcr_workwithother imcr_understandotherfeeling imcr_trustingofother imcr_rudetoother imcr_toleratefaults imcr_forgiveother ///
imcr_helpfulwithothers imcr_managestress imcr_nervous imcr_changemood imcr_feeldepressed imcr_easilyupset imcr_worryalot imcr_staycalm
*Imputation par la moyenne du sexe car assez grande différence entre les deux
forvalues i=1(1)2{
foreach x in $big5i{
sum `x' if sex==`i'
replace `x'=r(mean) if `x'==. & sex==`i'
}
}


/*
preserve
*minap $big5 // 8 with kaiser (eigen higher than 1), 5 with another one
factor $big5, pcf fa(5)
*screeplot, neigen(10) yline(1) ylabel(1[1]10) xlabel(1[1]10) 
*loadingplot, legend(off) xline(0) yline(0) scale(.8)
*scoreplot
rotate, promax
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput0)
*putexcel (E2) = matrix( e(r_L) )
qui predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5  
fsum $factor
*pwcorr $factor $big5, star(.01)
restore


preserve
keep if nmiss<=3
factor $big5i, pcf fa(5)
rotate, promax 
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput1)
*putexcel (E2) = matrix( e(r_L) )  
predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5
sum $factor
restore

preserve
keep if nmiss<=7
factor $big5i, pcf fa(5)
rotate, promax
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput2)
*putexcel (E2) = matrix( e(r_L) )
predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5
sum $factor
restore

preserve
keep if nmiss<=9
factor $big5i, pcf fa(5)
rotate, promax
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput3)
*putexcel (E2) = matrix( e(r_L) )
predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5
sum $factor
restore
*/

*preserve
keep if nmiss<=35
factor $big5i, pcf fa(5)
rotate, promax 
*screeplot, neigen(10) yline(1) ylabel(1[1]10) xlabel(1[1]10) 
*loadingplot, legend(off) xline(0) yline(0) scale(.8)
*scoreplot
*putexcel set "$directory\_temp\STAT.xlsx", modify sheet(imput4)
*putexcel (E2) = matrix( e(r_L) ) 
predict f1 f2 f3 f4 f5
global factor f1 f2 f3 f4 f5
sum $factor
sum $big5, sep(50)
sum $big5i, sep(50)
global naivebig5 EGOcrOP EGOcrEX EGOcrES EGOcrCO EGOcrAG
pwcorr $naivebig5 $factor, star(.01)
*restore

rename f1 new_CO
rename f2 new_ES
rename f3 new_OPEX
rename f4 new_ESCO
rename f5 new_AG






/*

*********************************POST ESTIMATION

*Cronbach's alpha for new categorization
*CO -> 0.8881
alpha cr_makeplans cr_appoint~e cr_enthusi~c cr_organized cr_workhard cr_complet~s cr_putoffd~s cr_inventive cr_workwit~r cr_repetit~s cr_easilyd~d cr_changem~d cr_newideas cr_curious cr_enjoype~e cr_liketot~k cr_activei~n cr_nervous cr_manages~s cr_worryalot cr_talkative cr_helpful~s cr_rudetoo~r cr_feeldep~d cr_shywith~e cr_sharefe~s cr_trustin~r cr_interes~t cr_easilyu~t cr_staycalm
*ES -> 0.8827
alpha cr_easilyu~t cr_nervous cr_worryalot cr_feeldep~d cr_easilyd~d cr_changem~d cr_shywith~e cr_putoffd~s cr_rudetoo~r cr_appoint~e cr_workhard cr_complet~s cr_repetit~s cr_workwit~r cr_enjoype~e cr_enthusi~c cr_makeplans cr_helpful~s cr_inventive cr_interes~t cr_activei~n cr_organized cr_tolerat~s cr_trustin~r cr_newideas cr_forgive~r cr_liketot~k
*OP-EX -> 0.8530
alpha cr_liketot~k cr_express~s cr_sharefe~s cr_activei~n cr_curious cr_newideas cr_talktom~e cr_inventive cr_manages~s cr_underst~g cr_enthusi~c cr_organized cr_staycalm cr_interes~t cr_makeplans cr_enjoype~e cr_shywith~e cr_talkative cr_putoffd~s cr_repetit~s cr_forgive~r cr_workhard cr_appoint~e cr_changem~d cr_tolerat~s cr_feeldep~d cr_easilyd~d cr_nervous
*ES-CO -> 0.8703
alpha cr_staycalm cr_talkative cr_changem~d cr_easilyd~d cr_helpful~s cr_manages~s cr_putoffd~s cr_makeplans cr_enjoype~e cr_repetit~s cr_nervous cr_rudetoo~r cr_complet~s cr_appoint~e cr_underst~g cr_workhard cr_trustin~r cr_workwit~r cr_shywith~e cr_tolerat~s cr_sharefe~s cr_curious cr_inventive cr_express~s cr_interes~t cr_liketot~k cr_organized cr_enthusi~c cr_newideas
*AG -> 0.8515
alpha cr_forgive~r cr_tolerat~s cr_trustin~r cr_rudetoo~r cr_curious cr_newideas cr_enjoype~e cr_workwit~r cr_putoffd~s cr_inventive cr_interes~t cr_complet~s cr_activei~n cr_easilyd~d cr_nervous cr_feeldep~d cr_liketot~k cr_changem~d cr_talktom~e cr_underst~g cr_shywith~e cr_talkative cr_staycalm cr_easilyu~t cr_enthusi~c cr_appoint~e cr_worryalot

rename fact1 new_CO
rename fact2 new_ES
rename fact3 new_OPEX
rename fact4 new_ESCO
rename fact5 new_AG

*NET OF LIFE CYCLE EVENTS
foreach x in new_CO new_ES new_OPEX new_ESCO new_AG EGOcrOP EGOcrCO EGOcrEX EGOcrAG EGOcrES EGOraven EGOlit EGOnum {
qui reg `x' age
predict `x'_r, resid
egen `x'_r_std=std(`x'_r)
drop `x'_r
}


global ego1new new_CO_r_std new_ES_r_std new_OPEX_r_std new_ESCO_r_std new_AG_r_std
global ego1 EGOcrOP_r_std EGOcrCO_r_std EGOcrEX_r_std EGOcrAG_r_std EGOcrES_r_std

sum $ego1 $ego1new, sep(5)


pwcorr $ego1new $ego1, star(.01)
/*
graph drop _all
set graph off
foreach x in $ego1new{
kdensity `x' if sex==1, bwidth(0.3) plot(kdensity `x' if sex==2, bwidth(0.3)) title ("") note("") legend(ring(0) pos(2) label(1 "Male") label(2 "Female")) name(k_`x', replace)
}
graph dir 
set graph on
grc1leg k_EGOlit_r_std k_EGOnum_r_std k_EGOraven_r_std k_new_CO_r_std k_new_OPEX_r_std k_new_ESCO_r_std k_new_AG_r_std k_new_ES_r_std, leg(k_new_ESCO_r_std) pos(3)
*/

keep parent_key egoid new_CO_r_std new_ES_r_std new_OPEX_r_std new_ESCO_r_std new_AG_r_std 
reshape wide new_CO_r_std new_ES_r_std new_OPEX_r_std new_ESCO_r_std new_AG_r_std, i(parent_key) j(egoid)
save "$directory\_temp\NEEMSIS_newFFM.dta", replace
*/
