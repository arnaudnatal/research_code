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
* Cleaning label et var
****************************************
use"raw\NEEMSIS2-alters_networkpurpose", clear

* Label
label define dummyfam 0"No" 1"Yes"
label define friend 0"No" 1"Yes"
label define wkp 0"No" 1"Yes"
label define labourrelation 0"No" 1"Yes"
label define sex 1"Male" 2"Female"
label define age 1"15-25" 2"26-35" 3"36-45" 4"46-55" 5"56-65" 6"More than 65"
label define labourtype 1"Employer" 2"Colleague" 3"Maistry" 4"Supplier"
label define castes 1"Vanniyar" 2"SC" 3"Arunthathiyar" 4"Rediyar" 5"Gramani" 6"Naidu" 7"Navithar" 8"Asarai" 9"Settu" 10"Nattar" 11"Mudaliar" 12"Kulalar" 13"Chettiyar" 14"Marwari" 15"Muslims" 16"Padayachi" 88"D/K"
label define educ 1"Primary or below" 2"Upper primary" 3"High school" 4"Senior secondary" 5"Bachelor and above" 6"No education" 88"D/K"
label define employertype 1"State admin" 2"State-owned enterprise/farm" 3"Paid public works" 4"An individual" 5"Private firm or plant or farm" 6"Cooperative" 7"NGO" 77"Other"
label define living 1"Same neighborhood" 2"Same village" 3"Same district" 4"Another place in Tamil Nadu" 5"India" 6"Foreign country"
label define ruralurban 1"Urban area" 2"Rural area"
label define district 1"Ariyalur" 2"Chengalpet" 3"Chennai" 4"Coimbatore" 5"Cuddalore" 6"Dharmapuri" 7"Dindigul" 8"Erode" 9"Kallakurichi" 10"Kancheepuram" 11"Karur" 12"Krishnagiri" 13"Madurai" 14"Nagapattinam" 15"Kanyakumari" 16"Nagercoil" 17"Namakkal" 18"Perambalur" 19"Pudukottai" 20"Ramanathapuram" 21"Ranipet" 22"Salem" 23"Sivagangai" 24"Tenkasi" 25"Thanjavur" 26"Theni" 27"Thiruvallur" 28"Tuticorin" 29"Trichirappalli" 30"Thirunelveli" 31"Tirupattur" 32"Tiruppur" 33"Thiruvannamalai" 34"The Nilgiris" 35"Vellore" 36"Viluppuram" 37"Virudhunagar"
label define compared 1"Better situation" 2"Same situation" 3"Worst situation"
label define meet 1"Labour relation" 2"Neighbourhood relation" 3"Introduced by family" 4"Introduce by an acquaintance" 5"Classmate" 6"Through an asso" 77"Other"
label define meetfrequency 1"At least once a week" 2"At least once a month" 3"Every 2-3 months" 4"Every 4-6 months" 5"Once a year" 6"Less than once a year"
label define invite 0"No" 1"Yes"
label define reciprocity1 0"No" 1"Yes"
label define intimacy 1"Not intimate" 2"Intimate" 3"Very intimate"
order meetother, after(meet)
label define dummyhh 0"No" 1"Yes"
label define money 1"Very often" 2"Often" 3"Barely" 4"Never"


foreach x in dummyfam friend wkp labourrelation sex age labourtype castes educ employertype living ruralurban district compared meet meetfrequency invite reciprocity1 intimacy dummyhh money {
label values `x' `x'
}
drop assoid_v1 loanlender businesslender loanmarriageuse snlist typesn businessloanuse1 businessloanuse2 businessloanuse3 businessloanuse4 businessloanuse5 recruitworkeruse associationid assosnuse currentjobuse_ego1 currentjobuse_ego2 currentjobuse_ego3 futurejobuse_ego1 futurejobuse_ego2 futurejobuse_ego3 recommendforjobuse_ego1 recommendforjobuse_ego2 recommendforjobuse_ego3 recojobsuccessuse_ego1 recojobsuccessuse_ego2 recojobsuccessuse_ego3 talkthemostuse_ego1 talkthemostuse_ego2 talkthemostuse_ego3 medicalemergencyuse_ego1 medicalemergencyuse_ego2 medicalemergencyuse_ego3 closerelouthhuse_ego1 closerelouthhuse_ego2 closerelouthhuse_ego3 receivedhelpcov_ego1 receivedhelpcov_ego2 receivedhelpcov_ego3 givehelpcov_ego1 givehelpcov_ego2 givehelpcov_ego3 castesother

