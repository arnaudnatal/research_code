# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt PCA
# November 22, 2022



#--- Introduction
# .rs.restartR()
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/MEGA/Thesis/Thesis_Measuring_debt/Analysis")


#--- Install packages
# install.packages("Factoshiny", dependencies = TRUE)


#--- Open packages
library(Factoshiny)
library(tidyverse)


#--- Open datasets
data<-read.csv("debtPCA.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(imp1_is_tot_HH, ))
subdata<-as.data.frame(X)
detach(data)
attach(subdata)




#--- Factoshiny
Factoshiny(subdata)


#--- HCPC
res.MCA<-MCA(subdata,ncp=5,graph=FALSE)
res.HCPC<-HCPC(res.MCA,nb.clust=4,consol=TRUE,graph=FALSE)


inert<-res.HCPC[["call"]][["t"]][["inert.gain"]]


#--- Datasets extraction
vulnerable<-res.HCPC$data.clust
data<-cbind(data,vulnerable)
inertia<-cbind(inert)

table(vulnerable$clust)

write.csv(data,"debtMCA_grp.csv")
#write.csv(inertia,"inertia.csv")


mcacoord<-res.MCA$ind
data<-cbind(data,mcacoord)
