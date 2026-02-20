*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*February 16, 2026
*-----
gl link = "measuringinvisible"
*ODRIIS at household level
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------






****************************************
* RUME (2010) last 5 years
****************************************
use"raw/RUME-loans_mainloans_new", replace

***** Check in the last 5 years
ta loandate // ok


***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2010: egen sloan=sum(loan)


***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2010 borrowed $var sloan

foreach x in borrowed $var {
bysort HHID2010: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/RUME-HH", clear
keep HHID2010
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2010 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END












****************************************
* RUME (2010) last year
****************************************
use"raw/RUME-loans_mainloans_new", replace

***** Check in the last year
ta loandate // ok
drop if loandate<mdy(1, 1, 2009)


***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2010: egen sloan=sum(loan)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2010 borrowed $var sloan

foreach x in borrowed $var {
bysort HHID2010: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/RUME-HH", clear
keep HHID2010
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2010 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END








****************************************
* RUME (2010) outstanding
****************************************
use"raw/RUME-loans_mainloans_new", replace

***** Check in the last year
ta loandate
drop if loansettled==1

***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2010: egen sloan=sum(loan)

***** Outstanding amount
bys HHID2010 : egen sbalance=sum(loanbalance2)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2010 borrowed sbalance $var sloan

foreach x in borrowed $var {
bysort HHID2010: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/RUME-HH", clear
keep HHID2010
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2010 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
sum sbalance
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END













****************************************
* NEEMSIS-1 (2016) last 5 years
****************************************
use"raw/NEEMSIS1-loans_mainloans_new", replace

***** Check in the last 5 years
ta loandate // ok
drop if loandate<mdy(1, 1, 2012)


***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2016: egen sloan=sum(loan)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2016 borrowed $var sloan

foreach x in borrowed $var {
bysort HHID2016: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/NEEMSIS1-HH", clear
keep HHID2016
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2016 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END








****************************************
* NEEMSIS-1 (2016) last year
****************************************
use"raw/NEEMSIS1-loans_mainloans_new", replace

***** Check in the last year
ta loandate // ok
drop if loandate<mdy(1, 1, 2015)


***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2016: egen sloan=sum(loan)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2016 borrowed $var sloan

foreach x in borrowed $var {
bysort HHID2016: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/NEEMSIS1-HH", clear
keep HHID2016
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2016 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END












****************************************
* NEEMSIS-1 (2016) outstanding
****************************************
use"raw/NEEMSIS1-loans_mainloans_new", replace

***** Check in the last year
ta loandate
drop if loansettled==1

***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2016: egen sloan=sum(loan)

***** Outstanding amount
bys HHID2016 : egen sbalance=sum(loanbalance2)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2016 borrowed sbalance $var sloan

foreach x in borrowed $var {
bysort HHID2016: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/NEEMSIS1-HH", clear
keep HHID2016
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2016 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
sum sbalance
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END














****************************************
* NEEMSIS-2 (2020) last 5 years
****************************************
use"raw/NEEMSIS2-loans_mainloans_new", replace

***** Check in the last 5 years
ta loandate // ok
drop if loandate<mdy(1, 1, 2015)


***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2020: egen sloan=sum(loan)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2020 borrowed $var sloan

foreach x in borrowed $var {
bysort HHID2020: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/NEEMSIS2-HH", clear
keep HHID2020
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2020 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END








****************************************
* NEEMSIS-2 (2020) last year
****************************************
use"raw/NEEMSIS2-loans_mainloans_new", replace

***** Check in the last year
ta loandate // ok
drop if loandate<mdy(1, 1, 2019)


***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2020: egen sloan=sum(loan)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2020 borrowed $var sloan

foreach x in borrowed $var {
bysort HHID2020: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/NEEMSIS2-HH", clear
keep HHID2020
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2020 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END











****************************************
* NEEMSIS-2 (2020) outstanding
****************************************
use"raw/NEEMSIS2-loans_mainloans_new", replace

***** Check in the last year
ta loandate
drop if loansettled==1

***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2020: egen sloan=sum(loan)

***** Outstanding amount
bys HHID2020 : egen sbalance=sum(loanbalance2)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

keep HHID2020 borrowed sbalance $var sloan

foreach x in borrowed $var {
bysort HHID2020: egen s`x'=sum(`x')
}

foreach x in borrowed $var {
drop `x'
rename s`x' `x'
}

***** Duplicate and dummy
duplicates drop
foreach x in borrowed $var {
replace `x'=1 if `x'>1
}
*
preserve
use"raw/NEEMSIS2-HH", clear
keep HHID2020
duplicates drop
save"_temp", replace
restore
merge 1:1 HHID2020 using "_temp"
drop _merge
*
foreach x in borrowed $var {
recode `x' (.=0)
}

cls
***** Statistics
ta borrowed
sum sbalance
foreach x in $var {
ta `x'
}
sum sloan if borrowed==1
*
****************************************
* END



