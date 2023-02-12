fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileurl, "./Data_cleaning/Project")

contents <- list(unzip("./Data_cleaning/Project"))

test <- list()

for(i in 5:16){
  cols <- read.csv(contents[[1]][i], header = FALSE, sep = "")
  test[[abs(4-i)]] <- cols
}

features <- read.csv(contents[[1]][2], header = F, sep = "")

colnames(test[[11]]) <- features$V2

colnames(test[[12]]) <- "Activity_Labels"

colnames(test[[10]]) <- "Subject_id"

names(test) <- c(rep("", 9), "Subject_id", "Test_Set", "Activity_Labels")

train <- list()

for(i in 17:28){
  colss <- read.csv(contents[[1]][i], sep = "", header = F)
  train[[abs(16-i)]] <- colss
}

names(train) <- c(rep("", 9), "Subject_id", "Train_Set", "Activity_Labels")

colnames(train[[11]]) <- features$V2

colnames(train[[10]]) <- "Subject_id"

colnames(train[[12]]) <- "Activity_Labels"

Testing <- cbind(test[[10]], test[[11]], test[[12]])

Training <- cbind(train[[10]], train[[11]], train[[12]])

Fit <- rbind(Testing, Training)

Fit <- Fit[, grep("mean|std|id|Labels", names(Fit), value = TRUE)]

library(stringr) #stringr package will help in replacing the activity labels with their names.

activity_labels <- c("1" = "Walking", "2" = "Walking_Upstairs", "3" = "Walking_Downstairs", "4" = "Sitting", "5" = "Standing", "6" = "Laying")

activity_labels[str_sub(Fit$Activity_Labels, 1)]

Fit$Activity_Labels <- factor(activity_labels[str_sub(Fit$Activity_Labels, 1)], levels = activity_labels)

library(dplyr)

Fit2 <- Fit %>% group_by(Subject_id, Activity_Labels) %>% arrange(Subject_id, Activity_Labels) %>% summarise_all(mean)
