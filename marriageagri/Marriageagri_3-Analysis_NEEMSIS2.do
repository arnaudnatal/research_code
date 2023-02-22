cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
20 avril 2021
-----
TITLE: CLEANING MARRIAGE NEEMSIS2


-------------------------
*/

clear all
*global directory "D:\Documents\_Thesis\Research-Marriage\Data"
global directory "C:\Users\anatal\Downloads\_Thesis\Research-Marriage\Data"

*global git "D:\Documents\GitHub"
global git "C:\Users\anatal\Downloads\GitHub"

cd"$directory\NEEMSIS2"
set scheme plottig






****************************************
* Preliminary analysis
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v6.dta", clear


********** Identify respondent amount
gen respondent_engagementcost1000=.
gen respondent_marriagecost1000=.
gen respondent_sharemarriage=.
gen respondent_shareengagement=.

replace respondent_engagementcost1000=engagementhusbandcost1000 if sex==1
replace respondent_engagementcost1000=engagementwifecost1000 if sex==2

replace respondent_marriagecost1000=marriagehusbandcost1000 if sex==1
replace respondent_marriagecost1000=marriagewifecost1000 if sex==2

replace respondent_shareengagement=husbandshareengagement if sex==1
replace respondent_shareengagement=wifeshareengagement if sex==2

replace respondent_sharemarriage=husbandsharemarriage if sex==1
replace respondent_sharemarriage=wifesharemarriage if sex==2


********** Extremums
replace MCIR=9 if MCIR>9
replace ECIR=2 if ECIR>2




********** Age as cat
fsum ageatmarriage
fre sex
gen female_agecat=.
replace female_agecat=1 if ageatmarriage<18 & ageatmarriage!=. & sex==2
replace female_agecat=2 if ageatmarriage>=18 & ageatmarriage<25 & ageatmarriage!=. & sex==2
replace female_agecat=3 if ageatmarriage>=25 & ageatmarriage<30 & ageatmarriage!=. & sex==2
replace female_agecat=4 if ageatmarriage>=30 & ageatmarriage<40 & ageatmarriage!=. & sex==2
replace female_agecat=5 if ageatmarriage>=40 & ageatmarriage!=. & sex==2

label define agecat 1"];18[" 2"[18;25[" 3"[25;30[" 4"[30;40[" 5"[40;["
label values female_agecat agecat

tab female_agecat sex, m



********** Label for moc
label define mainoccupation_indiv 0"Not working" 1"Agri" 2"SE" 3"SJ agri" 4"SJ non-agri" 5"UW hh business" 6"UW other business" 7"UW own farm" 8"UW another farm", replace
label values mainoccupation_indiv mainoccupation_indiv



********** Quantile income and assets
xtile totalincome_HH_q=totalincome_HH, n(4)
xtile assets_q=assets, n(4)

label define inc_q 1"Income - Q1" 2"Income - Q2" 3"Income - Q3" 4"Income - Q4", replace
label define ass_q 1"Assets - Q1" 2"Assets - Q2" 3"Assets - Q3" 4"Assets - Q4", replace

label values totalincome_HH_q inc_q
label values assets_q ass_q


********** Who marries?
tab caste sex, nofreq col
tab edulevel sex, nofreq col
tabstat ageatmarriage, stat(n mean p50) by(sex)




********** Type of marriage
tab caste
tab hwcaste caste, cell nofreq
tab hwcaste caste if sex==1
tab hwcaste caste if sex==2
tab marriagearranged caste, col nofreq
tab marriagetype caste, col nofreq
*tab marriagedecision caste
*tab marriagedecision_rec caste, col nofreq
tab marriagespousefamily caste, col nofreq
tabstat peoplewedding, stat(mean sd p50 min max) by(caste)
tab datecovid caste, nofreq col



********** % of expenses in capital
preserve
bysort HHID_panel: egen sum_marriageexpenses=sum(marriageexpenses)
duplicates drop HHID_panel, force
drop if sum_marriageexpenses==. | sum_marriageexpenses==0
tab caste
restore




********** How pay the marriage?
tab1 howpaymarriage_loan howpaymarriage_capital howpaymarriage_gift
/*
102/117 marriages were paid with loan
113/117 marriages were paid with capital
7/117 marriages were paid with gift 

pb bc i have only 38 values in marriageexpenses
*/
order howpaymarriage_capital marriageexpenses, last
sort howpaymarriage_capital marriageexpenses
*I have 75 missings


********** Cost of marriage
* Marriage
tabstat marriagetotalcost1000 husbandsharemarriage wifesharemarriage, stat(mean sd p50) by(caste)
* Engagement
tabstat engagementtotalcost1000 husbandshareengagement wifeshareengagement, stat(mean sd p50) by(caste)
* Dowry
tabstat marriagedowry1000 DWTC DWTCnodowry, stat(n mean sd p50) by(caste)
* Total
tabstat totalcost1000 husbandsharetotal wifesharetotal, stat(n mean sd p50) by(caste)



