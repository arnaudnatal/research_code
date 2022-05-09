# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: classification of trends
# May 3, 2022



#--- Introduction
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/Analysis/Overindebtedness")



#--- Install packages
# install.packages("Factoshiny", dependencies = TRUE)



#--- Open packages
library(Factoshiny)
library(tidyverse)


#--- Open datasets
data<-read.csv("debttrend_v3.csv")



#--- Matrices creation
X<-as.matrix(cbind(data$cl_loanamount, data$cl_annualincome, data$cl_assets_noland))#, data$cl_yearly_expenses, data$caste, data$jatis, data$villageid, data$villagearea, data$head_edulevel2010, data$head_occupation2010, data$wifehusb_edulevel2010, data$wifehusb_occupation2010, data$mainocc_occupation2010, data$cat_income, data$cat_assets, data$dummyownland2010, data$DSR302010, data$DSR402010, data$DSR502010, data$path_30, data$path_40, data$path_50))

trend<-as.data.frame(X)

trend<-rename(trend, loan=V1)
trend<-rename(trend, income=V2)
trend<-rename(trend, assets=V3)
# trend<-rename(trend, expenses=V4)
# trend<-rename(trend, caste=V5)
# trend<-rename(trend, jatis=V6)
# trend<-rename(trend, villageid=V7)
# trend<-rename(trend, villagearea=V8)
# trend<-rename(trend, head_edu=V9)
# trend<-rename(trend, head_occupation=V10)
# trend<-rename(trend, wife_edu=V11)
# trend<-rename(trend, wife_occupation=V12)
# trend<-rename(trend, occupation=V13)
# trend<-rename(trend, cat_income=V14)
# trend<-rename(trend, cat_assets=V15)
# trend<-rename(trend, dummyownland=V16)
# trend<-rename(trend, DSR30=V17)
# trend<-rename(trend, DSR40=V18)
# trend<-rename(trend, DSR50=V19)
# trend<-rename(trend, path30=V20)
# trend<-rename(trend, path40=V21)
# trend<-rename(trend, path50=V22)



#--- Factoshiny
MCAshiny(trend)




#--- Datasets extraction
cl_annualincome<-income@cluster
cl_assets_noland<-assets@cluster
cl_yearly_expenses<-expenses@cluster

data<-cbind(data,cl_annualincome,cl_assets_noland,cl_yearly_expenses)

write.csv(data,"debttrendRreturn.csv")