save"NEEMSIS2-alters_networkpurpose_v2", replace
****************************************
* END
















****************************************
* Correction alters
****************************************
/*
Il y a certains alters qui sont déclarés deux fois pour un même individu. Souvent, c'est lorsqu'il y a les prêteurs au milieu.

Je pars du principe que pour un égo donné, deux alters sont identiques s'ils ont toutes les mêmes caractéristiques.
Mais attention, si les prêteurs apparaissent plusieurs fois c'est parce qu'ils ont fourni plusieurs prêts, c'est une info importante à garder.
*/


* 1. Pour les prêteurs, je mets le nombre de prêt et les id sur toutes les lignes
use"NEEMSIS2-alters_networkpurpose_v2", clear

sort HHID2020 INDID2020 ALTERID
keep HHID2020 INDID2020 ALTERID namealter networkpurpose* dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother living ruralurban district livingname compared duration meet meetfrequency invite reciprocity1 intimacy loanid

keep if networkpurpose1==1
bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother living ruralurban district livingname compared duration meet meetfrequency invite reciprocity1 intimacy: gen n=_N 
order HHID2020 INDID2020 ALTERID namealter n
ta n
sort n HHID2020 INDID2020 namealter
compress
gen type=loanid
tostring type, replace
bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother living ruralurban district livingname compared duration meet meetfrequency invite reciprocity1 intimacy : replace type = type[_n-1] + "," + type if _n >= 2
by HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother living ruralurban district livingname compared duration meet meetfrequency invite reciprocity1 intimacy : replace type = type[_N] 
rename n nbloanperalter
drop loanid
rename type loanid
save"_temp1", replace

* 2. Pour les prêteurs, je vais voir la ligne que je garde lorsqu'il y a des doublons
use"NEEMSIS2-alters_networkpurpose_v2", clear
sort HHID2020 INDID2020 ALTERID
keep if networkpurpose1==1
drop loanid
merge 1:1 HHID2020 INDID2020 ALTERID using "_temp1", keepusing(nbloanperalter loanid)
drop _merge
order nbloanperalter, after(namealter)
compress
drop if ALTERID=="A2165"
drop if ALTERID=="A1648"
drop if ALTERID=="A2187"
drop if ALTERID=="A2185"
drop if ALTERID=="A2186"
drop if ALTERID=="A2141"
drop if ALTERID=="A146"
drop if ALTERID=="A498"
drop if ALTERID=="A497"
drop if ALTERID=="A394"
drop if ALTERID=="A395"
drop if ALTERID=="A397"
drop if ALTERID=="A2147"
drop if ALTERID=="A493"
drop if ALTERID=="A1925"
drop if ALTERID=="A2351"
drop if ALTERID=="A2976"
drop if ALTERID=="A2994"
drop if ALTERID=="A1233"
drop if ALTERID=="A1818"
drop if ALTERID=="A1817"
drop if ALTERID=="A1261"
drop if ALTERID=="A1260"
drop if ALTERID=="A2397"
drop if ALTERID=="A2398"
drop if ALTERID=="A2145"
drop if ALTERID=="A1213"
drop if ALTERID=="A324"
drop if ALTERID=="A944"
drop if ALTERID=="A2137"
drop if ALTERID=="A551"
drop if ALTERID=="A312"
drop if ALTERID=="A1509"
replace networkpurpose3=11 if ALTERID=="A2211"
drop if ALTERID=="A2213"
replace networkpurpose3=11 if ALTERID=="A1251"
drop if ALTERID=="A1252"
save "_tempalterpreteurs", replace


