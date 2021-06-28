# R-Ladies Tbilisi meetup December 21, 2017 #
# Prepared by Nino Melitauri #
# Based on materials from the Datacamp #


# Comparison of logicals
TRUE == FALSE
# Comparison of numerics
3 == (2+1)
-6 * 14 != 17 - 101
# Comparison of character strings
"Rchitect" != "rchitect"
"useR" == "user"
# Compare a logical with a numeric
"intermediate" != "r"
TRUE == 1

# Comparison of numerics
-6 * 5 + 2 >= -10 + 1

# Comparison of character strings
"raining" <= "raining dogs"
"N" > "M"
# Comparison of logicals
TRUE > FALSE

#creating two vectors
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)

# Popular days
linkedin > 15

# Quiet days
linkedin <= 5

# LinkedIn more popular than Facebook
linkedin > facebook

#logical operators
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
last <- tail(linkedin, 1)
last
# Is last under 5 or above 10?
last < 5 | last > 10
# Is last between 15 and 20?
last > 15 & last <= 20
# linkedin exceeds 10 but facebook below 10
linkedin > 10 & facebook < 10

# When were one or both visited at least 12 times?
linkedin >= 12 | facebook >= 12
#reverse the result
!5>3


#conditional statements
medium <- "LinkedIn"
num_views <- 14

# Examine the if statement for medium
if (medium != "LinkedIn") {
  print("Showing LinkedIn information")
}

# Write the if statement for num_views
if (num_views > 12) {
  print("You're popular!")
  }
#add else
if (medium != "LinkedIn") {
  print("Showing LinkedIn information")
} else {
  print("Unknown medium")
}

medium <- "Face"
if (medium == "LinkedIn") {
  print("Showing LinkedIn information")
} else if (medium == "Facebook") {
  # Add code to print correct string when condition is TRUE
  print("Showing Facebook information")
} else {
  print("Unknown medium")
}

##while loop 
# Initialize the speed variable
speed <- 64

# Code the while loop
while (speed > 30) {
  print("Slow down!")
  speed <- speed - 7
}

# Print out the speed variable
speed

# Extend/adapt the while loop
speed <- 64

while (speed > 30) {
  print(paste("Your speed is", speed))
  if (speed > 48) {
    print("Slow down big time!")
    speed <- speed - 11
  } else {
    print("Slow down!")
    speed <- speed - 6
}
}
speed

## data bases
mtcars
head(mtcars)
tail(mtcars)
str(mtcars)


# Definition of vectors
name <- c("Mercury", "Venus", "Ea'r'th", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)

# Create a data frame from the vectors
planets_df <-data.frame(name, type, diameter, rotation, rings)
str(planets_df)


# Print out diameter of Mercury (row 1, column 3)
planets_df[1, 3]

# Print out data for Mars (entire fourth row)
planets_df[4,]

#when we have a lot of columns
planets_df[1:3,1] #find column number may be hard
planets_df[1:3, "name"] #easier to use var name
#select entire column
planets_df[,3]
planets_df[,"diameter"]

planets_df$rings


rings_vector <-planets_df$rings


subset(planets_df, subset = diameter < 1)

order(planets_df$diameter)

positions <- order(planets_df$diameter)
planets_df[positions, ]

#list

# Vector with numerics from 1 up to 10
my_vector <- 1:10 

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, byrow=TRUE, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]

# Construct list with these different elements:
my_list <- list(my_vector, my_matrix, my_df)

my_list


