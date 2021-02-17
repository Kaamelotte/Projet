rm(list=objects())
download.packages("ranger")
library(tidyverse)
library(forecast)
library(lubridate)
library(xts)
library(ranger)
library(Metrics)
setwd("D:/Documents/SIM202/")


Data0=read_delim("Data/train_V2.csv",delim=",")
Data1=read_delim("Data/test_V2.csv",delim=",")
#Train vraie conso
#Test variables explicatives


summary(Data0)
str(Data0)

range(Data1$Date)
names(Data0)

plot(Data0$Date,Data0$Load, xlab="Date", ylab="Consommation(MW)", type="l", col="5")
title("Consommation (MW) en fonction de la date")

plot(Data0$toy,Data0$Load, xlab="Période de l'année", ylab="Consommation(MW)", pch=20, col="10")
title("Consommation (MW) sur une année")

plot(Data0$Temp,Data0$Load, xlab="Température (°C)", ylab="Consommation(MW)",pch=20, col="10")
title("Consommation (MW) en fonction de la température")
reglin=lm(Load~Temp,data=Data0)
points(Data0$Temp,reglin$fitted.values)


#Temps95-99: coef de lissage dynamique, pondération des valeurs: prio aux valeurs.
a=1
b=a+7*52*8
plot(Data0$Date[a:b],Data0$Temp[a:b],type='l')
lines(Data0$Date[a:b],Data0$Temp_s95[a:b],type='l',col='red')
lines(Data0$Date[a:b],Data0$Temp_s99[a:b],type='l',col='blue')

#Corrélation de la consommation par rapport à elle même dans le passé
acf(Data0$Load, lag.max=52*7)


#as.factor pour transformer en variable qualitative, et ne pas garder les strings
#Var qualitative en fonction de quantitative: R fait des boxplots sur tout l'échantillon, par jour de la semaine
#Les boxplots sont assez larges car variabilité dans les données plus forte que hebdomadaire: saisonnière
plot(as.factor(Data0$WeekDays),Data0$Load, xlab="jour de la semaine", ylab="Consommation(MW)",pch=20, col="10")

#On peut voir l'impact hebdomadaire:
#Petit drop en mai à cause des jours fériés: les usines ferment
#La conso résidentielle augmente et usine baisse pendant le confinement 2020, constat en conf' 2020: Se leve et couche plus tard et ça a shift le load
plot(Data0$Date[a:b],Data0$Load[a:b], xlab="Date", ylab="Consommation(MW)", type="l", col="5")
title("Consommation (MW) en fonction de la date")


#Pour les graphes: par(mfrow=c(1,1),add=T)


d1=which(as.character(Data0$Date)=="2020-04-15")
range(Data0$Date, Data1$Date)

plot(Data0$Date, Data0$Load, type='l', xlim=range(Data0$Date, Data1$Date))
lines(Data1$Date, meann$mean , col='red')
lines(Data1$Date, naivem$mean, col=3, lty=1)
lines(Data1$Date, driftm$mean, col=2, lty=1)
lines(Data1$Date, snaivem$mean, col=6, lty=1)
legend("topleft",  lty=1, col=c(1,3,2,6), 
       legend=c("Mean method", "Naive method", "Drift method", "Seasonal naive"))


length(Data1$Date)
length(Data0$Date)
seq(1,276)
Load0.update=Data0$Load
#Modeles naifs
#-----------------------
for (i in seq(1, 276))
{
  meann=meanf(Load0.update, h=1)
  meann$mean
  
  Load0.update<-rbind(Load0.update, meann$mean)
  
}



t <- c(1:length(Data0$Load))  

meann=meanf(Data0$Load, h=1)
naivem=naive(Data0$Load, h=1)
driftm=rwf(Data0$Load, h=1, drift=T)
snaivem=snaive(Data0$Load, h=1)



plot(meann, type='l')
lines(naivem$mean, col=3, lty=1)
lines(driftm$mean, col=2, lty=1)
lines(snaivem$mean, col=6, lty=1)
legend("topleft",  lty=1, col=c(1,3,2,6), 
       legend=c("Mean method", "Naive method", "Drift method", "Seasonal naive"))

#-------------

#Regrssion linéaire "à la main"
X=as.matrix(cbind(1,Data0$Temp, Data0$toy, Data0$GovernmentResponseIndex)) #Variables expli+intercept
Y = as.matrix(Data0$Load) #Variable a expliquer

Load.esti_lin=solve(t(X)%*%X)%*% t(X)%*%Y

n = length(Y)
p = ncol(X)
#On suppose que le bruit est gaussien de variance inconnue
sigma.est = sqrt(sum( (X%*%Load.esti_lin -Y)^2   )/(n-p)) 
V = solve(t(X)%*%X) *sigma.est^2
stddev = sqrt(diag(V))

plot(Data0$Load,X%*%Load.esti_lin,xlab="Conso observee", ylab="Conso estimée")
abline(0,1, col='red')

#Regression linéaire avec lm (toutes les variables)
res=lm(Data0$Load~.,data=Data0)

summary(res)
loaddddd=c(Load.lm,seq(1,275)*0)
Load.lm=res$fitted
plot(loaddddd)
points(Data0$Load, col='red')

rmse(Data0$Load, res$fitted)

res.predict <- predict(res, newdata=Data1)
rmse(Data1$Load.7, res.predict)

pointsss=c(seq(1,3000)*0,res.predict)
plot(Data1$Load.1)
points(pointsss, col=seq(1,3275))


###########Exemple de soumission 


which(is.na(res.predict))

submit <- read.csv(file="D:/Documents/SIM202/Data/sample_submission_V2.csv", sep=",", dec=".")
submit$Appliances <- res.predict

write.table(submit, file="Data/submission_lm.csv", quote=F, sep=",", dec='.',row.names = F)

pairs(Data0$Load)
cor(Data0$Load, Data0$toy)
