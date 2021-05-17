# finding help
help(haven)
??haven
# stackoverflow

# loading SPSS or STATA datasets into R using the haven package
cb2015 <- read_sav("/home/eric/data/CB_2015_Regional_Only_Responses_140416.sav")
attach(cb2015)

# summary of dataset
structure(cb2015)
class(cb2015)
nrow(cb2015)
ncol(cb2015)
typeof(cb2015$COUNTRY)
class(cb2015$RESPONSE)

# accessing labels from data imported from SPSS format
library(Hmisc)
label(cb2015$CBYEAR)

# subsets
firstThreeCols <- cb2015[,1:3]
firstTenRows <- cb2015[1:10,]
threeColsThreeRows <- cb2015[1:10,1:3]
georgia <- subset(cb2015, cb2015$COUNTRY == 3) # <, <=, >, >=, ==, !=, !x, x | y, x & y, isTrue(x)

# factors using data imported with haven
cb2015$COUNTRY <- as_factor(cb2015$COUNTRY)
cb2015$BANKACC <- as_factor(cb2015$BANKACC)

# factor subsets
bankAccount <- subset(cb2015, cb2015$BANKACC != "Break off" | cb2015$BANKACC != "Legal skip")
bankAccount <- subset(bankAccount, cb2015$BANKACC != "Interviewer error")
levels(bankAccount$BANKACC)
levels(droplevels(bankAccount$BANKACC))

# interviewing your data with qplot (ggplot2)
# datasets: diamonds, economics
library(ggplot2)
# scatterplot 
qplot(data=diamonds,x=carat,y=price)
# color
qplot(data=diamonds, x=carat, y=price, color=color)
# line graph
qplot(data=economics, x=economics$date, y=economics$uempmed,color=format(economics$date, "%Y"))
# bar graph
qplot(data=diamonds, x=cut, y=carat, geom="boxplot")
