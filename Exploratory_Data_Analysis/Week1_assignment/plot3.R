# install packages + open library -----------------------------------------
packages = c("downloader","lubridate")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

# download and unzip the data ---------------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile <- "ElectricPowerConsumption.zip"
download(url, dest= destfile, mode="wb") 
unzip (destfile, exdir = ".", overwrite = TRUE)
unlink("ElectricPowerConsumption.zip")

# add parameters
household_power_consumption <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, dec=".", stringsAsFactors = F)
# convert question marks to NA
household_power_consumption[household_power_consumption == "?"] <- NA
# convert class character to posixt
household_power_consumption$Date <- dmy(household_power_consumption$Date)
# subset dates
household_power_consumption_subset <- household_power_consumption[(household_power_consumption$Date >= "2007-02-01" & household_power_consumption$Date <= "2007-02-02"),]

# create line graph
household_power_consumption$Time <- hms(household_power_consumption$Time)
datetime <- ymd_hms(paste(household_power_consumption_subset$Date, household_power_consumption_subset$Time))
global_active_power <- as.numeric(household_power_consumption_subset$Global_active_power)
sub_metering_1 <- as.numeric(household_power_consumption_subset$Sub_metering_1)
sub_metering_2 <- as.numeric(household_power_consumption_subset$Sub_metering_2)
sub_metering_3 <- as.numeric(household_power_consumption_subset$Sub_metering_3)
png("plot3.png", width=480, height=480)
plot(datetime, sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
lines(datetime, sub_metering_2, type="l", col="red")
lines(datetime, sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
dev.off()
