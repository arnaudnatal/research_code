# install.packages("Factoshiny")

rm(list=ls())

library(Factoshiny)

setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Diversity/Analysis")

# Import data
data<-read.csv("CA.csv")

# Shiny App
res<-Factoshiny(data)