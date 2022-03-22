install.packages(c("cluster", "factoextra"))
library(cluster)
library(factoextra)

a <- matrix(c(0,1,3,2,0,.32,1,.5,0,.35,1.2,.4,.5,.3,.2,.1,.5,.2,0,-.1), byrow=T, nrow=5)
cl <- clara(a,2)
summary(cl)
matplot(t(a),type="b", pch=20, col=cl$clustering) 



a1 <- t(apply(a,1,scale))
a2 <- t(apply(a1,1,diff))

cl <- clara(a2,2)
summary(cl)
matplot(t(a),type="b", pch=20, col=cl$clustering) 