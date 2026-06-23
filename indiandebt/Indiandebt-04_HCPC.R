##### Rural/Urban

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")


### Import
data<-read.csv("Allloans_all.csv")
var<-data[,c("amount3cat3", "lender4", "reason7", "interest", "security2", "duration2", "scheme2"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=9, graph=FALSE)

#print(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
#res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE, nb.clust=9)
plot(res_hcpc,choice="tree", rect=FALSE)
plot(res_hcpc,choice="tree", rect=TRUE)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))

#
cluster<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,cluster)
write.csv(data_clustered, "Allloans_all_res.csv", row.names = FALSE, fileEncoding = "UTF-8")













##### Rural/Urban récent

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")


### Import
data<-read.csv("Allloans_allrecent.csv")
var<-data[,c("amount3cat3", "lender4", "reason5", "interest", "security2", "duration2", "scheme2"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=11, graph=FALSE)

#print(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE, nb.clust=5)
plot(res_hcpc,choice="tree", rect=FALSE)
plot(res_hcpc,choice="tree", rect=TRUE)

#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))

#
cluster<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,cluster)
write.csv(data_clustered, "Allloans_allrecent_res.csv", row.names = FALSE, fileEncoding = "UTF-8")
