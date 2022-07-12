# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: classification of trends
# May 3, 2022


#--- Introduction
# .rs.restartR()
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/evodebt")


#--- Install packages
# install.packages("Factoshiny", dependencies = TRUE)


#--- Open packages
library(Factoshiny)
library(tidyverse)


#--- Open datasets
data<-read.csv("debttrend_v3.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(sbd_dsr,sbd_dar,sbd_assets_noland))#,sbd_annualincome, sbd_dir, sbd_expenses))
# X<-as.matrix(cbind(sbd_dar,sbd_assets_noland,sbd_annualincome, sbd_dsr))
trend<-as.data.frame(X)

detach(data)
attach(trend)

# trend<-rename(trend, dsr=V1)


#--- Factoshiny
 MCAshiny(trend)


#--- MCA
res.MCA<-MCA(trend,ncp=4,graph=FALSE)


#--- HCPC
res.HCPC<-HCPC(res.MCA,nb.clust=5,consol=TRUE,graph=FALSE)


inert<-res.HCPC[["call"]][["t"]][["inert.gain"]]


#--- Datasets extraction
vulnerable<-res.HCPC$data.clust
data<-cbind(data,vulnerable)
inertia<-cbind(inert)

table(vulnerable$clust)

write.csv(data,"debttrend_v4.csv")
write.csv(inertia,"inertia.csv")