# install.packages("Factoshiny")

library(Factoshiny)

setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Diversity/Analysis")

data<-read.csv("Mainloans_4.csv")
MCAshiny(data)