********** Relative cost of marriage
* Points
gen assets1000=assets/1000
gen totalincome1000_HH=totalincome_HH/1000
tabstat assets1000 totalincome1000_HH, stat(n mean sd p50) by(sex)
* Assets
tabstat MCAR ECAR DAAR TCAR, stat(n mean sd p50) by(sex)
* Income
tabstat MCIR ECIR DAIR TCIR, stat(n mean sd p50) by(sex)
* Expenses
tabstat marriageexpenses1000 MEAR MEIR MEMC, stat(n mean sd p50) by(sex)




********** Schemes
tab schemeamount7 intercaste
tab schemeamount8 intercaste
*Nothing





********** Gift as form of saving?
fre dummymarriagegift
fre sex
gen totalmarriagegiftamount1000=totalmarriagegiftamount/1000
* Gift and relative to cost 
tabstat totalmarriagegiftamount1000 gifttoexpenses gifttocost, stat(n mean sd p50) by(sex)
* Gift relative to assets and income
tabstat GAR GIR, stat(n mean sd p50) by(sex)
* Benefits on marriage ceremony
tab benefitscost sex, col
tab benefitsexpenses sex, col



********** Net benefits of marriage
tabstat netbenefitsmarriage, stat(n mean sd min q max) by(sex) 
tabstat BAR BIR, stat(n mean sd p50) by(sex)
tabstat BAR BIR if netbenefitsmarriage>1, stat(n mean sd p50) by(sex)
reg netbenefitsmarriage i.sex i.caste
/*
Est-ce que quand le HH est au placé, il dégage plus de profit?
Si jamais il appartient à un Panchayat, etc
*/




********** Gift and people wedding
plot totalmarriagegiftamount peoplewedding
/*
  790000 +  
    t    |       *
    o    |  
    t    |  
    a    |  
    l    |  
    m    |  
    a    |  
    r    |  
    r    |  
    i    |  
    a    |  
    g    |       *    *
    e    |      *    *
    g    |  
    i    |      *            *                            *
    f    |    * *  *            *         *               *
    t    |  * * *                         *               *                *
    a    | ** * ** *      *     *         *               *                *
    m    | ** *  *        *     *                         *
    9000 + ** * **
          +----------------------------------------------------------------+
               40    How many people attended the ${marriedna        2000
*/
*twoway (scatter totalmarriagegiftamount peoplewedding, legend(off) ytitle("Total gift amount")) (lfit totalmarriagegiftamount peoplewedding)




********** If better situation is the cost higher ?
tabstat wifesharemarriage if sex==1, stat(n mean sd p50) by(marriagespousefamily)
tabstat husbandsharemarriage if sex==2, stat(n mean sd p50) by(marriagespousefamily)





********** Date
*twoway (scatter peoplewedding marriagedate, legend(off) ytitle("Nb people at wedding"))
*twoway (scatter marriagetotalcost marriagedate, legend(off))




********** Type of marriage
tabstat marriagetotalcost1000, stat(n min p50 max)

/*
stripplot marriagetotalcost1000, over(marriagearranged) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(100)1800) ymtick(0(50)1800) ytitle() ///
msymbol(oh oh oh) 
*/




********** Graphical representation of cost
* Absolut measure of marriage and engagement cost
fsum marriagetotalcost1000 respondent_sharemarriage engagementtotalcost1000 respondent_shareengagement wifesharemarriage
set graph off
stripplot marriagetotalcost1000, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") ytitle("₹1k") xlabel(,angle(45))  ///
ylabel(0(300)1800) ymtick(0(100)1800) ytitle() ///
msymbol(oh oh oh) ///
legend(off) ///
title("Cost") name(g1, replace)

stripplot wifesharemarriage, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.1)1) ymtick(0(.05)1) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
legend(off) ///
title("Share paid by spouse") name(g2, replace)

stripplot engagementtotalcost1000, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") ytitle("₹1k") xlabel(,angle(45))  ///
ylabel(0(100)400) ymtick(0(25)400) ytitle() ///
msymbol(oh oh oh) ///
legend(off) ///
title("Cost") name(g3, replace)

stripplot wifeshareengagement, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(.1)1) ymtick(0(.05)1) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
legend(off) ///
legend(col(3) pos(6)) ///
title("Share paid by spouse") name(g4, replace)

graph combine g1 g2, col(2) name(g_marriage, replace) title("Marriage")
graph combine g3 g4, col(2) name(g_engagement, replace) title("Engagement")
graph combine g_engagement g_marriage, note("Couple level (n=117)", size(tiny)) name(g_abs, replace)
set graph on

graph display g_abs
graph export "$git/Analysis/Marriage/Graph/cost_caste_abs.pdf", replace





