*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*MCA
*-----
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*cd"C:\Users\anatal\Documents\id"
*-------------------------







****************************************
* HCPC
****************************************
use"Loans_v2", clear

********** Preparation
* Var
global var cat5amount cat3amount lender2 reason2 reason3 interest interest2 duration2 security2 scheme2

keep if year==2012 | year==2019
mdesc

keep uniqueid $var
foreach x in $var {
decode `x', gen(dec_`x')
drop `x'
rename dec_`x' `x'
}
export delimited using "Allloans.csv", replace


********** Import results HCPC
import delimited using "Allloans_res.csv", clear
save"_temp", replace
use"Loans_v2", clear
merge 1:1 uniqueid using"_temp", keepusing(cluster)
drop _merge

save"Loans_v3", replace
****************************************
* END







****************************************
* Stat
****************************************
use"Loans_v3", clear

ta cluster
recode cluster (2=77) (5=77) (6=77)
*recode cluster (2=77) (5=77) (7=77) (8=77) (9=77)
ta cluster

ta cluster year, col nofreq

ta reason cluster, col nofreq
ta lender cluster, col nofreq 
ta duration cluster, col nofreq
ta interest cluster, col nofreq
ta scheme cluster, col nofreq
ta security cluster, col nofreq
ta cat5amount cluster, col nofreq

****************************************
* END


