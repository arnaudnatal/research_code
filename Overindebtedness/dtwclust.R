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

X_loan_cro<-as.matrix(cbind(cro_loanamount1,cro_loanamount2,cro_loanamount3))
X_income_cro<-as.matrix(cbind(cro_annualincome1,cro_annualincome2,cro_annualincome3))
X_assets_cro<-as.matrix(cbind(cro_assets_noland1,cro_assets_noland2,cro_assets_noland3))

X_loan_ihs<-as.matrix(cbind(ihs_loanamount1,ihs_loanamount2,ihs_loanamount3))
X_income_ihs<-as.matrix(cbind(ihs_annualincome1,ihs_annualincome2,ihs_annualincome3))
X_assets_ihs<-as.matrix(cbind(ihs_assets_noland1,ihs_assets_noland2,ihs_assets_noland3))

X_DSR_ihs<-as.matrix(cbind(ihs_DSR1,ihs_DSR2,ihs_DSR3))
X_DSR_cro<-as.matrix(cbind(cro_DSR1,cro_DSR2,cro_DSR3))

X_DAR_ihs<-as.matrix(cbind(ihs_DAR1,ihs_DAR2,ihs_DAR3))
X_DAR_cro<-as.matrix(cbind(cro_DAR1,cro_DAR2,cro_DAR3))

X_ISR_ihs<-as.matrix(cbind(ihs_ISR1,ihs_ISR2,ihs_ISR3))
X_ISR_cro<-as.matrix(cbind(cro_ISR1,cro_ISR2,cro_ISR3))

X_DSR<-as.matrix(cbind(DSR1,DSR2,DSR3))
X_DAR<-as.matrix(cbind(DAR_without1,DAR_without2,DAR_without3))
X_ISR<-as.matrix(cbind(ISR1,ISR2,ISR3))

X_agri<-as.matrix(cbind(shareagri1,shareagri2,shareagri3))
X_nagri<-as.matrix(cbind(sharenagri1,sharenagri2,sharenagri3))


#--- Trends analysis clustering
# interactive_clustering(X_loan_log)
# interactive_clustering(X_income_log)
# interactive_clustering(X_assets_log)
# interactive_clustering(X_expenses_log)

interactive_clustering(X_income_ihs)
interactive_clustering(X_assets_ihs)
interactive_clustering(X_loan_ihs)

interactive_clustering(X_DSR_ihs)
interactive_clustering(X_ISR_ihs)
interactive_clustering(X_DAR_ihs)

interactive_clustering(X_DSR_cro)
interactive_clustering(X_ISR_cro)
interactive_clustering(X_DAR_cro)

interactive_clustering(X_agri)
interactive_clustering(X_nagri)


#--- What to keep?
# log loan      -> k=4 with sbd and median. Random seed=9 OK
# log loan      -> k=3 with sbd and median. Random seed=3 OK -> drop 0 before
# ihs loan      -> k=3 with sbd and median. Random seed=1 OK

# log assets    -> k=4 with sbd and median. Random seed=7 OK
# ihs assets    -> k=4 with sbd and median. Random seed=7 OK

# log income    -> k=3 with sbd and median. Random seed=1 OK
# ihs income    -> k=3 with sbd and median. Random seed=1 OK

# ihs DSR       -> k=3 with sbd and median. Random seed=9 OK

# ihs ISR       -> k=4 with sbd and median. Random seed=5 OK

# ihs DAR       -> k=3 with sbd and median. Random seed=2 OK




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