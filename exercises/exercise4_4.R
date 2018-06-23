# Go to working directory
currentDir <- getSrcDirectory(function(x) {x})
setwd(currentDir)

# Load the libraries -> fpp (for now...)
library(fpp2)
library(stringr)

# Set constants
DATASETS_DIR = "../datasets"

# Instruction > Select one of the univariate (U) sample data sets available!
DATASET_FILE = "GoldenGate.RData"
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment

# Obtain plots
data.ts <-  ts(data$traffic, start = c(1968, 1), frequency = 12)

data.ts.fit <- window(data.ts, start = c(1968, 1), end = c(1977, 12))
data.ts.val <- window(data.ts, start = c(1978, 1))

getIntervals <- function(data.arima){
  lowerInterval <- data.arima$coef - sqrt(diag(data.arima$var.coef))
  upperInterval <- data.arima$coef + sqrt(diag(data.arima$var.coef))
  
  for ( name in names(lowerInterval) ){
    print(cbind(lowerInterval[name], upperInterval[name]))
  }
}

doAnalysis <- function(data.arima, data.ts.val){
  print(data.arima)
  getIntervals(data.arima)
  
  tsdisplay(data.arima$residuals)
  print(accuracy(data.arima))
  print(Box.test(data.arima$residuals, lag = 12, type = "Ljung-Box"))
  
  #Plot fitted values vs real values
  plot(data.arima$x, col = 'black', main = "Fitted vs Real Values")
  lines(data.arima$fitted, col = "red")
  
  #Make forecast and plot
  print("Forecaste results...")
  data.arima.fore <- forecast(data.arima, h = 12*4)
  print(accuracy(data.arima.fore, data.ts.val))
  plot(data.arima.fore)
  # Plot 
  plot(data.arima.fore$mean, col = 'black', main = "Predicted vs Real Values")
  lines(data.ts.val, col = "red")
  
  tsdisplay(data.arima.fore$residuals, main = "Residuals of forecast")
  print(Box.test(data.arima.fore$residuals, lag = 12, type = "Ljung-Box"))
}

# Mine
ex44a1 <- function(){
  data.arima <- Arima(data.ts.fit, order = c(1, 1, 1), seasonal = list(order = c(1, 1, 0),
                                                                   period = 12))
  doAnalysis(data.arima, data.ts.val)
}

# Professor's
ex44a2 <- function(){
  data.arima <- Arima(data.ts.fit, order = c(0, 1, 1), seasonal = list(order = c(0, 1, 0),
                                                                       period = 12))
  doAnalysis(data.arima, data.ts.val)
}

ex44g <- function(){
  data.arima <- auto.arima(data.ts.fit)
  doAnalysis(data.arima, data.ts.val)
}

# ex44a1()
ex44a2()
# ex44g()