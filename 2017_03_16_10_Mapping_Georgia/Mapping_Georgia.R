#################################################################################
#################################################################################
##
## Session 10: Mapping in plot basic
##
#################################################################################
#################################################################################
#shapefiles provide coordinates --> can get them online at gadm.org, diva-gis.org

# clear space
# two ways: remove list or click on the broomstick in the environment window
rm(list=ls(all=TRUE))
#remove info from the console
cat("\014") #or by using ctrl+L

#Tools -> Update packages

# install relevant libraries
# 
install.packages(c("maps","maptools","RColorBrewer","classInt","rgdal","TeachingDemos", "classInt"))

require(maps) #for creating geographical maps
require(maptools) #tools for handling spatial objects
library(RColorBrewer)
require(RColorBrewer) #contains color palettes
require(classInt) #defines the class intervals for the color palettes
require(rgdal) #reads proj files
require(TeachingDemos) #useful examples
#check colorbrewer2.org for colours

# upload shape files
# 
mypath <- "C:/Users/KASUTAJA/Documents/RLadies/Session10"
setwd(paste(mypath))
#two types: shapefiles and projected files, need them both
#shapefiles are all polygon data files
# C:\Users\KASUTAJA\Documents\RLadies
georgia <- readOGR(".","GEO_adm0") #readOGR reads projected files, have to set the wd exactly where the files are; /GEO_adm is the subfolder name
plot(georgia, lwd=1.5)
#use "." if all files in the same folder as already specified in mypath

georgia1 <- readOGR(".","GEO_adm1")
plot(georgia1)

georgia2 <- readOGR(".","GEO_adm2")
plot(georgia2)

gwat <- readOGR("." , "GEO_water_lines_dcw")
plot(gwat)

install.packages("raster")
require(raster)
gpop <- raster("./geo_pop.grd") #/add folder_name if needed
plot(gpop)

galt <- raster("./GEO_msk_alt.grd") #/GEO_msk_alt/GEO_msk_alt.grd
plot(galt)

### neighbouring countries
#
tur <- readOGR("." , "TUR_adm0")
arm <- readOGR("." , "ARM_adm0")
rus <- readOGR("." , "RUS_adm0") #/folder_name after .
aze <- readOGR("." , "AZE_adm0") 
str(tur) #usually shapefiles quite large, have a lot of information
#ID_0 gives the number of the region which you need later, NAME important for having labels
#centroid isa point with a coordinate (spatial polygon)

# plot maps in plotbasic, ggplot more timeconsuming
# 
plot(georgia, lwd=1.5, col="white", bg="lightblue") #lwd is line width of border, bg-background, col - colour of country
plot(georgia1, add=T, lty=2) #lty - line type, add=T use when want to add additional elements to the same map
plot(tur, add=T, col="white")
plot(arm, add=T, col="white")
#plot(rus, add=T, col="white")
plot(aze, add=T, col="white")

#in basic r there are some colours, for getting palettes - nice ones usually comes with packages, e.g. rcolorbrewer
#website colorbrewer2.org helps with visualising
#to add or delete colours, can create my own palette if know the colour code - they are on the website, for example

# add labels for the countries; first tell r where to copy the label names
# z <- locator()
# z$x
# z$y
x.loc <- c(44.32002, 46.35746, 44.40421, 42.18156, 40.71662) 
y.loc <- c(43.42472, 40.87209, 40.82228, 40.90945, 41.99276)
#create vector w names of countries:
nb.lab <- c("Russia", "Azerbaijan", "Armenia", "Turkey", "Black Sea")
#now paste
text(x.loc, y.loc, nb.lab)
#to change the location of country labels, use locator
locator()
#then get new coordinates, copy-paste them:
#x.loc<-c(39.16490, 39.47292, 42.18345)
#y.loc<-c(42.30697, 42.44364, 41.25920)

# let's add everything (or almost everything) together
# 
plot(gwat, col="blue")
#highlight the first region - 1 - Abkhazia in this case, [2:6] -> would give 5 regions starting from the 2nd
plot(georgia1[1,], lwd=1, col="lightblue", border="black", add=T)
#want also adm2 unit borders, want them with a purple segmented line
plot(georgia2, lwd=0.5, border="purple", lty=3, add=T)
#now want to have a border line for the country
plot(georgia1, border="black", lty=2, add=T)
plot(georgia, lwd=1.5, add=T)

