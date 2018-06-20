# Go to working directory
currentDir <- getSrcDirectory(function(x) {x})
setwd(currentDir)

# Load the libraries -> fpp (for now...)
library(fpp2)
library(stringr)
library(dplyr) # To handle datasets

# Set constants
DATASETS_DIR = "../datasets"

# Instruction > Select one of the univariate (U) sample data sets available!
DATASET_FILE = "laborforce.RData" 
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment
data <- select(data, -CO2, -unemployment)
# convert to time-series object
#data.ts <- ts(data$temp, start = 1953, frequency = 12) # Montly data for recife
data.ts <- ts(data$laborforce, start = c(1948, 1), frequency = 12) 

#data.ses <- HoltWinters(data.ts, seasonal = "additive")
data.ses <- ets(data.ts)

plot(data.ses)

# check accuracy on the fitted values (NOT THE FORECASTED)
with(data.ses, accuracy(fitted,x))

# Forecasting
data.ses.fore <- forecast(data.ses, h = 10)

plot(data.ses.fore)

# Check normality of residuals
qqnorm(unclass(data.ses.fore$residuals))
qqline(unclass(data.ses.fore$residuals))

shapiro.test(data.ses.fore$residuals)

# Check significance of the autocorrelations in the residuals. If random noise,
# this should be 0!

tsdisplay(data.ses.fore$residuals)
Box.test(data.ses.fore$residuals, lag = 12, type = "Ljung-Box")

#####################################
