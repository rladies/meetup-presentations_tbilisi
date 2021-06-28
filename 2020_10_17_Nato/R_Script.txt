
#----------მონაცემთა ვიზუალიზაცია-----------------#
# სამუშაო გარემოს დაყენება
setwd ("C:\\Users\\usser\\Desktop\\R_Ladies_2020")
getwd()

### მონაცემთა ბაზის გახსნა ###

install.packages("readxl")
library(readxl)

mydata <- read_excel("datafinal.xlsx")


# მონაცემთა ბაზის გახსნის მეორე გზა
mydata <- read.csv(file.choose())

mydata <- read_excel(file.choose())

# მონაცემების პირველადი შესწავლა #

View(mydata)
dim(mydata)
head (mydata)
tail(mydata)
names(mydata)
str(mydata)

table(mydata$name)

summary(mydata)

summary(mydata$grant)

# გამოტოვებული მონაცემის ჩანაცვლება


mydata$grant <- ifelse(is.na(mydata$grant),
                         0,
                       mydata$grant)

summary(mydata$grant)

# გამოტოვებული მონაცემის ჩანაცვლება საშუალო /მედიანა

mydata$grant1 <- ifelse(is.na(mydata$grant),
                          mean(mydata$grant,na.rm=TRUE),
                        mydata$grant)

mydata$grant2 <- ifelse(is.na(mydata$grant),
                        median(mydata$grant,na.rm=TRUE),
                        mydata$grant)

# ggplot პაკეტის დაყენება
install.packages("ggplot2")
library (ggplot2)


### მონაცმეთა ვიზუალიზაციისთვის ვმუშაობთ ggplot გარემოში###
#-----------Aesthetics---------------

ggplot(data=mydata,aes(x=name, 
                       y=math))


# კოდმა არაფერი გამოგვიტანა ვინაიდან აუცილებელი მივუთითოთ
# გრაფიკის გეომეტრიული სახე (geometrylayer)
# ავაგოთ წერტილოვანი და წრფივი გრაფიკები

ggplot(data=mydata,aes(x=name, 
                       y=math))+
  geom_point()

ggplot(data=mydata,aes(x=name, 
                       y=skills))+
  geom_point()

ggplot(data=mydata,aes(x=name, 
                       y=cons))+
  geom_point()

ggplot(data=mydata,aes(x=name, 
                       y=grant))+
  geom_line()

ggplot(data=mydata,aes(x=math, 
                       y=skills))+
  geom_point()


ggplot(data=mydata,aes(x=cons, 
                       y=skills))+
  geom_point()

####-----------------####


ggplot(data=mydata,aes(x=math, 
                       y=foreign))+
  geom_point()

ggplot(data=mydata,aes(x=geo, 
                       y=skills))+
  geom_point()


### ----------### 

#გრაფიკზე ფერის და თემის დამატება

ggplot(data=mydata,aes(x=name, 
                       y=cons, colour=name))+
  geom_point() 

ggplot(data=mydata,aes(x=name, 
                       y=cons, colour=name))+
  geom_point()+ theme_classic()

ggplot(data=mydata,aes(x=name, 
                       y=cons, colour=name))+
  geom_point() + theme_minimal()


#გრაფიკზე ზომის დამატება
ggplot(data=mydata,aes(x=name, 
                       y=cons, colour=name, size=fac))+
  geom_point() + theme_minimal()

ggplot(data=mydata,aes(x=name, 
                       y=cons, colour=name, size=grant))+
  geom_point() + theme_minimal()

ggplot(data=mydata,aes(x=name, 
                       y=skills, colour=name, size=grant))+
  geom_point() + theme_minimal()


# ფერის დამატება შეგვიძლია ორი გზით (mapping vs setting)
# პირველ შემთხვევაში ესთეტიკის ფუნქციის მემშვეობით
# როგორც ზემოთ დავამატეთ(mapping)

ggplot(data=mydata,aes(x=name, 
                       y=cons))+
  geom_point(aes(colour=name)) + theme_minimal()


# მეორე შემთხვევაში ვუთითებთ ფერს(setting)

ggplot(data=mydata,aes(x=name, 
                       y=cons))+
  geom_point(colour="DarkGreen") + theme_minimal()


# შეცდომაა შემდეგი ჩანაწერი

ggplot(data=mydata,aes(x=name, 
                       y=cons))+
  geom_point(aes(colour="DarkGreen")) + theme_minimal()

### ასევე შეგვიძლია ზომის შეცვლის შემთხვევაშიც

ggplot(data=mydata,aes(x=name, 
                       y=cons))+
  geom_point(aes(colour=name, size=grant)) + theme_minimal()


ggplot(data=mydata,aes(x=name, 
                       y=cons))+
  geom_point(colour="DarkGreen", size=2) + theme_minimal()


# შეცდომაა

