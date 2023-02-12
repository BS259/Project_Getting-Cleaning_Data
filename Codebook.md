# CODE
#The link for downloading the data is "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Variables/Objects Explained
fileurl: Contains the web link for downloading the data. This provides the data in zip format. 
"./Data_cleaning/Project": This is the address for storing the downloaded contents. The repository is 'Data Cleaning' with the folder named 'Project'.
contents: A list of all the files that are in the Project folder after they are unzipped using the unzip function.
test: An empty list that ultimately stores data from files created as testing data.
train: An empty list that ultimately stores data from files created as training data.
features: This stores the name of all the features (total 561) on which observations are made.
Testing: Data related to subjects in testing on each feature along with their id and the activity performed.
Training: Data related to subjects in training on each feature along with their id and the activity performed.
activity_labels: This is used to replace the activity labels (1, 2, 3, 4, 5, 6) with their activity names.
Fit: The combined dataset that contains information on all subjects of their performance in each activity.
Fit2: This is the final dataset that groups the subjects and the activity performed and computes the average feature value for each group.

# Packages Required
1. Base R
2. Dplyr
3. Stringr

#Save this link to fileurl.
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download the data to any arbitrary destination. In my case it is "./Data_cleaning/Project".
download.file(fileurl, "./Data_cleaning/Project")

#To see the contents of the downloaded zip file, use
contents <- list(unzip("./Data_cleaning/Project"))

#We have to merge the train and tests datasets. Lets see the common columns in them.
test <- list()
for(i in 5:16){
  cols <- read.csv(contents[[1]][i], header = FALSE, sep = "")
  test[[abs(4-i)]] <- cols
}

#The features are given in the second element of object contents. Let's read it into features
features <- read.csv(contents[[1]][2], header = F, sep = "")
#These features represents the column names in the 561 feature file, which is the eleventh element in list test.
colnames(test[[11]]) <- features$V2

#The last element in the list  test gives the test labels, i.e. the activity that was performed by the subject
colnames(test[[12]]) <- "Activity_Labels"
#Similarly the tenth element of list test() gives the subject id.
colnames(test[[10]]) <- "Subject_id"

#Finally, we can name the elements of the list test() according to the given information.
names(test) <- c(rep("", 9), "Subject_id", "Test_Set", "Activity_Labels")

#In the same way, lets create a list train() that will contain all the information related to training data.
train <- list()
for(i in 17:28){
  colss <- read.csv(contents[[1]][i], sep = "", header = F)
  train[[abs(16-i)]] <- colss
}

#Let's name the necessary element of this list.
names(train) <- c(rep("", 9), "Subject_id", "Train_Set", "Activity_Labels")
colnames(train[[11]]) <- features$V2
colnames(train[[10]]) <- "Subject_id"
colnames(train[[12]]) <- "Activity_Labels"

#Let us create datasets that contain info about the test and train strats together.
Testing <- cbind(test[[10]], test[[11]], test[[12]])
Training <- cbind(train[[10]], train[[11]], train[[12]])

#The testing data provides info on subjects that were divided into the testing group and similarly the training data does that for subjects divided into the trainin group. The combined data can then be given as
Fit <- rbind(Testing, Training)

#Extract only those columns with mean and standard deviation on measurements with the subject id and activity labels.
Fit <- Fit[, grep("mean|std|id|Labels", names(Fit), value = TRUE)]

#Replace the activity labels with their names.
library(stringr) #stringr package will help in replacing the activity labels with their names.

#Create an object with activity names equated with labels.
activity_labels <- c("1" = "Walking", "2" = "Walking_Upstairs", "3" = "Walking_Downstairs", "4" = "Sitting", "5" = "Standing", "6" = "Laying")
#Replace the labels with names.
activity_labels[str_sub(Fit$Activity_Labels, 1)]
Fit$Activity_Labels <- factor(activity_labels[str_sub(Fit$Activity_Labels, 1)], levels = activity_labels)

#Using dplyr package's group_by function to group the Fit data by Subject ids and Activity labels, then summarizing all columns by "summarise_all".
library(dplyr)
Fit2 <- Fit %>% group_by(Subject_id, Activity_Labels) %>% arrange(Subject_id, Activity_Labels) %>% summarise_all(mean)
