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
cd"C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Measuringinvisible\Analysis"
*-------------------------








****************************************
* RUME (2010) outstanding
****************************************
use"raw/RUME-loans_mainloans_new", replace

***** Check in the last year
ta loandate
drop if loansettled==1

preserve
replace loanamount=loanamount/1000
tabstat loanamount, stat(n mean sd p50)
restore

***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanamount>0

***** Nb loans
gen loan=1
bys HHID2010: egen sloan=sum(loan)

***** Outstanding amount
bys HHID2010 : egen sbalance=sum(loanbalance2)

***** Av loan amount
bys HHID2010 : egen avloan=mean(loanamount)

***** Dummy lender and borrower
gen relafriend=lender4_rela+lender4_frie
gen otherinfo=lender4_WKP+lender4_neig
gen activity=given_agri+given_inve
gen funmar=given_marr+given_deat

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal lender4_WKP

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
foreach x in $var {
ta `x' if borrowed==1
}
tabstat sbalance sloan if borrowed==1, stat(n mean sd q)
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

preserve
replace loanamount=loanamount/1000
tabstat loanamount, stat(n mean sd p50)
restore

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

global var lender4_bank lender4_micr lender4_mone lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal lender4_WKP

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
foreach x in $var {
ta `x' if borrowed==1
}
tabstat sbalance sloan if borrowed==1, stat(n mean sd p50)
*
****************************************
* END










****************************************
* NEEMSIS-2 (2020) outstanding
****************************************
use"raw/NEEMSIS2-loans_mainloans_new", replace

*
drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"

***** Check in the last year
ta loandate
drop if loansettled==1

preserve
replace loanamount=loanamount/1000
tabstat loanamount, stat(n mean sd p50)
restore

***** Dummy borrowed
gen borrowed=0
replace borrowed=1 if loanbalance2>0

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

global var lender4_bank lender4_micr lender4_mone lender4_WKP lender_empl relafriend lender4_shop lender4_pawn otherinfo activity given_hous given_educ funmar given_heal

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

drop if HHID2020=="uuid:1091f83c-d157-4891-b1ea-09338e91f3ef"
drop if HHID2020=="uuid:21f161fd-9a0c-4436-a416-7e75fad830d7"
drop if HHID2020=="uuid:7373bf3a-f7a4-4d1a-8c12-ccb183b1f4db"
drop if HHID2020=="uuid:aea57b03-83a6-44f0-b59e-706b911484c4"
drop if HHID2020=="uuid:b3e4fe70-f2aa-4e0f-bb6e-8fb57bb6f409"
drop if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52"

cls
***** Statistics
ta borrowed
foreach x in $var {
ta `x' if borrowed==1
}
tabstat sbalance sloan if borrowed==1, stat(n mean sd p50)
*
****************************************
* END



