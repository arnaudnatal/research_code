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
* INCOME - Social mobility
****************************************
use"panel_v3", clear

keep HHID_panel year monthlyincome_pc caste
rename monthlyincome_pc income
reshape wide income, i(HHID_panel) j(year)

foreach x in 2010 2016 2020 {
xtile quint`x'=income`x', n(5)
}

* Diff quintile for stat
gen diffq1=quint2016-quint2010
gen absdiffq1=abs(diffq1)
gen catdiffq1=.
label define catdiffq1 1"Immobility" 2"Upward" 3"Downward" 
label values catdiffq1 catdiffq1
replace catdiffq1=1 if diffq1==0 & diffq1!=.
replace catdiffq1=2 if diffq1>0 & diffq1!=.
replace catdiffq1=3 if diffq1<0 & diffq1!=.

gen diffq2=quint2020-quint2016
gen absdiffq2=abs(diffq2)
gen catdiffq2=.
label define catdiffq2 1"Immobility" 2"Upward" 3"Downward" 
label values catdiffq2 catdiffq2
replace catdiffq2=1 if diffq2==0 & diffq2!=.
replace catdiffq2=2 if diffq2>0 & diffq2!=.
replace catdiffq2=3 if diffq2<0 & diffq2!=.



* Transition matrix
ta quint2010 quint2016, row nofreq chi2
ta quint2016 quint2020, row nofreq chi2

* Immobility and upward and downward mobility
ta catdiffq1
ta catdiffq2

ta catdiffq1 catdiffq2, row nofreq
ta catdiffq1 catdiffq2, chi2 exp cchi2

tabstat absdiffq1 if catdiffq1!=1, stat(n mean) by(catdiffq1)
tabstat absdiffq2 if catdiffq2!=1, stat(n mean) by(catdiffq2)

****************************************
* END












****************************************
* WEALTH - Social mobility
****************************************
use"panel_v3", clear

keep HHID_panel year assets_total_pc caste
rename assets_total_pc assets
reshape wide assets, i(HHID_panel) j(year)

foreach x in 2010 2016 2020 {
xtile quint`x'=assets`x', n(5)
}

* Diff quintile for stat
gen diffq1=quint2016-quint2010
gen absdiffq1=abs(diffq1)
gen catdiffq1=.
label define catdiffq1 1"Immobility" 2"Upward" 3"Downward" 
label values catdiffq1 catdiffq1
replace catdiffq1=1 if diffq1==0 & diffq1!=.
replace catdiffq1=2 if diffq1>0 & diffq1!=.
replace catdiffq1=3 if diffq1<0 & diffq1!=.

gen diffq2=quint2020-quint2016
gen absdiffq2=abs(diffq2)
gen catdiffq2=.
label define catdiffq2 1"Immobility" 2"Upward" 3"Downward" 
label values catdiffq2 catdiffq2
replace catdiffq2=1 if diffq2==0 & diffq2!=.
replace catdiffq2=2 if diffq2>0 & diffq2!=.
replace catdiffq2=3 if diffq2<0 & diffq2!=.


* Transition matrix
ta quint2010 quint2016, row nofreq chi2
ta quint2016 quint2020, row nofreq chi2

* Immobility and upward and downward mobility
ta catdiffq1
ta catdiffq2

ta catdiffq1 catdiffq2, row nofreq chi2

tabstat absdiffq1 if catdiffq1!=1, stat(n mean) by(catdiffq1)
tabstat absdiffq2 if catdiffq2!=1, stat(n mean) by(catdiffq2)

****************************************
* END





















****************************************
* Cowell and Flachaire (2018, QE)
****************************************

********** Income

* 2010 - 2016-17
use"panel_v3", clear
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc3
drop if inc1==.
drop if inc2==.
rename inc1 var1
rename inc2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc1.txt", delimiter(tab) replace


* 2016-17 - 2020-21
use"panel_v3", clear
keep HHID_panel year monthlyincome_pc
rename monthlyincome_pc inc
replace inc=inc*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide inc, i(HHID_panel) j(year)
rename HHID_panel hhid
drop inc1
drop if inc2==.
drop if inc3==.
rename inc2 var1
rename inc3 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\incomepc2.txt", delimiter(tab) replace



********** Assets

* 2010 - 2016-17
use"panel_v3", clear
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass3
drop if ass1==.
drop if ass2==.
drop if ass1==0
drop if ass2==0
rename ass1 var1
rename ass2 var2
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc1.txt", delimiter(tab) replace


* 2016-17 - 2020-21
use"panel_v3", clear
keep HHID_panel year assets_total_pc
rename assets_total_pc ass
replace ass=ass*1000
replace year=1 if year==2010
replace year=2 if year==2016
replace year=3 if year==2020
reshape wide ass, i(HHID_panel) j(year)
rename HHID_panel hhid
drop ass1
drop if ass2==.
drop if ass3==.
rename ass2 var1
rename ass3 var2
drop if var1==0
drop if var2==0
export delimited using "C:\Users\Arnaud\Documents\GitHub\research_code\inequalities\wealthpc2.txt", delimiter(tab) replace

