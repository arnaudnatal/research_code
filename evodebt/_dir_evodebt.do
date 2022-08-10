cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
-----
evodebt
-----
-------------------------
*/


********** Clear
clear all
macro drop _all


********** Path to do
global dofile = "C:\Users\Arnaud\Documents\GitHub\research_code\evodebt"


********** Path to data
global datapanel = "C:\Users\Arnaud\Documents\MEGA\Data\Data_ODRIIS_panel"

global datarume = "C:\Users\Arnaud\Documents\MEGA\Data\Data_RUME\DATA\CLEAN"
global dataneemsis1 = "C:\Users\Arnaud\Documents\MEGA\Data\Data_NEEMSIS1\DATA\CLEAN"
global dataneemsis2 = "C:\Users\Arnaud\Documents\MEGA\Data\Data_NEEMSIS2\DATA\CLEAN"

global datatracking1 = "C:\Users\Arnaud\Documents\MEGA\Data\Data_Tracking2019\DATA\CLEAN"
global datatracking2 = "C:\Users\Arnaud\Documents\MEGA\Data\Data_Tracking2022\DATA\CLEAN"


********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Thesis\Thesis_Debt\Analysis"
cd"$directory"


********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid


********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020
