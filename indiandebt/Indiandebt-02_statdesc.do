*-------------------------
cls
*Arnaud NATAL
*arnaud.natal@ifpindia.org
*June 6, 2026
*-----
gl link = "indiandebt"
*Stat desc
*-----
*do"C:/Users/Arnaud/Documents/GitHub/folderanalysis/$link.do"
cd"C:\Users\anatal\Documents\id"
*-------------------------












cls

****************************************
* Stat desc
****************************************
use"Loans_v2", replace

* How many loans?
ta year

* How many households?
preserve
keep HHID year
duplicates drop
ta year
restore

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

* Security
ta security year
ta security year, col nofreq

* Amount
ta catamount year
ta catamount year, col nofreq

* Reason x Lender
egen reasonlender=group(reason lender), label
ta reasonlender year, col nofreq

* Amount by reason
*tabstat amount if year==1992, stat(mean) by(reason)
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
