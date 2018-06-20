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
DATASET_FILE = "laborforce.RData" 
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment
data <- select(data, -CO2, -unemployment)
# convert to time-series object
#data.ts <- ts(data$temp, start = 1953, frequency = 12) # Montly data for recife
data.ts <- ts(data$laborforce, start = c(1948, 1), frequency = 12) 

# a) Make a time sequence plot of the selected data and perform an 
#    Exploratory Data Analysis (EDA): 
#       - Characterize the main properties of the time series such as:
#           - trend, 
#           - seasonal variation, 
#           - cyclic variation
#           - irregular variations
#           - sudden changes in the data and/or possible outliers.
# plot(data.ts, main = "Time sequence series for Recife's temperature",
#      xlab = "Years", ylab = "Temperature") #Recife
# plot(data.ts, main = "Time sequence series for Prothero's sales",
#      xlab = "Years", ylab = "Sales") #Prothero
tsdisplay(data.ts)

# INTERPRETATION for recife dataset
# The data does not expose any trend but suggests some seasonality. No cyclic
# variation can be observed and some irregularities can be found such as some
# years with slightly different picks and maximum values. We can observe some
# sudden changes in some of the picks and specially in year 1960, outliers seem 
# to be present (picks with different shape than the others).

# INTERPRETATION for prothero dataset
# J > The data exhibits a grow, which can be interpreted as a trend. No cyclic
# variation is observed but seasonality it is. We notice some small variations 
# after the seasonal picks from year to year which may suggest outliers.

# INTERPRETATION for laborforce dataset
# Trend: We can clearly observe a trend on the labor force.
# Seasonality: Yes, in the information we visualize, there is a seasonal factor
#              per year, that is continously repeated.
# Cyclyc variation: No cyclic variation observed.
# Irregular variation: No irregular variation observed.
# Sudden changes and/or outliers: Yes. At some points (e.g. ~1975) there are
#                                 sudden changes that even if the trend and
#                                 seasonality is preserved, outstand in the 
#                                 observed pattern.

# b) If the time series selected exhibits trend, describe ways to correct for it
#    Explain how finite differencing might correct for trend.
# J > Finite differencing may expose the change with respect to each moment on
#     on time. This is, if from one month to another a big change ocurred, we 
#     consider only this effective change (delta). Hence, we will not observe
#     the trend, but the actual variations during time representing the trend.

# Experiment with the effect of finite differencing on the data set selected and
# perform an Exploratory Data Analysis on the result obtained. 

#    Do you expect for the data set selected that it is needed to do this finite 
#    differencing more than once to correct for trend? Check your conjecture 
#    with R
# J > The trend is not drastically increasing, so we would expect to get better
#     results with 1 correction only.

# Testing 1 correction
data.d1 = diff(data.ts, differences = 1)
tsdisplay(data.d1)

# Testing 2 corrections
data.d2 = diff(data.ts, differences = 2)
tsdisplay(data.d2)

# c) If the time series selected exhibits seasonality, determine the period of 
#    seasonality and argue if an additive or a multiplicative seasonal model 
#    seems most adequate.

# THEORY: The additive decomposition is the most appropriate if the magnitude 
#         of the seasonal fluctuations, or the variation around the trend-cycle,
#         does not vary with the level of the time series. When the variation in
#         the seasonal pattern, or the variation around the trend-cycle, appears
#         to be proportional to the level of the time series, then a 
#         multiplicative decomposition is more appropriate. Multiplicative 
#         decompositions are common with economic time series. Multiplicative 
#         can be performed many times to correct (similar to trend correction)

# J > Additive decomposition should be the most adequate

data.deco.mult <- decompose(data.ts, type = "multiplicative") # other: multiplicative
plot(data.deco.mult)

data.deco.add <- decompose(data.ts, type = "additive") # other: multiplicative
plot(data.deco.add)

## d)

data.sd1 <- diff(data.ts, lag = 12, differences = 1)
tsdisplay(data.sd1)

data.sd2 <- diff(data.ts, lag = 12, differences = 2)
tsdisplay(data.sd2)

# e
data.corrected = diff(data.ts, differences = 1)
data.corrected <- diff(data.corrected, lag = 12, differences = 2)
tsdisplay(data.corrected)

# f
data.corrected.dec <- decompose(data.corrected, type = "additive") # other: multiplicative
plot(data.corrected.dec)

data.corrected.dec$figure # Global Additive Seasonal Factors

# g
data.corrected.dec2 <- decompose(data.corrected, type = "multiplicative") # other: multiplicative
plot(data.corrected.dec2)

data.corrected.dec2$figure

# 1.2
spectrum(data.ts)

spectrum(data.corrected.dec$x)

spectrum(data.ts)
spectrum(data.ts, span = 10)
spectrum(data.corrected.dec$x, span = 10)
