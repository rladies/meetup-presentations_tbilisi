#set working directory
setwd("C:\\Users\\Nina\\Desktop\\Titanic_Data")

#load libraries and data
library (data.table) #Extension of `data.frame`
library (plyr)  #Tools for Splitting, Applying and Combining Data
library (stringr) #A consistent, simple and easy to use set of wrappers
train <- fread("train.csv",na.strings = c(""," ",NA,"NA"))

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


