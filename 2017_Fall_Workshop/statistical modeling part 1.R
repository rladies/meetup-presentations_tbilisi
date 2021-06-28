#statistical modeling (Dr Jeromy Anglim)

# create some variables
library(AER)
data("CASchools")
?CASchools
cas <- CASchools

# create new vaiables
# academic performance as the sum of reading and mathematics
# performance
cas$performance <- as.numeric(scale(cas$read) + scale(cas$math))

# student-staff ratio
cas$student_teacher_ratio <- cas$students / cas$teachers

# computers per student
cas$computer_student_ratio <- cas$computer / cas$students 

# Student size is quite skewed
hist(cas$students)
# Let's log transform it
cas$students_log <- log(cas$students)
hist(cas$students_log)

# same with average district income
cas$income_log <- log(cas$income)

v <- list()

v$predictors <- 
    c("calworks",     # percent of students qualifying for income assistance
      "lunch",        # percent qualifying for reduced price lunch
      "expenditure",  # expenditure per student
      "english",      # percent of english learners
      "student_teacher_ratio", 
      "computer_student_ratio", 
      "students_log", 
      "income_log")
v$dv <- "performance"
v$all_variables <- c(v$predictors, v$dv)


# Univariate statistics

# sample size
nrow(cas)

# Frequencies or percentages on categorical variables
table(cas$grades) # frequency counts
prop.table(table(cas$grades)) # proportions


# Bivariate correlations 

cor(cas[ , v$all_variables])
round(cor(cas[ , v$all_variables]), 2) # round to 2 decimal places
rp <- Hmisc::rcorr(as.matrix(cas[,v$all_variables])) # significance test on correlations
rp
ifelse(rp$P < .05, "*", "")

# Scatterplot matrix with correlations

psych::pairs.panels(cas[ , v$all_variables])


# Regression models

# By default, you don't get much output
lm(performance ~ expenditure + calworks + lunch, data = cas)

# You need to save the model to an object
fit <- lm(performance ~ expenditure + calworks + lunch, cas)

# this object stores the results of analyses.
# You can extract elements directly from this object
str(fit) # show the structure of the object
fit$coefficients

# But more commonly you apply a set of "methods"
summary(fit) # summary info
par(mfrow=c(2,2))
plot(fit)



anova(fit)

confint(fit) # confidence intervals on coeficients

# You can create plots yourself
# Check normality and homoscedsaticity of residuals
# plot predicted by residuals
plot(predict(fit), residuals(fit))
abline(h=0)

# standardised coefficients
library(QuantPsyc)
QuantPsyc::lm.beta(fit)
fit_standardised <- lm(scale(performance) ~ scale(expenditure) + scale(calworks) + scale(lunch), cas)
summary(fit_standardised)

# more information on regression diagnostics
# http://www.statmethods.net/stats/rdiagnostics.html


# Comparing regression models

# model 1 include poverty variables
v$predictors
fit1 <- lm(performance ~ calworks + lunch + expenditure + income_log, cas)
# Model 2 adds school features
fit2 <- lm(performance ~ calworks + lunch + expenditure + income_log +
               student_teacher_ratio + students_log + 
               computer_student_ratio, cas)

summary(fit1)
summary(fit2)

# Does second model explain significantly more variance?
anova(fit1, fit2)


# Formula notation

# For teaching purposes let's name the variables in a general way
x <- cas[, c("performance", "student_teacher_ratio", "students_log", "income_log")]
head(x)
names(x)  <- c("dv", "A", "B", "C")
head(x)


# 1 intercept
# -1 exclude intercept
# The intercept is included by default in linear models, 
# but in other contexts you need to specify it.

lm(dv ~ A, x) # intercept included by default
lm(dv ~ 1 + A, x) # intercept explicitly included (same as above)
lm(dv ~ -1 + A, x) # exclude intercept

# + main effect
lm(dv ~ A + B, x) # main effect of A and B


# * include interaction and main effects
# : just main effect without interactions 
lm(dv ~ A * B, x) # main effects and interactions
lm(dv ~ A:B, x) # no main effects but interaction
lm(dv ~ A + B + A:B, x) # main effects explicitly specified
lm(dv ~ A*B*C, x) # main effects, two-way interactions, three-way interaction
lm(dv ~ (A + B + C)^3, x) # main as above
lm(dv ~ (A + B + C)^2, x) # main effects but only two-way interactions

# You can apply transformations to variables in place
lm(dv ~ scale(A), x) # main effects but only two-way interactions
# this is the same as creating a new variable
# and using the new variable in the model
x$zA <- scale(x$A)
lm(dv ~ zA, x)

# However if the transformation involves symbols that
# have special meaning in the context of R formulas
# i.e., +, -, *, ^, |, :
# then you  # have to wrap it in the I()


# Polynomial regression
lm(dv ~ A + I(A^2), x) # include quadratic effect of A
lm(dv ~ A + A^2, x)
lm(dv ~ A + I(A^2) + I(A^3), x) # include quadratic and cubic effect of A

# interaction effects with centering
lm(dv ~ A + B + I(scale(A) * scale(B)), x) # z-score centre before creating interaction

# composites
lm(dv ~ I(A + B), x) # include the sum of two variables as a predictor
lm(dv ~ I(2 * A + 5 * B), x) # include the weighted coposte as a predictor



# R Factors: Categorical predictors

# Factors can be used for categorical variables

library(MASS)
data(survey)
csurvey <- na.omit(survey)
# let's assume a few variables were string variables
csurvey$Sex_character <- as.character(csurvey$Sex)
csurvey$Smoke_character <- as.character(csurvey$Smoke)

