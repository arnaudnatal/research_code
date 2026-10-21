*-------------------------
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*-----
*debtrollover
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to do
global dofile = "C:\Users\Arnaud\Documents\GitHub\research_code\debtrollover"

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Research\Ongoing_Rollover\Analysis"
cd"$directory"

********** Database names
global wave1 = "RUME-HH"
global wave2 = "NEEMSIS1-HH"
global wave3 = "NEEMSIS2-HH"

********** Scheme
*set scheme plotplain_v2
*grstyle init
*grstyle set plain, box nogrid

set scheme plottig
grstyle init
grstyle set plain, grid dotted box

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020