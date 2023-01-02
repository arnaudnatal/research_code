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
pcaindex<-as.matrix(cbind(pca2index2010, pca2index2016, pca2index2020))
mindex<-as.matrix(cbind(m2index2010, m2index2016, m2index2020))


#--- Trends analysis clustering
interactive_clustering(pcaindex)
interactive_clustering(mindex)




#--- Manually trends analysis
pca_clust<-tsclust(
  series=pcaindex,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=11,
  trace=TRUE,
  error.check=TRUE
)

m_clust<-tsclust(
  series=mindex,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=5,
  trace=TRUE,
  error.check=TRUE
)





#--- Datasets extraction
pca_cluster<-pca_clust@cluster
m_cluster<-m_clust@cluster




#--- Step2
data<-cbind(data, pca_cluster, m_cluster)

write.csv(data,"indextrend.csv")
