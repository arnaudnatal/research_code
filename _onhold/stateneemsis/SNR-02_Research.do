*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 22, 2025
*-----
*Figures for all outputs
*
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid
*
cd"C:\Users\Arnaud\Documents\GitHub\research_code\stateneemsis"
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
* Published or finished outputs
****************************************
use"Papers_v1", clear


********** Selection
/*
Garder qui ce qui est publié ou terminé
*/
drop if status==1
drop if status==2


fre type




****************************************
* END











****************************************
* Published or finished papers
****************************************
use"Papers_v1", clear

********** Selection
/*
Garder qui ce qui est publié ou terminé
Enlever les thèses, les PB et les BP
*/
drop if status==1
drop if status==2
drop if type>4


********** Type
ta type
catplot, over(type) percent vertical ///
ylabel(0(10)80) ///
ytitle("Percentage") ///
title("Type") ///
scale(1.5) ///
name(type, replace)
graph export "figures/type.png", as(png) replace



********** Panel
ta panel
* Pas la peine d'en faire un graphique, une phrase suffira


********** Data used
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



********** Nb
twoway ///
(histogram Year, width(0.5) freq discrete) ///
, ylabel(1(1)4) xlabel(2012(1)2026, angle(90)) ///
ytitle("Number") xtitle("") title("Papers over the years") ///
scale(1.5) name(nb, replace)
graph export "figures/nb.png", as(png) replace




********** Availability
ta availability
* Une phrase car seulement une binaire



****************************************
* END










****************************************
* Topics per wave for research papers
****************************************
use"Stata_cmd\Papers_v1", clear

*
fre type
drop if type>4

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
graph combine rume neemsis1 neemsis2, col(3) title("Topics by wave for research papers", size(medium)) note("{it:Source:} $authordate", size(vsmall)) name(authors, replace)
graph export "Stata_cmd\Stata_fig\RP_topicswave.svg", as(svg) replace

****************************************
* END













