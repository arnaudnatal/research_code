# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: v2
# June 16, 2022


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
data<-read.csv("debttrend_new_v1.csv")


#--- Matrices creation
attach(data)
X1<-as.matrix(cbind(cat1_assets, cat1_DAR, cat1_DSR))
X2<-as.matrix(cbind(catb1_assets, catb1_DAR, catb1_DSR))


trend<-as.data.frame(X2)

detach(data)
attach(trend)

# trend<-rename(trend, dsr=V1)


#--- Factoshiny
 MCAshiny(trend)


#--- MCA


#--- HCPC



inert<-res.HCPC[["call"]][["t"]][["inert.gain"]]


#--- Datasets extraction
vulnerable<-res.HCPC$data.clust
data<-cbind(data,vulnerable)
inertia<-cbind(inert)

table(vulnerable$clust)

write.csv(data,"debttrend_v4.csv")
write.csv(inertia,"inertia.csv")