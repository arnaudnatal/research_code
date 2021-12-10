cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
December 09, 2021
-----
Panel for indebtedness and over-indebtedness
-----

-------------------------
*/









****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
global directory = "D:\Documents\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"
set scheme plotplain

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH_v8"
global wave2 "NEEMSIS1-HH_v8"
global wave3 "NEEMSIS2-HH_v19"

global loan1 "RUME-loans_v8"
global loan2 "NEEMSIS1-loans_v4"
global loan3 "NEEMSIS2-all_loans"



********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020



****************************************
* END










****************************************
* Source of loans
****************************************

/*
	1	WKP	1971	37.00	37.00	37.00
	
	2	Relatives	654	12.28	12.28	49.28
	3	Employer	71	1.33	1.33	50.61
	4	Maistry	19	0.36	0.36	50.97
	5	Colleague	91	1.71	1.71	52.68
	
	6	Pawn Broker	285	5.35	5.35	58.03
	7	Shop keeper	22	0.41	0.41	58.44
	8	Finance (moneylenders)	171	3.21	3.21	61.65
	
	9	Friends	336	6.31	6.31	67.96
	
	10	SHG	88	1.65	1.65	69.61
	
	11	Banks	564	10.59	10.59	80.20
	12	Coop bank	66	1.24	1.24	81.43
	
	13	Sugar mill loan	1	0.02	0.02	81.45
	
	14	Group finance	801	15.04	15.04	96.49
	
	15	Thandal	187	3.51	3.51	100.00
*/

label define reason 1"Agriculture" 2"Investment" 3"Family" 4"Repay previous loan" 5"Relatives" 6"Health" 7"Education" 8"Ceremonies" 9"Marriage" 10"Death" 11"Housing" 12"No reason" 77"Other"
gen loanreasongiven_rec=.
replace loanreasongiven_rec=1 if loanreasongive==1
replace loanreasongiven_rec=3 if loanreasongive==2
replace loanreasongiven_rec=6 if loanreasongive==3
replace loanreasongiven_rec=4 if loanreasongive==4
replace loanreasongiven_rec=11 if loanreasongive==5
replace loanreasongiven_rec=2 if loanreasongive==6
replace loanreasongiven_rec=8 if loanreasongive==7
replace loanreasongiven_rec=9 if loanreasongive==8
replace loanreasongiven_rec=7 if loanreasongive==9
replace loanreasongiven_rec=5 if loanreasongive==10
replace loanreasongiven_rec=10 if loanreasongive==11
replace loanreasongiven_rec=12 if loanreasongive==12
replace loanreasongiven_rec=77 if loanreasongive==77

label define lender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"" 7"" 8"" 9"" 10"" 11"" 12"" 13"" 14"" 15""

gen loanlender_rec=.
replace loanlender_rec= if loanlender==1
replace loanlender_rec= if loanlender==2
replace loanlender_rec= if loanlender==3
replace loanlender_rec= if loanlender==4
replace loanlender_rec= if loanlender==5
replace loanlender_rec= if loanlender==6
replace loanlender_rec= if loanlender==7
replace loanlender_rec= if loanlender==8
replace loanlender_rec= if loanlender==9
replace loanlender_rec= if loanlender==10
replace loanlender_rec= if loanlender==11
replace loanlender_rec= if loanlender==12
replace loanlender_rec= if loanlender==13
replace loanlender_rec= if loanlender==14
replace loanlender_rec= if loanlender==15

********** 2010
use "$loan1", clear
drop if loansettled==1
ta loanlender



********** 2016
use "$loan2", clear
drop if loansettled==1
drop if loan_database=="MARRIAGE"
ta loanlender

*** Amount
replace loanamount=(loanamount*(100/158))/1000
tabstat loanamount, stat(n mean) by(loanlender)
tabstat loanamount, stat(n mean) by(loanreasongiven)



********** 2020
use "$loan3", clear
drop if loansettled==1
replace loanlender=6 if loan_database=="GOLD"

ta loanlender
ta loanreasongiven
*** Clientele using it
fre loanlender
forvalues i=1(1)15{
gen lenders_`i'=0
}
forvalues i=1(1)15{
replace lenders_`i'=1 if loanlender==`i'
}
*
cls
preserve 
forvalues i=1(1)15{
bysort HHID_panel: egen lendersHH_`i'=max(lenders_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)15{
tab lendersHH_`i', m
}
restore

*** Reason given
fre loanreasongiven
recode loanreasongiven (77=13)
forvalues i=1(1)13{
gen reason_`i'=0
}
forvalues i=1(1)13{
replace reason_`i'=1 if loanreasongiven==`i'
}
*
cls
preserve 
forvalues i=1(1)13{
bysort HHID_panel: egen reasonHH_`i'=max(reason_`i')
} 
bysort HHID_panel: gen n=_n
keep if n==1
forvalues i=1(1)13{
tab reasonHH_`i', m
}
restore


*** Amount
replace loanamount=(loanamount*(100/184))/1000
tabstat loanamount, stat(n mean) by(loanlender)
tabstat loanamount, stat(n mean) by(loanreasongiven)




****************************************
* END
