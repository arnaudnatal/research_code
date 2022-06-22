cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 17, 2021
-----
Short trends and static vuln
-----

-------------------------
*/





****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all

global user "Arnaud"
global folder "Documents"

********** Path to folder "data" folder.
global directory = "C:\Users\\$user\\$folder\_Thesis\Research-Overindebtedness\Persistence_over"
cd"$directory"
global git "C:\Users\\$user\\$folder\GitHub"


*Fac
*cd "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"

* Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid compact

*global git "C:\Users\anatal\Downloads\GitHub"
*global dropbox "C:\Users\anatal\Downloads\Dropbox"
*global thesis "C:\Users\anatal\Downloads\_Thesis\Research-Skills_and_debt\Analysis"


********** Name of the NEEMSIS2 questionnaire version to clean
global wave1 "RUME-HH"
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"

global loan1 "RUME-all_loans"
global loan2 "NEEMSIS1-all_loans"
global loan3 "NEEMSIS2-all_loans"


********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020

****************************************
* END






****************************************
* Dyanmic between 2010-2016 and 2016-2020
****************************************
cls
use"panel_v11_wide", clear



********** Calcul diff and delta
foreach x in assets DAR DSR income ISR expenses {
gen de1_`x'=(`x'2016-`x'2010)*100/`x'2010
gen de2_`x'=(`x'2020-`x'2016)*100/`x'2016

replace de1_`x'=`x'2016 if `x'2010==0
replace de2_`x'=`x'2020 if `x'2016==0

gen di1_`x'=`x'2016-`x'2010
gen di2_`x'=`x'2020-`x'2016

}


********** Cat evolution
foreach x in assets DAR DSR income ISR expenses {

egen cat_`x'_b1=cut(de1_`x'), at(-999999 -10 10 9999999)
egen cat_`x'_b2=cut(de2_`x'), at(-999999 -10 10 9999999)

recode cat_`x'_b1 (-999999=-1) (-10=0) (10=1)
recode cat_`x'_b2 (-999999=-1) (-10=0) (10=1)

label define cut2 -1"Dec" 0"Sta" 1"Inc", replace
label values cat_`x'_b1 cut2
label values cat_`x'_b2 cut2
}

order HHID_panel caste2010 caste2016 caste2020 cat_assets_b1 cat_assets_b2 cat_DAR_b1 cat_DAR_b2 cat_DSR_b1 cat_DSR_b2 cat_income_b1 cat_income_b2 cat_ISR_b1 cat_ISR_b2 cat_expenses_b1 cat_expenses_b2


********** R -1
preserve
drop if caste2010!=. & caste2016==. & caste2020==.
drop if caste2010==. & caste2016!=. & caste2020==.
drop if caste2010==. & caste2016==. & caste2020!=.

ta caste2010 caste2016
ta caste2016 caste2020

*keep if panel==1

keep HHID_panel cat_assets_b* cat_DAR_b* cat_DSR_b* cat_income_b* cat_ISR_b* cat_expenses_b* ihs_ISR* ihs_DAR* ihs_DSR* ihs_income* ihs_assets* ISR* DAR* DSR* income* assets* 
drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020 DAR_with2010 DAR_with2016 DAR_with2020

reshape long cat_assets_b cat_DAR_b cat_DSR_b cat_income_b cat_ISR_b cat_expenses_b, i(HHID_panel) j(tempo)
drop if cat_assets_b==.
export delimited using "$git\research_code\evodebt\debttrend_new_v1.csv", replace
restore

preserve
import delimited using "$git\research_code\evodebt\debttrend_new_v3.csv", clear
gen dubvuln=.
replace dubvuln=0 if clust==1
replace dubvuln=1 if clust==2
replace dubvuln=0 if clust==3
replace dubvuln=0 if clust==4
replace dubvuln=1 if clust==5
ta dubvuln tempo, col nofreq
rename clust ubclust
keep hhid_panel tempo ubclust dubvuln
reshape wide ubclust dubvuln, i(hhid_panel) j(tempo)
rename hhid_panel HHID_panel
save"_temp_clust.dta", replace
restore
merge 1:1 HHID_panel using "_temp_clust"
drop _merge




