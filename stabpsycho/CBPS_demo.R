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
#fit<-CBPS(treat~age+caste_2+caste_3+sex_2+mainocc_occupation_indiv_1+mainocc_occupation_indiv_2+mainocc_occupation_indiv_4+mainocc_occupation_indiv_5+mainocc_occupation_indiv_6+mainocc_occupation_indiv_7+mainocc_occupation_indiv_8+edulevel_2+edulevel_3+edulevel_4+edulevel_5+edulevel_6+HHsize+annualincome_indiv+maritalstatus_2+maritalstatus_3+maritalstatus_4+villageid_2+villageid_3+villageid_4+villageid_5+villageid_6+villageid_7+villageid_8+villageid_9+villageid_10+username_code_1+username_code_2+username_code_3+username_code_4+username_code_5+username_code_7, ATT=0)
fit<-CBPS(treat~age+caste_2+caste_3+sex_2+mainocc_occupation_indiv_1+mainocc_occupation_indiv_2+mainocc_occupation_indiv_4+mainocc_occupation_indiv_5+mainocc_occupation_indiv_6+mainocc_occupation_indiv_7+mainocc_occupation_indiv_8+edulevel_2+edulevel_3+edulevel_4+edulevel_5+edulevel_6+HHsize+annualincome_indiv+maritalstatus_2+maritalstatus_3+maritalstatus_4, ATT=0)

summary(fit)

# Store weights
weights<-fit$weights
neemsis1$weights<-weights
write.dta(neemsis1, "neemsis1_r.dta") 

# Store ADSM
adsm<-plot(fit, covars=NULL, silent=FALSE, boxplot=TRUE)
adsm
write.dta(adsm, "adsm_n1_r.dta")

detach(neemsis1)


# ADSM plot
#attach(adsm)
#pdf(file = "ADSM_res_demo.pdf")
#scatterplot(original, balanced, # Data
#            pch = 19,           # Symbol of the points
#            col = 1,            # Color of the points
#            smooth = FALSE,     # Remove smooth estimate
#            regLine = FALSE,    # Remove linear estimate
#            xlab="ADSM before weighting",
#            ylab="ADSM after weighting",
#            grid=FALSE) 

#dev.off()

#detach(adsm)