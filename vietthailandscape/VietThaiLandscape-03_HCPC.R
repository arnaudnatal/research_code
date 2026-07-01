###########################################
##### ALL
###########################################

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_VietThaiLandscape/Analysis")


### Import
data<-read.csv("All.csv")
var<-data[,c("type", "catamount", "lender", "reason", "shock", "interest", "collateral", "secondcollateral", "duration"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=23, graph=FALSE)
#print(res_mca)
#summary(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
#res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE, nb.clust=6)
#plot(res_hcpc,choice="tree", rect=FALSE, tree.barplot=FALSE)
plot(res_hcpc,choice="tree", rect=TRUE)
#summary(res_hcpc)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))


### Results
cluster<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,cluster)
write.csv(data_clustered, "All_res.csv", row.names = FALSE, fileEncoding = "UTF-8")

###########################################
##### END












###########################################
##### THAILAND
###########################################

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_VietThaiLandscape/Analysis")


### Import
data<-read.csv("Thai.csv")
var<-data[,c("type", "catamount", "lender", "reason", "shock", "interest", "collateral", "secondcollateral", "duration"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=23, graph=FALSE)
#print(res_mca)
#summary(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
#res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE, nb.clust=6)
#plot(res_hcpc,choice="tree", rect=FALSE, tree.barplot=FALSE)
plot(res_hcpc,choice="tree", rect=TRUE)
#summary(res_hcpc)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))


### Results
cluster<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,cluster)
write.csv(data_clustered, "Thai_res.csv", row.names = FALSE, fileEncoding = "UTF-8")

###########################################
##### END

















###########################################
##### VIETNAM
###########################################

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_VietThaiLandscape/Analysis")


### Import
data<-read.csv("Viet.csv")
var<-data[,c("type", "catamount", "lender", "reason", "shock", "interest", "collateral", "secondcollateral", "duration"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=23, graph=FALSE)
#print(res_mca)
#summary(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
#res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE, nb.clust=6)
#plot(res_hcpc,choice="tree", rect=FALSE, tree.barplot=FALSE)
plot(res_hcpc,choice="tree", rect=TRUE)
#summary(res_hcpc)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))


### Results
cluster<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,cluster)
write.csv(data_clustered, "Viet_res.csv", row.names = FALSE, fileEncoding = "UTF-8")

###########################################
##### END

