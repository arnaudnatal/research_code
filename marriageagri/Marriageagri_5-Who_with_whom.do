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










****************************************
* Who's married?
****************************************
cls

********** NEEMSIS-1 (2016-17)
use"NEEMSIS1-marriage_v2.dta", clear
keep if married==1

* Socio-demo
ta sex
tabstat age, stat(n mean q) by(sex)
ta caste sex, col nofreq

* Edu
ta canread sex, col nofreq
ta everattendedschool sex, col nofreq
ta currentlyatschool sex
ta edulevel sex, col nofreq

* Labour
ta working_pop sex
recode mainocc_occupation_indiv (.=0)
ta mainocc_occupation_indiv sex, col nofreq



********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5.dta", clear

* Socio-demo
ta sex
tabstat age, stat(n mean q) by(sex)
ta caste sex, col nofreq

* Edu
ta canread sex
ta everattendedschool sex
ta currentlyatschool sex
ta edulevel sex, col nofreq

* Labour
ta working_pop sex
recode mainocc_occupation_indiv (.=0)
ta mainocc_occupation_indiv sex, col nofreq





********** Panel
use"NEEMSIS-marriage.dta", clear

ta sex
ta caste sex, col nofreq
tabstat age, stat(n mean p50) by(sex)
ta edulevel sex, col nofreq
ta working_pop sex, col nofreq
ta mainocc_occupation_indiv sex, col nofreq


****************************************
* END

















****************************************
* Whith whom? -1
****************************************
cls

********** NEEMSIS-1 (2016-17)
use"NEEMSIS1-marriage_v3", clear
keep if married==1

* Global
ta intercaste
ta marrtype
ta interjatis
ta interjatis intercaste, cell

* Details castes
ta caste hwcaste
ta caste hwcaste, row nofreq

* Details marrtype
sort marrtype sex caste
list sex caste hwcaste marrtype if marrtype!=., clean noobs


********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5", clear
keep if married==1

* Global
ta intercaste
ta marrtype
ta interjatis
ta interjatis intercaste, cell nofreq

* Details castes
ta caste hwcaste
ta caste hwcaste, row nofreq

* Details marrtype
sort marrtype sex caste
list sex caste hwcaste marrtype if marrtype!=., clean noobs

****************************************
* END













****************************************
* Whith whom? -2
****************************************
cls

********** NEEMSIS-2 (2020-21)
use"NEEMSIS2-marriage_v5", clear
keep if married==1

* Economic
ta marriagespousefamily
ta sex 				marriagespousefamily, row nofreq
ta caste 			marriagespousefamily, row nofreq
ta intercaste 		marriagespousefamily, row nofreq
ta interjatis 		marriagespousefamily, row nofreq
ta marriagearranged	marriagespousefamily, row nofreq

* Type
ta marriagetype2
ta sex 				marriagetype2, row nofreq
ta caste 			marriagetype2, row nofreq
ta intercaste 		marriagetype2, row nofreq
ta interjatis 		marriagetype2, row nofreq
ta marriagearranged	marriagetype2, row nofreq

* Arranged
ta marriagearranged
ta sex 				marriagearranged, row nofreq
ta caste 			marriagearranged, row nofreq
ta intercaste 		marriagearranged, row nofreq
ta interjatis 		marriagearranged, row nofreq

ta sex 				marriagearranged, cchi2 chi2 exp

****************************************
* END
