library(dplyr)
library(reshape2)

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy 
#    data set with the average of each variable for each activity and 
#    each subject.


########################################################
# Read in labels
########################################################
# Read in feature labels and convert to vector
feature_labels <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactors = FALSE)[,2]
# Read in activity labels
activity_labels <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING") 


########################################################
# Test Data Set Merge
########################################################
# read in test files and then combine
test_subject <- read.delim("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="\n", col.names = "subject_id")
test_activity <- read.delim("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="\n", col.names = "activity")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = feature_labels)
# Use cbind to collapse equal row dataframes to one
test_merged <- cbind(test_subject, test_activity, test_x)
test_merged$activity <- factor(test_merged$activity, labels = activity_labels)
# add column to identify the dataset this comes from and move to first column
test_merged <- mutate(test_merged, dataset = 'test')
test_merged <- select(test_merged, dataset, subject_id:angle.Z.gravityMean.)


########################################################
# Training Data Set Merge
########################################################
# read in train files and then combine
train_subject <- read.delim("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="\n", col.names = "subject_id")
train_activity <- read.delim("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="\n", col.names = "activity")
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = feature_labels)
# Use cbind to collapse equal row dataframes to one
train_merged <- cbind(train_subject, train_activity, train_x)
train_merged$activity <- factor(train_merged$activity, labels = activity_labels)
# add column to identify the dataset this comes from and move to first column
train_merged <- mutate(train_merged, dataset = 'train')
train_merged <- select(train_merged, dataset, subject_id:angle.Z.gravityMean.)


########################################################
# Merge All Data Sets
########################################################
all_merged <- rbind(test_merged, train_merged)


########################################################
# Extract only mean or std columns
########################################################
all_meanOrStd <- all_merged[ ,grepl("[Mm]ean|[Ss]td", names(all_merged))]
# Add the dataset, subject_id, and test_label
all_meanOrStd <- cbind(all_merged[, 1:3], all_meanOrStd)


########################################################
# Get mean of each variable by subject and activity
########################################################
averages_data <- ddply(all_meanOrStd, .(subject_id, activity), numcolwise(mean))
write.table(averages_data, "averages_data.txt", row.name=FALSE)