### Kaggle - Titanic Challenge
### based on code by Hilla Behar

##### ვალიდა ფანცულაია & მარიამ ასათიანი #####
### R-Ladies Tbilisi 
### 14 ნოემბერი, 2020

# სამუშაო ფოლდერის ნახვა/დაყენება
getwd()
setwd("/Users/MariamAsatiani/Desktop/titanic")

# იმ პაკეტების გადმოწერა რომლებიც ამ პროექტისთვის დაგვჭირდება
install.packages("ggplot2")
install.packages("dplyr")
install.packages("GGally")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("randomForest")

# გადმოწერილი პაკეტების "გამოძახება"
library(ggplot2)
library(dplyr)
library(GGally)
library(rpart)
library(rpart.plot)
library(randomForest)

# მონაცემების გახსნა
test <- read.csv("test.csv")
train <- read.csv("train.csv")

# ახალი მონაცემთა ბაზის შექმნა train და test ბაზების გაერთიანებით
full <- bind_rows(train,test)
LT=dim(train)[1]


# მონაცემთა ბაზის დათვალიერება
names(full)
head(full)
summary(full)
str(full)

# გამოტოვებული უჯრების/მნიშვნელობების ნახვა
colSums(is.na(full))
colSums(full=="")

# Embarked ველში, ცარიელი უჯრები შევავსოთ "C"-თი
full$Embarked[full$Embarked==""]="C"

# ვნახოთ თითოეულ სვეტში რამდენი უნიკალური მონაცემია
apply(full,2, function(x) length(unique(x)))

# Survived, Pclass, Sex და Embarked გადავაკეთოთ ფაქტორებად
cols<-c("Survived","Pclass","Sex","Embarked")
for (i in cols){
  full[,i] <- as.factor(full[,i])
}

str(full)


####### ანალიზი ######

# ვნახოთ რა კავშირია სხვადასხვა მახასიათებლებს შორის:

# სქესი და გადარჩენა
ggplot(data=full[1:LT,],aes(x=Sex,fill=Survived))+geom_bar()
# სადგური და გადარჩენა
ggplot(data = full[1:LT,],aes(x=Embarked,fill=Survived))+geom_bar(position="fill")+ylab("Frequency")
# სადგური და კლასი
ggplot(data = full[1:LT,],aes(x=Embarked,fill=Pclass))+geom_bar(position="fill")+ylab("Frequency")


# ცხრილის სახით შევხედოთ სხვადასხვა სადგურიდან გადარჩენილების წილს
t <-table(full[1:LT,]$Embarked,full[1:LT,]$Survived)
for (i in 1:dim(t)[1]){
  t[i,]<-t[i,]/sum(t[i,])*100
}
t


# კლასი და გადარჩენა
ggplot(data = full[1:LT,],aes(x=Pclass,fill=Survived))+geom_bar(position="fill")+ylab("Frequency")

# სადგური, კლასი, გადარჩენა
ggplot(data = full[1:LT,],aes(x=Embarked,fill=Survived))+geom_bar(position="fill")+facet_wrap(~Pclass)

# შევხედოთ რიცხვებს
table(full[1:LT,]$Pclass, full[1:LT,]$Embarked, full[1:LT,]$Survived)

# SibSp, Parch, და Survived
ggplot(data = full[1:LT,],aes(x=SibSp,fill=Survived))+geom_bar()
table(full[1:LT,]$SibSp, full[1:LT,]$Survived)


s <-table(full[1:LT,]$SibSp,full[1:LT,]$Survived)
for (i in 1:dim(s)[1]){
  s[i,]<-s[i,]/sum(s[i,])*100
}
s

ggplot(data = full[1:LT,],aes(x=Parch,fill=Survived))+geom_bar()
table(full[1:LT,]$Parch, full[1:LT,]$Survived)

p <-table(full[1:LT,]$Parch,full[1:LT,]$Survived)
for (i in 1:dim(p)[1]){
  p[i,]<-p[i,]/sum(p[i,])*100
}
p

# SibSp და Parch დიდად განსხვავებულ ინფორმაციას არ გვაძლევს
# მათი გაერთიანებით შევქმნათ ახალი ველი FamilySize

full$FamilySize <- full$SibSp + full$Parch +1;
full1<-full[1:LT,]
ggplot(data = full1[!is.na(full[1:LT,]$FamilySize),],aes(x=FamilySize,fill=Survived))+geom_histogram(binwidth =1,position="fill")+ylab("Frequency")

# Survived და Age
ggplot(data = full1[!(is.na(full[1:LT,]$Age)),],aes(x=Age,fill=Survived))+geom_histogram(binwidth =3)
ggplot(data = full1[!is.na(full[1:LT,]$Age),],aes(x=Age,fill=Survived))+geom_histogram(binwidth = 3,position="fill")+ylab("Frequency")

# Fare და Survived
ggplot(data = full[1:LT,],aes(x=Fare,fill=Survived))+geom_histogram(binwidth =20, position="fill")

