require(rvest)
require(dplyr)
require(lubridate)
require(ggplot2)


setwd("C:/ whatever your directory is...")

###initiate empty data frame

Tday_Tbilisi3 <- data.frame() ###name the variable according to station

###create objeccts to help loop throu years 
start_year <- 2016
stop_year <- 2016

for (j in start_year:stop_year){
  ### this first "j" loop, goes through years if you have multiple years
  ###Loop for months
  ###put station identifier after ws- 
  for (i in 1:9) {
    url <- paste("http://en.tutiempo.net/climate/0",i,"-",j,"/ws-375490.html", sep="")
    ###The following code captures the column with average daily temp and makes it text
    weather <- read_html(url) %>%
      html_nodes("td:nth-child(2)") %>%
      html_text()
    ###Here we remove unnecessary information and convert character to number in df
    weather2 <- weather[4:(length(weather)-15)]###Get rid of unnecessary elements
    weather2 <- as.numeric(weather2)
    weather_df <- as.data.frame(weather2)
    Tday_Tbilisi3 <- rbind(Tday_Tbilisi3, weather_df)
    
  }
  ###months 10 - 12 have to be done separately
  for (i in 10:12) {
    url <- paste("http://en.tutiempo.net/climate/",i,"-",j,"/ws-375490.html", sep="")
    
    weather <- read_html(url) %>%
      html_nodes("td:nth-child(2)") %>%
      html_text() 
    
    weather2 <- weather[4:(length(weather)-15)]###Get rid of the last 15 elements
    weather2 <- as.numeric(weather2)
    weather_df <- as.data.frame(weather2)
    Tday_Tbilisi3 <- rbind(Tday_Tbilisi3, weather_df)
  }
}

###Create a new column with dates to match with the data (a column of data type "date")
Tday_Tbilisi3$date <- seq(ymd('2016-01-01'), ymd('2016-12-31'), by='days')

###Plot the average daily temp for Tbilisi 2016 
Tday_2016 <- ggplot(Tday_Tbilisi3, aes(x=date, y=weather2)) + geom_line(size=2, color="red")
