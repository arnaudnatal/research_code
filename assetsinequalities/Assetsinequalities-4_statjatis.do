*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*September 9, 2024
*-----
gl link = "assetsinequalities"
*Desc
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\assetsinequalities.do"
*-------------------------










****************************************
* Evolution of assets level by jatis
****************************************
use"panel_v1", clear

rename assets_total assets_m
gen assets_se=assets_m
gen assets_iqr=assets_m

collapse (mean) assets_m (semean) assets_se (iqr) assets_iqr, by(jatis year)

* 95 CI
gen assets_lb=assets_m-(assets_se*1.96)
gen assets_ub=assets_m+(assets_se*1.96)

* Growth rate
reshape wide assets_m assets_se assets_iqr assets_lb assets_ub, i(jatis) j(year)
gen growth2010=100
gen growth2016=assets_m2016*100/assets_m2010
gen growth2020=assets_m2020*100/assets_m2010
reshape long assets_m assets_se assets_iqr assets_lb assets_ub growth, i(jatis) j(year)



***** Assets level
twoway ///
(connected assets_m year if jatis==1) ///
(connected assets_m year if jatis==2) ///
(connected assets_m year if jatis==3) ///
(connected assets_m year if jatis==4) ///
(connected assets_m year if jatis==5) ///
(connected assets_m year if jatis==6) ///
(connected assets_m year if jatis==7) ///
(connected assets_m year if jatis==8) ///
(connected assets_m year if jatis==9) ///
(connected assets_m year if jatis==10) ///
(connected assets_m year if jatis==11) ///
(connected assets_m year if jatis==12) ///
, title("Assets") ytitle("1k rupees") ylabel(0(1000)7000) ///
xtitle("") ///
legend(order(1 "Arunthathiyar" 2 "SC" 3 "Muslims" 4 "Nattar" 5 "Vanniyar" 6 "Kulalar" 7 "Asarai" 8 "Mudaliar" 9 "Chettiyar" 10 "Naidu" 11 "Marwari" 12 "Rediyar") pos(6) col(4)) ///
scale(1.2) name(assetsjatis, replace)

****************************************
* END














****************************************
* Decomposition GE by jatis
****************************************
use"panel_v1", clear


***** Stat global
cls
* 2010
ineqdeco assets_total if year==2010, by(jatis)

cls
* 2016
ineqdeco assets_total if year==2016, by(jatis)

cls
* 2020
ineqdeco assets_total if year==2020, by(jatis)



***** Stat par caste
cls
* Dalits
ineqdeco assets_total if year==2010 & caste==1, by(jatis)
ineqdeco assets_total if year==2016 & caste==1, by(jatis)
ineqdeco assets_total if year==2020 & caste==1, by(jatis)

cls
* Middle castes
ineqdeco assets_total if year==2010 & caste==2, by(jatis)
ineqdeco assets_total if year==2016 & caste==2, by(jatis)
ineqdeco assets_total if year==2020 & caste==2, by(jatis)

cls
* Upper castes
ineqdeco assets_total if year==2010 & caste==3, by(jatis)
ineqdeco assets_total if year==2016 & caste==3, by(jatis)
ineqdeco assets_total if year==2020 & caste==3, by(jatis)



***** Graph share pop share assets
import excel "Statdesc.xlsx", sheet("GE_jatis2") firstrow clear
label define jatis 1"Arunthathiyar" 2"SC" 3"Muslims" 4"Nattar" 5"Vanniyar" 6"Kulalar" 7"Asarai" 8"Mudaliar" 9"Chettiyar" 10"Naidu" 11"Marwari" 12"Rediyar"
label values jatis jatis
replace popshare=popshare*100
replace assetsshare=assetsshare*100

* Ratio détenu/population
gen ratio=assetsshare*100/popshare

* Graph
twoway ///
(connected ratio year if jatis==1, yline(100)) ///
(connected ratio year if jatis==2) ///
(connected ratio year if jatis==3) ///
(connected ratio year if jatis==4) ///
(connected ratio year if jatis==5) ///
(connected ratio year if jatis==6) ///
(connected ratio year if jatis==7) ///
(connected ratio year if jatis==8) ///
(connected ratio year if jatis==9) ///
(connected ratio year if jatis==10) ///
(connected ratio year if jatis==11) ///
(connected ratio year if jatis==12) ///
, title("Ratio détenu / pop") ///
ytitle("Percent") ylabel(0(50)350) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "Arunthathiyar" 2 "SC" 3 "Muslims" 4 "Nattar" 5 "Vanniyar" 6 "Kulalar" 7 "Asarai" 8 "Mudaliar" 9 "Chettiyar" 10 "Naidu" 11 "Marwari" 12 "Rediyar") pos(6) col(4))


****************************************
* END

















****************************************
* Graph within
****************************************
import excel "GE.xlsx", sheet("Sheet1") firstrow clear
label define type 1"Level" 2"Base100"
label values type type

* Level within
twoway ///
(connected w_GE0 year if type==1) ///
(connected w_GE1 year if type==1) ///
(connected w_GE2 year if type==1) ///
, title("Share of {it:within} inequalities") ///
ytitle("Percent") ylabel(82(2)96) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "GE(0)" 2 "GE(1)" 3 "GE(2)") pos(6) col(3)) name(sw, replace) scale(1.2)


* Level between
twoway ///
(connected b_GE0 year if type==1) ///
(connected b_GE1 year if type==1) ///
(connected b_GE2 year if type==1) ///
, title("Share of {it:between} inequalities") ///
ytitle("Percent") ylabel(6(2)20) ///
xtitle("") xlabel(2010 2016 2020) ///
legend(order(1 "GE(0)" 2 "GE(1)" 3 "GE(2)") pos(6) col(3)) name(sb, replace) scale(1.2)



* Combine
grc1leg sw sb, name(swb, replace) note("{it:Note:} For 405 households in 2010, 492 in 2016-17, and 626 in 2020-21.", size(vsmall))
graph export "WithinBetween_jatis.png", as(png) replace


****************************************
* END


