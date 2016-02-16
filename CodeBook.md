### Introduction

This file describes the data, the variables, and the work that has been performed to clean up the data.

### Data Set Description

The following three section descriptions are taken from the dataset website referenced here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

#### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. They were then filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

### Work/Transformations

#### Download and Unzip the dataset

The Data Set is not included in the repository because it's larger that what Github recommends. Instead, execution of the run_analysis.R script will create 'data' directory, and then download and extract that dataset into that directory.

The `unzip` function is used to extract the zip file in this directory.

```
project_dataset_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# If the 'data' directory doesn't exist, create it so we have a place to put it
if(!file.exists("./data")){
  dir.create("./data")
}

# download the file and place in 'data' directory
download.file(project_dataset_url, destfile = "data/getdata-projectfiles-UCI HAR Dataset.zip", method = "curl")

# Capture the date of the download
dateDownloaded <- date()

# unzip the downloaded dataset file
unzip("./data/getdata-projectfiles-UCI HAR Dataset.zip", exdir = "data/")
```

#### Read in the labels

Labels for the features and the activities are read in from the features.txt and then activity_labels

#### Merge the test and train datasets into a larger dataset
##### Also included proper labeling and descriptions

`read.delim` is used to load the data to R environment for the data, the activities and the subject of both test and training datasets.
Each data frame of the data set is labeled - using the `features.txt` - with the information about the variables used on the feature vector. The `Activity` and `Subject` columns are also named properly before merging them to the test and train dataset.

```
# read in test files and then combine
test_subject <- read.delim("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="\n", col.names = "subject_id")
test_activity <- read.delim("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="\n", col.names = "activity")
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = feature_labels)

# Use cbind to collapse equal row dataframes to one
test_merged <- cbind(test_subject, test_activity, test_x)
test_merged$activity <- factor(test_merged$activity, labels = activity_labels)

# add column to identify the dataset this comes from and move to first column
test_merged <- mutate(test_merged, dataset = 'test')
test_merged <- select(test_merged, dataset, subject_id:angle.Z.gravityMean.)

# read in train files and then combine
train_subject <- read.delim("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="\n", col.names = "subject_id")
train_activity <- read.delim("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="\n", col.names = "activity")
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = feature_labels)

# Use cbind to collapse equal row dataframes to one
train_merged <- cbind(train_subject, train_activity, train_x)
train_merged$activity <- factor(train_merged$activity, labels = activity_labels)

# add column to identify the dataset this comes from and move to first column
train_merged <- mutate(train_merged, dataset = 'train')
train_merged <- select(train_merged, dataset, subject_id:angle.Z.gravityMean.)


all_merged <- rbind(test_merged, train_merged)
```

#### Extract only the measurements on the mean and standard deviation for each measurement

```
all_meanOrStd <- all_merged[ ,grepl("[Mm]ean|[Ss]td", names(all_merged))]

# Add the dataset, subject_id, and test_label
all_meanOrStd <- cbind(all_merged[, 1:3], all_meanOrStd)
```

#### Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Finaly the desired result, a "tidy" data table is created with the average of each measurement per activity/subject combination. The new dataset is saved in `averages_data.csv` file.

```
averages_data <- ddply(all_meanOrStd, .(subject_id, activity), numcolwise(mean))
write.table(averages_data,file="averages_data.csv",sep=",",col.names = NA)
```