*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*Cleaning AIDIS
*-----
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*cd"C:\Users\anatal\Documents\id"
*-------------------------








****************************************
* HH / Indiv
****************************************
use "Loans_v1", clear

* Caste
tostring caste, replace

replace caste="ST" if caste=="1" & year==1992
replace caste="SC" if caste=="2" & year==1992
replace caste="Others" if caste=="9" & year==1992

replace caste="ST" if caste=="1" & year==2002
replace caste="SC" if caste=="2" & year==2002
replace caste="OBC" if caste=="3" & year==2002
replace caste="Others" if caste=="9" & year==2002

replace caste="ST" if caste=="1" & year==2012
replace caste="SC" if caste=="2" & year==2012
replace caste="OBC" if caste=="3" & year==2012
replace caste="Others" if caste=="9" & year==2012

replace caste="ST" if caste=="1" & year==2019
replace caste="SC" if caste=="2" & year==2019
replace caste="OBC" if caste=="3" & year==2019
replace caste="Others" if caste=="9" & year==2019

encode caste, gen(caste2)

gen caste3=.
label define caste3 1"Caste: SC/ST" 2"Caste: OBC" 3"Caste: Others"
label values caste3 caste3
replace caste3=3 if caste2==1
replace caste3=2 if caste2==2
replace caste3=3 if caste2==3
replace caste3=1 if caste2==4
replace caste3=1 if caste2==5

ta caste2 caste3

* Religion
tostring religion, replace

replace religion="" if year==1992

replace religion="Hindu" if religion=="1" & year==2002
replace religion="Muslim" if religion=="2" & year==2002
replace religion="Christian" if religion=="3" & year==2002
replace religion="Sikh" if religion=="4" & year==2002
replace religion="Jain" if religion=="5" & year==2002
replace religion="Buddhist" if religion=="6" & year==2002
replace religion="Zoro" if religion=="7" & year==2002
replace religion="Others" if religion=="9" & year==2002

replace religion="Hindu" if religion=="1" & year==2012
replace religion="Muslim" if religion=="2" & year==2012
replace religion="Christian" if religion=="3" & year==2012
replace religion="Sikh" if religion=="4" & year==2012
replace religion="Jain" if religion=="5" & year==2012
replace religion="Buddhist" if religion=="6" & year==2012
replace religion="Zoro" if religion=="7" & year==2012
replace religion="Others" if religion=="9" & year==2012

replace religion="Hindu" if religion=="1" & year==2019
replace religion="Muslim" if religion=="2" & year==2019
replace religion="Christian" if religion=="3" & year==2019
replace religion="Sikh" if religion=="4" & year==2019
replace religion="Jain" if religion=="5" & year==2019
replace religion="Buddhist" if religion=="6" & year==2019
replace religion="Zoro" if religion=="7" & year==2019
replace religion="Others" if religion=="9" & year==2019

encode religion, gen(religion2)
fre religion2

* Religion3
gen religion3=.
label define religion3 1"Reli: Hindu" 2"Reli: Muslim" 3"Reli: Christian" 4"Reli: Other"
label values religion3 religion3
replace religion3=4 if religion2==1
replace religion3=4 if religion2==2
replace religion3=3 if religion2==3
replace religion3=1 if religion2==4
replace religion3=4 if religion2==5
replace religion3=2 if religion2==6
replace religion3=4 if religion2==7
replace religion3=4 if religion2==8
replace religion3=4 if religion2==9

ta religion2 religion3



