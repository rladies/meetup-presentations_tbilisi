##სლაიდი-სტაციონარულობა
ma.sim<-arima.sim(model=list(ma=c(0)),n=100, rand.gen = rnorm, mean=10)
ts.plot(ma.sim)
mean(ma.sim)
acf(ma.sim, type="correlation")



##წარმოვქმნათ პროცესი AR(2)
ar.sim<-arima.sim(model=list(ar=c(.9,-.2)),n=100) 
ar.sim
##გამოვსახოთ გრაფიკულად
ts.plot(ar.sim) 
##გამოვთვალოთ შერჩევის ავტოკორელაციური ფუნქცია
ar.acf<-acf(ar.sim,type="correlation",plot=T) 
ar.acf 

##მეორე რიგის პოლინომიალური რეგრესია
t=1:100
is.ts(ar.sim)

reg2=lm(formula = ar.sim ~ poly(t,2) +0)
plot.ts(ar.sim)
summary(reg2)


AIC(lm(ar.sim~poly(n,1)))  #361.297 ოპტიმალური
AIC(lm(ar.sim~poly(n,2)))  #362.3111
AIC(lm(ar.sim~poly(n,3)))  #363.9948

BIC(lm(ar.sim~poly(n,1)))  #369.1125 ოპტიმალური
BIC(lm(ar.sim~poly(n,2)))  #372.7317
BIC(lm(ar.sim~poly(n,3)))  #377.0206



## MA პროცესის წარმოქმნა
ma.sim<-arima.sim(model=list(ma=c(-.7,.1)),n=100) 
ma.sim
##გამოვსახოთ გრაფიკულად
ts.plot(ma.sim)
##გამოვთვალოთ შერჩევის ავტოკორელაციური ფუნქცია
ma.acf<-acf(ma.sim,type="correlation",plot=T)  
ma.acf 

n=1:100
reg1=lm(ma.sim~poly(n,1))
plot.ts(ma.sim)

summary(reg1)

AIC(lm(ma.sim~1))          #352.6659 ოპტიმალური
AIC(lm(ma.sim~poly(n,2)))  #356.624
AIC(lm(ma.sim~poly(n,3)))  #358.5033

BIC(lm(ma.sim~poly(n,1)))  #362.4666 ოპტიმალური
BIC(lm(ma.sim~poly(n,2)))  #367.0447
BIC(lm(ma.sim~poly(n,3)))  #371.5291




