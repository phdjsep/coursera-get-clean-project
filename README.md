### Introduction

This repository contains R code that downloads, extracts, and cleans up a data set from the Human Activity Using Smartphones (HAUS) project. Link here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

### Requirements

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Execution and files

**The Data Set is not included in the repository because it's larger than what Github recommends.** Instead, execution of the run_analysis.R script will create 'data' directory, and then download and extract that dataset into teh 'data' directory. The script will continue to process the dataset and create a tidy 'average_data.csv' file as per the requirements.

The `CodeBook.md` describes the variables, the data, and the work that has been performed to clean up the data.

The `run_analysis.R` is the script that has been used for this work. It can be loaded in R/Rstudio and executed without any parameters.

The result of the execution is that an `average_data.csv` file is created. It stores the data (mean and standard deviation of each measurement per activity and subject) for later analysis.