
#  Set working directory

setwd("D:\\Dropbox\\My projects\\Courses\\R_LADIES\\ts_models\\repo")

parl12 <- read.csv("data/parl12.csv", sep="\t")

parl16 <- read.csv("data/parl16.csv", sep="\t")

ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages<-c("ggplot2", "reshape2", "ggthemes", "gridExtra", "grid", "zoo", "e1071")

ipak(packages)

results12 <- data.frame(party=c("Dream", "UNM", "CDM", "OTH"), votes12=c(0.5490, 0.4040, 0.0205, 0.0265))

results16 <- data.frame(party=c("Dream", "UNM", "PA", "FD", "SFP", "UDM", "LAB", "OTH"), votes12=c(0.487, 0.271, 0.05, 0.046, 0.035, 0.035, 0.031, 0.045))

names(parl12)
savg12 <- apply(parl12[5:8], 2, mean)
names(savg12) <- c("simple_average")
total12 <- cbind(results12, savg12)
savg12

savg16 <- apply(parl16[4:(ncol(parl16)-2)], 2, mean)
names(savg16) <- c("Dream", "UNM", "PA", "FD", "SFP", "UDM", "LAB", "OTH")
total16 <- cbind(results16, savg16)
savg16

wavg12 <- lapply(parl12[5:8], weighted.mean,  w = parl12$weight)
wavg12
wavg12 <- melt(wavg12)
names(wavg12) <- c("weighted_average", "party")
total12 <- merge(total12, wavg12, by="party")


wavg16 <- lapply(parl16[4:(ncol(parl16)-2)], weighted.mean,  w = parl16$weight)
wavg16 <- melt(wavg16)
names(wavg16) <- c("weighted_average", "party")
total16 <- merge(total16, wavg16, by="party")

total12 <- melt(total12[1:4])
total12$elections <- c("2012")

total16 <- melt(total16[1:4])
total16$elections <- c("2016")

total <- rbind(total12, total16)
levels(total$variable)

levels(total$variable) <-c("Vote Share", "Simple Average", "Weighted Average","Simple Average")

pl12<- ggplot(data=total[total$elections=="2012",], aes(party, value, fill = party))+
  geom_col()+
  ylim(0, 1)+
  scale_fill_manual(values = c("#9a142c", "#195ea2", "grey", "#e4012e"))+
  facet_grid(~variable)+
  scale_x_discrete(limits=c("UNM", "Dream", "CDM", "OTH"), labels=c("UNM", "GDC", "CDM", "Others"))+
  theme_fivethirtyeight()+
  theme(legend.position="none"
  )+
  labs(title = "2012",
       x = "Parties",
       y = "%")+
  geom_hline(yintercept = 0.05, color = "red")

print(pl12)

pl16<- ggplot(data=total[total$elections=="2016",], aes(party, value, fill = party))+
  geom_col()+
  ylim(0, 1)+
  facet_grid(~variable)+
  scale_x_discrete(limits=c("Dream", "UNM", "PA", "FD", "SFP", "UDM", "LAB", "OTH"), labels=c("Dream", "UNM", "PA", "FD", "SFP", "UDM", "LAB", "Other"))+
  scale_fill_manual(values = c("#195ea2", "grey", "#e4012e", "#003087", "#faa41f", "#e7b031", "#ec1c24", "#33ace2"))+    
  theme_fivethirtyeight()+
  theme(legend.position="none"
  )+
  labs(title = "2016",
       x = "Parties",
       y = "%") +
  geom_hline(yintercept = 0.05, color = "red")
print(pl16)


parl12$Date <- as.Date(parl12$Date, format="%m/%d/%Y")

parl12.zoo <- zoo(x=parl12$UNM, order.by = parl12$Date)

a <- rollmean(parl12.zoo, 2)

a <- as.data.frame(a)
a

parl16$Date <- as.Date(parl16$Date, format="%m/%d/%Y")

parl16.zoo <- zoo(x=parl16$UNM, order.by = parl16$Date)

rollmean(parl16.zoo, 1)

WTI.hwm <- HoltWinters(parl12$UNM, gamma=FALSE )
WTI.hwf <- forecast.HoltWinters(WTI.hwm, h=3)
summary(WTI.hwf)

