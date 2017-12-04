
#set up
rm(list = ls())
load('linmodExampleData.RData')
source('linmod_function.R')

#inspecting the data
dim(x)
dim(y)
head(x)
head(y)

#invoking the linmod function
results <- linmod(x = x, y = y)
results$coefficients

#plotting
plot(results$fitted.values, y)
