#Second R-Ladies Tbilisi meetup - December 13,2016
#Prepared by Dinara Urazova and Liili Abuladze

#Vectors - basic building blocks in R; An object that consists of the same data type (e.g. numbers, strings, logical values)
#Vector is simply a list of values. R relies on vectors for many of its operations.
#Review - constructing basic numeric vectors
#c is short for "combine"
a<-c(1,2,3,4,5)
a
b<-c(6,7,8,9,10)

#Joining vectors:
ab<-c(a,b)
#Check the outcome:
ab
#Try ba - the same?
ba<-c(b,a)
#Check again the outcome:
ba

#What if we have a sequence of numbers from 1 to 10?
#using start:end notation
e <- 1:10
f <- 10:1
#print the outcome
e
f
str(e) #integer
#seq(from=1, to=10, by=1) --> this tells you that we create a sequence of numbers from 1 to 10 with a step of 1
#you can shorten the command by excluding "from", "to" and "by":
g <- seq(1, 10, 1)
g

#experiment with changing elements of seq 
h <- seq(1,10,0.5)
h
str(h)
i<-seq(10,1,-3) 
i

#Explore your data by using str() - this helps you to understand the types of variables the vector/ dataset has
str(ba)
str(a)

#There are other ways to create and manipulate numeric vectors, which can be learned individually


#What about non-numeric vectors?
countries<- c("Georgia", "Armenia", "Azerbaijan")
countries
str(countries)


#Get the second value of the "countries" array (also works with numeric vectors)
countries[2]

#R's vector indices start at 1 (not 0). Get the first value:
countries[1]

#Add another value
countries[4]<-"Poland"
countries

#add several values at the same time
countries[c(4,5)]<-c("Poland", "Hungary")
countries

#Get the first and the third value
countries[c(1, 3)]

#Get a range of values
countries[3:5]

#Creating other objects, like sex, ethnicity, religion, etc.
#Let 1 stand for "Female" and 2 for "Male" - we make it a "factor" variable - a categorical (not numerical)
sex <- factor(c(1,2,2,1,2,1,1,2)) 
sex
str(sex) #this tells you that "sex" is indeed a factor variable

#lets create another vector with similar length to be used together with sex
age <- c(20, 34, 56, 33, 78, 35, 12, 92)
str(age) #numerical var, so this is different from "sex" which is factor
age1 <-age[sex==1] #this creates a new variable for age of women only (sex=1 stands for females)
age1
mean(age1)


#A vector has 1 dimension, a dataframe 2 dimensions
#A dataframe can have different data types for each column (dates, numbers, factors). 
#A dataframe is a list with equal length vectors at each index.
#Creating a dataframe
X <- data.frame(S=sex, A=age)
X
#Explore the types of data in your dataframe by using str()
str(X) #we see that S is a factor variable, and A is a numerical variable

#And saving:
save(X,file="mydata.Rda")
#where is the file? In the general Documents directory.

#Store your data
write.table(X, file="mydata.txt", col.names = TRUE) #col.names=T helps to separate columns in the data



#How about data that is already available
#First tell R where to find the dataset
#setwd("C:/Users/Dinara/Desktop/Data/")

setwd("C:/Users/KASUTAJA/Documents/RLadies")
#Import dataset --> for txt files use read.table
newdata <- read.table(file="data1.txt", header = FALSE, sep = " ")
#header=F means that the first row will not include variable names, header=T would mean that first row includes variable names
#sep="\t" tells R that the file is tab-delimited (use " " for space delimited and "," for comma delimited; use "," for a .csv file).
newdata

#Lets import another dataset - this one is an Excel file --> use read.csv for Excel files
Cars_data <- read.csv(file = "cars.csv")
Cars_data
#For STATA files use read.dta, for SPSS files use read.spss, for .txt files use read.txt

#If you want to share an object with someone else in text format (e.g. to get r help :)), use dput
dput(newdata)


#There are several datasets online. Load them:
data("mtcars")
data("longley")
data("USArrests")
data("VADeaths")


#Explore the first 6 rows of your data by using head()
head(newdata)
head(mtcars)
#similarly you can explore the last 6 rows by using tail()
tail(newdata)
tail(VADeaths)

#In addition to head, tail and str there are other useful exploration commands
class(newdata) #tells you whether it is a dataframe, matrix, etc.
class(mtcars)
class(VADeaths)
dim(newdata) #tells you what are the dimensions of the dataset
dim(mtcars)
summary(newdata) #summarises the dataset
View(newdata) #opens a separate viewing window of the dataset
#?<name of data set>
?mtcars #describes the dataset in the right pane

#Selecting and subsetting a dataframe
names(mtcars) #see the names of the variables
#subsetting the first 10 observations(=rows) of mtcars
mtcars2<- mtcars[1:10,] #having a space after the comma is interntional --> this indicates that we want to include all columns in the new dataset
mtcars2
mtcars2<- mtcars[1:10,1]

#you can also include all rows, but select a set of columns
#[, 1:10]

hist(mtcars$disp)
#"subset" subsets dataframe by observations (=rows)
#subsetting observations where disp is below the value of 300
#using the subset function we don't need to tell R where variable "disp" is
mtcars3<- subset(mtcars, disp<300)
mtcars3

#subsetting by both observations(rows) and variables(columns)
#The select argument lets you subset variables (columns).
mtcars4<-subset(mtcars, disp<300 & gear>2, select=c(mpg:am))
mtcars4


#to repeat a value
rep("Yo ho!", times = 3)
rep(1:5, 3)
rep(c(1,2,3), 10)

#List the objects in your environment
ls()
#Remove any objects if necessary
rm()
rm(mtcars4)

#Let's do a simple plot
summary(USArrests)
plot(USArrests$Murder, USArrests$UrbanPop)

#for practice swirl is useful to do basic expressions in R
#after each session you can use this at home to learn more
install.packages("swirl")
library(swirl)
install_from_swirl("R Programming Alt")  # this may take a while (10-30 min)
swirl()
#follow instructions
#to exit: esc
#to continue, type library(swirl)
