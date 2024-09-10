# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Ineq trend analysis
# August 3, 2024



#--- Introduction
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Assetsinequalities/Analysis")



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
data<-read.csv("index.csv")
attach(data)



#--- Matrices creation
index<-as.matrix(cbind(index2010, index2016, index2020))



#--- Trends analysis clustering
interactive_clustering(index)




#--- Manually trends analysis
clustseed1<-tsclust(
  series=index,
  type="partitional",
  k=7,
  distance="euclidean",
  centroid="pam",
  seed=3,
  trace=TRUE,
  error.check=TRUE
)

clustseed2<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=4,
  trace=TRUE,
  error.check=TRUE
)

clustseed3<-tsclust(
  series=index,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="pam",
  seed=23,
  trace=TRUE,
  error.check=TRUE
)



#--- Datasets extraction
cluster1<-clustseed1@cluster
cluster2<-clustseed2@cluster
cluster3<-clustseed3@cluster


#--- Step2
data<-cbind(data, cluster1, cluster2, cluster3)

write.csv(data,"indextrend.csv")
