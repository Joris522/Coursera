# Coursera, Exploratory Data Analysis, Week 4, Peer Graded Assignment. Question 3.

# define packages
packages = c("downloader", "ggplot2")
# install and load packages
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

# create folder if does not exist -----------------------------------------
if (!file.exists("Exploratory_Data_Analysis_Week4_Assignment")) { # check if directory exists
  dir.create("Exploratory_Data_Analysis_Week4_Assignment") # create a directory if it doesn't exist
}

# set working directory ---------------------------------------------------
setwd("Exploratory_Data_Analysis_Week4_Assignment")

# download and unzip the data ---------------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile <- "EPA_PM25.zip"
if (!file.exists("summarySCC_PM25.rds")&!file.exists("Source_Classification_Code.rds")) { # check if directory exists
  download(url, dest= destfile, mode="wb") 
  unzip (destfile, exdir = ".", overwrite = TRUE)
  unlink("EPA_PM25.zip")
}

# read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 5.How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

# subset data Baltimore City, Maryland and motor vehicle sources
NEI_BaltimoreCity_motor_vehicle_sources  <- subset(NEI, fips=="24510")

# ggplot and save as PNG
png("plot5.png", width=800, height=600)
g <- ggplot(NEI_BaltimoreCity_motor_vehicle_sources, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Tons of PM2.5 emission')) +
  ggtitle('Total PM2.5 emissions per year from motor vehicle sources in Baltimore City, Maryland') +
  theme_minimal()
print(g)
dev.off()
