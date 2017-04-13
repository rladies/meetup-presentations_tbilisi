getwd()
setwd("C:/Users/keti/Desktop/ceu stats folder")
library(foreign)
cb15<-read.dta("cb15nr.dta")
read.

read.spss("cb15nr")
# functions
#function_name <- function(arg1, arg2){
#Manipulate arguments in some way
#Return a value
#}

# The "variable name" you assign will become the name of your function. arg1 and
# arg2 represent the arguments of your function. You can manipulate the arguments
# you specify within the function. After sourcing the function, you can use the 
# function by typing:
# 
# function_name(value1, value2)
#
# Below we will create a function called boring_function. This function takes
# the argument `x` as input, and returns the value of x without modifying it.

boring_function <- function(x) {
  x
}








z<-"stata stinks R is better"

boring_function(z)
names(cb15)
print(z)
names(cb15)

#we've created the equivalent of a print function

boring_function(cb15$n13)

#lets try something a little bit more interesting

minimean <- function(x) {
  sum(x)/length(x)
}

## let's try our mean now

a<-sample(1000,100, replace = FALSE)
minimean(a)

## now let's try out our function with some real data

minimean(cb15$n14)






#### why isn't it working?
### ok, so how can you fix that?












## answer
meanmeanmean <- function(x) {
  sum(na.omit(x))/length(na.omit(x))
}

meanmeanmean(cb15$n14)



### alright, so now let's write a t-test
### but what is a t-test?







## write an independent samples t-test formula without using your mean
## t= mean1-mean2 divided by
## square root of the standard deviation squared 
## divided by sample size of sample 1 plus the same for sample 2 population 2









tt<-function(a,b){
  ((mean(a)-mean(b)) / 
     
     (sqrt((sd(a)^2/(length(a)))+(sd(b)^2/(length(b))))))
}

## test your function using the following variables, x and y
## (sample generates a random sample; the first number provides the highest number to draw from)
## (the second number is the sample size)
##  replace = false means the sampling does not use replacement

x<-sample(100000, 1000, replace = FALSE)
y<-sample(100000, 1000, replace = FALSE)

tt(x,y)

##check if your function worked using t-test 
##variance equals true leaves this t-test as a simple two sample rather than 
##going to Welch's which is the default test
t.test(x,y)



#a good way of learning about how to write functions is looking at 
# other peoples functions with stats, a simple way to do this is

#find out the different sets of code
methods(t.test)

## list the package and then the set of code you want to see
stats:::t.test.default


## ok, now all the coding stuff is done. Let's  try using a t-test
## let's test whether there is a difference

## between whether men and women trust the army the same

cb15$gender<-as.numeric(cb15$sex)
table(cb15$gender)
cb15$gender[cb15$gender==1]<-NA
cb15$army<-as.numeric(cb15$p4_05)
table(cb15$army)
table(cb15$p4_05)
cb15$army[cb15$army<=5]<-NA
men<-subset(cb15, cb15$gender==4)
women<-subset(cb15, cb15$gender==5)
t.test(men$army,women$army)

##between whether men and women trust banks the same
cb15$banks<-as.numeric(cb15$p4_02)
table(cb15$banks)
cb15$banks[cb15$banks<=5]<-NA
men<-subset(cb15, cb15$gender==4)
women<-subset(cb15, cb15$gender==5)
t.test(men$banks,women$banks)

#between whether ethnic minorities and majorities trust the EU the same
cb15$min<-as.numeric(cb15$d1)
table(cb15$d1)
table(cb15$min)
cb15$min[cb15$min<=5]<-NA
cb15$min[cb15$min!=8]<-1
cb15$min[cb15$min==8]<-0
table(cb15$min)

cb15$EU<-as.numeric(cb15$p4_17)
table(cb15$EU)
cb15$EU[cb15$EU<=5]<-NA
minority<- subset(cb15, cb15$min==1)
notminority<- subset(cb15, cb15$min==0)
t.test(minority$EU, notminority$EU)
