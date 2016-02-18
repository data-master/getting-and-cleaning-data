library(plyr)
library(reshape2)
library(httr) 

## Goals
## 1. each variable should be in one column
## 2. each observation of that variable should be in a diferent row
## 3. include ids to link tables together

# Download the data

file <- "UCI HAR Dataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists(file)){
	print("descargando")
	download.file(url, file, method="curl")
}

root.dir <- "UCI\ HAR\ Dataset"
resultsfolder <- "results"
if(!file.exists(root.dir)){
  print("unzip file")
  unzip(file, list = FALSE, overwrite = TRUE)
} 
if(!file.exists(resultsfolder)){
  print("create results folder")
  dir.create(resultsfolder)
} 



## Merges the training and the test sets to create one data set.

data.set <- list()

message("loading features.txt")
data.set$features <- read.table(paste(root.dir, "features.txt", sep="/"), col.names=c('id', 'name'), stringsAsFactors=FALSE)

message("loading activity_features.txt")
data.set$activity_labels <- read.table(paste(root.dir, "activity_labels.txt", sep="/"), col.names=c('id', 'Activity'))


message("loading test set")
data.set$test <- cbind(subject=read.table(paste(root.dir, "test", "subject_test.txt", sep="/"), col.names="Subject"),
                       y=read.table(paste(root.dir, "test", "y_test.txt", sep="/"), col.names="Activity.ID"),
                       x=read.table(paste(root.dir, "test", "x_test.txt", sep="/")))

message("loading train set")
data.set$train <- cbind(subject=read.table(paste(root.dir, "train", "subject_train.txt", sep="/"), col.names="Subject"),
                        y=read.table(paste(root.dir, "train", "y_train.txt", sep="/"), col.names="Activity.ID"),
                        x=read.table(paste(root.dir, "train", "X_train.txt", sep="/")))

rename.features <- function(col) {
    col <- gsub("tBody", "Time.Body", col)
    col <- gsub("tGravity", "Time.Gravity", col)

    col <- gsub("fBody", "FFT.Body", col)
    col <- gsub("fGravity", "FFT.Gravity", col)

    col <- gsub("\\-mean\\(\\)\\-", ".Mean.", col)
    col <- gsub("\\-std\\(\\)\\-", ".Std.", col)

    col <- gsub("\\-mean\\(\\)", ".Mean", col)
    col <- gsub("\\-std\\(\\)", ".Std", col)

    return(col)
}

## Extracts only the measurements on the mean and standard deviation for each measurement.

tidy <- rbind(data.set$test, data.set$train)[,c(1, 2, grep("mean\\(|std\\(", data.set$features$name) + 2)]

## Uses descriptive activity names to name the activities in the data set

names(tidy) <- c("Subject", "Activity.ID", rename.features(data.set$features$name[grep("mean\\(|std\\(", data.set$features$name)]))

## Appropriately labels the data set with descriptive activity names.

tidy <- merge(tidy, data.set$activity_labels, by.x="Activity.ID", by.y="id")
tidy <- tidy[,!(names(tidy) %in% c("Activity.ID"))]

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy.mean <- ddply(melt(tidy, id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, MeanSamples=mean(value))

write.csv(tidy.mean, file = "tidy.mean.txt",row.names = FALSE)
write.csv(tidy, file = "tidy.txt",row.names = FALSE)

