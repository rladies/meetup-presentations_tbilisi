#http://www.blopig.com/blog/2017/04/a-very-basic-introduction-to-random-forests-using-r/


# Set random seed to make results reproducible:
set.seed(17)
# Calculate the size of each of the data sets:
data_set_size <- floor(nrow(iris)/2)
# Generate a random sample of "data_set_size" indexes
indexes <- sample(1:nrow(iris), size = data_set_size)
# Assign the data to the correct sets
training <- iris[indexes,]
validation1 <- iris[-indexes,]
#import the package
library(randomForest)
# Perform training:
rf_classifier = randomForest(Species ~ ., data=training, ntree=100, mtry=2, importance=TRUE)

#-The first parameter specifies our formula: Species ~ . (we want to predict Species using each of the remaining columns of data).
#–ntree defines the number of trees to be generated. It is typical to test a range of values for this parameter (i.e. 100,200,300,400,500) and choose the one that minimises the OOB estimate of error rate.
#–mtry is the number of features used in the construction of each tree. These features are selected at random, which is where the “random” in “random forests” comes from. The default value for this parameter, when performing classification, is sqrt(number of features).
#–importance enables the algorithm to calculate variable importance.



rf_classifier
prediction_for_table <- predict(rf_classifier,validation1[,-5])
table(observed=validation1[,5],predicted=prediction_for_table)
