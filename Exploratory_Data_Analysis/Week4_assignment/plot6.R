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

# 6.Compare emissions from motor vehicle sources in Baltimore City with emissions from 
# motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# subset data Baltimore City, Maryland OR Los Angeles County, California, AND ON-ROAD type
subsetNEI <- NEI[(NEI$fips=="24510"|NEI$fips=="06037") & NEI$type=="ON-ROAD",  ]

# sum motor vehicle emissions for each year and fips
yearly_emission_motor_vehicles_by_fips <- aggregate(Emissions ~ year + fips, subsetNEI, sum)
# Replace code for place
yearly_emission_motor_vehicles_by_fips$fips[yearly_emission_motor_vehicles_by_fips$fips=="24510"] <- "Baltimore"
yearly_emission_motor_vehicles_by_fips$fips[yearly_emission_motor_vehicles_by_fips$fips=="06037"] <- "Los Angeles"

# ggplot and save as PNG
png("plot6.png", width=1040, height=480)
g <- ggplot(yearly_emission_motor_vehicles_by_fips, aes(factor(year), Emissions))
g <- g + facet_grid(. ~ fips)
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Tons of PM2.5 emission')) +
  ggtitle('Total PM2.5 emissions per year from motor vehicle sources in Baltimore City, Maryland, and Los Angeles, California') +
  theme_minimal()
print(g)
dev.off()
