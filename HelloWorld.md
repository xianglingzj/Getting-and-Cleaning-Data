# This is for the programming assignemnt of the "Getting and Cleaning Data" Course

This file contains a few function which are Listed below:
  
  
1. readDataset() is a function which reads the data set (both training and testing) from the directory and return both of them as a list
2. mergeDataset() directly merges the training and testing data set into one data frame.
3. extract() extracts only the factor indicated with the "factor" parameter from the given data frame.
4. readActivity() reads the activity from the activity label file.
5. changeActivityToWords() changes the activity from the code to the actual words
6. tidyDataSet() first split he given dataset by activity and subject, then for each of it calculate the average, and gel them together as a returned data frame after that.
7. run_analysis() is the main function which calls functions 1~6 to achieve the required action in the assignment.
