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
# install.packages("clusterSim", dependencies = TRUE)

#--- Open packages
library(Factoshiny)
library(tidyverse)
library(clusterSim)

#--- Open datasets
data<-read.csv("pca.csv")


#--- Matrices creation
attach(data)

X<-as.matrix(cbind(dailyincome_pc_std, assets_pc_std, dsr_std, dar_std, afm_std, tdr_std, lapc_std))
debt<-as.data.frame(X)

detach(data)
attach(debt)

#--- Factoshiny
#PCAshiny(debt)


#--- HCPC
res.PCA<-PCA(debt,ncp=4,graph=FALSE)
res.HCPC<-HCPC(res.PCA,nb.clust=4,consol=FALSE,graph=FALSE)



#--- Datasets extraction
vulnerable<-res.HCPC$data.clust
data<-cbind(data,vulnerable)
inertia<-cbind(inert)

table(vulnerable$clust)

write.csv(data,"debttrend_v4.csv")
write.csv(inertia,"inertia.csv")