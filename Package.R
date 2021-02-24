
#install.packages("usethis")
#install.packages("devtools")
#install.packages("roxygen2")

library(usethis)
library(devtools)
library(roxygen2)
library(tidyverse)
library(lubridate)



#######################################################################################
#_______________________________Creation du package __________________________________#
#######################################################################################
#A mettre dans une console quelconque
mydir <- "/Users/caill/Documents/GitHub/SIM202/Packages/"
mypackage <- "Projet.SIM202"
path <- file.path(mydir, mypackage)

unlink(path, recursive=TRUE)

my_description<-list("Title" = "Lockdown period Load forecasting",
                     "Version" ="0.0",
                     "Authors@R"= c("person('Antoine', 'Caillebotte')","person('Pablo', 'Le Guern-Fiallo')"),
                     "Description" = "Lockdown period Load forecasting",
                     "License" = "GPL-3"
)


create_package(path, my_description, open=FALSE)





#######################################################################################
#_________________________________Ajout de données ___________________________________#
#######################################################################################
#a mettre dans la console correspondant au projet du package !
data_train <- read_delim(file = "C:/Users/caill/Documents/GitHub/SIM202-Projet/data/train.csv", delim=",")

setwd("C:/Users/caill/Documents/GitHub/SIM202/Packages/Projet.SIM202/")
usethis::use_data(data_train)


data_test <- read_delim(file = "C:/Users/caill/Documents/GitHub/SIM202-Projet/data/test.csv", delim=",")

setwd("C:\Users\caill\Documents\GitHub\SIM202\Packages\Projet.SIM202")
usethis::use_data(data_test)










