*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*November 19, 2022
*-----
gl link = "labourdebt"
*Prepa database
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\labourdebt.do"
*-------------------------








****************************************
* Financial Vulnerability Index
****************************************
use"panel_v0", clear


********** RRGPL
*45.71 in 2010
*65.10 in 2017

/*
All is expressed in 2010 PPP
However, new PL with 2017
annualincome_HH is expressed in 2010 rupees
annualincome_HH2 is not deflated
*/
tabstat annualincome_HH annualincome_HH2, stat(n mean) by(year)

* Deflate for 2017 PPP
gen annualincome_HH_backup=annualincome_HH2
replace annualincome_HH2=annualincome_HH2*(100/62.81) if year==2010
replace annualincome_HH2=annualincome_HH2*(100/114.95) if year==2020
replace annualincome_HH2=round(annualincome_HH2,1)

* Test
tabstat annualincome_HH_backup annualincome_HH annualincome_HH2, stat(n mean) by(year)
/*
Ok
*/


gen dailyincome_pc=(annualincome_HH2/365)/HHsize
*gen dailyusdincome_pc=dailyincome_pc/65.10
gen dailyusdincome_pc=dailyincome_pc/20.647793
gen rrgpl2=((dailyusdincome_pc-2.15)/2.15)*(-1)
ta rrgpl2
replace rrgpl2=1 if rrgpl2>1
replace rrgpl2=0 if rrgpl2<0
*the more is the poorer


********** ISR
gen isr=imp1_is_tot_HH/annualincome_HH
replace isr=0 if isr==.
replace isr=1 if isr>1
ta isr

gen isr_noinv=imp1_is_tot_HH_noinv/annualincome_HH
replace isr_noinv=0 if isr_noinv==.
replace isr_noinv=1 if isr_noinv>1
ta isr

********** TDR
gen tdr=totHH_givenamt_repa/loanamount_HH
replace tdr=0 if tdr==.
ta tdr

gen tdr_noinv=totHH_givenamt_repa_noinv/loanamount_HH_noinv
replace tdr_noinv=0 if tdr_noinv==.
ta tdr_noinv



********** TAR
gen tar=totHH_givenamt_repa/assets_total
replace tar=0 if tar==.
replace tar=1 if tar>1
ta tar



********** DAR
gen dar=loanamount_HH/assets_total
replace dar=0 if dar==.
replace dar=5 if dar>5
sum dar


********* FVI
* FVI
gen fvi=(2*tdr+2*isr+1*rrgpl2)/5
gen fvi2=(1*tdr+1*isr+1*rrgpl2)/3
gen fvi3=(2*tar+2*isr+1*rrgpl2)/5
gen fvi4=(1*tar+1*isr+1*rrgpl2)/5


gen fvi_noinv=(2*tdr_noinv+2*isr_noinv+1*rrgpl2)/5

* FVI
*gen fvi=(tar+isr+rrgpl2)/3

ta fvi
sum fvi

save"panel_v1", replace 
****************************************
* END




















****************************************
* Others variables
****************************************
use"panel_v1", clear


********** Other var
* HH
encode HHID_panel, gen(panelvar)

* Time
gen time=0
replace time=1 if year==2010
replace time=2 if year==2016
replace time=3 if year==2020
label define time 1"2010" 2"2016-17" 3"2020-21"
label values time time

* Dalits
gen dalits=.
replace dalits=1 if caste==1
replace dalits=0 if caste==2
replace dalits=0 if caste==3

* Village
encode villageid, gen(vill)

*Stem
gen stem=.
replace stem=0 if typeoffamily=="nuclear"
replace stem=1 if typeoffamily=="stem"
replace stem=1 if typeoffamily=="joint-stem"
label define stem 0"Nuclear" 1"Stem"
label values stem stem
ta stem typeoffamily

* Trap
gen dummytrap=0
replace dummytrap=1 if tdr>0

* Head sex
fre head_sex
gen head_female=.
replace head_female=0 if head_sex==1
replace head_female=1 if head_sex==2

