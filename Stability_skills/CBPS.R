rm(list=ls())
setwd("C:/Users/Arnaud/Documents/_Thesis/Research-Stability_skills/Analysis")

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
fit<-CBPS(treat~age+caste_2+caste_3+sex_2+mainocc_occupation_indiv_1+mainocc_occupation_indiv_2+mainocc_occupation_indiv_4+mainocc_occupation_indiv_5+mainocc_occupation_indiv_6+mainocc_occupation_indiv_7+mainocc_occupation_indiv_8+edulevel_2+edulevel_3+edulevel_4+edulevel_5+edulevel_6, ATT=0)
summary(fit)

# Store weights
weights<-fit$weights
neemsis1$weights<-weights
write.dta(neemsis1, "neemsis1_r.dta") 

# Store ADSM
adsm<-plot(fit, covars=NULL, silent=FALSE, boxplot=TRUE)
write.dta(adsm, "adsm_r.dta")

detach(neemsis1)
attach(adsm)

scatterplot(original, balanced,            # Data
            pch = 19,        # Symbol of the points
            col = 1,         # Color of the points
            smooth = FALSE,  # Remove smooth estimate
            regLine = FALSE) # Remove linear estimate




