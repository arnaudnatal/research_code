rm(list = ls())

# synthetically generated control charts

# install.packages("tidyr", dependencies = TRUE)
# install.packages("dtwclust", dependencies = TRUE)
# install.packages("dplyr", dependencies = TRUE)
# install.packages("reshape", dependencies = TRUE)

library(tidyr)
library(dtwclust)
library(dplyr)
library(ggplot2)
library(reshape)

data<-read.csv("C:/Users/Arnaud/Downloads/loantest.csv")

attach(data)

tslist(loan1-loan3, simplify = FALSE)

## Not run:
interactive_clustering(data)
## End(Not run)