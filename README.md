
## Getting and Cleaning Data - Project

Source dataset https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The R script 'run_analysis.R' performs the following tasks:
*  Merges the training and the test sets to create one data set.
*  Extracts only the measurements on the mean and standard deviation for each measurement.
*  Uses descriptive activity names to name the activities in the data set
*  Appropriately labels the data set with descriptive activity names.
*  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Notes

*  Only vaiables containing mean() & std() are used.
*  Requires the plyr & reshape2 packages.
*  It does not assume the dataset is unzipped in the current directory and will try to download it if not present

Constructed using the following:

```R
> version
platform       x86_64-apple-darwin13.4.0   
arch           x86_64                      
os             darwin13.4.0                
system         x86_64, darwin13.4.0        
status                                     
major          3                           
minor          2.3                         
year           2015                        
month          12                          
day            10                          
svn rev        69752                       
language       R                           
version.string R version 3.2.3 (2015-12-10)
nickname       Wooden Christmas-Tree  
```

##  Running

```bash
$ Rscript run_analysis.R
```

Yields tidy.txt & tidy.mean.txt.

```

##  Running

```bash
$ Rscript run_analysis.R
```

Yields tidy.txt & tidy.mean.txt.