ggplot(data=mydata,aes(x=name, 
                       y=math))+
  geom_point(aes(colour="DarkGreen", size=2)) + theme_minimal()


#-------Geometric---------
# შეგვიძლია შევქმნათ ცვლადი მთავარი მახასიათებლებით, რომელზეც გვჭირდება 
#გრაფიკების აგება და შემდგომ დავუმატოთ სხვადასხვა შრეები

var1 <- ggplot(data=mydata,aes(x=skills, 
                       y=cons, colour=name)) +
   theme_minimal()

#წერტილოვანი გრაფიკი

var1 + geom_point() 

# წრფივი გრაფიკი
var1 + geom_line()


# შეგვიძლია მივუთითოთ ორივე სახე ერთდროულად
var1 + geom_point() + geom_line()


#სიგლუვის დამატება 
# თუ ცვლადის შექმნის დროს ძირითად მახასითებელში ჩავდებთ ფერის კლასიფიკაციას ცვლადით
# განაწილების ტრენდს გამოიტანს თითოეული კატეგორიისთვის (ფერის ცვლადის კატეგორიებისთვის)

var1 + geom_point()+geom_smooth()

var1 + geom_point()+geom_smooth(fill=NA)



#მონაცემების დიაპაზონის შეზღუდვა

var1+geom_point()+ylim(1800,2000)+xlim(140,160)


###----------###
var2 <- ggplot(data=mydata,aes(x=name, 
                       y=cons, colour=name)) +
  theme_minimal()


var2+geom_point()+xlim("freeuni","tsu","iset")

var2+geom_point()+xlim("freeuni","tsu","iset")+ylim(2000,2200)


#------------ჰისტოგრამის აგება-------------#

ggplot(data=mydata, aes(x=grant))+geom_histogram()+
  theme_minimal()

#ფერისთ შევსება
ggplot(data=mydata, aes(x=grant,fill=fac))+geom_histogram()+
  theme_minimal() 

# ჰისტორგამის შემთხვევაში მონაცემთა დიაპაზონის შეზღუდვა ხდება განსხვავებულად
# წერტილოვანი დიაგრამის მონაცემთა ამორჩევის ფუნქცია ამ შემთხვევაში არ მუშაობს

ggplot(data=mydata, aes(x=grant,fill=fac))+geom_histogram()+
  theme_minimal() +ylim (50,100)


#ჰისტოგრამის შემთხვევაში ვიყენებთ შემდეგ ბრძანებას

ggplot(data=mydata, aes(x=grant,fill=fac))+geom_histogram()+
  theme_minimal()+
  coord_cartesian(xlim=c(30,100))

#სიმარტივისთვის შევქმნათ ცვლადი

var3 <- ggplot(data=mydata, aes(x=grant))+theme_minimal()
  

var3 +geom_histogram(aes(fill=fac))

var3 +geom_histogram(aes(fill=fac))+
  coord_cartesian(xlim=c(40,100))

# სვეტების მოცულობის ცვლილება

var3 +geom_histogram(bins=10, aes(fill=fac))+
  coord_cartesian(xlim=c(40,100))
  
# ფერების კონტურით გამოყოფა
var3 +geom_histogram(bins=10, aes(fill=fac),colour="black")+
  coord_cartesian(xlim=c(40,110))


# ერთი ფერის ჰისტოგრამის აგება
var3 + geom_histogram(binwidth=10,fill="darkred")+
  coord_cartesian(xlim=c(40,110))

# სვეტების კონტურის დამატება
var3 + geom_histogram(binwidth=10,fill="darkred", colour="black")+
  coord_cartesian(xlim=c(40,110))

var3 + geom_histogram(binwidth=10,fill="DarkGreen", colour="blue")+
  coord_cartesian(xlim=c(40,110))


#---------- სიმკვრივის გრაფიკის აგება (Density)-----------#
var3 + geom_density()

# ფერის დამატება
var3 + geom_density(aes(fill=name))

var3 + geom_density(aes(fill=name))+
  coord_cartesian(xlim=c(40,110),ylim=c(0,0.15))


#------------ Boxplot-ის აგება-------------#

var4 <- ggplot(data=mydata,aes(x=name, 
                               y=cons, colour=name)) +
  theme_minimal()

var4 + geom_boxplot()

# გრაფიკის კონტურების ზომის შეცვლა
var4 + geom_boxplot(size=1.2)

# წერტილოვანი დიაგრამის გამოტანა
var4 + geom_boxplot(size=1.2) + geom_point()

# წერტილების უკანა ფონზე გადატანა
var4+ geom_jitter() + geom_boxplot()

#გამჭირვალობის დამატება
var4+ geom_jitter() + geom_boxplot(size=1.2, alpha=0.8)

#--------გრაფიკის კლასიფიკაცია (Facets)---------------

var1+geom_point() 

var1+geom_point() + facet_grid(fac~.)

