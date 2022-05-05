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
X<-as.matrix(cbind(data$cl_loanamount,data$cl_annualincome,data$cl_assets_noland,data$cl_yearly_expenses,data$caste,data$jatis,data$villageid,data$villagearea))
trend<-as.data.frame(X)
trend<-rename(trend,loan=V1)
trend<-rename(trend,income=V2)
trend<-rename(trend,assets=V3)
trend<-rename(trend,expenses=V4)
trend<-rename(trend,caste=V5)
trend<-rename(trend,jatis=V6)
trend<-rename(trend,villageid=V7)
trend<-rename(trend,villagearea=V8)

#--- Factoshiny
MCAshiny(trend)




#--- Datasets extraction
cl_annualincome<-income@cluster
cl_assets_noland<-assets@cluster
cl_yearly_expenses<-expenses@cluster

data<-cbind(data,cl_annualincome,cl_assets_noland,cl_yearly_expenses)

write.csv(data,"debttrendRreturn.csv")