# ############################################################# #
#                                                               #
#### Part1: Data Structures: Vectores                  ####
# ############################################################# #

# 1.1 Basics ----------------------------------------
getwd()
data()
# 1.2 Creating Vectors --------------------------------------
help.start()
install.packages("dplyr")
library(dplyr)

# Vector is a basic data structure in R. 
# It contains element of the same type. 
# The data types can be logical, integer, double, character, complex or raw.

# 1.2.1 Creating vectors directly by yourself ------------------------------

### Function c()
vecInteger  <- c(1,2,10)
vecInteger
class(vecInteger)
vecCharacter  <- c("a","Bee", "Zeh") 
vecCharacter
class(vecCharacter)

(vecMix       <- c(1,2, "Three", "Four"))
class(vecMix)
(vecNumeric   <- c(1.1,1.2,1.3))
(vecLogical   <- c(T,T,T, F, F))

## Doing some calculations with vectors"
vecNumeric+2
vecNumeric-vecInteger
vecNumeric*vecInteger
vecNumeric/vecInteger

### Sequences: Colon (:) und seq()
1:10
5:-1

1:10 %% 5 # %% Modulus (what is left after dividing by 5)
seq()
?seq
seq(0,1,by=0.1)
seq(-5,-10,by=-0.5)
seq(0,1,length.out = 10)

### Replications rep()
?rep
rep(14,times=7)
rep(1,5)
rep(1:3, 3)
rep(1:3, 1:3)

rep(1:3, each=3)

rep(T, 10)
rep("Na", 12)
rep(c("group1","group2"),times=10)

# 1.2.2 Vectors as a result ----------------------------

### Random number generator
rnorm(10, mean = 0, sd = 1)

rbinom(100, size = 1, prob = 0.5)
rbinom(100, 1, 0.2)

sample(10, size = 3, replace = F)

### Result of other functions
range(rnorm(100)) # range returns a vector containing the minimum and maximum 
                  #of all the given arguments
sort(c(1,3,5,-10))
?sort
sort(c(1,3,5,-10), decreasing = T)

# 1.2.3 Empty Vectors -------------------------------------

### Indirect
vecInt2 <- vector(mode = "integer", length = 10)
vecInt2
vector("numeric", 10)

### Alternatives
integer(10)
numeric(10)
logical(10)
character(10)

# 1.2.4 Other Vectors ----------------------------------

vecColours <- c("red", "red", "green", "red", "blue")

## factor()
factor(vecColours)
factor(vecFarben, levels=c("rot", "gruen", "blau"))

vecFacColours <- factor(vecColours,
                       levels=c("red", "green", "blue"))

## ordered()
ordered(vecColours)
factor(vecColours, ordered = TRUE)

ordered(vecColours, levels=c("red", "green", "blue"))

vecOrdcolours <- ordered(vecColours,
                        levels=c("red", "green", "blue"))

levels(vecOrdcolours) # Zeigt verfügbare Ausprägungswerte an

# 1.3 Infos about Vectors ----------------------------------

# 1.3.1 "External" Infos -------------------------------------

### Dimensions and number of Elements
NROW(vecColours)
NCOL(vecColours)

length(vecFacColours)
length(levels(vecFacColours))
nlevels(vecFacColours)

### Class
class(vecColours)
mode(vecColours)

### More about the contents
View(vecFacColours)
head(vecColours, n=2)
tail(vecColours,n=2)
str(vecColours)

# 1.3.2 Internal Infos ---------------------------------------

### General
summary(vecFacColours)
summary(vecOrdcolours)
summary(vecInteger)

### Other statistical functions
mean(vecInteger)
var(vecInteger)
table(vecColours)

### Other
which.max(vecInteger) # Where is the maximum of a vectors? 
which.min(vecInteger) # Where is the minimum of a vector?

# 1.4 Drag elements from vectors (indexing) ------------

#### Index by numbers
vecInteger #=> 1. Element 1, 2. Element 2 und 3. Element 3
vecInteger[3]
vecInteger[c(1,3)] #More than one elemens per vector
vecColours[1:4]

vecInteger[which.max(vecInteger)]
max(vecInteger)

## Remove by negative numbers
# To delete some values one must also use indexing, 
# otherwise it won't be removed

vecColours
vecColours <- vecColours[-(1:4)]

### "Out of bounds" (Unfortunately no error message with vectors)
vecInteger[4]
vecInteger[4:10]

