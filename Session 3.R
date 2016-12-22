ls()
rm(a, ab, age, age1, b, ba, countries, e, f, g, h, sex)
#clear all variables
rm(list=ls())

#Basic data types in data structures: character, numeric, integer, logical, complex, factor
#CHARACTER --> 'a' , '"good", "TRUE", '23.4'
v <- "TRUE"
print(class(v))
#coerce using as.character
as.character(v) 
#paste two values
fname = "Mary"; lname ="Ann" 
paste(fname, lname) 

#NUMERIC --> 12.3, 5, 999 - Default in R
v <- 23.5
class(v)
#can coerce using as.numeric, but usually have to also first define your vector as.character
a<-as.numeric(as.character(x))

#INTEGER --> 2L, 34L, 0L
#Integer is  is a whole number (not a fractional number) that can be positive, negative, or zero
v <- 2L
class(v)
#or coerce using as.integer
#can also check if it is integer
is.integer(v)  # is y an integer? 
#coerce a numeric or string value
as.integer(3.14) 
as.integer("5.27")
#but cannot coerce a non-decimal string
as.integer("Joe")

#LOGICAL --> TRUE, FALSE
v <- TRUE 
class(v)

#COMPLEX --> 1 + 2i 
v <-1 + 2i 
class(v)
#or coerce using as.complex command

#FACTORS
#Factors are categorical variables that act like dummy variables, and that R codes for you
#It can have levels, e.g. race variable
#You cannot do a mean or any other statistic of a factor variable, except: a count
#You can coerce factor to be numerical
#is.factor, is.ordered, as.factor
sex <- factor(c(1,2,2,1,2,1,1,2)) 
a <- factor (c("a", "b", "c", "b", "c", "b", "a", "c", "c")) 
a                      
# You can tell it's not a character vector: no quotes
# Also the levels print out
levels(a)      
a[3] <- "d" #creates NA
a[3] <- "a" # allows to add existing levels
a
#Change levels
levels(a)[1] <- "AA"
a

#Factors are efficient way to store character values. 
#read.table will automatically convert character variables to factors unless the as.is= argument is specified


###Storing data in R objects: vector, matrix and array, dataframe, list
#VECTOR is an object that consists of the SAME data type (e.g. numbers, strings, logical values)
#Vector is simply a list of values
#Vector is 1-dimensional
q<-c(1,2,3,4,5,6)
q
b<-c(6,7,8,9,10)
b
qb<-c(q,b)
qb

g <- seq(1, 10, 1)
g

countries<- c("Georgia", "Armenia", "Azerbaijan")
countries

#MATRIX
#Matrix is a 2-dimensional rectangular data table containing rows and columns.
#Matrix is a collection of vectors of same length
#Matrix is memory efficient and facilitates analysis (e.g. in regression)

#use c() to construct a vector by concatenating data
vec <- c(1, 2, 3) #numeric vector
vec1 <- c("A", "B", "C") #character vector
vec2 <- c(TRUE, FALSE, TRUE) #logical vector

#use cbind() & rbind() to construct matrices
M <-cbind(vec, vec1) #bind vectors by column
M
M2 <-rbind(vec,vec1) #bind by rows
M2
class()

#use matrix() to construct matrices
M3 <-matrix(data=1:20, nrow=4, ncol=5)
M3
length()
dim()

M4 <- matrix(1:20, 5, 4)
M4

#Matrix content is filled along the column orientation by default!
#If we do not specify columns, R fills automatically given the length of data
M5 <- matrix(1:20, 2)
M5
M5 <- matrix(1:20, 3) #error although produces the matrix, recycles the values
M5 <-matrix(1:27,3) #no problem
M5

#Matrices need two indices - for column and row
M5[2,4] #selects value in the 2nd row, 4th column
M5[1,] #selects first row of matrix
M5[,2] #selects the 2nd column
M5[,c(1,3)] #selects all rows, but 1st and 3rd column
M5[,-c(3,5)] #deletes 3rd and 5th column
M5[1:3,] #selects columns 1 to 3
M5[c(1,2),] #selects the 1st and 2nd rows

#assign names/labels to matrix vectors
#dimnames can also be used for arrays or data frames

dimnames(M2) <- list(month.abb[1:2], month.abb[3:5])
dimnames(M2)[[1]] <- letters[1:2]

#dimnames(M2) = list( 
 # +   c("one", "two"),         # row names 
#  +   c("col1", "col2","col3")) # column names 
M2
str(M2)

M2[, "Apr"] #selects column named "Apr"

#Basic matrix operations: addition, subtraction, transpose
mat<-matrix(1:9,3,3)
mat
mat2<-matrix(10:18,3,3)
mat2
#Addition
mat+mat2
#Subtraction
mat2-mat
#Transpose the matrix by interchanging columns and rows with the function t
t(M5)
M6 <- t(M5)

#ARRAYS
#Array is similar to matrix, but arrays allow data in n-dimensions
#Construct it: array(data, dimension_vector)
my.array <- array(1:24, dim=c(3,4,2)) #an array with 3 rows, 4 columns and 2 tables or layers
my.array

#arrays need as many indices as there are dimensions to reference elements
my.array[3,4,1] #prints element from 3rd row in 4th column, 1st layer

#if you already have data in an existing vector, but want to change it into an array
vector<-1:24
vector
dim(vector)<-c(3,4,2) #now looks like an array
#the same can be used with matrices  
dim(M4)<-c(5,2,2)
M4
class(M4)

#LISTS
#Lists can contain all kinds of elements - numbers, strings, vectors and another list inside it + matrices + functions
#Create using list() function
mylist <- list("School", "Work", c(9,97,30), TRUE, 33.23, 100.1)
print(mylist)

mylist <- list(c("Jan","Feb","Mar"), matrix(c(3,9,5,1,-2,8), nrow = 2),
                  list("green",12.3))

# Give names to the elements in the list.
names(mylist) <- c("1st Quarter", "A_Matrix", "A Inner list")
mylist


#SORTING DATA
a <- c(4, 1, 2, 3)
sort(a) #sorts a numeric vector in ascending order (default)
sort(a, decreasing = TRUE) #specify the decreasing arg to reverse default order

#create another character vector
A <- c( "D", "B", "C", "A")
sort(A) #sorts a character vector in alphabetical order (default)
sort(A, decreasing = TRUE) #specify the decreasing arg to reverse default order

a[1] #selects first value in vector
tail(a, n=1) #selects last value
head(a, n=1) #selects first value
