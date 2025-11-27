*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 2, 2025
*-----
gl link = "debtnetworks"
*Desc analysis
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:\Users\Arnaud\Documents\GitHub\folderanalysis\debtnetworks.do"
*-------------------------







****************************************
* Table stat desc
****************************************
use"Analysesloan_v2", clear

ta sex
ta caste

********** Stat
cls
***** X-var
foreach x in samecaste samesex sameoccup samevillage dummymultipleloan invite_reciprocity sndummyfam snfriend snlabourrelation {
*ta `x'
ta `x' sex, nofreq chi2
ta `x' caste, nofreq chi2
}

tabstat snduration, stat(n mean)
tabstat snduration, stat(n mean) by(sex)
tabstat snduration, stat(n mean) by(caste)

reg snduration i.sex
reg snduration i.caste


cls
***** Y-var
foreach y in dummyinterest dummyg_mat dummylenderservices dummyborrowerservice  {
ta `y'
ta `y' sex, nofreq chi2 col 
ta `y' caste, nofreq chi2 col
}


********** Pop size
keep HHID2020 INDID2020
duplicates drop
count
keep HHID2020
duplicates drop
count




****************************************
* END
