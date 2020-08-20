---
title: "Coursera - Getting and cleaning data - Course project"
output: github_document
---

This project is done as a part of Getting and cleaning data course on coursera. R script `run_analysis.R` in this repo does the following :
 1. Check whether the working directory contains the required dataset needed to run the script. If not, download the dataset and unzip it
 2. Load datasets into R as objects
 3. Combine both test and train datasets and also extract only `mean()` and `std()` variables. Also including `Meanfreq()` variables since they are also means of frequency
 4. Format variable names and activity labels from the dataset
 5. Use descriptive activity labels instead of numbers
 6. Sort the data set according to `SubjectID`
 7. Create another tidy dataset which gives the mean of each variable for every pair of `SubjectID` and `Activity`
 8. Write this dataset into a txt file

The output file of the script `tidydat.txt` is also in the repo. Use read.table() with header = TRUE option to read this into R.
 