********** R -2
preserve
drop if caste2010!=. & caste2016==. & caste2020==.
drop if caste2010==. & caste2016!=. & caste2020==.
drop if caste2010==. & caste2016==. & caste2020!=.

ta caste2010 caste2016
ta caste2016 caste2020

keep if panel==1

keep HHID_panel cat_assets_b* cat_DAR_b* cat_DSR_b* cat_income_b* cat_ISR_b* cat_expenses_b* ihs_ISR* ihs_DAR* ihs_DSR* ihs_income* ihs_assets* ISR* DAR* DSR* income* assets* 
drop DSR302010 DSR402010 DSR502010 DSR302016 DSR402016 DSR502016 DSR302020 DSR402020 DSR502020 DAR_with2010 DAR_with2016 DAR_with2020

reshape long cat_assets_b cat_DAR_b cat_DSR_b cat_income_b cat_ISR_b cat_expenses_b, i(HHID_panel) j(tempo)
drop if cat_assets_b==.
export delimited using "$git\research_code\evodebt\debttrend_new_v2.csv", replace
restore

preserve
import delimited using "$git\research_code\evodebt\debttrend_new_v4.csv", clear
gen dbvuln=.
replace dbvuln=0 if clust==1
replace dbvuln=0 if clust==2
replace dbvuln=1 if clust==3
replace dbvuln=1 if clust==4
ta dbvuln tempo, col nofreq
rename clust bclust
keep hhid_panel tempo bclust dbvuln
reshape wide bclust dbvuln, i(hhid_panel) j(tempo)
rename hhid_panel HHID_panel
save"_temp_clust.dta", replace
restore
merge 1:1 HHID_panel using "_temp_clust"
drop _merge



********** All diff var
***** Quanti: first diff
foreach x in income assets nbchildren HHsize rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH repay_amt_HH formal_HH informal_HH eco_HH current_HH humank_HH social_HH home_HH {
gen `x'_v1=`x'2016-`x'2010
gen `x'_v2=`x'2020-`x'2016

gen dummy_`x'_v1=0
replace dummy_`x'_v1=1 if `x'_v1>0

gen dummy_`x'_v2=0
replace dummy_`x'_v2=1 if `x'_v2>0
}


cls
***** Quali: change

***
/*
Before: agri agri
*/
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
egen `x'_v1=group(`x'2010 `x'2016), label
egen `x'_v2=group(`x'2016 `x'2020), label
}



********** Small cross
cls
tabstat assets2010 assets2016 DAR2010 DAR2016 income2010 income2016 DSR2010 DSR2016, stat(mean med) by(dubvuln1)
tabstat assets2016 assets2020 DAR2016 DAR2020 income2016 income2020 DSR2016 DSR2020, stat(mean med) by(dubvuln2)

save "panel_v12_wide", replace
****************************************
* END









****************************************
* Reshape long --> one line, one year
****************************************
cls
use"panel_v12_wide", clear

ta dubvuln1 dubvuln2
ta dubvuln1
ta dubvuln2