* Relatives measures of marriage and engagement cost
fsum MCAR MCIR ECAR ECIR
set graph off

stripplot MCAR, over(sex) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.3)3.6) ymtick(0(.1)3.6) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
legend(pos(6) col(3)) ///
title("Cost to assets ratio") name(g1, replace)

stripplot MCIR, over(sex) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.5)9) ymtick(0(0.25)9) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
legend(pos(6) col(3)) ///
title("Cost to income ratio") name(g2, replace)

stripplot ECAR, over(sex) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.1).5) ymtick(0(.05).5) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
legend(pos(6) col(3)) ///
title("Cost to assets ratio") name(g3, replace)

stripplot ECIR, over(sex) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.2)2) ymtick(0(0.1)2) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
legend(pos(6) col(3)) ///
title("Cost to income ratio") name(g4, replace)

grc1leg g1 g2, col(2) name(g_marriage, replace) title("Marriage")
grc1leg g3 g4, col(2) name(g_engagement, replace) title("Engagement")
grc1leg g_engagement g_marriage, note("Respondent level (n=117)", size(tiny)) name(g_rel, replace)
set graph on


graph display g_rel
graph export "$git/Analysis/Marriage/Graph/cost_sexcaste_rel.pdf", replace



* Dowry absolut cost
tabstat marriagedowry1000 DMC, stat(n mean sd p50 min max) by(

set graph off
stripplot marriagedowry1000, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle("₹1k") ///
msymbol(oh oh oh) ///
title("Amount") name(g1, replace)

stripplot DWTC, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.1)1) ymtick(0(.05)1) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
title("Dowry to union total cost") name(g2, replace)

stripplot wifesharetotal, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.1)1) ymtick(0(.05)1) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
title("Total cost assumed by the wife") name(g3, replace)

graph combine g1 g2 g3, col(3) name(g_dowry_abs, replace)
set graph on

graph display g_dowry_abs
graph export "$git/Analysis/Marriage/Graph/dowry_caste_abs.pdf", replace



* Dowry absolut over age of bride, educ and labour of groom

stripplot marriagedowry1000 if sex==2, over(female_agecat) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(100)800) ymtick(0(50)800) ytitle("₹1k") ///
msymbol(o o o o) ///
title("Amount") name(g1bis, replace)

stripplot marriagedowry1000 if sex==1, over(edulevel) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle("₹1k") ///
msymbol(o o o o) ///
title("Amount") name(g1bis, replace)

stripplot marriagedowry1000 if sex==1, over(mainoccupation_indiv) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle("₹1k") ///
msymbol(o o o o) ///
title("Amount") name(g1bis, replace)

stripplot marriagedowry1000 if sex==1, over(totalincome_HH_q) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle("₹1k") ///
msymbol(o o o o) ///
title("Amount") name(g1bis, replace)

stripplot marriagedowry1000 if sex==1, over(assets_q) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle(45))  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle("₹1k") ///
msymbol(o o o o) ///
title("Amount") name(g1bis, replace)




* Dowry relative cost
fsum DAAR DAIR
set graph off
stripplot DAAR, over(caste) separate(edulevel) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.5)3.5) ymtick(0(.1)3.5) ytitle("(*100)%") ///
msymbol(o o o o) ///
title("Assets ratio") name(g2, replace)

stripplot DAIR, over(caste) separate(marriagearranged) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(.2)2) ymtick(0(0.1)2) ytitle("(*100)%") ///
msymbol(oh oh oh) ///
title("Income ratio") name(g3, replace)