****************************************
* END















****************************************
* Graph CF
****************************************

********** INCOME RANK
import excel "CF_income.xlsx", sheet("rank") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2
*
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Monthly income per capita rank mobility") ///
ytitle("") ylabel(.2(.1).8) ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(incrank, replace)




********** WEALTH RANK
import excel "CF_wealth.xlsx", sheet("rank") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2
*
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Wealth per capita rank mobility") ///
ytitle("") ylabel(.2(.1).8) ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(assrank, replace)




********** INCOME VALUE
import excel "CF_income.xlsx", sheet("inc") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2
*
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Monthly income per capita mobility") ///
ytitle("") ylabel(0(1)3) ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(incval, replace)







********** WEALTH VALUE
import excel "CF_wealth.xlsx", sheet("ass") firstrow clear
label define timeframe 1"2010 - 2016-17" 2"2016-17 - 2020-21"
label values timeframe timeframe
label define sample 1"Overall" 2"Downward" 3"Upward"
label values sample sample
keep if sample==1
drop if alpha==-1
drop if alpha==2
*
twoway ///
(connected index alpha if timeframe==1, color(plg1)) ///
(rarea CI_upper CI_lower alpha if timeframe==1, color(plg1%10)) ///
(connected index alpha if timeframe==2, color(plr1)) ///
(rarea CI_upper CI_lower alpha if timeframe==2, color(plr1%10)) ///
, title("Wealth per capita mobility") ///
ytitle("") ylabel(0(1)3) ///
xtitle("α") xlabel(-.5(.5)1.5) ///
legend(order(1 "2010 to 2016-17" 3 "2016-17 to 2020-21") pos(6) col(2)) ///
scale(1.2) name(assval, replace)






********** Combine
grc1leg incrank assrank incval assval, col(2) name(combcomb, replace) note("{it:Note:} For 388 households in 2010 and 2016-17, and 485 in 2016-17 and 2020-21.", size(vsmall))
graph export "graph_pc/CFgraph_pc.png", as(png) replace

****************************************
* END
























****************************************
* Reldist
****************************************
use"panel_v3", clear

/*
doi: 10.1177/1536867X211063147
*/

gen assets=assets_total_pc*1000
gen income=monthlyincome_pc*1000

keep HHID_panel year assets income
reshape wide assets income, i(HHID_panel) j(year)



*
reldist cdf income2016 income2010
reldist graph
/*
La valeur du 80e centile en 2010 est égale à la valeur du 60e en 2016-17.
*/

*
reldist pdf income2016 income2010
reldist graph

reldist pdf income2020 income2016
reldist graph
/*
Une densité relative supérieure à un signifie que le groupe 2016 est surreprésentée au niveau correspondant des gains salariaux, les valeurs inférieures à un signifient que le groupe 2016 est sous-représentée par rapport au groupe 2010.
Nous pouvons maintenant voir directement que les differences distributionnelles les plus importantes se situent au bas de la distribution.
Le groupe 2016 a une densité beaucoup plus importante que le groupe 2010 dans les régions situées en dessous du quantile de 10 % du groupe 2010 (facteur de surreprésentation jusqu'à 2). Aux quantiles supérieurs, le groupe 2016 est sur-représentée également.
*/



/*
doi: 10.1016/j.econlet.2022.110738
Enfin, la figure 2 montre la densité relative des femmes (avec les hommes comme groupe de référence). Si les deux distributions comparées sont identiques, les densités relatives seront égales à 1. Si la distribution de comparaison a tendance à avoir des valeurs plus faibles que la distribution de référence, la densité relative sera supérieure à 1 pour de faibles valeurs de r et inférieure à 1 pour de grandes valeurs de r, où r (y) et est la variable d'intérêt (voir Jann, 2021, pour plus de détails). La figure 2 présente les deux comparaisons de (a) ln gains et (b) GPA, montrant dans le premier panneau que les femmes sont surreprésentées en termes de gains inférieurs et de GPA inférieure et sous-représentées aux niveaux supérieurs. Les deuxièmes panneaux pour chaque variable comparent les distributions relatives lorsqu'elles sont ajustées (équilibrées) par niveau académique (à l'aide d'une fonction d'appariement logit) ; dans les deux diagrammes, les densités relatives ne sont pas statistiquement différentes de 1 (sauf aux niveaux de revenus les plus élevés). Cela suggère que la promotion d'un nombre relativement plus élevé de femmes à des grades supérieurs réduira de manière significative l'écart entre les salaires et la moyenne générale. Le tableau A.2 montre qu'en 2021, 48,9 % des membres masculins du personnel de l'Institut d'enseignement supérieur et de recherche (DUBS) étaient professeurs, alors que seulement 25,6 % des femmes avaient le grade de professeur titulaire. La figure A.2 montre la répartition des grades académiques par sexe pour les écoles de commerce du groupe Russel, avec 21,5 % de femmes professeurs en 2019/20.
*/



****************************************
* END




