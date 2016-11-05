# download and unzip
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "my_file")
unzip("my_file") 

# get labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# get only mean and sd
featuresKept <- grep(".*mean.*|.*std.*", features[,2])
featuresKeptNames <- features[featuresKept,2]

# capitalize names and remove symbols
featuresKeptNames = gsub('-mean', 'Mean', featuresKeptNames)
featuresKeptNames = gsub('-std', 'Sd', featuresKeptNames)
featuresKeptNames <- gsub('[-()]', '', featuresKeptNames)

# Load training set (with proper names)
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresKept]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Load test set (with proper names)
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresKept]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Merge training and test and name attributes
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresKeptNames)

# Turn subject and activities into factor, set levels
allData$subject <- as.factor(allData$subject)
allData$activity <- as.factor(allData$activity)
levels(allData$activity) <- activityLabels[,2]

# Create "tidy" dataset
library(reshape2)
melted <- melt(allData, id = c("subject", "activity"))
tidy <- dcast(melted, subject + activity ~ variable, mean)

write.table(tidy, "tidy.txt", row.names = FALSE, quote = FALSE)













