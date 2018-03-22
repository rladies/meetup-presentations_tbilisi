rm(list=ls()) #clear all the object
#set working directory
setwd("C:\\Users\\Nina\\Desktop")
train <- fread("titanic.csv",na.strings = c(""," ",NA,"NA"))

#load libraries and data
library (data.table) #Extension of `data.frame`
library (plyr)  #Tools for Splitting, Applying and Combining Data
library (stringr) #A consistent, simple and easy to string manipulations


head(train)

str(train)

#check missing values
colSums(is.na(train))

#Quick Data Exploration
summary(train$Age)
summary(train$Fare)

train[,.N/nrow(train),Pclass]
train [,.N/nrow(train),Sex]
train [,.N/nrow(train),SibSp]
train [,.N/nrow(train),Parch]
nino <- train [,.N/nrow(train),Cabin]



#Impute Age with Median
for(i in "Age")
  set(train,i = which(is.na(train[[i]])),j=i,value = median(train$Age,na.rm = T))
summary(is.na(train$Age))

#Remove rows containing NA from Embarked
train <- train[!is.na(Embarked)]

#Impute Fare with Median
for(i in "Fare")
  set(train,i = which(is.na(train[[i]])),j=i,value = median(train$Fare,na.rm = T))

summary(is.na(train$Fare))
#Replace missing values in Cabin with "Miss"
train [is.na(Cabin),Cabin := "Miss"]

#Log Transform Fare
hist(train$Fare)
Fare_log <- log(train$Fare)
hist(Fare_log)
hist(train$Age)


#linear model
model1 <- lm(Fare ~ Age + Sex, train)
summary(model1)

#library dplyr with functions: select, mutate and filter

rm(list=ls()) #clear all the object

library(dplyr)
library(hflights)
head(hflights)
summary(hflights)
dim(hflights)

# Convert the hflights data.frame into a hflights tbl
hflights <- tbl_df(hflights)

# Display the hflights tbl
hflights

# Create the object carriers
carriers <- hflights$UniqueCarrier
class(hflights)


two <- c("AA", "AS")
lut <- c("AA" = "American", 
         "AS" = "Alaska", 
         "B6" = "JetBlue")
two <- lut[two]
two
glimpse(hflights$UniqueCarrier)
unique(hflights$UniqueCarrier)

lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue", "CO" = "Continental", 
         "DL" = "Delta", "OO" = "SkyWest", "UA" = "United", "US" = "US_Airways", 
         "WN" = "Southwest", "EV" = "Atlantic_Southeast", "F9" = "Frontier", 
         "FL" = "AirTran", "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")

# Add the Carrier column to hflights
hflights$UniqueCarrier <- lut[hflights$UniqueCarrier]
unique(hflights$UniqueCarrier)


lut <- c("A" = "carrier", "B" = "weather", "C" = "FFA", "D" = "security", "E" = "not cancelled")

# Add the Code column
unique(hflights$CancellationCode)
hflights$Code <- lut[hflights$CancellationCode]

# Glimpse function
glimpse(hflights)

#several examples how to use select function
select(hflights, ActualElapsedTime, AirTime, ArrDelay, DepDelay)
select(hflights, Origin:Cancelled)
select(hflights, - (DepTime:AirTime))
select(hflights, ends_with("Delay"))
select(hflights, UniqueCarrier, ends_with("Num"), starts_with("Cancel"))


# comparing base r-code and dplyr code
ex1r <- hflights[c("TaxiIn", "TaxiOut", "Distance")]
ex1d <- select(hflights,TaxiIn, TaxiOut, Distance)

ex2r <- hflights[c("Year", "Month", "DayOfWeek", "DepTime", "ArrTime")]
ex2d <- select(hflights,Year, Month, DayOfWeek, DepTime, ArrTime)

ex3r <- hflights[c("TailNum", "TaxiIn", "TaxiOut")]
ex3d <- select(hflights,TailNum, TaxiIn, TaxiOut)


# examples how to use mutate
g1 <- mutate(hflights, ActualGroundTime = ActualElapsedTime - AirTime)
m1 <- mutate(hflights, loss = ArrDelay - DepDelay, loss_ratio = loss / DepDelay)
m2 <- mutate(hflights, TotalTaxi = TaxiIn + TaxiOut, 
             ActualGroundTime = ActualElapsedTime - AirTime,
             Diff = TotalTaxi - ActualGroundTime)


# Filter function
filter(hflights, Distance >= 3000)
filter(hflights, UniqueCarrier %in% c("JetBlue", "Southwest", "Delta"))
filter(hflights, TaxiIn + TaxiOut > AirTime)
filter(hflights, DepTime < 500 | ArrTime > 2200)
filter(hflights, DepDelay > 0, ArrDelay < 0)
filter(hflights, Cancelled == 1, DepDelay > 0)





