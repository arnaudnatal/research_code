#######################################################################################
#
#                             - Measuring Mobility -
#    
# by Frank A. Cowell and E. Flachaire, October 2017
#
# replication file: Table 8, Mobility in China
#
#######################################################################################
rm(list=ls(all=TRUE))
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/inequalities")
library(openxlsx)

#
A=c(-1,-0.5,0,0.5,1,1.5,2)     # set the values of the mobility index parameter (alpha in eq.(19))
nboot=999

nalpha=NROW(A)
Mboot = matrix(0,nboot,nalpha)

source("mobility.r")  # load the functions used to compute mobility indices 

# Read the data
  data1 <- read.table("wealthhh2_upp.txt",header=TRUE)
  data <- data1[data1$var1>0 & data1$var2>0,]
  attach(data)
  i1=var1
  i2=var2

Z=cbind(i1,i2) 


#########################################################################
############## First, let's consider *rank* mobility indices ############
#########################################################################

# For rank mobility, we don't have asymptotic standard errors. 
# Confidence intervals are computed with the bootstrap percentile method.

status=1

#################### Overall (rank) mobility
inc=Z

# compute mobility indices
M0=M.stat(inc[,1],inc[,2],a=A,status=status)$index    

# compute bootstrap confidence intervals at 95% (percentile bootstrap method)
set.seed(100)
for (b in 1:nboot) {      
  iboot=sample(NROW(inc),replace=TRUE)     
  Mb <- M.stat(inc[iboot,1],inc[iboot,2],a=A,status=status)
  Mboot[b,]=Mb$index    
}
ICu=numeric(nalpha)
ICl=numeric(nalpha)
for (j in 1:nalpha) {
  ICl[j] = quantile(Mboot[,j],probs=c(.025),type=1,names=F)
  ICu[j] = quantile(Mboot[,j],probs=c(.975),type=1,names=F)
}  
res1=round(cbind(A,M0,ICl,ICu),4)


#################### Downward (rank) mobility
inc=Z[(Z[,1]>Z[,2]),]

# compute mobility indices
M0=M.stat(inc[,1],inc[,2],a=A,status=status)$index    

# compute bootstrap confidence intervals at 95% (percentile bootstrap method)
set.seed(100)
for (b in 1:nboot) {      
  iboot=sample(NROW(inc),replace=TRUE)     
  Mb <- M.stat(inc[iboot,1],inc[iboot,2],a=A,status=status)
  Mboot[b,]=Mb$index    
}
ICu=numeric(nalpha)
ICl=numeric(nalpha)
for (j in 1:nalpha) {
  ICl[j] = quantile(Mboot[,j],probs=c(.025),type=1,names=F)
  ICu[j] = quantile(Mboot[,j],probs=c(.975),type=1,names=F)
}  
res2=round(cbind(A,M0,ICl,ICu),4)


#################### Upward (rank) mobility
inc=Z[(Z[,1]<=Z[,2]),]

# compute mobility indices
M0=M.stat(inc[,1],inc[,2],a=A,status=status)$index    

# compute bootstrap confidence intervals at 95% (percentile bootstrap method)
set.seed(100)
for (b in 1:nboot) {      
  iboot=sample(NROW(inc),replace=TRUE)     
  Mb <- M.stat(inc[iboot,1],inc[iboot,2],a=A,status=status)
  Mboot[b,]=Mb$index    
}
ICu=numeric(nalpha)
ICl=numeric(nalpha)
for (j in 1:nalpha) {
  ICl[j] = quantile(Mboot[,j],probs=c(.025),type=1,names=F)
  ICu[j] = quantile(Mboot[,j],probs=c(.975),type=1,names=F)
}  
res3=round(cbind(A,M0,ICl,ICu),4)


################## Save the results

res=rbind(res1[1,],res2[1,],res3[1,],res1[2,],res2[2,],res3[2,],res1[3,],res2[3,],res3[3,],res1[4,],res2[4,],res3[4,],res1[5,],res2[5,],res3[5,],res1[6,],res2[6,],res3[6,],res1[7,],res2[7,],res3[7,])
rownames(res)=c("overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward")
colnames(res)=c("alpha","index","CI_lower", "CI_upper")
res_rank=res



#########################################################################
############ Second, let's consider *income* mobility indices ###########
#########################################################################

# For income mobility, we have asymptotic standard errors. 
# Confidence intervals are computed with the bootstrap studentized method.

status=0 

#################### Overall (income) mobility
inc=Z

