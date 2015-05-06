#===============================================================================
# Reproducible Research Project #1
# Author:  Byron Estes
# Date:  
#===============================================================================
#Load Libaries
library(dplyr)
library(lubridate)

#-------------------------------------------------------------------------------
# Step 1:  Download zip file to working direcory IF IT DOES NOT ALREADY EXIST
#-------------------------------------------------------------------------------
if(!file.exists("repdata-data-activity.zip")) {
        print("downloading...")
        zipfile <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip", zipfile)
} else {
        zipfile <- "repdata-data-activity.zip" 
}
#-------------------------------------------------------------------------------
# Step 2:  Reads the file needed from the archive (i.e. does not explode it) and 
#          loads it into a data frame variable based on the file name. After 
#          reading, unlink (i.e. delete) file ONLY IF SCRIPT DOWNLOADED IT!
#-------------------------------------------------------------------------------
activity <- read.csv(unz(zipfile, "activity.csv"), 
                     header=TRUE, 
                     sep =",",
                     na.strings="NA",
                     stringsAsFactors=FALSE)


# What is mean total number of steps taken per day?

activity_avg_by_date <- activity %>%
        group_by(date) %>%
        summarize(mean(steps, na.rm=TRUE))

names(activity_avg_by_date) <- c("Date", "Mean")

png(filename="before_date.png",
    width=480,
    height=480)

hist(activity_avg_by_date$Mean)

dev.off()

#barplot(activity_avg_by_date$Mean)

# What is the average daily activity pattern? (Average per 5 minute slice across all days?)

activity_avg_by_interval <- activity %>%
        group_by(interval) %>% 
        summarize(mean(steps, na.rm=TRUE))

names(activity_avg_by_interval) <- c("Interval", "Mean")


png(filename="before_interval.png",
    width=480,
    height=480)

hist(activity_avg_by_interval$Mean)

dev.off()

# null issue?
barplot(activity_avg_by_interval$Mean) 

# Imputing missing values and compare.

# 1 - Calculate and report the total number of missing values in the dataset 
activity_na_steps <- subset(activity, is.na(activity$steps))
nrow(activity_na_steps)
# 2 - Set missing steps in observation to the average for the interval, but what if
# no average for a NA step, then set to zero.


Loop through activity_avg_by_interval
subselect observations with that interval and NA ---replace it with the mean
end loop
select any remaining na and set to zero (...or eliminate) 

activity_imputed <- activity

for(i in 1:nrow(activity_avg_by_interval)) {
        # Get interval and average for that interval
        interval <- as.integer(activity_avg_by_interval[i,1])
        average <- as.numeric(activity_avg_by_interval[i,2])
        # Find all occurences of that interval with NA and set steps to the average steps for that interval.
        activity_imputed[which(activity_imputed$interval == interval & is.na(activity_imputed$steps)),1] <- average
        #print (paste(i, interval,average))
}



activity_imputed_avg_by_date <- activity_imputed %>%
        group_by(date) %>%
        summarize(mean(steps))

names(activity_imputed_avg_by_date) <- c("Date", "Mean")

png(filename="after_date.png",
    width=480,
    height=480)

hist(activity_imputed_avg_by_date$Mean)

dev.off()

activity_imputed_avg_by_interval <- activity_imputed %>%
        group_by(interval) %>% 
        summarize(mean(steps))

names(activity_imputed_avg_by_interval) <- c("Interval", "Mean")

png(filename="after_interval.png",
    width=480,
    height=480)

hist(activity_imputed_avg_by_interval$Mean)

dev.off()

#What about missing intervals?  Answer: there aren't at 55 increase the hundreds for the next hour

http://stackoverflow.com/questions/9322773/how-to-replace-na-with-mean-by-subset-in-r-impute-with-plyr

#Are there differences in activity patterns between weekdays and weekends?
#Add day of week to dataset
activity_imputed_with_dayofweek <- activity_imputed %>%
        mutate(day=wday(date)) %>%
        group_by(day) %>%
        summarize(mean(steps))        

png(filename="after_day_of_week.png",
    width=480,
    height=480)

names(activity_imputed_with_dayofweek) <- c("Day", "Mean")


barplot(activity_imputed_with_dayofweek$Mean,
        main="Activity by Day of Week",        
        ylab="Mean Steps",
        xlab="Day",
        names.arg=activity_imputed_with_dayofweek$Day,
        col="azure2")

dev.off()

!!!!!
        TODO:
        !!!!
        Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating
whether a given date is a weekday or weekend day.
2. Make a panel plot containing a time series plot (i.e. type = "l" ) of the 5minute
interval (xaxis)
and
the average number of steps taken, averaged across all weekday days or weekend days (yaxis).
See the README file in the GitHub repository to see an example of what this plot should look like
using simulated data.