var1+geom_point() + facet_grid(.~name)

var1+geom_point() + facet_grid(fac~name)

var1+geom_point() + facet_grid(fac~name) +geom_smooth()

var1+geom_point() + facet_grid(fac~name) +geom_smooth(fill=NA)



#------------- დასახელებები-------------#
#კოორდინატთა ღერძების სათაურების დამატება
var5 <- ggplot(data=mydata,aes(x=skills, 
                               y=cons)) +theme_minimal()
  

var5 + geom_point(color="darkgreen")+ xlab("უნარები")+ ylab("კონსოლიდირებული")

#სათაურების ფორმატირება
var5 + geom_point(color="darkgreen")+ xlab("უნარები")+ ylab("კონსოლიდირებული")+
  theme(axis.title.x = element_text(colour="blue",size=15),
        axis.title.y = element_text(colour="red",size=15))

#კოორდინატთა ღერძზე არსებული რიცხვების ზომის შეცვლა

var5 + geom_point(color="darkgreen")+ xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  theme(axis.title.x = element_text(colour="blue",size=15),
        axis.title.y = element_text(colour="red",size=15),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20 ))

# გრაფიკის სათაურის პოზიციის ცვლილება, შეგვიძლია მივანიჭოთ 0-დან 1-მდე 
#მნიშვნელობები, 0-უკიდურესიმარცხენა, 1 მარჯვენა, 0.5 ცენტ

var5 + geom_point(color="darkgreen")+ xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  theme(axis.title.x = element_text(colour="blue",size=15),
        axis.title.y = element_text(colour="red",size=15),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20,hjust=0.5))

# იგივე პრინციპი მოქმედებს კოორდინატთა ღერძების სათაურების პოზიციის ცვლილებისას
var5 + geom_point(color="darkgreen")+ xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  theme(axis.title.x = element_text(colour="blue",size=15,hjust=0),
        axis.title.y = element_text(colour="red",size=15,hjust=1),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20,hjust=0.5))

#ქვესათაური
#წყარო

var5 + geom_point(color="darkgreen")+ xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  theme(axis.title.x = element_text(colour="blue",size=15,hjust=0),
        axis.title.y = element_text(colour="red",size=15,hjust=1),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20,hjust=0.5))+
  labs( subtitle = "ეკონომიკა და ბიზნესი",
        caption="naec.ge") 


# ფერის ( ცვლადი) კლასიფიკატორის ფორმატირება

var5 <- ggplot(data=mydata,aes(x=skills, 
                               y=cons,col=fac)) +theme_minimal()

var5 +geom_point() +xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  guides(col=guide_legend("ფაკულტეტი"))+
  
  theme(axis.title.x = element_text(colour="blue",size=15,hjust=0),
        axis.title.y = element_text(colour="red",size=15,hjust=1),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20,hjust=0.5)) +
  labs( subtitle = "ეკონომიკა და ბიზნესი",
       caption="naec.ge") 
  

#კლასიფიკატორის პოზიციის ცვლილება

var5 +geom_point() +xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  guides(col=guide_legend("ფაკულტეტი"))+
  
  theme(axis.title.x = element_text(colour="blue",size=15,hjust=0),
        axis.title.y = element_text(colour="red",size=15,hjust=1),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20,hjust=0.5),
        legend.position = c(0,1)) +
  labs( subtitle = "ეკონომიკა და ბიზნესი",
        caption="naec.ge") 

#პოზიციის ცვლილების ფუნქციიაში არგუმენტები არის 0 და 1
# შეგვიძლია მივუთითოთ c(0,1) ან მათი სხვა კომბინაია

#იმისათვის, რომ ჩამონათვალის ყველა ელემენტი გამოჩნდეს ვიყენებთ
#შემდეგ ბრძანებას

var5 +geom_point() +xlab("უნარები")+ ylab("კონსოლიდირებული")+
  ggtitle("ეროვნული გამოცდები")+
  guides(col=guide_legend("ფაკულტეტი"))+
  
  theme(axis.title.x = element_text(colour="blue",size=15,hjust=0),
        axis.title.y = element_text(colour="red",size=15,hjust=1),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        plot.title=element_text(colour="darkgreen",
                                size=20,hjust=0.5),
        legend.position = c(0,1),
        legend.justification = c(0,1)) +
  labs( subtitle = "ეკონომიკა და ბიზნესი",
        caption="naec.ge")




#----------- თემის დამატება----------------------------
# გარემოში შეგვიძლია გამოვიყენოთ რამდენიმე სახის თემა

var4 + geom_point()+theme_classic()

var4 + geom_point()+ theme_bw()

var4 + geom_point()+ theme_dark()

var4 + geom_point()+theme_light()

var4 + geom_point()+theme_minimal()

var4 + geom_point()+theme_void()

var4 + geom_point()+theme_linedraw()

