# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: classification of trends
# May 3, 2022



#--- Introduction
#.rs.restartR()
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
X<-as.matrix(cbind(data$sbd_dsr,data$sbd_dar,data$sbd_annualincome,data$sbd_assets_noland,data$sbd_loanamount))

trend<-as.data.frame(X)

trend<-rename(trend, dsr=V1)
trend<-rename(trend, dar=V2)
trend<-rename(trend, income=V3)
trend<-rename(trend, assets=V4)
trend<-rename(trend, debt=V5)


#--- Factoshiny
MCAshiny(trend)


#--- Datasets extraction
cl_annualincome<-income@cluster
cl_assets_noland<-assets@cluster
cl_yearly_expenses<-expenses@cluster

data<-cbind(data,cl_annualincome,cl_assets_noland,cl_yearly_expenses)

write.csv(data,"debttrendRreturn.csv")