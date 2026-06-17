##### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
setwd("C:/Users/anatal/Documents/id")
#setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")


##### 1992 - 2002 - 2012 - 2019

### Import
data1<-read.csv("Allloans_9219.csv")
var1<-data1[,c("lender2", "reason2", "cat3amount", "interest2", "security2", "duration2", "scheme2"), drop = FALSE]

### MCA
nbaxe<-MCA(var1, ncp=50, graph=FALSE)
nbaxe$eig
res_mca1<-MCA(var1, ncp=8, graph=FALSE)

print(res_mca1)
res_mca1$var$coord
res_mca1$var$cos2
res_mca1$var$contrib
res_mca1$var$v.test

### HCPC
set.seed(123)
res_hcpc1<-HCPC(res_mca1, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
plot(res_hcpc1,choice="tree")
plot(res_hcpc1,choice="tree", rect=FALSE)
plot(res_hcpc1,choice="map", draw.tree=FALSE)
plot(res_hcpc1,choice="3D.map")
catdes(res_hcpc1$data.clust,ncol(res_hcpc1$data.clust))

#
clusters1<-res_hcpc1$data.clust$clust
table(clusters1)
data_clustered1<-cbind(data1,clusters1)
write.csv(data_clustered1, "Allloans_9219_res.csv", row.names = FALSE, fileEncoding = "UTF-8")






##### 2012 - 2019

### Import
data2<-read.csv("Allloans_1219.csv")
var2<-data2[,c("lender2", "reason3", "cat3amount", "interest", "security2", "duration2", "scheme2"), drop = FALSE]

### MCA
nbaxe<-MCA(var2, ncp=50, graph=FALSE)
nbaxe$eig
res_mca2<-MCA(var2, ncp=11, graph=FALSE)

### HCPC
#
set.seed(2026)
res_hcpc2<-HCPC(res_mca2, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
plot(res_hcpc2,choice="tree")
plot(res_hcpc2,choice="tree", rect=FALSE)
plot(res_hcpc2,choice="map", draw.tree=FALSE)
plot(res_hcpc2,choice="3D.map")
catdes(res_hcpc2$data.clust,ncol(res_hcpc2$data.clust))
#
clusters2<-res_hcpc2$data.clust$clust
table(clusters2)
data_clustered2<-cbind(data2,clusters2)
write.csv(data_clustered2, "Allloans_1219_res.csv", row.names = FALSE, fileEncoding = "UTF-8")