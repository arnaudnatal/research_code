*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "measuringdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\measuringdebt.do"
*-------------------------








****************************************
* Finindex no. 4
****************************************
use"panel_v5", clear

********** Replace
*** Income
gen dailyincome_pc=(annualincome_HH/365)/squareroot_HHsize
gen dailyusdincome_pc=dailyincome_pc/45.73
gen dailyplincome_pc=dailyusdincome_pc-1.9


replace dailyusdincome_pc_perc2=100 if dailyusdincome_pc_perc2>100
replace dailyusdincome_pc_perc2=-100 if dailyusdincome_pc_perc2<-100
corr annualincome_HH dailyusdincome_pc_perc2
*the more is the poorer
replace dailyusdincome_pc_perc2=0 if dailyusdincome_pc_perc2<0

replace dailyincome_pc=600 if dailyincome_pc>600


gen dailyusdincome_pc_perc=((dailyusdincome_pc-1.9)/1.9)*(-1)*100
ta dailyusdincome_pc_perc
gen dailyusdincome_pc_perc2=dailyusdincome_pc_perc





*** ISR
gen isr=imp1_is_tot_HH*100/annualincome_HH
replace isr=0 if isr==.
replace isr=190 if isr>190
replace isr=100 if isr>100


*** TDR
gen tdr=totHH_givenamt_repa*100/loanamount_HH
replace tdr=0 if tdr==.



*** FVI
gen fvi=(2*tdr+2*isr+dailyusdincome_pc_perc2)/5



save"panel_v6", replace
****************************************
* END






















****************************************
* Labour var: 2010
****************************************
use"raw/RUME-occupnew", clear

fre kindofwork
drop if kindofwork==9

keep HHID2010 INDID2010 profession sector occupation nboccupation_indiv annualincome
fre occupation

*** Merge charact
merge m:1 HHID2010 INDID2010 using "raw/RUME-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge HHID_panel
merge m:m HHID2010 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2010


save"RUME-newoccvar", replace
****************************************
* END










****************************************
* Labour var: 2016-17
****************************************
use"raw/NEEMSIS1-occupnew", clear

fre kindofwork

keep HHID2016 INDID2016 profession sector occupation nboccupation_indiv annualincome hoursayear
fre occupation

*** Merge charact
merge m:1 HHID2016 INDID2016 using "raw/NEEMSIS1-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge HHID_panel
merge m:m HHID2016 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2016


save"NEEMSIS1-newoccvar", replace
****************************************
* END








****************************************
* Labour var: 2020-21
****************************************
use"raw/NEEMSIS2-occupnew", clear

fre kindofwork

keep HHID2020 INDID2020 profession sector occupation nboccupation_indiv annualincome hoursayear
fre occupation

*** Merge charact
merge m:1 HHID2020 INDID2020 using "raw/NEEMSIS2-HH", keepusing(name age sex)
keep if _merge==3
drop _merge

gen dep=0
replace dep=1 if age<15
replace dep=1 if age>64


*** Merge HHID_panel
merge m:m HHID2020 using "raw/ODRIIS-HH_wide", keepusing(HHID_panel)
keep if _merge==3
drop _merge
gen year=2020


save"NEEMSIS2-newoccvar", replace
****************************************
* END













****************************************
* Append all
****************************************
use"RUME-newoccvar", clear

append using "NEEMSIS1-newoccvar"
append using "NEEMSIS2-newoccvar"

order HHID_panel year INDID2010 INDID2016 INDID2020
sort HHID_panel year

tostring INDID2016, replace
tostring INDID2020, replace

gen INDID=""
replace INDID=INDID2010 if year==2010
replace INDID=INDID2016 if year==2016
replace INDID=INDID2020 if year==2020
drop INDID2010 INDID2016 INDID2020

order HHID_panel INDID year

