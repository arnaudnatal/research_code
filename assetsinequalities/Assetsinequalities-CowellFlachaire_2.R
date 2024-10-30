#######################################################################################
#
#                             - Measuring Mobility -
#    
# by Frank A. Cowell and E. Flachaire, October 2017
#
# replication file: Table 7, Mobility in China
#
#######################################################################################
rm(list=ls(all=TRUE))
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/assetsinequalities")



# Define a function to compute the Cowell-Flachaire summary index

CFp = function(p, a=0) {  
  K=NROW(p)
  Ma=0
  if(a==0)
    for(k in 1:K)
      for (l in 1:K)  Ma = Ma + p[k,l]*l*log(k/l) * (-2/(K*K+K))
  else if(a==1)
    for(k in 1:K)
      for (l in 1:K)  Ma = Ma + p[k,l]*k*log(k/l) * (2/(K*K+K))
  else {
    for(k in 1:K)
      for (l in 1:K)  Ma = Ma + p[k,l]*k^a*l^(1-a)
      Ma= (1/(a*a-a)) * ((2/(K*K+K))*Ma - 1 )
  }
  return(Ma)
}

# Read the data
  data1 <- read.table("panelHHassets2.txt",header=TRUE)
  r1=rank(data1$ass1)/NROW(data1$ass1)
  r2=rank(data1$ass2)/NROW(data1$ass2)


# Compute the transition matrix

rg1 = (r1<=.2) + 2*(r1>.2 & r1<=.4) + 3*(r1>.4 & r1<=.6) + 4*(r1>.6 & r1<=.8) + 5*(r1>.8)
rg2 = (r2<=.2) + 2*(r2>.2 & r2<=.4) + 3*(r2>.4 & r2<=.6) + 4*(r2>.6 & r2<=.8) + 5*(r2>.8)

trf <- table(data.frame(R0=rg1,R1=rg2))
TMat = trf/rowSums(trf)

# Compute the bootstrap (percentile) confidence interval

nboot=999
Mb=numeric(nboot)

set.seed(100)
a1=rep(1:5, each=NROW(rg1)/5)
a2=numeric(NROW(a1))
for(b in 1:nboot) {
  # generate a sample of size n from the transition matrix
  for(i in 1:NROW(a1)) a2[i] = sample(5,size=1,prob=TMat[a1[i],]) 
  # compute the transition matrix
  trfb <- table(data.frame(R0=a1,R1=a2))
  TMatb = trfb/rowSums(trfb)
  # compute the summary index
  Mb[b]=CFp(TMatb,a=0)
}

res=c(CFp(TMat,a=0),quantile(Mb,.025),quantile(Mb,.975))  

# Show the results
round(TMat,3)   # Show the transition matrix
round(res,3)    # Show the summary index and its confidence interval at 95%