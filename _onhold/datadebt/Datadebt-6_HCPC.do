*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 1, 2023
*-----
gl link = "datadebt"
*Stat loan
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------












****************************************
* Overlap?
****************************************
use"panel_loans", clear

********** Prepa
*** Simple selection
keep if dummyml==1
drop if loansettled==1


********** Overlap
gen overlap=0
replace overlap=1 if loandate<td(31dec2010) & year==2016
replace overlap=1 if loandate<td(31dec2010) & year==2020
replace overlap=1 if loandate<td(31dec2017) & year==2020

bysort HHID_panel: egen maxoverlap=max(overlap)
drop if maxoverlap==0

keep HHID_panel INDID_panel loanid year loanamount loanlender loanreasongiven overlap loandate maxoverlap

sort HHID_panel INDID_panel loanid year


****************************************
* END

















****************************************
* MCA + HAC for ML
****************************************
use"panel_loans", clear

********** Prepa
*** Simple selection
keep if dummyml==1
drop if loansettled==1


*** Selection on missing
fre reason_cat
drop if reason_cat==6  // no reason
drop if reason_cat==77
fre borrowerservices
drop if borrowerservices==77
drop if borrowerservices==99


*** New var
gen dummyborrowerservices=.
replace dummyborrowerservices=0 if borrowerservices==4
replace dummyborrowerservices=1 if borrowerservices==1
replace dummyborrowerservices=1 if borrowerservices==2
replace dummyborrowerservices=1 if borrowerservices==3
ta borrowerservices dummyborrowerservices, m
label values dummyborrowerservices yesno

*** Label correction
fre reason_cat lender_cat dummyinterest dummyhelptosettleloan dummyborrowerservices
codebook lender_cat
label define reason_cat 1"Econ" 2"Curr" 3"Huma" 4"Soci" 5"Hous", modify
label define lender_cat 1"Info" 2"Semi" 3"Form", modify


********** MCA
global var reason_cat lender_cat dummyinterest dummyhelptosettleloan dummyborrowerservices
fre $var
*dummyborrowerservices
*** How many axes to interpret?
mca $var, meth(ind) normal(princ)

*** Donner du sens aux axes
mca $var, meth(ind) normal(princ) comp dim(2)
mcaplot, overlay legend(off) xline(0) yline(0) legend(on pos(6) col(3) order(1 "Purpose" 2 "Lender" 3 "Interest?" 4 "Help to settle?" 5 "Borr. services?")) xtitle("Dim. 1 (64%)*") ytitle("Dim. 2 (9%)*") title("") note("*Percentage corrected using the Greenacre correction", size(vsmall))



*** Axis for HAC
qui mca $var, meth(ind) normal(princ) comp dim(5)
global var2 d1 d2 d3 d4 d5
predict $var2




********** HAC
cluster wardslinkage $var2
/*
cluster dendrogram, cutnumber(60) title("") ytitle("Squared Euclidean distance") yline(600) xlabel(,angle(90) labsize(vsmall)) name(tree, replace)
graph export "hac.pdf", as(pdf) replace
graph export "hac.png", as(png) replace
graph save "hac.gph", replace
*/
cluster gen clust=groups(6)



********** Light db
keep HHID_panel INDID_panel loanid year loanamount loanreasongiven reason_cat loanlender lender_cat loandate dummyinterest dummyhelptosettleloan dummyborrowerservices clust assets_total1000 assets_totalnoland1000 assets_totalnoprop1000 shareassets_housevalue shareassets_livestock shareassets_goods shareassets_ownland shareassets_gold nbmale nbfemale HHsize typeoffamily nbgeneration head_sex head_age head_mocc_occupation head_annualincome head_nboccupation head_edulevel dependencyratio sexratio annualincome_HH shareincomeagri_HH shareincomenonagri_HH dummyworkedpastyear working_pop mainocc_occupation_indiv nboccupation_indiv villageid villagearea sex age caste


*** Label clust
fre clust
recode clust (5=1) (6=2) (1=3) (2=4) (3=5) (4=6)
gen clust_lab=clust
label define clust_lab 1"Form" 2"Semi" 3"Smoothing" 4"Oppressive" 5"Human" 6"Housing"
label values clust_lab clust_lab

ta clust_lab



save "clusters", replace
****************************************
* END

