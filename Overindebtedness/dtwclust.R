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

# Add expenses

X_loan_ihs<-as.matrix(cbind(ihs_loanamount1,ihs_loanamount2,ihs_loanamount3))
X_income_ihs<-as.matrix(cbind(ihs_annualincome1,ihs_annualincome2,ihs_annualincome3))
X_assets_ihs<-as.matrix(cbind(ihs_assets_noland1,ihs_assets_noland2,ihs_assets_noland3))
X_expenses_ihs<-as.matrix(cbind(ihs_yearly_expenses1, ihs_yearly_expenses2, ihs_yearly_expenses3))
X_DSR_ihs<-as.matrix(cbind(ihs_DSR1,ihs_DSR2,ihs_DSR3))
X_DAR_ihs<-as.matrix(cbind(ihs_DAR1,ihs_DAR2,ihs_DAR3))
X_ISR_ihs<-as.matrix(cbind(ihs_ISR1,ihs_ISR2,ihs_ISR3))

X_agri<-as.matrix(cbind(shareagri1,shareagri2,shareagri3))
X_nagri<-as.matrix(cbind(sharenagri1,sharenagri2,sharenagri3))

X_info_ihs<-as.matrix(cbind(ihs_informal1, ihs_informal2, ihs_informal3))
X_form_ihs<-as.matrix(cbind(ihs_formal1, ihs_formal2, ihs_formal3))
X_econ_ihs<-as.matrix(cbind(ihs_eco1, ihs_eco2, ihs_eco3))
X_curr_ihs<-as.matrix(cbind(ihs_current1, ihs_current2, ihs_current3))
X_huma_ihs<-as.matrix(cbind(ihs_humank1, ihs_humank2, ihs_humank3))
X_soci_ihs<-as.matrix(cbind(ihs_social1, ihs_social2, ihs_social3))
X_home_ihs<-as.matrix(cbind(ihs_home1, ihs_home2, ihs_home3))
X_repa_ihs<-as.matrix(cbind(ihs_loanforrepayment1, ihs_loanforrepayment2, ihs_loanforrepayment3))


X_info_rel<-as.matrix(cbind(rel_informal1, rel_informal2, rel_informal3))
X_form_rel<-as.matrix(cbind(rel_formal1, rel_formal2, rel_formal3))
X_econ_rel<-as.matrix(cbind(rel_eco1, rel_eco2, rel_eco3))
X_curr_rel<-as.matrix(cbind(rel_current1, rel_current2, rel_current3))
X_huma_rel<-as.matrix(cbind(rel_humank1, rel_humank2, rel_humank3))
X_soci_rel<-as.matrix(cbind(rel_social1, rel_social2, rel_social3))
X_home_rel<-as.matrix(cbind(rel_home1, rel_home2, rel_home3))
X_repa_rel<-as.matrix(cbind(rel_loanforrepayment1, rel_loanforrepayment2, rel_loanforrepayment3))





#--- Trends analysis clustering
interactive_clustering(X_income_ihs)
interactive_clustering(X_assets_ihs)
interactive_clustering(X_loan_ihs)

interactive_clustering(X_DSR_ihs)
interactive_clustering(X_ISR_ihs)
interactive_clustering(X_DAR_ihs)

interactive_clustering(X_agri)
interactive_clustering(X_nagri)

interactive_clustering(X_info_rel)
interactive_clustering(X_form_rel)
interactive_clustering(X_econ_rel)
interactive_clustering(X_curr_rel)
interactive_clustering(X_huma_rel)
interactive_clustering(X_soci_rel)
interactive_clustering(X_home_rel)
interactive_clustering(X_repa_rel)


#--- What to keep?



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