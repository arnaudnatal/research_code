# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: v2
# June 22, 2022


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
data<-read.csv("pca_cross.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(std_assets, std_DAR, std_DSR, std_income))


trend<-as.data.frame(X)

detach(data)
attach(trend)

# trend<-rename(trend, dsr=V1)


#--- Factoshiny
Factoshiny(trend)


#--- HCPC
res.PCA<-PCA(trend,ncp=2,graph=FALSE)
res.HCPC<-HCPC(res.PCA,nb.clust=2,consol=TRUE,graph=FALSE)

inert<-res.HCPC[["call"]][["t"]][["inert.gain"]]


#--- Datasets extraction
vulnerable<-res.HCPC$data.clust
data<-cbind(data,vulnerable)
inertia<-cbind(inert)

table(vulnerable$clust)


write.csv(data,"")
#write.csv(inertia,"inertia.csv")