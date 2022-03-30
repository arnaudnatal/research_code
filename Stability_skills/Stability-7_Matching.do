cls

/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
March 30, 2022
-----
Stability over time of personality traits
-----

-------------------------
*/


****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
set scheme plotplain

********** Path to folder "data" folder.
*** PC
global directory = "C:\Users\Arnaud\Documents\_Thesis\Research-Stability_skills\Analysis"
cd"$directory"
global git "C:\Users\Arnaud\Documents\GitHub"

*** Fac
*global directory = "C:\Users\anatal\Downloads\_Thesis\Research-Stability_skills\Analysis"
*cd "$directory"
*global git "C:\Users\anatal\Downloads\GitHub"

********** Name of the NEEMSIS2 questionnaire version to clean
global wave2 "NEEMSIS1-HH"
global wave3 "NEEMSIS2-HH"
****************************************
* END




/*
• DEFAULT --> One to one : 	neighbor(1)

• k nearest: 						neighbor(k)
	• Sans remplacement pour k=1:	noreplacement
	• *Descendant pour k=1: 		descending
	• Match les contrôles: 			ties

• Radius Caliper: 					radius
	• Régler le caliper: 			caliper(x)
	
• Kernel: 							kerneltype(j)
	• Gauss: 						j=normal
	• Biweight: 					j=biweight
	• Epanechnikov: 				j=epan
	• Uniforme: 					j=uniform
	• Tricube:						j=tricube
	
• Spline: spline	
*/	





****************************************
* Matching shock demonetisation
****************************************
use "$wave2", clear

global var caste age sex mainocc_occupation_indiv edulevel

global treat dummydemonetisation

psmatch2 $treat $var, common n(2)

pstest $var, treated($treat) both
pstest $var, treated($treat) both graph label
pstest $var, treated($treat) both scatter

psgraph

gen 	charact=1 if _support==1 & $treat==1
replace	charact=0 if _support==1 & $treat==0

drop _pscore _treated _support _weight _id _n1 _nn _pdif


twoway (kdensity _pscore if $treat==1, clwid(medium)) (kdensity _pscore if $treat==0, clwid(thin) clcolor(black)), xti("") yti("") title("") ///
	legend(order(1 "p-score treatment" 2 "p-score control"))



****************************************
* END
