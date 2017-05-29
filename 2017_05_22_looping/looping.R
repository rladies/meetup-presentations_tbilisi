setwd("C:/Users/KASUTAJA/Documents/RLadies/Looping")

library(dplyr)
library(tidyr)
install.packages("countrycode") #codes country names into intnl org's classifications
install.packages("countrycode")
library(countrycode) 
install.packages("tibble")
library(tibble) #tibble - devt of dataframe
library(ggplot2)

require(dplyr)
require(tidyr)

#download data from FAO website (fao.org) -> Data -> Crops
#Looping
wheat<-read.csv("wheat_yield.csv", header=T)
wheat[,c(1:3, 5:9, 11, 13:14)] <- NULL #get rid of these columns

#long > wide -- spread, create new df
wheat<- spread(wheat, key=Area, value=Value) #key will become column header
wheat<- wheat[, c(2:134)] / 10000 #divide all columns, get rid of 1st column (year)

#create separate year vector
year <- 1961:2014
year
class(year)
class(wheat)

#want to see the wheat yield trends
#two method for looping
#matrix method for looping and performing linear regression
#create new df-s first, can be used as a matrix for diff calculations
df <- matrix(NA, nrow=ncol(wheat), ncol=1) #first fill w NA -> this will be for r2
cf <- matrix(NA, nrow=ncol(wheat), ncol=2) #coefficients - need two values
pval <- matrix(NA, nrow=ncol(wheat), ncol=2) #also need two values

for (i in 1:ncol(wheat)) { #go through column 1 to end
  result <- lm(wheat[[i]]~year) #double brackets - go through columns, regresses on yr, will put the lm into object called result, will do it repeatedly for each country
  df[i] = summary(result)$r.squared
  cf [i,] = coefficients(result) #put in i-th row, both columns; slope & intercept
  pval[i,] = summary(result)$coef[,4] #4th column bc pvalue's position is 4th, all rows
}

result

#rbind looping - slow if have a lot of data
r_sqr <- data.frame()
coeff<- data.frame()
pvalues<- data.frame()

for (i in 1:ncol(wheat)) { #go through column 1 to end
  result <- lm(wheat[[i]]~year) #double brackets - go through columns, regresses on yr, will put the lm into object called result, will do it repeatedly for each country
  df = summary(result)$r.squared
  cf = coefficients(result) #put in i-th row, both columns; slope & intercept
  pval = summary(result)$coef[,4] #4th column bc pvalue's position is 4th, all rows
  r_sqr <- rbind(r_sqr, df)
  coeff <- rbind(coeff, cf)
  pvalues <- rbind(pvalues,pval)
  }


reg_test <- cbind(r_sqr, coeff, pvalues)


countries<-colnames(wheat)
rownames(reg_test)<-countries
columns <- c("r2_linear", "intercept", "slope", "p_intercept", "p_slope")
colnames(reg_test)<- columns #get linear regr results for all countries in one set

#polynomial regression
r_sqr <- data.frame()
coeff<- data.frame()
pvalues<- data.frame()

for (j in 1:ncol(wheat)) { #go through column 1 to end
  result <- lm(wheat[[j]] ~ year + I(year^2)) #double brackets - go through columns, regresses on yr, will put the lm into object called result, will do it repeatedly for each country+polyn regr
  df = summary(result)$r.squared
  cf = coefficients(result) #put in i-th row, both columns; slope & intercept
  pval = summary(result)$coef[,4] #4th column bc pvalue's position is 4th, all rows
  r_sqr <- rbind(r_sqr, df)
  coeff <- rbind(coeff, cf)
  pvalues <- rbind(pvalues,pval)
}

reg.test2 <- cbind(r_sqr, coeff, pvalues)

#names(summaryobject) gives a list in lm model

#third loop to get f-test
ftest_p <- matrix(NA, nrow=ncol(wheat), ncol=1)
#when predfeine as matrix, have to put the position in the loop

#pf gives the f-distribution
#unname command gives a value and attribute of that value
for (k in 1:133) {
  result <- lm(wheat[[k]] ~year + I(year^2))
  sm <- summary(result)
  ftest_p[k] <- unname(pf(sm$fstatistic[1], sm$fstatistic[2], sm$fstatistics[3], lower.tail=F))
}

#pf calculates f-test value based 

#import population and gdp data and join to reg_test3
world_pop <- read.csv("world_pop.csv", header=T, na.strings="..") #na.strings for WB NA data

world_pop[, c(1:3)] <- NULL #all rows of col 1- 3 should be deleted

world_pop <- world_pop[1:217,]
pop_countries <- world_pop$country.Code
pop_countries2 <- as.character(pop_countries) 
world_pop <- world_pop[,2:57]
rownames(world_pop)<- pop_countries2

#r doesnt like numbers for column names
#summarise_each is from dplyr - by columns
#mutate - to create col from 2 cols, transmute - same thing, but want to have the outcome as sep df

#country.name is a parameter in countrycode pckg
#join - column names have to be same in tibble pckg: rownames to col
#innerjoin - join 2 datasets, remove rows if they are not the same


?subset
