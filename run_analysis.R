library(dplyr)
library(tidyr)

Data <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(Data)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, Data, method = "auto")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(Data) 
}


activity <- read.table("UCI HAR Dataset/activity_labels.txt")
activity[,2] <- as.character(activity[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Removing all data thats not STD and MEAN and also increasing legibility
featuresMSD <- grep(".*mean.*|.*std.*", features[,2])
featuresfix <- features[featuresMSD, 2]
featuresfix <- gsub('-mean', 'Mean', featuresfix)
featuresfix <- gsub('-std', 'Std', featuresfix)
featuresfix <- gsub('[-()]', '', featuresfix)

# Load the datasets using dplyr
train <- read.table("UCI HAR Dataset/train/X_train.txt") %>%
  select(featuresMSD) %>%
  setNames(featuresfix)
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt") %>%
  rename(activity = V1)
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") %>%
  rename(subject = V1)
train <- bind_cols(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt") %>%
  select(featuresMSD) %>%
  setNames(featuresfix)
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt") %>%
  rename(activity = V1)
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") %>%
  rename(subject = V1)
test <- bind_cols(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- bind_rows(train, test)

# Convert activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activity[,1], labels = activity[,2])
allData$subject <- as.factor(allData$subject)

# Reshape data using dplyr and tidyr
allData.mean <- allData %>%
  pivot_longer(-c(subject, activity), names_to = "variable") %>%
  group_by(subject, activity, variable) %>%
  summarize(mean_value = mean(value), .groups = "drop") %>%
  pivot_wider(names_from = variable, values_from = mean_value)

directory <- "/Users/benjaminnazif/Desktop/Project R" #Where finished file will end up going
filename <- "tidy_data.txt"
path <- paste0(directory, filename)

write.table(allData.mean, path, row.names = FALSE, quote = FALSE)


