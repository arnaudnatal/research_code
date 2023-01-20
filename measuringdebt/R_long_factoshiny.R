# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: classification of trends
# May 3, 2022


#--- Introduction
# .rs.restartR()
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/measuringdebt")


#--- Install packages
# install.packages("Factoshiny", dependencies = TRUE)


#--- Open packages
library(Factoshiny)
library(tidyverse)


#--- Open datasets
data<-read.csv("pca.csv")


#--- Matrices creation
attach(data)

X<-as.matrix(cbind(dar_std, dsr_std, rfm_std, tdr_std, dailyincome_pc_std, assets_pc_std, lpc_std))
#X<-as.matrix(cbind(dar_std, dsr_std, rfm_std, tdr_std, lpc_std))
debt<-as.data.frame(X)


detach(data)
attach(debt)



#--- Factoshiny
PCAshiny(debt)


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