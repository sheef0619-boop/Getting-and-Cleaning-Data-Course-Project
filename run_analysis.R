# Getting and Cleaning Data Course Project
# run_analysis.R
#
# This script:
# 1. Merges the training and test sets.
# 2. Extracts measurements on the mean and standard deviation.
# 3. Uses descriptive activity names.
# 4. Applies descriptive variable names.
# 5. Creates an independent tidy data set with averages by subject and activity.
#
# Expected directory structure:
#   .
#   ├── run_analysis.R
#   └── UCI HAR Dataset/
#
# The script downloads and extracts the dataset automatically if it is not present.

data_url <- "https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!dir.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    download.file(data_url, zip_file, mode = "wb")
  }
  unzip(zip_file)
}

# Check that the expected files exist.
required_files <- c(
  file.path(data_dir, "activity_labels.txt"),
  file.path(data_dir, "features.txt"),
  file.path(data_dir, "train", "X_train.txt"),
  file.path(data_dir, "train", "y_train.txt"),
  file.path(data_dir, "train", "subject_train.txt"),
  file.path(data_dir, "test", "X_test.txt"),
  file.path(data_dir, "test", "y_test.txt"),
  file.path(data_dir, "test", "subject_test.txt")
)

missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop(
    paste(
      "The following required files are missing:",
      paste(missing_files, collapse = "\n")
    )
  )
}

# Read activity labels and feature names.
activity_labels <- read.table(
  file.path(data_dir, "activity_labels.txt"),
  col.names = c("activity_id", "activity")
)

features <- read.table(
  file.path(data_dir, "features.txt"),
  col.names = c("feature_id", "feature")
)

# Select only measurements containing mean() or std().
# This follows the project requirement to extract mean and standard deviation
# measurements, while avoiding unrelated variables such as angle(...mean...).
selected <- grepl("-(mean|std)\\(", features$feature)
selected_features <- features$feature[selected]

# Read training data.
X_train <- read.table(file.path(data_dir, "train", "X_train.txt"))
y_train <- read.table(file.path(data_dir, "train", "y_train.txt"),
                      col.names = "activity_id")
subject_train <- read.table(file.path(data_dir, "train", "subject_train.txt"),
                            col.names = "subject")

# Read test data.
X_test <- read.table(file.path(data_dir, "test", "X_test.txt"))
y_test <- read.table(file.path(data_dir, "test", "y_test.txt"),
                     col.names = "activity_id")
subject_test <- read.table(file.path(data_dir, "test", "subject_test.txt"),
                           col.names = "subject")

# Apply feature names, then select the requested measurements.
names(X_train) <- features$feature
names(X_test) <- features$feature

X_train <- X_train[, selected, drop = FALSE]
X_test <- X_test[, selected, drop = FALSE]

# Add subject and activity identifiers.
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)

# Merge training and test sets.
all_data <- rbind(train, test)

# Replace activity IDs with descriptive activity names.
all_data$activity <- activity_labels$activity[
  match(all_data$activity_id, activity_labels$activity_id)
]

# Put identifier columns first and use descriptive names.
all_data <- all_data[, c("subject", "activity", selected_features)]

# Create the second tidy data set: average of each measurement
# for every subject and activity.
tidy_data <- aggregate(
  all_data[, selected_features],
  by = list(subject = all_data$subject, activity = all_data$activity),
  FUN = mean
)

# Sort for readability.
tidy_data <- tidy_data[order(tidy_data$subject, tidy_data$activity), ]

# Write the final tidy data set.
write.table(
  tidy_data,
  file = "tidy_data.txt",
  row.names = FALSE,
  quote = FALSE,
  sep = "\t"
)

message("Analysis complete.")
message("Created: tidy_data.txt")
message(
  paste(
    "Final tidy data dimensions:",
    nrow(tidy_data), "rows x", ncol(tidy_data), "columns."
  )
)
