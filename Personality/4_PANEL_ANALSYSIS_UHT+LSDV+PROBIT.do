*Arnaud NATAL, University of Bordeaux, 20/10/2020
*Debt, institutions and individuals


***********
** ANALYSIS
**********
global directory "C:\Users\anatal\Downloads\En_cours\Research-Skills_and_debt\PANEL"
use"$directory\analysis\panel_v6.dta", clear
xtset panelvar year
set more off
*set scheme plotplain
*set scheme plottig
set matsize 5000, perm
*tab HHID, gen(HHID_p_)
*gen year2016=1 if year==2016
*replace year2016=0 if year==2010


*Global
global ego1 EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOcrGrit1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std

global ego1new EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std

global ego1cont age1 age1sq sex1 mainoccupation1rec2 mainoccupation1rec3 mainoccupation1rec4 mainoccupation1rec5 mainoccupation1rec6  edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 relation1_2 relation1_3
global struct assets_NSDEF1000 land_own sex_ratio ownhouse
global HHcont annualincome_HHDEF1000 dep_ratio nbHHmb dummymar dummydemonetisation nbCHILD
global meanego mainoccupation1rec2_mean mainoccupation1rec3_mean mainoccupation1rec4_mean mainoccupation1rec5_mean mainoccupation1rec6_mean age1_mean relation1_2_mean relation1_3_mean
global meanstruct assets_NSDEF1000_mean land_own_mean sex_ratio_mean ownhouse_mean
global meanHHcont annualincome_HHDEF1000_mean dep_ratio_mean nbHHmb_mean dummymar_mean dummydemonetisation_mean nbchild_mean
global meanall $meanego $meanstruct $meanHHcont
global villagesFE villageid2 villageid3 villageid4 villageid5 villageid6 villageid7 villageid8 villageid9 villageid10

global yhh imp1_debt_burden imp1_interest_burden dar_HH dir_HH

*Perfect balance
egen nmissing = rowmiss(imp1_debt_burden imp1_interest_burden dar_HH dir_HH $ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont caste_group)
bysort HHID: gen n=_N
tab nmissing n
keep if n==2
drop n
cls




/*
***********
** 2. LSDV
***********
*LSDV comme Clément m'a dit (reg) + Wooldrige dans le forum dit qu'on peut le faire pour le tobit (https://www.statalist.org/forums/forum/general-stata-discussion/general/1539477-tobit-and-fixed-effects)
*reg dsr_HH $PERSO $CONT i.panelvar
tobit dsr_HH $PERSO $CONT i.panelvar
logit dsr_HH $PERSO $CONT i.panelvar
*LSDV
foreach x in dsr_HH isr_HH dir_HH dar_HH ilr_amount_HH niglr_amount_HH hslr_amount_HH{
qui tobit `x' $PERSO $CONT i.panelvar
est store m_`x'_0, title(Global)
forvalues i=1(1)3{
qui tobit `x' $PERSO $CONT i.panelvar if caste_group==`i'
est store m_`x'_`i', title(Caste `i')
}
}
esttab m_* using "$directory\_temp\panel_lsdv.csv",	///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N chi2 r2_p, fmt(0 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01)  ///
	replace
estimates clear
*LOGIT
set maxiter 20
foreach x in dsr_HH_bin isr_HH_bin dir_HH_bin dar_HH_bin ilr_amount_HH_bin niglr_amount_HH_bin hslr_nb_HH_bin {
qui logit `x' $PERSO $CONT i.panelvar
est store m_`x'_0, title(Global)
forvalues i=1(1)3{
qui logit `x' $PERSO $CONT i.panelvar if caste_group==`i'
est store m_`x'_`i', title(Caste `i')
}
}
esttab m_* using "$directory\_temp\panel_lsdvbin.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N chi2 p r2_p, fmt(0 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
*/


