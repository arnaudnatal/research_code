*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*April 29, 2026
*-----
gl link = "debttrap"
*Econo indiv level
*-----
*do "https://raw.githubusercontent.com/arnaudnatal/folderanalysis/main/$link.do"
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------






****************************************
* Both nonparametric graphs
****************************************

********** Household
use"panel_HH_v3", clear
* 
drop if timeperiod==.
keep if dummyloans_HH1==1
keep if dummyloans_HH2==1
drop if year==2020
drop if year==2010
*
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 180) xline(30)) ///
xtitle("DSR (2016-2017)") ytitle("DSR (2020-2021)") ///
title("(a) Household") legend(off) name(hhall, replace) scale(1.1)


********** Individual
use"panel_indiv_v3", clear
* 
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010
*
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 300) xline(30)) ///
xtitle("DSR (2016-2017)") ytitle("DSR (2020-2021)") ///
title("(b) Individual") legend(off) name(indivall, replace) scale(1.1)

********** Combine
graph combine hhall indivall, col(2) name(comb, replace)
graph export "graph/nonpara.png", as(png) replace

****************************************
* END

















****************************************
* Nonparametric
****************************************
use"panel_indiv_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010



********** Nonparametric regression
lpoly w5_dsr2 w5_dsr1, kernel(epanechnikov) degree(4) ci noscatter ///
addplot(function y=x, range(0 300) xline(30)) ///
xtitle("DSR t") ytitle("DSR t+1") ///
title("Individual level") legend(off) name(indivall, replace)
graph export "graph/indiv_w5.png", replace



