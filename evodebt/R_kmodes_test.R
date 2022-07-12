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
# install.packages("klaR", dependencies = TRUE)
# install.pcakages("cluster", dependencies = TRUE)

#--- Open packages
library(tidyverse)
library(klaR)
library(cluster)

#--- Open datasets
data<-read.csv("shortdebttrend_v1.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(cat_assets_b_1, cat_assets_b_2, cat_assets_b_3, cat_DAR_b_1, cat_DAR_b_2, cat_DAR_b_3, cat_DSR_b_1, cat_DSR_b_2, cat_DSR_b_3, cat_income_b_1, cat_income_b_2, cat_income_b_3))


trend<-as.data.frame(X)

detach(data)
attach(trend)


#--- Hierarchical Ascendant
d_dist<-daisy(trend, metric = "gower")
hc<-hclust(d_dist, method = "ward.D2") 
plot(hc, labels=FALSE)
rect.hclust(hc, k=3, border="red")
cluster<-cutree(hc, k=3)
data<-cbind(trend,cluster)
trend<-cbind(trend,cluster)
table(data$cluster)


#--- Kmodes
#res.kmodes<-kmodes(trend,cluster,iter.max=500,weighted=FALSE,fast=TRUE)
#res.kmodes<-kmodes(trend,3,iter.max=500,weighted=FALSE,fast=TRUE)
#kclust<-res.kmodes$cluster
#data<-cbind(data,kclust)
#inertia<-cbind(inert)
#table(data$kclust)
inertia<-cbind(inert)

table(vulnerable$clust)

write.csv(data,"shortdebttrend_v2.csv")
#write.csv(inertia,"inertia.csv")