********** Var creation
foreach x in assets income DSR DAR {
foreach y in 2010 2016 2020 {
xtile `x'_q`y'=`x'`y', n(3)
}
}


***** Clean
foreach x in income DSR loanamount DIR villageid sizeownland mainocc_occupation head_female head_married head_age head_edulevel head_occupation wifehusb_female wifehusb_married wifehusb_age wifehusb_edulevel wifehusb_occupation expenses assets villagearea agri nagri shareagri sharenagri repay_amt_HH rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH informal_HH formal_HH eco_HH current_HH humank_HH social_HH home_HH other_HH lf_IMF_nb_HH lf_IMF_amt_HH lf_bank_nb_HH lf_bank_amt_HH lf_moneylender_nb_HH lf_moneylender_amt_HH repay_nb_HH MLborrowstrat_nb_HH MLborrowstrat_amt_HH MLgooddebt_nb_HH MLgooddebt_amt_HH MLbaddebt_nb_HH MLbaddebt_amt_HH MLstrat_asse_nb_HH MLstrat_asse_amt_HH MLstrat_migr_nb_HH MLstrat_migr_amt_HH mainloan_HH mainloan_amt_HH rel_lf_IMF_amt_HH rel_lf_bank_amt_HH rel_lf_moneylender_amt_HH rel_mainloan_amt_HH rel_MLborrowstrat_amt_HH rel_MLbaddebt_amt_HH rel_MLgooddebt_amt_HH rel_MLstrat_asse_amt_HH rel_MLstrat_migr_amt_HH dummyIMF dummybank dummymoneylender dummyrepay dummyborrowstrat dummymigrstrat dummyassestrat sum_loans_HH DAR DAR_with ISR DSR30 DSR40 DSR50 ihs_ISR ihs_DAR ihs_DSR ihs_DIR ihs_DIR10 ihs_DIR100 ihs_DIR1000 ihs_DIR10000 ihs_loanamount ihs_income ihs_assets ihs_yearly_expenses ihs_informal_HH ihs_rel_informal_HH ihs_formal_HH ihs_rel_formal_HH ihs_eco_HH ihs_rel_eco_HH ihs_current_HH ihs_rel_current_HH ihs_humank_HH ihs_rel_humank_HH ihs_social_HH ihs_rel_social_HH ihs_home_HH ihs_rel_home_HH ihs_repay_amt_HH ihs_rel_repay_amt_HH ownland dummymarriage housetype housetitle HHsize nbchildren nontoworkers femtomale village_ur occupation assets_q income_q DSR_q DAR_q  {
rename `x'2010 `x'1
rename `x'2016 `x'2
drop `x'2020
}

drop if caste2010!=. & caste2016==. & caste2020==.
drop if caste2010==. & caste2016!=. & caste2020==.
drop if caste2010==. & caste2016==. & caste2020!=.


********** Reshape
reshape long ubclust bclust dbvuln dubvuln income_v assets_v nbchildren_v HHsize_v rel_repay_amt_HH_v rel_formal_HH_v rel_informal_HH_v rel_eco_HH_v rel_current_HH_v rel_humank_HH_v rel_social_HH_v rel_home_HH_v repay_amt_HH_v formal_HH_v informal_HH_v eco_HH_v current_HH_v humank_HH_v social_HH_v home_HH_v mainocc_occupation_v housetype_v housetitle_v ownland_v occupation_v income DSR loanamount DIR villageid sizeownland mainocc_occupation head_female head_married head_age head_edulevel head_occupation wifehusb_female wifehusb_married wifehusb_age wifehusb_edulevel wifehusb_occupation expenses assets villagearea agri nagri shareagri sharenagri repay_amt_HH rel_repay_amt_HH rel_formal_HH rel_informal_HH rel_eco_HH rel_current_HH rel_humank_HH rel_social_HH rel_home_HH rel_other_HH informal_HH formal_HH eco_HH current_HH humank_HH social_HH home_HH other_HH lf_IMF_nb_HH lf_IMF_amt_HH lf_bank_nb_HH lf_bank_amt_HH lf_moneylender_nb_HH lf_moneylender_amt_HH repay_nb_HH MLborrowstrat_nb_HH MLborrowstrat_amt_HH MLgooddebt_nb_HH MLgooddebt_amt_HH MLbaddebt_nb_HH MLbaddebt_amt_HH MLstrat_asse_nb_HH MLstrat_asse_amt_HH MLstrat_migr_nb_HH MLstrat_migr_amt_HH mainloan_HH mainloan_amt_HH rel_lf_IMF_amt_HH rel_lf_bank_amt_HH rel_lf_moneylender_amt_HH rel_mainloan_amt_HH rel_MLborrowstrat_amt_HH rel_MLbaddebt_amt_HH rel_MLgooddebt_amt_HH rel_MLstrat_asse_amt_HH rel_MLstrat_migr_amt_HH dummyIMF dummybank dummymoneylender dummyrepay dummyborrowstrat dummymigrstrat dummyassestrat sum_loans_HH DAR DAR_with ISR DSR30 DSR40 DSR50 ihs_ISR ihs_DAR ihs_DSR ihs_DIR ihs_DIR10 ihs_DIR100 ihs_DIR1000 ihs_DIR10000 ihs_loanamount ihs_income ihs_assets ihs_yearly_expenses ihs_informal_HH ihs_rel_informal_HH ihs_formal_HH ihs_rel_formal_HH ihs_eco_HH ihs_rel_eco_HH ihs_current_HH ihs_rel_current_HH ihs_humank_HH ihs_rel_humank_HH ihs_social_HH ihs_rel_social_HH ihs_home_HH ihs_rel_home_HH ihs_repay_amt_HH ihs_rel_repay_amt_HH ownland dummymarriage housetype housetitle HHsize nbchildren nontoworkers femtomale village_ur static_vuln km static_ml_vuln occupation dummy_income_v dummy_assets_v dummy_nbchildren_v dummy_HHsize_v dummy_rel_repay_amt_HH_v dummy_rel_formal_HH_v dummy_rel_eco_HH_v dummy_rel_current_HH_v dummy_rel_humank_HH_v dummy_rel_social_HH_v dummy_rel_home_HH_v assets_q income_q DSR_q DAR_q, i(HHID_panel) j(p)

drop dummy_rel_informal_HH_v1 dummy_rel_informal_HH_v2 dummy_rel_eco_HH_v dummy_rel_current_HH_v dummy_rel_humank_HH_v dummy_rel_social_HH_v dummy_rel_home_HH_v dummy_repay_amt_HH_v1 dummy_repay_amt_HH_v2 dummy_formal_HH_v1 dummy_formal_HH_v2 dummy_informal_HH_v1 dummy_informal_HH_v2 dummy_eco_HH_v1 dummy_eco_HH_v2 dummy_current_HH_v1 dummy_current_HH_v2 dummy_humank_HH_v1 dummy_humank_HH_v2 dummy_social_HH_v1 dummy_social_HH_v2 dummy_home_HH_v1 dummy_home_HH_v2



********** Stat desc
/*
program drop _all
program define stripgraph
stripplot `1' if `1'<`4', over(`2') by(`3') vert ///
stack width(10) jitter(5) ///
box(barw(0.1)) boffset(-0.1) pctile(10) ///
ms(oh oh oh) msize(small) mc(red%30) ///
yla(, ang(h)) xla(, noticks)
end

stripgraph assets p dubvuln 2000
*/


save "panel_v12_long", replace
****************************************
* END









****************************************
* Analysis in cross section: 2010 / 2016-17
****************************************
use "panel_v12_long", clear
keep if p==1
keep if caste2010!=. & caste2016!=.

global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid

global varv dummy_nbchildren_v dummy_HHsize_v dummy_rel_repay_amt_HH_v dummy_rel_formal_HH_v


**********
estimates clear
cls
qui probit dubvuln i.caste2016 $wealth $HH $head
est store spec1
qui probit dubvuln i.caste2016 $wealth $HH $head i.assets_q
est store spec2
qui probit dubvuln i.caste2016 $wealth $HH $head i.income_q
est store spec3
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR_q
est store spec4
qui probit dubvuln i.caste2016 $wealth $HH $head i.DAR_q
est store spec5
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR30
est store spec6
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR40
est store spec7
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR50
est store spec8
qui probit dubvuln i.caste2016 $wealth $HH $head i.dummyincrel_formal
est store spec9
qui probit dubvuln i.caste2016 $wealth $HH $head rel_formal_HH
est store spec10
qui probit dubvuln i.caste2016 $wealth $HH $head i.assets_q i.income_q i.DSR_q i.DAR_q
est store spec11

cls
esttab spec1 spec2 spec3 spec4 spec5, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N r2_p)
esttab spec6 spec7 spec8 spec9 spec10, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N r2_p)
esttab spec11, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N r2_p)

