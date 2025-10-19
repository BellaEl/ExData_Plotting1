# Load the libraries (and install them first if unavailable):
if (!require("data.table")) install.packages("data.table")
library(data.table)


# Check if the "household_power_consumption.txt" file exists in the working directory:
if (!file.exists("household_power_consumption.txt")) {
    # Download and unzip if not found
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url, destfile = "elpower.zip", method = "curl")
    unzip("elpower.zip")
    file.remove("elpower.zip")
    message("Dataset downloaded and unzipped, zip file removed")
} else {
    message("Dataset already exists.")
}


# Read the data 
full_data <- fread("household_power_consumption.txt", sep = ";", na.strings = "?")

# Filter for the two dates:
filtered_data <- full_data[Date %in% c("1/2/2007", "2/2/2007")]
# Remove the original full dataset from memory:
rm(full_data)

# Create a DateTime column, needed for the x-axis of the line plot:
filtered_data$DateTime <- as.POSIXct(paste(filtered_data$Date, filtered_data$Time),
                                     format = "%d/%m/%Y %H:%M:%S")
# Set English for weekdays labels
Sys.setlocale("LC_TIME", "English")

# Open PNG device
png(filename = "plot3.png", width = 480, height = 480)

# Plot Sub_metering_1
plot(filtered_data$DateTime,               # X-axis: time stamps
     filtered_data$Sub_metering_1,         # Y-axis: energy usage in sub-metering zone 1
     type = "l",
     xlab = "",
     ylab = "Energy sub metering",
     col = "black")

# Add Sub_metering_2 in red
lines(filtered_data$DateTime, filtered_data$Sub_metering_2, col = "red")

# Add Sub_metering_3 in blue
lines(filtered_data$DateTime, filtered_data$Sub_metering_3, col = "blue")

# Add legend
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1)

# Close the device
dev.off()

# Confirm completion
message("plot3.png successfully created and saved in the working directory")