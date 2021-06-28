x=c(4,3,7,1,7,3,8.4,5,12,9,12) ##შევქმენით 10 მონაცემისგან შემდგარი ვექტორი
is.ts(x)  ##ვეკითხებით, არის x დროითი მწკრივი
y=as.ts(x)  ##გადააკეთე x დროით მწკრივად
y
time(y)  ##გვიბრუნებს დროითი მწკრივის აღწერას
is.ts(y) ##ვეკითხებით, არის y დროითი მწკრივი?
##R-ის პროგრამა მუშაობს სხვადასხვა ტიპის ობიექტებთან: 
##ვექტორებთან, შესაბამისი ბრძანებებია (is.vector, as.vector)
##მატრიცებთან,შესაბამისი ბრძანებებია (is.matrix, as.matrix)
##მონაცემთა ცხრილებთან, შესაბამისი ბრძანებებია(is.data.frame, as.data.frame)
##დროით მწკრივებთან, შესაბამისი ბრძანებებია (is.ts, as.ts)
##სიებთან, შესაბამისი ბრძანებებია (is.list, as.list) 
t=tsp(y)    ##y მწკრივს დავუკავშირეთ t დროითი მწკრივი
plot.ts(y)
plot.ts(y,type="b")
z=ts(y,freq=4) ##დავყოთ მწკრივი კვარტლებად (შეგვიძლია თვეებად =12)
z
time(z)
plot.ts(z)
frequency(z)
length(z)
m=tapply(z,cycle(z),mean) ##ვითვლით საშუალოს კვარტლების მიხედვით
m
##დროითი მწკრივის სიმულაცია, 
##r -შემთხვევითი რიცხვის წარმომქმნელი პრეფიქსი
##p-განაწილების ფუნქციის წარმომქმნელი პრეფიქსი
##q-კვანტილი

qnorm(0.95) ##სტანდარტული ნორმალური განაწილენის 95%-იანი კვანტილი
pnorm(1.64) ##განაწილების ფუნქცია 2 კვანტილში
##წარმოვქმნათ 100 ცვლადი გაუსის მიხედვით დამოუკიდებლად განაწილებული, N(-1,3)
eps=rnorm(100,-1,3^0.5)
mean(eps)
var(eps)
plot(eps)
is.ts(eps)
epsi=ts(eps)
plot.ts(eps)
##წარმოვქმნათ თეთრი ხმაური
x=rnorm(30)
par(mfrow=c(2,2)) ##გრაფიკების ფანჯარას ვყოფთ ოთხად
plot.ts(x)
hist(x,nclass=6)
qqnorm(x) ##x-ის მნიშვნელობები თეორიული N(0,1) კვანტილის მიხედვით
abline(0,1) #ბისექტრისა


## exercise
t=1:82
k=1980+t/4
a=0.02*k+3
a
Sai=rep(c(5,-1,-7,3),21)
S=Sai[1:82]
S

epsi=rnorm(82,0,1.5^0.5)
epsi
mean(epsi)
var(epsi)
X=a+S+epsi
plot.ts(X)
is.ts(X)
y=as.ts(X)
is.ts(y)
z=ts(y,freq=4,1980+1/4,2000+2/4)
plot(z)

##წარმოვქმნათ დროითი მწკრივი ტრენდით

t=1:120
a=10*sqrt(t+200/log(t+2))
eps=10*rnorm(120)
X=a+eps
plot.ts(X)
##დროზე დარეგრესირებული X-ის წრფივი რეგრესია
reg1=lm(X~t) 
abline(reg1)
plot(reg1)
names(reg1)
reg1$coef
summary(reg1)
segments(t,reg1$fit,t,X) 
reg1$res
win.graph()
par(mfrow=c(2,2))
plot(reg1,las=1)

##მეორე რიგის პოლინომიალური რეგრესია

reg2=lm(X~poly(t,2))
plot.ts(X)
lines(t,reg2$fit)
summary(reg2)
segments(t,reg2$fit,t,X)

##მეცხრე რიგის პოლინომიალური რეგრესია
reg2=lm(X~poly(t,9))
plot.ts(X)
lines(t,reg2$fit)
summary(reg2)
segments(t,reg2$fit,t,X)


##აკაიკის და შვარცის კრიტერიუმებით პოლინომის რიგის არჩევა

AIC(lm(X~poly(t,1)))  #932.1547
AIC(lm(X~poly(t,2)))  #907.4457
AIC(lm(X~poly(t,3)))  #901.1206
AIC(lm(X~poly(t,4)))  #889.3161
AIC(lm(X~poly(t,5)))  #880.4062
AIC(lm(X~poly(t,6)))  #876.5401 ოპტიმალური ლაგების რაოდენობა
AIC(lm(X~poly(t,7)))  #876.9667


BIC(lm(X~1))          #995.8413
BIC(lm(X~poly(t,2)))  #918.5956
BIC(lm(X~poly(t,3)))  #915.058
BIC(lm(X~poly(t,4)))  #906.041
BIC(lm(X~poly(t,5)))  #899.9187
BIC(lm(X~poly(t,6)))  #898.84   ოპტიმალური ლაგების რაოდენობა
BIC(lm(X~poly(t,7)))  #902.0541



