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
X_loan_log<-as.matrix(cbind(log_loanamount1,log_loanamount2,log_loanamount3))
X_income_log<-as.matrix(cbind(log_annualincome1,log_annualincome2,log_annualincome3))
X_assets_log<-as.matrix(cbind(log_assets_noland1,log_assets_noland2,log_assets_noland3))
X_assets2_log<-as.matrix(cbind(log_assets1,log_assets2,log_assets3))
X_expenses_log<-as.matrix(cbind(log_yearly_expenses1,log_yearly_expenses2,log_yearly_expenses3))

# X_loan<-as.matrix(cbind(loanamount1,loanamount2,loanamount3))
# X_DSR<-as.matrix(cbind(DSR1,DSR2,DSR3))
# X_DAR<-as.matrix(cbind(DAR_without1,DAR_without2,DAR_without3))


#--- Trends analysis clustering
# interactive_clustering(X_loan_log)
# interactive_clustering(X_income_log)
# interactive_clustering(X_assets_log)
# interactive_clustering(X_expenses_log)

interactive_clustering(X_assets2_log)


#--- What to keep?
# log loan      -> k=3 with sbd and median. Random seed=1
# log loan      -> k=4 with sbd and median. Random seed=8
# log loan      -> k=4 with sbd and median. Random seed=9 OK
# By dropping 0:
# log loan      -> k=3 with sbd and median. Random seed=3 OK -> best

# log assets    -> k=4 with sbd and median. Random seed=5
# log assets    -> k=5 with sbd and median. Random seed=6
# log assets    -> k=4 with sbd and median. Random seed=7 OK

# log income    -> k=4 with sbd and median. Random seed=1
# log income    -> k=3 with sbd and median. Random seed=1 OK

# log expenses  -> k=3 with sbd and median. Random seed=1
# log expenses  -> k=4 with sbd and median. Random seed=3
# log expenses  -> k=4 with sbd and median. Random seed=19 OK



#--- Manually trends analysis
assets<-tsclust(
  series=X_assets_log,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="median",
  seed=7,
  trace=TRUE,
  error.check=TRUE
)

income<-tsclust(
  series=X_income_log,
  type="partitional",
  k=3,
  distance="sbd",
  centroid="median",
  seed=1,
  trace=TRUE,
  error.check=TRUE
)

expenses<-tsclust(
  series=X_expenses_log,
  type="partitional",
  k=4,
  distance="sbd",
  centroid="median",
  seed=19,
  trace=TRUE,
  error.check=TRUE
)



#--- Datasets extraction
cl_annualincome<-income@cluster
cl_assets_noland<-assets@cluster
cl_yearly_expenses<-expenses@cluster

data<-cbind(data,cl_annualincome,cl_assets_noland,cl_yearly_expenses)

write.csv(data,"debttrendRreturn.csv")



#--- For loan
detach(data)
rm(list = ls())
data<-read.csv("debttrend_v2.csv")
attach(data)
X_loan_log<-as.matrix(cbind(log_loanamount1,log_loanamount2,log_loanamount3))

# interactive_clustering(X_loan_log)

loan<-tsclust(
  series=X_loan_log,
  type="partitional",
  k=3,
  distance="sbd",
  centroid="median",
  seed=3,
  trace=TRUE,
  error.check=TRUE
)

cl_loanamount<-loan@cluster

data<-cbind(data,cl_loanamount)

write.csv(data,"debttrendRreturn_v2.csv")


#--- Stata graph
#options("RStata.StataPath" = "C:/Users/Arnaud/Documents/Software/Stata15/StataMP-64")
#options("RStata.StataVersion" = 15.1)
#stata("linegraph.do")