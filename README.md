# Getting-and-Cleaning-Data-Coursera-Project
READ ME

This is a project positing for the course Getting and Cleaning Data provided by Coursera

The R Script, “run_analysis.R”, provided is a data cleaning script to reformat and “clean the data”. It’s functions are as follows:

1.	Downloads the dataset onto your working directory if the file doesn’t already exist on your computer.
2.	Unzip, access and load the activity and features files into R
3.	Load the training and test datasets and remove all data except mean and standard deviation
4.	Load subject and activity data for each dataset and add that data to the train and test dataset columns
5.	Merge Train and Test datasets
6.	Make activity and subject columns factors
7.	Tidy the data so that each subject and activity group have their own mean value
8.	Print and create a tidy.txt file for the cleaned data




