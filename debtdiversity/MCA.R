install.packages("Factoshiny")

library(Factoshiny)

setwd("C:/Users/Arnaud/Documents/MEGA/Research/Ongoing_Diversity/Analysis")

loan<-read.csv("Loan_mca.csv")
MCAshiny(loan)