* 3. Je reprends l'ancienne base, j'enlève les prêteurs et je mets les prêteurs "corrigés"
use"NEEMSIS2-alters_networkpurpose_v2", clear
drop if networkpurpose1==1
drop loanid businessloanid marriageloanid
append using "_tempalterpreteurs"
save"NEEMSIS2-alters_networkpurpose_v3", replace


* 4. Je regarde les doublons dans leur intégralité
use"NEEMSIS2-alters_networkpurpose_v3", clear

bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother living ruralurban district livingname compared duration meet meetfrequency invite reciprocity1 intimacy: gen n=_N 
ta n
sort n HHID2020 INDID2020 namealter

replace networkpurpose2=11 if ALTERID=="F51"
drop if ALTERID=="K221"

replace networkpurpose3=11 if ALTERID=="F47"
drop if ALTERID=="K205"

replace networkpurpose3=11 if ALTERID=="F56"
drop if ALTERID=="K245"

drop n

save"NEEMSIS2-alters_networkpurpose_v4", replace


* 5. Je regarde les doublons sur un peu moins de caractéristiques
use"NEEMSIS2-alters_networkpurpose_v4", clear

bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother: gen n=_N 
order HHID2020 INDID2020 ALTERID namealter n
ta n
sort n HHID2020 INDID2020 namealter ALTERID

drop if ALTERID=="A185"
replace nbloanperalter=2 if ALTERID=="A183"
replace loanid="1,3" if ALTERID=="A183"

drop if ALTERID=="A2070"
replace nbloanperalter=2 if ALTERID=="A2071"
replace loanid="2,3" if ALTERID=="A2071"

drop if ALTERID=="A636"
replace nbloanperalter=2 if ALTERID=="A637"
replace loanid="6,7" if ALTERID=="A637"

drop if ALTERID=="A1289"
replace nbloanperalter=2 if ALTERID=="A1288"
replace loanid="1,2" if ALTERID=="A1288"

drop if ALTERID=="A919"
replace nbloanperalter=2 if ALTERID=="A921"
replace loanid="2,4" if ALTERID=="A921"

drop if ALTERID=="A2430"
replace nbloanperalter=2 if ALTERID=="A2429"
replace loanid="4,5" if ALTERID=="A2429"

drop if ALTERID=="A2120"
replace networkpurpose3=10 if ALTERID=="A2119"
replace nbloanperalter=2 if ALTERID=="A2119"
replace loanid="6,7" if ALTERID=="A2119"


drop if ALTERID=="L1918"
replace networkpurpose2=12 if ALTERID=="A1211"
replace money=3 if ALTERID=="A1211"

drop n
bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother: gen n=_N 
order HHID2020 INDID2020 ALTERID namealter n
ta n
sort n HHID2020 INDID2020 namealter ALTERID

replace n=1 if ALTERID=="A1529"
replace n=1 if ALTERID=="A1530"
replace n=1 if ALTERID=="A504"
replace n=1 if ALTERID=="A505"
replace n=1 if ALTERID=="A2271"
replace n=1 if ALTERID=="A2272"
replace n=1 if ALTERID=="A557"
replace n=1 if ALTERID=="A558"

* Je vais garder les doublons dans une base à part
preserve
drop if n==1
compress
/*
Il y a 8 alters qui ne sont pas exclusivement dans la base des prêts, donc eux je vais les recoder à la main.
Pour les autres, je vais faire la même procédure que dans le point 1.
Je vais recoder les 8 avant le preserve pour simplifier les changements après


Il y a aussi des faux doublons, je vais remplacer n par 1 pour éviter de les supprimer définitivement
*/
ta n

gen type=loanid
tostring type, replace
bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother : replace type = type[_n-1] + "," + type if _n >= 2
by HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex age labourtype castes educ occup employertype occupother : replace type = type[_N] 
rename loanid old
rename type loanid
drop nbloanperalter
rename n nbloanperalter
order nbloanperalter, before(loanid)
replace nbloanperalter=6 if ALTERID=="A392"
replace nbloanperalter=6 if ALTERID=="A393"
replace nbloanperalter=6 if ALTERID=="A396"

