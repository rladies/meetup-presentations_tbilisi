#################################################################################
#################################################################################
##
## Session 3: Mapping in plot basic
##
#################################################################################
#################################################################################

# clear space
# 
rm(list=ls(all=TRUE))
cat("\014") 

# install relevant libraries
# 
install.packages(c("maps","maptools","RColorBrewer","classInt","rgdal","TeachingDemos", "classInt"))

require(maps) #for creating geographical maps
require(maptools) #tools for handling spatial objects
require(RColorBrewer) #contains color palettes
require(classInt) #defines the class intervals for the color palettes
require(rgdal) #reads proj files
require(TeachingDemos) #useful examples

# upload shape files
# 
mypath <- "/Users/ac1y15/Google Drive/blog/RLadies_Georgia_files/Session_3"
setwd(paste(mypath))

georgia <- readOGR("./GEO_adm/","GEO_adm0")
plot(georgia, lwd=1.5)

georgia1 <- readOGR("./GEO_adm/","GEO_adm1")
plot(georgia1)

georgia2 <- readOGR("./GEO_adm/","GEO_adm2")
plot(georgia2)

gwat <- readOGR("./GEO_wat" , "GEO_water_lines_dcw")
plot(gwat)

require(raster)
gpop <- raster("./GEO_pop/geo_pop.grd")
plot(gpop)

galt <- raster("./GEO_msk_alt/GEO_msk_alt.grd")
plot(galt)

### neighbouring countries
#
tur <- readOGR("./TUR_adm" , "TUR_adm0")
arm <- readOGR("./ARM_adm" , "ARM_adm0")
rus <- readOGR("./RUS_adm" , "RUS_adm0")
aze <- readOGR("./AZE_adm" , "AZE_adm0")

# plot maps
# 
plot(georgia, lwd=1.5, col="white", bg="lightblue")
plot(georgia1, add=T, lty=2)
plot(tur, add=T, col="white")
plot(arm, add=T, col="white")
plot(rus, add=T, col="white")
plot(aze, add=T, col="white")

# add labels for the countries
# z <- locator()
# z$x
# z$y
# x.loc <- c(44.32002, 46.35746, 44.40421, 42.18156, 40.71662) 
# y.loc <- c(43.42472, 40.87209, 40.82228, 40.90945, 41.99276)
nb.lab <- c("Russia", "Azerbaijan", "Armenia", "Turkey", "Black Sea")

text(x.loc, y.loc, nb.lab)

# let's add everything (or almost everything) together
# 
plot(gwat, col="blue")
plot(georgia1[1,], lwd=1, col="lightblue", border="black", add=T)
plot(georgia2, lwd=0.5, border="black", lty=3, add=T)
plot(georgia1, border="black", lty=2, add=T)
plot(georgia, lwd=1.5, add=T)

################
head(georgia1)

# print labels on the map
# 
coords<- coordinates(georgia1) 
admin1 <- c(as.character(georgia1$NAME_1))
admin1.new <- c("Abkhazia", "Ajaria", "Guria","Imereti" ,"Kakheti"  ,"Kvemo Kartli","Mtskheta-Mtianeti", "\nRacha-Lechkhumi-Kvemo Svaneti","Samegrelo-Zemo Svaneti","Samtskhe-Javakheti","Shida Kartli","Tbilisi")

shadowtext(coords[,1],coords[,2], label=paste(admin1.new), cex=1,col="black", bg="white",r=0.1, face="bold")

# labels for admin 2
coords2<- coordinates(georgia2[2:6,])
admin2 <- c(as.character(georgia2$NAME_2[1:5]))
admin2

plot(georgia2, lwd=0.5, border="black", lty=3)
plot(georgia1[1,], lwd=1, col="lightblue", border="black", add=T)
plot(georgia1, border="black", lty=2, add=T)
plot(georgia, lwd=1.5, add=T)
shadowtext(41.555, 43.1, label="My label", cex=1,col="black", bg="white",r=0.1, font=3)

