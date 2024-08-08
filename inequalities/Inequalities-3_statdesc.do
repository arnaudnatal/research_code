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
* Stat HH
****************************************
use"panel_v4", clear

* Lorenz
preserve
keep HHID_panel year sharewomen
rename sharewomen var
reshape wide var, i(HHID_panel) j(year)
lorenz estimate var2010 var2016 var2020
lorenz graph, noci overlay legend(pos(6) col(3) order(2 "2010" 3 "2016-17" 4 "2020-21")) xtitle("Population share") ytitle("Cumulative monthly income proportion")
restore


* Desc
tabstat sharewomen, stat(mean q) by(year)

tabstat sharewomen if caste==1, stat(mean q) by(year)
tabstat sharewomen if caste==2, stat(mean q) by(year)
tabstat sharewomen if caste==3, stat(mean q) by(year)

tabstat sharewomen if poor_HH==0, stat(mean q) by(year)
tabstat sharewomen if poor_HH==1, stat(mean q) by(year)

tabstat sharewomen if assets_cat==1, stat(mean q) by(year)
tabstat sharewomen if assets_cat==2, stat(mean q) by(year)
tabstat sharewomen if assets_cat==3, stat(mean q) by(year)

tabstat sharewomen if income_cat==1, stat(mean q) by(year)
tabstat sharewomen if income_cat==2, stat(mean q) by(year)
tabstat sharewomen if income_cat==3, stat(mean q) by(year)


* Theil
ineqdeco sharewomen


****************************************
* END




