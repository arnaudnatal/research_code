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
interactive_clustering(index)




#--- Manually trends analysis
clustseed1<-tsclust(
  series=index,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="pam",
  seed=6,
  trace=TRUE,
  error.check=TRUE
)

clustseed2<-tsclust(
  series=index,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="pam",
  seed=14,
  trace=TRUE,
  error.check=TRUE
)

clustseed3<-tsclust(
  series=index,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="pam",
  seed=15,
  trace=TRUE,
  error.check=TRUE
)

clustseed4<-tsclust(
  series=index,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="pam",
  seed=24,
  trace=TRUE,
  error.check=TRUE
)




#--- Datasets extraction
cluster1<-clustseed1@cluster
cluster2<-clustseed2@cluster
cluster3<-clustseed3@cluster
cluster4<-clustseed4@cluster




#--- Step2
data<-cbind(data, cluster1, cluster2, cluster3, cluster4)

write.csv(data,"indextrend.csv")
