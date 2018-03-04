# install packages + open library -----------------------------------------
packages = c("downloader","reshape2")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

# create folder if does not exist -----------------------------------------
if (!file.exists("Coursera_GettingAndCleaning_FinalAssignment")) { # check if directory exists
  dir.create("Coursera_GettingAndCleaning_FinalAssignment") # create a directory if it doesn't exist
}

# set working directory ---------------------------------------------------
setwd("Coursera_GettingAndCleaning_FinalAssignment")

# download and unzip the data ---------------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "SamsungGalaxyData.zip"
download(url, dest= destfile, mode="wb") 
unzip (destfile, exdir = ".", overwrite = TRUE)
unlink("SamsungGalaxyData.zip")

# define folder name -------------------------------------------------
folder <- list.files()

# load activity labels and features ---------------------------------------
activity_labels <- read.table(paste(folder, "/activity_labels.txt", sep = ""))
activity_features <- read.table(paste(folder, "/features.txt", sep = ""))

# extract only the measurements on the mean and standard deviation --------
features_of_interest <- grep(".*mean.*|.*std.*", activity_features[,2])
names_features <- grep(".*mean.*|.*std.*", activity_features[,2], value = TRUE)
names_features <- gsub('-mean', 'Mean', names_features)
names_features <- gsub('-std', 'Std', names_features)
names_features <- gsub('[-()]', '', names_features)

# merge the training data sets, and the test data sets --------------------
# read train datasets
subject_train <- read.table(paste(folder, "/train/subject_train.txt", sep = ""))
y_train <- read.table(paste(folder, "/train/y_train.txt", sep = ""))
x_train <- read.table(paste(folder, "/train/x_train.txt", sep = ""))[features_of_interest]
# cbind 
train <- cbind(subject_train, y_train, x_train)

# read test datasets
subject_test <- read.table(paste(folder, "/test/subject_test.txt", sep = ""))
y_test <- read.table(paste(folder, "/test/y_test.txt", sep = ""))
x_test <- read.table(paste(folder, "/test/x_test.txt", sep = ""))[features_of_interest]
# cbind
test <- cbind(subject_test, y_test, x_test)

# rbind train and test data -----------------------------------------------
mydf <- rbind(train, test)

# add descriptive variable names ------------------------------------------
names(mydf) <- c("subject", "activity", names_features)

# turn variables types activity and subject into factor
mydf$activity <- factor(mydf$activity, levels = activity_labels[,1], labels = activity_labels[,2])
mydf$subject <- as.factor(mydf$subject)

# create an independent tidy data set with the average of each variable for each activity and each subject.
mydf_mean <- melt(mydf, id = c("subject", "activity"))
mydf_mean <- dcast(mydf_mean, subject + activity ~ variable, mean)

# write to text file
write.table(mydf_mean, "tidy_dataset.txt", row.names = FALSE)
