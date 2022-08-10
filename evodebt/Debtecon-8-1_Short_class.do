*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*June 17, 2022
*-----
gl link = "evodebt"
*Short class
*-----
do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
*-------------------------
















****************************************
* Dyanmic between 2010-2016 and 2016-2020
****************************************
cls
use"panel_v12_wide", clear


********** Calcul diff and delta
foreach x in assets DAR DSR income {
gen de1_`x'=(`x'2016-`x'2010)*100/`x'2010
gen de2_`x'=(`x'2020-`x'2016)*100/`x'2016

replace de1_`x'=`x'2016 if `x'2010==0
replace de2_`x'=`x'2020 if `x'2016==0

gen di1_`x'=`x'2016-`x'2010
gen di2_`x'=`x'2020-`x'2016
}


********** Cat evolution
foreach x in assets DAR DSR income {

egen cat_`x'_b1=cut(de1_`x'), at(-999999 -10 10 9999999)
egen cat_`x'_b2=cut(de2_`x'), at(-999999 -10 10 9999999)

recode cat_`x'_b1 (-999999=-1) (-10=0) (10=1)
recode cat_`x'_b2 (-999999=-1) (-10=0) (10=1)

label define cut2 -1"Dec" 0"Sta" 1"Inc", replace
label values cat_`x'_b1 cut2
label values cat_`x'_b2 cut2
}

********** All diff var
***** Quanti: first diff
foreach x in income assets rel_repay rel_formal rel_informal rel_eco rel_current rel_humank rel_social rel_home repay formal informal eco current humank social home {
gen `x'_var1=`x'2016-`x'2010
gen `x'_var2=`x'2020-`x'2016

gen dummy_`x'_var1=0
replace dummy_`x'_var1=1 if `x'_var1>0
gen dummy_`x'_var2=0
replace dummy_`x'_var2=1 if `x'_var2>0

gen dummy_`x'_varbis1=0
gen dummy_`x'_varbis2=0
replace dummy_`x'_varbis2=1 if `x'_var1>0
gen dummy_`x'_varbis3=0
replace dummy_`x'_varbis3=1 if `x'_var2>0


drop `x'_var1 `x'_var2
}

***** Quali: change
***
fre mainocc_occupation2016
foreach x in 2010 2016 2020 {
clonevar occupation`x'=mainocc_occupation`x'
recode occupation`x' (2=1) (3=2) (4=2) (6=2) (7=2)
label define occup 1"Agri." 2"Non-agri.", replace
label values occupation`x' occup 
}
***
foreach x in mainocc_occupation housetype housetitle ownland occupation {
ta `x'2010 `x'2016
ta `x'2016 `x'2020
egen `x'_var1=group(`x'2010 `x'2016), label
egen `x'_var2=group(`x'2016 `x'2020), label

egen `x'_varbis2=group(`x'2010 `x'2016), label
egen `x'_varbis3=group(`x'2016 `x'2020), label
}

save "panel_v13_wide", replace

fre occupation_var1
codebook occupation_var1


********** R
preserve
keep HHID_panel cat_assets_b* cat_DAR_b* cat_DSR_b* cat_income_b* DAR* DSR* income* assets* 

drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020 DAR_with2010 DAR_with2016 DAR_with2020
drop assets_BU2010 income_BU2010 DSR_BU2010 DAR_BU2010 assets_BU2016 income_BU2016 DSR_BU2016 DAR_BU2016 assets_BU2020 income_BU2020 DSR_BU2020 DAR_BU2020

reshape long cat_assets_b cat_DAR_b cat_DSR_b cat_income_b, i(HHID_panel) j(tempo)

drop if cat_assets_b==.

export delimited using "$git\research_code\evodebt\shortdebttrend_v1.csv", replace
restore



********** Reintroduce in dataset
cls
import delimited using "$git\research_code\evodebt\shortdebttrend_v2.csv", clear
rename hhid_panel HHID_panel
rename cat_dar_b cat_DAR_b
rename cat_dsr_b cat_DSR_b
rename clust sdclust

*** Charact
foreach x in DAR DSR assets income {
ta sdclust cat_`x'_b, row nofreq
}

*** Vuln
gen sdvuln=.
replace sdvuln=0 if sdclust==1
replace sdvuln=0 if sdclust==2
replace sdvuln=0 if sdclust==3
replace sdvuln=1 if sdclust==4

ta sdvuln

foreach x in DAR DSR assets income {
ta sdvuln cat_`x'_b, row nofreq
}

