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

# Covert data and time Variable using as.Date() function
filtered_data$Date <- as.Date(filtered_data, format="%d/%m/%Y")

# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels
png("plot1.png", width=480, height=480)

hist(filtered_data$Global_active_power, main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()

