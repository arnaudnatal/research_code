*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*February 22, 2023
*-----
gl link = "marriageagri"
*Analysis NEEMSIS-2 marriage
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\marriageagri.do"
*-------------------------




/*****************************************************

TITLE:
The political and sexual economies of marriages. Two decades of change in South-Arcot, South India

AUTHORS:
I. Guérin, A. Natal, C. J. Nordman, and G. Venkatasubramanian

JOURNAL:
Contemporary South Asia

ABSTRACT:
This chapter explores the multifaceted role of marriages in the south-Arcot region of central Tamil Nadu.
There are cases of forced celibacy, but they remain isolated.
By mobilising twenty years of ethnographic survey, and three household surveys conducted in 2010, 2016-17 and 2020-21, including questions on marriages (who marries whom? at what cost? with a dowry and if so how much?), this paper will examine how marriages are both shaped by and constitutive of local political and sexual economies. 
By local political and sexual economies, we mean the intertwining of access to material resources, norms of kinship and deviant sexuality.
As feminist anthropology has long shown, modes of accumulation, kinship and sexuality are inseparable and mutually constructed.
The drastic and interconnected changes observed over the last two decades in modes of production, marital alliances and the control of female sexuality are a clear illustration of this.
Our data suggest two main findings, which explains the reasons behind low prevalence of forced celibacy, while highlighting the intensification of patriarchal norms: First, marriages and marital transfers (primarily dowry) play a crucial role in compensating for a volatile economy, whether it is agricultural decline (with the exception of the pandemic period, agricultural incomes are declining, both in absolute and relative terms), a precarious and uncertain non-farm labour market, and costly and risky investments in education (of boys in particular) and expensive housing expenditures.
In turn, and this is our second argument, the dowry, which is a recent practice among the lower castes and classes, strongly devalues the economic value of young girls and is accompanied by increasing control over women's bodies and sexuality as a symbol of upward mobility.
The paper will also examine the differences between families that remained solely peasant and those that diversified, exploring the role of marriages and marriage payments in these differentiated strategies.

KEYWORDS:
Marriage, kinship, sexuality, economy, Tamil Nadu

STATISTICAL ANALYSIS:
1. Who maries whom?
2. At what cost?
3. What about dowry?
4. Marital transfers (primarily dowry) play a crucial role in compensating for a volatile economy, i.e. agricultural decline, uncertain non-farm labour market, risky investment in education of boys, expensive housing expenditures
5. Dowry as a symbol of upward mobility
6. Differences between families that remained solely peasant and those that diversified, exploring the role of marriages and marriage payments in these differentiated strategies

*****************************************************/









****************************************
* Loan level
****************************************

***** 2016-17
use"raw/NEEMSIS1-loans_mainloans_new", clear

keep HHID2016 INDID2016 loanid loanreasongiven loanamount2 loanbalance2
gen year=2016

save"_temploan2016", replace

bysort HHID2016: egen balance_total_HH=sum(loanbalance2)
fre loanreasongiven
gen balance_marr=0
replace balance_marr=loanbalance2 if loanreasongiven==8
bysort HHID2016: egen balance_marr_HH=sum(balance_marr)

keep HHID2016 balance_marr_HH balance_total_HH
duplicates drop
save"_temp2016", replace



***** 2020-21
use"raw/NEEMSIS2-loans_mainloans_new", clear

keep HHID2020 INDID2020 loanid loanreasongiven loanamount2 loanbalance2
gen year=2020

save"_temploan2020", replace

bysort HHID2020: egen balance_total_HH=sum(loanbalance2)
fre loanreasongiven
gen balance_marr=0
replace balance_marr=loanbalance2 if loanreasongiven==8
bysort HHID2020: egen balance_marr_HH=sum(balance_marr)

keep HHID2020 balance_marr_HH balance_total_HH
duplicates drop
save"_temp2020", replace