# For comparison (see later)
USPersonalExpenditure[,6] #Has only 5 columns
iris[,6]

#### Indexing by logical comparisons
iSpec   <- iris$Species
iSepLen <- iris$Sepal.Length

iSpec == "virginica"
iSepLen[iSpec == "virginica"] # Values of the lengths of virginica irises

iSepLen > 6.5
iSpec[iSepLen > 6.5] # Names of lilies of length greater 6.5

## More options
# >  : greater
# <  : smaller
# >= : greater or equal
# <= : smaller or equal
# == : is equal
# != : is not equal
# !  : Not => !T  (not TRUE) ist FALSE (and !F is TRUE)
# &  : AND
# |  : OR

### Scalars
5 == 5
5 != 5
!(5 == 5)
5 > 5
5 <= 5
5 < 5
5 >= 5

## AND
5 == 5 & 10 == 10
T & T
T & F
F & T
F & F

## OR
5 == 5 | 10 == 10
T | T
T | F
F | T
F | F

### Logical comparisons for vectors
#   Create example vectors
TestVector1 <- c(1,5,10,15)
TestVector2 <- c(1,5,11,17)
TestVector3 <- c("Hello","World")

## Comparing vectors with scalars
TestVector1 > 1
TestVector1 > 5
TestVector2 >= 5
TestVector3 == "Hello"
TestVector3 == "hello"

## Compare vectors with vectors
TestVector1 == TestVector2
TestVector3 != c("Hello", "earth")

## Linking logical vectors with logical vectors
c(T,T,F) & c(F,T,F)
c(T,T,F) | c(F,T,F)
(TestVector1 > 1) & (TestVector2 > 1)
(TestVector1 > 5) & (TestVector2 >= 5)


### Addition which(): Converts TRUE/FALSE-Vectors,
#   then returns the positions of TRUE's  

which(iSpec == "virginica")
iSepLen[which(iSpec == "virginica")]

### Addition1 2: Named vectors
vecName <- c(MW=10, Var=2.5, SD=sqrt(2.5))
vecName
vecName["MW"]

### Addition 3: Number or share per TRUE (=1) and FALSE (=0)
sum(iSepLen > 6.5)
mean(iSpec == "virginica")

# 1.5 Saving Elements in Vectors  -----------------------

### Saving in Vectors = Indexing + Assigning

vecColours[1]
vecColours[1] <- "green"
vecFarben[2] <- NA

## More elements => Indexing  + Assigning of more elements
vecCharacter[c(1,3)] <- c("Aaa", "Cee")
vecCharacter

vecMix[vecMix == c("Three","Four")] <- c(3,4)
vecMix
as.numeric(vecMix) # Side note: Commands starting with as. usually allow a ,
                   # conversion from one storage type to another. 
                   # Run as.numeric(c(T,T,F,F)) and as.logical(c(1,0,0,3,2))


## Attaching to vectors
c(vecInteger,1:10)

# 1.6 Summary of commands ------------------

#:           #  For generating a number sequence ascending/descending by 1
#%%          #  Modulo-Operator
seq()        #  Anu sequence of numbers
rep()        #  Replication
rbinom()     #  Binomially distributed random numbers
range()      #  Minimum and Maximum
vector()     #  Creating empty vectors (or lists)
integer()    #  Create empty (=all 0) integer vector
numeric()    #  Create empty (=all 0) numeric vector
logical()    #  Create an empty vector of logical values (=all FALSE)
character()  #  Create empty character vector (=all "")
factor()     #  Generating factor variables (is quasi nominal)
ordered()    #  Generating ordered-factor variables (quasi ordinal)
levels()     #  Charasteristics of a factor/ ordered factor
length()     #  Length of a vector (or a List, also number of columns of 
             #  a data.frame)
NROW()       #  Number of rows
NCOL()       #  Number of columns
nlevels()    #  Number of existing levels of factors
             #  / ordered factors
class()      #  Class
mode()       #  Mode
str()        #  "Structure" of an Objekts
head()       #  First n Elements (Default: 6 Elements)
tail()       #  last n Elements (Default: 6 Elements)
summary()    #  General overview command
which.max()  #  Position of the largest value
which.min()  #  Position of the smallest value
as.numeric() #  Transformation into numeric object
as.logical() #  Transformation into logical object

# ############################################################# #
#                                                               #
#### Part 2: Data Structures: Matrices & Arrays  ####
# ############################################################# #