*** Introduce
keep HHID_panel tempo sdclust sdvuln
reshape wide sdclust sdvuln, i(HHID_panel) j(tempo)
merge 1:1 HHID_panel using "panel_v13_wide"
drop _merge

ta sdvuln1 sdclust1, col row
ta sdvuln2 sdclust2, col row


***** Check
cls
ta sdclust1 sdvuln1
ta sdclust2 sdvuln2
ta sdvuln1 caste2016, cchi2 exp chi2
ta sdvuln2 caste2016, cchi2 exp chi2

save "panel_v13_wide", replace
****************************************
* END










****************************************
* Reshape long --> one line, one period of times
****************************************
cls
use"panel_v13_wide", clear

***** Clean
global var DAR	DAR_BU	DAR_with	DIR	DIR_BU	DSR	DSR30	DSR40	DSR50	DSR_BU	HHsize	IMF	ISR	ISR_BU	MLbaddebt	MLborrowstrat	MLgooddebt	MLstratasse	MLstratmigr	agri	assets	assets_BU	bank	caste	current	dummyIMF	dummyassestrat	dummybank	dummyborrowstrat	dummymigrstrat	dummymoneylender	dummyrepay	eco	expenses	femtomale	formal	head_age	head_edulevel	head_female	head_married	head_occupation	home	housetitle	housetype	humank	income	income_BU	informal	jatis	loanamount	loanamount_BU	mainloan_HH	mainocc_occupation	moneylender	nagri	nbchildren	nontoworkers	occupation	other	ownland	rel_IMF	rel_MLbaddebt	rel_MLborrowstrat	rel_MLgooddebt	rel_MLstratasse	rel_MLstratmigr	rel_bank	rel_current	rel_eco	rel_formal	rel_home	rel_humank	rel_informal	rel_moneylender	rel_other	rel_repay	rel_social	repay	shareagri	sharenagri	sizeownland	social	std_DAR	std_DSR	std_assets	std_income	sum_loans_HH	village_ur	villagearea	villageid	wifehusb_age	wifehusb_edulevel	wifehusb_female	wifehusb_married	wifehusb_occupation clust

foreach x in $var {
rename `x'2010 `x'1
rename `x'2016 `x'2
rename `x'2020 `x'3
}

global shockvar dummymarriage dummymarriagedaughter dummymarriageson dummylock covsick dummydemonetisation
foreach x in  $shockvar {
drop `x'2010
rename `x'2016 `x'1
rename `x'2020 `x'2
}



save "panel_v13_period_wide", replace


********** Reshape
global vardiff sdclust sdvuln cat_assets_b cat_DAR_b cat_DSR_b cat_income_b dummy_income_var	dummy_assets_var	dummy_rel_repay_var	dummy_rel_formal_var	dummy_rel_informal_var	dummy_rel_eco_var	dummy_rel_current_var	dummy_rel_humank_var	dummy_rel_social_var	dummy_rel_home_var	dummy_repay_var	dummy_formal_var	dummy_informal_var	dummy_eco_var	dummy_current_var	dummy_humank_var	dummy_social_var	dummy_home_var	mainocc_occupation_var	housetype_var	housetitle_var	ownland_var	occupation_var ///
dummy_income_varbis dummy_assets_varbis dummy_rel_repay_varbis dummy_rel_formal_varbis dummy_rel_informal_varbis dummy_rel_eco_varbis dummy_rel_current_varbis dummy_rel_humank_varbis dummy_rel_social_varbis dummy_rel_home_varbis dummy_repay_varbis dummy_formal_varbis dummy_informal_varbis dummy_eco_varbis dummy_current_varbis dummy_humank_varbis dummy_social_varbis dummy_home_varbis mainocc_occupation_varbis housetype_varbis housetitle_varbis ownland_varbis occupation_varbis


reshape long $var $shockvar $vardiff, i(HHID_panel) j(potimes)
dropmiss, force
drop if clust==.
ta potimes

order HHID_panel panelvar potimes sdclust sdvuln cat_assets_b cat_DAR_b cat_DSR_b cat_income_b
sort HHID_panel

label values occupation_var occupation_var1
label values ownland_var ownland_var1


save "panel_v13_period_long", replace
****************************************
* END