/*
***********
** DEF : LOGIT
***********
set maxiter 50
estimates clear
foreach x in imp1_debt_bin imp1_interest_bin dar_HH_bin dir_HH_bin {
qui xtlogit `x' $ego1, re
est store `x'_m1, title(Global - 1)
qui xtlogit `x' $ego1 $ego1cont $meanego, re
est store `x'_m2, title(Global - 2)
qui xtlogit `x' $ego1 $ego1cont $struct caste_group2 caste_group3 $meanego $meanstruct, re
est store `x'_m3, title(Global - 3)
qui xtlogit `x' $ego1 $ego1cont $struct caste_group2 caste_group3 $HHcont $meanego $meanstruct $meanHHcont, re
est store `x'_m4, title(Global - 4)
}
**Dans les castes ?
foreach x in imp1_debt_bin imp1_interest_bin dar_HH_bin dir_HH_bin {
forvalues i=1(1)3{
qui xtlogit `x' $ego1 if caste_group==`i', re
est store `x'_`i'_m1, title(Caste `i' - 1)
qui xtlogit `x' $ego1 $ego1cont $meanego if caste_group==`i', re
est store `x'_`i'_m2, title(Caste `i' - 2)
qui xtlogit `x' $ego1 $ego1cont $struct $meanego $meanstruct if caste_group==`i', re
est store `x'_`i'_m3, title(Caste `i' - 3)
qui xtlogit `x' $ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont if caste_group==`i', re
est store `x'_`i'_m4, title(Caste `i' - 4)
}
}
estimates dir
foreach x in imp1_debt_bin imp1_interest_bin dar_HH_bin dir_HH_bin {
esttab `x'_* using "$directory\_temp\mk-logit_`x'.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2, fmt(0 0 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($meanall) ///
	replace
}
estimates clear
cls

***********
** IMPORT
***********
cd"$directory\_temp"
foreach x in imp1_debt_bin imp1_interest_bin dar_HH_bin dir_HH_bin{
import delimited mk-logit_`x'.csv, delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
gen n=_n
drop if n==4
drop if n==65
drop n 
gen sp1=""
gen sp2=""
gen sp3=""
order v1 v2 v3 v4 v5 sp1 v6 v7 v8 v9 sp2 v10 v11 v12 v13 sp3, first
gen n=_n
rename v* v*_`x'
rename sp* sp*_`x'
save"_`x'.dta", replace
}
use"$directory\_temp\_imp1_debt_bin.dta", replace
foreach x in imp1_interest_bin dar_HH_bin dir_HH_bin{
merge 1:1 n using "$directory\_temp\_`x'.dta"
drop _merge
}
order v1_*, first
drop v1_imp1_interest_bin v1_dar_HH_bin v1_dir_HH_bin n
export excel using "$directory\_temp\panel_table.xlsx", sheet("mklogit", replace)
*/


