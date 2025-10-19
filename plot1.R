# Load the libraries (and install them first if unavailable:
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

# Filter for the two dates
filtered_data <- full_data[Date %in% c("1/2/2007", "2/2/2007")]
# Remove the original full dataset from memory:
rm(full_data)

# Have a look at the data and see if there are NAs:
summary(filtered_data)
# No NAs in the filtered dataset

# Open PNG device
png(filename = "plot1.png", width = 480, height = 480)

# Create the histogram
hist(
    filtered_data$Global_active_power,
    col = "red",
    main = "Global Active Power",
    xlab = "Global Active Power (kilowatts)"
)

# Close the device
dev.off()

# Confirm completion
message("plot1.png successfully created and saved in the working directory")

