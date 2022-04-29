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
X_loan<-as.matrix(cbind(loanamount1,loanamount2,loanamount3))
X_loan_cro<-as.matrix(cbind(cro_loanamount1,cro_loanamount2,cro_loanamount3))
X_loan_ihs<-as.matrix(cbind(ihs_loanamount1,ihs_loanamount2,ihs_loanamount3))
X_loan_log<-as.matrix(cbind(log_loanamount1,log_loanamount2,log_loanamount3))

#X_income<-as.matrix(cbind(income1,income2,income3))
#X_assets<-as.matrix(cbind(assets1,assets2,assets3))
#X_DSR<-as.matrix(cbind(DSR1,DSR2,DSR3))
#X_expenses<-as.matrix(cbind(expenses1,expenses2,expenses3))
#X_DIR<-as.matrix(cbind(DIR1,DIR2,DIR3))
#X_DAR<-as.matrix(cbind(DAR1,DAR2,DAR3))
#X_ISR<-as.matrix(cbind(ISR1,ISR2,ISR3))


#--- Trends analysis clustering
interactive_clustering(X_loan)
interactive_clustering(X_loan_cro)
interactive_clustering(X_loan_ihs)
interactive_clustering(X_loan_log)
#interactive_clustering(X_income)
#interactive_clustering(X_assets)
#interactive_clustering(X_DSR)
#interactive_clustering(X_DAR)
#interactive_clustering(X_expenses)


#--- Manually trends analysis: loan
loan_sbd<-tsclust(
  series=X_loan,
  type="partitional",
  k=6,
  distance="sbd",
  centroid="mean",
  seed=1,
  trace=TRUE,
  error.check=TRUE
  )

# loan_dtw<-tsclust(
#   series=X_loan,
#   type="partitional",
#   k=4,
#   distance="dtw",
#   centroid="dba",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )


#--- Manually trends analysis: income
income_sbd<-tsclust(
  series=X_income,
  type="partitional",
  k=7,
  distance="sbd",
  centroid="mean",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

# income_dtw<-tsclust(
#   series=X_income,
#   type="partitional",
#   k=5,
#   distance="dtw",
#   centroid="dba",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )


#--- Manually trends analysis: assets
assets_sbd<-tsclust(
  series=X_assets,
  type="partitional",
  k=6,
  distance="sbd",
  centroid="mean",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

# assets_dtw<-tsclust(
#   series=X_assets,
#   type="partitional",
#   k=5,
#   distance="dtw",
#   centroid="dba",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )


#--- Manually trends analysis: DSR
DSR_sbd<-tsclust(
  series=X_DSR,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="mean",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

# DSR_dtw<-tsclust(
#   series=X_DSR,
#   type="partitional",
#   k=7,
#   distance="dtw",
#   centroid="dba",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )


#--- Manually trends analysis: DAR
DAR_sbd<-tsclust(
  series=X_DAR,
  type="partitional",
  k=7,
  distance="sbd",
  centroid="mean",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

# DAR_dtw<-tsclust(
#   series=X_DAR,
#   type="partitional",
#   k=5,
#   distance="dtw",
#   centroid="dba",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )


#--- Manually trends analysis: expenses
expenses_sbd<-tsclust(
  series=X_expenses,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="mean",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

# expenses_dtw<-tsclust(
#   series=X_expenses,
#   type="partitional",
#   k=5,
#   distance="dtw",
#   centroid="dba",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )


#--- Datasets extraction
cl_loan_sbd<-loan_sbd@cluster
cl_income_sbd<-income_sbd@cluster
cl_assets_sbd<-assets_sbd@cluster
cl_DSR_sbd<-DSR_sbd@cluster
cl_DAR_sbd<-DAR_sbd@cluster
cl_expenses_sbd<-expenses_sbd@cluster

# cl_loan_dtw<-loan_dtw@cluster
# cl_income_dtw<-income_dtw@cluster
# cl_assets_dtw<-assets_dtw@cluster
# cl_DSR_dtw<-DSR_dtw@cluster
# cl_DAR_dtw<-DAR_dtw@cluster
# cl_expenses_dtw<-expenses_dtw@cluster

data<-cbind(data,cl_loan_sbd,cl_income_sbd,cl_assets_sbd,cl_DSR_sbd,cl_DAR_sbd,cl_expenses_sbd)

# data<-cbind(data,cl_loan_dtw,cl_income_dtw,cl_assets_dtw,cl_DSR_dtw,cl_DAR_dtw,cl_expenses_dtw)


write.csv(data,"debttrendRreturn.csv")




#--- Stata graph
#options("RStata.StataPath" = "C:/Users/Arnaud/Documents/Software/Stata15/StataMP-64")
#options("RStata.StataVersion" = 15.1)
#stata("linegraph.do")





#--- Manual testing
# loan_sbd<-tsclust(
#   series=X_loan,
#   type="partitional",
#   k=2,
#   distance="sbd",
#   centroid="shape",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )
# 
# loan_sbdmean<-tsclust(
#   series=X_loan,
#   type="partitional",
#   k=2,
#   distance="sbd",
#   centroid="mean",
#   seed=1,
#   trace=TRUE,
#   error.check=TRUE
# )
# 
# 
# cl_loan_sbdshape<-loan_sbd@cluster
# cl_loan_sbdmean<-loan_sbdmean@cluster
# 
# 
# data<-cbind(data,cl_loan_sbdshape,cl_loan_sbdmean)
# 
# write.csv(data,"debttrendRreturn.csv")