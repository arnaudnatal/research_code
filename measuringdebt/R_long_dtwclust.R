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
clustseed5<-tsclust(
  series=index,
  type="partitional",
  k=6,
  distance="euclidean",
  centroid="pam",
  seed=5,
  trace=TRUE,
  error.check=TRUE
)

clustseed6<-tsclust(
  series=index,
  type="partitional",
  k=6,
  distance="euclidean",
  centroid="pam",
  seed=6,
  trace=TRUE,
  error.check=TRUE
)

clustseed7<-tsclust(
  series=index,
  type="partitional",
  k=6,
  distance="euclidean",
  centroid="pam",
  seed=7,
  trace=TRUE,
  error.check=TRUE
)






#--- Datasets extraction
clusts5<-clustseed5@cluster
clusts6<-clustseed6@cluster
clusts7<-clustseed7@cluster




#--- Step2
data<-cbind(data, clusts5, clusts6, clusts7)

write.csv(data,"indextrend.csv")
