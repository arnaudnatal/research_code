*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*May 14, 2023
*-----
gl link = "evodebt"
*Prepa database
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------







****************************************
* RUME
****************************************
use"raw/RUME-loans_mainloans_new", clear

merge m:m HHID2010 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

*** Choose
fre loansettled
fre lender4 lender_cat
fre loanreasongiven reason_cat
sum loanamount2
fre otherlenderservices
fre borrowerservices
fre dummyinterest
sum monthlyinterestrate
fre helptosettleloan
fre dummyrecommendation
fre dummyguarantor
fre plantorepay1 plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_noth plantorep_othe plantorep_nrep

* Help
gen dummyhelptosettleloan=.
replace dummyhelptosettleloan=0 if helptosettleloan==14 & helptosettleloan!=.
replace dummyhelptosettleloan=1 if helptosettleloan!=14 & helptosettleloan!=. 
ta dummyhelptosettleloan

keep HHID_panel loanid loansettled loanreasongiven loanlender lender4 lender_cat loanreasongiven reason_cat loanamount2 otherlenderservices borrowerservices dummyinterest monthlyinterestrate dummyhelptosettleloan dummyrecommendation dummyguarantor plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_noth plantorep_othe plantorep_nrep termsofrepayment dummyml

* Otherlenderservices
fre otherlenderservices
gen otherlenderservices_poli=0
gen otherlenderservices_fina=0
gen otherlenderservices_guar=0
gen otherlenderservices_gene=0
gen otherlenderservices_none=0
gen otherlenderservices_othe=0
replace otherlenderservices_poli=1 if otherlenderservices==1
replace otherlenderservices_fina=1 if otherlenderservices==2
replace otherlenderservices_guar=1 if otherlenderservices==3
replace otherlenderservices_gene=1 if otherlenderservices==4
replace otherlenderservices_none=1 if otherlenderservices==5
replace otherlenderservices_othe=1 if otherlenderservices==77
*drop otherlenderservices

label val otherlenderservices
ta otherlenderservices
tostring otherlenderservices, replace 

* Borrowerservices
fre borrowerservices
gen borrowerservices_free=0
gen borrowerservices_less=0
gen borrowerservices_supp=0
gen borrowerservices_none=0
gen borrowerservices_othe=0
replace borrowerservices_free=1 if borrowerservices==1
replace borrowerservices_less=1 if borrowerservices==2
replace borrowerservices_supp=1 if borrowerservices==3
replace borrowerservices_none=1 if borrowerservices==99
replace borrowerservices_othe=1 if borrowerservices==77
*drop borrowerservices

label val borrowerservices
ta borrowerservices
tostring borrowerservices, replace 

order HHID_panel loanid loanamount2 loansettled
sort HHID_pane loanid
gen year=2010

save"temp_RUMEloanpanel", replace
****************************************
* END









 



****************************************
* NEEMSIS1
****************************************
use"raw/NEEMSIS1-loans_mainloans_new", clear

merge m:m HHID2016 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

tostring INDID2016, replace
merge m:m HHID_panel INDID2016 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
drop if _merge==2
drop _merge


*** Choose
fre loansettled
fre lender4 lender_cat
fre loanreasongiven reason_cat
sum loanamount2
fre otherlenderservices
fre borrowerservices
fre dummyinterest
sum monthlyinterestrate
fre dummyproblemtorepay
fre dummyhelptosettleloan
fre dummyrecommendation
fre dummyguarantor
fre loanproductpledge

keep HHID_panel INDID_panel loanid loansettled loanreasongiven loanlender lender4 lender_cat loanreasongiven reason_cat loanamount2 otherlenderservices borrowerservices dummyinterest monthlyinterestrate dummyhelptosettleloan dummyrecommendation dummyguarantor plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe termsofrepayment dummyml loan_database

* Otherlenderservices
fre otherlenderservices
gen otherlenderservices_poli=0
gen otherlenderservices_fina=0
gen otherlenderservices_guar=0
gen otherlenderservices_gene=0
gen otherlenderservices_none=0
gen otherlenderservices_othe=0
replace otherlenderservices_poli=1 if strpos(otherlenderservices,"1")
replace otherlenderservices_fina=1 if strpos(otherlenderservices,"2")
replace otherlenderservices_guar=1 if strpos(otherlenderservices,"3")
replace otherlenderservices_gene=1 if strpos(otherlenderservices,"4")
replace otherlenderservices_none=1 if strpos(otherlenderservices,"5")
replace otherlenderservices_othe=1 if strpos(otherlenderservices,"77")
*drop otherlenderservices

