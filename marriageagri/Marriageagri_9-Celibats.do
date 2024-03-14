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
* Dataset construction
****************************************

***** 2016-17
use"raw/NEEMSIS1-HH", clear


keep HHID2016 INDID2016 age sex currentlyatschool maritalstatus livinghome lefthomereason

* Merge caste
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-caste"
keep if _merge==3
drop _merge

* Merge income
merge m:1 HHID2016 using "raw/NEEMSIS1-occup_HH", keepusing(annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

* Merge assets
merge m:1 HHID2016 using "raw/NEEMSIS1-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 assets_ownland)
drop _merge

* Merge education
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-education"
keep if _merge==3
drop _merge

* Merge occupation
merge 1:1 HHID2016 INDID2016 using "raw/NEEMSIS1-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
keep if _merge==3
drop _merge

* Merge HHID panel
merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID panel
tostring INDID2016, replace
merge 1:m HHID2016 INDID2016 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2016
drop HHID2016 INDID2016
order HHID_panel INDID_panel year

save"N1_celib", replace






***** 2020-21
use"raw/NEEMSIS2-HH", clear

keep HHID2020 INDID2020 age sex currentlyatschool maritalstatus livinghome lefthomereason dummylefthousehold reasonlefthome

* Merge caste
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-caste"
keep if _merge==3
drop _merge

* Merge income
merge m:1 HHID2020 using "raw/NEEMSIS2-occup_HH", keepusing(annualincome_HH shareincomeagri_HH shareincomenonagri_HH)
drop _merge

* Merge assets
merge m:1 HHID2020 using "raw/NEEMSIS2-assets", keepusing(assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 assets_ownland)
drop _merge

* Merge education
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-education"
keep if _merge==3
drop _merge

* Merge occupation
merge 1:1 HHID2020 INDID2020 using "raw/NEEMSIS2-occup_indiv", keepusing(working_pop mainocc_occupation_indiv mainocc_annualincome_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv)
keep if _merge==3
drop _merge

* Merge HHID panel
merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge

* Merge INDID panel
tostring INDID2020, replace
merge 1:m HHID2020 INDID2020 using "raw/keypanel-Indiv_wide", keepusing(INDID_panel)
keep if _merge==3
drop _merge

gen year=2020
drop HHID2020 INDID2020
order HHID_panel INDID_panel year

* Decode
decode lefthomereason, gen(ok)
drop lefthomereason
rename ok lefthomereason

save"N2_celib", replace


***** Formation
use"N1_celib", replace
fre lefthomereason

append using "N2_celib"

* Recode
recode currentlyatschool (.=0)
fre currentlyatschool

* Creation 
gen ownland=0
replace ownland=1 if assets_ownland!=. & assets_ownland!=0

ta ownland year, col nofreq
preserve
keep HHID_panel year ownland
duplicates drop
ta year
ta ownland year, col nofreq
restore

* Creation 2
label define divHH 1"Agricultural household" 2"Non-agricultural household" 3"Diversified household"
gen divHH0=.
replace divHH0=1 if shareincomeagri_HH==1
replace divHH0=2 if shareincomeagri_HH==0
replace divHH0=3 if shareincomeagri_HH!=0 & shareincomeagri_HH!=1 & shareincomeagri_HH!=.
label values divHH0 divHH
fre divHH0
gen divHH5=.
replace divHH5=1 if shareincomeagri_HH>=0.95
replace divHH5=2 if shareincomeagri_HH<=0.05
replace divHH5=3 if shareincomeagri_HH>0.05 & shareincomeagri_HH<0.95 & shareincomeagri_HH!=.
label values divHH5 divHH
fre divHH5
gen divHH10=.
replace divHH10=1 if shareincomeagri_HH>=0.9
replace divHH10=2 if shareincomeagri_HH<=0.1
replace divHH10=3 if shareincomeagri_HH>0.1 & shareincomeagri_HH<0.9 & shareincomeagri_HH!=.
label values divHH10 divHH
fre divHH10


save"Celibat", replace
****************************************
* END










****************************************
* Celibat
****************************************
use"Celibat", clear

* Selection
keep if sex==1
fre maritalstatus
drop if maritalstatus==3
drop if maritalstatus==4
drop if maritalstatus==5
sort HHID_panel INDID_panel year

* Only 25 or more
keep if age>=25
ta maritalstatus year

* Only 30 or more
keep if age>=30
ta maritalstatus year, col nofreq
ta caste maritalstatus, col nofreq chi2

ta currentlyatschool

ta edulevel maritalstatus, col nofreq chi2
ta edulevel maritalstatus, exp cchi2 chi2

ta working_pop maritalstatus, col nofreq chi2
ta working_pop maritalstatus, exp cchi2 chi2

ta mainocc_occupation_indiv maritalstatus, col nofreq chi2
ta mainocc_occupation_indiv maritalstatus, exp cchi2 chi2

ta ownland maritalstatus, col nofreq chi2
ta divHH10 maritalstatus, col nofreq chi2

tabstat annualincome_HH annualincome_indiv, stat(mean sd) by(maritalstatus)
reg annualincome_HH i.maritalstatus
reg annualincome_indiv i.maritalstatus


* Only single males
fre maritalstatus
keep if maritalstatus==2




****************************************
* END



