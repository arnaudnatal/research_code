*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Stat desc corr
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* Correlation families : LFP
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
keep HHID_panel INDID_panel year relationshiptohead2 work
fre relationshiptohead2

* Var tot 
bysort HHID_panel year relationshiptohead2: egen sum_rel=sum(1)
ta sum_rel

* Var LFP
bysort HHID_panel year relationshiptohead2: egen sum_LFP=sum(work)
ta sum_LFP

* Share LFP
gen shareLFP=sum_LFP/sum_rel

* Selection
keep HHID_panel year relationshiptohead2 sum_rel sum_LFP shareLFP
duplicates drop
ta year
sort HHID_panel year relationshiptohead2

* Reshape
drop sum_rel sum_LFP
rename shareLFP var
reshape wide var, i(HHID_panel year) j(relationshiptohead2)
rename var1 Head
rename var2 Wife
rename var3 Parents
rename var4 Son
rename var5 Daughter
rename var6 Son_in_law
rename var7 Daughter_in_law
rename var8 Siblings
rename var9 Grandchild
rename var10 Others

* Table
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.01)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.05)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.1)

****************************************
* END














****************************************
* Correlation families : hours
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if hoursayear_indiv==.
keep HHID_panel INDID_panel year relationshiptohead2 hoursayear_indiv
fre relationshiptohead2

* Selection
keep HHID_panel year relationshiptohead2 hoursayear_indiv
duplicates drop
ta year
sort HHID_panel year relationshiptohead2

* Var tot 
bysort HHID_panel year relationshiptohead2: egen sum_hours=sum(hoursayear_indiv)

* Selection
keep HHID_panel year relationshiptohead2 sum_hours
duplicates drop
ta year
sort HHID_panel year relationshiptohead2


* Reshape
rename sum_hours var
reshape wide var, i(HHID_panel year) j(relationshiptohead2)
rename var1 Head
rename var2 Wife
rename var3 Parents
rename var4 Son
rename var5 Daughter
rename var6 Son_in_law
rename var7 Daughter_in_law
rename var8 Siblings
rename var9 Grandchild
rename var10 Others

* Table
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.01)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.05)
pwcorr Head Wife Parents Son Daughter Son_in_law Daughter_in_law Siblings Grandchild Others, star(0.1)


****************************************
* END











****************************************
* Correlation families : occupations
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if work==0
keep HHID_panel INDID_panel year relationshiptohead2 mainocc_occupation_indiv
fre relationshiptohead2
rename mainocc_occupation_indiv occupation
fre occupation

* Var tot 
bysort HHID_panel year relationshiptohead2: egen sum_rel=sum(1)
ta sum_rel

* Var occ
ta occupation, gen(occ)
forvalues i=1/7 {
bysort HHID_panel year relationshiptohead2: egen sum_occ`i'=sum(occ`i')
}

* Share occ
forvalues i=1/7{
gen share_occ`i'=(sum_occ`i'/sum_rel)*100
}


* Selection
keep HHID_panel year relationshiptohead2 share_occ1 share_occ2 share_occ3 share_occ4 share_occ5 share_occ6 share_occ7
duplicates drop
ta year
sort HHID_panel year relationshiptohead2

* Reshape
rename share_occ1 agrise 
rename share_occ2 agrica
rename share_occ3 casual
rename share_occ4 regnon
rename share_occ5 regqua
rename share_occ6 selfem
rename share_occ7 mgnreg

reshape wide agrise agrica casual regnon regqua selfem mgnreg, i(HHID_panel year) j(relationshiptohead2)

foreach x in agrise agrica casual regnon regqua selfem mgnreg {
rename `x'1 hea_`x'
rename `x'2 wif_`x'
rename `x'3 par_`x'
rename `x'4 son_`x'
rename `x'5 dau_`x'
rename `x'6 sil_`x'
rename `x'7 dil_`x'
rename `x'8 sib_`x'
rename `x'9 gra_`x'
rename `x'10 oth_`x'
}


* Table
global varhea hea_agrise hea_agrica hea_casual hea_regnon hea_regqua hea_selfem hea_mgnreg
global varwif wif_agrise wif_agrica wif_casual wif_regnon wif_regqua wif_selfem wif_mgnreg
global varpar par_agrise par_agrica par_casual par_regnon par_regqua par_selfem par_mgnreg
global varson son_agrise son_agrica son_casual son_regnon son_regqua son_selfem son_mgnreg
global vardau dau_agrise dau_agrica dau_casual dau_regnon dau_regqua dau_selfem dau_mgnreg
global varsil sil_agrise sil_agrica sil_casual sil_regnon sil_regqua sil_selfem sil_mgnreg
global vardil dil_agrise dil_agrica dil_casual dil_regnon dil_regqua dil_selfem dil_mgnreg
global varsib sib_agrise sib_agrica sib_casual sib_regnon sib_regqua sib_selfem sib_mgnreg
global vargra gra_agrise gra_agrica gra_casual gra_regnon gra_regqua gra_selfem gra_mgnreg
global varoth oth_agrise oth_agrica oth_casual oth_regnon oth_regqua oth_selfem oth_mgnreg
global var $varhea $varwif $varpar $varson $vardau $varsil $vardil $varsib $vargra $varoth


cls
cpcorr $varhea \ $varwif, f(%4.2f)
cpcorr $varhea \ $varpar, f(%4.2f)
cpcorr $varhea \ $varson, f(%4.2f)
cpcorr $varhea \ $vardau, f(%4.2f)
cpcorr $varhea \ $varsil, f(%4.2f)
cpcorr $varhea \ $vardil, f(%4.2f)
cpcorr $varhea \ $varsib, f(%4.2f)
cpcorr $varhea \ $vargra, f(%4.2f)
cpcorr $varhea \ $varoth, f(%4.2f)

