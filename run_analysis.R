# Getting and Cleaning Data Course Project
# Samsung Galaxy S Smartphone Dataset

# 1. Read the activity labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              header = FALSE)

features <- read.table("UCI HAR Dataset/features.txt",
                       header = FALSE)

# 2. Read the training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# 3. Read the test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# 4. Assign descriptive names to the variables
colnames(x_train) <- features[, 2]
colnames(x_test) <- features[, 2]

colnames(y_train) <- "Activity"
colnames(y_test) <- "Activity"

colnames(subject_train) <- "Subject"
colnames(subject_test) <- "Subject"

# 5. Merge the training and test datasets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# 6. Create one complete dataset
data <- cbind(subject_data, y_data, x_data)

# 7. Extract only measurements on the mean and standard deviation
mean_std_columns <- grep("mean\\(\\)|std\\(\\)", colnames(data))

data <- data[, c(1, 2, mean_std_columns)]

# 8. Use descriptive activity names
data$Activity <- activity_labels[data$Activity, 2]

# 9. Create descriptive activity names
data$Activity <- factor(data$Activity)

# 10. Create a tidy dataset with the average of each variable
# for each activity and each subject
tidy_data <- aggregate(. ~ Subject + Activity,
                        data = data,
                        FUN = mean)

# 11. Write the tidy dataset to a text file
write.table(tidy_data,
            "tidy_data.txt",
            row.name = FALSE)
