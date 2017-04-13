#Beginners' Drop In April 6, 2017
#this is a comment - good for including explanations of your code
#r does not execute the line behind the hash sign

#in order to get the directory you are working in, type:
getwd()

#when you want to set your directory
setwd("C:/Users/KASUTAJA/Documents")
#you might need to change the direction of slashes not to get error message

#to get help or explanation of a command
#if the information doesn't load, restart R again
help(getwd)
?sum
example(sum)

#we use packages to access different commands for different purposes
#you have to install and load the packages
install.packages("swirl")      
library("swirl")

#Use R as calculator
3+4
3*4
2*3*4
2^4

#You can use different functions
#Summing 3 and 4 is the same as 3+4
sum(3:4)

#replicate a raneg of values (1-3) twice
rep(1:3, 2)

#square root
sqrt(9)

#Assigning values to an object
x<-2 
x
3->y
y
z=4
z
#all these three options give the same result

#Logical vectors
#T and F often stand for TRUE and FALSE
T==FALSE
3>4 #R will tell you this is not correct
3<4 #R will tell you this is correct

u<-"Text"
u


#list all the files in your directory
list.files()

#list all the objects in your envrionment
ls()

#remove objects in your environment
rm()
help(rm)
ls()
rm(a)
#remove ALL objects in your environment
rm(list=ls())

#basic vectors
x<-2
x
x/2
x

#a vector consisting of several elements
#c stands for column bind
y<-c(1,2,3,4)
y
z<-c(1,2,3,4,5,6,7,8,9,10)
z
#a shorter way to get the same result as in the previous code line
t<-c(1:10)
t
mean(z)
median(z)

#let's have a look at the swirl package
#we installed and loaded it earlier, so it should work now
swirl()
#follow the instructions swirl gives you. first it wants to know my name
liili
#to exit swirl
0
bye()

#to quit R
q()
#type n not to save the workspace in R
n
