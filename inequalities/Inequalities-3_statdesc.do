*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*August 8, 2024
*-----
gl link = "inequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\inequalities.do"
*-------------------------






****************************************
* Evolution of HH composition
****************************************
use"panel_v6", clear

tabstat HHsize HH_count_child HH_count_adult, stat(mean) by(year)
tabstat HHsize HH_count_child HH_count_adult if dalits==1, stat(mean) by(year)
tabstat HHsize HH_count_child HH_count_adult if dalits==0, stat(mean) by(year)

cls
foreach i in 2020 {
reg HHsize dalits if year==`i'
reg HH_count_child dalits if year==`i'
reg HH_count_adult dalits if year==`i'
}


/*
Il y a des différences de composition des ménages entre Dalits et non-Dalits donc on va s'intéresser au revenu par tête en tenant compte des équivalences scales. On prend celle de l'OCDE.
*/


****************************************
* END












****************************************
* Income
****************************************

* Income evolution
use"panel_v6", clear
cls
tabstat monthlyincome_mpc, stat(mean) by(year)
tabstat monthlyincome_mpc if caste==1, stat(mean) by(year)
tabstat monthlyincome_mpc if caste==2, stat(mean) by(year)
tabstat monthlyincome_mpc if caste==3, stat(mean) by(year)

oneway monthlyincome_mpc caste if year==2010, tab
oneway monthlyincome_mpc caste if year==2016, tab
oneway monthlyincome_mpc caste if year==2020, tab

* Occupation by caste
use"panel_v6", clear
cls
foreach i in 2010 2016 2020 {
ta d_agrise caste if year==`i', col nofreq chi2 
ta d_agricasual caste if year==`i', col nofreq chi2 
ta d_nonagricasual caste if year==`i', col nofreq chi2 
ta d_nonagrireg caste if year==`i', col nofreq chi2 
ta d_nonagrise caste if year==`i', col nofreq chi2 
ta d_nrega caste if year==`i', col nofreq chi2 
}

* Occupation by caste and gender
use"panelindiv_v0", clear

ta moc_indiv caste, chi2 exp cchi2

****************************************
* END














****************************************
* Lorenz
****************************************
use"panel_v6", clear

keep HHID_panel year monthlyincome_mpc
reshape wide monthlyincome_mpc, i(HHID_panel) j(year)
lorenz estimate monthlyincome_mpc2010 monthlyincome_mpc2016 monthlyincome_mpc2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" "G=0.31" 2 "2016-17" "G=0.42" 3 "2020-21" "G=0.48")) xtitle("Population share") ytitle("Cumulative income proportion") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio(1) name(mpc, replace)
graph export "Lorenz.png", as(png) replace

****************************************
* END

















****************************************
* Gini decomposition
****************************************

***** Decomposition Gini by income source
use"panel_v6", clear

global MPC annualincome_compo2_mpc incagrise_mpc incagricasual_mpc incnonagricasual_mpc incnonagrireg_mpc incnonagrise_mpc incnrega_mpc

descogini $MPC if year==2010
descogini $MPC if year==2016
descogini $MPC if year==2020



***** Graph
import excel "Gini.xlsx", sheet("Sheet1") firstrow clear
label define occupation 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA"
label values occupation occupation

* Sk
twoway ///
(connected Sk year if occupation==1, yline(0, lcolor(black))) ///
(connected Sk year if occupation==2) ///
(connected Sk year if occupation==3) ///
(connected Sk year if occupation==4) ///
(connected Sk year if occupation==5) ///
(connected Sk year if occupation==6) ///
, title("Share in total income") ylabel(0(.1).5) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(sk, replace)

* Gk
twoway ///
(connected Gk year if occupation==1, yline(0, lcolor(black))) ///
(connected Gk year if occupation==2) ///
(connected Gk year if occupation==3) ///
(connected Gk year if occupation==4) ///
(connected Gk year if occupation==5) ///
(connected Gk year if occupation==6) ///
,title("Income source Gini") ylabel(0.4(.1)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(gk, replace)

* Rk
twoway ///
(connected Rk year if occupation==1, yline(0, lcolor(black))) ///
(connected Rk year if occupation==2) ///
(connected Rk year if occupation==3) ///
(connected Rk year if occupation==4) ///
(connected Rk year if occupation==5) ///
(connected Rk year if occupation==6) ///
, title("Gini correlation with income rankings") ylabel(-.4(.2)1) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(rk, replace)

* Share
replace Share=0 if Share<0
twoway ///
(connected Share year if occupation==1, yline(0, lcolor(black))) ///
(connected Share year if occupation==2) ///
(connected Share year if occupation==3) ///
(connected Share year if occupation==4) ///
(connected Share year if occupation==5) ///
(connected Share year if occupation==6) ///
, title("Share in total-income inequality") ylabel(0(.1).6) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(share, replace)

* Percentage
twoway ///
(connected Percentage year if occupation==1, yline(0, lcolor(black))) ///
(connected Percentage year if occupation==2) ///
(connected Percentage year if occupation==3) ///
(connected Percentage year if occupation==4) ///
(connected Percentage year if occupation==5) ///
(connected Percentage year if occupation==6) ///
, title("% change in Gini") ylabel(-.2(.1).2) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Agri self-employed" 2 "Agri casual" 3 "Casual" 4 "Regular" 5 "Self-employed" 6 "MGNREGA") pos(6) col(3)) name(percentage, replace)

***** Combine
grc1leg sk gk rk share percentage, name(decompo, replace)
graph export "Decompo.png", as(png) replace

****************************************
* END














****************************************
* Intra-HH
****************************************
cls
use"panel_v6", clear


* Desc
foreach y in absdiffshare {
tabstat `y', stat(n mean q) by(year)

* By caste
tabstat `y' if caste==1, stat(n mean q) by(year)
tabstat `y' if caste==2, stat(n mean q) by(year)
tabstat `y' if caste==3, stat(n mean q) by(year)

* By poor
tabstat `y' if poor_HH==0, stat(n mean q) by(year)
tabstat `y' if poor_HH==1, stat(n mean q) by(year)

* By assets
tabstat `y' if assets_cat==1, stat(n mean q) by(year)
tabstat `y' if assets_cat==2, stat(n mean q) by(year)
tabstat `y' if assets_cat==3, stat(n mean q) by(year)

* By income
tabstat `y' if income_cat==1, stat(n mean q) by(year)
tabstat `y' if income_cat==2, stat(n mean q) by(year)
tabstat `y' if income_cat==3, stat(n mean q) by(year)
}


* absdiffshare
stripplot absdiffshare, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
xmtick(0(.1)1) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("Relative differences of income") ytitle("") ///
title("Total") name(c0, replace)



****************************************
* END


