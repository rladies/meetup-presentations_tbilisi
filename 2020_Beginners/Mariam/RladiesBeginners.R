#samushao sivrcis gageba
getwd()

#axali samushao sivrcis dayeneba
setwd("/Users/MariamAsatiani/Desktop/rladies")

#komentarebis dasacerad viyenebt # simbolos
#komentarebi gvexmareba rom kodi martivad casakitxi iyos

#daxmarebis punqciebi help(), ?
help(getwd)
?setwd

#martivi operaciebi
2+4
(4+6)*10
20^3


#amovxsnat kvadratuli gantoleba x^2+x-1=0 (a*x^2+b*x+c=0, sadac a=1, b=1, c=-1)
(-1+sqrt(1^2-4*(-1)))/2
(-1-sqrt(1^2-4*(-1)))/2

#amovxsnat kvadratuli gantaloba 2x^2+3x-1=0 (a*x^2+b*x+c=0, sadac a=2, b=3, c=-1)
(-3+sqrt(3^2-4*2*(-1)))/(2*2)
(-3-sqrt(3^2-4*2*(-1)))/(2*2)

# obieqtebis sheqmna xdeba <- an = simbolos gamoyenebit. 
a <- 1
b <- 1
c <- -1

#imistvis rom vnaxot obieqtebis shemcveloba shegvidzlia gamoviyenot print() punqcia; 
#an pirdapir davcerot obieqtis saxeli
print(a)
b

#sheqmnili obieqtebis saxelebis naxva shesadzlebelia ls() punqciit
ls()

#tu obieqti sheqmnili ar aris, R errors amoagdebs
x

#arsebobs ukve arsebuli obieqtebic
pi

#kvadratuli gantolebis ax^2+bx+c=0 zogadi amonaxsni
(-b+sqrt(b^2-4*a*c))/(2*a)
(-b-sqrt(b^2-4*a*c))/(2*a)

amonaxsni1 <- (-b+sqrt(b^2-4*a*c))/(2*a)
amonaxsni2 <- (-b-sqrt(b^2-4*a*c))/(2*a)

amonaxsni1
amonaxsni2

#punqciebis magalitebi
sum(2,4)
sqrt(144)
abs(-5)
log(8) #default pudze aris e

r <- 8
log(r) 

log(sum(3,5)) #punqcia punqciashi

args(log) #ra argumenets igebs log punqcia
log(8, base = 2)

#obieqtta klasebis gasagebad shegvidzlia gamoviyenot class() punqcia
a <- 2
class(a)

b <- "rladies"
class(b)

class(sum)

#veqtoris sheqmna
V1 <- c(1,2,3,4,5)
V2 <- c("a", "b", "c")

#matricis sheqmna
M1 <- matrix(c(1,2,2,5,6,4), nrow = 2, ncol = 3)

#axali paketis gadmocera
install.packages("dslabs")
library(dslabs)

#gavxsnat monacemebi "murders"
data(murders)
class(murders)

str(murders) #gvachvenebs monacemta charchos struqturas
head(murders) #gvachvenebs monacemebis pirvel 6 xazs
names(murders) #machvenebs murders monacemta charchos velebis saxelebs
murders$population #amomigdebs mxolod populaciis svets

