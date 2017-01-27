require(ggplot2)
require(tidyr)
require(dplyr)

setwd("what ever your working directory is")

lb <- read.csv("landbank.csv", header = TRUE)

###convert from wide format to long (indexed) format so a bar-graph can be created
lb_2 <- gather(lb, key = cultivation, value = hectare, harvested, unharvested, -Year, -Company)



lb_plot <- ggplot(lb_2, aes(x=Company, y=hectare, fill=cultivation)) + geom_bar(stat="identity", position= "stack")
lb_plot <- lb_plot + facet_grid(~Year) 
lb_plot <- lb_plot + labs(y="Hectares controlled") + theme_bw()  ##theme_bw makes background white
lb_plot <- lb_plot + scale_y_continuous(labels = scales::comma_format()) ###this converts y axis label values from scientific notation to regular notation
lb_plot <- lb_plot + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) ##this turns x-axis labels 90 degrees
lb_plot <- lb_plot + theme(axis.title.x=element_blank()) + theme(legend.position='bottom')
lb_plot <- lb_plot + guides(fill=guide_legend(title=NULL)) 
lb_plot <- lb_plot + scale_fill_grey() ###this make plot elements black and white


###Using the filter function from dplyr to select out rows, then use pipe %>% to direct outout
###of that filtering into ggplot to then create a new plot. 
lb_2 <- filter(Company != "BEF") %>% ggplot(aes(x=Company, y=hectare, fill=cultivation)) + 
  geom_bar(stat="identity", position = "stack") + facet_grid(~Year)

##ggsave saves the last plot you procuded, whatever that is. Perhaps less useful in Rstudio
##although the ability to set the dpi, in ggsave, is a useful function for creating "print-ready"
##images for publication.
ggsave("C:/Users/Brian/Dropbox/Dropbox/Swedish Black Earth/Figures and Maps/Figures/landbank.tiff", dpi=300)


pop_yield <- read.csv("pop_yield_trend.csv", header = T)

plot2.1 <- ggplot(pop_yield, aes(x = Ave_pop_growth, y = abs(Latitude), colour = as.factor(Yield_Trend), size = GDP)) + geom_point()
plot2.1 <- plot2.1 + geom_text(aes(y=abs(Latitude)+0.7, label=Country), size = 4.5, vjust=0, check_overlap = T) 
plot2.1 <- plot2.1 + labs(x="average population growth", y="Latitude/Absolute Value")
plot2.1 <- plot2.1 + ggtitle("Figure 14: Average population growth and Latitude \nand Yield Plateau (0) and Substantial Growth Countries (1)")
plot2.1 <- plot2.1 + labs(colour="Yield Trend Group")