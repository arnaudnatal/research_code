# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: classification of trends
# May 3, 2022


#--- Introduction
# .rs.restartR()
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/research_code/evodebt")


#--- Install packages
# install.packages("Factoshiny", dependencies = TRUE)


#--- Open packages
library(Factoshiny)
library(tidyverse)


#--- Open datasets
data<-read.csv("debttrend_v3.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(sbd_dsr,sbd_dar,sbd_assets_noland,sbd_annualincome))#,sbd_loanamount,cat_assets,cat_income,caste,jatis,villagearea,villageid))
trend<-as.data.frame(X)

detach(data)
attach(trend)

# trend<-rename(trend, dsr=V1)


#--- Factoshiny
MCAshiny(trend)




#--- MCA
res.MCA<-MCA(trend,ncp=5,graph=FALSE)

#plot.MCA(res.MCA,axes=c(1,2),invisible= 'ind',col.var=c(1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4),label =c('var'))
#plot.MCA(res.MCA,axes=c(1,2),invisible= 'var',col.var=c(1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4),label ='none')
#summary(res.MCA)


#--- HCPC
res.HCPC<-HCPC(res.MCA,nb.clust=4,consol=TRUE,graph=FALSE)

#plot.HCPC(res.HCPC,choice='tree',title='Hierarchical tree')
#summary(res.HCPC)

inert<-res.HCPC[["call"]][["t"]][["inert.gain"]]

#plot.HCPC(res.HCPC,choice='map',draw.tree=FALSE,title='Factor map')


#--- Datasets extraction
vulnerable<-res.HCPC$data.clust
data<-cbind(data,vulnerable)
inertia<-cbind(inert)

table(vulnerable$clust)

write.csv(data,"debttrend_v4.csv")
write.csv(inertia,"inertia.csv")