***** Pooled
use"_temploan2016", clear
append using "_temploan2020"

replace loanamount2=loanamount2*(100/116) if year==2020

save"pooledloans", replace
****************************************
* END











****************************************
* HH level
****************************************

***** 2016-17
use"raw/NEEMSIS1-HH", clear

keep HHID2016 dummymarriage
duplicates drop
merge 1:1 HHID2016 using "_temp2016"
drop _merge
merge 1:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH)
drop _merge
merge 1:1 HHID2016 using "raw/NEEMSIS1-loans_HH", keepusing(nbHH_given_marr dumHH_given_marr nbHH_effective_marr dumHH_effective_marr totHH_givenamt_marr totHH_effectiveamt_marr nbloans_HH loanamount_HH)
drop _merge
merge 1:m HHID2016 using "raw/NEEMSIS1-caste", keepusing(caste)
drop _merge
duplicates drop
merge 1:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
gen year=2016
drop _merge HHID2016
order HHID_panel year caste dummymarriage

save"_tempdebtmar2016", replace


***** HH level
use"raw/NEEMSIS2-HH", clear

keep HHID2020 dummymarriage
duplicates drop
merge 1:1 HHID2020 using "_temp2020"
drop _merge
merge 1:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH)
drop _merge
merge 1:1 HHID2020 using "raw/NEEMSIS2-loans_HH", keepusing(nbHH_given_marr dumHH_given_marr nbHH_effective_marr dumHH_effective_marr totHH_givenamt_marr totHH_effectiveamt_marr nbloans_HH loanamount_HH)
drop _merge
merge 1:m HHID2020 using "raw/NEEMSIS2-caste", keepusing(caste)
drop _merge
duplicates drop
merge 1:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
gen year=2020
drop _merge HHID2020
order HHID_panel year caste dummymarriage

save"_tempdebtmar2020", replace


***** Pooled
use"_tempdebtmar2016", clear

append using "_tempdebtmar2020"
sort HHID_panel year

gen sharedebtgivenmarr=totHH_givenamt_marr*100/loanamount_HH
gen sharedebteffecmarr=totHH_effectiveamt_marr*100/loanamount_HH
gen shareincogivenmarr=totHH_givenamt_marr*100/annualincome_HH
gen shareincoeffecmarr=totHH_effectiveamt_marr*100/annualincome_HH

gen sharebaldebtmarr=balance_marr_HH*100/balance_total_HH
gen sharebalincomarr=balance_marr_HH*100/annualincome_HH

foreach x in annualincome_HH loanamount_HH totHH_givenamt_marr totHH_effectiveamt_marr {
replace `x'=`x'*(100/116) if year==2020
}

save"pooleddebtmar", replace
****************************************
* END













****************************************
* Stat
****************************************

********** Loan
use"pooledloans", clear

ta loanreasongiven
tabstat loanamount2, stat(n mean q) by(loanreasongiven)

/*
In pooled setting:
- 13% of loans are for marriage.
- Average amount of INR 80k.
*/




********** HH
use"pooleddebtmar", clear


tabstat sharedebtgivenmarr sharedebteffecmarr shareincogivenmarr shareincoeffecmarr sharebaldebtmarr sharebalincomarr totHH_givenamt_marr totHH_effectiveamt_marr annualincome_HH balance_total_HH loanamount_HH, stat(n mean q) by(dummymarriage) long

tabstat sharebalincomarr if dummymarriage==1, stat(n mean q p90 p95 p99 max) long

tabstat sharebalincomarr if dummymarriage==1 & sharebalincomarr<1000, stat(n mean q p90 p95 p99 max) long



reg loanamount_HH i.dummymarriage

/*
In pooled setting:
- Marriage debt represents 32% of household total debt for household who experienced a marriage of one of their member, while it represents less than 5% for other households.
- Marriage debt represents 147% of household total income for household who experienced a marriage of one of their member.
*/
****************************************
* END
