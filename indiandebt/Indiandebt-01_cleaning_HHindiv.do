*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*Cleaning AIDIS
*-----
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
cd"C:\Users\anatal\Documents\id"
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

save "Loans_v1", replace
****************************************
* END


















****************************************
* Selection
****************************************
use "Loans_v1", clear

drop amount lender scheme duration reason security religion caste

order uniqueid HHID year Sector State District Weight caste religion HHsize loanid amount cat5amount cat3amount lender2 reason2 reason3 interest interest2 duration security2 scheme2

ta year

save "Loans_v2", replace
****************************************
* END
