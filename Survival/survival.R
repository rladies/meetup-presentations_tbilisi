######################
# Survival analysis ##
# R-Ladies Tbilisi ###
# Meetup 3 July 2018 #
## Liili Abuladze ####

install.packages("survival")
library("survival")

######################
# create random data #
######################
# age at interview
rnorm(100)
rnorm(4, mean=62, sd=5)
age <- rnorm(100, mean=62, sd=5)
hist(age)

#gender
gender <- rep(1:2, 50)

#event
event <- rep(0:1, each = 5, times = 10)
event

#end time - use it for age at death, for example
rnorm(100)
rnorm(4, mean=69, sd=5)
end_time <- rnorm(100, mean=69, sd=5)
hist(end_time)

#education level
edu <- rep(2:1, 50)
edu
length(edu)

mydata <- data.frame(age_int, gender, event, end_time, edu)

class(mydata)
head(mydata)


#creating a survival object
su_obj <- Surv(mydata$end_time, mydata$event)
su_obj
?Surv

mydata$end_time


fit_km <- survfit(su_obj ~ 1, data = mydata)
fit_km

str(fit_km) # full summary of the fit_km object
str(summary(fit_km)) # full summary of the fit_km object


# Kaplan-Meier survival probability curve 
plot(fit_km)

# Specify plot arguments
plot(fit_km, main="Kaplan-Meier estimate with 95% confidence bounds",
     xlab = "Time", ylab = "Survival function")


##################################################
# VISUALISING SURVIVAL DATA: GGPLOT2 & SURVMINER #
##################################################
install.packages("ggplot2")
library("ggplot2")
install.packages("survminer")
library("survminer")

#creating a Kaplan-Meier survival curve graph
ggsurvplot(fit_km, risk.table = TRUE, xlab = "Age", censor = T)

mydata$gender <- as.numeric(mydata$gender)

# Adding gender to the model
su_stg  <- survfit(su_obj ~ gender, data = mydata)
su_stg

# Plotting cumulative hazard
ggsurvplot(su_stg, fun = "event", censor = T, xlab = "Time")
?ggsurvplot

#fun = "event" plots cumulative events
#fun = "cumhaz" plots the cumulative hazard function 
#fun = "pct" for survival probability in percentage



# Fitting a Cox model
fit.coxph <- coxph(su_obj ~ edu, 
                   data = mydata)

ggforest(fit.coxph, data = mydata)




###########################
# Trying out AIDS dataset #
###########################
mydata2 <- read.csv("/Aids2.csv")
head(mydata2)
str(mydata2)
mydata2$sex <- as.numeric(mydata2$sex)
mydata2$status <- as.numeric(mydata2$status)
mydata2$diag <- as.numeric(mydata2$diag)
mydata2$death <- as.numeric(mydata2$death)
mydata2$age <- as.numeric(mydata2$age)


# Run some descriptives
table(mydata2$sex)
hist(mydata2$age)

# recode age into a categorical variable
mydata2$agecat[mydata2$age <= 25] <- "Up to 25"
mydata2$agecat[mydata2$age > 25 & mydata2$age <= 35] <- "26-35"
mydata2$agecat[mydata2$age > 35 & mydata2$age <= 45] <- "36-45"
mydata2$agecat[mydata2$age > 45] <- "45+"

# create time to event variable
# in this case: time since diagnosis until death
mydata2$time <- mydata2$death - mydata2$diag
hist(mydata2$time)

table(mydata2$status)

# create survival object
su_obj_a <- Surv(mydata2$time, mydata2$status)

# Kaplan-Meier survival curve plot
# survfit requires a formula or a previously fitted model
su_aids  <- survfit(su_obj_a + agecat, data = mydata2)
su_aids

ggsurvplot(su_aids, censor = T, xlab = "Time")

# versus
plot(su_aids)


#can add extras
ggsurvplot(su_aids, censor = T, xlab = "Time",
           conf.int = T,
           pval = T,
           risk.table = T,
           size = 0.5)



# Specifying a Cox survival model
fit.coxph <- coxph(su_obj_a ~ sex + agecat + state, 
                   data = mydata2)

#Hazard ratios
ggforest(fit.coxph, data = mydata2)

# KM curves of the fitted Cox model
su_aids_cox  <- survfit(fit.coxph, data=mydata2)
su_aids_cox

ggsurvplot(su_aids_cox, censor = T, xlab = "Time")


#mydata2$agecat <- as.factor(mydata2$agecat)

