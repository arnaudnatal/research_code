*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 2, 2025
*-----
gl link = "debtnetworks"
*Creation variables
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------

*cd"C:\Users\anatal\Documents\Ongoing_Networks_debt\Analysis"






****************************************
* Loan level
****************************************

********** SN Data
use"raw/NEEMSIS2-alters - VF", clear

* Selection
keep if networkpurpose1==1 | ///
networkpurpose2==1 | ///
networkpurpose3==1 | ///
networkpurpose4==1 | ///
networkpurpose5==1 | ///
networkpurpose6==1 | ///
networkpurpose7==1 | ///
networkpurpose8==1 | ///
networkpurpose9==1 | ///
networkpurpose10==1 | ///
networkpurpose11==1 | ///
networkpurpose12==1

drop networkpurpose1 networkpurpose2 networkpurpose3 networkpurpose4 networkpurpose5 networkpurpose6 networkpurpose7 networkpurpose8 networkpurpose9 networkpurpose10 networkpurpose11 networkpurpose12 money

* Caste
rename castes jatis
gen caste=1 if jatis==2 | jatis==3
replace caste=2 if inlist(jatis,1,5,7,8,10,12,15,16)
replace caste=3 if inlist(jatis,4,6,9,11,13,14)
replace caste=4 if inlist(jatis,66,88)
label define caste 1"Dalits" 2"Middle caste" 3"Upper caste" 4"Don't know", replace
label value caste caste
tab jatis caste 

* Var
global var HHID2020 INDID2020 loanid dummyfam friend wkp labourrelation sex age labourtype jatis educ occup employertype occupother living living ruralurban district livingname compared duration meet meetother meetfrequency invite reciprocity1 intimacy dummyhh hhmember nbloanperalter caste
keep $var 
order $var 
order nbloanperalter, after(loanid)
sort nbloanperalter
ta nbloanperalter

* 2 prêts
preserve
keep if nbloanperalter==2
expand 2
sort HHID2020 INDID2020 loanid
bysort HHID2020 INDID2020 loanid: gen n=_n
order HHID2020 INDID2020 loanid n
split loanid, p(,)
order loanid1 loanid2, after(loanid)
replace loanid=loanid1 if n==1
replace loanid=loanid2 if n==2
drop loanid1 loanid2 n
save"_tempsnlender_2", replace
restore


* 3 prêts
preserve
keep if nbloanperalter==3
expand 3
sort HHID2020 INDID2020 loanid
bysort HHID2020 INDID2020 loanid: gen n=_n
order HHID2020 INDID2020 loanid n
split loanid, p(,)
order loanid1 loanid2 loanid3, after(loanid)
replace loanid=loanid1 if n==1
replace loanid=loanid2 if n==2
replace loanid=loanid3 if n==3
drop loanid1 loanid2 loanid3 n
save"_tempsnlender_3", replace
restore


* 7 prêts
preserve
keep if nbloanperalter==7
expand 7
sort HHID2020 INDID2020 loanid
bysort HHID2020 INDID2020 loanid: gen n=_n
order HHID2020 INDID2020 loanid n
split loanid, p(,)
order loanid1 loanid2 loanid3 loanid4 loanid5 loanid6 loanid7, after(loanid)
replace loanid=loanid1 if n==1
replace loanid=loanid2 if n==2
replace loanid=loanid3 if n==3
replace loanid=loanid4 if n==4
replace loanid=loanid5 if n==5
replace loanid=loanid6 if n==6
replace loanid=loanid7 if n==7
drop loanid1 loanid2 loanid3 loanid4 loanid5 loanid6 loanid7 n
save"_tempsnlender_7", replace
restore


* Drop les prêteurs multiples et les ajouter à la main
drop if nbloanperalter>1
append using "_tempsnlender_2"
append using "_tempsnlender_3"
append using "_tempsnlender_7"

destring loanid, replace

* Rename
foreach x in dummyfam friend wkp labourrelation sex age labourtype jatis educ occup employertype occupother living ruralurban district livingname compared duration meet meetother meetfrequency invite reciprocity1 intimacy dummyhh hhmember caste {
rename `x' sn`x'
}

* Save
save"_tempsndata", replace






********** Loan Data
use"raw/NEEMSIS2-loans_mainloans_new", clear

keep if loan_database=="FINANCE"