# 2.1 Creating matrices  ---------------------------------

# Note: Save only one class of objetcs in matrices 
#       (example: only numbers/characters/logical values).
#       Mixing is less helpful

# 2.1.1 Matrix of vectors  --------------------------------

matR <- rbind(1:5, 11:15) # Rowwise
matC <- cbind(1:5, 11:15) # Columnwise

# 2.1.2 Create by matrix() -------------------------------

matM <- matrix(1:9,nrow = 3, ncol=3,byrow=F)
matM
matM <- matrix(sample(1:9),3) # Default by column
matM

### Attention: Inappropriate vectors

matrix(1:4, 3,3)
cbind(1:3,1:8)
cbind(1:3,1:9)    # R does not always warn (if the Element number of a shorter
matrix(1:3, 3,3)  # vector is a multiple of the longer vector 
                  # or a multiple of rows*columns)
             
### Attention regarding mixing:
matrix(c(1,2,T,T),2)
matrix(c(T,T, "d","v"),2)
matMix <- matrix(c(1,2, "d","v"),2)
matMix

# 2.2 Drag elements from matrices (Indexing) ------------

# 2.2.1 Indexing by numbers ------------------------------

matM
matM[5] #Works like it worked for vectors, but ... 

#...  It is better like this (Left: row, Right: column)
matM[2,2]     # 2. Row, 2. Column
matM[2,]      # 2. Column
matM[,c(1,2)] # 1. and 2. Column

matM[3,]      # 3. Row
matM[c(1,3),] # 1. and 3. row

## Sort by column
matM[,2]
order(matM[,2], decreasing = T)
idxOrd <- order(matM[,2], decreasing = T)
matM[idxOrd,]

### Exclude
matM[-2,]
matM[,-2]
matM[-2,-2]

# 2.2.2 Index by name -------------------------------

### Columnnames
colnames(matM)
colnames(matM) <- c("C1","C2","C3")
matM
matM[,"C1"]         # Column C1
matM[,c("C1","C3")] # Column C1 and C3

### Rownames
rownames(matM) <- c("R1","R2","R3")
matM
matM["R1", ]         # Row R1
matM[c("R1","R3"), ] # Row R1 and R3

# 2.2.3 Indexing by logical comparisons ----------------


# which()
matM > 5
which(matM > 5)              # Position as a vector
which(matM > 5, arr.ind = T) # Better: Rows & Column numbers

# 2.3 Save in Matrices --------------------------------

### One Element
matM[1,1]
matM[1,1] <- 10

### In row 1 (Number of elements = length of rows)
matM[1,] <- c(2,8,14)

### In row 2 (Number of elements = length of rows)
matM[,"C2"] <- c(4.3, 5.2, 6.1)

### Add column (add row via rbind())
matM <- cbind(matM,1:3)
matM

# 2.4 Informations about matrices ----------------------------------

# 2.4.1 "External" Infos -------------------------------------

### Use sample matrix
matUSP <- USPersonalExpenditure
matUSP

### Dimensions and number of elements
dim(matUSP)    # Number of rows and columns; Analogical to NROW() & NCOL()
nrow(matUSP)   # nrow() does not work for vectors
ncol(matUSP)   # ncol() does not work for vectors
length(matUSP) # Number of elements in the matrix

### Storing
class(matUSP)
class(matMix[,1]) #Class of the 1st column from matMix
mode(matUSP)

### In addition, if name exists:
rownames(matUSP)
colnames(matUSP)
dimnames(matUSP)

### Looking in more details at the contents
View(matUSP)
edit(matUSP)
matedtUSP <- edit(matUSP)

head(matUSP, n=2)
tail(matUSP, n=2)
 
str(matUSP)

# 2.4.2 Internal informations  --------------------------------------------

### General
summary(matUSP)

### Basic statistical functions
cov(matUSP[,1],matUSP[,2]) 
cov(matUSP)
cor(matUSP)

mean(matUSP)
mean(matUSP[,1])


# 2.5 Arrays ---------------------------------------

### Array ("Hyperrechteck")
arr <- array(1:27, dim=c(3,3,3))

# in argument "im":
#        - the 1. number: Number of all rows  (for each matrix)
#        - the 2. number: Number of all columns (for each matrix)
#        - the 3. number: Number of matrices

arr

arr[1,,] # All first rows
arr[,2,] # All second columns
arr[,,3] # The third matrix

arr[1,2,] # First rows of all second columns (so the first elements)
arr[,2,3] # The second column of the thirs matrix

