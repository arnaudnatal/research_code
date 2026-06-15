*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*MCA
*-----
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
cd"C:\Users\anatal\Documents\id"
*-------------------------








****************************************
* CA
****************************************
use"Loans_v2", replace

ta reason lender

ca reason lender
* 3 dimensions
ca reason lender, dim(2)
estat coordinates
predict d1, rowscore(1)
predict d2, rowscore(2)

****************************************
* END









****************************************
* MCA
****************************************
use"Loans_v2", replace

********** Preparation
* Var
global var reason lender duration interest security cat3amount
mdesc $var

********** MCA
mca $var, method (indicator) normal(princ)
mca $var, method (indicator) normal(princ) dim(9)
global dim d1 d2 d3 d4 d5 d6 d7 d8 d9
predict $dim


********** Kmeans
cluster kmeans $dim, k(1000)

save"Loans_hcpc_v0", replace


********** CAH sur les centroids
* Centroids
bys uniqueid: gen n=1
collapse (mean) $dim (sum) n, by(_clus_1)
* CAH
cluster wardslinkage $dim
cluster dendrogram, cutnumber(50)
cluster gen clust=groups(4)

save"_tempclust", replace


********** Reaffectation
use"Loans_hcpc_v0", clear

merge m:1 _clus_1 using "_tempclust", keepusing(clust)
keep if _merge==3
drop _merge

save"Loans_hcpc_v1", replace
****************************************
* END










****************************************
* Stat
****************************************
use"Loans_hcpc_v1", clear

*
ta clust year, col nofreq

*
egen reasonXlender=group(reason lender), label
ta reasonXlender clust, col nofreq
ta reasonXlender clust, row nofreq

*
ta reason clust, col nofreq
ta lender clust, col nofreq 
ta duration clust, col nofreq
ta interest clust, col nofreq
ta scheme clust, col nofreq
ta security clust, col nofreq

*
tabstat amount, stat(n mean q) by(clust)

****************************************
* END

