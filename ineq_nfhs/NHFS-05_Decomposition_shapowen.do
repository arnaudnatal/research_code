*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 5, 2026
*-----
*Shapowen
*-----

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_JatisInequalities\Analysis"
cd"$directory"
*-------------------------










****************************************
* Decomposition 12 dimension
****************************************
use "Indiv_mpi.dta", clear

* Selection
keep if jatis1000==1

***** Caste / State
shapowen ///
i.head_caste ///
i.loc_state ///
"i.loc_rururb c.hh_size i.hh_family i.head_sex c.head_age i.head_marital i.head_religion", ///
scalarexpressions(e(r2)) ///
: regress dp_score12 @ [pw=wgt]	


***** Jatis / State
shapowen ///
i.head_jatis ///
i.loc_state ///
"i.loc_rururb c.hh_size i.hh_family i.head_sex c.head_age i.head_marital i.head_religion", ///
scalarexpressions(e(r2)) ///
: regress dp_score12 @ [pw=wgt]	


***** Caste / District
shapowen ///
i.head_caste ///
i.loc_district ///
"i.loc_rururb c.hh_size i.hh_family i.head_sex c.head_age i.head_marital i.head_religion", ///
scalarexpressions(e(r2)) ///
: regress dp_score12 @ [pw=wgt]	


***** Jatis / District
shapowen ///
i.head_jatis ///
i.loc_district ///
"i.loc_rururb c.hh_size i.hh_family i.head_sex c.head_age i.head_marital i.head_religion", ///
scalarexpressions(e(r2)) ///
: regress dp_score12 @ [pw=wgt]	

****************************************
* END



