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
data<-read.csv("debttrend.csv")
df.labels<-data$panelvar
data$panelvar<-NULL
attach(data)

#--- Matrices creation
X_loan<-as.matrix(cbind(loan1,loan2,loan3))
X_income<-as.matrix(cbind(income1,income2,income3))
X_assets<-as.matrix(cbind(assets1,assetd2,assets3))
X_DSR<-as.matrix(cbind(DSR1,DSR2,DSR3))
X_expenses<-as.matrix(cbind(expenses1,expenses2,expenses3))
X_DIR<-as.matrix(cbind(DIR1,DIR2,DIR3))
X_DAR<-as.matrix(cbind(DAR1,DAR2,DAR3))
X_ISR<-as.matrix(cbind(ISR1,ISR2,ISR3))


#--- Trends analysis clustering
#interactive_clustering(X_loan)
#interactive_clustering(X_income)
interactive_clustering(X_DSR)


#--- Manually trends analysis clustering 1
clsbd<-tsclust(
  series=X_loan,
  type="partitional",
  k=6,
  distance="sbd",
  centroid="shape",
  seed=1,
  trace=TRUE,
  error.check=TRUE
  )

cldtw<-tsclust(
  series=X_loan,
  type="partitional",
  k=6,
  distance="dtw",
  centroid="dba",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)



#--- Datasets extraction
clustersbd<-clsbd@cluster
data<-cbind(data,clustersbd)

clusterdtw<-cldtw@cluster
data<-cbind(data,clusterdtw)

write.csv(data,"debttrendRreturn.csv")


#--- Stata graph
options("RStata.StataPath" = "C:/Users/Arnaud/Documents/Software/Stata15/StataMP-64")
options("RStata.StataVersion" = 15.1)

stata("linegraph.do")