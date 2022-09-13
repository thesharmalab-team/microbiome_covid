#install.packages("plyr")
#install.packages("data.table")
library(plyr)
library(dplyr)
library(magrittr)
library("data.table")

#reading Covid data in csv format from 'Our World Data'
owid.covid.data <- read.csv("~/Documents/Research Project MRes/owid.covid.data.csv")
#keep only hospitalisations, location and date
covid_hosp <- owid.covid.data[c("location","hosp_patients", "date", 
                                "aged_70_older", "gdp_per_capita", "human_development_index")]
#removing NAs in the data
covid <- na.omit(covid_hosp) 
#filter for pre-vaccination data -> before 1st December 2020
covid1 <- subset(covid, date< "2020-12-01")
#duplicate dataset
covid2 <- covid1
#remove 'date' column 
covid3 <- covid2[c("location","hosp_patients", 
                  "aged_70_older", "gdp_per_capita", "human_development_index")]
covid_var <- covid2[c("location","aged_70_older", "gdp_per_capita", "human_development_index")]
#sum up data for each 'location'
covid4 <- setkey(setDT(covid3), location)[, 
                                list(hosp_patients=sum(hosp_patients)), by=list(location)]
#Dataframe with first and last date of hospitalised patients (time frame)
covid5 <- covid2 %>% group_by(location) %>% summarise(FirsDate=first(date),LastDate=last(date))
#combine both datasets together 
covid_final <- merge(covid5,covid4,by="location")
#get one measure for each variable per country
covid_var1 <- ddply(.data = covid_var, .var = c("location"), .fun = function(x) x[1,])
#combine variables to dataset
covid_final1 <- merge(covid_final,covid_var1,by="location")
#save as csv
write.csv(covid_final1,"~/Documents/Research Project MRes/Covid_Final.csv", row.names = TRUE)
