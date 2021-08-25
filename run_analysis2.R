 if(!file.exists("./data")){dir.create("./data")}

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")

Unzip
unzip(zipfile="./data/Dataset.zip",exdir="./data")

library(dplyr)
library(tidy)
library(reshape2)
install.packages("openxlsx")
library("openxlsx")

x_train <- read.table(file= choose.files())
y_train <- read.table(file = choose.files())
sub_train <- read.table("E://R programming/getting and cleaning data SWIRL/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table(choose.files())
y_test <- read.table(choose.files())
sub_test <- read.table(choose.files())
features <- read.table("E:/R programming/getting and cleaning data SWIRL/UCI HAR Dataset/features.txt",
                       row.names=1, quote="\"", comment.char="")
activity_labels = read.table(choose.files())
colnames(activity_labels) <- c('activityId','activityType')

# converting features into rows, to give 561 columns 
# features <- as.data.frame(t(features))
# View(features)

## my function for extracting out the names and making them header columns
header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
}
x_test_header <- rbind(features$V2, x_test)
x_test_header <- header.true(x_test_header)

## Making different factors in the actiities 
activities_as_fact_test <- factor(y_test$V1, levels = c(1,2,3,4,5,6), 
                                  labels = c("WALKING", "WALKING_UPSTAIRS", 
                                             "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

## merging above with the volunteers
volunteers_test <- factor(sub_test$V1, levels = c(1:30)) 

Data_type_test <- rep("TEST", nrow(x_test_header))
x_test_activity <- cbind("volunteers" = volunteers_test,
                         "activities_as_fact"= activities_as_fact_test , "Data_type" = Data_type_test
                         ,x_test_header)

colum_Names <- colnames(x_test_activity)
Mean_Std <- (grepl("volunteers", colum_Names)| grepl("Data_type", colum_Names) |
               grepl("activities_as_fact", colum_Names) | 
               grepl("mean..", colum_Names, ignore.case = TRUE) |
               grepl("std..", colum_Names, ignore.case = TRUE)  )
x_test_Mean_Std <- x_test_activity[, Mean_Std == TRUE]

#2nd subset manipulation
x_train_header <- rbind(features$V2, x_train)
x_train_header <- header.true(x_train_header)

activities_as_fact_train <- factor(y_train$V1, levels = c(1,2,3,4,5,6),
                                   labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS", 
                                              "SITTING","STANDING", "LAYING"))
volunteers_train <- factor(sub_train$V1, levels = c(1:30))
Data_type_train <- rep("TRAIN", nrow(x_train_header))
x_train_activity <- cbind("volunteers" = volunteers_train, 
                          "activities_as_fact"= activities_as_fact_train,
                          "Data_type" = Data_type_train,
                          x_train_header)

## creating a logical vector to find the relative columns
colum_Names2 <- colnames(x_train_activity)
Mean_Std2 <- (grepl("volunteers", colum_Names2)| grepl("Data_type", colum_Names2) |
                grepl("activities_as_fact", colum_Names2) | 
                grepl("mean..", colum_Names2, ignore.case = TRUE) |
                grepl("std..", colum_Names2, ignore.case = TRUE)  )

## extracting merged dataset to only get relative columns
x_subset_train <- x_train_activity[, Mean_Std2 == TRUE]

x_merged <- rbind(x_subset_train, x_test_Mean_Std)
x_merged[,4:86] <- lapply(x_merged[,4:86], as.numeric)


write.xlsx(x_merged, file = "UCI Mean and Std data(final3).xlsx")



