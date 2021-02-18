setwd("C:\Users\caill\Documents\Projet")
rm(list=objects())

library(tidyverse)
library(lubridata_train$Date)
library(xts)

data_train <- read_delim(file = "data/train.csv", delim=",")
data_test <- read_delim(file = "data/test.csv", delim=",")


names(data_train)
range(data_train$data_train$Date)

n = length(data_train$Date)
t = c(1:n)

Xt = xts(data_train$Load, order.by = data_train$Date)

#_______Affichage________#
png(file = "Exo1_plot.png", width=600, height=350)
plot(Xt, type = "l", col = "purple", xlab = "Annee")
lines(Yt, type = "l", col = "green", lwd=2)
lines(Tt, type = "l", col = "red", lwd=2)

addLegend(legend.loc = "topleft", legend.names = c("Xt", 'Yt', 'Tt'),
          col = c("purple","green","red"),lty = c(1, 1) )
dev.off()

#######################################################################################
#__________________________________Regression_________________________________________#
#######################################################################################
reglin <- lm(Xt ~ t)

summary(reglin)

LinearModels_trend <- reglin$fitted.values
#_______Affichage________#
png(file = "Exo1_Reg.png", width=600, height=350)
plot(Xt, type='l', col = "purple", xlab = "Annee")
lines(LinearModels_trend, col='red', lwd=2)
addLegend(legend.loc = "topleft", legend.names = c("Xt", 'Reg'),
          col = c("purple","blue"),lty = c(1, 1) )
dev.off()

#######################################################################################
#________________________________moyenne mobile ______________________________________#
#######################################################################################
MovingAverage_trend = stats::filter(Xt, 
                                    filter = array(1/100, dim=10),
                                    method = c('convolution'),
                                    sides = 2,
                                    circular = FALSE)

MovingAverage_trend = xts(MovingAverage_trend, order.by = data_train$Date)
#_______Affichage________#
png(file = "Exo1_MoyMobile.png", width=600, height=350)
plot(Xt, type='l', col = "purple", xlab = "Annee")
lines(MovingAverage_trend, col='red', lwd=2)
addLegend(legend.loc = "topleft", legend.names = c("Xt", 'moyenne mobile'),
          col = c("purple","red"),lty = c(1, 1)) 
dev.off()

#######################################################################################
#________________________________Noyau Gaussien_______________________________________#
#######################################################################################
kernel_smooth = function(x){
  value = (x - t)/h
  kernel = 1/(2*pi) * exp((-value^2)/2)
  return(sum(Xt*kernel)/sum(kernel))
}

h=10
x = t
kernel_trend = sapply(x,kernel_smooth)
#_______Affichage________#
png(file = "Exo1_Gaussien.png", width=600, height=350)
plot(Xt, type='l', col = "purple", xlab = "Annee")
lines(xts(kernel_trend,order.by = data_train$Date),col='red', lwd=2)
addLegend(legend.loc = "topleft", legend.names = c("Xt", 'Noyau Gaussien'),
          col = c("purple","red"),lty = c(1, 1) )
dev.off()

#######################################################################################
#_______________________________Polynômes locaux______________________________________#
#######################################################################################


lo = loess(Xt ~ t, degree = 2, span = 0.7)
poly_trend = lo$fitted
#_______Affichage________#
png(file = "Exo1_PolLoc.png", width=600, height=350)
plot(Xt, type='l', col = "purple", xlab = "Annee")
lines(xts(poly_trend,order.by = data_train$Date),col='red', lwd=2)
addLegend(legend.loc = "topleft", legend.names = c("Xt", 'Polynômes locaux'),
          col = c("purple","red"),lty = c(1, 1) )
dev.off()