* State
/*
Nouveaux Etats qui n'existaient pas en 1992
"Uttarakhand"
"Jharkhand"
"Chhattisgarh"
"Telengana"
*/
destring State, replace
gen State_label=.
replace State_label=State if year==2002
replace State_label=State if year==2012
replace State_label=State if year==2019
label define State_label ///
1"Jammu & Kashmir" ///
2"Himanchal Pradesh" ///
3"Punjab" ///
4"Chandigarh" ///
5"Uttarakhand" ///
6"Haryana" ///
7"Delhi" ///
8"Rajasthan" ///
9"Uttar Pradesh" ///
10"Bihar" ///
11"Sikkim" ///
12"Arunachal Pradesh" ///
13"Nagaland" ///
14"Manipur" ///
15"Mizoram" ///
16"Tripura" ///
17"Meghalaya" ///
18"Assam" ///
19"West Bengal" ///
20"Jharkhand" ///
21"Orissa" ///
22"Chhattisgarh" ///
23"Madhya Pradesh" ///
24"Gujarat" ///
25"Daman & Diu" ///
26"Dadra & Nagar Haveli" ///
27"Maharastra" ///
28"Andhra Pradesh" ///
29"Karnataka" ///
30"Goa" ///
31"Lakshadweep" ///
32"Kerala" ///
33"Tamil Nadu" ///
34"Puducherry" ///
35"Andaman & Nicober Islands" ///
36"Telengana"
label values State_label State_label

gen State_label1992=.
replace State_label1992=State if year==1992
label define State_label1992 ///
2"Andhra Pradesh" ///
3"Assam" ///
4"Bihar" ///
5"Gujarat" ///
6"Haryana" ///
7"Himanchal Pradesh" ///
8"Jammu & Kashmir" ///
9"Karnataka" ///
10"Kerala" ///
11"Madhya Pradesh" ///
12"Maharastra" ///
13"Manipur" ///
14"Meghalaya" ///
15"Nagaland" ///
16"Orissa" ///
17"Punjab" ///
18"Rajasthan" ///
19"Sikkim" ///
20"Tamil Nadu" ///
21"Tripura" ///
22"Uttar Pradesh" ///
23"West Bengal" ///
24"Andaman & Nicober Islands" ///
25"Arunachal Pradesh" ///
26"Chandigarh" ///
27"Dadra & Nagar Haveli" ///
28"Delhi" ///
29"Goa" ///
30"Lakshadweep" ///
31"Mizoram" ///
32"Puducherry" ///
33"Daman & Diu" 
label values State_label1992 State_label1992

decode State_label1992, gen(State_label1992_dec)
decode State_label, gen(State_label_dec)
drop State_label1992 State_label
gen State_label=""
replace State_label=State_label1992_dec if year==1992
replace State_label=State_label_dec if year==2002
replace State_label=State_label_dec if year==2012
replace State_label=State_label_dec if year==2019
drop State_label1992_dec State_label_dec
ta State_label year, m

order State_label, after(State)
rename State State_nss
rename State_label State

* Sector
destring Sector, replace
label define Sector 1"Rural" 2"Urban"
label values Sector Sector
ta Sector

save "Loans_v2", replace
****************************************
* END


















****************************************
* Selection
****************************************
use "Loans_v2", clear

global loanvar loanid ///
amount2 amount3cat1 amount3cat2 amount3cat3 amount5cat1 amount5cat2 amount10cat1 ///
lender2 lender3 lender4 lender5 ///
reason2 reason4 reason5 reason7 ///
interest interest2 ///
duration2 security2 scheme2


keep uniqueid HHID year Sector State District Weight ///
caste3 religion3 HHsize ///
$loanvar

order uniqueid HHID year Sector State District Weight ///
caste3 religion3 HHsize ///
$loanvar

ta year

drop if interest==99

save "Loans_v3", replace
****************************************
* END
















****************************************
* Info supp (age, sexe, occ)
****************************************

