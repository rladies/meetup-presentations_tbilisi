getwd()
setwd("C:/Users/Nina/Desktop/today/beginner")

#create object a and b

a <- 5
b <- "string object"

#create a vector
V1 <- c(1,2,3,4,5)

5 + 5
5 - 5
5*5
10/2
35 %% 10
5<7
5>7
5<=5
5>=7
5=6
5!=6
ls()
x <- rep(1:5)
x <- rep(1:5,2)
sum(5,6)
sqrt(9)
log(4)
sort(x, decreasing = T)
seq(1.2,6,0.5)
seq(1.2,6)
paste("hello", "world")
help("Foreign")
install.packages("foreign")
library("foreign")
install.packages("readr")
library("readr")
#The goal of readr is to provide a fast and friendly way to
#read rectangular data like csv.
#factor data
kids = factor(c(1,0,1,0,0,0), levels = c(0, 1),
              labels = c("boy", "girl"))
kids
as.numeric(kids)
1 + as.numeric(kids)

y = c("a", "bc", "def")
y
length(y)
y == "b"
#Logical – binary, two possible values represented by TRUE and FALSE
x > 2

#Arrays are the R data objects which can store data in more than two dimensions. 
#For example − If we create an array of dimension (2, 3, 4) then it creates 
#4 rectangular matrices each with 2 rows and 3 columns. Arrays can store only data type.
my.array <- array(1:12, dim=c(3,4))
my.array
my.array <- array(1:36, dim=c(3,4,3))
my.array

#vectors
V1 <- c(1,2,3,4,5)

V2 <- c("red","blue", "green")
class(V1)
class(V2)


#matrices


M1 <- matrix(c("a","a","b","c","b","a"),nrow = 2, ncol = 3)
M1
dim(M1)

#data frame
df1 <- data.frame(V1, V1 * 10)
V3 <- c(6,7,8,9,10)
df2 <- data.frame(V1,V3) 

nrow(df1)
ncol(df1)

#list
mylist <- list(1, "a", TRUE, 1 + 4i)
str(mylist)

rm(list=ls( ))
data()
data("Titanic")
?Titanic
View(Titanic)
class(Titanic)
ftable(Titanic)
prop.table(Titanic)
Titanic2 <- data.frame(Titanic)
head(Titanic2)
tail(Titanic2)
str(Titanic2)
summary(Titanic2)
names(Titanic2)

write.csv(Titanic2, file = "Titanic2.csv", row.names = FALSE)
