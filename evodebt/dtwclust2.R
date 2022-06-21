# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis
# April 28, 2022



#--- Introduction
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/evodebt")



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
data<-read.csv("debttrend_new_v2.csv")
attach(data)



#--- Matrices creation

X_assets<-as.matrix(cbind(ihs_assets_1,ihs_assets_2))
X_income<-as.matrix(cbind(ihs_income_1,ihs_income_2))
X_DSR<-as.matrix(cbind(ihs_DSR_1,ihs_DSR_2))
X_DAR<-as.matrix(cbind(ihs_DAR_1,ihs_DAR_2))


#--- Trends analysis clustering
#interactive_clustering(X_assets)
interactive_clustering(X_income)
interactive_clustering(X_DSR)
interactive_clustering(X_DAR)



#--- Manually trends analysis
income_sbd<-tsclust(
  series=X_income_ihs,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

assets_sbd<-tsclust(
  series=X_assets_ihs,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

DSR_sbd<-tsclust(
  series=X_DSR_ihs,
  type="partitional",
  k=5,
  distance="sbd",
  centroid="pam",
  seed=2,
  trace=TRUE,
  error.check=TRUE
)

ISR_sbd<-tsclust(
  series=X_ISR_ihs,
  type="partitional",
  k=5,
  distance="sbd",
  centroid="pam",
  seed=16,
  trace=TRUE,
  error.check=TRUE
)

DAR_sbd<-tsclust(
  series=X_DAR_ihs,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=2,
  trace=TRUE,
  error.check=TRUE
)



#--- Datasets extraction
euc_annualincome<-income_euc@cluster
sbd_annualincome<-income_sbd@cluster

euc_assets_noland<-assets_euc@cluster
sbd_assets_noland<-assets_sbd@cluster

euc_loanamount<-loan_euc@cluster
sbd_loanamount<-loan_sbd@cluster

euc_DSR<-DSR_euc@cluster
sbd_DSR<-DSR_sbd@cluster

euc_ISR<-ISR_euc@cluster
sbd_ISR<-ISR_sbd@cluster

euc_DAR<-DAR_euc@cluster
sbd_DAR<-DAR_sbd@cluster

sbd_expenses<-expenses_sbd@cluster

sbd_DIR<-DIR_sbd@cluster

#--- Step2
data<-cbind(data, euc_annualincome, sbd_annualincome, euc_assets_noland, sbd_assets_noland, euc_loanamount, sbd_loanamount, euc_DSR, sbd_DSR, euc_ISR, sbd_ISR, euc_DAR, sbd_DAR, sbd_expenses, sbd_DIR)

write.csv(data,"debttrend_v2.csv")
