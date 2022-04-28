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


#--- Open packages
library(tidyr)
library(dtwclust)
library(dplyr)
library(ggplot2)


#--- Open datasets
data<-read.csv("debttrend.csv")
attach(data)

#--- Matrices creation
X_loan<-as.matrix(cbind(loanstd1,loanstd2,loanstd3))
X_income<-as.matrix(cbind(incomestd1,incomestd2,incomestd3))
X_assets<-as.matrix(cbind(assetsstd1,assetsstd2,assetsstd3))
X_expenses<-as.matrix(cbind(expensesstd1,expensesstd2,expensesstd3))
X_DSR<-as.matrix(cbind(DSRstd1,DSRstd2,DSRstd3))
X_DIR<-as.matrix(cbind(DIRstd1,DIRstd2,DIRstd3))
X_DAR<-as.matrix(cbind(DARstd1,DARstd2,DARstd3))
X_ISR<-as.matrix(cbind(ISRstd1,ISRstd2,ISRstd3))


#--- Trends analysis clustering
interactive_clustering(X_loan)
interactive_clustering(X_income)
interactive_clustering(X_DSR)