* Borrowerservices
fre borrowerservices
gen borrowerservices_free=0
gen borrowerservices_less=0
gen borrowerservices_supp=0
gen borrowerservices_none=0
gen borrowerservices_othe=0
replace borrowerservices_free=1 if strpos(borrowerservices,"1")
replace borrowerservices_less=1 if strpos(borrowerservices,"2")
replace borrowerservices_supp=1 if strpos(borrowerservices,"3")
replace borrowerservices_none=1 if strpos(borrowerservices,"4")
replace borrowerservices_othe=1 if strpos(borrowerservices,"77")
*drop borrowerservices


order HHID_panel INDID_panel loanid loanamount2 loansettled
sort HHID_panel INDID_panel loanid
gen year=2016
tostring loanid, replace

save"temp_NEEMSIS1loanpanel", replace
****************************************
* END
















****************************************
* NEEMSIS2
****************************************
use"raw/NEEMSIS2-loans_mainloans_new", clear

ta dummyml
drop dummyml
gen dummyml=dummyhelptosettleloan
recode dummyml (1=1) (0=1) (.=0)
ta dummyml
order dummyml, after(loanid)

recode dummyml (.=0) if dummyhelptosettleloan==.
ta dummyml
ta dummyhelptosettleloan

ta borrowerservices dummyml, m

merge m:m HHID2020 using "raw/keypanel-HH_wide", keepusing(HHID_panel)
drop if _merge==2
drop _merge

tostring INDID2020, replace
merge m:m HHID_panel INDID2020 using "raw/keypanel-indiv_wide", keepusing(INDID_panel)
drop if _merge==2
drop _merge


*** Choose
fre loansettled
fre lender4 lender_cat
fre loanreasongiven reason_cat
sum loanamount2
fre otherlenderservices
fre borrowerservices
fre dummyinterest
sum monthlyinterestrate
fre dummyproblemtorepay
fre dummyhelptosettleloan
fre dummyrecommendation
fre dummyguarantor
fre loanproductpledge

keep HHID_panel INDID_panel loanid loansettled loanreasongiven loanlender lender4 lender_cat loanreasongiven reason_cat loanamount2 otherlenderservices borrowerservices dummyinterest monthlyinterestrate dummyhelptosettleloan dummyrecommendation dummyguarantor plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe termsofrepayment dummyml loan_database

* Otherlenderservices
fre otherlenderservices
gen otherlenderservices_poli=0
gen otherlenderservices_fina=0
gen otherlenderservices_guar=0
gen otherlenderservices_gene=0
gen otherlenderservices_none=0
gen otherlenderservices_othe=0
replace otherlenderservices_poli=1 if strpos(otherlenderservices,"1")
replace otherlenderservices_fina=1 if strpos(otherlenderservices,"2")
replace otherlenderservices_guar=1 if strpos(otherlenderservices,"3")
replace otherlenderservices_gene=1 if strpos(otherlenderservices,"4")
replace otherlenderservices_none=1 if strpos(otherlenderservices,"5")
replace otherlenderservices_othe=1 if strpos(otherlenderservices,"77")
*drop otherlenderservices

* Borrowerservices
fre borrowerservices
gen borrowerservices_free=0
gen borrowerservices_less=0
gen borrowerservices_supp=0
gen borrowerservices_none=0
gen borrowerservices_othe=0
replace borrowerservices_free=1 if strpos(borrowerservices,"1")
replace borrowerservices_less=1 if strpos(borrowerservices,"2")
replace borrowerservices_supp=1 if strpos(borrowerservices,"3")
replace borrowerservices_none=1 if strpos(borrowerservices,"4")
replace borrowerservices_othe=1 if strpos(borrowerservices,"77")
*drop borrowerservices

order HHID_panel INDID_panel loanid loanamount2 loansettled
sort HHID_panel INDID_panel loanid
gen year=2020
tostring loanid, replace

save"temp_NEEMSIS2loanpanel", replace
****************************************
* END











****************************************
* Append panel
****************************************
use "temp_NEEMSIS2loanpanel", clear
append using "temp_NEEMSIS1loanpanel"
append using "temp_RUMEloanpanel"


fre loanreasongiven
codebook loanreasongiven
label define loanreasongiven 1"agri" 2"fami" 3"heal" 4"repa" 5"hous" 6"inve" 7"cere" 8"marr" 9"educ" 10"rela" 11"deat" 12"nore" 77"othe", modify
fre loanreasongive

fre loanlender
codebook loanlender
label define loanlender 1"wkp" 2"rela" 3"empl" 4"mais" 5"coll" 6"pawn" 7"shop" 8"fina" 9"frie" 10"shg" 11"bank" 12"coop" 13"suga" 14"grou" 15"than", modify

fre reason_cat
codebook reason_cat
label define reason_cat 1"econ" 2"curr" 3"huma" 4"soci" 5"hous" 6"nore" 77"othe", modify

