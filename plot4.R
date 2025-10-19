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
png(filename = "plot4.png", width = 480, height = 480)

# Set up 2x2 layout
par(mfrow = c(2, 2))

# Top-left: Global Active Power over the two-day period:
plot(filtered_data$DateTime,
     filtered_data$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power")

# Top-right: Voltage over the two-day period:
plot(filtered_data$DateTime,
     filtered_data$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# Bottom-left: Energy usage in three distinct home areas:
plot(filtered_data$DateTime,
     filtered_data$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering",
     col = "black")
lines(filtered_data$DateTime, filtered_data$Sub_metering_2, col = "red")
lines(filtered_data$DateTime, filtered_data$Sub_metering_3, col = "blue")
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       bty = "n")  # No box around legend

# Bottom-right: Global Reactive Power over the two-day period:
plot(filtered_data$DateTime,
     filtered_data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global Reactive Power")

# Close the device
dev.off()

# Confirm completion
message("plot4.png successfully created and saved in the working directory")