***** 1992
use"raw/NSSO1992/Block 6_Visit 1_Household members and their activity particulars", clear
* Selection head
ta B6_q3
keep if B6_q3=="1"
* Age
rename B6_q4 age
* Sex
rename B6_q5 sex
destring sex, replace
label define sex 1"Sex: Male" 2"Sex: Female"
label values sex sex
* Education
rename B6_q6 educ
destring educ, replace
label define educ 1"Not literate" 2"Below primary" 3"Below secondary" 4"Secondary" 5"Graduate or more"
label values educ educ
* Occupation
rename B6_q8 activity
destring activity, replace
label define activity 11"SE" 21"SE coolie" 31"Regular" 41"Casual public" 51"Casual" 81"No occ but search" 91"In educ" 92"In domestic duties" 93"In domestic duties" 94"Renters, pension, remitt" 95"Disability" 96"Beggars, prostitute" 97"Others"
label values activity activity
ta activity
* Selection
keep HHID age sex educ activity
gen year=1992
gen head=1
order HHID year head age sex educ activity
*
foreach x in sex educ activity {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
*
save "_temp1992", replace


***** 2002
use"raw/NSSO2003/Visit 1 & 2 Combined_Block 4_demographic and other particulars of household members", clear
* Selection head
ta B4_q3
keep if B4_q3=="1"
* Age
rename B4_q5 age
* Sex
rename B4_q4 sex
destring sex, replace
label define sex 1"Sex: Male" 2"Sex: Female"
label values sex sex
* Education
rename B4_q7 educ
destring educ, replace
label define educ 1"Not literate" 2"Literate without schooling" 3"Below primary" 4"Primary" 5"Middle" 6"Secondary" 7"Higher secondary" 8"Diploma" 10"Graduate" 11"Postgraduate or more"
label values educ educ
* Occupation
rename B4_q8 activity
destring activity, replace
label define activity 11"SE" 12"SE employer" 21"SE coolie" 31"Regular" 41"Casual public" 51"Casual" 81"No occ but search" 91"In educ" 92"In domestic duties" 93"In domestic duties" 94"Renters, pension, remitt" 95"Disability" 96"Beggars, prostitute" 97"Others" 98"Sickness"
label values activity activity
ta activity
* Maritalstatus
rename B4_q6 maritalstatus
destring maritalstatus, replace
label define maritalstatus 1"Status: Unmarried" 2"Status: Married" 3"Status: Widowed" 4"Status: Divorced"
label values maritalstatus maritalstatus
* Selection
keep HHID age sex educ activity maritalstatus
gen year=2002
gen head=1
order HHID year head age sex educ activity maritalstatus
*
foreach x in sex educ activity maritalstatus {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
*
save "_temp2002", replace


***** 2012
use"raw/NSSO2013/Visit 1 _Block 4_Demographic and other particulars of household members", clear
* Selection head
ta b4q3
keep if b4q3=="1"
* Age
rename b4q5 age
* Sex
rename b4q4 sex
destring sex, replace
label define sex 1"Sex: Male" 2"Sex: Female"
label values sex sex
* Education
rename b4q6 educ
destring educ, replace
label define educ 1"Not literate" 2"Literate without schooling" 3"Literate without schooling" 4"Literate without schooling" 5"Below primary" 6"Primary" 7"Middle" 8"Secondary" 10"Higher secondary" 11"Diploma" 12"Graduate" 13"Postgraduate or more"
label values educ educ
* Worker
rename b4q7 worker
destring worker, replace
label define worker 1"Worker: Yes" 2"Worker: No"
label values worker worker
* Occupation
rename b4q8 activity
destring activity, replace
label define activity 11"SE" 12"SE employer" 21"SE coolie" 31"Regular" 41"Casual public" 51"Casual"
label values activity activity
ta activity
* Selection
keep HHID age sex educ worker activity
gen year=2012
gen head=1
order HHID year head age sex educ worker activity
*
foreach x in sex educ worker activity {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
*
save "_temp2012", replace


***** 2019
use"raw/NSSO2019/Visit1  Level - 02 (Block 3) - Demographic and other particulars of household members", clear
* Selection head
ta b3q3
keep if b3q3=="1"
* Age
rename b3q5 age
* Sex
rename b3q4 sex
destring sex, replace
label define sex 1"Sex: Male" 2"Sex: Female"
label values sex sex
* Education
rename b3q6 educ
destring educ, replace
label define educ 1"Not literate" 2"Below primary" 3"Primary" 4"Middle" 5"Secondary" 6"Higher secondary" 7"Diploma (upto sec)" 8"Diploma (higher sec)" 10"Diploma (graduation above)" 11"Graduate" 12"Postgraduate or more"
label values educ educ
* Selection
keep HHID age sex educ
gen year=2019
gen head=1
order HHID year head age sex educ
*
foreach x in sex educ {
decode `x', gen(`x'_dec)
drop `x'
rename `x'_dec `x'
}
*
save "_temp2019", replace

***** Append
use"_temp1992", clear
append using "_temp2002"
append using "_temp2012"
append using "_temp2019"

* Sex
ta sex
encode sex, gen(sex_enc)
drop sex
rename sex_enc sex

* Marital status
ta maritalstatus
encode maritalstatus, gen(maritalstatus_enc)
drop maritalstatus
rename maritalstatus_enc maritalstatus

* Education
ta educ
gen educ2=.
label define educ2 0"No school" 1"Below primary" 2"Below secondary" 3"Secondary" 4"Graduate or more", replace
label values educ2 educ2
replace educ2=0 if educ=="Not literate"
replace educ2=0 if educ=="Literate without schooling"

replace educ2=1 if educ=="Below primary"

replace educ2=2 if educ=="Below secondary"
replace educ2=2 if educ=="Primary"
replace educ2=2 if educ=="Middle"

replace educ2=3 if educ=="Secondary"
replace educ2=3 if educ=="Diploma"
replace educ2=3 if educ=="Diploma (upto sec)"
replace educ2=3 if educ=="Diploma (higher sec)"
replace educ2=3 if educ=="Higher secondary"

replace educ2=4 if educ=="Diploma (graduation above)"
replace educ2=4 if educ=="Graduate or more"
replace educ2=4 if educ=="Graduate"
replace educ2=4 if educ=="Postgraduate"
replace educ2=4 if educ=="Postgraduate or more"

* Employment
ta activity
ta worker
gen occ=.
label define occ 0"Occ: No" 1"Occ: Self-emp" 2"Occ: Casual" 3"Occ: Regular" 4"Occ: Other"
label values occ occ
replace occ=0 if worker=="Worker: No"
replace occ=0 if activity=="Disability"
replace occ=0 if activity=="In domestic duties"
replace occ=0 if activity=="In educ"
replace occ=0 if activity=="No occ but search"
replace occ=0 if activity=="Renters, pension, remitt"
replace occ=0 if activity=="Disability"
replace occ=1 if activity=="SE"
replace occ=2 if activity=="Casual"
replace occ=2 if activity=="Casual public"
replace occ=3 if activity=="Regular"
replace occ=4 if activity=="Others"
replace occ=4 if activity=="Beggars, prostitute"
replace occ=4 if activity=="SE coolie"
replace occ=4 if activity=="SE employer"

* Head
label define head 0"Head: No" 1"Head: Yes"
label values head head

* Selection
keep HHID year head age sex maritalstatus educ2 occ

* Duplicates
bys HHID year: gen N=_N
bys HHID year: gen n=_n
ta N
preserve
drop if N==1
bys HHID year: egen maxage=max(age)
keep if maxage==age
drop if HHID=="3466532" & year==1992 & n==1
drop N n maxage
save"_temp", replace
restore

*
drop n
keep if N==1
append using "_temp"
drop N

sort HHID year

save"_tempindiv", replace
****************************************
* END











****************************************
* Merge indiv
****************************************
use "Loans_v3", clear

merge m:1 HHID year using "_tempindiv"
drop if _merge==2
ta _merge

order head age sex maritalstatus educ2 occ _merge, after(HHsize)

keep if _merge==3
drop _merge

* Age
ta age
gen agecat=.
label define agecat 1"Less than 30" 2"30 to 39" 3"40 to 49" 4"50 to 59" 5"60 or more"
label values agecat agecat
replace agecat=1 if age<=29
replace agecat=2 if age>=30 & age<=39
replace agecat=3 if age>=40 & age<=49
replace agecat=4 if age>=50 & age<=59
replace agecat=5 if age>=60
ta age agecat
ta agecat, m
order agecat, after(age)

save "Loans_v4", replace
****************************************
* END




