**********
* Arnaud NATAL
* arnaud.natal@ifpindia.org
* Global estimate of household debt to make ends meet
**********



********** Directory
cd"D:/Ongoing_JPS_Debtworldwide/Analysis"



********** Import
import excel "WorldDebt.xlsx", sheet("Pop") firstrow clear
keep name value shareworld
rename name Country
rename value Worldpop
rename shareworld Shareworldpop
drop if Country==""
save"_temppop", replace
*
import excel "WorldDebt.xlsx", sheet("Data") firstrow clear
drop if Country==""
merge 1:1 Country using "_temppop"
keep if _merge==3
drop _merge
order Country Selectyn NorthSouth Worldpop Shareworldpop


********** Global estimates
***** Debt
gen scountry=.
replace scountry=Measure2 if Measure2!=.
replace scountry=Measure1 if Measure1!=. & scountry==.
*
gen share=scountry*Shareworldpop
egen s_share=sum(share) if share!=.
egen s_pop=sum(Shareworldpop) if share!=.
gen INFDEBT=s_share/s_pop
rename s_pop INFDEBT_SHAREPOP
drop scountry share s_share

***** Poverty
gen scountry=.
replace scountry=Measure4 if Measure4!=.
*
gen share=scountry*Shareworldpop
egen s_share=sum(share) if share!=.
egen s_pop=sum(Shareworldpop) if share!=.
gen POVERTY=s_share/s_pop
rename s_pop POVERTY_SHAREPOP
drop scountry share s_share

***** Save
preserve
keep INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP
foreach x in INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP {
egen `x'2=max(`x')
drop `x'
rename `x'2 `x'
}
duplicates drop
gen cat="Global"
order cat, first
save"_tempglobal", replace
restore
drop INFDEBT POVERTY INFDEBT_SHAREPOP POVERTY_SHAREPOP


********** North
preserve
keep if NorthSouth=="N"
egen sp=sum(Worldpop)
gen scp=Worldpop/sp
***** Debt
gen scountry=.
replace scountry=Measure2 if Measure2!=.
replace scountry=Measure1 if Measure1!=. & scountry==.
*
gen share=scountry*scp
egen s_share=sum(share) if share!=.
egen s_pop=sum(scp) if share!=.
gen INFDEBT=s_share/s_pop
rename s_pop INFDEBT_SHAREPOP
drop scountry share s_share

***** Poverty
gen scountry=.
replace scountry=Measure4 if Measure4!=.
*
gen share=scountry*scp
egen s_share=sum(share) if share!=.
egen s_pop=sum(scp) if share!=.
gen POVERTY=s_share/s_pop
rename s_pop POVERTY_SHAREPOP
drop scountry share s_share

***** Save
keep INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP
foreach x in INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP {
egen `x'2=max(`x')
drop `x'
rename `x'2 `x'
}
replace INFDEBT_SHAREPOP=INFDEBT_SHAREPOP*100
replace POVERTY_SHAREPOP=POVERTY_SHAREPOP*100
duplicates drop
gen cat="North"
order cat, first
save"_tempnorth", replace
restore



********** South
preserve
keep if NorthSouth=="S"
egen sp=sum(Worldpop)
gen scp=Worldpop/sp
***** Debt
gen scountry=.
replace scountry=Measure2 if Measure2!=.
replace scountry=Measure1 if Measure1!=. & scountry==.
*
gen share=scountry*scp
egen s_share=sum(share) if share!=.
egen s_pop=sum(scp) if share!=.
gen INFDEBT=s_share/s_pop
rename s_pop INFDEBT_SHAREPOP
drop scountry share s_share

***** Poverty
gen scountry=.
replace scountry=Measure4 if Measure4!=.
*
gen share=scountry*scp
egen s_share=sum(share) if share!=.
egen s_pop=sum(scp) if share!=.
gen POVERTY=s_share/s_pop
rename s_pop POVERTY_SHAREPOP
drop scountry share s_share

***** Save
keep INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP
foreach x in INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP {
egen `x'2=max(`x')
drop `x'
rename `x'2 `x'
}
replace INFDEBT_SHAREPOP=INFDEBT_SHAREPOP*100
replace POVERTY_SHAREPOP=POVERTY_SHAREPOP*100
duplicates drop
gen cat="South"
order cat, first
save"_tempsouth", replace
restore



********** Exports
use"_tempglobal", clear
append using "_tempnorth"
append using "_tempsouth"

foreach x in INFDEBT INFDEBT_SHAREPOP POVERTY POVERTY_SHAREPOP {
replace `x'=round(`x',0.01)
}
order cat INFDEBT_SHAREPOP INFDEBT POVERTY_SHAREPOP POVERTY
export excel using "Estimates.xlsx", firstrow(variables) replace
erase "_tempglobal.dta"
erase "_tempnorth.dta"
erase "_tempsouth.dta"
erase "_temppop.dta"
