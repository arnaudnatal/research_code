*Arnaud NATAL, University of Bordeaux, 20/10/2020
*Debt, institutions and individuals
/*
H0 : diff ==0
Ha : diff !=0
pvalue inf. à .05 = rejet H0
*/
clear all
*ssc install blindschemes
*net install grc1leg.pkg

set scheme plottig
global name "anatal"

global directory "D:\En_cours\Research-Skills_and_debt\PANEL"
*global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
global pdf "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\pdf"
use"$directory\analysis\panel_v15.dta", clear
xtset panelvar year
set more off
*set matsize 5000, perm
set maxiter 50

drop if dropego3==1


*Est ce que la place dans le ménages compte ?
gen _relation_head=1 if relation1_ego3==1 & year==2010
replace _relation_head=0 if relation1_ego3!=1 & year==2010
bysort HHID: egen relation_head=max(_relation_head)
drop _relation_head
tab relation_head year

****************************************
* MACRO
****************************************
global ego3 EGOcrOP1_r_std_ego3 EGOcrCO1_r_std_ego3 EGOcrEX1_r_std_ego3 EGOcrAG1_r_std_ego3 EGOcrES1_r_std_ego3 EGOraven1_r_std_ego3 EGOlit1_r_std_ego3 EGOnum1_r_std_ego3
global ego3new new_CO_r_std1_ego3 new_ES_r_std1_ego3 new_OPEX_r_std1_ego3 new_ESCO_r_std1_ego3 new_AG_r_std1_ego3 EGOraven1_r_std_ego3 EGOlit1_r_std_ego3 EGOnum1_r_std_ego3
global ego3cont age1_ego3 age1sq_ego3 sex1_ego3 mainoccupation1rec2_ego3 mainoccupation1rec3_ego3 mainoccupation1rec4_ego3 mainoccupation1rec5_ego3 mainoccupation1rec6_ego3 edulevel_ego1_2_ego3 edulevel_ego1_3_ego3 edulevel_ego1_4_ego3 relation1_2_ego3 relation1_3_ego3
global ego3mean age1_mean_ego3 age1sq_mean_ego3 mainoccupation1rec2_mean_ego3 mainoccupation1rec3_mean_ego3 mainoccupation1rec4_mean_ego3 mainoccupation1rec5_mean_ego3 mainoccupation1rec6_mean_ego3 relation1_2_mean_ego3 relation1_3_mean_ego3

global struct assets_NSDEF1000 dummyownland female_ratio ownhouse
global meanstruct assets_NSDEF1000_mean dummyownland_mean female_ratio_mean ownhouse_mean

global HHcont annualincome_HHDEF1000 dep_ratio_cat1 dep_ratio_cat2 nbHHmb shock2 nbCHILD nbsource
global meanHHcont annualincome_HHDEF1000_mean nbHHmb_mean shock2_mean nbchild_mean nbsource_mean dep_ratio_cat1_mean dep_ratio_cat2_mean

global villagesFE villageid2 villageid3 villageid4 villageid5 villageid6 villageid7 villageid8 villageid9 villageid10

global yhh_main imp1_ds_totDEF1000 imp1_is_totDEF1000 imp1_debt_burden imp1_interest_burden
global yhh_rob loanamount_HHDEF1000 dar_HH dir_HH
global yhh_oth flr_HH ilr2_HH iglr_HH niglr_amount_HH 
global yhh_bin imp1_debt_bin imp1_interest_bin dar_HH_bin dir_HH_bin
global yhh $yhh_main $yhh_rob $yhh_oth
****************************************
* END