plot(tur, col="white")
#if want to have two maps on one plot
#divides plotting space in symmetrical parts, plot by row: 2 rows & 1 column
par(mfrow=c(2,1))
#could have also par(mfrow=c(1,2))
plot(georgia,lwd=1.5)
plot(tur,col="white")


################
head(georgia1)

# print labels on the map
# 
coords<- coordinates(georgia1) 
admin1 <- c(as.character(georgia1$NAME_1))
admin1.new <- c("Abkhazia", "Ajaria", "Guria","Imereti" ,"Kakheti"  ,"Kvemo Kartli","Mtskheta-Mtianeti", "\nRacha-Lechkhumi-Kvemo Svaneti","Samegrelo-Zemo Svaneti","Samtskhe-Javakheti","Shida Kartli","Tbilisi")

#use shadowtext in order to text not to overlap
shadowtext(coords[,1],coords[,2], label=paste(admin1.new), cex=1,col="black", bg="white",r=0.1, face="bold")

# labels for admin 2
#coordinates function gives coordinates of admin units, dep on shapefile
coords2<- coordinates(georgia2[2:6,])
admin2 <- c(as.character(georgia2$NAME_2[1:5]))
admin2
coords
coords2

#plot everything
plot(georgia2, lwd=0.5, border="black", lty=3)
plot(georgia1[1,], lwd=1, col="lightblue", border="black", add=T)
plot(georgia1, border="black", lty=2, add=T)
plot(georgia, lwd=1.5, add=T)
shadowtext(41.555, 43.1, label="Abkhazia", cex=2,col="black", bg="white",r=0.1, font=3)
#cex for changing the size of the label, bg - background of the label, r - thickness of bg, font=3 means bold & italics
#font=1 for normal, 2 - bold, 4, italic

head(georgia1)

# Upload data from World Bank

dt <- read.csv("3f075abc-c51c-40c5-afb1-f8fbcfa30f23_Data.csv", header=T)
dt.1 <- subset(dt, dt$type==1&dt$select==1)
dt.1

library(dplyr)
dt.1 <- dt%>%
  filter(type=="1"&select=="1")
  
names(dt.1)
head(dt.1)
dt.1$YR2000
dt.1$YR2005
dt.1$YR2009

### Prevalence overweight w/h
install.packages("classInt")
library(classInt)
require(classInt) #find color breaks
nclassint <- 3 #number of colors to be used in the palette
cat <- classIntervals(dt.1$YR2005, nclassint,style = "quantile") #style refers to how the breaks are created
#type classIntervals in help search
#jenks style good for spatial , quantile divides everything into quantiles

#choose colour palette, eg greens
colpal <- brewer.pal(nclassint,"Greens") #sequential
color.palette <- findColours(cat,colpal)
is.na(color.palette) 
bins <- cat$brks
lb <- length(bins)

color.palette[c(1, 10)] <- "gray"
value.vec <- c(round(bins[-length(bins)],2))
value.vec.tail <- c(round(bins[-1],2))

# Plot and SAVE map:

pdf("Georgia Obesity 2005.pdf", width = 13, height =8 )
plot(georgia1, col=color.palette, border=T, main="Prevalence of overweight, \nweight for height (% of children under 5)") 
legend("topright",fill=c("gray", "#E5F5E0", "#A1D99B", "#31A354"),legend=c("NA",paste(value.vec,":",value.vec.tail)),cex=1, bg="white", bty = "n")

# map.scale(41, 41, 2, "km", 2, 100)
map.scale(x=40.1, y=41.2, relwidth=0.1 , metric=T, ratio=F, cex=0.8) #metric - metric system
#to get the North arrow:
SpatialPolygonsRescale(layout.north.arrow(2), offset= c(40.1, 41.6), scale = 0.5, plot.grid=F)
dev.off()

#google scale for maps

#or use postscipt to save as eps file -> better for some journals, can download a programme for reading eps


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


#ggmap - visualisation of streets, location of shops, but takes more time than plotbasic
