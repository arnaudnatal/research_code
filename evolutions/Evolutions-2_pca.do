*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*March 16, 2026
*-----
gl link = "evolutions"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\evolutions.do"
*-------------------------









****************************************
* HCPC
****************************************
use"panel_v1", clear

global var d_inf d_form w_land w_saving w_assets w_gold inc_agr inc_nonagr remittnet
global varstd d_inf_std d_form_std w_land_std w_saving_std w_assets_std w_gold_std inc_agr_std inc_nonagr_std remittnet_std


factortest $varstd
pca $varstd
minap $varstd 
predict a1 a2 a3 a4 a5

cluster wardslinkage a1 a2 a3 a4 a5, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clust2=groups(2)
cluster gen clust4=groups(4)

tabstat $var, stat(n mean) by(clust2)
tabstat $var, stat(n mean) by(clust4)

ta clust2 year, col nofreq
ta clust4 year, col nofreq

ta clust4 dalit, exp cchi2 chi2

****************************************
* END









****************************************
* ACH
****************************************
use"panel_v1", clear

global var d_inf d_form w_land w_saving w_assets w_gold inc_agr inc_nonagr remittnet
global varstd d_inf_std d_form_std w_land_std w_saving_std w_assets_std w_gold_std inc_agr_std inc_nonagr_std remittnet_std

cluster wardslinkage $varstd, measure(Euclidean)
cluster dendrogram, cutnumber(50)
cluster gen clust2=groups(2)
cluster gen clust4=groups(4)

tabstat $var, stat(n mean) by(clust2)

ta clust2 year, col nofreq

****************************************
* END
