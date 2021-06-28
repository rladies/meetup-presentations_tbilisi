######################################################################
##
## Plotting in ggplot
##
######################################################################
# download session 9 files here: https://github.com/rladies/meetup-presentations_tbilisi
##
## BAR CHART + LINE
## Graph 1: Total services trade, by value
##
install.packages(c("ggplot2", "dplyr", "tidyr"))

#call the packages back with require or library
require(ggplot2)
require(dplyr) #data management

#define my working space
mypath <- "C:/Users/KASUTAJA/Documents/RLadies/Session9"

#setting the working directory will save all files in this working directory
setwd(paste(mypath))
#if dont know where you are working, type getwd
getwd()

#header=T means that first line will be header line, providing column titles
#reads comma as a thousand
mydt <- read.csv("Session_9_Georgia_Data_UN.csv", header=T)

#explore data with the following ways before doing anything
head(mydt)
#last lines:
tail(mydt)
#other ways of exploring data
summary(mydt)
class(mydt) # type of class of the data
str(mydt) # gives the structure of the dataset, useful with lists
levels(mydt$variable) #gives all variables we have

########################################
#select a sublevel within a variable
ser.dt <- mydt %>%
  filter(variable=="Total Services Trade")

ser.dt #consists of only "Total Services Trade"

#create a new column "Balance" within this new dataset
Balance <- ser.dt%>%
  group_by(year)%>%
  summarise(value=-diff(value))

Balance

#attach "Balance" to other columns to each other
Balance <- cbind(variable=c(rep("Total Services Trade", 13)),type= c(rep("Balance", 13)), Balance, geo=c(rep("NA", 13)))

Balance

# and attach it to the ser.dt dataset
mydata <- rbind(ser.dt, Balance)

###
### subset with the pipe operator %>%
#pipe operator --> gives a sequence to operations: first look into data, then filter out, then notate
#piping is often faster than using loops
###

#some data manipulation
#take balance out, if the "type" = "Exports" then keep its value, otherwise make it negative
base <- mydata %>%
  filter(type != "Balance") %>% #filter out Balance
  mutate(
    value = ifelse(type == "Exports", value, -value)
  )
#create a different dataframe with balance in it
balance <- mydata %>%
  filter(type == "Balance")

# aes "aesthetics" contains x and y axis

ggplot(balance, aes(x = year, y = value)) +
  geom_bar(data = base, aes(fill = type), stat = "identity") + #plots a bar chart
  geom_point(aes(colour = type)) + #adds points for the line
  geom_line(aes(colour = type, group=type)) + #manually specifying group = 1 indicates you want a single line connecting all the points, it's the same as group=type
  scale_fill_manual(values = c(Exports = "#D55E00", Imports = "#E69F00"), name="") + #name will give you the title of the legend
  scale_colour_manual(values = c(Balance = "black"), name="") + #the line colour changes with this code line
  labs(x = "", y = "Total Services Trade")+
  theme_bw() #change the background colours (black and white)
#change the size of line through theme_bw or by adding size=... to geom_line

#you can also do your own colour themes


#Or save a pdf file by this, you will find the file in your directory:
pdf("Total Services Trade")
ggplot(balance, aes(x = year, y = value)) +
  geom_bar(data = base, aes(fill = type), stat = "identity") +
  geom_point(aes(colour = type)) +
  geom_line(aes(colour = type, group=1)) + #group=1 means you will have one line
  scale_fill_manual(values = c(Exports = "#D55E00", Imports = "#E69F00"), name="") + #"name will give you the title of the legend
  scale_colour_manual(values = c(Balance = "black"), name="") + #the line colour changes with this code line
  labs(x = "", y = "Total Services Trade")+
  theme_bw() #change the background colours (black and white)
dev.off()

#best resolution by using eps, also easy to cut-paste pieces of graphs with it
postscript("name.eps")


##
## PIE/ DONUT CHART
## Graph 2: Exports of services by EBOPS category
##

#select "export of services", callthe new dataset exp.ser
exp.ser <-
  mydt %>%
  filter(variable == "Export of Services")
exp.ser
#create a new variable "pos" - the percentage of services
#a donut chart always implies having a percentage
#have to have 2 things: value and where to put your labels

