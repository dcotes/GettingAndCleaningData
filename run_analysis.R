library(plyr)
## Step 1 - Download and Merge Data Sets

#Download
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "~/Desktop/smartphone.zip")
unzip("smartphone.zip")

#Combine Datasets
train <- read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt")
test <- read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt")
merged <- rbind(train, test)

#Acquire Activity and use Activity Labels
activities <- read.table("~/Desktop/UCI HAR Dataset/activity_labels.txt")
train_lab <- read.table("~/Desktop/UCI HAR Dataset/train/y_train.txt")
test_lab <- read.table("~/Desktop/UCI HAR Dataset/test/y_test.txt")
merged_labels <- rbind(train_lab, test_lab)
merged_labels <- activities$V2[merged_labels[,1]]

#Combine Subjects
train_sub <- read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt")
test_sub <- read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt")
merged_subjects <- rbind(train_sub, test_sub)

#Combine Subjects and Activities
merged_info <- cbind(merged_subjects, merged_labels)
colnames(merged_info) <- c("Subject", "Activity")

#Subset Desired Features and Remove Non-Letters from Names of Activities
features <- as.character(read.table("~/Desktop/UCI HAR Dataset/features.txt")[,2])
features <- gsub('[-()]', '', features)
feature_subset <- grep(".mean.|.std.", features)
merged_sub <- merged[,feature_subset]
names(merged_sub) <- features[feature_subset]

#Creates One Tidy DF with Proper Names of Features Measuring Mean or SD
tidy_data <- cbind(merged_info, merged_sub)

someColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
tidy_summary <- ddply(tidy_data, .(Subject, Activity), someColMeans)

#Create tidy.txt
write.table(tidy_summary, "tidy.txt", row.name=FALSE)














