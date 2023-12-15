*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*December 5, 2023
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------






****************************************
* Coef plot
****************************************
import excel "Testhours.xlsx", sheet("Sheet1") firstrow clear

* Label
replace level="1" if level=="Household"
replace level="2" if level=="Individual"
destring level, replace
label define level 1"Ménage" 2"Individu"
label values level level

replace sample="1" if sample=="Total"
replace sample="2" if sample=="Males"
replace sample="3" if sample=="Females"
destring sample, replace
label define sample 1"Total" 2"Hommes" 3"Femmes"
label values sample sample

drop y

*"80 151 68" brick
*"164 204 76" greenlight
*"197 102 63" darkgreen

* Graph HH
preserve
keep if level==1
twoway ///
(rcap max min sample, lcolor("164 204 76")) ///
(scatter coef sample, yline(0, lcolor("197 102 63")) mcolor("80 151 68")) ///
, xlabel(0" " 1"Total" 2"Hommes" 3"Femmes" 4" ", nogrid notick angle(0)) ///
ylab(, angle(vertical)) ///
title("Niveau ménage", size(small)) ///
xtitle("Échantillon") ytitle("Heures travaillées") ///
legend(order(1 "I.C. 95 %" 2 "Coef." ) pos(6) col(2)) ///
note("Modèles à EF", size(vsmall)) scale(1.5) ///
name(hourshh, replace)
restore


* Graph indiv
preserve
keep if level==2
twoway ///
(rcap max min sample, lcolor("164 204 76")) ///
(scatter coef sample, yline(0, lcolor("197 102 63")) mcolor("80 151 68")) ///
, xlabel(1" " 2"Hommes" 3"Femmes" 4" ", nogrid notick angle(0)) ///
ylab(, angle(vertical)) ///
title("Niveau individu", size(small)) ///
xtitle("Échantillon") ytitle("Heures travaillées") ///
legend(order(1 "I.C. 95 %" 2 "Coef." ) pos(6) col(2)) ///
note("Modèles à EF + cluster ménage", size(vsmall)) scale(1.5) ///
name(hoursindiv, replace)
restore


* One graph
grc1leg hourshh hoursindiv, title("Effet du lag de FVI, sans investissement") name(gphcomb, replace)
graph export "Testhours.pdf", as(pdf) replace


****************************************
* END



