################################################################################
############ Exercise 1.1: Univariate Time Series – General Aspects ############
################################################################################

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
DATASET_FILE = "GoldenGate.RData" 
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment
# data <- select(data, -CO2, -unemployment)

# convert to time-series object
data.ts <- ts(data$traffic, start = c(1968, 1), frequency = 12)
tsdisplay(data.ts)

## 2a)

# 1. Remove trend
data.corrected1 <- diff(data.ts, differences = 2)

# 2. Remove seasonality
data.corrected2 <- diff(data.ts, lag = 12, differences = 1)

# 3. Remove both
data.corrected3 = diff(data.ts, differences = 2)
data.corrected3 <- diff(data.corrected3, lag = 12, differences = 1)

# 4. Remove nothing
data.corrected4 <- data.ts

# Remove only trend
data.ses1 <- HoltWinters(data.corrected1, beta = FALSE)
# Remove only seasonality
data.ses2 <- HoltWinters(data.corrected2, gamma = FALSE)
# Remove both
data.ses3 <- HoltWinters(data.corrected3, beta = FALSE, gamma = FALSE)
# Remove nothing
data.ses4 <- HoltWinters(data.corrected4)

data.corrected <- data.corrected3
tsdisplay(data.corrected)

data.ses <- data.ses3
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
