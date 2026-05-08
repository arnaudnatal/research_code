*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Household level
****************************************
use"panel_HH_v2", clear

keep HHID_panel year dummyloans_HH
rename dummyloans_HH debt
reshape wide debt, i(HHID_panel) j(year)

*
ta debt2010
ta debt2016
ta debt2020
ta debt2025
*
ta debt2010 debt2016
ta debt2016 debt2020
ta debt2020 debt2025

/*
. ta debt2010

  2010 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
        Yes |        405      100.00      100.00
------------+-----------------------------------
      Total |        405      100.00

. ta debt2016

  2016 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |          5        1.02        1.02
        Yes |        487       98.98      100.00
------------+-----------------------------------
      Total |        492      100.00

. ta debt2020

  2020 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |          4        0.64        0.64
        Yes |        622       99.36      100.00
------------+-----------------------------------
      Total |        626      100.00

. ta debt2025

  2025 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |          4        1.97        1.97
        Yes |        199       98.03      100.00
------------+-----------------------------------
      Total |        203      100.00

. *
. ta debt2010 debt2016

           |       2016 debt
 2010 debt |        No        Yes |     Total
-----------+----------------------+----------
       Yes |         4        384 |       388 
-----------+----------------------+----------
     Total |         4        384 |       388 


. ta debt2016 debt2020

           |       2020 debt
 2016 debt |        No        Yes |     Total
-----------+----------------------+----------
        No |         0          5 |         5 
       Yes |         3        477 |       480 
-----------+----------------------+----------
     Total |         3        482 |       485 


. ta debt2020 debt2025

           |       2025 debt
 2020 debt |        No        Yes |     Total
-----------+----------------------+----------
       Yes |         4        199 |       203 
-----------+----------------------+----------
     Total |         4        199 |       203 
*/


****************************************
* END








****************************************
* Household level
****************************************
use"panel_HH_v2", clear

keep HHID_panel year log_dsr
reshape wide log_dsr, i(HHID_panel) j(year)

gen path=.
replace path=1 if log_dsr2016>log_dsr2010 & log_dsr2020>log_dsr2016
replace path=2 if log_dsr2016>log_dsr2010 & log_dsr2020<log_dsr2016
replace path=3 if log_dsr2016<log_dsr2010 & log_dsr2020>log_dsr2016
replace path=4 if log_dsr2016<log_dsr2010 & log_dsr2020<log_dsr2016 

ta path

****************************************
* END




****************************************
* Individual level
****************************************
use"panel_indiv_v2", clear

keep HHID_panel INDID_panel year dummyloans_indiv
rename dummyloans_indiv debt
reshape wide debt, i(HHID_panel INDID_panel) j(year)

*
ta debt2016
ta debt2020
ta debt2025
*
ta debt2016 debt2020
ta debt2020 debt2025

/*
. ta debt2016

  2016 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |        765       45.29       45.29
        Yes |        924       54.71      100.00
------------+-----------------------------------
      Total |      1,689      100.00

. ta debt2020

  2020 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |        948       41.93       41.93
        Yes |      1,313       58.07      100.00
------------+-----------------------------------
      Total |      2,261      100.00

. ta debt2025

  2025 debt |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |        295       43.13       43.13
        Yes |        389       56.87      100.00
------------+-----------------------------------
      Total |        684      100.00

. *
. ta debt2016 debt2020

           |       2020 debt
 2016 debt |        No        Yes |     Total
-----------+----------------------+----------
        No |       342        207 |       549 
       Yes |       163        667 |       830 
-----------+----------------------+----------
     Total |       505        874 |     1,379 


. ta debt2020 debt2025

           |       2025 debt
 2020 debt |        No        Yes |     Total
-----------+----------------------+----------
        No |       113         97 |       210 
       Yes |        80        271 |       351 
-----------+----------------------+----------
     Total |       193        368 |       561 
*/




****************************************
* END





