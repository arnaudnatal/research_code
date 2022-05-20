# Arnaud NATAL
# University of Bordeaux
# arnaud.natal@u-bordeaux.fr
# Debt trend analysis: classification of trends
# May 3, 2022



#--- Introduction
# .rs.restartR()
rm(list = ls())
setwd("C:/Users/Arnaud/Documents/GitHub/Analysis/Overindebtedness")



#--- Install packages
# install.packages("Factoshiny", dependencies = TRUE)


#--- Open packages
library(Factoshiny)
library(tidyverse)


#--- Open datasets
data<-read.csv("debttrend_v3.csv")


#--- Matrices creation
attach(data)
X<-as.matrix(cbind(sbd_dsr,sbd_dar,sbd_assets_noland,sbd_loanamount))#,sbd_annualincome,cat_assets,cat_income,caste,jatis,villagearea,villageid))
trend<-as.data.frame(X)

detach(data)
attach(trend)

# trend<-rename(trend, dsr=V1)


#--- Factoshiny
# MCAshiny(trend)


#--- MCA
res.MCA<-MCA(trend,ncp=4,graph=FALSE)

plot.MCA(res.MCA,axes=c(1,2),invisible= 'ind',col.var=c(1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4),label =c('var'))
plot.MCA(res.MCA,axes=c(1,2),invisible= 'var',col.var=c(1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4),label ='none')

plot.MCA(res.MCA,axes=c(3,4),invisible= 'ind',col.var=c(1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4),label =c('var'))
plot.MCA(res.MCA,axes=c(3,4),invisible= 'var',col.var=c(1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4),label ='none')

summary(res.MCA)


#--- HCPC
res.HCPC<-HCPC(res.MCA,nb.clust=3,consol=FALSE,graph=FALSE)

plot.HCPC(res.HCPC,choice='tree',title='Hierarchical tree')
summary(res.HCPC)

plot.HCPC(res.HCPC,choice='map',draw.tree=FALSE,title='Factor map')
plot.HCPC(res.HCPC,choice='3D.map',ind.names=FALSE,centers.plot=FALSE,angle=60,title='Hierarchical tree on the factor map')

plot.HCPC(res.HCPC,choice='map',draw.tree=FALSE,title='Factor map',axes=c(3,4))
plot.HCPC(res.HCPC,choice='3D.map',ind.names=FALSE,centers.plot=FALSE,angle=60,title='Hierarchical tree on the factor map',axes=c(3,4))


#--- Datasets extraction
vulnerable<-res.HCPC$data.clust

data<-cbind(data,vulnerable)

write.csv(data,"debttrendRreturn.csv")