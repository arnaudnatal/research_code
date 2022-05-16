# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis
# April 28, 2022

#--- Introduction
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/Analysis/Overindebtedness")

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
library(RStata)

#--- Open datasets
data<-read.csv("dt_loanamount.csv")
attach(data)

#--- Matrix
X<-as.matrix(cbind(rel_var1, rel_var2, rel_var3))

#--- Clustering
interactive_clustering(X)

#--- Groups creation
# assets<-tsclust(
#   series=X_assets_log,
#   type="partitional",
#   k=4,
#   distance="sbd",
#   centroid="median",
#   seed=7,
#   trace=TRUE,
#   error.check=TRUE
# )

#--- Groups exportation
# cl_annualincome<-income@cluster
# data<-cbind(data,cl_annualincome,cl_assets_noland,cl_yearly_expenses)
# write.csv(data,"dt_informal_v2.csv")