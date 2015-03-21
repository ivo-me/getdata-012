## 0. Load data
  # load reqired library
  library(dplyr);

  # set the path of UCI HAR Dataset folder
  path <- "C:/Users/Ivo/coursera-repo/getting-data/datasets/UCI HAR Dataset/";

  # read data files
  subject_names <- c("subject")
  subject_test  <- read.csv(paste0(path, "test/subject_test.txt"), header = FALSE, col.names = subject_names);     
  subject_train <- read.csv(paste0(path, "train/subject_train.txt"), header = FALSE, col.names = subject_names);
  x_names       <- read.csv(paste0(path, "features.txt"), header = FALSE, sep = "");
  x_test        <- read.csv(paste0(path, "test/X_test.txt"), header = FALSE, col.names = as.character(x_names$V2), sep = "");
  x_train       <- read.csv(paste0(path, "train/X_train.txt"), header = FALSE, col.names = as.character(x_names$V2), sep = "");
  y_names       <- read.csv(paste0(path, "activity_labels.txt"), header = FALSE, sep = "");
  y_test        <- read.csv(paste0(path, "test/y_test.txt"), header = FALSE, col.names = "activity", sep = "");
  y_train       <- read.csv(paste0(path, "train/y_train.txt"), header = FALSE, col.names = "activity", sep = "");
  
## 1. Merges the training and the test sets to create one data set.
  # merge test and train columns
  subject <- bind_rows(subject_test, subject_train);
  x <- bind_rows(x_test, x_train);
  y <- bind_rows(y_test, y_train);

  # merge columns into data frame
  har.df <- bind_cols(subject, y, x);

  # convert df to tbl
  har.tbl.temp <- tbl_df(har.df);

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  har.tbl <- select(har.tbl.temp, subject, activity, contains("mean"), contains("std"));

## 3. Uses descriptive activity names to name the activities in the data set
  har.tbl$activity <- factor(har.tbl$activity, levels = y_names$V1, labels = y_names$V2);
  
## 4. Appropriately labels the data set with descriptive variable names. 
  # handled by read.csv()
  
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  group_by <- har.tbl %>% group_by(activity, subject);
  tidy.tbl <- group_by %>% summarise_each(funs(mean));
  
  # save tidy data
  write.csv(tidy.tbl, file = "tidy.csv");
  write.table(tidy.tbl, file = "tidy.txt", row.name = FALSE);
  
  # remove all objects but the tidy set
  rm(list = setdiff(ls(), "tidy.tbl"))