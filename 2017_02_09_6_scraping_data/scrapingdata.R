require(rvest)
require(dplyr)
require(lubridate)
require(ggplot2)

###scrape climate data from a web-page

###initiate empty data frame

Tday1 <- data.frame() ###name the variable according to station

###try to loop through years
start_year <- 1973
stop_year <- 2016

for (j in start_year:stop_year){
  
  ###Loop for months
  ###put station identifier after ws- 
  for (i in 1:9) {
    url <- paste("http://en.tutiempo.net/climate/0",i,"-",j,"/ws-339020.html", sep="")
    
    weather <- read_html(url) %>%
      html_nodes("td:nth-child(2)") %>%
      html_text()
    
    weather2 <- weather[1:(length(weather)-17)]###Get rid of the last 17 elements
    weather2 <- as.numeric(weather2)
    weather_df <- as.data.frame(weather2)
    Tday1 <- rbind(Tday1, weather_df)
    
  }
  
  for (i in 10:12) {
    url <- paste("http://en.tutiempo.net/climate/",i,"-",j,"/ws-339020.html", sep="")
    
    weather <- read_html(url) %>%
      html_nodes("td:nth-child(2)") %>%
      html_text() 
    
    weather2 <- weather[1:(length(weather)-17)]###Get rid of the last 17 elements
    weather2 <- as.numeric(weather2)
    weather_df <- as.data.frame(weather2)
    Tday1 <- rbind(Tday1, weather_df)
  }
}

####create column with dates
Tday1$date <- seq(ymd('1973-01-01'), ymd('2016-12-31'), by='days')

###THen make separate columns for Julian day, Month and Year
Tday1$Julian <- yday(Tday1$date) ##I needed a grouping factor, yday provides a grouping factor, i.e. the Julian day

Tday1$Month <- month(Tday1$date, label=F)  ###a column with months

Tday1$Year <- format(Tday1$date,format="%Y") ###a column with the years, big Y needed for 4 digit year

###this computes the daily average over the time period
daily_tmean <- Tday1 %>%  group_by(Julian) %>% summarise(daily_mean = mean(weather2, na.rm=T))

###Base R solution for taking mean of daily temp for each month. 
Kherson_tmonth <- aggregate(weather2 ~ Month + Year, Kherson_tmean, mean) ###create new df with the average for each month (not total monthly average)

###dplyr solution for taking mean of each month. 
monthly_tmean <- Tday1 %>% group_by(Month, Year) %>% summarise(mean(weather2, na.rm=T)) %>% arrange(Year, Month)
colnames(monthly_tmean)[3] <- "Mean"
monthly_tmean$Y_M <- ymd(paste(monthly_tmean$Year, monthly_tmean$Month, '01', sep="-"))

###Filter to get the means for just one  month over the time period
aug_mean <- filter(monthly_tmean, Month == 8)

###plot montly monthly mean temp
month_plot <- ggplot(monthly_tmean, aes(x=Y_M, y=Mean)) + geom_line() + geom_smooth(method='lm')

###plot the aug mean temp over the time period
aug_plot <- ggplot(aug_mean, aes(x=Y_M, y=Mean)) + geom_line() + geom_smooth()

###Plotting daily temp for individual years against mean daily temp for whole time period

###Filter out daily temp for individual years
daily_2013 <- filter(Kherson_tmean, date > "2012-12-31" & date < "2014-01-01")
daily_2011 <- filter(Kherson_tmean, date > "2010-12-31" & date < "2012-01-01")

###Join these to df with mean daily temp
temp_comp <- full_join(daily_tmean, daily_2013, by="Julian")
temp_comp <- full_join(temp_comp, daily_2011, by='Julian')

###Give columns new names for ease of use
new_names <- c("Julian", "daily_mean", "daily_13", "date_13", "daily_11", "date_11")
colnames(temp_comp) <- new_names

###Plot daily temp for individual years against mean daily temp for all years
temp_plot <- ggplot(temp_comp, aes(x=date_13)) + 
  geom_line(aes(y=daily_mean, color="daily_mean"), size=3) + 
  geom_line(aes(y=daily_13, color='daily_13'), size=2) +
  geom_line(aes(y=daily_10, color='daily_11'), size=1) + 
  scale_x_date(date_breaks = "month", date_labels = "%b") +
  labs(x="Date", y="Daily air temperature") +
  theme_bw()



