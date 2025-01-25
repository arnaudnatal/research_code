*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*January 21, 2025
*-----
gl link = "debtdiversity"
*Stat loan
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------








****************************************
* Characteristics of clusters
****************************************
use"panel_loans_v1_clust", clear

********** MCA 1
global mca1 lender4 reason_cat catloanamount
cls
foreach x in $mca1 {
ta clustloan1 `x', row nofreq
}
foreach x in $mca1 {
ta clustloan1 `x', col nofreq
}


********** MCA 2
keep if dummymainloan==1
global mca2 lender4 reason_cat catmainloanamount dummyinterest guarantee otherlenderservice
cls
foreach x in $mca2 {
ta clustloan2 `x', row nofreq
}


****************************************
* END











****************************************
* Label
****************************************
use"panel_loans_v1_clust", clear

label define clustloan1 1"Housing" 2"Moneylenders" 3"Small non-eco invest" 4"Daily pawn" 5"Small human invest" 6"Invest" 7"Social" 8"Emergency" 9"TBD" 10"Daily WKP"
label values clustloan1 clustloan1

*label define clustloan2 1"Housing" 2"Emergency" 3"H invest" 4"Smoothing" 5"Daily" 6"Smoothing" 7"Daily" 8"S invest" 9"Emergency"
*label values clustloan2 clustloan2




save"panel_loans_v1_clust_v2", replace
****************************************
* END












****************************************
* Stat
****************************************
use"panel_loans_v1_clust_v2", clear

ta clustloan1 year, col nofreq

fre clustloan1
ta loanreasongiven reason_cat if clustloan1==3  // Family
ta loanreasongiven reason_cat if clustloan1==4  // Family + Ceremonies
ta loanreasongiven reason_cat if clustloan1==7  // 
ta loanreasongiven reason_cat if clustloan1==8
ta loanreasongiven reason_cat if clustloan1==10  // Family


ta clustloan2 year, col nofreq
ta clustloan3 year, col nofreq


****************************************
* END



