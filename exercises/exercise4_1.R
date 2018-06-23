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
DATASET_FILE = "ARMAsimulations.RData" 
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment

plotAll <- function(){
  for(name in names(data)){
    # convert to time-series object and plot
    data.ts <- ts(data[[name]])
    png(str_c("img/4_1_ts_", name, ".png"), width = 2000, height = 2000, pointsize = 32)
    plot(data.ts, main = name)
    dev.off()
    
    ggAcf(data.ts, main = name)
    ggsave(str_c("img/4_1_acf_", name, ".png"))
    
    ggPacf(data.ts, main = name)
    ggsave(str_c("img/4_1_pacf_", name, ".png"))
    
    png(str_c("img/4_1_spec_", name, ".png"), width = 2000, height = 2000, pointsize = 32)
    spectrum(data.ts)
    dev.off()
    
    png(str_c("img/4_1_spec10_", name, ".png"), width = 2000, height = 2000, pointsize = 32)
    spectrum(data.ts, span = 10)
    dev.off()
  }
}

arima1 <- function(){
  arima_model <- arima(data$ARMA1, order = c(1, 0, 0))
  print(arima_model)
  lowerInterval <- arima_model$coef - sqrt(diag(arima_model$var.coef))
  upperInterval <- arima_model$coef + sqrt(diag(arima_model$var.coef))
  print("Lower bound of interval")
  print(lowerInterval)
  print("Upper bound of interval")
  print(upperInterval)
}

arima2 <- function(){
  arima_model <- arima(data$ARMA2, order = c(1, 0, 0))
  print(arima_model)
  lowerInterval <- arima_model$coef - sqrt(diag(arima_model$var.coef))
  upperInterval <- arima_model$coef + sqrt(diag(arima_model$var.coef))
  print("Lower bound of interval")
  print(lowerInterval)
  print("Upper bound of interval")
  print(upperInterval)
}

arima3 <- function(){
  arima_model <- arima(data$ARMA3, order = c(3, 1, 0))
  print(arima_model)
  lowerInterval <- arima_model$coef - sqrt(diag(arima_model$var.coef))
  upperInterval <- arima_model$coef + sqrt(diag(arima_model$var.coef))
  for ( name in names(lowerInterval) ){
    print(cbind(lowerInterval[name], upperInterval[name]))
  }
}


arima3()