# compute mobility indices and standard errors
M0=M.stat(inc[,1],inc[,2],a=A,status=status)$index    
M0se=M.stat(inc[,1],inc[,2],a=A,status=status)$se

# compute asymptotic confidence intervals
ICuas=M0+1.96*M0se
IClas=M0-1.96*M0se

# compute bootstrap confidence intervals (bootstrap-t method)
set.seed(100)
for (b in 1:nboot) {      
  iboot=sample(NROW(inc),replace=T)     # as.integer(runif(nobs)*nobs+1)
  Mb <- M.stat(inc[iboot,1],inc[iboot,2],a=A,status=status)
  Mboot[b,]=(Mb$index-M0)/Mb$se    
}
ICu=numeric(nalpha)
ICl=numeric(nalpha)
for (j in 1:nalpha) {
  ICu[j] = M0[j]-quantile(Mboot[,j],probs=c(.025),type=1,names=F)*M0se[j]
  ICl[j] = M0[j]-quantile(Mboot[,j],probs=c(.975),type=1,names=F)*M0se[j]
}  

res1=round(cbind(A,M0,ICl,ICu,IClas,ICuas),4)


#################### Downward (income) mobility
inc=Z[(Z[,1]>Z[,2]),]

# compute mobility indices and standard errors
M0=M.stat(inc[,1],inc[,2],a=A,status=status)$index    
M0se=M.stat(inc[,1],inc[,2],a=A,status=status)$se

# compute asymptotic confidence intervals
ICuas=M0+1.96*M0se
IClas=M0-1.96*M0se

# compute bootstrap confidence intervals (bootstrap-t method)
set.seed(100)
for (b in 1:nboot) {      
  iboot=sample(NROW(inc),replace=T)     # as.integer(runif(nobs)*nobs+1)
  Mb <- M.stat(inc[iboot,1],inc[iboot,2],a=A,status=status)
  Mboot[b,]=(Mb$index-M0)/Mb$se    
}
ICu=numeric(nalpha)
ICl=numeric(nalpha)
for (j in 1:nalpha) {
  ICu[j] = M0[j]-quantile(Mboot[,j],probs=c(.025),type=1,names=F)*M0se[j]
  ICl[j] = M0[j]-quantile(Mboot[,j],probs=c(.975),type=1,names=F)*M0se[j]
}  

res2=round(cbind(A,M0,ICl,ICu,IClas,ICuas),4)

#################### Upward (income) mobility
inc=Z[(Z[,1]<=Z[,2]),]

# compute mobility indices and standard errors
M0=M.stat(inc[,1],inc[,2],a=A,status=status)$index    
M0se=M.stat(inc[,1],inc[,2],a=A,status=status)$se

# compute asymptotic confidence intervals
ICuas=M0+1.96*M0se
IClas=M0-1.96*M0se

# compute bootstrap confidence intervals (bootstrap-t method)
set.seed(100)
for (b in 1:nboot) {      
  iboot=sample(NROW(inc),replace=T)     # as.integer(runif(nobs)*nobs+1)
  Mb <- M.stat(inc[iboot,1],inc[iboot,2],a=A,status=status)
  Mboot[b,]=(Mb$index-M0)/Mb$se    
}
ICu=numeric(nalpha)
ICl=numeric(nalpha)
for (j in 1:nalpha) {
  ICu[j] = M0[j]-quantile(Mboot[,j],probs=c(.025),type=1,names=F)*M0se[j]
  ICl[j] = M0[j]-quantile(Mboot[,j],probs=c(.975),type=1,names=F)*M0se[j]
}  

res3=round(cbind(A,M0,ICl,ICu,IClas,ICuas),4)

################## Save the results

res=rbind(res1[1,],res2[1,],res3[1,],res1[2,],res2[2,],res3[2,],res1[3,],res2[3,],res3[3,],res1[4,],res2[4,],res3[4,],res1[5,],res2[5,],res3[5,],res1[6,],res2[6,],res3[6,],res1[7,],res2[7,],res3[7,])
rownames(res)=c("overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward","overall","downward","upward")
colnames(res)=c("alpha","index","CI_lower", "CI_upper","CI_lower_asymp", "CI_upper_asymp")
res_inc=res[,1:4]

#########################################################################
#############################  Results ##################################
#########################################################################

res_rank
write.xlsx(res_rank, 'CF_rank.xlsx')

res_inc
write.xlsx(res_inc, 'CF_level.xlsx')