# 2.6 Summary of commands ------------------

rbind()   #  Row-wise joining 
cbind()   #  Column-wise joining
matrix()  #  Creating a matrix (from a vector)
order()   #  Where values would be, if they were sorted (is used for indexing)
dim()     #  Dimensions(Number of rows and columns for matrices and data.frames)
nrow()    #  Number of rows (does not work for vectors)
ncol()    #  Number of columns (does not work for vectors)
edit()    #  Editing Capabilities
rownames()#  Row names
colnames()#  Column names
dimnames()#  Row and column names
array()   #  Creating an array (from a vector)

# ############################################################# #
#                                                               #
#### Part 3: Data Structures: data.frames               ####
# ############################################################# #

# 3.1 Creating data.frames ------------------------------

# 3.1.1 data.frames per data.frame() -----------------------
data.frame(1:3, c(4,8,10))
data.frame(V1=1:3, V2=c(4,8,10))
datMix <- data.frame(V1=1:3,V2=letters[1:3])
                     # letters contains lowercase - abc
                     # LETTERS contains uppercase -ABC

# data.frame behaves differently than matrices with mixed object types;
# However, indexing and many other things are the same as for matrices.

mean(datMix[,1])
class(datMix[,1])
class(datMix[,2]) # characters are usually becoming factors

## Some other ways for joining vectors
rbind.data.frame(1:3,c(4,8,10))
cbind.data.frame(1:3,c(4,8,10))

# 3.1.2 data.frames from matrices ---------------------------
matA <- matrix(1:4,2)
matB <- matrix(c(1,2,"b","c"),2)

datA <- as.data.frame(matA)
datA
datB <- as.data.frame(matB)
datB


# 3.1.3 Loading data.frames: csv/txt/ASCII-Data --------

### read.table() & read.csv2()
datMiet1 <- read.table("")
head(datMiet1)
str(datMiet1)

datMiet2 <- read.table("",
                       header = T)
head(data, n=10)
str(data)

### It is also possible to load data per klicks:
#   Tab "Environment" => "Import Dataset" =>
#   "From Text File..."

# 3.1.4 Loading data.frames: RData-Data ----------------

### load()
load("")

## Pfath-Alternatives
path <- ""
load(file.path(path, ""))

# 3.1.5 Loading data.frames: SPSS-Data -----------------

### read.spss()
library(foreign)

# Without any settings we get a list 
datStudis1 <- read.spss("")
class(datStudis1)

# We should ise -  to.data.frame:
datStudmlab <- read.spss("",
                              to.data.frame = TRUE)

head(datStudmlab)

# Usage of use.value.labels:
datStudolab <- read.spss("",
                             to.data.frame = TRUE, use.value.labels = FALSE)

head(datStudolab)

# 3.1.6 Loading data.frames: Exkurse ----------------------

# 3.1.7 Example datasets from packages ---------------------

data() ### Overview of existing/available datasets 

### Load sample data including its package:
install.packages("MASS")
library(MASS)
survey <- data(survey)
survey
install.packages("VIM")
require(VIM) #Alternative to library()
data(tao)
names(survey)
# 3.2 Indexing data.frames() -------------------------

# 3.2.1 Indexing per numbers ------------------------------

## Same as by matrices
survey[,1]
datA[,1]
datA[1,2]


# 3.4 Saving data.frames & other objects ---------

### Saving as .RData
save.image(file=file.path(pfad, ""))  # Saves all Elements 
                                                     # (vectors, matrices, lists
                                                     # data.frames that have 
                                                     # been currently created)
x <- 1
vecAdditional <- sample(100,6)
getwd()

save(x, vecAdditional, file="") # Saves individual objects

### Saving .csv/.txt
#   => write.table(), write.csv2()

# 3.5 Merging data.frames -------------------------------

### Generate sample data with ID variable
set.seed(2345)
(datC <- data.frame("ID" = c(2,3,5), "X" = rnorm(3)))
(datD <- data.frame("ID" = 1:6, "Y" = rpois(6,3)))

### Merge over intersection
(indInA <- intersect(datC$ID, datD$ID))   # intersect () forms intersection

datD[indInA,]
# or
indInA2 <- is.element(datD$ID, datC$ID) # Checks if / which elements contain
           # Alternatives: datD$ID %in% datC$ID
           # Attention to the order, what first::
           # datD$ID %in% datC$ID != datC$ID %in% datD$ID