exp.ser <- exp.ser %>% group_by(year) %>% mutate(pos = cumsum(value)- value/2)
#value/2 because want to have values positioned exactly in the middle
p <- #may not need this if don't want to save the plot as a separate object
  ggplot(exp.ser, aes(x=2, y=value, fill=type))+ #x=2 because it is a donut chart, it always equals 2
  geom_bar(stat="identity")+
  geom_text( aes(label = value, y=pos), size=10, fontface="bold")+
  xlim(0.5, 2.5) + #this slims it down and creates the donut's hole
  coord_polar(theta = "y")+ #bending function
  labs(x=NULL, y=NULL)+
  labs(fill="") +
  scale_fill_manual(values = c(Remaining = "blue", Transportation = "#E69F00", Travel= "#D55E00"), name="")+
  ggtitle("Exports of services by EBOPS category, 2013")+ #for colour code google them, or create your own colour palette
  theme_bw()+
  theme(plot.title = element_text(face="bold",family=c("sans"),size=22), #start erasing anything don't want to have on the figure
        legend.text=element_text(size=15),
        axis.ticks=element_blank(), #or use element_line for specifying the element, not deleting completely
        axis.text=element_blank(),
        axis.title=element_blank(),
        panel.grid=element_blank(),
        panel.border=element_blank())
p

#some palettes are infinite, e.g rainbow palette, but have to tell how many different coulours you want
#
# here are some examples:
col <- colorRampPalette(c("red", "blue"))(14) # interpolate a set of given colors to create new color palettes

require(RColorBrewer) # remember to install the package first!
col.bp <- brewer.pal(3, "Set1") # brewer.pal only has a max of 9 colors see http://colorbrewer2.org/

require(randomcoloR) # remember to install the package first!
col.rc <- as.vector(distinctColorPalette(14)) # here we have 14 colors, max is 40

ggplot(exp.ser, aes(x=2, y=value, fill=type))+ #x=2 because it is a donut chart, it always equals 2
  geom_bar(stat="identity")+
  geom_text( aes(label = value, y=pos), size=10, fontface="bold")+
  xlim(0.5, 2.5) + #this slims it down and creates the donut's hole
  coord_polar(theta = "y")+ #bending function
  labs(x=NULL, y=NULL)+
  labs(fill="") +
  scale_fill_manual(values = col.bp, name="")+
  ggtitle("Exports of services by EBOPS category, 2013")+ #for colour code google them, or create your own colour palette
  theme_bw()+
  theme(plot.title = element_text(face="bold",family=c("sans"),size=22), #start erasing anything don't want to have on the figure
        legend.text=element_text(size=15),
        axis.ticks=element_blank(), #or use element_line for specifying the element, not deleting completely
        axis.text=element_blank(),
        axis.title=element_blank(),
        panel.grid=element_blank(),
        panel.border=element_blank())
##
## BAR CHART
## Graph 3:  Merchandise trade balance
##

mer.bal <-
  mydt %>%
  filter(variable == "Merchandize Trade Balance")

base <- mer.bal %>%
  filter(type != "Balance") %>%
  mutate(
    value = ifelse(type == "Exports", value, -value)
  )
balance <- mer.bal %>%
  filter(type == "Balance")

ggplot(balance, aes(x = geo, y = value, fill=factor(type))) +
  geom_bar(data = base %>%
             filter(type=="Exports"),  aes(col=type), stat = "identity") +
  geom_bar(data = base %>%
             filter(type=="Imports"), aes(col=type), stat = "identity") +
  geom_bar(data = balance, aes(col=type), stat = "identity", width=.2) +
  ggtitle(expression(atop("Merchandise trade balance", atop(italic("(Bln US$ by MDG Regions in 2013)"), "")))) +
  theme_bw()+
  theme(axis.text.x = element_text(size=15, color="black"),
        axis.text.y = element_text(size=15, color="black"),
        legend.text=element_text(size=18),
        plot.title = element_text(size = 25, face = "bold", colour = "black", vjust = -1))+
  scale_fill_manual(values = c(Exports = "#0072B2", Imports = "#56B4E9", Balance="red"), name="") +
  scale_colour_manual(values = c(Exports = "#0072B2", Imports = "#56B4E9", Balance="red"), name="") +
  coord_flip()+
  labs(x = "", y = "")

##
## PYRAMID CHART
##

###
### Graph 4:  Population charts
###

pop <- read.csv("Session_9_Georgia_Population_2014.csv", header=T)

