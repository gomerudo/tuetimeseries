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

arima1 <- function(){
  
  sim<- arima.sim(n = 250, list(ar = c(0.5), ma = c(-1.3, 0.4)))
  tsdisplay(sim.ts)
  arimares <- arima(sim, order = c(1, 0, 2))
  
  arima.fore <- forecast(arimares, h = 10)
  plot(arima.fore)
  plot(arima.fore)
}

