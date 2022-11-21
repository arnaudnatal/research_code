*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "labourdebt"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------









****************************************
* Loan duration
****************************************

***** 
* RUME
use"RUME-loans_mainloans_new", clear
gen loanduration_month=loanduration/12
tabstat loanduration_month, stat(n mean sd q)
/*
    variable |         N      mean        sd       p25       p50       p75
-------------+------------------------------------------------------------
loandurati~h |      2392  23.36734  18.09608        10     20.25  30.41667
--------------------------------------------------------------------------

2 years on average
50% of loans around 2 years
*/



* NEEMSIS-1
use"NEEMSIS1-loans_mainloans_new", clear
gen loanduration_month=loanduration/12
tabstat loanduration_month, stat(n mean sd q)
/*
    variable |         N      mean        sd       p25       p50       p75
-------------+------------------------------------------------------------
loandurati~h |      1697  53.56369  55.08383        17  35.66667  69.66666
--------------------------------------------------------------------------

4 years on average
50% of loans around 3 years
*/



* NEEMSIS-2
use"NEEMSIS2-loans_mainloans_new", clear
drop loanduration_month
gen loanduration_month=loanduration/12
tabstat loanduration_month, stat(n mean sd q)
/*
    variable |         N      mean        sd       p25       p50       p75
-------------+------------------------------------------------------------
loandurati~h |      5803  39.92673  39.66111     12.75  31.08333  60.41667
--------------------------------------------------------------------------

3 years on average
50% of loans around 3 years
*/

****************************************
* END













****************************************
* Financing marriage
****************************************

* NEEMSIS-1
use"NEEMSIS1-HH", clear
count if marriagedowry!=.
/*
240 marriages
*/
fre howpaymarriage
/*
-----------------------------------------------------------------------------
                                |      Freq.    Percent      Valid       Cum.
--------------------------------+--------------------------------------------
Valid   1 Loan                  |         11       0.41       4.58       4.58
        2 Own capital / Savings |         33       1.22      13.75      18.33
        3 Both                  |        196       7.27      81.67     100.00
        Total                   |        240       8.90     100.00           
Missing .                       |       2456      91.10                      
Total                           |       2696     100.00                      
-----------------------------------------------------------------------------
*/


* NEEMSIS-2
use"NEEMSIS2-HH", clear
count if marriagedowry!=.
/*
176 marriages
*/
fre howpaymarriage
/*
1 - Loan
2 - Own capital / Savings
3 - Gift
4 - Both - Loan, Own capital

-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   1     |          6       0.16       3.41       3.41
        1 2   |         13       0.36       7.39      10.80
        1 2 3 |          2       0.05       1.14      11.93
        1 4   |          1       0.03       0.57      12.50
        2     |         15       0.41       8.52      21.02
        2 3   |          5       0.14       2.84      23.86
        2 4   |          3       0.08       1.70      25.57
        3 4   |          1       0.03       0.57      26.14
        4     |        130       3.56      73.86     100.00
        Total |        176       4.83     100.00           
Missing       |       3471      95.17                      
Total         |       3647     100.00                      
-----------------------------------------------------------
*/

****************************************
* END

















****************************************
* Parallel trends
****************************************
* NEEMSIS-2
use"NEEMSIS2-HH", clear

* New var
gen marriagesexmale=0 
gen marriagesexfemale=0 
replace marriagesexmale=1 if dummy_marriedlist==1 & sex==1
replace marriagesexfemale=1 if dummy_marriedlist==1 & sex==2

bysort HHID2020: egen nbmarriage=sum(dummy_marriedlist)
bysort HHID2020: egen nbmmale=sum(marriagesexmale)
bysort HHID2020: egen nbmfemale=sum(marriagesexfemale)


* Duplicates drop
keep HHID2020 caste dummymarriage nbmarriage nbmmale nbmfemale
duplicates drop


* New var 2
gen dummymale=0
gen dummyfemale=0
replace dummymale=1 if nbmmale>0
replace dummyfemale=1 if nbmfemale>0

ta dummymarriage
/*
since 2016? |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |        464       73.42       73.42
        Yes |        168       26.58      100.00
------------+-----------------------------------
      Total |        632      100.00
*/

merge 1:m HHID2020 using "ODRIIS-HH_wide", keepusing(HHID2010 HHID2016 HHID_panel)
keep if _merge==3
drop _merge

gen panel=0
replace panel=1 if HHID2010!="" & HHID2016!=""

ta panel
ta dummymarriage panel, col 
/*
     since |         panel
     2016? |         0          1 |     Total
-----------+----------------------+----------
        No |       166        298 |       464 
           |     66.40      78.01 |     73.42 
-----------+----------------------+----------
       Yes |        84         84 |       168 
           |     33.60      21.99 |     26.58 
-----------+----------------------+----------
     Total |       250        382 |       632 
           |    100.00     100.00 |    100.00 
*/


* Add debt
merge 1:1 HHID2020 using "NEEMSIS2-loans_HH", keepusing(imp1_ds_tot_HH imp1_is_tot_HH loanamount_HH)
drop _merge


* Add assets
merge 1:1 HHID2020 using "NEEMSIS2-assets"
drop _merge


* Add income
merge 1:1 HHID2020 using "NEEMSIS2-occup_HH"
drop _merge


* Gen var
gen dar=loanamount_HH*100/assets
gen dir=loanamount_HH*100/annualincome_HH
gen dsr=imp1_ds_tot_HH*100/annualincome_HH
gen isr=imp1_is_tot_HH*100/annualincome_HH


* Replace
tabstat dar dir dsr isr, stat(n min p1 p5 p10 q p90 p95 p99 max)
replace dar=300 if dar>300  // 15 - - 2.40%
replace dir=5000 if dir>5000  // 15 - 2.40%
replace dsr=500 if dsr>500  // 27 - 
replace isr=200 if isr>200  // 23 - 3.68%


* Marriage on debt
keep if panel==1
tabstat dar dir dsr isr, stat(n mean sd q) by(dummymarriage)
tabstat dar dir dsr isr, stat(n mean sd q) by(dummymale)
tabstat dar dir dsr isr, stat(n mean sd q) by(dummyfemale)

foreach x in dar dir dsr isr {
reg `x' dummymarriage
}

stripplot dar, over(dummymarriage) vert ///
stack width(2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(25) ///
ms(oh) msize(small) mc(black%30) ///
xmtick() xtitle("") ///
ytitle("Debt measure") xlabel(0 "No marriage" 1 "Marriage",angle(0))

stripplot isr, over(dummymarriage) vert ///
width(2) centre cumul cumprob refline ///
box(barw(0.2))  pctile(90) ///
ms(oh) msize(small) mc(black%30) ///
xmtick() xtitle("") ///
ytitle("Debt measure") xlabel(0 "No marriage" 1 "Marriage",angle(0))




****************************************
* END