datD[indInA2,]

cbind(datC, datD[indInA2,-1])

#By the way:
unique(c(2,3,3,3,3,3,3,5,5,5,5,7,7))

### Alternative: merge()
merge(datC, datD,by="ID")
merge(x=datC, y=datD, all.y=T)

merge(datD, datC)
merge(datD, datC, all.x=T)

merge(datC, datD, all=T)
merge(datD, datC, all=T)


# 3.6 Infos about data.frames -------------------------------

# 3.6.1 "External" Infos -------------------------------------

### Dimensions and number of elements
dim(datA)
ncol(datA)   # Analogous: nrow(), NCOL(), NROW()
length(datA) # Element number, but elements of a data.frames ()
             # are the columns!

### Saving Class
class(datA)
class(datA[,1])
mode(datA)

### If names are available:
rownames(datA)
colnames(datA)
dimnames(datA)
names(datA)   #New, like colnames () only shorter; is not working with matrices

### More about contents
# analogous as Matrix: head(), tail(), View(), edit(),....
str(datA)

# Number of rows and columns / observations and variables
# int (integer) => Integer / Absolute
# num (numeric) => floating point / ratio or Interval scaled
# Factor => nominal
# log (logical) => TRUE / FALSE values => dichotomous
# Ord. Factor => Ordinal


# 3.7 Summary of commands

data.frame()       #  Generating data.frame from vectors
rbind.data.frame() #  Joining rowise to data.frame
cbind.data.frame() #  Joining columnwise to data.frame
as.data.frame()    #  Conversion (from matrix) to data.frame
read.table()       #  Importing .csv / .txt files
read.csv2()        #  Importing .csv / .txt files
load()             #  Loading .RData files
file.path()        #  Join path as a string
read.spss()        #  Importing SPSS .sav files
install.packages() #  Install additional packages
library()          #  Load Packge
require()          #  Load Oackage
names()            # Variable name / column name of a
                   # Record (or element name of a list,
                   # does not work for matrices)
attributes()       #  Show attributes
subset()           #  Forming samples of dataset
attach()           #  Attaching data.frames (and Lists), so
                   #  that one does not need $ 
detach()           #  Undo attach() 
save.image()       #  Save Workspace / Environment as .RData
save()             #  Save individual objects as .RData
write.table()      #  Save as a .csv / .txt file
intersect()        #  Creating intersections
unique()           #  Delete duplicate values
merge()            #  Merging Datasets

# ############################################################# #
#                                                               #
#### Part 4: Data Structures: Lists + Saving Objects ####
# ############################################################# #

# 4.1 Creating lists -----------------------------------

# 4.1.1 Lists per list() ----------------------------------

### Other objects are still needed
vecA <- c(1,3,7,9)
matA <- matrix(0,4,4)
matB <- cbind(1:2, 3:4)

### Creating list
lst <- list(Name1=matA,
            Name2=matB,
            Name3=vecA,
            "nix") # Similar data.frame()
lst

## For empty lists of specific length, there are also:
vector(mode="list", length=5)

# 4.1.2 Lists by conversion  ----------------------

datB <- as.data.frame(matB)
as.list(datB)
as.list(1:5)
as.list(matA)

# 4.1.3 Vectorizing lists (unlist()) ----------------

lstZahlen <- as.list(1:5)
lstZahlen
unlist(lstZahlen)

## Attention with multu-element list elements:
#  => Changed names
#  => Mixing saving classes becomes problematic again


# 4.2 Indexing lists -------------------------------

### Like the "new" options in the data.frame: [], [[]], $
lst
names(lst)
lst$Name1
lst["Name2"]
lst[[2]]
lst[[3]]
lst[["Name3"]]
lst[[4]]

class(attributes(datB))
attributes(datB)$names

### and of course one can continue indexing
lst$Name2[,1] # First column of the second matrix in lst

# 4.3 Saving objects -------------------------------

lstLeer <- vector(mode="list", length=5)
names(lstLeer) <- c("Vek1", "Mat1", "Mat2", "Vek3", "Nix")

lstLeer$Vek1 <- 1:10
lstLeer$Vek3 <- c(T,F)

## Attention with more elements:
lstLeer[c(2,3)] <- list(matA, matB)
lstLeer

# 4.4 Summary of commands  ------------------

list()    #  Creating lists yourself
as.list() #  Converting to lists
unlist()  #  Vectorizing lists
