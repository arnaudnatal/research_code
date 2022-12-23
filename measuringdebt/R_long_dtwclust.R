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
X_finindex<-as.matrix(cbind(finindex2010,finindex2016,finindex2020))
X_isr<-as.matrix(cbind(isr2010,isr2016,isr2020))
X_tdr<-as.matrix(cbind(tdr2010,tdr2016,tdr2020))
X_income<-as.matrix(cbind(dailyincome4_pc2010,dailyincome4_pc2016,dailyincome4_pc2020))
X_assets<-as.matrix(cbind(assets_total2010,assets_total2016,assets_total2020))

#--- Trends analysis clustering
interactive_clustering(X_finindex)




#--- Manually trends analysis
income_euc<-tsclust(
  series=X_income_ihs,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="mean",
  seed=4,
  trace=TRUE,
  error.check=TRUE
)

income_sbd<-tsclust(
  series=X_income_ihs,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=3,
  trace=TRUE,
  error.check=TRUE
)





assets_euc<-tsclust(
  series=X_assets_ihs,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="mean",
  seed=8,
  trace=TRUE,
  error.check=TRUE
)

assets_sbd<-tsclust(
  series=X_assets_ihs,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=5,
  trace=TRUE,
  error.check=TRUE
)




loan_euc<-tsclust(
  series=X_loan_ihs,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="mean",
  seed=2,
  trace=TRUE,
  error.check=TRUE
)

loan_sbd<-tsclust(
  series=X_loan_ihs,
  type="partitional",
  k=3,
  distance="sbd",
  centroid="pam",
  seed=2,
  trace=TRUE,
  error.check=TRUE
)





DSR_euc<-tsclust(
  series=X_DSR_ihs,
  type="partitional",
  k=5,
  distance="euclidean",
  centroid="mean",
  seed=7,
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




ISR_euc<-tsclust(
  series=X_ISR_ihs,
  type="partitional",
  k=3,
  distance="euclidean",
  centroid="mean",
  seed=1,
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




DAR_euc<-tsclust(
  series=X_DAR_ihs,
  type="partitional",
  k=4,
  distance="euclidean",
  centroid="mean",
  seed=1,
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


expenses_sbd<-tsclust(
  series=X_expenses_ihs,
  type="partitional",
  k=3,
  distance="sbd",
  centroid="pam",
  seed=3,
  trace=TRUE,
  error.check=TRUE
)



DIR_sbd<-tsclust(
  series=X_DIR_ihs,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="pam",
  seed=9,
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