ta head_sex head_female
label define head_female 0"Male" 1"Female"
label values head_female head_female

* Head occupation
fre head_mocc_occupation
recode head_mocc_occupation (5=4)
ta head_mocc_occupation, gen(head_occ)


* Head edulevel
fre head_edulevel
recode head_edulevel (3=2) (4=2) (5=2)
ta head_edulevel, gen(head_educ)


* Head age
tabstat head_age, stat(n mean sd q)
gen head_agesq=head_age*head_age

gen head_agecat=0
replace head_agecat=1 if head_age<40
replace head_agecat=2 if head_age>=40 & head_age<50
replace head_agecat=3 if head_age>=50 & head_age<60
replace head_agecat=4 if head_age>=60

label define head_agecat 1"Less 40" 2"40-50" 3"50-60" 4"60 or more"
label values head_agecat head_agecat
ta head_agecat, gen(head_agecat)


* Head maritalstatus
fre head_maritalstatus
gen head_nonmarried=head_maritalstatus
recode head_nonmarried (1=0) (2=1) (3=1) (4=1) (.=0)
label define head_nonmarried 0"Married" 1"Non-married"
label values head_nonmarried head_nonmarried
fre head_nonmarried

* Class
** Categorize assets 
/*
by year to take into account the
increasing level of consumption
see ref on conspicuous consumption
*/
tabstat assets_total, stat(q) by(year)
foreach i in 2010 2016 2020 {
xtile assets_`i'=assets_total if year==`i', n(3) 
}
gen assets_cat=.
replace assets_cat=assets_2010 if year==2010
replace assets_cat=assets_2016 if year==2016
replace assets_cat=assets_2020 if year==2020
drop assets_2010 assets_2016 assets_2020
ta assets_cat
label define assets_cat 1"Wealth: Poor" 2"Wealth: Middle" 3"Wealth: Rich"
label values assets_cat assets_cat
fre assets_cat
ta assets_cat caste, chi2 cchi2 exp
ta assets_cat, gen(assets_cat)






********** Last minute var crea
gen head_educ=head_edulevel
recode head_educ (2=1)

* Rem + Assets
foreach x in assets_total remittnet_HH annualincome_HH {
egen `x'_std=std(`x')
rename `x' `x'_r
rename `x'_std `x'
}

ta villageid, gen(village_)


*** Fafchamps and Quisumbing, 1998

* Log HH size
gen log_HHsize=log(HHsize)

* Share children
gen share_children=agegrp_0_13/HHsize

* Share female
gen share_female2=nbfemale/HHsize

* Share old
gen share_old=(agegrp_70_79+agegrp_80_100)/HHsize

* Share young
gen share_young=agegrp_14_17/HHsize

* Stock mdo en age de travailler, qui ne travaille pas, en %
gen share_stock=nbworker_HH/HHsize


* Caste
ta caste, gen(caste_)
label var caste_1 "Caste: Dalits"
label var caste_2 "Caste: Middle"
label var caste_3 "Caste: Upper"


*** Lockdown
rename secondlockdownexposure lockdown
fre lockdown
recode lockdown (1=0) (.=0) (2=1) (3=2)
label define exposure 0"No" 1"During" 2"After", modify
ta lockdown, gen(lockdown)



*** Demonetisation
fre dummydemonetisation
label values dummydemonetisation yesno
fre dummydemonetisation


save"panel_v2", replace 
****************************************
* END



*do"C:\Users\Arnaud\Documents\GitHub\research_code\labourdebt\Labourdebt-3_variables_labour.do"
*do"C:\Users\Arnaud\Documents\GitHub\research_code\labourdebt\Labourdebt-4_desc.do"
*do"C:\Users\Arnaud\Documents\GitHub\research_code\labourdebt\Labourdebt-6_indivdatabase.do"
*do"C:\Users\Arnaud\Documents\GitHub\research_code\labourdebt\Labourdebt-7_predictivepower_indiv.do"





