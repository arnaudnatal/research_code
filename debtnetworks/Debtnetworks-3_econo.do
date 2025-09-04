*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 2, 2025
*-----
gl link = "debtnetworks"
*Econo
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------





****************************************
* Test analysis
****************************************
use"Main_analyses_v4", clear

* Selection
drop if nbloan_indiv==.
drop if nbloan_indiv==0

* Y var creation
gen isr_indiv=is_indiv/annualincome_indiv
gen dsr_indiv=ds_indiv/annualincome_indiv

gen share_isr=is_indiv/is_HH
gen share_dsr=ds_indiv/ds_HH


* Macro
global controls i.sex c.age i.caste i.educ i.occupation c.assets_total c.annualincome_HH i.villageid

global yvar share_isr

* Size
cls
reg $yvar netsize_debt $controls, cluster(HHFE)

* Strength
cls
foreach x in debt_duration strength_debt {
reg $yvar `x' $controls, cluster(HHFE)
}

* Diversification
cls
foreach x in debt_samegender_pct debt_samecaste_pct debt_samejatis_pct debt_sameage_pct debt_samejobstatut_pct debt_sameoccup_pct debt_sameeduc_pct debt_samelocation_pct debt_samewealth_pct {
reg $yvar `x' $controls, cluster(HHFE)
}


****************************************
* END