* Je supprime ici les "mauvais"
order nbloanperalter old, after(namealter)
drop if ALTERID=="A524"
drop if ALTERID=="A591"
drop if ALTERID=="A879"
drop if ALTERID=="A881"
drop if ALTERID=="A2203"
drop if ALTERID=="A2204"
drop if ALTERID=="A923"
drop if ALTERID=="A1258"
drop if ALTERID=="A393"
drop if ALTERID=="A396"
drop if ALTERID=="A2725"
drop if ALTERID=="A2334"
drop if ALTERID=="A1267"
drop if ALTERID=="A134"
drop if ALTERID=="A2787"
drop if ALTERID=="A457"
drop if ALTERID=="A455"
drop if ALTERID=="A1585"
drop if ALTERID=="A2940"
drop if ALTERID=="A2371"
drop if ALTERID=="A20"
drop if ALTERID=="A3351"
drop if ALTERID=="A1619"
drop if ALTERID=="A2093"
drop if ALTERID=="A2805"
drop old
save"_temp2", replace
restore
keep if n==1
drop n businessloanid marriageloanid
append using "_temp2"

save"NEEMSIS2-alters_networkpurpose_v5", replace



* 6. Encore un peu moins pour bien vérifier
use"NEEMSIS2-alters_networkpurpose_v5", clear

bysort HHID2020 INDID2020 namealter dummyfam friend wkp labourrelation sex occup: gen n=_N 
order HHID2020 INDID2020 ALTERID namealter n
ta n
sort n HHID2020 INDID2020 namealter ALTERID

replace n=1 if ALTERID=="J1870"
replace n=1 if ALTERID=="J1871"
replace n=1 if ALTERID=="A1749"
replace n=1 if ALTERID=="A1753"
replace n=1 if ALTERID=="A3581"
replace n=1 if ALTERID=="A3582"
replace n=1 if ALTERID=="L202"
replace n=1 if ALTERID=="L204"
replace n=1 if ALTERID=="A2271"
replace n=1 if ALTERID=="A2272"
replace n=1 if ALTERID=="J1721"
replace n=1 if ALTERID=="J1723"
replace n=1 if ALTERID=="A224"
replace n=1 if ALTERID=="A226"
replace n=1 if ALTERID=="A2885"
replace n=1 if ALTERID=="A2886"
replace n=1 if ALTERID=="A133"
replace n=1 if ALTERID=="A135"
replace n=1 if ALTERID=="A136"
replace n=1 if ALTERID=="A137"
replace n=1 if ALTERID=="A557"
replace n=1 if ALTERID=="A558"

drop if ALTERID=="A1530"
replace nbloanperalter=2 if ALTERID=="A1529"
replace loanid="1,2" if ALTERID=="A1529"

drop if ALTERID=="A542"
replace nbloanperalter=2 if ALTERID=="A540"
replace loanid="3,5" if ALTERID=="A540"

drop if ALTERID=="L3460"
replace networkpurpose2=12 if ALTERID=="A2109"
replace money=2 if ALTERID=="A2109"

drop if ALTERID=="A924"
replace nbloanperalter=3 if ALTERID=="A922"
replace loanid="1,2,3" if ALTERID=="A922"

drop if ALTERID=="K259"
replace networkpurpose2=11 if ALTERID=="G25"

drop if ALTERID=="A1276"
replace nbloanperalter=2 if ALTERID=="A1274"
replace loanid="2,4" if ALTERID=="A1274"

drop if ALTERID=="A1179"
replace nbloanperalter=2 if ALTERID=="A1177"
replace loanid="3,5" if ALTERID=="A1177"

drop if ALTERID=="G21"
replace networkpurpose3=7 if ALTERID=="K240"

drop if ALTERID=="G46"
replace networkpurpose2=7 if ALTERID=="K107"

drop if ALTERID=="G59"
replace networkpurpose2=7 if ALTERID=="K362"

drop if ALTERID=="G45"
replace networkpurpose2=7 if ALTERID=="K104"

drop if ALTERID=="G22"
replace networkpurpose2=7 if ALTERID=="K244"