# by default character variables will be converted to factors in regression models
lm(Height ~ Sex_character, csurvey)
# by default it performs dummy coding with the first category as the reference category
# By default the ordering of a categorical variable is alphabetical

# levels shows the levels of a factor variable
# Thus, if we convert a sex as a character variable to a factor
# F is before M to it is Female then Male

csurvey$Sex_factor <-  factor(csurvey$Sex_character)
levels(csurvey$Sex_factor)
lm(Height ~ Sex_factor, csurvey)

# Factors also influence the ordering of categorical variables
# in plots
par(mfrow=c(2,1))
plot(Height ~ Sex_factor, csurvey) 
# and the order in tables
table(csurvey$Sex_factor)

# If we wanted to change the order to Male then Female
csurvey$Sex_factor <- factor(csurvey$Sex_character, levels = c("Male", "Female"))
levels(csurvey$Sex_factor)
lm(Height ~ Sex_factor, csurvey) # now male is the reference category
plot(Height ~ Sex_factor, csurvey) 
table(csurvey$Sex_factor)


# Ordered factors
# Factors  
# some factors reflect an ordinal relationship
# e.g., survey frequency-agreement type scales
# For example, see this smoking frequency items
csurvey$Smoke_factor <- factor(csurvey$Smoke)
table(csurvey$Smoke_factor)
# By default it is in the wrong order
csurvey$Smoke_factor <- factor(csurvey$Smoke, c("Never", "Occas", "Regul", "Heavy"))
table(csurvey$Smoke_factor)

# However, we can also influence the type of contrasts performed
csurvey$Smoke_ordered <- factor(csurvey$Smoke, c("Never", "Occas", "Regul", "Heavy"),
                                ordered = TRUE)
# or equivalently
csurvey$Smoke_ordered <- ordered(csurvey$Smoke, c("Never", "Occas", "Regul", "Heavy"))

table(csurvey$Smoke_ordered)
# When included in linear model, we get
# polynomial contrasts for ordered factors
lm(Pulse ~ Smoke_ordered, csurvey)

# Many data import functions have the option of
# importing string variables as characters or factors
# Some use a general configuration option:
opt <- options()
opt$stringsAsFactors
# e.g., 
# read.table(..., stringsAsFactors = ...) 
# read.csv(..., stringsAsFactors = ...) 

# other functions have explicit options to import as factors
# foreign::read.spss(..., use.value.labels = ...




# Exercise 1

library(AER)
help(package = AER)
data("GSS7402")
?GSS7402 # to learn about the dataset
# It might be easier to work with a shorter variable name 

# 1. Run a t-test on whether participants who lived in a city
#    at age 16 (i.e, city16) have more or less education 
#    than those those who did not

# 2. Get correlations between education, number of kids (kids)
#    year, and number of siblings (siblings)

# 3. Run a multiple regresion predicting education from
#    year, kids, and siblings.
# 3.1 Run the model and save the fit

# 3.2 Get a summary of the results

# 3.3 the standardised coefficients

# 3.4 Check whether the residuals are normally distributed

# 3.5 Plot predicted values by residuals


# 4. Factors
# 4.1 create a table of values for ethnicity

# 4.2 Run a regression predicting education from ethnicity

# 4.3 Make a new factor variable where cauc is the reference value
#     and check that this worked by running a regression with 
#     this new ethncity variable as the predictor.


# 5. Comparing models
# 5.1 Fit a model predicting education from 
#     (a) year and siblings 
#     (b) year, siblings, and the interaction
#     and compare the fit of these two models



# Answers 1

library(AER)
help(package = AER)
data("GSS7402")
?GSS7402 # to learn about the dataset
# It might be easier to work with a shorter variable name 
gss <- GSS7402

# 1. Run a t-test on whether participants who lived in a city
#    at age 16 (i.e, city16) have more or less education 
#    than those those who did not
t.test(education ~ city16, gss)

# 2. Get correlations between education, number of kids (kids)
#    year, and number of siblings (siblings)
cor( gss[ ,c("education", "kids", "year", "siblings")])


# 3. Run a multiple regresion predicting education from
#    year, kids, and siblings.
# 3.1 Run the model and save the fit
fit <- lm(education ~ year + kids + siblings, gss)

# 3.2 Get a summary of the results
summary(fit)

# 3.3 the standardised coefficients
QuantPsyc::lm.beta(fit)

# 3.4 Check whether the residuals are normally distributed
hist(residuals(fit))

# 3.5 Plot predicted values by residuals
plot(predict(fit), residuals(fit), pch =".")
par(mfrow = c(2, 2))
plot(fit, pch=".")
par(mfrow = c(1,1))


# 4. Factors
# 4.1 create a table of values for ethnicity
table(gss$ethnicity)

# 4.2 Run a regression predicting education from ethnicity
lm(education ~ ethnicity, gss)

# 4.3 Make a new factor variable where cauc is the reference value
#     and check that this worked by running a regression with 
#     this new ethncity variable as the predictor.
gss$ethnicity_other <- factor( gss$ethnicity, c("cauc", "other"))
lm(education ~ ethnicity_other, gss)


# 5. Comparing models
# 5.1 Fit a model predicting education from 
#     (a) year and siblings 
#     (b) year, siblings, and the interaction
# and compare the fit of these two models
fit1 <- lm(education ~ year + siblings, gss)
fit2 <- lm(education ~ year * siblings, gss)
summary(fit1)
summary(fit2)
anova(fit1, fit2)
```