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
neemsis2<-read.dta("N2_CBPS.dta")
attach(neemsis2)


# CBPS
fit<-CBPS(treat~age+caste_2+caste_3+sex_2+mainocc_occupation_indiv_1+mainocc_occupation_indiv_2+mainocc_occupation_indiv_4+mainocc_occupation_indiv_5+mainocc_occupation_indiv_6+mainocc_occupation_indiv_7+mainocc_occupation_indiv_8+edulevel_2+edulevel_3+edulevel_4+edulevel_5+edulevel_6+HHsize+annualincome_indiv+maritalstatus_2+maritalstatus_3+maritalstatus_4, ATT=0, baseline.formula=NULL, diff.formula=NULL)
summary(fit)


# Store weights
weights<-fit$weights
neemsis2$weights<-weights
write.dta(neemsis2, "neemsis2_r.dta") 

# Store ADSM
adsm<-plot(fit, covars=NULL, silent=FALSE, boxplot=TRUE)
write.dta(adsm, "adsm_n2_r.dta")

detach(neemsis2)

# ADSM plot
#attach(adsm)
#scatterplot(original, balanced,            # Data
#            pch = 19,        # Symbol of the points
#            col = 1,         # Color of the points
#            smooth = FALSE,  # Remove smooth estimate
#            regLine = FALSE,
#            xlab="ADSM before weighting",
#            ylab="ADSM after weighting",
#            grid=FALSE) 

#detach(adsm)