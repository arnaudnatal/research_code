*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 22, 2025
*-----
*Figures for all outputs
*
*set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid
*
*cd"C:\Users\Arnaud\Documents\GitHub\research_code\stateneemsis"
cd"C:\Users\anatal\Documents\sonr"
*-------------------------








****************************************
* Lists
****************************************

global authors Nordman Guérin Venkat Michiels Natal Mouchel DiSantolo Lanos Hilger Kumar Girollet DEspallier Goedecke Reboul Kar Seetahul Roesch
global data R N1 N2
global topics Debt Employment Personality Networks Agriculture Gender Income Wealth Inequality Demonetisation Covid Mobility Marriage Trust Caste Migration Education Discrimination Consumption Saving Decisionmaking

****************************************
* END





****************************************
* Graph #1: Type of output
****************************************
use"Papers_v1", clear

/*
À date du XX, qu'avons-nous produit ?
Echantillon : tous les produits.
*/


**********
catplot, over(type) percent vertical ///
ylabel(0(10)80) ///
ytitle("Percentage") ///
title("Type") ///
scale(1.5) ///
name(type, replace)
graph export "figures/type.png", as(png) replace

****************************************
* END






****************************************
* Graph #2: Evolution of production
****************************************
use"Papers_v1", clear

/*
Combien d'articles ont été publiés ?
Echantillon :
	articles publiés,
	chapitres publiés,
	livres publiés,
	working papers terminés ne sont plus soumis
*/
********** Selection
fre type
drop if type>=5
fre status
drop if status==1
drop if status==2

**********
twoway ///
(histogram Year, width(0.5) freq discrete) ///
, ylabel(1(1)4) xlabel(2012(1)2026, angle(90)) ///
ytitle("Number") xtitle("") title("Papers over the years") ///
scale(1.5) note("Submitted papers are removed") name(nb, replace)
graph export "figures/nb.png", as(png) replace


****************************************
* END












****************************************
* Graph #3: Data used
****************************************
use"Papers_v1", clear

/*
Quelles sont les données utilisées ?
Echantillon :
	toutes les productions originales (articles, chapitres, livres) qql soit le statut (publiés, en cours d'écriture, wp)
	Les thèses ne sont pas ici car il y a déjà les articles des thèses
*/
********** Selection
fre type
drop if type>=5

