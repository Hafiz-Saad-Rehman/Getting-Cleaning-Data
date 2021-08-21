##  attempt to getting and cleaning data task'
X_train <- read.table("E:/R programming/getting and cleaning data SWIRL/UCI HAR Dataset/train/X_train.txt", 
                      row.names=NULL, quote="\"", comment.char="")
X_test <- read.table("E:/R programming/getting and cleaning data SWIRL/UCI HAR Dataset/test/X_test.txt", 
                     row.names=NULL, quote="\"", comment.char="")

X_merged <- rbind(X_train, X_test)
View(X_merged)
## now i am adding the features to assign them column headers
features <- read.table("E:/R programming/getting and cleaning data SWIRL/UCI HAR Dataset/features.txt",
                       row.names=NULL, quote="\"", comment.char="")
## converting features into columns
faetures_column <- as.data.frame(t(features))
View(faetures_column)                      

# names(X_merged) <- NULL
# X_merged
# View(X_merged)
# names(X_merged) <- features2 
# View(X_merged)
## this failed

X_merged_header <- rbind(features$V2, X_merged)
View(X_merged_header)

## my function for extracting out the names and making them header columns
header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
}
## I only wrote this to test the function i created above
## df1 <- data.frame(c("a", 1,2,3), c("b", 4,5,6))
## header.true(df1)
X_with_Header <- header.true(X_merged_header)
## here i am extracting only the mean columns and then assigning
## the frame to a new variable

X_with_Header_mean <- X_with_Header[, c(1:3, 41:43, 81:83, 121:123, 161:163,
                        201,214,227,240,253,266:268, 294:296,
                        345:347, 373:375, 424:426, 452:454, 503,
                        513,516,526,529,539,542,552, 555:561)]

View(X_with_Header_mean)
X_with_Header_std <- X_with_Header[,c(4:6,44:46, 84:86, 124:126, 164:166, 202,
                      215, 228, 241, 254, 269:271, 348:350,
                      427:429, 504, 517, 530, 543)]
X_Header_mean_std <- cbind(X_with_Header_mean, X_with_Header_std)
View(X_Header_mean_std)

## Now saving this table in my computer ahead
install.packages("openxlsx")
library("openxlsx")
write.xlsx(X_Header_mean_std, file = "UCI Mean and Std data.xlsx")
write.table(X_Header_mean_std, file = "UCI Mean & Std Data", sep = ",", row.name = F)

## library(dplyr)
## try_2_std %>% mutate_all(vars(1:33), funs(round(, 2)))

