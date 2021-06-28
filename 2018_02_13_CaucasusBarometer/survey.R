library(foreign)
library(readstata13)
library(haven)
library(dplyr)
library(ggplot2)


library(survey)

setwd("D:\\Dropbox\\My projects\\Courses\\R_LADIES\\survey\\Feb_13")


raioni <- read.csv("data/hypothetical.csv", sep = "\t")

names(raioni)

mean(raioni$Age)
mean(raioni$WidespreadName)

set.seed(42)
raioni$sample <- rnorm(nrow(raioni))
raioni <- raioni[order(-raioni$sample) , ]

sample <- subset(raioni[1:1000, ])

mean(sample$Age)
mean(sample$WidespreadName)

cbspss <- read.spss("data/CB_2017_Georgia_public_17.11.17.sav") ### Foreign
cbstata <- read.dta("data/CB_2017_Georgia_public_17.11.17.dta") ### Foreign
cbstata <- read.dta13("data/CB_2017_Georgia_public_17.11.17.dta") ### readstata13

cb <- read_dta("data/CB_2017_Georgia_public_17.11.17.dta") ### Haven
cb <- read_sav("data/CB_2017_Georgia_public_17.11.17.sav") ### Haven

cb$RATEHAP[cb$RATEHAP < -2] <- NA

table(cb$RATEHAP)
prop.table(table(cb$RATEHAP))

RATEHAP.table <- na.omit(count(x = cb, RATEHAP, wt = INDWT))
RATEHAP.table$proportion <- RATEHAP.table$n/sum(RATEHAP.table$n)
RATEHAP.table

RATEHP.RESPSEX <- cb %>%
              group_by(RESPSEX) %>%
              count(., RATEHAP, wt = INDWT)%>%
              mutate(n/sum(n))
RATEHP.RESPSEX

chisq.test(cb$RATEHAP, cb$RESPSEX)
t.test(cb$EDUYRS, cb$RESPSEX)

ggplot(RATEHAP.table, aes(RATEHAP, proportion))+
  geom_bar(stat="identity")


RATEHAP.table$RATEHAP <- factor(RATEHAP.table$RATEHAP,
                       levels=c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                              -1, -2),
                       labels=c("Very unhappy", "2", "3", "4",
					   "5", "6", "7", "8", "9", "Very happy",
					   "DK", "RA"))


ggplot(RATEHAP.table, aes(RATEHAP, proportion, fill=RATEHAP))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("#543005", "#8c510a", "#bf812d",
                             "#dfc27d", "#f6e8c3", "#c7eae5",
                             "#80cdc1", "#35978f", "#01665e",
                             "#003c30", "#444444", "#999999"))+
  labs(title="Overall, how happy would you say you are?",
       subtitle="Caucasus Barometer 2017, Georgia")+
  theme_minimal()

crosstab <- cb %>%
  group_by(RESPSEX) %>%
  count(., RATEHAP, wt = INDWT)%>%
  mutate(n/sum(n))


crosstab$RESPSEX <- factor(crosstab$RESPSEX,
                           levels=c(1, 2),
                           labels=c("Male", "Female"))

crosstab$RATEHAP <- factor(crosstab$RATEHAP, levels=c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                              -1, -2),
                       labels=c("Very unhappy", "2", "3", "4",
                                "5", "6", "7", "8", "9", "Very happy",
                                "DK", "RA"))

ggplot(crosstab, aes(RESPSEX, `n/sum(n)`, fill=RATEHAP))+
  geom_bar(stat="identity", aes(group=RATEHAP), position="dodge")+
  scale_fill_manual(values=c("#543005", "#8c510a", "#bf812d", "#dfc27d", "#f6e8c3", "#c7eae5", "#80cdc1", "#35978f", "#01665e", "#003c30", "#444444", "#999999"))+
  labs(title="Overall, how happy would you say you are?",
       subtitle="BY Gender",
      caption="Caucasus Barometer 2017, Georgia")


cb$PSU[cb$PSU==202013] <- 202014
cb$PSU[cb$PSU==1106004] <- 1106014

cbs<-svydesign(id=~PSU+ID, strata=~SUBSTRATUM, weights=~INDWT, 
               fpc=~NPSUSS+NHHPSU, data=cb)

RATEHAP.svy <- as.data.frame(svymean(~factor(RATEHAP), cbs, na.rm=TRUE))