drop if ALTERID=="G23"
replace networkpurpose2=7 if ALTERID=="K246"

drop if ALTERID=="A2149"
replace nbloanperalter=2 if ALTERID=="A2148"
replace loanid="2,3" if ALTERID=="A2148"

drop if ALTERID=="A505"
replace nbloanperalter=2 if ALTERID=="A504"
replace loanid="1,2" if ALTERID=="A504"

drop if ALTERID=="J1642"

drop if ALTERID=="A488"
replace nbloanperalter=2 if ALTERID=="A487"
replace loanid="6,7" if ALTERID=="A487"

drop if ALTERID=="A2977"
replace nbloanperalter=3 if ALTERID=="A2975"
replace loanid="4,5,6" if ALTERID=="A2975"

drop if ALTERID=="L3664"
replace networkpurpose2=12 if ALTERID=="A2491"

drop if ALTERID=="A2243"
replace nbloanperalter=2 if ALTERID=="A2242"
replace loanid="4,5" if ALTERID=="A2242"

drop if ALTERID=="A154"
replace nbloanperalter=2 if ALTERID=="A153"
replace loanid="2,3" if ALTERID=="A153"
replace networkpurpose5=10 if ALTERID=="A153"

drop if ALTERID=="F12"
replace networkpurpose3=6 if ALTERID=="A1214"
replace networkpurpose4=10 if ALTERID=="A1214"
replace dummyhh=0 if ALTERID=="A1214"
replace money=3 if ALTERID=="A1214"

drop if ALTERID=="A2174"
replace nbloanperalter=2 if ALTERID=="A2173"
replace loanid="2,3" if ALTERID=="A2173"

drop if ALTERID=="A2769"
replace nbloanperalter=2 if ALTERID=="A2768"
replace loanid="1,3" if ALTERID=="A2768"

drop if ALTERID=="A2139"
replace nbloanperalter=2 if ALTERID=="A2138"
replace loanid="4,5" if ALTERID=="A2138"

drop if ALTERID=="J2534"
replace networkpurpose3=14 if ALTERID=="J2532"

drop if ALTERID=="A2955"
replace nbloanperalter=2 if ALTERID=="A2953"
replace loanid="2,5" if ALTERID=="A2953"

drop if ALTERID=="A492"
replace nbloanperalter=2 if ALTERID=="A491"
replace loanid="3,4" if ALTERID=="A491"

drop if ALTERID=="A442"
replace nbloanperalter=2 if ALTERID=="A443"
replace loanid="9,10" if ALTERID=="A443"

drop if ALTERID=="A2210"
replace nbloanperalter=2 if ALTERID=="A2209"
replace loanid="1,2" if ALTERID=="A2209"

drop if ALTERID=="A1241"
replace nbloanperalter=2 if ALTERID=="A1240"
replace loanid="3,4" if ALTERID=="A1240"

drop n businessloanid marriageloanid
compress
drop phonenb
rename ALTERID alterid

save"NEEMSIS2-alters_networkpurpose_v6", replace

****************************************
* END










****************************************
* Finition des couples
****************************************
/*
- Vérifier les polygames avec Venkat
*/


* Vérifier qu'il y a bien 2 personnes dans un couple
* Enlever les veufs et veuves des couples.
* Changer label wife pour wife / husband

use"NEEMSIS2-couples", clear

ta couple maritalstatus

forvalues i=1/4 {
gen couple`i'=1 if couple==`i'
}

forvalues i=1/4 {
bysort HHID_panel: egen nbcouple`i'=sum(couple`i')
}

ta nbcouple4
sort nbcouple4 HHID_panel INDID_panel
order nbcouple4, after(couple)

drop nbcouple1 couple1 couple2 couple3 couple4 nbcouple2 nbcouple3 nbcouple4

fre relationshiptohead
codebook relationshiptohead
label define relationshipwithinhh 2"Wife/Husband", modify

* Recodage sex qui ne vont pas
replace sex=2 if HHID_panel=="NAT36" & INDID_panel=="Ind_2"
replace sex=1 if HHID_panel=="MANAM17" & INDID_panel=="Ind_3"
replace sex=2 if HHID_panel=="ORA7" & INDID_panel=="Ind_2"

