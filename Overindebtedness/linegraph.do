import delimited using "C:\Users\Arnaud\Documents\GitHub\Analysis\Overindebtedness\debttrendRreturn.csv", clear
keep v1 cluster* loan1 loan2 loan3
reshape long loan, i(v1) j(time)
xtset v1 time
ta clustersbd clusterdtw
/*
ta cluster, gen(cl)
sort cluster v1 time
forvalues i=1(1)15 {
set graph off
capture confirm variable cl`i'
if _rc==0 {
twoway (line loan time if cluster==`i', c(L) lcolor(red%10)), name(g`i', replace)
graph export "C:\Users\Arnaud\Desktop\_graph\g`i'.pdf", as(pdf) replace 
}
set graph on
}
*/