****************************************
* END










****************************************
* Analysis in cross section: 2016-17 / 2020-21
****************************************
use "panel_v12_long", clear
keep if p==2
keep if caste2016!=. & caste2020!=.

global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid

global varv dummy_nbchildren_v dummy_HHsize_v dummy_rel_repay_amt_HH_v dummy_rel_formal_HH_v


**********
estimates clear
cls
qui probit dubvuln i.caste2016 $wealth $HH $head
est store spec1
qui probit dubvuln i.caste2016 $wealth $HH $head i.assets_q
est store spec2
qui probit dubvuln i.caste2016 $wealth $HH $head i.income_q
est store spec3
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR_q
est store spec4
qui probit dubvuln i.caste2016 $wealth $HH $head i.DAR_q
est store spec5
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR30
est store spec6
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR40
est store spec7
qui probit dubvuln i.caste2016 $wealth $HH $head i.DSR50
est store spec8
qui probit dubvuln i.caste2016 $wealth $HH $head i.dummyincrel_formal
est store spec9
qui probit dubvuln i.caste2016 $wealth $HH $head rel_formal_HH
est store spec10
qui probit dubvuln i.caste2016 $wealth $HH $head i.assets_q i.income_q i.DSR_q i.DAR_q
est store spec11

cls
esttab spec1 spec2 spec3 spec4 spec5, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N r2_p)
esttab spec6 spec7 spec8 spec9 spec10, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N r2_p)
esttab spec11, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N r2_p)

