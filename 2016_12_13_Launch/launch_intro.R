
#1st launch session - R-Ladies Tbilisi, December 8, 2016

#Welcome!
#By using a hash-sign, the text will appear in green. You can use this text
#as comments for yourself or as explanation of what you're doing. This text 
#is not treated as commands.

#Operators: R can be used as a calculator
#Basic operations: +, -, *, /, ^, sqrt(). Type in the following and see the outcome in the pane below
2+5
8*19
7^7

#Vectors - creating a vector, assigning values to the vector, mean, mode, median, plotting it
# <- is used for assignment
vector <- c(1,2,3,4,5,6,7,8,9,10)
#check the vector by running it
vector
#get the mean value of the values of the vector
mean(vector)
#get the median value of the vector
median(vector)
#if you want to know what "mean" command does, type "?"-mark. An explanation
#appears in the pane on the right
?mean

#lets create another vector
vector1 <- c(1,1,1,1,2,2,2,3,3,3,3,3,87,91)
mean(vector1)
#better to use median - accounts better for outliers
median(vector1)

#ls() lists all objects in our environment - vectors we created, any existing dataset
ls()

#to remove an object
rm(vector)

#if you run ls() again you will see an updated list with all existing objects in your R environment
ls()

#library(package_name) is used to load packages
