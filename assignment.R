#You should create one R script called run_analysis.R that does the following. 

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 
library(stringr)

# readDataset
# 
# Description
#   Read the test and training data sets according to the given root path of
# the files.  
#
# Usage
#
# readDataset(rootPath="./UCI HAR Dataset")
#
# Arguments
#
# rootPath	An input string which indicates the root path
#
# Details
#
#   readDataset function reads the test and training data sets from the
# relative path of the given root path.  It also reads the feature and
# subject list, append to the data set, and name the columns accordingly.
#
# Values
#   readDataset returns a list of two elements, the first is the data frame
# of the test data, and the second the training data.
#

readDataset <- function(rootPath="./UCI HAR Dataset/") {
  testPath <- paste(rootPath,"test",sep="")
  trainPath <- paste(rootPath,"train",sep="")
  featureFileName <- file.path(rootPath, "features.txt")
  xTestFileName <- file.path(testPath, "X_test.txt")
  yTestFileName <- file.path(testPath, "y_test.txt")
  testSubjectName <- file.path(testPath, "subject_test.txt")
  xTrainFileName <- file.path(trainPath, "X_train.txt")
  yTrainFileName <- file.path(trainPath, "y_train.txt")
  trainSubjectName <- file.path(trainPath, "subject_train.txt")
  featureLables <- read.table(featureFileName, col.names=c("Seq","Feature"))
  features <- t(as.vector(featureLables["Feature"]))
  xTestData <- read.table(xTestFileName,col.names=features)
  yTestData <- read.table(yTestFileName,col.names="Activity")
  testSubjectData <-read.table(testSubjectName, col.names="Subject")
  TestData <- cbind(xTestData,testSubjectData, yTestData)

  xTrainData <- read.table(xTrainFileName, col.names=features)
  yTrainData <- read.table(yTrainFileName, col.names="Activity")
  trainSubjectData <-read.table(trainSubjectName, col.names="Subject")
  TrainData <-cbind(xTrainData, trainSubjectData, yTrainData)
  list(TestData, TrainData)
}

mergeDataSet <- function(dataList) {
  testData <- dataList[[1]]
  trainData <- dataList[[1]]
  data <- rbind(testData, trainData)
}

extract <- function(data, factor){
  colName <- names(data)
  filteredCol <- colName[str_detect(colName, factor)]
  data[filteredCol]
}

readActivity <-function(rootPath="./UCI HAR Dataset/"){
  labelFileName <- file.path(rootPath, "activity_labels.txt")
  activityL <- read.table(labelFileName, col.names=c("Seq","Activity"))
}

changeActivityToWords <- function(data, activityLables){
  actCol <- which(names(data) %in% "Activity")
  activityData <- t(data[actCol])
  dataWithoutActivity <- data[-actCol]
  activity <- t(as.vector(activityLabels["Activity"]))
  activityName <- t(activityLabels["Activity"])
  activityWord <- data.frame(activityName[activityData])
  names(activityWord) <- "ActivityName"
  dataWord <- cbind(data, activityWord)
  dataWord
}



tidyDataSet<- function(data) {
  dataList <- split(data, list(data$Subject, data$Activity))
  listCount <- length(dataList)
  tiddyData <- NULL
  for(i in 1:listCount) {
    subList <- as.data.frame(dataList[i])
    maxindex <-ncol(subList)
    subList2 <- subList[1:(maxindex-1)]
    activityName <- as.character(subList[[maxindex]][i])
    avg<-c(colMeans(subList2), activityName)
    tiddyData <- rbind(tiddyData, avg)
  } 
  names(tiddyData) <- names(dataList)
  tiddyData
}

assignment <- function(){
# Prepare the environment variables
  rP <- "./UCI HAR Dataset/"
  meanStr <- "\\.mean\\."
  stdStr <- "\\.std\\."

# 1. Merges the training and the test sets to create one data set.
  dataSetList <- readDataset(rP)
  dataSet <- mergeDataSet(dataSetList)
# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement. 
  mean <- extract(dataSet, meanStr)
  std <- extract(dataSet, stdStr)
  meanstd <- cbind(mean, std)
# 3. Uses descriptive activity names to name the activities in the data set
  actLabel <- readActivity(rP)
# 4. Appropriately labels the data set with descriptive activity names. 
  namedDataSet <- changeActivityToWords(dataSet, actLabel)
# 5. Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 
  td <- tidyDataSet(dataSet)

  outputFile <-  file.path(rP, "assignment.txt")
  write.table(td, outputFile)
}