/*
****************************************
* DESCRIPTIVE EGO 3
****************************************
***Who is ego 3 ?
tabstat age1_ego3 if year==2010, stat(n mean) by(sex1_ego3)
tabstat age1_ego3 if year==2016, stat(n mean) by(sex1_ego3)
tab caste_group sex1_ego3 if year==2010, col nofreq
tab relation1_ego3 sex1_ego3 if year==2010
tab relation1_ego3 sex1_ego3 if year==2010, col nofreq
tab relation1_ego3 sex1_ego3 if year==2016, col nofreq
tab edulevel1_ego3 sex1_ego3 if year==2010, col nofreq
tab mainoccupation1_ego3rec sex1_ego3 if year==2010, col nofreq
tab mainoccupation1_ego3rec sex1_ego3 if year==2016, col nofreq

*kdensity for personality traits
graph drop _all
set graph off
foreach x in $ego3new{
kdensity `x' if year==2010 & sex1_ego3==0, bwidth(0.3) plot(kdensity `x' if year==2010 & sex1_ego3==1, bwidth(0.3)) title ("") note("") legend(ring(0) pos(2) label(1 "Male") label(2 "Female")) name(k_`x', replace)
}
graph dir 
set graph on
grc1leg k_EGOlit1_r_std_ego3 k_EGOnum1_r_std_ego3 k_EGOraven1_r_std_ego3 k_new_AG_r_std1_ego3 k_new_ES_r_std1_ego3 k_new_CO_r_std1_ego3 k_new_OPEX_r_std1_ego3 k_new_ESCO_r_std1_ego3, leg(k_EGOlit1_r_std_ego3) pos(3)
graph export "$directory\_temp\k_persoEGO3.pdf", replace
****************************************
* END
*/








/*
****************************************
* DESCRIPTIVE HH
****************************************
*HH characteristics
foreach x in 2010 2016{
tabstat assets_NSDEF1000 annualincome_HHDEF1000 nbHHmb nbCHILD nbsource if year==`x', stat(n mean sd p50) by(caste_group)
}
foreach x in 2016{
tab dummyownland caste_group if year==`x', col nofreq
tab ownhouse caste_group if year==`x', col nofreq
tab sex_ratio_cat caste_group if year==`x', col nofreq
tab dep_ratio_cat caste_group if year==`x', col nofreq
tab mainoccupation_HH caste_group if year==`x', col nofreq
tab villageidclub caste_group if year==`x', col nofreq
}

tab villageidclub caste_group if year==2010, col nofreq
tab shock2 caste_group if year==2016, col nofreq
****************************************
* END
*/


/*
****************************************
* CORR MOC
****************************************
tab mainoccupation_HH mainoccupation1rec, nofreq chi2
/*
Pearson chi2(30) =  1.4e+03   Pr = 0.000
H0: indépendante
Dependance donc ne va pas..
Est-ce que je vire la moc du HH ou celle du head ?
Si je vire celle du HH, je peux la remplacer par le nombre de source de revenu du HH
Si je vire celle du head, je peux remplacer par le nombre de source de revenu du head oui
j'importe les deux déjà
*/
****************************************
* END
*/

/*
****************************************
* DESCRIPTIVE ENDOGENOUS
****************************************
*Endogenous variables
tabstat $yhh_main, stat(mean sd p25 p50 p75) by(year)
estimates clear
foreach x in $impY{
eststo: qui reg `x' year2016
}
esttab using "$directory\_temp\ttest.csv", ///
	cells(b(fmt(3)) t(fmt(2)) p(fmt(2))) ///
	drop(_cons) replace
foreach x of varlist $yhh {
quiet sdtest `x', by(year)
di r(F) `","' r(p)
}
estimates clear
foreach x in $yhh {
eststo: qui qreg `x' year2016
}
esttab using "$directory\_temp\mtest.csv", ///
	cells(b(fmt(3)) t(fmt(2)) p(fmt(2))) ///
	drop(_cons) replace
*matrix 
graph matrix $yhh, half jitter(2)
*boxplot
graph drop _all
set graph off
foreach x in $yhh{
recode year2016 (1=0.5)
bysort year2016: egen med = median(`x')
bysort year2016: egen lqt = pctile(`x'), p(25)
bysort year2016: egen uqt = pctile(`x'), p(75)
bysort year2016: egen iqr = iqr(`x')
bysort year2016: egen mean = mean(`x')
bysort year2016: egen ls = min(max(`x', lqt-1.5*iqr))
bysort year2016: egen us = max(min(`x', uqt+1.5*iqr)) 
gen outliers = `x' if(`x'<=lqt-1.5*iqr | `x'>=uqt+1.5*iqr)

replace ls=0 if ls<=0

twoway rbar lqt med year2016, fcolor(gs6) lcolor(black) barw(.3) lwidth(vthin) || ///
       rbar med uqt year2016, fcolor(gs6) lcolor(black) barw(.3) lwidth(vthin) || ///
       rspike lqt ls year2016, lcolor(black) lwidth(vthin) || ///
       rspike uqt us year2016, lcolor(black) lwidth(vthin) || ///
       rcap ls ls year2016, msize(*20) lcolor(black) lwidth(vthin) || ///
       rcap us us year2016, msize(*20) pstyle(p1) lwidth(vthin) || ///
       scatter mean year2016, msymbol(+) msize(*1) fcolor(plb2) mcolor(red) ///
       legend(off) xtitle("") ytitle("`: var label `x''") ///
       graphregion(fcolor(white)) note("no out.") ///
	   xlab(-.2 " " 0 "2010" 0.5 "2016-17" 0.7 " ", notick) name(box_`x', replace) 
drop med lqt uqt iqr mean ls us outliers
}

graph dir 
graph combine box_imp1_ds_totDEF1000 box_imp1_is_totDEF1000 box_imp1_debt_burden box_imp1_interest_burden, name(box_main, replace)

graph combine box_loanamount_HHDEF1000 box_dar_HH box_dir_HH, name(box_rob, replace)

graph combine box_flr_HH box_ilr2_HH box_iglr_HH box_niglr_amount_HH, name(box_oth, replace)


*graph save box_raw "$directory\_temp\box_raw.pdf", replace 
*graph save box_ratio "$directory\_temp\box_ratio.pdf", replace
set graph on
graph dis box_main
graph dis box_rob
graph dis box_oth

tabstat ilr_amount_HH ilr2_HH flr_HH niglr_amount_HH iglr_HH, stat(n mean sd q) by(year)
/*
Hausse de l'endettement formel, baisse de l'informel
Hausse de l'endettement non générateur de revenus
*/

