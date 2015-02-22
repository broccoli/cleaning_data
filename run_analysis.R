
# load all activity data, subject, and activity
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subtrain <- read.table("./train/subject_train.txt")
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subtest <- read.table("./test/subject_test.txt")
}

# load data column labels and activity labels
features <- read.table("./features.txt")
activities <- read.table("./activity_labels.txt")

# merge data for test and training sets
xdata <- rbind(xtest, xtrain)

# attach columns names from list in features
colnames <- features[, 2]
names(xdata) <- colnames

# get list of columns names with "mean()" and "std()"
colnames <- grep("mean\\(\\)|std\\(\\)", colnames, perl=TRUE, value=TRUE)

# subset xdata to include cols with mean() and std()
xdata <- xdata[, colnames]

# merge activity values for test and training sets
ydata <- rbind(ytest, ytrain)
yorder <- seq(nrow(ydata))	# add a sequence column to resort after merge
ydata <- cbind(yorder, ydata)
ydata <- merge(ydata, activities)
ydata <- ydata[order(ydata$yorder), ]

# merge activity values to xdata
xdata <- cbind(ydata$V2, xdata)
names(xdata)[1] <- "activity"

# merge subject values for test and training sets
subdata <- rbind(subtest, subtrain)
names(subdata)[1] <- "subject"

# merge subject values to xdata
xdata <- cbind(subdata, xdata)


# Now we are ready to create the tidy data set with
# averages for each variable for activity and subject.
# The data will have one row for each combination of
# activity and subject.  6 activities x 30 subjects = 180 rows

library(dplyr)
gr <- group_by(xdata, subject, activity)
tidy_data <- summarise_each(gr, funs(mean))



