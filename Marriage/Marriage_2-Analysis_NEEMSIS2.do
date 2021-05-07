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
global directory "D:\Documents\_Thesis\Research-Marriage\Data"
cd"$directory\NEEMSIS2"







****************************************
* Preliminary analysis
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-marriage_v6.dta", clear


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
twoway (scatter peoplewedding marriagedate, legend(off) ytitle("Nb people at wedding"))
twoway (scatter marriagetotalcost marriagedate, legend(off))




********** Type of marriage
tabstat marriagetotalcost1000, stat(n min p50 max)

stripplot marriagetotalcost1000, over(marriagearranged) separate(caste) ///
cumul cumprob box centre refline vertical /// 
xsize(3) xtitle("") xlabel(,angle())  ///
ylabel(0(100)1800) ymtick(0(50)1800) ytitle() ///
msymbol(oh oh oh) mcolor(plr1 ply1 plg1) 

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
* Stat loans
****************************************
use"$directory\NEEMSIS2\NEEMSIS2-loans_v11.dta", clear
tab loan_database
tab loansettled loan_database
*keep if loansettled==0



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
* Verif
gen verif=marriageloanamount_HH-marriageloanamount_mar_HH-marriageloanamount_fin_HH
tab verif
drop verif

* Share marriage
gen marriageshare=marriageloanamount_HH*100/loanamount_HH
tab marriageshare

* Perc of increase
gen loanamount1000_HH=loanamount_HH/1000
gen marriageloanamount1000_HH=marriageloanamount_HH/1000
gen loanamount1000_nomar_HH=loanamount1000_HH-marriageloanamount1000_HH
tabstat loanamount1000_nomar_HH loanamount1000_HH, stat(n mean sd p1 p5 p10 q p90 p95 p99 min max)
gen percmarriage=(loanamount1000_HH-loanamount1000_nomar_HH)*100/loanamount1000_nomar_HH

tabstat loanamount1000_nomar_HH loanamount1000_HH percmarriage if dummyloanmarriage==1, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(caste)

tabstat loanamount1000_nomar_HH loanamount1000_HH percmarriage if dummyloanmarriage==1, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(sex)


* Perc of increase of DAR
gen DAR_with=loanamount_HH/assets
gen DAR_without=(loanamount_HH-marriageloanamount_HH)/assets

*gen percDAR=(DAR_with-DAR_without)*100/DAR_without

tabstat DAR_without DAR_with if dummyloanmarriage==1, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(caste)
tabstat DAR_without DAR_with if dummyloanmarriage==1, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max) by(sex)


****************************************
* END