****************************************
* END
*/



/*
****************************************
* CORRELATION
****************************************
*correlation between ego1 skills and yhh
cpcorr $ego1 \ $yhh , format(%4.3f)
putexcel set "$directory\_temp\_cpcorrC.xlsx", replace
putexcel A1=matrix(r(C))
putexcel set "$directory\_temp\_cpcorrp.xlsx", replace
putexcel A1=matrix(r(p))
*correlation in ego1
cpcorr $ego1, format(%4.3f)
putexcel set "$directory\_temp\_cpcorrC.xlsx", replace
putexcel A1=matrix(r(C))
putexcel set "$directory\_temp\_cpcorrp.xlsx", replace
putexcel A1=matrix(r(p))
*correlation in y
cpcorr $yhh if year==2010, format(%4.3f)
putexcel set "$directory\_temp\_cpcorrC.xlsx", replace
putexcel A1=matrix(r(C))
putexcel set "$directory\_temp\_cpcorrp.xlsx", replace
putexcel A1=matrix(r(p))
****************************************
* END
*/


/*
DRAFT EXAMPLE
*Global
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* imp1_debt_burden_* imp1_interest_burden_* using "$directory\_temp\graph_table\econ_all_global.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	varlabels(_cons Constant) ///
	replace f
	
*Robustness
esttab loanamount_HHDEF1000_* dar_HH_* dir_HH_* using "$directory\_temp\graph_table\econ_all_rob.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	varlabels(_cons Constant) ///
	replace f

*Type and use
esttab flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\graph_table\econ_all_type.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(3)star)" "se(fmt(3)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	varlabels(_cons Constant) ///
	replace f
*/



			

			
			
			

****************************************
* ECON --> EGO 3
****************************************
*GLOBAL
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont , re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont , re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
estimates dir
/*
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step1", replace)
restore
*/
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* using "$pdf\INPUT\econ_all_global_p1.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	varlabels(_cons Constant) ///
	replace f
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* using "$pdf\INPUT\econ_all_global_p1.tex", replace f ///
	label booktabs b(2) p(2) eqlabels(none) alignment(S) collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	varlabels(_cons Constant) 	
esttab imp1_debt_burden_* imp1_interest_burden_* using "$pdf\INPUT\econ_all_global_p2.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	varlabels(_cons Constant) ///
	replace f
esttab loanamount_HHDEF1000_* dar_HH_* dir_HH_* using "$pdf\INPUT\econ_all_rob_p1.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	varlabels(_cons Constant) ///
	replace f
esttab loanamount_HHDEF1000_* dar_HH_* dir_HH_* using "$pdf\INPUT\econ_all_rob_p2.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	varlabels(_cons Constant) ///
	replace f
esttab flr_HH_* ilr2_HH_* using "$pdf\INPUT\econ_all_type_p1.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	varlabels(_cons Constant) ///
	replace f
esttab iglr_HH_* niglr_amount_HH_* using "$pdf\INPUT\econ_all_type_p2.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE $HHcont $ego3cont) ///
	varlabels(_cons Constant) ///
	replace f




















