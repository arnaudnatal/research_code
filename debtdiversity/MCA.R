# install.packages("Factoshiny")

rm(list=ls())

library(Factoshiny)

setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Diversity/Analysis")

data<-read.csv("Mainloans.csv")
res<-MCAshiny(data)

# data<-read.table("AFC.csv", header=TRUE, sep=";", row.names=1, check.names=FALSE)
# res<-Factoshiny(data)