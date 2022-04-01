rm(list=ls())
setwd("C:/Users/Arnaud/Documents/_Thesis/Research-Stability_skills/Analysis")

#install.packages("CBPS", dependencies=TRUE)
#install.packages("MatchIt", dependencies=TRUE)

library(foreign)
library(CBPS)
library(MatchIt)


neemsis1<-read.dta("N1_CBPS.dta")

attach(neemsis1)


fit<-CBPS(treat~caste_2+caste_3+sex_2+mainocc_occupation_indiv_1+mainocc_occupation_indiv_2+mainocc_occupation_indiv_4+mainocc_occupation_indiv_5+mainocc_occupation_indiv_6+mainocc_occupation_indiv_7+mainocc_occupation_indiv_8+edulevel_2+edulevel_3+edulevel_4+edulevel_5+edulevel_6, ATT=0)
summary(fit)

plot(fit, covars=NULL, silent=FALSE, boxplot=TRUE)

## matching via MatchIt
## one to one nearest neighbor with replacement
m.out <- matchit(treat~1, distance=fitted(fit), method="nearest", replace=FALSE)
summary(m.out)


