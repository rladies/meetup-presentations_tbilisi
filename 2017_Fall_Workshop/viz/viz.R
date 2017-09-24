install.packages("tidyverse")

library(ggplot2)
library(tidyverse)

setwd("D:\\Dropbox\\My Projects\\Courses\\R_LADIES\\viz")
data(mtcars)
p <- ggplot(mtcars)
print(p)
summary(p)

p <- ggplot(mtcars, aes(x=mpg, y=wt))

p + geom_point()

p + geom_point(aes(colour = factor(cyl)))


gg <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + labs(title="გაბნევის დიაგრამა :)", x="კარატი", y="ფასი")

gg1 <- gg + theme(plot.title=element_text(size=30, face="bold"), 
                  axis.text.x=element_text(size=15), 
                  axis.text.y=element_text(size=15),
                  axis.title.x=element_text(size=25),
                  axis.title.y=element_text(size=25)) + 
scale_color_discrete(name="Cut of diamonds")  # add title and axis text, change legend title.
print(gg1)  # print the plot

print(gg)


### Economist

install.packages("ggthemes")
library("ggthemes")
econ$font <- factor(1)
econ <- read.csv("data/EconomistData.csv")

ggplot(econ, aes(x=CPI, y=HDI, colour=Region)) + 
    geom_point(shape=21, size=4)+
	  scale_fill_manual(values = alpha(c("#8c510a", "#d8b365", "#f6e8c3", "#f5f5f5", "#c7eae5", "#5ab4ac", "#01665e")))+
    geom_text(aes(label=Country), size = 3, position=position_jitter(width=0.1, height=0.1), check_overlap = T)+
    theme_economist()+
    labs(title="Corruption and human development", x="Corruption Perception Index, 2011", y="Human Development Index, 2011")
	  