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




/*
FactomineR:
Linkage: Ward
Distance: L2squared  squared Euclidean distance 
*/






****************************************
* FVI
****************************************
use"panel_v3", clear


*** Income
replace rrgpl=100 if rrgpl>100
replace rrgpl=-100 if rrgpl<-100
gen rrgpl2=rrgpl
replace rrgpl2=0 if rrgpl<0

*** ISR
replace isr=100 if isr>100
ta isr


*** TDR
ta tdr

*** TAR
replace tar=100 if tar>100

*** FVI
replace tar=tar/100
replace isr=isr/100
replace rrgpl2=rrgpl2/100
/*
2*tdr+2*isr+rrgpl2
tar+isr+rrgpl2
*/
gen fvi=(tar+isr+rrgpl2)/3
*gen fvib=(2*tdr+2*isr+rrgpl2)/5
*sum fvi fvib

*replace tar=tar*100
*replace isr=isr*100
*replace rrgpl2=rrgpl2*100

*** Label
label var tar "TAR"
label var isr "ISR"
label var rrgpl "RRGPL"
label var rrgpl2 "RRGPL"
label var fvi "FVI"


save"panel_v4.dta", replace
****************************************
* END












****************************************
* A-MPI - FVi
****************************************
use"panel_v4", clear

*** Range 70-130
* TDR
ta tar
gen a_tar=((tar-0)/(100-0))*60+70
sum a_tar

* ISR
ta isr
gen a_isr=((isr-0)/(100-0))*60+70
sum a_isr

* RRGPL
ta rrgpl
gen a_rrgpl=((rrgpl+100)/(100+100))*60+70
sum a_rrgpl


*** Mean, CV, and STD
egen M=rowmean(a_tar a_isr a_rrgpl)
egen S=rowsd(a_tar a_isr a_rrgpl)
gen cv=S/M


*** AMPI
gen ampi=M+S*cv
ta ampi

*** Clean
drop a_tar a_isr a_rrgpl M S cv
drop rrgpl
rename rrgpl2 rrgpl
drop ampi

save"panel_v5", replace
****************************************
* END













****************************************
* Desc
****************************************
use"panel_v5", clear


********** Desc
tabstat fvi, stat(n mean cv) by(year)

* Corr for FE
keep HHID_panel year fvi
reshape wide fvi, i(HHID_panel) j(year)
pwcorr fvi2010 fvi2016 fvi2020, star(.1)

****************************************
* END




