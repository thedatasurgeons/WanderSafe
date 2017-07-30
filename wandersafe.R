# install.packages("rgdal")
#library(rgdal)
#library(tmap)
#library(sp)
#library(mapproj)
install.packages(c("UsingR", "manipulate","reshape" ))
library(UsingR); 
library(manipulate)
library(reshape); 
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(data.table)
library(knitr)
library(stringr)
# Read crimedata  -------------------------------------------
crime_data <-read.csv("data.csv", colClasses = "character", na.strings = c("", "NA"))
View(head(crime_data, 100))
#-------------compute statistics - Meshblock-----------------

crime_data_processed <- crime_data %>% mutate(Occurrence.Hour.of.Day=as.numeric(Occurrence.Hour.of.Day)) %>%
                  group_by(Meshblock, Reported.Year.and.Month, Occurrence.Day) %>% 
                    mutate(time_of_day=ifelse(Occurrence.Hour.of.Day>6 & Occurrence.Hour.of.Day<=9, "morning", 
                                          ifelse(Occurrence.Hour.of.Day>9 & Occurrence.Hour.of.Day<=18, "afternoon", 
                                                 ifelse(Occurrence.Hour.of.Day>18 & Occurrence.Hour.of.Day<=21, "evening", 
                                                      ifelse((Occurrence.Hour.of.Day>21 & Occurrence.Hour.of.Day<=24) | 
                                                               Occurrence.Hour.of.Day<=6, "night", "unkown"))
                                          )
                                          ))  

crime_data_tod <- crime_data_processed %>% group_by(Meshblock,time_of_day) %>% 
              summarise( numb_crime_tod=n()) 

View(head(crime_data_processed, 20000))
#---------------------------------trend
trend<-crime_data%>% group_by(Meshblock, Reported.Year.and.Month) %>% 
               summarise( numb_crime=n())

trend <- trend %>% arrange(Meshblock, Reported.Year.and.Month) %>% 
                 group_by(Meshblock) %>% mutate(   first_month= sum(ifelse(Reported.Year.and.Month=="2017/05", numb_crime, 0) ), 
                                                   second_month=sum(ifelse(Reported.Year.and.Month=="2017/06", numb_crime, 0)  )) %>% 
                mutate(trend=ifelse(second_month>first_month, "Up",
                                     ifelse(second_month==first_month, "same", "down")))

trend <- trend %>% group_by(Meshblock) %>% summarise(numb_crime=sum(numb_crime), 
                                                   first_month=max(first_month), 
                                                   second_month=max(second_month), 
                                                   trend=max(trend))
View(head(trend, 20000))

#-----------merge with trend data ------------
# crime_data_processed <- crime_data_processed %>% ungroup()
# trend<-trend %>% ungroup()

crime_data_merged <- crime_data_processed %>% left_join(trend, by="Meshblock")
crime_data_merged <- crime_data_merged %>% left_join(crime_data_tod, by=c("Meshblock", "time_of_day"))
View(head(crime_data_merged, 20000))

#-----------merge with Stats NZ geograpies to find bounding box 
data <-read.csv("mb_geo.csv", colClasses = "character", na.strings = c("", "NA"))
setnames(data, "MB2017", "Meshblock")
#------merge with geography
crime_data_polygon<- crime_data_merged %>% left_join(data, by="Meshblock") %>% na.omit()
View( head(  crime_data_polygon, 100))
#-------remove extra data 
rm(data, crime_data)
gc()

write.csv(crime_data_polygon, "crime_data_with_geo.csv")

#--------Visualization ------------
ggplot(by_hour, aes(by_hour$Occurrence.Day, fre))
ggplot(by_hour,aes(three_days_by_hr$i_date, fill = three_days_by_hr$i_date)) + 
  geom_bar(position = "fill")  +
  scale_fill_discrete(name="Gender")+
  labs(title="Response by mode and gender", 
       x="mode", 
       y="count")
#----------------------------------