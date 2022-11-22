# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt MCA
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
data<-read.csv("debtMCA.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(lender2_cat, reason2_cat, amount))
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
