library(sqldf)

url <- "http://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"

# The name of the datafile, with path
datafile <- paste(".", basename(dirname(url)), basename(url), sep="/")

# Create the directory for the data file if it doesn't exist
if( !file.exists(dirname(datafile))) {
    dir.create()
}

# Download the data file if it doesn't exist
if( !file.exists(datafile)) {
    download.file(url, datafile, method="curl", mode="wb")
}

# Unzip the actual data if it does not exist
file <- (unzip(datafile, list = TRUE))$Name
if( !file.exists(file)) {
    unzip(datafile, file)
}

# Sql to get only the rows for the dates I am interested in.
query <- "select * from file where Date = '1/2/2007' OR Date = '2/2/2007'"

# Read in the data grabbing only the records called for in query
data <- read.csv.sql(file, sql=query, header=TRUE, sep=";")
# Close the connection
sqldf()

# Remove the data file when finished
unlink(file)

# Convert missing data (?) to NA
data[data=="?"] <- NA

# Remove the records with missing data
cdata <- na.omit(data)

# Concat the data and time fields and convert them to a POSIXlt object
dateTimes <- strptime(paste(cdata$Date, cdata$Time),"%d/%m/%Y %T")

# Second plot - line
png(file = "plot2.png", width=480, height=480)
with(cdata, plot(dateTimes, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))
dev.off()

# Cleanup after I am done.
rm(url, datafile, file, query, data, cdata, dateTimes)