keep HHID2020 INDID2020 loanid loanamount loanreasongiven loanlender guarantee dummyinterest dummyproblemtorepay dummyhelptosettleloan lender4 interestpaid2 totalrepaid2 principalpaid2 interestloan2 loanduration_month yratepaid monthlyinterestrate debt_service interest_service dummyinteret borrservices_free borrservices_work borrservices_supp borrservices_none borrservices_othe othlendserv_poli othlendserv_fina othlendserv_guar othlendserv_gene othlendserv_none othlendserv_othe guarantee_doc guarantee_chit guarantee_shg guarantee_pers guarantee_jewe guarantee_none guarantee_othe
sort HHID2020 INDID2020 loanid

* Save
save"_temploandata", replace




********** HH data
use"Main_analyses_v5", clear

keep HHID2020 INDID2020 age sex jatis caste relationshiptohead educ occupation annualincome_HH assets_total HHsize HH_count_child HH_count_adult typeoffamily waystem religion villageid occup married

* Covid
merge m:1 HHID2020 using "raw/NEEMSIS2-covid", keepusing(secondlockdownexposure)
keep if _merge==3
drop _merge
rename secondlockdownexposure covidexpo

* Save
save"_tempindivdata", replace



********** Merge
use"_temploandata",clear

merge 1:1 HHID2020 INDID2020 loanid using "_tempsndata"
keep if _merge==3
drop _merge

merge m:1 HHID2020 INDID2020 using "_tempindivdata"
keep if _merge==3
drop _merge

* Encode indivclust
egen hhindiv=group(HHID2020 INDID2020)
order hhindiv, first

save"Analysesloan_v1", replace
****************************************
* END













****************************************
* Loan level: creation variables
****************************************
use"Analysesloan_v1", clear

* Dummy main loans
gen dummymainloan=0
replace dummymainloan=1 if dummyproblemtorepay==0
replace dummymainloan=1 if dummyproblemtorepay==1
order dummymainloan, after(loanid)

********** Network size
* Multiple loan
gen dummymultipleloan=0 if nbloanperalter==1
replace dummymultipleloan=1 if nbloanperalter>1
ta nbloanperalter dummymultipleloan 
order dummymultipleloan, after(nbloanperalter)


********** Homophily
* Caste homophily
gen samecaste=.
label define samecaste 0"Same caste: No" 1"Same caste: Yes" 2"Same caste: DK"
label values samecaste samecaste
replace samecaste=0 if caste!=sncaste
replace samecaste=1 if caste==sncaste
replace samecaste=2 if sncaste==4

* Gender homophily
gen samesex=.
label define samesex 0"Same sex: No" 1"Same sex: Yes" 2"Same sex: DK"
label values samesex samesex
replace samesex=0 if sex!=snsex
replace samesex=1 if sex==snsex
replace samesex=2 if snsex==4

* Occupation homophily
gen sameoccup=.
label define sameoccup 0"Same occup: No" 1"Same occup: Yes" 2"Same occup: DK"
label values sameoccup sameoccup
fre occup
fre snoccup
replace occup=. if occup==12
replace snoccup=. if snoccup==9 | snoccup==10 | snoccup==12 | snoccup==77
replace sameoccup=0 if occup!=snoccup
replace sameoccup=1 if occup==snoccup
ta sameoccup

* Location homophily
fre snliving
gen samevillage=.
label define samevillage 0"Same village: No" 1"Same village: Yes"
label values samevillage samevillage
replace samevillage=1 if snliving==1
replace samevillage=1 if snliving==2
replace samevillage=0 if snliving==3
replace samevillage=0 if snliving==4
replace samevillage=0 if snliving==5
replace samevillage=0 if snliving==6
ta samevillage

********** Strength
* Duration
gen duration_cat=1 if snduration<5
replace duration_cat=2 if snduration>=5 & snduration<10
replace duration_cat=3 if snduration>=10 & snduration<15
replace duration_cat=4 if snduration>=15 & snduration<20
replace duration_cat=5 if snduration>=20 & snduration<25
replace duration_cat=6 if snduration>=25 & snduration<30
replace duration_cat=7 if snduration>=30 
tab duration_cat
ta snduration
replace snduration=50 if snduration>50
ta snduration

*Meet frequency : overall average + average by categories
tab	snmeetfrequency
gen meetfrequency_weekly=cond(snmeetfrequency==1,1,0)

*Intimacy
tab	snintimacy
gen very_intimate=cond(snintimacy==3,1,0)

*Invitation
tab	sninvite snreciprocity1 
gen invite_reciprocity=cond(sninvite==1 & snreciprocity1==1,1,0)

* Strenght 
mca duration_cat meetfrequency_weekly very_intimate invite_reciprocity, method(indicator) 
predict dim1
sum dim1
gen strength_mca=(dim1-`r(min)')/(`r(max)'-`r(min)')
sum strength_mca


