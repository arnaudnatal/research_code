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
* Inter-HH: Desc
****************************************

***** Activities and caste
use"panelindiv_v0", clear

ta employed
keep if employed==1
clonevar occupation=mainocc_occupation_indiv
recode occupation (5=4) (6=5) (7=6)
label define occupation2 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA"
label values occupation occupation2

ta occupation year, col nofreq
ta occupation caste, cchi2 chi2 exp


* Differences by castes
use"panel_v6", clear

keep HHID_panel year caste annualincome_HH

tabstat annualincome_HH, stat(mean) by(year)
tabstat annualincome_HH if caste==1, stat(mean) by(year)
tabstat annualincome_HH if caste==2, stat(mean) by(year)
tabstat annualincome_HH if caste==3, stat(mea) by(year)

reshape wide annualincome_HH, i(HHID_panel) j(year)

gen growth2010=(annualincome_HH2010/annualincome_HH2010)*100
gen growth2016=(annualincome_HH2016/annualincome_HH2010)*100
gen growth2020=(annualincome_HH2020/annualincome_HH2010)*100

replace growth2016=0 if growth2016==. & annualincome_HH2016!=.

tabstat growth2016, stat(n mean) by(caste)


****************************************
* END














****************************************
* Lorenz
****************************************

***** Without intra-

* Per household
/*
preserve
use"panel_v6", clear

keep HHID_panel year annualincome_HH
rename annualincome_HH income
reshape wide income, i(HHID_panel) j(year)

lorenz estimate income2010 income2016 income2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio(1) name(HH, replace)
restore
*/

* Per capita
/*
preserve
use"panelindiv_v0", clear
keep HHID_panel INDID_panel year annualincome_pc
sort HHID_panel year INDID_panel
rename annualincome_pc incomepc
reshape wide incomepc, i(HHID_panel INDID_panel) j(year)
lorenz estimate incomepc2010 incomepc2016 incomepc2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio(1) name(pc, replace)
restore
*/

* Per active
preserve
use"panelindiv_v0", clear
keep HHID_panel INDID_panel year annualincome_pa wp_inactive
drop if wp_inactive==1
drop wp_inactive
sort HHID_panel year INDID_panel
rename annualincome_pa incomepa
reshape wide incomepa, i(HHID_panel INDID_panel) j(year)
lorenz estimate incomepa2010 incomepa2016 incomepa2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio(1)title("Without intra-")  name(pa, replace)
restore





***** With intra-

* By active
preserve
use"panelindiv_v0", clear
keep HHID_panel INDID_panel year annualincome_indiv wp_inactive
drop if wp_inactive==1
drop wp_inactive
recode annualincome_indiv (.=0)
sort HHID_panel year INDID_panel
rename annualincome_indiv incomeindiv
reshape wide incomeindiv, i(HHID_panel INDID_panel) j(year)
lorenz estimate incomeindiv2010 incomeindiv2016 incomeindiv2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio(1) title("With intra-") name(ba, replace)
restore


* By occupied
/*
preserve
use"panelindiv_v0", clear
keep HHID_panel INDID_panel year annualincome_indiv
drop if annualincome_indiv==.
sort HHID_panel year INDID_panel
rename annualincome_indiv incomeindiv
reshape wide incomeindiv, i(HHID_panel INDID_panel) j(year)
lorenz estimate incomeindiv2010 incomeindiv2016 incomeindiv2020, gini
lorenz graph, overlay noci legend(pos(6) col(3) order(1 "2010" 2 "2016-17" 3 "2020-21")) xtitle("Population share") ytitle("Cumulative income proportion") xlabel(0(10)100) ylabel(0(.1)1) nodiagonal aspectratio(1) name(bo, replace)
restore
*/

***** Combine
grc1leg pa ba, name(active, replace)
graph export "Lorenz.png", as(png) replace



****************************************
* END

















****************************************
* Gini decomposition
****************************************

***** Decomposition Gini by income source
use"panel_v6", clear


* By occupation with regular instead of qualified and non-qualified
cls
global PA annualincome_HH_compo2_pa incagrise_HH_pa incagricasual_HH_pa incnonagricasual_HH_pa incnonagrireg_HH_pa incnonagrise_HH_pa incnrega_HH_pa

descogini $PA if year==2010
descogini $PA if year==2016
descogini $PA if year==2020


/*
* By agri/non agri
cls
global HHlevel1 annualincome_HH_compo1 incomeagri_HH incomenonagri_HH
global PClevel1 annualincome_HH_compo1_pa incomeagri_HH_pa incomenonagri_HH_pc

descogini $HHlevel1 if year==2010
descogini $HHlevel1 if year==2016
descogini $HHlevel1 if year==2020

descogini $PClevel1 if year==2010
descogini $PClevel1 if year==2016
descogini $PClevel1 if year==2020


* By occupation
cls
global HHlevel2 annualincome_HH_compo2 incagrise_HH incagricasual_HH incnonagricasual_HH incnonagriregnonquali_HH incnonagriregquali_HH incnonagrise_HH incnrega_HH
global PClevel2 annualincome_HH_compo2_pa incagrise_HH_pa incagricasual_HH_pa incnonagricasual_HH_pa incnonagriregnonquali_HH_pa incnonagriregquali_HH_pa incnonagrise_HH_pa incnrega_HH_pa

descogini $HHlevel2 if year==2010
descogini $HHlevel2 if year==2016
descogini $HHlevel2 if year==2020

descogini $PClevel2 if year==2010
descogini $PClevel2 if year==2016
descogini $PClevel2 if year==2020
*/


***** Graph
import excel "Gini.xlsx", sheet("Sheet1") firstrow clear
label define occupation 0"Total" 1"Agri self-employed" 2"Agri casual" 3"Casual" 4"Regular" 5"Self-employed" 6"MGNREGA"
label values occupation occupation

* Sk
twoway ///
(connected Sk year if occupation==1, yline(0, lcolor(black))) ///
(connected Sk year if occupation==2) ///
(connected Sk year if occupation==3) ///
(connected Sk year if occupation==4) ///
(connected Sk year if occupation==5) ///
(connected Sk year if occupation==6) ///
, ytitle("Share in total income") ylabel(0(.1).5) ///
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
, ytitle("Income source Gini") ylabel(0.4(.1)1) ///
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
, ytitle("Gini correlation with income rankings") ylabel(-.3(.1).9) ///
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
, ytitle("Share in total-income inequality") ylabel(0(.1).6) ///
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
, ytitle("% change in Gini") ylabel(-.2(.1).2) ///
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
*foreach y in sharewomen absdiffshare {
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


* sharewomen
stripplot sharewomen, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
xmtick(0(.1)1) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("Share women") ytitle("") ///
title("Total") name(c0, replace)



****************************************
* END