cpcorr $varwif \ $varpar, f(%4.2f)
cpcorr $varwif \ $varson, f(%4.2f)
cpcorr $varwif \ $vardau, f(%4.2f)
cpcorr $varwif \ $varsil, f(%4.2f)
cpcorr $varwif \ $vardil, f(%4.2f)
cpcorr $varwif \ $varsib, f(%4.2f)
cpcorr $varwif \ $vargra, f(%4.2f)
cpcorr $varwif \ $varoth, f(%4.2f)

cpcorr $varpar \ $varson, f(%4.2f)
cpcorr $varpar \ $vardau, f(%4.2f)
cpcorr $varpar \ $varsil, f(%4.2f)
cpcorr $varpar \ $vardil, f(%4.2f)
cpcorr $varpar \ $varsib, f(%4.2f)
cpcorr $varpar \ $vargra, f(%4.2f)
cpcorr $varpar \ $varoth, f(%4.2f)

cpcorr $varson \ $vardau, f(%4.2f)
cpcorr $varson \ $varsil, f(%4.2f)
cpcorr $varson \ $vardil, f(%4.2f)
cpcorr $varson \ $varsib, f(%4.2f)
cpcorr $varson \ $vargra, f(%4.2f)
cpcorr $varson \ $varoth, f(%4.2f)

cls
pwcorr $var

cls
pwcorr $var, star(0.01)

cls
pwcorr $var, star(0.05)

cls
pwcorr $var, star(0.1)

****************************************
* END


















****************************************
* Correlation families : occupations MCA
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if work==0
keep HHID_panel year relationshiptohead2 mainocc_occupation_indiv
fre relationshiptohead2
rename mainocc_occupation_indiv occupation
rename relationshiptohead2 relation
bysort HHID_panel year relation: gen n=_n

egen relan=group(relation n), label
drop relation n

reshape wide occupation, i(HHID_panel year) j(relan)


* Chi2
cls
forvalues i=1/25 {
local j=`i'+1
forvalues k=`j'/25 {
ta occupation`i' occupation`k', chi2
}
}

****************************************
* END










****************************************
* Correlation sex : occupations
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
drop if work==0
keep HHID_panel INDID_panel year sex mainocc_occupation_indiv
fre sex
rename mainocc_occupation_indiv occupation
fre occupation

* Var tot 
bysort HHID_panel year sex: egen sum_rel=sum(1)
ta sum_rel

* Var occ
ta occupation, gen(occ)
forvalues i=1/7 {
bysort HHID_panel year sex: egen sum_occ`i'=sum(occ`i')
}

* Share occ
forvalues i=1/7{
gen share_occ`i'=(sum_occ`i'/sum_rel)*100
}


* Selection
keep HHID_panel year sex share_occ1 share_occ2 share_occ3 share_occ4 share_occ5 share_occ6 share_occ7
duplicates drop
ta year
sort HHID_panel year sex

* Reshape
rename share_occ1 agrise 
rename share_occ2 agrica
rename share_occ3 casual
rename share_occ4 regnon
rename share_occ5 regqua
rename share_occ6 selfem
rename share_occ7 mgnreg

reshape wide agrise agrica casual regnon regqua selfem mgnreg, i(HHID_panel year) j(sex)

foreach x in agrise agrica casual regnon regqua selfem mgnreg {
rename `x'1 male_`x'
rename `x'2 fema_`x'
}


* Table
global varmale male_agrise male_agrica male_casual male_regnon male_regqua male_selfem male_mgnreg
global varfema fema_agrise fema_agrica fema_casual fema_regnon fema_regqua fema_selfem fema_mgnreg
global var $varmale $varfema

* 2016-17
cls
cpcorr $varmale \ $varfema if year==2016, f(%4.2f)
matrix pval=r(p)
matrix list pval

* 2020-21
cls
cpcorr $varmale \ $varfema if year==2020, f(%4.2f)
matrix pval=r(p)
matrix list pval

* Pooled
cls
cpcorr $varmale \ $varfema, f(%4.2f)
matrix pval=r(p)
matrix list pval

****************************************
* END





















****************************************
* Correlation couples
****************************************
use"panel_laboursupplyindiv_v2", clear

* Selection
ta year
drop if age<14
keep HHID_panel INDID_panel year relationshiptohead2 work hoursayear_indiv mainocc_occupation_indiv annualincome_indiv nboccupation_indiv
fre relationshiptohead2

* Keep head and wife
keep if relationshiptohead2==1 | relationshiptohead2==2

* Check duplicates head
ta relationshiptohead2, gen(rela)
forvalues i=1/2 {
bysort HHID_panel year: egen sum_rela`i'=sum(rela`i')
drop rela`i'
}
drop if sum_rela1==0 
drop if sum_rela2==0
drop if sum_rela1==2
drop if sum_rela2==2
drop sum_rela1 sum_rela2

* Reshape
reshape wide INDID_panel mainocc_occupation_indiv annualincome_indiv nboccupation_indiv hoursayear_indiv work, i(HHID_panel year) j(relationshiptohead2)
ta year



********* Labour characteristics
* Decision to work
ta work1 work2, chi2 exp cchi2

* Main occupation
ta mainocc_occupation_indiv1 mainocc_occupation_indiv2, chi2 exp cchi2

* Nb of occupation
pwcorr nboccupation_indiv1 nboccupation_indiv2, sig

* Labour supply
pwcorr hoursayear_indiv1 hoursayear_indiv2, sig

* Income
pwcorr annualincome_indiv1 annualincome_indiv2, sig


****************************************
* END