********** QREG
foreach x in assets totalincome_HH {
preserve
tempname memhold
tempfile results
postfile `memhold' q b cilow95 cihigh95 using `results'
forvalues i=.1(.1).9 {
qui qreg2 marriagedowry assets totalincome_HH if sex==1, q(`i')
	local b = _b[`x']
    local cilow95  = _b[`x']-_se[`x']*invttail(e(df_r),.025)    
    local cihigh95  = _b[`x']+_se[`x']*invttail(e(df_r),.025)    
    post `memhold' (`i') (`b') (`cilow95') (`cihigh95')
}
postclose `memhold'
use `results', clear
twoway ///
(rarea cihigh95 cilow95 q, fcolor(%5)) ///
(line b q, yline(0, lcolor(black) lpattern(solid) lwidth(0.1))) ///
, xtitle("Quantile") legend(order(1 "95% cl" 2 "90% cl" 3 "Coef.") col(3) pos(6)) xlabel(.1(.1).9) title("", size(large)) aspectratio(0.5) scale(0.7) name(g_male_`x', replace)
restore
}
}



save"$directory\NEEMSIS2\NEEMSIS2-marriage_v7.dta", replace
****************************************
* END
















****************************************
* Network
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v7.dta", clear

********** Cleaning formal network
gen dummyassopolitic=0
replace dummyassopolitic=1 if assodegreeparticip_politic1!=""
*replace dummyassopolitic=1 if assodegreeparticip_politic2!=""

gen dummyassoprofess=0
replace dummyassoprofess=1 if assodegreeparticip_profess1!=""
*replace dummyassoprofess=1 if assodegreeparticip_profess2!=""
*replace dummyassoprofess=1 if assodegreeparticip_profess3!="" 

gen dummyassoshg=0
replace dummyassoshg=1 if assodegreeparticip_shg1!=""
*replace dummyassoshg=1 if assodegreeparticip_shg2!=""
*replace dummyassoshg=1 if assodegreeparticip_shg3!=""

gen dummyassofarmer=0
replace dummyassofarmer=1 if assodegreeparticip_farmer1!=""

gen dummyassohobby=0
*replace dummyassohobby=1 if assodegreeparticip_hobby2!=""

gen dummyassoother=0
*replace dummyassoother=1 if assodegreeparticip_other2!=""

gen dummyassovillage=0
*replace dummyassovillage=1 if assodegreeparticip_village2!=""

tab1 dummyassopolitic dummyassoprofess dummyassoshg dummyassofarmer dummyassohobby dummyassoother dummyassovillage

egen dummyasso=rowtotal(dummyassopolitic dummyassoprofess dummyassoshg dummyassofarmer dummyassohobby dummyassoother dummyassovillage)
replace dummyasso=1 if dummyasso>1
label define asso 0"No asso (n=99)" 1"Asso (n=18)"
label values dummyasso asso


********** Cleaning size network & qualityt
tab1 nbercontactphone1 nbercontactphone2 nbercontactphone3
fre nbercontactphone1

gen contactphone=. 
replace contactphone=1 if nbercontactphone1==7
replace contactphone=2 if nbercontactphone1==1
replace contactphone=2 if nbercontactphone1==2
replace contactphone=3 if nbercontactphone1==3
replace contactphone=4 if nbercontactphone1==4
replace contactphone=4 if nbercontactphone1==5
tab nbercontactphone1 contactphone

*Quality
tab1 dummycontactleaders1 dummycontactleaders2 dummycontactleaders3
tab contactleaders1
gen leaders=0
replace leaders=1 if contactleaders1=="ADMK"
replace leaders=1 if contactleaders1=="Admk"
replace leaders=1 if contactleaders1=="Politician of ADMK"
replace leaders=2 if contactleaders1=="Village panchayat"
replace leaders=3 if contactleaders1=="Babu"
replace leaders=3 if contactleaders1=="DPI"
tab leaders

*Party cost
gen partycost1000=marriagehusbandcost1000 if sex==1
replace partycost1000=marriagewifecost1000 if sex==2



********** Analysis

*Dummy asso
tabstat peoplewedding totalmarriagegiftamount1000 partycost1000, stat(n mean sd q max) by(dummyasso) 

*Nbercontact
tab contactphone sex, row nofreq
tabstat peoplewedding totalmarriagegiftamount1000 partycost1000, stat(n mean sd q max) by(contactphone)

*Leaders
tab dummycontactleaders1 sex
tabstat peoplewedding totalmarriagegiftamount1000 partycost1000, stat(n mean sd q max) by(dummycontactleaders1)





save"$directory\NEEMSIS2\NEEMSIS2-marriage_v8.dta", replace
****************************************
* END














****************************************
* Aspiration and social mobility
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v8.dta", clear

********** Aspirations
twoway ///
|| scatter  marriagedowry1000 assets1000 if sex==2 ///
|| lfit  marriagedowry1000 assets1000 if sex==2 ///
|| scatter  marriagedowry1000 assets1000 if sex==1 & assets1000<1000 ///
|| lfit  marriagedowry1000 assets1000 if sex==1 & assets1000<1000

plot marriagedowry1000 assets1000 if sex==2
plot marriagedowry1000 assets1000 if sex==1



********** Intercaste marriage
tab jatis caste
tab hwcaste caste
/*
Pratiloma --> lower dowry  --> downward mobility
Anumola --> higher dowry --> upward mobility for female


-------------------------+--------------------------------------------
Valid   1  Vanniyar      |         30      25.64      25.64      25.64
        2  SC            |         68      58.12      58.12      83.76
        3  Arunthathiyar |          1       0.85       0.85      84.62
        4  Rediyar       |          2       1.71       1.71      86.32
        6  Naidu         |          2       1.71       1.71      88.03
        8  Asarai        |          1       0.85       0.85      88.89
        11 Mudaliar      |          6       5.13       5.13      94.02
        12 Kulalar       |          1       0.85       0.85      94.87
        13 Chettiyar     |          1       0.85       0.85      95.73
        15 Muslims       |          1       0.85       0.85      96.58
        16 Padayachi     |          2       1.71       1.71      98.29
        17 Yathavar      |          2       1.71       1.71     100.00
        Total            |        117     100.00     100.00           


*/
tab husbandwifecaste jatis if sex==1 & intercaste==1
/*
Hommes enquêtés:														Mobility for female	
4 hommes SC (dalits) se sont mariés avec des Vanniyar (middle)			pratiloma 	
1 homme Naidu (upper) s'est marié est une Vanniyar (middle)				anumola 		
3 hommes Mudaliar  (upper) se sont mariés avec des Vanniyar (middle)	anumola
1 homme Chettiyar  (upper) s'est marié avec une Vanniyar (middle)		anumola
1 homme Yathavar (upper) s'est marié avec une Vanniyar (middle)			anumola
1 homme Yathavar (upper) s'est marié avec une Padayachi	(middle)		anumola			
*/

tab husbandwifecaste jatis if sex==2 & intercaste==1
/*
Femmes enquêtés:														Mobility for female
5 femmes SC (dalits) se sont mariées avec des Vanniyar (middle)			anumola
1 femme Rediyar (upper) s'est mariée avec un Vanniyar (middle)			pratiloma
2 femmes Mudaliar (upper) se sont mariée avec des Vanniyar (middle)		pratiloma
*/

gen pratiloma=0
replace pratiloma=1 if sex==1 & jatis==2 & husbandwifecaste==1
replace pratiloma=1 if sex==2 & jatis==4 & husbandwifecaste==1
replace pratiloma=1 if sex==2 & jatis==11 & husbandwifecaste==1

tab pratiloma

gen anumola=0
replace anumola=1 if sex==1 & jatis==6 & husbandwifecaste==1
replace anumola=1 if sex==1 & jatis==11 & husbandwifecaste==1
replace anumola=1 if sex==1 & jatis==13 & husbandwifecaste==1
replace anumola=1 if sex==1 & jatis==17 & husbandwifecaste==1
replace anumola=1 if sex==1 & jatis==17 & husbandwifecaste==16
replace anumola=1 if sex==2 & jatis==2 & husbandwifecaste==1

tab anumola
tab pratiloma

gen marriagemobility=2 
replace marriagemobility=1 if pratiloma==1
replace marriagemobility=3 if anumola==1

stripplot marriagedowry1000, over(marriagemobility) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(100)1200) ymtick(0(50)1200) ytitle() ///
msymbol(oh oh oh) mcolor(plr1 ply1 plg1) 


********** Voir plus finement
* Dowry for middle wife without mobility
tab marriagedowry1000 if (caste==2 | hwcaste==2) & marriagemobility==2
* Dowry for middle wife with mobility
tab marriagedowry1000 if (caste==2 | hwcaste==2) & sex==2 & marriagemobility==3

****************************************
* END


















****************************************
* Stat loans
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-loans_v11.dta", clear
drop _merge
preserve
use "$directory\NEEMSIS2\NEEMSIS2-marriage_v8.dta", clear
duplicates drop HHID_panel, force
keep HHID_panel
gen marriage=1
save "$directory\NEEMSIS2\NEEMSIS2-marriage_v8_1.dta", replace
restore

preserve
merge m:1 HHID_panel using "$directory\NEEMSIS2\NEEMSIS2-marriage_v8_1.dta"
tab marriage
keep if marriage==1
save"$directory\NEEMSIS2\NEEMSIS2-loans_v11_marriage.dta", replace
restore


tab loan_database

**********  Amount of reason
gen loanamount1000=loanamount/1000
gen loanbalance1000=loanbalance/1000

tabstat loanamount1000, stat(n mean sd p50) by(loanreasongiven)
tabstat loanamount1000 if loanreasongiven!=8, stat(n mean sd p50) by(loanlender_new2020)
tabstat loanamount1000 if loanreasongiven==8, stat(n mean sd p50) by(loanlender_new2020)



********** Share of total clientele using it
fre loanreasongiven
forvalues i=1(1)13{
gen reason`i'=0
}

forvalues i=1(1)12{
replace reason`i'=1 if loanreasongiven==`i'
}
replace reason13=1 if loanreasongiven==77

preserve 
forvalues i=1(1)13{
bysort parent_key: egen reasonHH_`i'=max(reason`i')
} 
bysort parent_key: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore



********** Share of total clientele using it (lender)
fre loanlender_new2020
forvalues i=1(1)15{
gen lenders`i'=0
}

forvalues i=1(1)15{
replace lenders`i'=1 if loanlender_new2020==`i' & loanreasongiven==8
}

preserve 
keep if loanreasongiven==8
forvalues i=1(1)15{
bysort parent_key: egen lendersHH_`i'=max(lenders`i')
} 
bysort parent_key: gen n=_n
keep if n==1
forvalues i=1(1)15{
tab lendersHH_`i', m
}
restore





********** From whom?
/*
The sense of debt as something immoral also depends upon the hierarchical positions of the
lender and the borrower. On the borrower’s side, the norm is to contract loans from someone
from an equal or higher caste." They do not take water from us, do you think they would take
money?" is something the low castes often said to us. On the creditor side, some upper castes
refuse to lend to castes who are too low in the hierarchy in comparison to them, stating that it
would be degrading for them to go and claim their due. To ask an upper caste whether he is
indebted to a lower caste can be considered as an insult.
*/
tab snmoneylendercastes
gen snmoneylendercastes_group=.
foreach x in 2 3{
replace snmoneylendercastes_group=1 if snmoneylendercastes==`x'
}
foreach x in 1 5 7 8 10 12 15 16{
replace snmoneylendercastes_group=2 if snmoneylendercastes==`x'
}
foreach x in 4 6 11 13 17{
replace snmoneylendercastes_group=3 if snmoneylendercastes==`x'
}
label values snmoneylendercastes_group castecat
drop lenderscaste
rename snmoneylendercastes_group lenderscaste
tab lenderscaste

tab lenderscaste caste if loanreasongiven==8, col row
tab lenderscaste caste if loanreasongiven!=8, col row




********** Who borrow for marriage?
tab loanreasongiven caste, row col nofreq
*surtout les dalits
tab loanlender_new2020 caste if loanreasongiven==8, row col nofreq
*wkp et relatives




********** Only the 117 marriage
use"$directory\NEEMSIS2\NEEMSIS2-loans_v11_marriage.dta", clear
fre loanreasongiven
tabstat loanamount, stat(n mean sd p50 sum) by(loanreasongiven)

tab loanlender if loanreasongiven==8
preserve
keep if loanreasongiven==8
duplicates drop HHID_panel, force
tab caste
restore






****************************************
* END





























****************************************
* Cost of debt
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-loans_v13.dta", clear
drop interestpaid2

********** Check les HH who face one marriage since 2016
preserve
use"$directory\NEEMSIS2\NEEMSIS2-HH_v16.dta", clear
keep parent_key dummymarriage
duplicates drop
save"$directory\NEEMSIS2\NEEMSIS2-HH_marriage_HH.dta", replace
restore
merge m:1 parent_key using "$directory\NEEMSIS2\NEEMSIS2-HH_marriage_HH.dta", nogen keep(3)





********** Price of debt
/*
Guérin et al. (2014) : Honouring reciprocity in ceremonies has always been a source of
permanent pressure. Many interviewees make clear that they prefer going into debt outside
the family circle to meet their own needs. This is a matter of freedom, as kin support calls
for constant justification (niyayapadthanum). Some say they borrow from their kin only for
"justified" reasons, which are mainly ceremony, housing and health costs. The obligation of
reciprocity (tiruppu) is also a burden. Not only should the debt be repaid, but the debtor should
be able to lend in return when the creditor is in need
*/
/*
“Bad” debts are rarely the most expensive, financially speaking, but those that tarnish
the reputation of the family and jeopardize its future, especially children’s marriages. Bad
debts serve to reveal that a household is unable to maintain its position in the social hierarchy.

Distinguer le cout des WKP par raison de l'endettement
*/





********* Interest: method 2
gen interestloanday=.
replace interestloanday=interestloan*(52/365) 	if interestfrequency==1
replace interestloanday=interestloan*(12/365) 	if interestfrequency==2
replace interestloanday=interestloan*(1/365)	if interestfrequency==3
replace interestloanday=interestloan*(2/365)  	if interestfrequency==4
replace interestloanday=interestloan*(1/365)	if interestfrequency==5
replace interestloanday=interestloan*(1/365)	if interestfrequency==6
gen interestpaid2=interestloanday*loanduration

gen yratepaid2=interestpaid2*100/loanamount






********** Interest: method 3
gen yratepaid3=interestpaid*100/loanamount






********** Interest: method 4
gen loan_months=loanduration/30.416667
gen loan_year=loanduration/365
gen yratepaid4=.
****if interest paid weekly, monthly or when have money, once in six months, or unclear (interestfreq=7)
replace yratepaid4=interestpaid*100*12/(loan_months*loanamount) if interestfreq==1 | interestfreq==2 | interestfreq==6 | interestfreq==7 | interestfreq==4
****if interest paid yearly: interestpaid averaged with an integer for number of years 
gen loan_year2=loan_year
replace loan_year2=1 if loan_year2<1 
replace yratepaid4=interestpaid*100/(loan_year2*loanamount) if interestfreq==3
**** if interest=fixed amount
replace yratepaid4=interestpaid*100/loanamount if interestfreq==5
replace yratepaid4=. if dummyinterest==0






********** Interest: method 5
gen monthlyinterestpaid5=.
*replace monthlyinterestpaid5= if interestfrequency==2




********** Interest
* Interest loan var
clonevar interestloan2=interestloan
recode interestloan2 (66=.)
tabstat interestloan2, stat(n mean sd p50) by(interestfrequency)


* Interest paid
*twoway (scatter interestpaid loandate, legend(off)) (lfit interestpaid loandate)


* Is equal?
fre interestfrequency
gen interestpaid_calc=.
replace interestpaid_calc=(interestpaid/loanduration)*7 if interestfrequency==1
replace interestpaid_calc=(interestpaid/loanduration)*30.4167 if interestfrequency==2
replace interestpaid_calc=(interestpaid/loanduration)*365 if interestfrequency==3
replace interestpaid_calc=(interestpaid/loanduration)*182.5 if interestfrequency==4
replace interestpaid_calc=interestpaid if interestfrequency==5
replace interestpaid_calc=interestpaid if interestfrequency==6


gen percvarinterest=abs((interestpaid_calc-interestloan)*100/interestloan)
tabstat percvarinterest, stat(n mean sd p50 p90 p95 p99 max)


stripplot percvarinterest if percvarinterest<=1000, separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(100)1000) ymtick(0(50)1000) ytitle() ///
msymbol(oh oh oh) mcolor(plr1 ply1 plg1) 







********** Check
/*
tabstat yratepaid3 yratepaid4 yratepaid5, stat(n mean sd q)
drop yratepaid3 yratepaid5
rename yratepaid4 yratepaid
*/
/*
yratepaid3 surestimation je crois bien..
yratepaid4 proche de yratepaid5 donc plutôt bon signe
*/




/*
********* Coherence with loan settled
use"$directory\NEEMSIS2\NEEMSIS2-loans_v11.dta", clear

keep if loansettled==1

* Interest: method 1
gen interestloanday=.
replace interestloanday=interestloan*(52/365) 	if interestfrequency==1
replace interestloanday=interestloan*(12/365) 	if interestfrequency==2
replace interestloanday=interestloan*(1/365)	if interestfrequency==3
replace interestloanday=interestloan*(2/365)  	if interestfrequency==4
replace interestloanday=interestloan*(1/365)	if interestfrequency==5
replace interestloanday=interestloan*(1/365)	if interestfrequency==6
gen interestpaid3=interestloanday*loanduration
gen verif=interestpaid3-interestpaid
tab verif if (interestfrequency==1 | interestfrequency==2 | interestfrequency==3) & loansettled==0
gen yratepaid3=interestpaid3*100/loanamount

* Interest: method 2
gen yratepaid4=interestpaid*100/loanamount

* Interest: method 3
gen loan_months=loanduration/30.416667
gen loan_year=loanduration/365
gen yratepaid5=.
****if interest paid weekly, monthly or when have money, once in six months, or unclear (interestfreq=7)
replace yratepaid5=interestpaid*100*12/(loan_months*loanamount) if interestfreq==1 | interestfreq==2 | interestfreq==6 | interestfreq==7 | interestfreq==4
****if interest paid yearly: interestpaid averaged with an integer for number of years 
gen loan_year2=loan_year
replace loan_year2=1 if loan_year2<1 
replace yratepaid5=interestpaid*100/(loan_year2*loanamount) if interestfreq==3
**** if interest=fixed amount
replace yratepaid5=interestpaid*100/loanamount if interestfreq==5
replace yratepaid5=. if dummyinterest==0
*/




********** Interest per lender and reason
*tabstat yratepaid, stat(n mean sd p50) by(loanlender)
*tabstat yratepaid, stat(n mean sd p50) by(lender4)
tabstat yratepaid2 yratepaid3 yratepaid4, stat(n mean sd p50) by(loanreasongiven)

tabstat yratepaid2 yratepaid3 yratepaid4 if loanreasongiven==8, stat(n mean sd p50) by(loanlender_new2020)
tabstat yratepaid2 yratepaid3 yratepaid4 if loanreasongiven!=8, stat(n mean sd p50) by(loanlender_new2020)

tabstat yratepaid2 yratepaid3 yratepaid4 if loanreasongiven==8 & loanlender_new2020==1, stat(n mean sd p1 p5 p10 q p90 p95 p99 min max)

*histogram yratepaid if loanreasongiven==8 & loanlender_new2020==1, width(1) xtitle("Interest rate")



********** Monthly/annual interest
forvalues i=2(1)4{
gen annualinterestrate`i'=.

gen monthlyinterestrate`i'=.
}

forvalues i=2(1)4{
replace annualinterestrate`i'=yratepaid`i' if loanduration<=365
replace annualinterestrate`i'=(yratepaid`i'/loanduration)*365 if loanduration>365

replace monthlyinterestrate`i'=yratepaid`i' if loanduration<=30.4167
replace monthlyinterestrate`i'=(yratepaid`i'/loanduration)*30.4167 if loanduration>30.4167
}

forvalues i=2(1)4{
gen monthlyinterestrate`i'_rec=1 if monthlyinterestrate`i'<3 & monthlyinterestrate`i'!=.
}

forvalues i=2(1)4{
replace monthlyinterestrate`i'_rec=2 if monthlyinterestrate`i'>=3 & monthlyinterestrate`i'<5 & monthlyinterestrate`i'!=.
replace monthlyinterestrate`i'_rec=3 if monthlyinterestrate`i'>=5 & monthlyinterestrate`i'!=.
}

tab monthlyinterestrate_rec if loanlender_new2020==1
tabstat monthlyinterestrate if loanlender_new2020==1, stat(n mean sd q) by(loanreasongiven)

tabstat monthlyinterestrate if loanreasongiven==8, stat(n mean sd p50) by(loanlender_new2020)
tabstat monthlyinterestrate if loanreasongiven!=8, stat(n mean sd p50) by(loanlender_new2020)

tabstat monthlyinterestrate2 monthlyinterestrate3 monthlyinterestrate4, stat(n mean sd p50) by(loanlender_new2020)

tabstat yratepaid2 monthlyinterestrate2 yratepaid3 monthlyinterestrate3 yratepaid4 monthlyinterestrate4, stat(n mean sd p50)

********** Comparaison avec 2016
use"$directory\NEEMSIS1\NEEMSIS1-loans_v11.dta", clear

gen yratepaid=interestpaid*100/loanamount
tab yratepaid

gen annualinterestrate=.
replace annualinterestrate=yratepaid if loanduration<=365
replace annualinterestrate=(yratepaid/loanduration)*365 if loanduration>365

gen monthlyinterestrate=.
replace monthlyinterestrate=yratepaid if loanduration<=30.4167
replace monthlyinterestrate=(yratepaid/loanduration)*30.4167 if loanduration>30.4167

gen monthlyinterestrate_rec=1 if monthlyinterestrate<3 & monthlyinterestrate!=.
replace monthlyinterestrate_rec=2 if monthlyinterestrate>=3 & monthlyinterestrate<5 & monthlyinterestrate!=.
replace monthlyinterestrate_rec=3 if monthlyinterestrate>=5 & monthlyinterestrate!=.
tab monthlyinterestrate_rec if loanlender==1
tabstat monthlyinterestrate if loanlender==1, stat(n mean sd q) by(loanreasongiven)



****************************************
* END
















****************************************
* Burden of marriage debt
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v8.dta", clear
gen dummyloanmarriage=1 if marriageloanamount_HH>0
recode dummyloanmarriage (.=0)
tab dummyloanmarriage
gen loanamount1000_HH=loanamount_HH/1000
gen marriageloanamount1000_HH=marriageloanamount_HH/1000
gen loanamount1000_nomar_HH=loanamount1000_HH-marriageloanamount1000_HH

* Verif
gen verif=marriageloanamount_HH-marriageloanamount_mar_HH-marriageloanamount_fin_HH
tab verif
drop verif

* Share marriage
gen marriageshare=marriageloanamount_HH*100/loanamount_HH
tab marriageshare


* % of debt in more with marriage debt
gen inc_loanamount=(loanamount1000_HH-loanamount1000_nomar_HH)*100/loanamount1000_nomar_HH if marriageloanamount_HH!=. & marriageloanamount_HH!=0
gen share_marriage_in_loanamount=(loanamount1000_HH-loanamount1000_nomar_HH)*100/loanamount1000_HH if marriageloanamount_HH!=. & marriageloanamount_HH!=0


* % of assets/income of debt in more/of marriage debt 
gen inc_assets=(loanamount1000_HH-loanamount1000_nomar_HH)*100/assets1000 if marriageloanamount_HH!=. & marriageloanamount_HH!=0
gen inc_income=(loanamount1000_HH-loanamount1000_nomar_HH)*100/totalincome1000_HH if marriageloanamount_HH!=. & marriageloanamount_HH!=0
sort inc_income

* Graph rpz
fsum inc_loanamount inc_assets inc_income, stat(min p1 p5 p10 p25 p50 p75 p90 p95 p99 max)

stripplot share_marriage_in_loanamount, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(10)100) ymtick(0(5)100) ytitle("%") ///
msymbol(oh oh oh) 

stripplot inc_loanamount, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(200)3000) ymtick(0(100)3000) ytitle("%") ///
msymbol(oh oh oh) 

stripplot inc_assets, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(10)120) ymtick(0(5)120) ytitle("%") ///
msymbol(oh oh oh)

stripplot inc_income, over(caste) separate() ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(200)3000) ymtick(0(100)3100) ytitle("%") ///
msymbol(oh oh oh)




* Perc of increase of DAR
gen DAR_with=loanamount_HH/assets


*gen percDAR=(DAR_with-DAR_without)*100/DAR_without

tabstat DAR_without DAR_with if dummyloanmarriage==1, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(caste)
tabstat DAR_without DAR_with if dummyloanmarriage==1, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(sex)


****************************************
* END