********** Nonparametric equilibrium
* All
eq_lpoly w5_dsr2 w5_dsr1
* By gender
foreach i in 0 1 {
preserve
keep if female==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}
* By caste
foreach i in 0 1 {
preserve
keep if dalits==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}
* By agri
foreach i in 0 1 {
preserve
keep if agriHH==`i'
eq_lpoly w5_dsr2 w5_dsr1
restore
}

****************************************
* END














****************************************
* Parametrics
****************************************
use"panel_indiv_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010

global HH HH1 HH2 HH3 HH4 HH5 HH6 HH7 HH8 HH9 HH10 HH11 HH12 HH13 HH14 HH15 HH16 HH17 HH18 HH19 HH20 HH21 HH22 HH23 HH24 HH25 HH26 HH27 HH28 HH29 HH30 HH31 HH32 HH33 HH34 HH35 HH36 HH37 HH38 HH39 HH40 HH41 HH42 HH43 HH44 HH45 HH46 HH47 HH48 HH49 HH50 HH51 HH52 HH53 HH54 HH55 HH56 HH57 HH58 HH59 HH60 HH61 HH62 HH63 HH64 HH65 HH66 HH67 HH68 HH69 HH70 HH71 HH72 HH73 HH74 HH75 HH76 HH77 HH78 HH79 HH80 HH81 HH82 HH83 HH84 HH85 HH86 HH87 HH88 HH89 HH90 HH91 HH92 HH93 HH94 HH95 HH96 HH97 HH98 HH99 HH100 HH101 HH102 HH103 HH104 HH105 HH106 HH107 HH108 HH109 HH110 HH111 HH112 HH113 HH114 HH115 HH116 HH117 HH118 HH119 HH120 HH121 HH122 HH123 HH124 HH125 HH126 HH127 HH128 HH129 HH130 HH131 HH132 HH133 HH134 HH135 HH136 HH137 HH138 HH139 HH140 HH141 HH142 HH143 HH144 HH145 HH146 HH147 HH148 HH149 HH150 HH151 HH152 HH153 HH154 HH155 HH156 HH157 HH158 HH159 HH160 HH161 HH162 HH163 HH164 HH165 HH166 HH167 HH168 HH169 HH170 HH171 HH172 HH173 HH174 HH175 HH176 HH177 HH178 HH179 HH180 HH181 HH182 HH183 HH184 HH185 HH186 HH187 HH188 HH189 HH190 HH191 HH192 HH193 HH194 HH195 HH196 HH197 HH198 HH199 HH200 HH201 HH202 HH203 HH204 HH205 HH206 HH207 HH208 HH209 HH210 HH211 HH212 HH213 HH214 HH215 HH216 HH217 HH218 HH219 HH220 HH221 HH222 HH223 HH224 HH225 HH226 HH227 HH228 HH229 HH230 HH231 HH232 HH233 HH234 HH235 HH236 HH237 HH238 HH239 HH240 HH241 HH242 HH243 HH244 HH245 HH246 HH247 HH248 HH249 HH250 HH251 HH252 HH253 HH254 HH255 HH256 HH257 HH258 HH259 HH260 HH261 HH262 HH263 HH264 HH265 HH266 HH267 HH268 HH269 HH270 HH271 HH272 HH273 HH274 HH275 HH276 HH277 HH278 HH279 HH280 HH281 HH282 HH283 HH284 HH285 HH286 HH287 HH288 HH289 HH290 HH291 HH292 HH293 HH294 HH295 HH296 HH297 HH298 HH299 HH300 HH301 HH302 HH303 HH304 HH305 HH306 HH307 HH308 HH309 HH310 HH311 HH312 HH313 HH314 HH315 HH316 HH317 HH318 HH319 HH320 HH321 HH322 HH323 HH324 HH325 HH326 HH327 HH328 HH329 HH330 HH331 HH332 HH333 HH334 HH335 HH336 HH337 HH338 HH339 HH340 HH341 HH342 HH343 HH344 HH345 HH346 HH347 HH348 HH349 HH350 HH351 HH352 HH353 HH354 HH355 HH356 HH357 HH358 HH359 HH360 HH361 HH362 HH363 HH364 HH365 HH366 HH367 HH368 HH369 HH370 HH371 HH372 HH373 HH374 HH375 HH376 HH377 HH378 HH379 HH380 HH381 HH382 HH383 HH384 HH385 HH386 HH387 HH388 HH389 HH390 HH391 HH392 HH393 HH394 HH395 HH396 HH397 HH398 HH399 HH400 HH401 HH402 HH403 HH404 HH405 HH406 HH407 HH408 HH409 HH410 HH411 HH412 HH413 HH414 HH415 HH416 HH417 HH418 HH419 HH420 HH421 HH422 HH423 HH424 HH425 HH426 HH427 HH428 HH429 HH430 HH431 HH432 HH433 HH434 HH435 HH436 HH437 HH438 HH439 HH440 HH441 HH442 HH443 HH444 HH445 HH446 HH447 HH448 HH449 HH450 HH451 HH452 HH453 HH454 HH455 HH456 HH457 HH458 HH459 HH460 HH461 HH462 HH463 HH464 HH465 HH466 HH467 HH468 HH469 HH470 HH471 HH472 HH473 HH474 HH475 HH476 HH477 HH478 HH479 HH480 HH481 HH482 HH483 HH484 HH485 HH486 HH487 HH488 HH489 HH490 HH491 HH492 HH493 HH494 HH495 HH496 HH497 HH498 HH499 HH500 HH501 HH502 HH503 HH504 HH505 HH506 HH507 HH508 HH509 HH510 HH511 HH512 HH513 HH514 HH515 HH516 HH517 HH518 HH519 HH520 HH521 HH522 HH523 HH524 HH525 HH526 HH527 HH528 HH529 HH530 HH531 HH532 HH533 HH534 HH535 HH536 HH537 HH538 HH539 HH540 HH541 HH542 HH543 HH544 HH545 HH546 HH547 HH548 HH549 HH550 HH551 HH552 HH553 HH554 HH555 HH556 HH557 HH558 HH559 HH560 HH561 HH562 HH563 HH564 HH565 HH566 HH567 HH568 HH569 HH570 HH571 HH572 HH573 HH574 HH575 HH576 HH577 HH578 HH579 HH580 HH581 HH582 HH583 HH584 HH585 HH586 HH587 HH588 HH589 HH590 HH591 HH592 HH593 HH594 HH595 HH596 HH597 HH598 HH599 HH600 HH601 HH602 HH603 HH604 HH605 HH606 HH607 HH608 HH609 HH610 HH611 HH612 HH613 HH614 HH615 HH616 HH617 HH618 HH619 HH620 HH621 HH622 HH623 HH624 HH625 HH626 HH627 HH628 HH629 HH630 HH631 HH632 HH633

cls
********** No int
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

cls
********** Gender
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##i.female ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

cls
********** Gender x Land
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##i.female##i.ownland ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

cls
********** Gender x Land x Dalits
reg diff_w5_dsr ///
c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##c.w5_dsr1##i.female##i.ownland##i.dalits ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

****************************************
* END





















****************************************
* Robustness
****************************************
use"panel_indiv_v3", clear

* Selection
fre timeperiod
drop if timeperiod==.
keep if dummyloans1==1
keep if dummyloans2==1
drop if year==2020
drop if year==2010

global HH HH1 HH2 HH3 HH4 HH5 HH6 HH7 HH8 HH9 HH10 HH11 HH12 HH13 HH14 HH15 HH16 HH17 HH18 HH19 HH20 HH21 HH22 HH23 HH24 HH25 HH26 HH27 HH28 HH29 HH30 HH31 HH32 HH33 HH34 HH35 HH36 HH37 HH38 HH39 HH40 HH41 HH42 HH43 HH44 HH45 HH46 HH47 HH48 HH49 HH50 HH51 HH52 HH53 HH54 HH55 HH56 HH57 HH58 HH59 HH60 HH61 HH62 HH63 HH64 HH65 HH66 HH67 HH68 HH69 HH70 HH71 HH72 HH73 HH74 HH75 HH76 HH77 HH78 HH79 HH80 HH81 HH82 HH83 HH84 HH85 HH86 HH87 HH88 HH89 HH90 HH91 HH92 HH93 HH94 HH95 HH96 HH97 HH98 HH99 HH100 HH101 HH102 HH103 HH104 HH105 HH106 HH107 HH108 HH109 HH110 HH111 HH112 HH113 HH114 HH115 HH116 HH117 HH118 HH119 HH120 HH121 HH122 HH123 HH124 HH125 HH126 HH127 HH128 HH129 HH130 HH131 HH132 HH133 HH134 HH135 HH136 HH137 HH138 HH139 HH140 HH141 HH142 HH143 HH144 HH145 HH146 HH147 HH148 HH149 HH150 HH151 HH152 HH153 HH154 HH155 HH156 HH157 HH158 HH159 HH160 HH161 HH162 HH163 HH164 HH165 HH166 HH167 HH168 HH169 HH170 HH171 HH172 HH173 HH174 HH175 HH176 HH177 HH178 HH179 HH180 HH181 HH182 HH183 HH184 HH185 HH186 HH187 HH188 HH189 HH190 HH191 HH192 HH193 HH194 HH195 HH196 HH197 HH198 HH199 HH200 HH201 HH202 HH203 HH204 HH205 HH206 HH207 HH208 HH209 HH210 HH211 HH212 HH213 HH214 HH215 HH216 HH217 HH218 HH219 HH220 HH221 HH222 HH223 HH224 HH225 HH226 HH227 HH228 HH229 HH230 HH231 HH232 HH233 HH234 HH235 HH236 HH237 HH238 HH239 HH240 HH241 HH242 HH243 HH244 HH245 HH246 HH247 HH248 HH249 HH250 HH251 HH252 HH253 HH254 HH255 HH256 HH257 HH258 HH259 HH260 HH261 HH262 HH263 HH264 HH265 HH266 HH267 HH268 HH269 HH270 HH271 HH272 HH273 HH274 HH275 HH276 HH277 HH278 HH279 HH280 HH281 HH282 HH283 HH284 HH285 HH286 HH287 HH288 HH289 HH290 HH291 HH292 HH293 HH294 HH295 HH296 HH297 HH298 HH299 HH300 HH301 HH302 HH303 HH304 HH305 HH306 HH307 HH308 HH309 HH310 HH311 HH312 HH313 HH314 HH315 HH316 HH317 HH318 HH319 HH320 HH321 HH322 HH323 HH324 HH325 HH326 HH327 HH328 HH329 HH330 HH331 HH332 HH333 HH334 HH335 HH336 HH337 HH338 HH339 HH340 HH341 HH342 HH343 HH344 HH345 HH346 HH347 HH348 HH349 HH350 HH351 HH352 HH353 HH354 HH355 HH356 HH357 HH358 HH359 HH360 HH361 HH362 HH363 HH364 HH365 HH366 HH367 HH368 HH369 HH370 HH371 HH372 HH373 HH374 HH375 HH376 HH377 HH378 HH379 HH380 HH381 HH382 HH383 HH384 HH385 HH386 HH387 HH388 HH389 HH390 HH391 HH392 HH393 HH394 HH395 HH396 HH397 HH398 HH399 HH400 HH401 HH402 HH403 HH404 HH405 HH406 HH407 HH408 HH409 HH410 HH411 HH412 HH413 HH414 HH415 HH416 HH417 HH418 HH419 HH420 HH421 HH422 HH423 HH424 HH425 HH426 HH427 HH428 HH429 HH430 HH431 HH432 HH433 HH434 HH435 HH436 HH437 HH438 HH439 HH440 HH441 HH442 HH443 HH444 HH445 HH446 HH447 HH448 HH449 HH450 HH451 HH452 HH453 HH454 HH455 HH456 HH457 HH458 HH459 HH460 HH461 HH462 HH463 HH464 HH465 HH466 HH467 HH468 HH469 HH470 HH471 HH472 HH473 HH474 HH475 HH476 HH477 HH478 HH479 HH480 HH481 HH482 HH483 HH484 HH485 HH486 HH487 HH488 HH489 HH490 HH491 HH492 HH493 HH494 HH495 HH496 HH497 HH498 HH499 HH500 HH501 HH502 HH503 HH504 HH505 HH506 HH507 HH508 HH509 HH510 HH511 HH512 HH513 HH514 HH515 HH516 HH517 HH518 HH519 HH520 HH521 HH522 HH523 HH524 HH525 HH526 HH527 HH528 HH529 HH530 HH531 HH532 HH533 HH534 HH535 HH536 HH537 HH538 HH539 HH540 HH541 HH542 HH543 HH544 HH545 HH546 HH547 HH548 HH549 HH550 HH551 HH552 HH553 HH554 HH555 HH556 HH557 HH558 HH559 HH560 HH561 HH562 HH563 HH564 HH565 HH566 HH567 HH568 HH569 HH570 HH571 HH572 HH573 HH574 HH575 HH576 HH577 HH578 HH579 HH580 HH581 HH582 HH583 HH584 HH585 HH586 HH587 HH588 HH589 HH590 HH591 HH592 HH593 HH594 HH595 HH596 HH597 HH598 HH599 HH600 HH601 HH602 HH603 HH604 HH605 HH606 HH607 HH608 HH609 HH610 HH611 HH612 HH613 HH614 HH615 HH616 HH617 HH618 HH619 HH620 HH621 HH622 HH623 HH624 HH625 HH626 HH627 HH628 HH629 HH630 HH631 HH632 HH633


********** Winsorizing 2%
reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##i.female ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##i.female##i.ownland ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_w2_dsr ///
c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##c.w2_dsr1##i.female##i.ownland##i.dalits ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH


********** Winsorizing 1%
reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##i.female ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##i.female##i.ownland ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_w1_dsr ///
c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##c.w1_dsr1##i.female##i.ownland##i.dalits ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH



********** No winsorizing
reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1 ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1##i.female ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1##i.female##i.ownland ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

reg diff_dsr ///
c.dsr1##c.dsr1##c.dsr1##c.dsr1##i.female##i.ownland##i.dalits ///
female age age2 nonmarried ///
occ1 occ2 occ4 occ5 occ6 occ7 ///
educ2 educ3 educ4 log_saving goldquantity ///
HHsize HH_count_child ownland log_wealthbis log_income ///
dummylock dummydemonetisation dalits ///
village1 village2 village3 village4 village5 village6 village7 village8 village9 $HH

****************************************
* END











