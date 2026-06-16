# 
rm(list=ls())
library(Factoshiny)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")

# Import data
data<-read.csv("Allloans.csv")
var<-data[,c("lender2", "reason3", "cat5amount", "interest", "security2", "scheme2", "duration2"), drop = FALSE]

# MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=15, graph=FALSE)

# HCPC
res_hcpc<-HCPC(res_mca, kk=100, description=FALSE, graph=FALSE, consol=FALSE)
plot(res_hcpc,choice="tree")
plot(res_hcpc,choice="tree", rect=FALSE)
plot(res_hcpc,choice="map", draw.tree=FALSE)
plot(res_hcpc,choice="3D.map")
catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))

# Export
clusters<-res_hcpc$data.clust$clust
table(clusters)
data_clustered<-cbind(data,clusters)
write.csv(data_clustered, "Allloans_res.csv", row.names = FALSE, fileEncoding = "UTF-8")