* Merge INDID_panel
tostring year, replace
merge m:1 HHID_panel INDID year using "raw/ODRIIS-indiv_long", keepusing(INDID_panel)
keep if _merge==3
drop _merge
destring year, replace
order HHID_panel INDID_panel INDID year name sex age dep
sort HHID_panel INDID_panel year
drop INDID


save"panel-newoccvar", replace
****************************************
* END











****************************************
* Var
****************************************
use"panel-newoccvar", clear


********** Occupations
* Precise
fre occupation

* Agri vs non-agri
gen occupation2=0
replace occupation2=1 if occupation==1
replace occupation2=1 if occupation==2
replace occupation2=2 if occupation==3
replace occupation2=2 if occupation==4
replace occupation2=2 if occupation==5
replace occupation2=2 if occupation==6
replace occupation2=2 if occupation==7
label define occupation2 1"Agri" 2"Non-agri"
label values occupation2 occupation2
ta occupation occupation2

* Casual vs regular
gen occupation3=0
replace occupation3=1 if occupation==1
replace occupation3=2 if occupation==2
replace occupation3=2 if occupation==3
replace occupation3=1 if occupation==4
replace occupation3=1 if occupation==5
replace occupation3=1 if occupation==6
replace occupation3=2 if occupation==7
label define occupation3 1"Regular" 2"Casual"
label values occupation3 occupation3
ta occupation occupation3

* Casual vs regular
gen occupation4=0
replace occupation4=1 if occupation==1
replace occupation4=2 if occupation==2
replace occupation4=2 if occupation==3
replace occupation4=2 if occupation==4
replace occupation4=2 if occupation==5
replace occupation4=1 if occupation==6
replace occupation4=2 if occupation==7
label define occupation4 1"Self-employed" 2"Other"
label values occupation4 occupation4
ta occupation occupation4


********** Dummies
ta occupation, gen(occ1_)
rename occ1_1 occ_agriself
rename occ1_2 occ_agricasual
rename occ1_3 occ_casual
rename occ1_4 occ_regnonquali
rename occ1_5 occ_regquali
rename occ1_6 occ_selfemp
rename occ1_7 occ_nrega

ta occupation2, gen(occ2_)
rename occ2_1 occ_agri
rename occ2_2 occ_nona

ta occupation3, gen(occ3_)
rename occ3_1 occ_regu
rename occ3_2 occ_casu

ta occupation4, gen(occ4_)
rename occ4_1 occ_self
rename occ4_2 occ_othe


********** Macro
global total occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe



********** Hours a year by occupation, at indiv level
foreach x in $total {
local name=substr("`x'",5,32)
gen hoursayear_`name'=0
}

replace hoursayear_agriself=hoursayear if occupation==1
replace hoursayear_agricasual=hoursayear if occupation==2
replace hoursayear_casual=hoursayear if occupation==3
replace hoursayear_regnonquali=hoursayear if occupation==4
replace hoursayear_regquali=hoursayear if occupation==5
replace hoursayear_selfemp=hoursayear if occupation==6
replace hoursayear_nrega=hoursayear if occupation==7

replace hoursayear_agri=hoursayear if occupation2==1
replace hoursayear_nona=hoursayear if occupation2==2

replace hoursayear_regu=hoursayear if occupation3==1
replace hoursayear_casu=hoursayear if occupation3==2

replace hoursayear_self=hoursayear if occupation4==1
replace hoursayear_othe=hoursayear if occupation4==2

global hay hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear

foreach x in $hay {
recode `x' (.=0)
}

foreach x in $hay {
bysort HHID_panel INDID_panel year: egen indiv_`x'=sum(`x')
drop `x'
rename indiv_`x' `x'
}





