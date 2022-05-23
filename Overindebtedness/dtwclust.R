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
attach(data)



#--- Matrices creation

X_loan_ihs<-as.matrix(cbind(ihs_loanamount1,ihs_loanamount2,ihs_loanamount3))
X_income_ihs<-as.matrix(cbind(ihs_annualincome1,ihs_annualincome2,ihs_annualincome3))
X_assets_ihs<-as.matrix(cbind(ihs_assets_noland1,ihs_assets_noland2,ihs_assets_noland3))
X_expenses_ihs<-as.matrix(cbind(ihs_yearly_expenses1, ihs_yearly_expenses2, ihs_yearly_expenses3))
X_DSR_ihs<-as.matrix(cbind(ihs_DSR1,ihs_DSR2,ihs_DSR3))
X_DAR_ihs<-as.matrix(cbind(ihs_DAR1,ihs_DAR2,ihs_DAR3))
X_ISR_ihs<-as.matrix(cbind(ihs_ISR1,ihs_ISR2,ihs_ISR3))

# X_info_rel<-as.matrix(cbind(rel_informal1, rel_informal2, rel_informal3))
# X_form_rel<-as.matrix(cbind(rel_formal1, rel_formal2, rel_formal3))
# X_econ_rel<-as.matrix(cbind(rel_eco1, rel_eco2, rel_eco3))
# X_curr_rel<-as.matrix(cbind(rel_current1, rel_current2, rel_current3))
# X_huma_rel<-as.matrix(cbind(rel_humank1, rel_humank2, rel_humank3))
# X_soci_rel<-as.matrix(cbind(rel_social1, rel_social2, rel_social3))
# X_home_rel<-as.matrix(cbind(rel_home1, rel_home2, rel_home3))
# X_repa_rel<-as.matrix(cbind(rel_repay1, rel_repay2, rel_repay3))
# 
# X_loan<-as.matrix(cbind(loanamount1,loanamount2,loanamount3))
# X_income<-as.matrix(cbind(annualincome1,annualincome2,annualincome3))
# X_assets<-as.matrix(cbind(assets_noland1,assets_noland2,assets_noland3))
# X_expenses<-as.matrix(cbind(yearly_expenses1, yearly_expenses2,yearly_expenses3))
# X_DSR<-as.matrix(cbind(DSR1,ihs_DSR2,DSR3))
# X_DAR<-as.matrix(cbind(DAR1,ihs_DAR2,DAR3))
# X_ISR<-as.matrix(cbind(ISR1,ihs_ISR2,ISR3))



#--- Trends analysis clustering
# interactive_clustering(X_income_ihs)
# interactive_clustering(X_assets_ihs)
# interactive_clustering(X_loan_ihs)
# interactive_clustering(X_DSR_ihs)
# interactive_clustering(X_ISR_ihs)
# interactive_clustering(X_DAR_ihs)


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


data<-cbind(data, euc_annualincome, sbd_annualincome, euc_assets_noland, sbd_assets_noland, euc_loanamount, sbd_loanamount, euc_DSR, sbd_DSR, euc_ISR, sbd_ISR, euc_DAR, sbd_DAR)

write.csv(data,"debttrend_v2.csv")
