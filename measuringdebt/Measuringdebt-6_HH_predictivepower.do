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
* Prediction power
****************************************
use"panel_v8", clear


********** To keep
global vardebt pcaindex pca2index m2index dsr dar rfm tdr lpc
global varlabour head_nboccupation nbworker_HH hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH sharehoursayearagri_HH sharehoursayearnonagri_HH
keep panelvar year $vardebt $varlabour
mdesc $vardebt $varlabour


********** Reshape
reshape wide $vardebt $varlabour, i(panelvar) j(year)


********** Re-organize the dataset
*** Drop occ 2010
foreach x in $varlabour {
drop `x'2010
}

*** Drop debt 2020
foreach x in $vardebt {
drop `x'2020
}

*** Rename
foreach x in $vardebt {
rename `x'2010 `x'1
rename `x'2016 `x'2
}

foreach x in $varlabour {
rename `x'2016 `x'1
rename `x'2020 `x'2
}

*** Clean with only full obs, i.e. full panel HH
drop if pcaindex1==.
drop if pcaindex2==.
drop if head_nboccupation2==.


*** Reshape
reshape long $vardebt $varlabour, i(panelvar) j(period)
mdesc $vardebt $varlabour



********** Test econometrics
xtset panelvar period
tabstat $varlabour, stat(n mean cv p50 min max)

cls
*foreach y in $vardebt {
*foreach x in $varlabour {
foreach y in pcaindex mindex {
foreach x in nbworker_HH hoursayear_HH hoursayearagri_HH hoursayearnonagri_HH {
xtreg `y' `x', fe
}
}


****************************************
* END
