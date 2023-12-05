rm(list=ls())

# Open Data
setwd("C:/Users/Arnaud/Documents/MEGA/Thesis/Thesis_5-Stability/Analysis")
par("mar")
par(mar=c(1,1,1,1))

#install.packages("CBPS", dependencies=TRUE)
#install.packages("MatchIt", dependencies=TRUE)
#install.packages("car", dependencies=TRUE)

library(foreign)
library(CBPS)
library(MatchIt)
library(car)

neemsis1<-read.dta("N1_CBPS.dta")
attach(neemsis1)

# CBPS
fit<-CBPS(treat~age+caste_2+caste_3+sex_2+mainocc_occupation_indiv_1+mainocc_occupation_indiv_2+mainocc_occupation_indiv_4+mainocc_occupation_indiv_5+mainocc_occupation_indiv_6+mainocc_occupation_indiv_7+mainocc_occupation_indiv_8+edulevel_2+edulevel_3+edulevel_4+edulevel_5+HHsize+annualincome_indiv+maritalstatus_2, ATT=0)

summary(fit)

# Store CBPS
#ps_scores<-predict(fit)
ps_scores<-fit$fitted.values
treated_indices<-which(treat == 1)
untreated_indices<-which(treat == 0)

plot(density(ps_scores[treated_indices]), col = "blue", main = "Propensity Score Distribution", xlab = "Propensity Score")
lines(density(ps_scores[untreated_indices]), col = "red")
legend("topright", legend = c("Treated", "Untreated"), fill = c("blue", "red"))



# Store weights
weights<-fit$weights
neemsis1$weights<-weights
write.dta(neemsis1, "neemsis1_r.dta") 

# Store ADSM
adsm<-plot(fit, covars=NULL, silent=FALSE, boxplot=TRUE)
write.dta(adsm, "adsm_n1_r.dta")

detach(neemsis1)