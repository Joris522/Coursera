# Coursera, Exploratory Data Analysis, Week 4, Peer Graded Assignment. Question 2.

# install package and open library
install.packages("downloader")
library(downloader)

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

# 2.Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# subset data Baltimore City, Maryland
NEI_BaltimoreCity  <- subset(NEI, fips=="24510")

# sum emissions for each year
yearly_emission <- aggregate(Emissions ~ year, NEI_BaltimoreCity, sum)

# plot and save as PNG
png('plot2.png')
barplot(height=yearly_emission$Emissions, names.arg=yearly_emission$year, xlab="year", ylab=expression('Tons of PM2.5 emission'),main=expression('Total PM2.5 emissions per year in the Baltimore City, Maryland'))
dev.off()

