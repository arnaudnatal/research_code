*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*September 22, 2025
*-----
*Prepa Papers
*
cd"C:\Users\Arnaud\Documents\GitHub\research_code\stateneemsis"
*-------------------------


****************************************
* Lists
****************************************

global authors Nordman Guérin Venkat Michiels Natal Mouchel DiSantolo Lanos Hilger Kumar Girollet DEspallier Goedecke Reboul Kar Seetahul Roesch
global data R N1 N2
global topics Debt Employment Personality Networks Agriculture Gender Income Wealth Inequality Demonetisation Covid Mobility Marriage Trust Caste Migration Education Discrimination Consumption Saving Decisionmaking

****************************************
* END









****************************************
* Import
****************************************

********** Import
import excel "NEEMSIS_papers.xlsx", sheet("Papers") firstrow clear
drop if Title==""
drop Permanentlink
save"Papers_v0", replace

****************************************
* END







****************************************
* Cleaning
****************************************
use"Papers_v0", clear

********** Authors
foreach x in $authors {
gen `x'=0
}
foreach x in $authors {
replace `x'=1 if strpos(Authors,"`x'")
}
replace DiSantolo=1 if strpos(Authors,"Di Santolo")
replace DEspallier=1 if strpos(Authors,"D'Espallier")
order $authors, after(Mainauthor)
*
label define yesno 0"No" 1"Yes"
foreach x in $authors {
label values `x' yesno
}


********** Team characteristics
gen team1=.
order team1, after(Team1)
replace team1=1 if strpos(Team1,"Men")
replace team1=2 if strpos(Team1,"Women")
replace team1=3 if Team1=="Mixed"
label define team1 1"Men" 2"Women" 3"Mixed"
label values team1 team1
drop Team1
*
gen team2=.
order team2, after(Team2)
replace team2=1 if strpos(Team2,"North")
replace team2=2 if strpos(Team2,"South")
replace team2=3 if Team2=="Mixed"
label define team2 1"North" 2"South" 3"Mixed"
label values team2 team2
drop Team2
*
gen team3=.
order team3, after(Team3)
replace team3=1 if strpos(Team3,"Interns")
replace team3=2 if strpos(Team3,"Externs")
replace team3=3 if Team3=="Mixed"
label define team3 1"Interns" 2"Externs" 3"Mixed"
label values team3 team3
drop Team3


********** Topic
foreach x in $topics {
gen `x'=0
}
foreach x in $topics {
forvalues i=1/5 {
replace `x'=1 if strpos(Topic`i',"`x'")
label values `x' yesno
}
}
order $topics, after(Topic1)
drop Topic2-Topic5


********** Language
fre Language
gen language=.
replace language=1 if Language=="EN"
replace language=2 if Language=="FR"
label define language 1"English" 2"French"
label values language language
order language, after(Language)
drop Language


********** Data
foreach x in $data {
gen `x'=0
}
foreach x in $data {
replace `x'=1 if strpos(Data,"`x'")
}
gen panel=0
replace panel=1 if R+N1+N2!=1
label define panel 0 "Cross-section" 1 "Panel"
label values panel panel
gen formatpanel=.
replace formatpanel=1 if panel==1 & R!=0 & N1!=0 & N2==0
replace formatpanel=2 if panel==1 & R==0 & N1!=0 & N2!=0
replace formatpanel=3 if panel==1 & R!=0 & N1!=0 & N2!=0
label define formatpanel 1"R-N1" 2"N1-N2" 3"R-N1-N2"
label values formatpanel formatpanel
ta formatpanel
foreach x in $data {
label values `x' yesno
}
order $data panel formatpanel, after(Data)
drop Data


********** Status
gen status=.
forvalues i=1/4 {
replace status=`i' if strpos(Status,"`i'")
}
label define status 1"Ongoing" 2"Submitted" 3"Published" 4"Finished"
label values status status
order status, after(Status)
drop Status


********** Type
gen type=.
replace type=1 if Type=="Journal article"
replace type=2 if Type=="Book chapter"
replace type=3 if Type=="Book"
replace type=4 if Type=="WP only"
replace type=5 if Type=="Dissertation"
replace type=6 if Type=="Policy brief"
replace type=7 if Type=="Blog post"
label define type 1"Journal article" 2"Book chapter" 3"Book" 4"WP only" 5"Dissertation" 6"Policy brief" 7"Blog post"
label values type type
order type, after(Type)
drop Type


********** Open access and WP
label values Open yesno
label values WP yesno
*
gen availability=0
replace availability=1 if Open==1 | WP==1
label define availability 0 "No" 1 "Yes"
label values availability availability
order availability, after(WP2date)


********** Date for ongoing and submitted
fre status
replace Year=2025 if status==1
replace Year=2025 if status==2


********** From dissertation?
label define Fromdissertation 0"Original paper" 1"Paper from thesis"
label values Fromdissertation Fromdissertation
fre Fromdissertation



********** 
codebook type
label define type 1"Article" 2"Chapter" 4"W. paper", modify
fre type


*
save"Papers_v1", replace
erase"Papers_v0.dta"
****************************************
* END
