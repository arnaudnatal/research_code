*Arnaud NATAL, University of Bordeaux, 20/10/2020
*Debt, institutions and individuals
/*
H0 : diff ==0
Ha : diff !=0
pvalue inf. à .05 = rejet H0
*/
clear all
global name "Arnaud"
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
use"$directory\analysis\panel_v10.dta", clear
xtset panelvar year
set more off
*set scheme plotplain
set scheme plottig
set matsize 5000, perm

global ego1 EGOcrOP1_r_std EGOcrCO1_r_std EGOcrEX1_r_std EGOcrAG1_r_std EGOcrES1_r_std EGOraven1_r_std EGOlit1_r_std EGOnum1_r_std
global ego1cont age1 age1sq sex1 mainoccupation1rec2 mainoccupation1rec3 mainoccupation1rec4 mainoccupation1rec5 mainoccupation1rec6 edulevel_ego1_2 edulevel_ego1_3 edulevel_ego1_4 relation1_2 relation1_3
global ego1mean age1_mean age1sq_mean mainoccupation1rec2_mean mainoccupation1rec3_mean mainoccupation1rec4_mean mainoccupation1rec5_mean mainoccupation1rec6_mean relation1_2_mean relation1_3_mean

global ego11 EGOcrOP11_r_std EGOcrCO11_r_std EGOcrEX11_r_std EGOcrAG11_r_std EGOcrES11_r_std EGOraven11_r_std EGOlit11_r_std EGOnum11_r_std
global ego11cont age11 age11sq sex11 mainoccupation11rec2 mainoccupation11rec3 mainoccupation11rec4 mainoccupation11rec5 mainoccupation11rec6 edulevel_ego11_2 edulevel_ego11_3 edulevel_ego11_4 relation11_2 relation11_3
global ego11mean age11_mean age11sq_mean mainoccupation11rec2_mean mainoccupation11rec3_mean mainoccupation11rec4_mean mainoccupation11rec5_mean mainoccupation11rec6_mean relation11_2_mean relation11_3_mean

global struct assets_NSDEF1000 dummyownland sex_ratio_cat1 sex_ratio_cat3 ownhouse
global meanstruct assets_NSDEF1000_mean dummyownland_mean sex_ratio_cat1_mean sex_ratio_cat3_mean ownhouse_mean
global HHcont annualincome_HHDEF1000 dep_ratio_cat1 dep_ratio_cat3 nbHHmb shock2 nbCHILD mainoccupation_HH2 mainoccupation_HH3 mainoccupation_HH4 mainoccupation_HH5 mainoccupation_HH6 mainoccupation_HH7
global meanHHcont annualincome_HHDEF1000_mean nbHHmb_mean shock2_mean nbchild_mean mainoccupation_HH2_mean mainoccupation_HH3_mean mainoccupation_HH4_mean mainoccupation_HH5_mean mainoccupation_HH6_mean mainoccupation_HH7_mean dep_ratio_cat1_mean dep_ratio_cat3_mean
global villagesFE villageid2 villageid3 villageid4 villageid5 villageid6 villageid7 villageid8 villageid9 villageid10
global yhh imp1_ds_totDEF1000 imp1_is_totDEF1000 loanamount_HHDEF1000 imp1_debt_burden imp1_interest_burden dar_HH dir_HH


****************************************
* Outlier
****************************************
foreach x in $yhh{
qui summarize `x', detail
gen _out_`x'=0 if inrange(`x', r(p1), r(p99))
recode _out_`x' (.=1)
bysort HHID : egen out_`x'=max(_out_`x')
drop _out_`x'
}
tab1 out_imp1_ds_totDEF1000 out_imp1_is_totDEF1000 out_loanamount_HHDEF1000 out_imp1_debt_burden out_imp1_interest_burden out_dar_HH out_dir_HH
****************************************
* END


****************************************
* ECON --> EGO 1
****************************************
*All sample
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if out_`x'==0, fe 
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego1 $ego1cont $ego1mean $meanstruct $meanHHcont if out_`x'==0 , re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
estimates dir
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego1mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std "Personality traits" EGOraven1_r_std "Cognitive skills" age1 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego1_noout", replace)
restore
*Low level of wealth
tabstat assets_NSDEF1000 if year==2016, stat(n mean sd q) by(assets_2010cat)
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==0 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==0 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego1 $ego1cont $ego1mean $meanstruct $meanHHcont if assets_2010cat==0 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego1mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std "Personality traits" EGOraven1_r_std "Cognitive skills" age1 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego1_low_noout", replace)
restore
*High level of wealth
tabstat assets_NSDEF1000 if year==2016, stat(n mean sd q) by(assets_2010cat)
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==1 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==1 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego1 $ego1cont $ego1mean $meanstruct $meanHHcont if assets_2010cat==1 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego1mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std "Personality traits" EGOraven1_r_std "Cognitive skills" age1 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego1_ric_noout", replace)
restore
*Male
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex1==0 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex1==0 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego1 $ego1cont $ego1mean $meanstruct $meanHHcont if sex1==0 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego1mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std "Personality traits" EGOraven1_r_std "Cognitive skills" age1 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego1_male_noout", replace)
restore
*Female
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex1==1 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex1==1 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego1 $ego1cont $ego1mean $meanstruct $meanHHcont if sex1==1 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego1mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std "Personality traits" EGOraven1_r_std "Cognitive skills" age1 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego1_female_noout", replace)
restore
****************************************
* END



****************************************
* ECON --> EGO 11 noout
****************************************
*All sample
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego11 $ego11cont $ego11mean $meanstruct $meanHHcont if out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
estimates dir
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego11mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP11_r_std "Personality traits" EGOraven11_r_std "Cognitive skills" age11 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego11_noout", replace)
restore
*Low level of wealth
tabstat assets_NSDEF1000 if year==2016, stat(n mean sd q) by(assets_2010cat)
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==0 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==0 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego11 $ego11cont $ego11mean $meanstruct $meanHHcont if assets_2010cat==0 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego11mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP11_r_std "Personality traits" EGOraven11_r_std "Cognitive skills" age11 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego11_low_noout", replace)
restore
*High level of wealth
tabstat assets_NSDEF1000 if year==2016, stat(n mean sd q) by(assets_2010cat)
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==1 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if assets_2010cat==1 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego11 $ego11cont $ego11mean $meanstruct $meanHHcont if assets_2010cat==1 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego11mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP11_r_std "Personality traits" EGOraven11_r_std "Cognitive skills" age11 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego11_ric_noout", replace)
restore
*Male
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex11==0 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex11==0 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego11 $ego11cont $ego11mean $meanstruct $meanHHcont if sex11==0 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego11mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP11_r_std "Personality traits" EGOraven11_r_std "Cognitive skills" age11 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego11_male_noout", replace)
restore
*Female
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex11==1 & out_`x'==0
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE if sex11==1 & out_`x'==0, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego11 $ego11cont $ego11mean $meanstruct $meanHHcont if sex11==1 & out_`x'==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego11mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP11_r_std "Personality traits" EGOraven11_r_std "Cognitive skills" age11 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_reg.csv", delimiter(",")  varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\STAT.xlsx", sheet("ECON|ego11_female_noout", replace)
restore
****************************************
* END
