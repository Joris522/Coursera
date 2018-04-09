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

# 4.Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

# Coal combustion related sources
SCC_coal = SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]

# Merge two data sets
merge_NEI_SCC_coal <- merge(x=NEI, y=SCC_coal, by='SCC')
yearly_emission_coal_combustion <- aggregate(Emissions ~ year, merge_NEI_SCC_coal, sum)

# ggplot and save as PNG
png("plot4.png", width=640, height=480)
g <- ggplot(yearly_emission_coal_combustion, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Tons of PM2.5 emission')) +
  ggtitle('Total PM2.5 emissions per year from coal combustion related sources') +
  theme_minimal()
print(g)
dev.off()