********** Annual income by occupation, at indiv level
foreach x in $total {
local name=substr("`x'",5,32)
gen annualincome_`name'=0
}

replace annualincome_agriself=annualincome if occupation==1
replace annualincome_agricasual=annualincome if occupation==2
replace annualincome_casual=annualincome if occupation==3
replace annualincome_regnonquali=annualincome if occupation==4
replace annualincome_regquali=annualincome if occupation==5
replace annualincome_selfemp=annualincome if occupation==6
replace annualincome_nrega=annualincome if occupation==7

replace annualincome_agri=annualincome if occupation2==1
replace annualincome_nona=annualincome if occupation2==2

replace annualincome_regu=annualincome if occupation3==1
replace annualincome_casu=annualincome if occupation3==2

replace annualincome_self=annualincome if occupation4==1
replace annualincome_othe=annualincome if occupation4==2

global ai annualincome_agriself annualincome_agricasual annualincome_casual annualincome_regnonquali annualincome_regquali annualincome_selfemp annualincome_nrega annualincome_agri annualincome_nona annualincome_regu annualincome_casu annualincome_self annualincome_othe annualincome

foreach x in $ai {
recode `x' (.=0)
}

foreach x in $ai {
bysort HHID_panel INDID_panel year: egen indiv_`x'=sum(`x')
drop `x'
rename indiv_`x' `x'
}








********** Occupation no at individual level
foreach x in $total {
bysort HHID_panel INDID_panel year: egen indiv_`x'=sum(`x')
drop `x'
rename indiv_`x' `x'
}



********** Indiv level
keep HHID_panel HHID2010 HHID2016 HHID2020 INDID_panel year name sex age dep $total $hay $ai
duplicates drop
duplicates report HHID_panel INDID_panel year


********** Dummies by sex
foreach x in $total {
gen `x'_male=0
gen `x'_female=0
}

foreach x in $total {
replace `x'_male=`x' if sex==1
replace `x'_female=`x' if sex==2
}


********** Dummies by dep
foreach x in $total {
gen `x'_dep=0
}

foreach x in $total {
replace `x'_dep=`x' if dep==1
}


********* Dummies total
gen occ_total=0
replace occ_total=occ_agri+occ_nona

gen occ_female=0
replace occ_female=occ_agri+occ_nona if sex==2

gen occ_male=0
replace occ_male=occ_agri+occ_nona if sex==1

gen occ_dep=0
replace occ_dep=occ_agri+occ_nona if dep==1






********** Hours by sex
gen hoursayear_male=0
replace hoursayear_male=hoursayear if sex==1
gen hoursayear_female=0
replace hoursayear_female=hoursayear if sex==2
gen hoursayear_dep=0
replace hoursayear_dep=hoursayear if dep==1

foreach x in agri nona regu casu self othe {
gen hoursayear_`x'_male=0
gen hoursayear_`x'_female=0
}

foreach x in agri nona regu casu self othe {
replace hoursayear_`x'_male=hoursayear_`x' if sex==1
replace hoursayear_`x'_female=hoursayear_`x' if sex==2
}



********** Income by sex
gen annualincome_male=0
replace annualincome_male=annualincome if sex==1
gen annualincome_female=0
replace annualincome_female=annualincome if sex==2
gen annualincome_dep=0
replace annualincome_dep=annualincome if dep==1

foreach x in agri nona regu casu self othe {
gen annualincome_`x'_male=0
gen annualincome_`x'_female=0
}

foreach x in agri nona regu casu self othe {
replace annualincome_`x'_male=annualincome_`x' if sex==1
replace annualincome_`x'_female=annualincome_`x' if sex==2
}






********** Order
order HHID_panel INDID_panel year name sex age dep occ_total occ_female occ_male occ_dep


********** Indiv level var
global totalocc occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agriself_male occ_agriself_female occ_agricasual_male occ_agricasual_female occ_casual_male occ_casual_female occ_regnonquali_male occ_regnonquali_female occ_regquali_male occ_regquali_female occ_selfemp_male occ_selfemp_female occ_nrega_male occ_nrega_female occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agriself_dep occ_agricasual_dep occ_casual_dep occ_regnonquali_dep occ_regquali_dep occ_selfemp_dep occ_nrega_dep occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep

