# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt CA
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
data<-read.csv("debtCA.csv")



#--- Factoshiny
CAshiny(data)


#--- HCPC
res.CA<-CA(data,ncp=2,quali.sup=c(1),graph=FALSE)
res.HCPC<-HCPC(res.CA,nb.clust=3,consol=FALSE,graph=FALSE)


#--- Extraction
res.CA[["row"]][["coord"]]
res.CA[["row"]][["contrib"]]

res.CA[["col"]][["coord"]]
res.CA[["col"]][["contrib"]]


row_coord<-res.CA[["row"]][["coord"]]
row_contrib<-res.CA[["row"]][["contrib"]]
row_cos2<-res.CA[["row"]][["cos2"]]
row_inertia<-res.CA[["row"]][["inertia"]]

col_coord<-res.CA[["col"]][["coord"]]
col_contrib<-res.CA[["col"]][["contrib"]]
col_cos2<-res.CA[["col"]][["cos2"]]
col_inertia<-res.CA[["col"]][["inertia"]]


#--- Write
write.csv(row_coord,"resCA.csv")