ggplot(pop %>%
         filter(geo=="GEORGIA")
       , aes(x = type, y = Georgians/Total*100, fill=factor(type))) +
  geom_bar(stat = "identity")+
  coord_cartesian(ylim=c(80,100))+
  labs(x = "", y = "% Georgian Population over Total")+
  scale_fill_manual(values = c(Rural = "#0072B2", Urban = "#56B4E9", Total="red"), name="")+
  theme_bw()+
  theme(axis.text.x = element_text(size=15, color="black"),
        axis.text.y = element_text(size=15, color="black"))

ggplot(pop %>%
         filter(geo=="GEORGIA")
       , aes(x = type, y = Georgians/Total*100, fill=factor(type))) +
  geom_bar(stat = "identity")+
  coord_cartesian(ylim=c(80,100))+
  labs(x = "", y = "% Georgian Population over Total")+
  scale_fill_manual(values = c(Rural = "#0072B2", Urban = "#56B4E9", Total="red"), name="")+
  theme_bw()+
  theme(axis.text.x = element_text(size=15, color="black"),
        axis.text.y = element_text(size=15, color="black"))

###
### Graph 5:  Population Pyramids
###

pyr <- read.csv("Session_9_POPULATION_BY_AGE_BOTH_SEXES.csv", header=T)
names(pyr)
head(pyr)
#erase 24th column because want to have age up to 100, not 80+ only:
pyr <- pyr[,-24] #everything before the comma is a row, after comma is a column
names(pyr) #check: now we don't have the extra age group 80+
#make a new variable with names of all variables:
vars <- names(pyr)

#create a vector age where rename with the right age groups
#(r puts an X in front of the number), so want to rename my columns
#don't want to write 20 times so automatise by using seq, make 100+ the last age group
age <- c(paste(seq(0, 95, by=5), "-", seq(4, 99, by=5)), "100+")
age
names(pyr) <- c(vars[1], vars[2], "Major.Area", "sex", vars[5], vars[6], "year", age)
head(pyr)
View(pyr)

library(tidyr) # data management package, use gather to turn dataframes from wide to long format
pyr <- gather(pyr, "age.group", "value", 8:28) #columns 8 to 28 have to squish
head(pyr)
#check again
View(pyr) #now data is in a different, long format

#replace all NA with 0
is.na(pyr$value) <- 0


pyr.g <- pyr %>%
  filter(Major.Area=="Georgia"&sex!="both") #exclude both because need only men and women in a pop pyramid

# view first 30 rows
pyr.g[1:30,]

#create an order vector to sort data
o <- seq(1,21, by=1)
oo <- rep(o,28)

order <-  as.vector(sort(oo, decreasing=F))

pyr.g$order <- order

breaks <- factor(pyr.g$age.group)
levels(breaks)

# write.csv(pyr.g, "Georgia Pyramid.csv")
#use write.csv if want to use dots as decimals, or use write.csv2 for using commas as decimals


### simple pyramid plot
p <- ggplot(pyr.g, aes(x=age.group, y=value, fill=factor(sex)))+
  geom_bar(data=pyr.g %>%
             filter(sex=="female"&year=="2015"),
           aes(x=reorder(age.group, order), y=value), stat="identity")+
  geom_bar(data=pyr.g %>%
             filter(sex=="male"&year=="2015"),
           aes(x=reorder(age.group, order), y=-value), stat="identity")+ #negative value for males not to overlap; reorder values of age group by order; "identity" is only for bar charts
  coord_flip()+ #bending function: flip the coordinates
  labs(x = "", y = "")+
  scale_fill_manual(values = c(female = "red", male = "blue"), name="")+
  scale_x_discrete(breaks=c("0 - 4", "10 - 14", "20 - 24", "30 - 34", "40 - 44", "50 - 54", "60 - 64", "70 - 74", "80 - 84", "90 - 94", "100+" ),labels=c("0 - 4", "10 - 14", "20 - 24", "30 - 34", "40 - 44", "50 - 54", "60 - 64", "70 - 74", "80 - 84", "90 - 94", "100+" ))+ #not to show all the age groups all the time
  scale_y_continuous(breaks=seq(-200,200,25),labels=abs(seq(-200,200,25)))+ #tell R t paste absolute numbers of values not to have negative values on graph
  theme_bw()+
  theme(axis.text.x = element_text(size=10, color="black"), # size of x axis text
        axis.text.y = element_text(size=10, color="black"))

