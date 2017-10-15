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


# Univariate statistics

# sample size
nrow(cas)

# Frequencies or percentages on categorical variables
table(cas$grades) # frequency counts
prop.table(table(cas$grades)) # proportions

newdata <- cas[c("expenditure","calworks","lunch")]

# Bivariate correlations 
cor(newdata, use="complete.obs", method="kendall")

round(cor(newdata, use="complete.obs", method="kendall"), 2) # round to 2 decimal places
library(Hmisc)
rp <- rcorr(as.matrix(newdata)) # significance test on correlations
rp
ifelse(rp$P < .05, "*", "")

# Scatterplot matrix with correlations
library(psych)
pairs.panels(newdata)


# Regression models

# By default, you don't get much output
lm(performance ~ expenditure + calworks + lunch, data = cas)

# You need to save the model to an object
fit <- lm(performance ~ expenditure + calworks + lunch, cas)
fit1 <- lm(performance ~ expenditure + lunch, cas)

summary(fit) # summary info
summary(fit1)

# Check normality of residuals
# plot predicted by residuals
residuals(fit)
res <- data.frame(residuals(fit))

plot(residuals(fit))
hist(residuals(fit))
shapiro.test(residuals(fit))

# standardised coefficients
library(QuantPsyc)
QuantPsyc::lm.beta(fit)
fit_standardised <- lm(scale(performance) ~ scale(expenditure) + scale(calworks) + scale(lunch), cas)
summary(fit_standardised)

# more information on regression diagnostics
# http://www.statmethods.net/stats/rdiagnostics.html



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



# Exercise 1

library(AER)
help(package = AER)
data("GSS7402")
?GSS7402 # to learn about the dataset
# It might be easier to work with a shorter variable name 



# 1. Get correlations between education, number of kids (kids)
#    year, and number of siblings (siblings)

# 2. Run a multiple regresion predicting education from
#    year, kids, and siblings.
# 2.1 Run the model and save the fit

# 2.2 Get a summary of the results

# 2.3 the standardised coefficients

# 2.4 Check whether the residuals are normally distributed


# 3. Factors
# 3.1 create a table of values for ethnicity

# 3.2 Run a regression predicting education from ethnicity

# 3.3 Make a new factor variable where cauc is the reference value
#     and check that this worked by running a regression with 
#     this new ethncity variable as the predictor.




# Answers 1

library(AER)
help(package = AER)
data("GSS7402")
?GSS7402 # to learn about the dataset
# It might be easier to work with a shorter variable name 
gss <- GSS7402


# 1. Get correlations between education, number of kids (kids)
#    year, and number of siblings (siblings)
cor( gss[ ,c("education", "kids", "year", "siblings")])


# 2. Run a multiple regresion predicting education from
#    year, kids, and siblings.
# 3.1 Run the model and save the fit
fit <- lm(education ~ year + kids + siblings, gss)

# 3.2 Get a summary of the results
summary(fit)

# 3.3 the standardised coefficients
QuantPsyc::lm.beta(fit)

# 3.4 Check whether the residuals are normally distributed
hist(residuals(fit))


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


