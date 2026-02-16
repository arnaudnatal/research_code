# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis
# December 23, 2022



#--- Introduction
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/measuringdebt")



#--- Install packages
# install.packages("tidyr", dependencies = TRUE)
# install.packages("dtwclust", dependencies = TRUE)
# install.packages("dplyr", dependencies = TRUE)
# install.packages('RStata')



#--- Open packages
library(tidyr)
library(dtwclust)
library(dplyr)
library(ggplot2)
# library(RStata)



#--- Open datasets
data<-read.csv("debtnew.csv")
attach(data)



#--- Matrices creation
index<-as.matrix(cbind(index2010, index2016, index2020))



#--- Trends analysis clustering
#interactive_clustering(index)




#--- Manually trends analysis
clustseed1<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=2,
  trace=TRUE,
  error.check=TRUE
)

clustseed2<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=3,
  trace=TRUE,
  error.check=TRUE
)

clustseed3<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=4,
  trace=TRUE,
  error.check=TRUE
)

clustseed4<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=12,
  trace=TRUE,
  error.check=TRUE
)


clustseed5<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=13,
  trace=TRUE,
  error.check=TRUE
)


clustseed6<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=14,
  trace=TRUE,
  error.check=TRUE
)



#--- Datasets extraction
cluster1<-clustseed1@cluster
cluster2<-clustseed2@cluster
cluster3<-clustseed3@cluster
cluster4<-clustseed4@cluster
cluster5<-clustseed5@cluster
cluster6<-clustseed6@cluster


#--- Step2
data<-cbind(data, cluster1, cluster2, cluster3, cluster4, cluster5, cluster6)

write.csv(data,"indextrend.csv")
