# install.packages("Factoshiny")

rm(list=ls())

library(Factoshiny)

setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Diversity/Analysis")

# Import data
data<-read.csv("Allloans.csv")

# Create a sub data set 
var<-data[,c("lender", "reason", "amount"), drop = FALSE]

# Shiny App
res<-MCAshiny(var)

# Codes
res.MCA10<-MCA(var,ncp=13,graph=FALSE)
res.HCPC10<-HCPC(res.MCA10,nb.clust=10,kk=200,consol=FALSE,graph=FALSE)
clust10<-data.frame(clust10=res.HCPC10$data.clust$clust)

res.MCA8<-MCA(var,ncp=13,graph=FALSE)
res.HCPC8<-HCPC(res.MCA8,nb.clust=8,kk=200,consol=FALSE,graph=FALSE)
clust8<-data.frame(clust8=res.HCPC8$data.clust$clust)

# Fusion avec le fichier initial
results<-cbind(data,clust10,clust8)

# Export CSV
write.csv(results, "Allloans_res.csv", row.names = FALSE, fileEncoding = "UTF-8")
