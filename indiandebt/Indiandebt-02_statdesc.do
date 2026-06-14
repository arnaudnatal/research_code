*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*Stat desc
*-----
do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
*-------------------------














****************************************
* Stat desc
****************************************
use"Loans_v2", replace

* Reason
ta reason year
ta reason year, col nofreq

* Lender
ta lender year
ta lender year, col nofreq

* Scheme
ta scheme year
ta scheme year, col nofreq

* Duration
ta duration year
ta duration year, col nofreq

* Interest
ta interest year
ta interest year, col nofreq

* Amount
ta catamount year
ta catamount year, col nofreq

* Amount by reason
tabstat amount if year==1992, stat(mean) by(reason)
tabstat amount if year==2002, stat(mean) by(reason)
tabstat amount if year==2012, stat(mean) by(reason)
tabstat amount if year==2019, stat(mean) by(reason)

* Amount by lender
tabstat amount if year==1992, stat(mean) by(lender)
tabstat amount if year==2002, stat(mean) by(lender)
tabstat amount if year==2012, stat(mean) by(lender)
tabstat amount if year==2019, stat(mean) by(lender)

****************************************
* END