head(georgia1)

# Upload data from World Bank

dt <- read.csv("./Data_Extract_From_Subnational_Malnutrition/3f075abc-c51c-40c5-afb1-f8fbcfa30f23_Data.csv", header=T)
dt.1 <- subset(dt, dt$type==1&dt$select==1)

library(dplyr)
dt.1 <- dt%>%
  filter(type=="1"&select=="1")
  
names(dt.1)
head(dt.1)
dt.1$YR2000
dt.1$YR2005
dt.1$YR2009

### Prevalence overweight w/h
require(classInt) # find color breaks
nclassint <- 3 #number of colors to be used in the palette
cat <- classIntervals(dt.1$YR2005, nclassint,style = "quantile") #style refers to how the breaks are created
colpal <- brewer.pal(nclassint,"Greens") #sequential
color.palette <- findColours(cat,colpal)
is.na(color.palette) 
bins <- cat$brks
lb <- length(bins)

color.palette[c(1, 10)] <- "gray"
value.vec <- c(round(bins[-length(bins)],2))
value.vec.tail <- c(round(bins[-1],2))

# Plot and SAVE map:

# pdf("Georgia Obesity 2005", width = 13, height =8 )
plot(georgia1, col=color.palette, border=T, main="Prevalence of overweight, \nweight for height (% of children under 5)") 
legend("topright",fill=c("gray", "#E5F5E0", "#A1D99B", "#31A354"),legend=c("NA",paste(value.vec,":",value.vec.tail)),cex=1.1, bg="white", bty = "n")
# map.scale(41, 41, 2, "km", 2, 100)
map.scale(x=40.1, y=41.2, relwidth=0.1 , metric=T, ratio=F, cex=0.8)
SpatialPolygonsRescale(layout.north.arrow(2), offset= c(40.1, 41.6), scale = 0.5, plot.grid=F)
# dev.off()


# SpatialPolygonsRescale(layout.scale.bar(), offset= c(40.1,41.15), scale= 1.2, fill=c("transparent", "black"), plot.grid= F)
# text(41, 41.65, "200km", cex= 0.8, font=2)
# play around with the legend

dt.pov <- read.csv("./Data_Extract_From_Subnational_Poverty/a7efc440-67f5-4259-8418-2fc9356bf5ce_Data.csv", header=T)
dt.pov1 <- dt.pov %>%
  filter(Series.Name=="Poverty headcount ratio at national poverty line (% of population)"&select!=0)%>%
  arrange(select)

nclassint <- 5 #number of colors to be used in the palette
cat <- classIntervals(dt.pov1$YR2011, nclassint,style = "jenks") #style refers to how the breaks are created
colpal <- brewer.pal(nclassint,"RdBu") #sequential
color.palette <- findColours(cat,rev(colpal))
is.na(color.palette) 
bins <- cat$brks
lb <- length(bins)

color.palette[1] <- "gray"
value.vec <- c(round(bins[-length(bins)],2))
value.vec.tail <- c(round(bins[-1],2))

# pdf("Georgia Poverty 2011.pdf", width = 13, height =8 )
plot(georgia1, col=color.palette, border=T, main="Poverty headcount ratio at \nnational poverty line (% of population))") 
legend("topright",fill=c("gray", "#0571B0",  "#92C5DE",  "#F7F7F7", "#F4A582", "#CA0020"),legend=c("NA",paste(value.vec,":",value.vec.tail)),cex=1.1, bg="white", bty = "n")
map.scale(x=39.8, y=41.4, relwidth=0.1 , metric=T, ratio=F, cex=0.8)
map.scale(x=39.8, y=41.4, relwidth=0.1 , metric=T, ratio=F, cex=0.8)
SpatialPolygonsRescale(layout.north.arrow(2), offset= c(40.1, 41.6), scale = 0.5, plot.grid=F)
# dev.off()