*Male
estimates clear
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if sex1_ego3==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if sex1_ego3==0, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
*global directory "D:\En_cours\Research-Skills_and_debt\PANEL"
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
/*
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step3|male", replace)
restore
*/
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* imp1_debt_burden_* imp1_interest_burden_* using "$directory\_temp\graph_table\econ_male_global.tex", ///
	eqlabels(none) label ///
	collabels("\multicolumn{1}{c}{$\beta$/SE}") ///
	booktabs b(2) p(2) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	refcat(assets_NSDEF1000 "\emph{Structures}" annualincome_HHDEF1000 "\emph{HH characteristics}" new_CO_r_std1_ego3 "\emph{Perso. traits - EFA}" EGOcrOP1_r_std_ego3 "\emph{Big-Five}" EGOraven1_r_std_ego3 "\emph{Cognitive skills}" age1_ego3 "\emph{Indiv. characteristics}", nolabel) ///
	cells("b(fmt(2)star)" "se(fmt(2)par)") ///	
	stats(N N_g rho r2 r2_w r2_b r2_o, fmt(0 0 2 2 2 2 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Nb. of groups"' `"$\uprho$"' `"\$R^2$"' `"Within \$R^2$"' `"Between \$R^2$"' `"Overall \$R^2$"')) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	varlabels(_cons Constant) ///
	replace f






















*Female
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if sex1_ego3==1, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if sex1_ego3==1, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "D:\En_cours\Research-Skills_and_debt\PANEL"
*global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step3|female", replace)
restore

























*Dalits
foreach x in $yhh{
qui xtreg `x' $struct $HHcont $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if caste_club==1, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if caste_club==1, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step2|dalits", replace)
restore

























*Middle upper
foreach x in $yhh{
qui xtreg `x' $struct $HHcont $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if caste_club==2, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if caste_club==2, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step2|midup", replace)
restore





























*PCA: lower
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich==0, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step2|pca-lower", replace)
restore



























*PCA: richer
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich==1, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich==1, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step2|pca-richer", replace)
restore












*PCA: lower no caste
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich_nocaste==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich_nocaste==0, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step2|pca-lowernocaste", replace)
restore




















*PCA: richer no caste
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich_nocaste==1, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if efa_rich_nocaste==1, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step2|pca-richernocaste", replace)
restore



















*RELATION: head
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if relation_head==0, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if relation_head==0, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
*global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
global directory "D:\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step4|head", replace)
restore




















*RELATION: not head
foreach x in $yhh{
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont if relation_head==1, re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont if relation_head==1, re cluste(panelvar)
est store `x'_CREnew, title(new)
}
*global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
global directory "D:\En_cours\Research-Skills_and_debt\PANEL"
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step4|notahead", replace)
restore





















/*
****************************************
* ECON --> EGO 3 ---- WITHOUT ESCO
****************************************

global ego3new new_CO_r_std1_ego3 new_ES_r_std1_ego3 new_OPEX_r_std1_ego3 new_AG_r_std1_ego3 EGOraven1_r_std_ego3 EGOlit1_r_std_ego3 EGOnum1_r_std_ego3

*ONLY STRUCT AS FIRST STEP
foreach x in $yhh{
qui reg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE
est store `x'_POLS, title(Pooled OLS)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE, fe
est store `x'_FE, title(FE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3 $ego3cont $ego3mean $meanstruct $meanHHcont , re cluste(panelvar)
est store `x'_CRE, title(CRE)
qui xtreg `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego3new $ego3cont $ego3mean $meanstruct $meanHHcont , re cluste(panelvar)
est store `x'_CREnew, title(new)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
estimates dir
esttab imp1_ds_totDEF1000_* imp1_is_totDEF1000_* loanamount_HHDEF1000_* imp1_debt_burden_* imp1_interest_burden_* dar_HH_* dir_HH_* flr_HH_* ilr2_HH_* iglr_HH_* niglr_amount_HH_* using "$directory\_temp\_reg.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego3mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std_ego3 "Big-Five" EGOraven1_r_std_ego3 "Cognitive skills" age1_ego3 "Indiv. characteristics" new_CO_r_std1_ego3 "Perso. traits - EFA", nolabel) ///
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
export excel using "$directory\_temp\ECON_ego3.xlsx", sheet("Step1testnoESCO", replace)
restore
****************************************
* END
*/





/*
****************************************
* ECON --> EGO 1 DUMMY
****************************************
*All sample
foreach x in $yhhbin{
qui xtprobit `x' $struct $HHcont caste_group2 caste_group3 $villagesFE $ego1 $ego1cont $ego1mean $meanstruct $meanHHcont , re vce(rob)
est store `x'_CRE, title(CRE)
}
global directory "C:\Users\\$name\Downloads\En_cours\Research-Skills_and_debt\PANEL"
estimates dir
esttab imp1_debt_bin_* imp1_interest_bin_* dar_HH_bin_* dir_HH_bin_* using "$directory\_temp\_probit.csv", ///
	cells(b(star fmt(3)) /// 
	se(par fmt(2))) ///
	legend label varlabels(_cons constant) ///
	stats(N N_g chi2 p rho r2_w r2_b r2_o, fmt(0 0 3 3 3 3 3 3)) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	drop($ego1mean $meanstruct $meanHHcont $villagesFE) ///
	refcat(assets_NSDEF1000 "Structures" annualincome_HHDEF1000 "HH characteristics" EGOcrOP1_r_std "Personality traits" EGOraven1_r_std "Cognitive skills" age1 "Indiv. characteristics", nolabel) ///
	replace
estimates clear
preserve
import delimited "$directory\_temp\_probit.csv", delimiter(",") varnames(nonames) clear
qui des
sca def k=r(k)
forvalues i=1(1)`=scalar(k)'{
replace v`i'=substr(v`i',3,.)
replace v`i'=substr(v`i',1,strlen(v`i')-1)
}
export excel using "$directory\_temp\ECON_draft1.xlsx", sheet("Step4|dummy", replace)
restore
*Not very good, better as continuous
****************************************
* END
*/












/*
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
*/



/*
***********
** FOR FURTHER
***********
*SGPV de Blume (World Beyond [...]) 
*ssc install sgpv
sgpv : estimation
*If 0, ok good !
*BP-LM
xtreg dar_HH $ego1 $ego1cont $struct caste_group2 caste_group3 $HHcont $meanego $meanstruct $meanHHcont if caste_group==1, re vce(rob)
xtreg0
*MARGINS
margins, dydx($ego1) post
 margins, expression(normalden(xb()*(1/sqrt(1 + e(sigma_u)^2)))*(_b[kids])*(1/sqrt(1 + e(sigma_u)^2))) force
*GRAPH
*ssc install coefplot
xtreg dar_HH $ego1 $ego1cont $struct caste_group2 caste_group3 $HHcont $ego1mean $meanstruct $meanHHcont, re cluster(panelvar)
coefplot, drop($ego1cont $struct caste_group2 caste_group3 $HHcont $ego1mean $meanstruct $meanHHcont _cons) xline(0) levels(95 90)
*/
/*
*DECOMPOSITION FIELD 2004 
*ssc install ineqrbd
help ineqrbd
ineqrbd dir_HH $ego1new $ego1cont $struct $HHcont, noreg

*DISTRIBUTION REGRESSION
*net install drprocess, from("https://sites.google.com/site/mellyblaise/")
*ssc install moremata
help drprocess
help plotprocess
drprocess dir_HH $ego1new $ego1cont $struct $HHcont if year==2016
plotprocess dep_ratio, level(0.05)

*CDECO Check Blaise Melly
*net install counterfactual, from("https://sites.google.com/site/mellyblaise/")
help cdeco
cdeco dir_HH $ego1new $ego1cont $struct $HHcont if year==2016, group(sex1)
*/


*Sample en fonction des revenus pour voir emboitement cognitive non cognitive : si jamais ce sont les pauvres qui ont cog signi et les riches ont perso 

***********
** QUANTIL REG
***********
/*
ssc install xtqreg
xtqreg imp1_debt_burden caste_group2 caste_group3 $villagesFE
*No

ssc install qregpd
ssc install moremata
qregpd imp1_debt_burden caste_group2 caste_group3, id(panelvar) fix(year2016) instruments(caste_group2 caste_group3)
*/

***********
** SOME FEW TESTS
***********
/*
*Multicollinearity check
reg dsr_HH $PERSO $CONT
vif
*A priori il n'y en a pas, donc le modèle n'est pas deg deg !
*Je lance toutes mes reg (tous les y avec les sous échantillon par caste pour voir ce que ca donne) avec xtgls et mean comme font Brown et Taylor
*/