foreach x in $totalocc {
gen `x'_indiv=0
}


foreach x in $totalocc {
replace `x'_indiv=1 if `x'!=0
}

foreach x in $totalocc {
local new=substr("`x'",5,32)
rename `x'_indiv ind_`new'
}


********** Household level for all
global fulltotal occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agriself_male occ_agriself_female occ_agricasual_male occ_agricasual_female occ_casual_male occ_casual_female occ_regnonquali_male occ_regnonquali_female occ_regquali_male occ_regquali_female occ_selfemp_male occ_selfemp_female occ_nrega_male occ_nrega_female occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agriself_dep occ_agricasual_dep occ_casual_dep occ_regnonquali_dep occ_regquali_dep occ_selfemp_dep occ_nrega_dep occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agriself_male ind_agriself_female ind_agricasual_male ind_agricasual_female ind_casual_male ind_casual_female ind_regnonquali_male ind_regnonquali_female ind_regquali_male ind_regquali_female ind_selfemp_male ind_selfemp_female ind_nrega_male ind_nrega_female ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agriself_dep ind_agricasual_dep ind_casual_dep ind_regnonquali_dep ind_regquali_dep ind_selfemp_dep ind_nrega_dep ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female annualincome_agriself annualincome_agricasual annualincome_casual annualincome_regnonquali annualincome_regquali annualincome_selfemp annualincome_nrega annualincome_agri annualincome_nona annualincome_regu annualincome_casu annualincome_self annualincome_othe annualincome annualincome_male annualincome_female annualincome_dep annualincome_agri_male annualincome_agri_female annualincome_nona_male annualincome_nona_female annualincome_regu_male annualincome_regu_female annualincome_casu_male annualincome_casu_female annualincome_self_male annualincome_self_female annualincome_othe_male annualincome_othe_female

foreach x in $fulltotal {
bysort HHID_panel year: egen _`x'=sum(`x')
drop `x'
rename _`x' `x'
}

keep HHID_panel HHID2010 HHID2016 HHID2020 year $fulltotal
duplicates drop
duplicates report HHID_panel year
ta year


********** Save
save"panel-newoccvar", replace

****************************************
* END









****************************************
* Merge with main dataset
****************************************
use"panel_v8", clear

merge 1:1 HHID_panel year using "panel-newoccvar"
drop _merge


