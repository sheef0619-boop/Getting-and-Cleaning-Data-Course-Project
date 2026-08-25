# CodeBook — Getting and Cleaning Data Course Project

## 1. Dataset

The source data is the **Human Activity Recognition Using Smartphones Dataset, Version 1.0**.

The original experiment used smartphone accelerometer and gyroscope measurements from 30 subjects performing six activities.

The source dataset contains training and test observations and 561 original feature measurements.

## 2. Variables in the final tidy data

The final file `tidy_data.txt` contains 68 columns:

### Identifier variables

- `subject` — identifier of the person who performed the activity. Values range from 1 to 30.
- `activity` — descriptive name of the activity performed.

The six activity labels are:

- `WALKING`
- `WALKING_UPSTAIRS`
- `WALKING_DOWNSTAIRS`
- `SITTING`
- `STANDING`
- `LAYING`

### Measurement variables

The remaining 66 columns are the measurements whose original feature names contain:

- `mean()`
- `std()`

These represent mean and standard-deviation measurements from the smartphone sensor signals.

The original feature names are retained so that the measurements can be traced back to the source dataset.

Examples include:

- `tBodyAcc-mean()-X`
- `tBodyAcc-mean()-Y`
- `tBodyAcc-mean()-Z`
- `tBodyAcc-std()-X`
- `tBodyAcc-std()-Y`
- `tBodyAcc-std()-Z`
- `tGravityAcc-mean()-X`
- `tGravityAcc-std()-X`
- `tBodyGyro-mean()-X`
- `tBodyGyro-std()-X`

## 3. Transformations

### Step 1 — Merge training and test sets

The following files are read:

- `train/X_train.txt`
- `train/y_train.txt`
- `train/subject_train.txt`
- `test/X_test.txt`
- `test/y_test.txt`
- `test/subject_test.txt`

The training and test observations are combined into one data set.

### Step 2 — Select mean and standard deviation measurements

The feature list from `features.txt` is used to identify measurements containing `-mean(` or `-std(`.

Only these measurements are retained.

### Step 3 — Descriptive activity names

The numeric activity identifiers in `y_train.txt` and `y_test.txt` are replaced using `activity_labels.txt`.

For example:

```text
1 -> WALKING
2 -> WALKING_UPSTAIRS
3 -> WALKING_DOWNSTAIRS
4 -> SITTING
5 -> STANDING
6 -> LAYING
```

### Step 4 — Descriptive variable names

The selected variables receive their original descriptive feature names from `features.txt`.

The first two columns are:

```text
subject
activity
```

### Step 5 — Independent tidy data set

The script calculates the arithmetic mean of every selected measurement for each unique combination of:

```text
subject + activity
```

There are 30 subjects and 6 activities:

```text
30 × 6 = 180 rows
```

There are 66 selected measurements plus 2 identifier columns:

```text
66 + 2 = 68 columns
```

The resulting data is written to:

```text
tidy_data.txt
```

## 4. Missing values

The script does not intentionally introduce missing values. The source data is used as supplied, and the final values are calculated using the arithmetic mean for each subject/activity group.

## 5. Tidy-data structure

The final data follows the principles of tidy data:

- each observation is a row;
- each variable is a column;
- each cell contains one measurement.

## 6. Reproducibility

Run:

```r
source("run_analysis.R")
```

The script will download the original dataset if necessary and create `tidy_data.txt`.

## 7. Source

Human Activity Recognition Using Smartphones Dataset, Version 1.0.

UCI Machine Learning Repository:
https://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones
