#SIMULACIEBI
#normaluri ganawilebis 
x <- rnorm(100, 0, 1)
x
plot(x)
hist(x, prob=TRUE)

curve( dnorm(x, 0,1,log=FALSE), col='blue', add=TRUE) 

#xi kvadrat ganawileba

x <- rchisq(100, 5) 
hist(x, prob=TRUE) 
curve( dchisq(x, df=5), col='green', add=TRUE) 
curve( dchisq(x, df=10), col='red', add=TRUE ) 

#Stiudentis ganawileba
x <- rt(100, 5)
plot(x)
hist(x, prob=TRUE)

curve(dt(x, df=5, log=FALSE), col="red", add=TRUE)
     
   

qt(c(.025, .975), df=5)   # 5 tavisuflebis xarisxit