****************************************
* END





















****************************************
* Analysis in panel setting
****************************************
use "panel_v12_long", clear

xtset panelvar p

global head head_female head_age i.head_edulevel i.head_occupation
global wifehusb wifehusb_female wifehusb_age i.wifehusb_edulevel i.wifehusb_occupation
global wealth income assets
global HH HHsize nbchildren i.housetype ownland i.villageid

global varv dummy_nbchildren_v dummy_HHsize_v dummy_rel_repay_amt_HH_v dummy_rel_formal_HH_v


**********
estimates clear
cls
qui xtlogit dubvuln i.caste2016 $wealth $HH $head, fe
est store spec000
qui xtlogit dubvuln i.caste2016 $wealth $HH $head, re
est store spec00
qui xtprobit dubvuln i.caste2016 $wealth $HH $head, pa
est store spec0
qui xtprobit dubvuln i.caste2016 $wealth $HH $head
est store spec1
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.assets_q
est store spec2
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.income_q
est store spec3
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.DSR_q
est store spec4
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.DAR_q
est store spec5
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.DSR30
est store spec6
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.DSR40
est store spec7
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.DSR50
est store spec8
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.dummyincrel_formal
est store spec9
qui xtprobit dubvuln i.caste2016 $wealth $HH $head rel_formal_HH
est store spec10
qui xtprobit dubvuln i.caste2016 $wealth $HH $head i.assets_q i.income_q i.DSR_q i.DAR_q
est store spec11

esttab spec000 spec00 spec0 spec1, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N rho)

cls
esttab spec1 spec2 spec3 spec4 spec5, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N rho)
esttab spec6 spec7 spec8 spec9 spec10, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N rho)
esttab spec11, drop(1.villageid 2.villageid 3.villageid 4.villageid 5.villageid 6.villageid 7.villageid 8.villageid 9.villageid 10.villageid) stats(N rho)


/*
https://www.statalist.org/forums/forum/general-stata-discussion/general/1376221-probit-logit-with-panel-data-should-i-use-probit-or-xtprobit

If after running -xtprobit- you find that rho (at the very end of the output table) is very close to zero, then it would be acceptable to say that the extent of intra-panel correlation is small enough to ignore and if there is some other advantage to using -probit-, you could then use -probit- (and would get nearly identical results). But otherwise, it is wrong to use a one-level model such as -probit- on panel data.
*/

****************************************
* END

