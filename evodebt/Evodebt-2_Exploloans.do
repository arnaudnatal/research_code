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
* L vs ML
****************************************
cls
use"panel_loans_nonsettled", clear

ta dummyml

ta loanreasongiven dummyml, col nofreq
ta loanlender dummyml, col nofreq
tabstat loanamount, stat(mean q) by(dummyml)


****************************************
* END













****************************************
* MCA + HAC for all loans
****************************************
use"panel_loans_nonsettled", clear

********** Selection
fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77
ta dummyml
ta year




********** MCA
mca reason_cat lender4 otherlenderservices, meth(ind) normal(princ) comp
mca reason_cat lender4 otherlenderservices, meth(ind) normal(princ) comp dim(11)
predict d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11

********** HAC
cluster wardslinkage d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11
cluster dendrogram, cutnumber(48)
cluster gen clust=groups(6)

ta reason_cat clust
ta lender4 clust



****************************************
* END















****************************************
* MCA + HAC
****************************************
use"panel_loans_nonsettled", clear

********** Selection
fre loanreasongiven
drop if loanreasongiven==12
drop if loanreasongiven==77
ta dummyml
keep if dummyml==1

ta year


fre dummyguarantor


********** MCA
mca reason_cat lender4 dummyinterest dummyhelptosettleloan termsofrepayment, meth(ind) normal(princ) comp dim(9)
mcaplot, overlay legend(off) xline(0) yline(0) scale(.8)
predict d1 d2 d3 d4 d5 d6 d7 d8
scatter a2 a1, xline(0) yline(0)



********** HAC
cluster wardslinkage d1 d2 d3 d4 d5 d6 d7 d8
cluster dendrogram, cutnumber(48)
cluster gen clust=groups(6)

ta reason_cat clust
ta lender4 clust



****************************************
* END



