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

# Obtain plots
name = "traffic"
data.ts <- ts(data$traffic, start = c(1968, 1), frequency = 12)

png(str_c("img/4_2_ts_", name, ".png"), width = 2000, height = 2000, pointsize = 32)
plot(data.ts, main = name)
dev.off()

ggAcf(data.ts, main = name)
ggsave(str_c("img/4_2_acf_", name, ".png"))

ggPacf(data.ts, main = name)
ggsave(str_c("img/4_2_pacf_", name, ".png"))

png(str_c("img/4_2_spec_", name, ".png"), width = 2000, height = 2000, pointsize = 32)
spectrum(data.ts)
dev.off()

png(str_c("img/4_2_spec10_", name, ".png"), width = 2000, height = 2000, pointsize = 32)
spectrum(data.ts, span = 10)
dev.off()

# No changes, run this...
# data.corrected <- data.ts

## Test differencing
data.corrected <- diff(data.ts, differences = 1)
data.corrected <- diff(data.corrected, lag = 12, differences = 1)
tsdisplay(data.corrected)

# 

data.arima <- Arima(data.ts, order = c(1, 1, 1), seasonal = list(order = c(1, 1, 0), 
                                                   period = 12))
print(data.arima)

lowerInterval <- data.arima$coef - sqrt(diag(data.arima$var.coef))
upperInterval <- data.arima$coef + sqrt(diag(data.arima$var.coef))
for ( name in names(lowerInterval) ){
  print(cbind(lowerInterval[name], upperInterval[name]))
}

plot(forecast(data.arima, h = 12))
