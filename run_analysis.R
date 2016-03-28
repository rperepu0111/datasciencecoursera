## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


    install.packages("data.table")
    library(data.table)
    install.packages("reshape2")

    library(reshape2)


    ## STEP 0: load required packages
    

    ## STEP 1: Merges the training and the test sets to create one data set
    
    setwd("/Users/Leels/datasciencecoursera/UCI HAR Dataset/test")
    subject_test <- read.table("subject_test.txt")
    X_test <- read.table("X_test.txt")
    y_test <- read.table("y_test.txt")
    setwd("/Users/Leels/datasciencecoursera/UCI HAR Dataset/train")
    subject_train <- read.table("subject_train.txt")
    X_train <- read.table("X_train.txt")
    y_train <- read.table("y_train.txt")

    
    # add column name for subject files
    names(subject_train) <- "subjectID"
    names(subject_test) <- "subjectID"
    setwd("/Users/Leels/datasciencecoursera/UCI HAR Dataset")
    # add column names for measurement files
    featureNames <- read.table("features.txt")
    names(X_train) <- featureNames$V2
    names(X_test) <- featureNames$V2
    
    # add column name for label files
    names(y_train) <- "activity"
    names(y_test) <- "activity"
    
    # combine files into one dataset
    train <- cbind(subject_train, y_train, X_train)
    test <- cbind(subject_test, y_test, X_test)
    combined <- rbind(train, test)
    
    
    ## STEP 2: Extracts only the measurements on the mean and standard
    ## deviation for each measurement.
    
    # determine which columns contain "mean()" or "std()"
    meanstdcols <- grepl("mean\\(\\)", names(combined)) |
        grepl("std\\(\\)", names(combined))
    
    # ensure that we also keep the subjectID and activity columns
    meanstdcols[1:2] <- TRUE
    
    # remove unnecessary columns
    combined <- combined[, meanstdcols]
    
    
    ## STEP 3: Uses descriptive activity names to name the activities
    ## in the data set.
    ## STEP 4: Appropriately labels the data set with descriptive
    ## activity names. 
    
    # convert the activity column from integer to factor
    combined$activity <- factor(combined$activity, labels=c("Walking",
                                                            "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
    
    
    ## STEP 5: Creates a second, independent tidy data set with the
    ## average of each variable for each activity and each subject.
    
    # create the tidy data set
    melted <- melt(combined, id=c("subjectID","activity"))
    tidy <- dcast(melted, subjectID+activity ~ variable, mean)
    
    # write the tidy data set to a file
    write.csv(tidy, "tidy.csv", row.names=FALSE)
    