fre lender4
codebook lender4
label define lender3 1"wkp" 2"rela" 3"labo" 4"pawn" 5"shop" 6"mone" 7"frie" 8"micr" 9"bank" 10"than", modify

fre lender_cat
codebook lender_cat
label define lender_cat 1"info" 2"semi" 3"form", modify


********** Label
label define otherlenderservices_poli 0"Poli_No" 1"Poli_Yes"
label values otherlenderservices_poli otherlenderservices_poli

label define otherlenderservices_fina 0"Fina_No" 1"Fina_Yes"
label values otherlenderservices_fina otherlenderservices_fina

label define otherlenderservices_guar 0"Guar_No" 1"Guar_Yes"
label values otherlenderservices_guar otherlenderservices_guar

label define otherlenderservices_gene 0"Gene_No" 1"Gene_Yes"
label values otherlenderservices_gene otherlenderservices_gene

label define otherlenderservices_none 0"None_No" 1"None_Yes"
label values otherlenderservices_none otherlenderservices_none

label define otherlenderservices_othe 0"Othe_No" 1"Othe_Yes"
label values otherlenderservices_othe otherlenderservices_othe



********** Recoder pour MCA
fre otherlenderservices  // 82.5
replace otherlenderservices="2 4" if otherlenderservices=="1 2 4"
replace otherlenderservices="2 4" if otherlenderservices=="2 3 4"
replace otherlenderservices="2 4" if otherlenderservices=="2 4 5"
replace otherlenderservices="2 4" if otherlenderservices=="2 4 77"
replace otherlenderservices="5" if otherlenderservices=="2 5"
replace otherlenderservices="5" if otherlenderservices=="2 5 4"
replace otherlenderservices="1" if otherlenderservices=="1 77"
replace otherlenderservices="2" if otherlenderservices=="2 77"
replace otherlenderservices="5" if otherlenderservices=="4 5"
replace otherlenderservices="4" if otherlenderservices=="4 77"
replace otherlenderservices="2 4" if otherlenderservices=="1 2 3 4"
replace otherlenderservices="1" if otherlenderservices=="1 2 3"
replace otherlenderservices="1" if otherlenderservices=="1 3"
replace otherlenderservices="3" if otherlenderservices=="1 3 4"
replace otherlenderservices="1" if otherlenderservices=="1 4"
replace otherlenderservices="3" if otherlenderservices=="2 3"
replace otherlenderservices="3" if otherlenderservices=="3 4"
replace otherlenderservices="6" if otherlenderservices=="2 4"
replace otherlenderservices="6" if otherlenderservices=="1 2 3 5 4"
replace otherlenderservices="1" if otherlenderservices=="1 2"
replace otherlenderservices="5" if otherlenderservices=="2 3 5"
destring otherlenderservices, replace
label define otherlenderservices 1"Polit" 2"Finan" 3"Guaranto" 4"General" 5"None" 6"Fin+Gen" 77"Other" 99"No_resp"
label values otherlenderservices otherlenderservices
replace otherlenderservices=5 if loan_database=="GOLD"



fre borrowerservices  // 96.7
replace borrowerservices="4" if strpos(borrowerservices,"4")
replace borrowerservices="3" if borrowerservices=="3 77"
replace borrowerservices="3" if borrowerservices=="1 2 3"
replace borrowerservices="3" if borrowerservices=="1 3"
replace borrowerservices="3" if borrowerservices=="2 3"
replace borrowerservices="2" if borrowerservices=="1 2"
destring borrowerservices, replace
label define borrowerservices 1"Free_serv" 2"Less_wage" 3"Support" 4"None" 77"Other" 99"No_resp"
label values borrowerservices borrowerservices




     

********** Amount
tabstat loanamount2, stat(min p1 p5 p10 q p90 p95 p99 max) 
	 
fre loanlender

********** Order
compress
*drop if loanid=="."

order HHID_panel INDID_panel loanid year loanamount2 loansettled dummyml loanreasongiven reason_cat loanlender lender4 lender_cat otherlenderservices_poli otherlenderservices_fina otherlenderservices_guar otherlenderservices_gene otherlenderservices_none otherlenderservices_othe borrowerservices_free borrowerservices_less borrowerservices_supp borrowerservices_none borrowerservices_othe


drop otherlenderservices_poli otherlenderservices_fina otherlenderservices_guar otherlenderservices_gene otherlenderservices_none otherlenderservices_othe borrowerservices_free borrowerservices_less borrowerservices_supp borrowerservices_none borrowerservices_othe plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe plantorep_noth plantorep_nrep

ta otherlenderservices loan_database,m


*** deflate
replace loanamount2=loanamount2*(100/158) if year==2016
replace loanamount2=loanamount2*(100/184) if year==2020
*drop loanamount
rename loanamount2 loanamount



save"panel_loans", replace
****************************************
* END