#############################################
### STEP 2: add lines/bars to compare other years
#############################################

p+
  geom_line(data=pyr.g %>%
              filter(sex=="male"&year=="1975"),
            aes(x=reorder(age.group, order), y=-value), colour="lightblue", group=1)+
  geom_line(data=pyr.g %>%
              filter(sex=="female"&year=="1975"),
            aes(x=reorder(age.group, order), y=value), colour="pink", group=1)

# bars: since in ggplot the last plot is the one that appears on top (hiding everything underneath), we can add alpha=0.5 to add some transparence, 1 being the full color
p+
  geom_bar(data=pyr.g %>%
             filter(sex=="male"&year=="1975"),
           aes(x=reorder(age.group, order), y=-value), fill="lightblue", alpha=.5,stat="identity")+
  geom_bar(data=pyr.g %>%
             filter(sex=="female"&year=="1975"),
           aes(x=reorder(age.group, order), y=value), fill="pink", alpha=.5, stat="identity")

##################################################################################
# STEP 3: add different legends for the two years: now we only have one for the sex, as the fill factors for all 4 geom_bar(s) is the same
#
ggplot(pyr.g, aes(x=age.group, y=value, fill=factor(sex), col=factor(year)))+ # add different colors for the two years 1975 and 2015 by adding col=factor(year)
  # this part stays the same
  geom_bar(data=pyr.g %>%
             filter(sex=="female"&year=="2015"),
           aes(x=reorder(age.group, order), y=value),  stat="identity")+
  geom_bar(data=pyr.g %>%
             filter(sex=="male"&year=="2015"),
           aes(x=reorder(age.group, order),  y=-value),  stat="identity")+
  geom_bar(data=pyr.g %>%
             filter(sex=="male"&year=="1975"),
           aes(x=reorder(age.group, order),y=-value),  alpha=.5,stat="identity")+
  geom_bar(data=pyr.g %>%
             filter(sex=="female"&year=="1975"),
           aes(x=reorder(age.group, order),  y=value),  alpha=.5, stat="identity")+
  coord_flip()+
  labs(x = "", y = "")+
  scale_x_discrete(breaks=c("0 - 4", "10 - 14", "20 - 24", "30 - 34", "40 - 44", "50 - 54", "60 - 64", "70 - 74", "80 - 84", "90 - 94", "100+" ),labels=c("0 - 4", "10 - 14", "20 - 24", "30 - 34", "40 - 44", "50 - 54", "60 - 64", "70 - 74", "80 - 84", "90 - 94", "100+" ))+
  scale_y_continuous(breaks=seq(-200,200,25),labels=abs(seq(-200,200,25)))+
  theme_bw()+
  theme(axis.text.x = element_text(size=10, color="black"),
        axis.text.y = element_text(size=10, color="black"))+
  # add the legends with scale_fill_manual which controls the filling colors for sex and scale_color_manual which controls the border color that distinguisces the two years
  scale_fill_manual(values = c(female = "red", male = "blue"), name="")+
  scale_color_manual(values=c("1975"="black", "2015"="grey"),  name="" )+
  # and I want the year legend squares to look empty
  guides(colour = guide_legend(override.aes = list(alpha = 0))) #makes the squares for the years legend empty of any color

###################################################################################
## STEP 4: multiple plots in one page with facet_wrap
##
ggplot(pyr.g, aes(x=age.group, y=value, fill=factor(sex)))+
  geom_bar(data=pyr.g %>%
             filter(sex=="male"),
           aes(x=reorder(age.group, order),  y=-value), stat="identity")+
  geom_bar(data=pyr.g %>%
             filter(sex=="female"),
           aes(x=reorder(age.group, order),  y=value), stat="identity")+
  coord_flip()+
  labs(x = "", y = "")+
  scale_x_discrete(breaks=c("0 - 4",  "20 - 24",  "40 - 44",  "60 - 64",  "80 - 84", "100+" ),labels=c("0 - 4",  "20 - 24",  "40 - 44",  "60 - 64",  "80 - 84",  "100+" ))+
  scale_y_continuous(breaks=seq(-300,300,100),labels=abs(seq(-300,300,100)))+
  scale_fill_manual(values = c(female = "red", male = "blue"), name="")+
  theme_bw()+
  theme(axis.text.x = element_text(size=10, color="black"),
        axis.text.y = element_text(size=10, color="black"))+
  facet_wrap(~year)