/*
***********
** UHT thank to Chatelain and Ralf
***********
*Global
cls
foreach x in imp1_debt_burden imp1_interest_burden dar_HH dir_HH {
xtgls `x' $ego1 $ego1cont $struct caste_group2 caste_group3 $HHcont $meanego $meanstruct $meanHHcont
}
*Caste 1
cls
foreach x in imp1_debt_burden imp1_interest_burden dar_HH dir_HH {
xtgls `x' $ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont if caste_group==1
}
*Caste 2
cls
foreach x in imp1_debt_burden imp1_interest_burden dar_HH dir_HH {
xtgls `x' $ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont if caste_group==2
}
*Caste 3
cls
foreach x in imp1_debt_burden imp1_interest_burden dar_HH dir_HH {
xtgls `x' $ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont if caste_group==3
}


global ego1 EGOcrOP1_r_std_new EGOcrCO1_r_std_new EGOcrEX1_r_std_new EGOcrAG1_r_std_new EGOcrES1_r_std_new EGOcrGrit1_r_std_new EGOraven1_r_std_new EGOlit1_r_std_new EGOnum1_r_std_new
global ego1cont age1 sex1 mainoccupation1bis2 mainoccupation1bis3 mainoccupation1bis4 mainoccupation1bis5 mainoccupation1bis6  edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 
global struct assets_NSDEF land_own sex_ratio housebis
global HHcont annualincome_HHDEF dep_ratio nbHHmb dummymar
global meanego mainoccupation1bis2_mean mainoccupation1bis3_mean mainoccupation1bis4_mean mainoccupation1bis5_mean mainoccupation1bis6_mean age1_mean 
global meanstruct assets_NSDEF_mean land_own_mean sex_ratio_mean housebis_mean
global meanHHcont annualincome_HHDEF_mean dep_ratio_mean nbHHmb_mean dummymar_mean
global meanall $meanego $meanstruct $meanHHcont


*$ego1 $ego1cont $struct $HHcont $meanego $meanstruct $meanHHcont
*Reg avec Chatelain and Ralf
*1
qui xthtaylor imp1_debt_burden $ego1 $ego1cont $struct $HHcont caste_group2 caste_group3, endog(age1 dep_ratio) constant($ego1 caste_group2 caste_group3 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dsr_glo
*2
qui xthtaylor imp1_debt_burden $ego1 $ego1cont $struct $HHcont if caste_group==1, endog(age1) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dsr_dal
*3
qui xtgls imp1_debt_burden $ego1 $ego1cont $struct $HHcont if caste_group==2
estimates store dsr_mid
*4
qui xthtaylor imp1_debt_burden $ego1 $ego1cont $struct $HHcont if caste_group==3, endog(mainoccupation1bis3 mainoccupation1bis4 age1 sex_ratio annualincome_HHDEF dep_ratio nbHHmb dummymar) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dsr_upp

*5
qui xthtaylor imp1_interest_burden $ego1 $ego1cont $struct $HHcont caste_group2 caste_group3, endog(age1 sex_ratio) constant($ego1 caste_group2 caste_group3 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store isr_glo
*6
qui xthtaylor imp1_interest_burden $ego1 $ego1cont $struct $HHcont if caste_group==1, endog(age1) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store isr_dal
*7
qui xtgls imp1_interest_burden $ego1 $ego1cont $struct $HHcont if caste_group==2
estimates store isr_mid
*8
qui xthtaylor dar_HH $ego1 $ego1cont $struct $HHcont if caste_group==3, endog(mainoccupation1bis5 age1 sex_ratio dep_ratio nbHHmb dummymar) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store isr_upp

*9
qui xthtaylor dar_HH $ego1 $ego1cont $struct $HHcont caste_group2 caste_group3, endog(mainoccupation1bis4 housebis) constant($ego1 caste_group2 caste_group3 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dar_glo
*10
qui xthtaylor dar_HH $ego1 $ego1cont $struct $HHcont if caste_group==1, endog(housebis) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dar_dal
*11
qui xthtaylor dar_HH $ego1 $ego1cont $struct $HHcont if caste_group==2, endog(mainoccupation1bis4 sex_ratio) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dar_mid
*12
qui xthtaylor dar_HH $ego1 $ego1cont $struct $HHcont if caste_group==3, endog(mainoccupation1bis3 age1 assets_NSDEF sex_ratio) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dar_upp

*13
qui xthtaylor dir_HH $ego1 $ego1cont $struct $HHcont caste_group2 caste_group3, endog(age1) constant($ego1 caste_group2 caste_group3 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dir_glo
*14
qui xthtaylor dir_HH $ego1 $ego1cont $struct $HHcont if caste_group==1, endog(mainoccupation1bis2 age1) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dir_dal
*15
qui xtgls dir_HH $ego1 $ego1cont $struct $HHcont if caste_group==2
estimates store dir_mid
*16
qui xthtaylor dir_HH $ego1 $ego1cont $struct $HHcont if caste_group==3, endog(mainoccupation1bis5 mainoccupation1bis6 age1 sex_ratio annualincome_HHDEF dep_ratio nbHHmb) constant($ego1 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 sex1)
estimates store dir_upp

estimates dir
esttab dsr* isr* dar* dir* using "$directory\_temp\uht.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2, fmt(0 0 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	replace
estimates clear
*/
