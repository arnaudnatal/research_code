rm(list=ls())
setwd("C:/Users/Arnaud/Documents/_Thesis/Research-Overindebtedness/Persistence_over")

#install.packages("CBPS", dependencies=TRUE)
#install.packages("MatchIt", dependencies=TRUE)
#install.packages("car", dependencies=TRUE)

library(foreign)
library(CBPS)
library(MatchIt)
library(car)

# Open Data
neemsis1<-read.dta("N1_CBPS.dta")
attach(neemsis1)

# CBPS
fit<-CBPS(treat ~ head_age + head_female + head_married + head_edulevel_2 + head_edulevel_3 + head_occupation_2 + head_occupation_3 + head_occupation_4 + head_occupation_5 + head_occupation_6 + head_occupation_7 + caste_2 + caste_3 + annualincome + assets_noland + HHsize + nbchildren + housetype_2 + housetype_3 + ownland + villageid_2 + villageid_3 + villageid_4 + villageid_5 + villageid_6 + villageid_7 + villageid_8 + villageid_9 + villageid_10, ATT=0)
summary(fit)
weights<-fit$weights


# Write weights
neemsis1$weights<-weights

write.dta(neemsis1, "neemsis1_r.dta") 



# Store ADSM
# adsm<-plot(fit1, covars=NULL, silent=FALSE, boxplot=TRUE)
# adsm
# write.dta(adsm, "adsm_n1_r.dta")

# detach(neemsis1)