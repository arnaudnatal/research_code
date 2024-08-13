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
* Inter-HH
****************************************
use"panel_v6", clear

* Lorenz curve
preserve
keep HHID_panel year income
reshape wide income, i(HHID_panel) j(year)

lorenz estimate income2010 income2016 income2020, gini
lorenz graph, noci overlay legend(pos(6) col(3) order(2 "2010" 3 "2016-17" 4 "2020-21")) xtitle("Population share") ytitle("Cumulative annual income proportion") xlabel(0(10)100) ylabel(0(.1)1)
restore


* Decomposition Gini by income source
descogini income 
descogini income income_agriself income_agricasu income_casual income_regnonqu income_regquali income_selfempl income_nrega


/*
Share = part de la composition dans l'inégalité totale
X% de l'inegalité totale est liée au XXXX
On compare ca avec Sk
on voit que Sk pour agri = 0.39 donc Sk pour non agri = 0.61
on voit donc que la part dans l'inéga est sup à celle du rev donc
la composante rev non agri est inégalisatrice

si le rev agri augmente de 1% le Gini va baisser de 11% 
% change s'interprete comme une élasticité donc c'est surtout le signe
qui importe, si + alors inégalisatrice si - égalisatrice

*/

****************************************
* END














****************************************
* Intra-HH
****************************************
cls
use"panel_v5", clear

* Desc
*foreach y in sharewomen absdiffshare {
foreach y in absdiffshare {
tabstat `y', stat(n mean q) by(year)

* By caste
tabstat `y' if caste==1, stat(n mean q) by(year)
tabstat `y' if caste==2, stat(n mean q) by(year)
tabstat `y' if caste==3, stat(n mean q) by(year)

* By poor
tabstat `y' if poor_HH==0, stat(n mean q) by(year)
tabstat `y' if poor_HH==1, stat(n mean q) by(year)

* By assets
tabstat `y' if assets_cat==1, stat(n mean q) by(year)
tabstat `y' if assets_cat==2, stat(n mean q) by(year)
tabstat `y' if assets_cat==3, stat(n mean q) by(year)

* By income
tabstat `y' if income_cat==1, stat(n mean q) by(year)
tabstat `y' if income_cat==2, stat(n mean q) by(year)
tabstat `y' if income_cat==3, stat(n mean q) by(year)
}


* absdiffshare
stripplot absdiffshare, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
xmtick(0(.1)1) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("Relative differences of income") ytitle("") ///
title("Total") name(c0, replace)


* sharewomen
stripplot sharewomen, over(time) ///
stack width(0.01) jitter(1) refline(lp(dash)) ///
box(barw(0.1)) boffset(-0.15) pctile(5) ///
ms(oh oh oh) msize(small) mc(black%30) ///
xla(0(.1)1, ang(h)) yla(, noticks) ///
xmtick(0(.1)1) ///
legend(order(1 "Mean" 4 "Whisker from 5% to 95%") pos(6) col(2) on) ///
xtitle("Share women") ytitle("") ///
title("Total") name(c0, replace)



****************************************
* END


