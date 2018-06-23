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
DATASET_FILE = "viscosity.RData"
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment

doTemp <- function(){
  data.ts <- ts(data$temp)
  tsdisplay(data.ts, main = "Temperature")
  spectrum(data.ts, main = "Temperature", span = 10)
}

doVisc <- function(){
  data.ts <- ts(data$visc)
  tsdisplay(data.ts, main = "Viscosity")
  spectrum(data.ts, main = "Viscosity", span = 10)
}

doCC <- function(){
  data.ts.temp <- ts(data$temp)
  data.ts.visc <- ts(data$visc)
  ccf(data.ts.temp, data.ts.visc, na.action = na.omit)
}

getIntervals <- function(data.arima){
  lowerInterval <- data.arima$coef - sqrt(diag(data.arima$var.coef))
  upperInterval <- data.arima$coef + sqrt(diag(data.arima$var.coef))
  
  for ( name in names(lowerInterval) ){
    print(cbind(lowerInterval[name], upperInterval[name]))
  }
}

doAnalysis <- function(data.arima){
  print(data.arima)
  # getIntervals(data.arima)
  # print( (1-pnorm(abs(data.arima$coef)/sqrt(diag(data.arima$var.coef))))*2)
  tslm(data.arima$model)
  tsdisplay(data.arima$residuals)
  
  print(shapiro.test(data.arima$residuals))
  
  print(accuracy(data.arima))
  print(Box.test(data.arima$residuals, lag = 10, type = "Ljung-Box"))
  
  #Plot fitted values vs real values
  plot(data.arima$x, col = 'black', main = "Fitted vs Real Values")
  lines(data.arima$fitted, col = "red")
  
  #Make forecast and plot
  print("Forecaste results...")
  data.arima.fore <- forecast(data.arima, h = 10)
  print(accuracy(data.arima.fore))
  plot(data.arima.fore)
  
  tsdisplay(data.arima.fore$residuals, main = "Residuals of forecast")
  print(Box.test(data.arima.fore$residuals, lag = 10, type = "Ljung-Box"))
}
doArimaVisc <- function(){
  data.ts <- ts(data$visc)
  data.arima <- Arima(data.ts, order = c(5, 0, 0))
  doAnalysis(data.arima)  
}

doRegressionVisc <- function(){
  data.ts <- ts(data)
  data.proxy <- Arima(data.ts[,1], xreg = data.ts[,2], order = c(3,0,0))
  doAnalysis(data.proxy)
}

doAutoVisc <- function(){
  data.ts <- ts(data)
  data.auto <<- auto.arima(data.ts[,1],xreg=data.ts[,2])
  doAnalysis(data.auto)
}

# doTemp()
# doVisc()
# doCC()
doAutoVisc()