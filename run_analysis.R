library(dplyr)
library(reshape2)

## Test whether the dataset exist in the working directory and if not download it. 
if(!file.exists("UCI HAR Dataset")){
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileurl,destfile = "dataset.zip")
    unzip("dataset.zip")
    file.remove("dataset.zip")
}

## Load datasets into objects
testsubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
testx <- read.table("UCI HAR Dataset/test/X_test.txt")
testy <- read.table("UCI HAR Dataset/test/y_test.txt")
trainsubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("UCI HAR Dataset/train/y_train.txt")
label <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

## Creating an index variable to subset only mean and std
index <- grep("mean|std", label[,2])

## For each observation there are corresponding subject id and activity recorded
## in separate files. This can be merged using cbind(). And we can subset out
## the mean and std variables using the index variable
train <- cbind(trainsubj, trainy, trainx[,index])
test <- cbind(testsubj, testy, testx[,index])
rm(trainsubj, testsubj, trainy, testy, trainx, testx) ## Removing these objects 

## Combine both of these datasets using rbind()
joinedData <- rbind(train, test)
rm(train, test)

## Name the columns using names()
names(joinedData) <- c("SubjectID", "Activity", label[index,2])

## Formatting activity labels
activity <- activity %>%
        mutate(V2 = paste(toupper(substring(V2,1,1)),
                          tolower(substring(V2,2)), sep = "")) %>%
        mutate(V2 = gsub("_", " ", V2))

## To sort dataset based on subject id and use descriptive activity labels in 
## the dataset
joinedData <- joinedData %>%
        arrange(SubjectID, Activity) %>%
        mutate(Activity = activity[Activity,2])

## Formatting the  variable names
names(joinedData) <- gsub("mean", "Mean", names(joinedData))
names(joinedData) <- gsub("std", "Std", names(joinedData))
names(joinedData) <- gsub("-", " ", names(joinedData))
names(joinedData) <- gsub("\\()", "", names(joinedData))

## Melt the dataset by using subject id and activity as factors
joinedData$SubjectID <- factor(joinedData$SubjectID)
joinedData$Activity <- factor(joinedData$Activity)
meltedData <- melt(joinedData, id = c("SubjectID", "Activity"), na.rm = TRUE)

## Cast the melted data into a data frame by finding the mean for each group.
tidyData <- dcast(meltedData, SubjectID + Activity ~ variable, mean)

## Writing out the tidy dataset into a .txt file
write.table(tidyData, file = "tidydata.txt", row.names = FALSE)

## Removes all other datasets 
rm(meltedData, activity, index, label)

