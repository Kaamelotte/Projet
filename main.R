setwd("W:/cours/M1_MA/Projet202")
rm(list=objects())

library(tidyverse)
library(lubridate)
library(xts)

data_train <- read_delim(file = "data/train.csv", delim=",")
data_test <- read_delim(file = "data/test.csv", delim=",")

#plot(data_train$Date)

names(data_train)
range(data_train$Date)
#date_begin<- strptime("01/01/12", "%m/%d/%y")
#date_end <- strptime("04/15/20", "%m/%d/%y") #"04/15/20"
#range_date<-seq(date_begin, date_end, by = "1 day")

train_x_times_serie <- xts(data_train$Load,order.by = data_train$Date)
plot(train_x_times_serie, ylab = "consomation en MW", xlab = "date", type = "l", col = "red")



a <- acf(train_x_times_serie, lag.max=336, type="correlation")


#######################################################################################
#____________________________________Moyenne__________________________________________#
#######################################################################################
par(mfrow = c(1,2), oma = c(2,0,0,0))

month <- as.factor(.indexmon(train_x_times_serie))
mean_month<-tapply(train_x_times_serie, month,mean)
plot(mean_month, type = "l", col = "green", sub = "Par mois", ylab = "consomation en MW", xlab = "mois")

year <- as.factor(.indexwday(train_x_times_serie))
mean_year <- tapply(train_x_times_serie, year, mean)
plot(mean_year, type = "l", col = "blue", sub = "Par jour", ylab = "consomation en MW", xlab = "jour")

title(main = "Moyenne", outer = TRUE, line = -1)


#######################################################################################
#_______________________________Modele linaire________________________________________#
#######################################################################################
par(mfrow = c(1,1))
lm0 <- lm(formula = Load~Load.1, data = data_train)
lm0forecast <- predict(lm0, newdata = data_test)

plot(data_train$Date, data_train$Load, type = "l", col = "blue", xlim = range(data_train$Date, data_test$Date), ylab = "consomation en MW", xlab = "Année")
lines(data_test$Date, lm0forecast, col = 'red')



#######################################################################################
#_________________________________temperature_________________________________________#
#######################################################################################

#affichage conso + température
plot(data_train$Date, data_train$Load, type = "l")
par(new = T)
plot(data_train$Date, data_train$Temp, type = "l", col = "red")

#conso en fct température
plot(data_train$Temp, data_train$Load, xlab = "Température (°C)", ylab = "Consommation (MW)", pch = "x", col = "blue")
title("Consomation")







reglin = lm(formula = Load~Temp, data = data_train)

#points(data_train$Temp, reglin$fitted.values, col = "red")

#plot(data_train$toy, data_train$Load, pch = 20)

#cor(data_train$Temp, data_train$Load)

#acf(data_train$Load, lag.max = 52*7)

#d_b = length(data_train$Date)-31*2
#plot( data_train$GovernmentResponseIndex[d_b:length((data_train$Date))] )