save"NEEMSIS2-couples_v2", replace


* Vérifier que le statut marital match bien avec le couple
use"NEEMSIS2-couples_v2", clear

ta couple maritalstatus, m
gen tocheck=1 if maritalstatus==2 & couple==2
bysort HHID_panel: egen max=max(tocheck)
sort max HHID_panel INDID_panel

drop tocheck max


forvalues i=1/4 {
gen couple`i'=1 if couple==`i'
}

forvalues i=1/4 {
bysort HHID_panel: egen nbcouple`i'=sum(couple`i')
}
gen dummypolygamous=0 if couple!=.
replace dummypolygamous=1 if nbcouple1==3
drop couple1 couple2 couple3 couple4 nbcouple1 nbcouple2 nbcouple3 nbcouple4
label define yesno 0"No" 1"Yes"
label values dummypolygamous yesno
rename dummypolygamous polygamous
order polygamous, after(couple)

* Inside couple dummy
rename couple coupleid
gen couplegender=.
order couplegender, after(coupleid)
replace couplegender=1 if sex==1 & coupleid!=.
replace couplegender=2 if sex==2 & coupleid!=.
label define couplegender 1"Husband" 2"Wife"
label values couplegender couplegender

save"NEEMSIS2-couples_v3", replace



* Vérifier avec les morts et avec les migrants que les relations au chef sont bonnes
use"raw/NEEMSIS2-HH", clear

keep HHID2020 INDID2020 name age sex relationshiptohead dummylefthousehold livinghome maritalstatus

merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring INDID2020, replace

order HHID_panel INDID_panel, first
order HHID2020 INDID2020, last

sort HHID_panel INDID_panel

foreach x in dummylefthousehold name livinghome sex age relationshiptohead maritalstatus {
rename `x' HH_`x'
}

save"_tempall", replace

use"NEEMSIS2-couples_v3", clear

merge 1:1 HHID_panel INDID_panel using "_tempall", keepusing(HH_*)
sort HHID_panel INDID_panel

order HHID_panel INDID_panel name age sex relationshiptohead maritalstatus couple _merge HH_dummylefthousehold HH_livinghome HH_name HH_sex HH_age HH_relationshiptohead HH_maritalstatus

sort HHID_panel INDID_panel

compress

save"_tempall2", replace






* Polygames pour Venkat
use"NEEMSIS2-couples_v3", clear

* Merger village
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(address villagename villagearea)
keep if _merge==3
drop _merge

* Merger caste
gen year=2020
merge m:1 HHID_panel year using "raw/JatisCastePanel"
keep if _merge==3
drop _merge

forvalues i=1/4 {
gen couple`i'=1 if couple==`i'
}

forvalues i=1/4 {
bysort HHID_panel: egen nbcouple`i'=sum(couple`i')
}

ta nbcouple1
ta nbcouple2
ta nbcouple3
ta nbcouple4

keep if nbcouple1==3
sort HHID_panel INDID_panel

drop HHID2020 INDID2020 couple1 couple2 couple3 couple4 nbcouple1 nbcouple2 nbcouple3 nbcouple4

rename jatisn jatis
rename casten caste

drop year

export excel using "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Networks\Analysis\Polygamous.xlsx", firstrow(variables) replace



* Duplicates HH
use"NEEMSIS2-couples_v3", clear

keep if HHID_panel=="KUV65" | HHID_panel=="KOR47"
sort HHID_panel INDID2020


use"raw/NEEMSIS2-HH", clear

keep if HHID2020=="uuid:33a9630e-ba1c-421a-a540-643552c68906" | HHID2020=="uuid:ff95bdde-6012-4cf6-b7e8-be866fbaa68b"

keep HHID_panel INDID_panel name age sex relationshiptohead address villagename villagearea jatis username
rename username enumeratorname

compress

export excel using "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Networks\Analysis\SameHH.xlsx", firstrow(variables) replace



****************************************
* END