********** Share
global fulltotal occ_total occ_female occ_male occ_dep occ_agriself occ_agricasual occ_casual occ_regnonquali occ_regquali occ_selfemp occ_nrega occ_agri occ_nona occ_regu occ_casu occ_self occ_othe occ_agriself_male occ_agriself_female occ_agricasual_male occ_agricasual_female occ_casual_male occ_casual_female occ_regnonquali_male occ_regnonquali_female occ_regquali_male occ_regquali_female occ_selfemp_male occ_selfemp_female occ_nrega_male occ_nrega_female occ_agri_male occ_agri_female occ_nona_male occ_nona_female occ_regu_male occ_regu_female occ_casu_male occ_casu_female occ_self_male occ_self_female occ_othe_male occ_othe_female occ_agriself_dep occ_agricasual_dep occ_casual_dep occ_regnonquali_dep occ_regquali_dep occ_selfemp_dep occ_nrega_dep occ_agri_dep occ_nona_dep occ_regu_dep occ_casu_dep occ_self_dep occ_othe_dep ind_total ind_female ind_male ind_dep ind_agriself ind_agricasual ind_casual ind_regnonquali ind_regquali ind_selfemp ind_nrega ind_agri ind_nona ind_regu ind_casu ind_self ind_othe ind_agriself_male ind_agriself_female ind_agricasual_male ind_agricasual_female ind_casual_male ind_casual_female ind_regnonquali_male ind_regnonquali_female ind_regquali_male ind_regquali_female ind_selfemp_male ind_selfemp_female ind_nrega_male ind_nrega_female ind_agri_male ind_agri_female ind_nona_male ind_nona_female ind_regu_male ind_regu_female ind_casu_male ind_casu_female ind_self_male ind_self_female ind_othe_male ind_othe_female ind_agriself_dep ind_agricasual_dep ind_casual_dep ind_regnonquali_dep ind_regquali_dep ind_selfemp_dep ind_nrega_dep ind_agri_dep ind_nona_dep ind_regu_dep ind_casu_dep ind_self_dep ind_othe_dep hoursayear_agriself hoursayear_agricasual hoursayear_casual hoursayear_regnonquali hoursayear_regquali hoursayear_selfemp hoursayear_nrega hoursayear_agri hoursayear_nona hoursayear_regu hoursayear_casu hoursayear_self hoursayear_othe hoursayear hoursayear_male hoursayear_female hoursayear_dep hoursayear_agri_male hoursayear_agri_female hoursayear_nona_male hoursayear_nona_female hoursayear_regu_male hoursayear_regu_female hoursayear_casu_male hoursayear_casu_female hoursayear_self_male hoursayear_self_female hoursayear_othe_male hoursayear_othe_female annualincome_agriself annualincome_agricasual annualincome_casual annualincome_regnonquali annualincome_regquali annualincome_selfemp annualincome_nrega annualincome_agri annualincome_nona annualincome_regu annualincome_casu annualincome_self annualincome_othe annualincome annualincome_male annualincome_female annualincome_dep annualincome_agri_male annualincome_agri_female annualincome_nona_male annualincome_nona_female annualincome_regu_male annualincome_regu_female annualincome_casu_male annualincome_casu_female annualincome_self_male annualincome_self_female annualincome_othe_male annualincome_othe_female

foreach x in $fulltotal {
replace `x'=0 if `x'==.
}


foreach x in total female male dep agriself agricasual casual regnonquali regquali selfemp nrega agri nona regu casu self othe agriself_male agriself_female agricasual_male agricasual_female casual_male casual_female regnonquali_male regnonquali_female regquali_male regquali_female selfemp_male selfemp_female nrega_male nrega_female agri_male agri_female nona_male nona_female regu_male regu_female casu_male casu_female self_male self_female othe_male othe_female agriself_dep agricasual_dep casual_dep regnonquali_dep regquali_dep selfemp_dep nrega_dep agri_dep nona_dep regu_dep casu_dep self_dep othe_dep {
gen share_`x'=ind_`x'/HHsize
replace share_`x'=1 if share_`x'>1
}

drop hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH



********** Last minute var crea
gen head_educ=head_edulevel
recode head_educ (2=1)

foreach x in remittnet_HH assets_total {
drop `x'
rename `x'_std `x'
}

ta villageid, gen(village_)


*** Fafchamps and Quisumbing, 1998
gen log_HHsize=log(HHsize)
gen share_children=HH_count_child/HHsize

*** trends
/*
label define trendn 0"Sta-Dec" 1"Increasing"
clonevar trendn1=trend1
recode trendn1 (1=0) (2=0) (3=1)
label values trendn1 trendn
clonevar trendn2=trend2
recode trendn2 (1=0) (2=0) (3=1)
label values trendn2 trendn
gen trendlong=.
replace trendlong=trendn1 if year==2016
replace trendlong=trendn2 if year==2020
label values trendlong trendn
*/

save"panel_v9", replace
****************************************
* END


















/*
stripplot `x', over(clust) vert ///
stack width(0.2) jitter(1) ///
box(barw(0.2)) boffset(-0.2) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks) name(sp`x', replace)


program drop _all
program define stripgraph
stripplot `1' if `1'<`4', over(`2') by(`3', title("`1'")) vert ///
stack width(1) jitter(0) ///
box(barw(1)) boffset(-0.3) pctile(10) ///
ms(oh oh oh) msize(small) mc(blue%30) ///
yla(, ang(h)) xla(, noticks)
end
****************************************
* END
*/