********** Trap
fre loanreasongiven
gen dummytrap=0
replace dummytrap=1 if loanreasongiven==4

ta loanreasongiven dummytrap
ta dummytrap

********** Borrower services only for ML
fre borrservices_free borrservices_work borrservices_supp borrservices_none borrservices_othe
foreach x in borrservices_free borrservices_work borrservices_supp borrservices_none borrservices_othe {
replace `x'=. if dummymainloan==0
}
gen dummyborrowerservice=0 if borrservices_none==1
replace dummyborrowerservice=1 if borrservices_free==1
replace dummyborrowerservice=1 if borrservices_work==1
replace dummyborrowerservice=1 if borrservices_supp==1
replace dummyborrowerservice=1 if borrservices_othe==1

ta dummyborrowerservice borrservices_none
drop borrservices_free borrservices_work borrservices_supp borrservices_none borrservices_othe


********** Lender services
fre othlendserv_poli othlendserv_fina othlendserv_guar othlendserv_gene othlendserv_none othlendserv_othe

gen dummylenderservices=0
replace dummylenderservices=1 if othlendserv_poli==1
replace dummylenderservices=1 if othlendserv_guar==1
replace dummylenderservices=1 if othlendserv_gene==1
replace dummylenderservices=1 if othlendserv_othe==1

ta dummylenderservices othlendserv_poli
ta dummylenderservices othlendserv_fina
ta dummylenderservices othlendserv_guar
ta dummylenderservices othlendserv_gene
ta dummylenderservices othlendserv_othe
ta dummylenderservices othlendserv_none

drop othlendserv_poli othlendserv_fina othlendserv_guar othlendserv_gene othlendserv_none othlendserv_othe

ta dummylenderservices

********** Loan duration
replace loanduration_month=1 if loanduration<1


********** Prepa analysis
*
fre samecaste
recode samecaste (2=0)
fre samecaste

*
fre caste
recode caste (3=2)
fre caste

*
ta loanamount
replace loanamount=log(loanamount)

*
ta annualincome_HH
replace annualincome_HH=log(annualincome_HH)

*
ta assets_total
replace assets_total=log(assets_total)

* yes vs no guarantee
ta guarantee_none
ta guarantee
gen dummyguarantee=.
replace dummyguarantee=0 if guarantee_none==1
replace dummyguarantee=1 if guarantee_doc==1
replace dummyguarantee=1 if guarantee_chit==1
replace dummyguarantee=1 if guarantee_shg==1
replace dummyguarantee=1 if guarantee_pers==1
replace dummyguarantee=1 if guarantee_jewe==1
replace dummyguarantee=1 if guarantee_othe==1
label define dummyguarantee 0"Guarantee: No" 1"Guarantee: Yes"
label values dummyguarantee dummyguarantee
ta dummyguarantee guarantee_none

* If yes, materials vs trust-based
gen dummyg_mat=.
replace dummyg_mat=0 if dummyguarantee==0
replace dummyg_mat=0 if dummyguarantee==1
replace dummyg_mat=1 if guarantee_doc==1
replace dummyg_mat=1 if guarantee_jewe==1

ta dummyguarantee dummyg_mat


gen dummyg_trust=0 if dummyguarantee==1
replace dummyg_trust=1 if guarantee_chit==1
replace dummyg_trust=1 if guarantee_shg==1
replace dummyg_trust=1 if guarantee_pers==1

ta dummyguarantee
ta dummyg_mat dummyg_trust

ta dummyguarantee dummyg_trust
ta dummyguarantee dummyg_mat

drop guarantee guarantee_doc guarantee_chit guarantee_shg guarantee_pers guarantee_jewe guarantee_othe guarantee_none


save"Analysesloan_v2", replace
****************************************
* END






****************************************
* Sample size
****************************************
cls
use"raw/NEEMSIS2-loans_mainloans_new", clear

keep if loan_database=="FINANCE"

preserve
keep HHID2020
duplicates drop
count
restore

fre loanlender
gen inf=0
gen for=0

foreach i in 1 2 3 4 5 6 7 8 9 10 15 {
replace inf=1 if loanlender==`i'
}

foreach i in 11 12 13 14 {
replace for=1 if loanlender==`i'
}


bys HHID2020: egen sum_inf=sum(inf)
bys HHID2020: egen sum_for=sum(for)
keep HHID2020 sum_inf sum_for
duplicates drop
count
gen type=.
replace type=1 if sum_inf>0 & sum_for>0
replace type=2 if sum_inf>0 & sum_for==0
replace type=3 if sum_inf==0 & sum_for>0

ta type



****************************************
* END



