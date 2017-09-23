###############################
## R-Ladies Tbilisi         ###
## 23.09.2017               ###
###############################

## PRACTICAL SESSION 1 ##

#1. Set your working directory
getwd()
setwd("C:/Users/KASUTAJA/Documents/RLadies/workshop")

#2. Create six objects named var0, var1, var2, var3, var4, var5, var6, var7
#with the following content: 5, 2+2, 4*5, 240/60, 4^15, ´this is", "my object", "5"

var0 <- 5
var1 <- 2+2
var1 #prints the outcome

var2 <- 4*5
var2 #prints the outcome
var3 <- 240/60
var4 <- 4^5
var5 <- "this is"
var6 <- "my object"
var7 <- "5"

#3. What is the difference between var0 and var7? 
class(var0)
class(var7)

#class tells you that var0 is numeric (5), var7 is character ("5") because we defined them as such when we created them

#4. Do a summing operation with var0 and var3.
# There are two ways to do that

var0+var3

sum(var0, var3)

#Both give the same answer: 9

#5. Paste var5 and var6 into var56.
var56 <- paste(var5, var6)

#6.Install the following packages: foreign, readr. Load them.
install.packages("foreign")
install.packages("readr")

library("foreign")
library("readr")

#7.Read about these packages - what are they for?
#Three ways to read: help, ? or choose from the "Packages" tab
help(foreign)
help(readr)

#Both packages are for reading in (importing) data from other formats into R

#8. Save your R file in your working directory.

#Go to File--> Save as


## PRACTICAL SESSION 2 ##

#1. Load data ´iris¡ from the R datasets
data(iris)


#2.Explore the dataset. 
class(iris)

#How many variables does it include? 
#What is the factor variable called? 
str(iris)

#It includes 5 variables: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species
#The factor variables is called "Species"

#How many levels does the factor variable have?
levels(iris$Species)

#It has three levels: setosa, versicolor and virginica


#3. What species are the first observations in the dataset from?
head(iris$Species)

#All are setosa species

#If you want to check more than six observations, select them
iris$Species[1:20]

#Still the first 20 are setosa species


#5. What is the maximum value of each variable in the dataset?
summary(iris)

#7.900, 4.400, 6.900, 2.500


#6. Run a frequency (flat contingency) table of the "Petal.Width" variable
ftable(iris$Petal.Width)

#7. Create a new object "sep_length" with the first 10 values of "Sepal.Length" variable.
sep_length <- iris$Sepal.Length[1:10]
sep_length

#8. Save the file as a csv file in your working directory.
write.csv(iris, "iris2.csv")