# ცარიელი უჯრები ჩავანაცვლოთ სხვა მონაცემების საშუალოთი
full$Fare[is.na(full$Fare)] <- mean(full$Fare,na.rm=T)

sum(is.na(full$Age))
full$Age[is.na(full$Age)] <- mean(full$Age,na.rm=T)
sum(is.na(full$Age))

# შევქნათ ახალი ველი მგზავრის წოდებისთბის
full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)
full$Title[full$Title == 'Mlle']<- 'Miss' 
full$Title[full$Title == 'Ms']<- 'Miss'
full$Title[full$Title == 'Mme']<- 'Mrs' 
full$Title[full$Title == 'Lady']<- 'Miss'
full$Title[full$Title == 'Dona']<- 'Miss'
officer<- c('Capt','Col','Don','Dr','Jonkheer','Major','Rev','Sir','the Countess')
full$Title[full$Title %in% officer]<-'Officer'

full$Title<- as.factor(full$Title)

ggplot(data = full[1:LT,],aes(x=Title,fill=Survived))+geom_bar(position="fill")+ylab("Frequency")

#### პროგნოზი #####

# train set მნიშვნელოვანი ველებით 
train_im<- full[1:LT,c("Survived","Pclass","Sex","Age","Fare","SibSp","Parch","Title")]
ind<-sample(1:dim(train_im)[1],500) # 500/891
train1<-train_im[ind,] # train set 
train2<-train_im[-ind,] # test set

# შევქმნათ ლოგისტიკური რეგრესიის მოდელი
model <- glm(Survived ~.,family=binomial(link='logit'),data=train1)
summary(model)

# გამოვცადოთ ჩვენი მოდელი ჩვენ შექმნილ სატესტო სეტზე (train2):
pred.train <- predict(model,train2)
pred.train <- ifelse(pred.train > 0.5,1,0)

# ვნახოთ რამდენად სწორია ჩვენი მოდელი 
mean(pred.train==train2$Survived)

t1<-table(pred.train,train2$Survived)
t1

# რამდენი გადარჩენა/სიკვდილი პროცენტი გამოვიცანით სწორად
presicion<- t1[1,1]/(sum(t1[1,])) #გვიჩვენებს სწორად გამოცნობილი სიკვდილიანობის პროცენტს
recall<- t1[1,1]/(sum(t1[,1])) #გვიჩვენებს სწორად გამოცნობილი სიკვდილიანობის პროცენტს

presicion # გამოცნობილი გარდაცვლილების რაოდენობის რა პროცენტი გარდაიცვალა მართლა
recall # მართლა გარდაცვლილების რამდენი პროცენტი გამოვიცანით

count(train2, train2$Survived == 0)

# F1 score 
F1 <- 2*presicion*recall/(presicion+recall)
F1

# შევამოწმოთ ჩვენი მოდელი test set-ზე:
test_im<-full[LT+1:1309,c("Pclass","Sex","Age","SibSp","Parch","Fare","Title")]

pred.test <- predict(model,test_im)[1:418]
pred.test <- ifelse(pred.test > 0.5,1,0)
res<- data.frame(test$PassengerId,pred.test)
names(res)<-c("PassengerId","Survived")
write.csv(res,file="res.csv",row.names = F)

#ახლა გამოვიყენოთ decision tree მოდელის შესაქმნელად:
model_dt<- rpart(Survived ~.,data=train1, method="class") #რეკურსიული დაყოფა კლასის მიხედვით
rpart.plot(model_dt)

pred.train.dt <- predict(model_dt,train2,type = "class")
mean(pred.train.dt==train2$Survived)

t2<-table(pred.train.dt,train2$Survived)
t2

presicion_dt<- t2[1,1]/(sum(t2[1,]))
recall_dt<- t2[1,1]/(sum(t2[,1]))
presicion_dt
recall_dt

F1_dt<- 2*presicion_dt*recall_dt/(presicion_dt+recall_dt)
F1_dt

# ვცადოთ ეს მოდელი test set-ზე:
pred.test.dt <- predict(model_dt,test_im,type="class")[1:418]
res_dt<- data.frame(test$PassengerId,pred.test.dt)
names(res_dt)<-c("PassengerId","Survived")
write.csv(res_dt,file="res_dt.csv",row.names = F)

# ვცადოთ მესამე მოდელი random forest-ის გამოყენებით
model_rf<-randomForest(Survived~.,data=train1)
# შევხედოთ ცდომილებას
plot(model_rf)


pred.train.rf <- predict(model_rf,train2)
mean(pred.train.rf==train2$Survived)

t1<-table(pred.train.rf,train2$Survived)
t1

presicion<- t1[1,1]/(sum(t1[1,]))
recall<- t1[1,1]/(sum(t1[,1]))
presicion
recall

F1<- 2*presicion*recall/(presicion+recall)
F1

# ვცადოთ ტესტ სეტზე:
pred.test.rf <- predict(model_rf,test_im)[1:418]
res_rf<- data.frame(test$PassengerId,pred.test.rf)
names(res_rf)<-c("PassengerId","Survived")
write.csv(res_rf,file="res_rf.csv",row.names = F)

