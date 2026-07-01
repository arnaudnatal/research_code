*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 5, 2026
*-----
*MPI
*-----

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_JatisInequalities\Analysis"
cd"$directory"
*cd"C:\Users\anatal\Documents\nfhs"
*-------------------------












****************************************
* Creation
****************************************

********** Shape file to dta
shp2dta using "shapefile/STATE_BOUNDARY.shp", database(india_state) coordinates(india_coord) gencentroids(coord) genid(id) replace 

********** Stats to dta
import excel "Statistics.xlsx", sheet("data") firstrow clear
sort id
drop if loc_state==9
drop if loc_state==.
save"_tempstat.dta", replace


********** Polygons and data in the same dataset
use"india_state", clear
*
merge 1:1 id using "_tempstat"
keep if _merge==3
drop _merge
*
save"india_state_v2", replace

****************************************
* END








****************************************
* Variables
****************************************
use"india_state_v2", clear

* Cat mpi (Pradhan et al., 2022)
gen cat1_mpi=.
replace cat1_mpi=1 if m0<4
replace cat1_mpi=2 if m0>=4 & m0<=10
replace cat1_mpi=3 if m0>10
label define cat1_mpi 1"Less than .04" 2".04-.09" 3".1 or more"
label values cat1_mpi cat1_mpi

* Cat2 mpi 
gen cat2_mpi=.
replace cat2_mpi=1 if m0<5
replace cat2_mpi=2 if m0>=5 & m0<=10
replace cat2_mpi=3 if m0>=10 & m0<=15
replace cat2_mpi=4 if m0>=15 & m0<=20
replace cat2_mpi=5 if m0>20
label define cat2_mpi 1"Less than .05" 2".05-.1" 3".1-.15" 4".15-.2" 5".2 or more"
label values cat2_mpi cat2_mpi

* Contrib pop vs contrib MPI
ta percentage_sample
ta contrib_m0
gen ratioMPIsample=contrib_m0/percentage_sample
ta ratioMPIsample
gen cat_ratio=.
label define cat_ratio 1"Less than 1" 2"1-1.5" 3"1.5 or more"
label values cat_ratio cat_ratio
replace cat_ratio=1 if ratioMPIsample<1
replace cat_ratio=2 if ratioMPIsample>=1 & ratioMPIsample<1.5
replace cat_ratio=3 if ratioMPIsample>=1.5

* Total share between
label define cat_sharebetween 0"Missing" 1"Less than 5%" 2"5-10%" 3"10-20%" 4"20-30%" 5"30-40%" 6"40-50%" 7"50-60%" 8"60-70%" 9"70-80%" 10"80-90%" 11"90% or more"
foreach x in tot_sharebetween sc_sharebetween st_sharebetween obc_sharebetween oth_sharebetween {
gen cat_`x'=.
replace cat_`x'=1 if `x'<5
replace cat_`x'=2 if `x'>=5 & `x'<10
replace cat_`x'=3 if `x'>=10 & `x'<20
replace cat_`x'=4 if `x'>=20 & `x'<30
replace cat_`x'=5 if `x'>=30 & `x'<40
replace cat_`x'=6 if `x'>=40 & `x'<50
replace cat_`x'=7 if `x'>=50 & `x'<60
replace cat_`x'=8 if `x'>=60 & `x'<70
replace cat_`x'=9 if `x'>=70 & `x'<80
replace cat_`x'=10 if `x'>=80 & `x'<90
replace cat_`x'=11 if `x'>=90
replace cat_`x'=0 if `x'==.
label values cat_`x' cat_sharebetween
}

*
save"india_state_v3", replace

****************************************
* END

























****************************************
* Graph
****************************************
use"india_state_v3", clear

*** MPI (Pradhan et al., 2022)
colorpalette viridis, n(3) nograph reverse
local colors `r(p)'
*
spmap cat1_mpi using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Multidimensional poverty index", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_mpi_pradhan.png", as(png) replace

*** MPI det
colorpalette viridis, n(5) nograph reverse
local colors `r(p)'
*
spmap cat2_mpi using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Multidimensional poverty index", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_mpi_alt.png", as(png) replace

*** Contrib MPI
colorpalette viridis, n(3) nograph reverse
local colors `r(p)'
*
spmap cat_ratio using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Contrib MPI / Contrib pop", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_contrib.png", as(png) replace

*** Cat share between tot
colorpalette viridis, n(7) nograph reverse
local colors `r(p)'
*
spmap cat_tot_sharebetween using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Share of between jatis inequalities (all castes)", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_sharebetween_tot.png", as(png) replace

*** Cat share between sc
colorpalette viridis, n(10) nograph reverse
local colors `r(p)'
*
spmap cat_sc_sharebetween using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Share of between jatis inequalities (SC)", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_sharebetween_sc.png", as(png) replace

*** Cat share between st
colorpalette viridis, n(9) nograph reverse
local colors `r(p)'
*
spmap cat_st_sharebetween using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Share of between jatis inequalities (ST)", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_sharebetween_st.png", as(png) replace

*** Cat share between obc
colorpalette viridis, n(10) nograph reverse
local colors `r(p)'
*
spmap cat_obc_sharebetween using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Share of between jatis inequalities (OBC)", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_sharebetween_obc.png", as(png) replace

*** Cat share between other
colorpalette viridis, n(10) nograph reverse
local colors `r(p)'
*
spmap cat_oth_sharebetween using india_coord, id(id) ///
clmethod(unique) ///
fcolor("`colors'") ///
ocolor(white ..) osize(0.05 ..)  ///
title("Share of between jatis inequalities (Other castes)", size(medium)) ///
legstyle(2) legend(pos(5) size(2) region(fcolor(gs15)))   ///
note("Source: NFHS-4 (2015-2016); author's calculations.", size(vsmall))
graph export "graph/map_sharebetween_oth.png", as(png) replace

****************************************
* END
