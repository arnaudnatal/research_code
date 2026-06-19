##### Rural/Urban

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")


### Import
data<-read.csv("Allloans_all.csv")
var<-data[,c("amount3cat2", "lender4", "reason2", "interest2", "security2", "duration2", "scheme2"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=8, graph=FALSE)

#print(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=100, description=FALSE, graph=FALSE, consol=FALSE)
plot(res_hcpc,choice="tree")
#plot(res_hcpc,choice="tree", rect=FALSE)
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
var<-data[,c("amount3cat3", "lender4", "reason5", "interest2", "security2", "duration2", "scheme2"), drop = FALSE]

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
plot(res_hcpc,choice="tree") 
#plot(res_hcpc,choice="tree", rect=FALSE)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))

#
cluster<-res_hcpc$data.clust$clust
table(cluster)
data_clustered<-cbind(data,cluster)
write.csv(data_clustered, "Allloans_allrecent_res.csv", row.names = FALSE, fileEncoding = "UTF-8")

















##### Rural

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")

### Import
data<-read.csv("Allloans_rural.csv")
var<-data[,c("lender2", "reason2", "catamount2", "interest2", "security2", "duration2", "scheme2"), drop = FALSE]

### MCA
nbaxe<-MCA(var, ncp=50, graph=FALSE)
nbaxe$eig
res_mca<-MCA(var, ncp=8, graph=FALSE)

#print(res_mca)
#res_mca$var$coord
#res_mca$var$cos2
#res_mca$var$contrib
#res_mca$var$v.test

### HCPC 
set.seed(123)
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
plot(res_hcpc,choice="tree")
#plot(res_hcpc,choice="tree", rect=FALSE)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))

#
clusters<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,clusters)
write.csv(data_clustered, "Allloans_rural_res.csv", row.names = FALSE, fileEncoding = "UTF-8")













##### Rural recent

### Initialisation 
rm(list=ls())
library(Factoshiny)
library(factoextra)
#setwd("C:/Users/anatal/Documents/id")
setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Indiandebt/Analysis")

### Import
data<-read.csv("Allloans_ruralrecent.csv")
var<-data[,c("lender2", "reason5", "catamount2", "interest2", "security2", "duration2", "scheme2"), drop = FALSE]

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
set.seed(123) # 1 123
res_hcpc<-HCPC(res_mca, kk=500, description=FALSE, graph=FALSE, consol=FALSE)
plot(res_hcpc,choice="tree") # 7 groupes
#plot(res_hcpc,choice="tree", rect=FALSE)
#plot(res_hcpc,choice="map", draw.tree=FALSE)
#plot(res_hcpc,choice="3D.map")
#catdes(res_hcpc$data.clust,ncol(res_hcpc$data.clust))

#
clusters<-res_hcpc$data.clust$clust
data_clustered<-cbind(data,clusters)
write.csv(data_clustered, "Allloans_ruralrecent_res.csv", row.names = FALSE, fileEncoding = "UTF-8")