#################################################################
#################################################################
##
## Session 8: Linear Regression in R
##
#################################################################
#################################################################
install.packages(c("MASS", "calibrate", "car"))

library(MASS)
library(calibrate)
library(car)

## or insted of writing each time the library(xxx) 
# x<-c("MASS", "calibrate", "car")
# 
# lapply(x, library, character.only = TRUE)

mypath <- "C:/Users/KASUTAJA/Documents/RLadies"
setwd(paste(mypath))


# generate some data
set.seed(500)
y <- rep(c(seq(1,30, by=1)), 2) # 
x <- rnorm(60, mean=10) # 
plot(x, y)


rep #repeat

rep(c(1,2,3,4),3)

seq #sequence

seq(1, 10, by=.5)

example1 = lm(y~x)
example1
attributes(example1)
summary(example1)

str(example1)

example1$coefficients

# plot the regression
plot(x,y)
abline(lm(y~x))
res <- signif(residuals(example1), 5)
pre <- predict(example1) # plot distances between points and the regression line
segments(x, y, x, pre, col="red")

# add labels (res values) to points
# require(calibrate)
textxy(x, y, res, cex=0.7)


# example1$fitted.values
# 
# y-example1$fitted.values #prediction error
# 
# (y-example1$fitted.values)^2 #squared error
# 
# (sum(y-example1$fitted.values)^2)/length(y)

################################################################################
### Let's use some real data...
# require(MASS)
data(Boston) #Boston housing data

################################################################################ 
# The Boston dataset has 14 variables and 506 cases:
#   
# 1. CRIM - per capita crime rate by town
# 2. ZN - proportion of residential land zoned for lots over 25,000 sq.ft.
# 3. INDUS - proportion of non-retail business acres per town.
# 4. CHAS - Charles River dummy variable (1 if tract bounds river; 0 otherwise)
# 5. NOX - nitric oxides concentration (parts per 10 million)
# 6. RM - average number of rooms per dwelling
# 7. AGE - proportion of owner-occupied units built prior to 1940
# 8. DIS - weighted distances to five Boston employment centres
# 9. RAD - index of accessibility to radial highways
# 10. TAX - full-value property-tax rate per $10,000
# 11. PTRATIO - pupil-teacher ratio by town
# 12. BLACK - 1000(Bk - 0.63)^2 where Bk is the proportion of blacks by town
# 13. LSTAT - % lower status of the population
# 14. MEDV - Median value of owner-occupied homes in $1000's
################################################################################
##
## always take a look at the dataset before running anything...
##
summary(Boston) # gives min, max, median, mean 1st and 3rd quantile
dim(Boston) # number of columns and rows
cor(Boston) # correlation


# I want to do a bit of data management for plotting... short to long format:
# 
require(tidyr) #Hadley Wickham
require(dplyr)
require(ggplot2)
require(RColorBrewer)
require(randomcoloR)

dt.long <- gather(Boston, "variable", "value", crim:medv)

col <- colorRampPalette(c("red", "blue"))(14)
# col.bp <- brewer.pal(9, "Set1") # brewer.pal only has a max of 9 colors
col.rc <- as.vector(distinctColorPalette(14))

# png("violin.ggplot.color.png")
ggplot(dt.long,aes(factor(variable), value))+ 
  geom_violin(aes(fill=factor(variable)))+
  geom_boxplot(alpha=0.3, color="black", width=.1)+
  labs(x = "", y = "")+
  # scale_fill_manual(values = col, name="")+
  theme_bw()+
  theme(legend.title = element_blank())+
  facet_wrap(~variable, scales="free")
 # dev.off() 


mymodel <- lm(Boston$medv~ Boston$rm )
summary(mymodel)
# mymodel$coefficients
# mymodel$residuals
# str(mymodel) #structure of the output

## 
## plot data and regression line
## 
plot(medv~ rm , data = Boston)
abline(mymodel, col="red")

# 
# Note that if you type plot(mymodel) you'll 
# obtain a set of summary plots
# 

op <- par(no.readonly = TRUE )
par(mfrow=c(2, 2))
plot(mymodel)
par(op)


# 1. The Residuals vs Fitted panel shows whether residuals have non-linear patterns.
# 
# 2. A Q-Q plot is a scatterplot with two sets of quantiles plotted against one another. If both sets come from the same distribution, the points will draw a line that’s roughly straight. In this case, we can notice that there are more extreme values (heavy tails) than we would expect if the values truly came from a Normal distribution.
# 
# 3. Scale or Spread-Location plot. The third panel shows if residuals are spread equally along the ranges of predictors. This is how you can check the assumption of equal variance (homoscedasticity). It’s good if you see a horizontal line with equally (randomly) spread points.
# 
# 4. Residuals vs Leverage points at influential cases (if there is any at all). In our case there is no influential case.


mymodel.2 <- lm(Boston$medv~ Boston$black + Boston$chas + 
                  Boston$crim +  Boston$lstat + 
                  Boston$ptratio + Boston$rad +
                  Boston$rm + Boston$zn +Boston$zn)
summary(mymodel.2)


# I check the Variance Inflation Number or vif, values should be before 4 (but also less):
  
# require(car)
vif(mymodel.2)


# Check if there are outliers:
  
outlierTest(mymodel.2)

# and remove them:
  
Boston.new <- Boston[-c(369, 372, 373),]
mymodel.3 <- lm(Boston.new$medv~ Boston.new$black + Boston.new$chas + Boston.new$crim + Boston.new$dis + Boston.new$lstat + Boston.new$nox + Boston.new$ptratio + Boston.new$rad +Boston.new$rm + Boston.new$zn +Boston.new$zn)

summary(mymodel.3)
vif(mymodel.3)


op <- par(no.readonly = TRUE )
par(mfrow=c(2,2))
plot(mymodel.3)
par(op)


# ## Coefficient of Determination
# The coefficient of determination of a linear regression model is the quotient of the variances of the fitted values and observed values of the dependent variable:


summary(mymodel.3)$r.squared
# str(summary(mymodel.3))
fit.SSE<-sum(mymodel.3$residuals^2)
fit.SSE

fit.SST <- var(Boston.new$medv)*(length(Boston.new$medv)-1)

SSreg <- fit.SST-fit.SSE
R2 <- 1-fit.SSE/fit.SST  # 0.7699303

# dfE   <- mymodel.3$df.residual
# dfReg <- length(Boston.new$medv) - 1 - dfE
# MSreg <- SSreg / dfReg
# MSE   <- fit.SSE / dfE
# Fstat <- MSreg / MSE
# pval  <- pf( Fstat , dfReg, dfE , lower.tail=FALSE )

# a way to compute (by hand) the adjusted R^2
ncases <- nrow(Boston.new)
ncovs <- length(mymodel.3$coefficients)-1
R2adj <- R2-(1-R2)*((ncovs)/(ncases-ncovs-1)) #0.7652541

