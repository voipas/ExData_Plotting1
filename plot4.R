#####################################################################################################
# Getting the data
#####################################################################################################


# Define variables (URL and filename) for dataset files to be downloaded
dataFile <- "household_power_consumption.txt"
archiveUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
archiveFile <- "household_power_consumption.zip"

# Check if the dataset file already exists, otherwise check if archive is downloaded
if(!file.exists(dataFile)) { 
  # Check if the archive already exists, otherwise download
  if(!file.exists(archiveFile)) {
    download.file(archiveUrl, archiveFile, method = "curl") 
  } 
  unzip(archiveFile) 
}




#####################################################################################################
# Checking Memory size (only theoretical calc)
#####################################################################################################
# 
# memory_required = no.of column * no. of rows * 8 bytes / numeric
# household_power_consumption.txt has:
#  - 2075260 rows
#  - 9 rows
# memory_required = 2075260 * 9 * 8 Bytes / numeric = 149418720 bytes = 142 MB

#####################################################################################################
# Reading the data
#####################################################################################################

# Note that in this dataset missing values are coded as ?
data <- read.csv(dataFile, header = TRUE, sep = ";", na.strings="?", stringsAsFactors=F, nrows = 2075259)

# We will only be using data from the dates 2007-02-01 and 2007-02-02.
filtered_data <- subset(data, Date %in% c("1/2/2007","2/2/2007"))

#
# Diagram requires Days in format (Thu, Fri Sat) and Energy sub Metering (Sub_metering_1) as Numeric
#

# Converting two Date and time Columns to a single and subtracking to data_time variable
date_time <- strptime(paste(filtered_data$Date, filtered_data$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 

# converting Global Active number as numeric and save all components to new global_active_power variable
global_active_power <- as.numeric(filtered_data$Global_active_power)

# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
#It corresponds to the kitchen, containing mainly a dishwasher, an oven and 
#a microwave (hot plates are not electric but gas powered).
sub_metering_1 <- as.numeric(filtered_data$Sub_metering_1)

# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy).
# It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
sub_metering_2 <- as.numeric(filtered_data$Sub_metering_2)

# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
# It corresponds to an electric water-heater and an air-conditioner.
sub_metering_3 <- as.numeric(filtered_data$Sub_metering_3)

# Voltage: minute-averaged voltage (in volt)
voltage <- as.numeric(filtered_data$Voltage)


# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
global_reactive_power <- as.numeric(filtered_data$Global_reactive_power)


# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels
# We need 4 diagrams: 2 rows , 2 columns
png("plot4.png", width=480, height=480)

# We need 4 diagrams: 2 rows , 2 columns
par(mfrow = c(2, 2)) 

# drawing first diagram - Global Active Power
plot(date_time, global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")

# drawing second diagram - Voltage / datetime
plot(date_time, voltage, type="l", xlab="datetime", ylab="Voltage")


# drawing third diagram Energy Sub Metering
plot(date_time, sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(date_time, sub_metering_2, type="l", col = "red")
lines(date_time, sub_metering_3, type="l", col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2, col=c("black", "red", "blue"))


# drawing fourth diagram - Global Reactive Diagram
plot(date_time, global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()