********** 
preserve
keep Title $data
rename ($data) (data#), addnumber(1)
gen id=_n
reshape long data, i(id) j(which)
lab define which 1 "RUME" 2 "NEEMSIS-1" 3 "NEEMSIS-2"
lab values which which
replace data=data*100
*
graph bar data, over(which) ///
ylabel(0(10)80) ytitle("Percentage",) ///
title("Data used") ///
scale(1.5) ///
name(dataused, replace)
restore
graph export "figures/data.png", as(png) replace

****************************************
* END











****************************************
* Graph #4: Panel
****************************************
use"Papers_v1", clear

/*
Comment les données sont utilisées ?
Echantillon :
	toutes les productions originales (articles, chapitres, livres) qql soit le statut (publiés, en cours d'écriture, wp)
	Les thèses ne sont pas ici car il y a déjà les articles des thèses
*/
********** Selection
fre type
drop if type>=5

********** 
catplot, over(panel) percent vertical ///
ylabel(0(10)80) ///
ytitle("Percentage") ///
title("Type") ///
scale(1.5) ///
name(panel, replace)
graph export "figures/panel.png", as(png) replace


****************************************
* END










****************************************
* Graph #5: Topics
****************************************
use"Papers_v1", clear

/*
Quels thèmes sont étudiés ?
Echantillon :
	toutes les productions originales (articles, chapitres, livres) qql soit le statut (publiés, en cours d'écriture, wp)
	Les thèses ne sont pas ici car il y a déjà les articles des thèses
*/
********** Selection
fre type
drop if type>=5


********** Topics
preserve
keep Title $topics
gen id=_n
rename ($topics) topic=
reshape long topic, i(id) j(which) string
replace topic=topic*100
bys which: egen x=sum(topic)
drop if x==0
drop x
myaxis order=which, sort(sum topic) descending
*
graph bar topic, over(order, lab(angle(90)))  ///
ylabel(0(10)70) ytitle("Percentage") ///
title("Topics")  ///
scale(1.5) ///
name(topics, replace)
restore
graph export "figures/topics.png", as(png) replace

****************************************
* END











****************************************
* Graph #6: Access
****************************************
use"Papers_v1", clear

/*
Quels sont les accès aux données ?
Echantillon :
	toutes les productions originales (articles, chapitres, livres) terminées (publiés ou wp)
	Les thèses ne sont pas ici car il y a déjà les articles des thèses
*/
********** Selection
fre type
drop if type>=5
fre status
drop if status==1


********** Access
catplot, over(access) percent vertical ///
ylabel(0(10)80) ///
ytitle("Percentage") ///
title("Access") ///
scale(1.5) ///
name(panel, replace)
graph export "figures/access.png", as(png) replace

****************************************
* END










****************************************
* Graph #7: Topics per wave for research papers
****************************************
use"Papers_v1", clear

/*
Quels thèmes sont étudiés (par vague) ?
Echantillon :
	toutes les productions originales (articles, chapitres, livres) qql soit le statut (publiés, en cours d'écriture, wp)
	Les thèses ne sont pas ici car il y a déjà les articles des thèses
*/
********** Selection
fre type
drop if type>=5


********** RUME
preserve
keep if R==1
count
local n=`r(N)'
keep Title $topics
gen id=_n
rename ($topics) topic=
reshape long topic, i(id) j(which) string
replace topic=topic*100
bys which: egen x=sum(topic)
drop if x==0
drop x
myaxis order=which, sort(sum topic) descending
*
graph bar topic, over(order, lab(angle(90) labsize(small)))  ///
ylabel(0(20)80,labsize(small)) ytitle("Percentage",size(small)) ///
title("RUME (N=`n')", size(medsmall))  ///
name(rume, replace)
restore

********** NEEMSIS
forvalues i=1/2 {
preserve
keep if N`i'==1
count
local n=`r(N)'
keep Title $topics
gen id=_n
rename ($topics) topic=
reshape long topic, i(id) j(which) string
replace topic=topic*100
bys which: egen x=sum(topic)
drop if x==0
drop x
myaxis order=which, sort(sum topic) descending
*
graph bar topic, over(order, lab(angle(90) labsize(small)))  ///
ylabel(0(20)80,labsize(small)) ytitle("Percentage",size(small)) ///
title("NEEMSIS-`i' (N=`n')", size(medsmall))  ///
name(neemsis`i', replace)
restore
}

********** Combine
graph combine rume neemsis1 neemsis2, col(3) title("Topics by wave for research papers", size(medium)) note("{it:Source:} $authordate", size(vsmall)) name(topics, replace)
graph export "figures/topicswave.png", as(png) replace

****************************************
* END















****************************************
* Graph #8: Debt and ...
****************************************
use"Papers_v1", clear

/*
Quels sont les autres thèmes liés à la dette ?
Echantillon :
	toutes les productions originales (articles, chapitres, livres) qql soit le statut (publiés, en cours d'écriture, wp)
	les articles qui traitent de la dette
	Les thèses ne sont pas ici car il y a déjà les articles des thèses
*/
********** Selection
fre type
drop if type>=5
keep if Debt==1

********** 
preserve
keep Title $topics
gen id=_n
rename ($topics) topic=
drop topicDebt
reshape long topic, i(id) j(which) string
replace topic=topic*100
bys which: egen x=sum(topic)
drop if x==0
drop x
myaxis order=which, sort(sum topic) descending
*
graph bar topic, over(order, lab(angle(90)))  ///
ylabel(0(10)50) ytitle("Percentage") ///
title("Topics")  ///
scale(1.5) ///
name(topics, replace)
restore
graph export "figures/topics_debt.png", as(png) replace

****************************************
* END
