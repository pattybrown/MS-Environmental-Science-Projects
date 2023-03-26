##########################################
### Patrick Brown
### ENVS 511
### Assignment 4
### 06-18-2022
#############################################

require(readr)
require(waterData)

### Task 1 - read water data from spreadsheet into R:

waterdata <- read_csv("~/Desktop/ENVS 511/Week 2/Assignment 4/Assignment 4.csv", skip = 3)

### Task 2 - read  file 1N_dendro_2020 into R:

X1N_dendro_2020 <- read_csv("~/Desktop/ENVS 511/Week 2/Assignment 4/1N_dendro_2020.csv")

### Task 3 - read file temperature_data into R:

## read data into R:
temp_data <- read.table("~/Desktop/ENVS 511/Week 2/Assignment 4/temperature_data.txt", header = TRUE, fill = TRUE)

### Task 4 - exract values from previous dataset:

task4_airtemp <- temp_data[13:15,1]

### Task 5 - Reads in the daily USGS streamflow data collected between January 2015 to December 2019 at the 
### Boise River at Glenwood Bridge site. :

boiseriver_gb <- importDVs("13206000", code = "00060", stat = "00003", sdate = "2015-01-01", edate = "2019-12-01")

### Task 6 - Write the streamflow data to your hard drive.

write.table(boiseriver_gb, "~/Desktop/ENVS 511/Week 2/boiseriver_gb.csv")
 





