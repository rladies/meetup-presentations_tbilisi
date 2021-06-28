### sashualebas gvadzlevs gvqondes wvdoma arsebul bazebtan
install.packages("devtools") 
devtools::install_github("rstudio/EDAWR")
library(EDAWR)

# moecemuli monacemebi gadaviyvanot tables klasshi
#Converts data to tbl class. tbl’s are easier to examine than
# data frames
dplyr::tbl_df(iris)

#Information dense summary of tbl data
dplyr::glimpse(iris)
utils::View(iris)
fix(iris)

## "Piping" with %>% makes code more readable, x %>% f(y) is the same as f(x, y)
### gvexmareba monacemta dafiltvrashi

library("dplyr") 
ir0 <- iris %>%
  group_by(Sepal.Width) %>%
  summarise(avg = mean(Sepal.Width)) %>%
  arrange(avg)  
fix(iris)
ir1 <- iris %>%
  group_by(Species) %>%
  count(Sepal.Width)


############### Reshaping Data ###########
install.packages("babynames")
library(babynames)
data(babynames)
head(babynames)

### Gather helps to Gather columns into rows
#View(stackloss)
#View(mtcars)
#View(pressure)
View(cases)
class(cases)
tidyr::gather(cases,"year","n", 2:4)
# "cases" is the data frame which reshape
# "year" it is key variable which contains column names
# "n" is the value column that contains the former column cells
# "2:4" names or numeric indexes of columns to collapse

View(pollution)
class(pollution)
tidyr::spread(pollution, size, amount)
# "pollution" is the data frame which reshape
#"size" is key value and each unique value in the key column becomes a column name
# " amount" is value and each value in the value column becomes a cell in the new columns

View(storms)
# when we want to separate the one coumn into several we use separate function
storms1 <- tidyr::separate(storms, date, c("y","m","d"), sep = "-")

tz(Europ/Georgia)
#View the storms1 data and if you want to unit several columns into one, shoud use function - unite
tidyr::unite(storms1, "date", y, m, d, sep = " ")  # (sep = "-" or sep = ".")
storms$date <- as.date(storms$date)
class(storms$date)
summarise(iris)
as.data.frame(iris)
#### if we have a vectors and want to combaine them 
#  into dataframe we use function data_fram form dplyr package
dplyr::data_frame(a = 1:10, b= 11:20)

View(mtcars)
## for order the existed rows by values of column we use "arrange" form low to high
dplyr::arrange(mtcars,hp)
### to arrange data from high to low
dplyr::arrange(mtcars, desc(hp))

View(tb)
### Rename the columns of a data frame
dplyr::rename(tb,y = year)
View(iris)
#########  Subset Observations (Rows) ##############################
irisi111 <- dplyr::filter(iris,Sepal.Length >7  )  #Extract rows that meet logical criteria
dplyr::select(irisi111, Sepal.Length, Species )
## to remove duplicate rows use distinct
dt <- dplyr::data_frame(a= 1:3, b=4:6,d= c(1,1,1))
dt <- tidyr::gather(dt,"type","n")
fix(dt)
dplyr::distinct(dt)

#### Randomly select n rows
samn <- dplyr::sample_n(iris,10, replace=T)
### Select rows by position
dplyr::slice(iris,10:15)
fix(iris)
### Select and order top n entries (by group if grouped data)
dplyr::top_n(storms,4,date)

############ Subset Variables (Columns) #########################33
## if we want to select columns from dataset by names we use  "Select" Function 
install.packages("dplyr")
library(dplyr)
View(babynames)
dt1 <-dplyr::select(babynames,year,name,n)
ddt <- dplyr::filter(babynames, year == 1880)
View(dt1)
dim(babynames)
select(iris, contains("."))
dplyr::select(iris, ends_with("Length")) #Select columns whose name ends with a character string
select(iris, starts_with("Sepal")) #Select columns whose name starts with a character string
View(storms)
select(storms, -long) # Select all columns except Species

##################  Summarise Data  ##############
View(pollution)
View(mtcars)
dplyr::summarise(mtcars,avg = mean(hp)) # Summarise data into single row of values

dplyr:: count(iris, Species, wt = Sepal.Length)
dplyr::summarise(pollution, median = median(amount), variance = var(amount))
dplyr:: summarise(pollution, mean = mean(amount), sum = sum(amount), n = n ())
###Summarise uses summary functions, functions that
## take a vector of values and return a single value, such as 
dplyr::n_distinct(pollution) ##  of distinct values in a vector
dplyr::last(pollution)
class(pollution)
 ############# Make  New Variable #########
###Compute and append one or more new columns
 isi <- dplyr::mutate(iris, sepal = Sepal.Length + Sepal.Width)
View(isi)
### Compute one or more new columns. Drop original columns
irr <- dplyr::transmute(iris, sepal = Sepal.Length+Sepal.Width)
View(irr)
dplyr::lead(iris) ### Copy with values shifed by 1
dplyr::lag(iris) #### Copy with values lagged by 1
View(storm3)
stor <- dplyr::mutate(storms, ratio = pressure / wind)

storm3 <- dplyr::mutate(storms, ratio = pressure / wind, inverse = ratio^-1)

############### Group Data ############
###Group data into rows with the same value of Species
saxeoba <- dplyr::group_by(iris, Species)
### Remove grouping information from data frame
dplyr::ungroup(iris)
fix(iris)
library(dplyr)
typ <- iris %>% group_by(Species) %>% summarise(sum = sum(Sepal.Length)) ## Compute separate summary row for each group
typ1 <- iris %>% group_by(Species) %>% mutate(meanlength = 1/Sepal.Length)   ### %>% arrange(meanlength)

###### Combination #######
 View(storms)
storms %>%
  filter(wind >= 50) %>%
  select(name, pressure, year, month, day)

View(storms)
storms %>% 
  mutate(ratio = wind/ pressure, invers = ratio ^-1) %>% 
  select(name,ratio, invers)
%>% 

View(pollution)
pollution %>% group_by(city)
pollution %>% group_by(city) %>% summarise()
pollution %>% group_by(city) %>% 
  summarise(mean= mean(amount),sum = sum(amount),n = n())
pollution %>% group_by(city) %>% 
  summarise(mean= mean(amount))

pollution %>% group_by(size) %>% 
  summarise(mean= mean(amount))

################# what we already know ??? ####
#1. take a glance of 'tb' data
#2. group_by 'tb' data by country and year (HInt: use '%>%' )
#3. from 'tb' data group_by country and year and summarise number of child according to these countryies and year
#4. and do another summarise by (use %>% ) 

View(tb)
tb %>% 
  group_by(country, year) %>% 
  summarise(child = sum(child)) %>% 
  summarise(child = sum(child))
  
