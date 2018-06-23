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
DATASET_FILE = "catalog.RData"
DATASET_FULL_PATH <- str_c(DATASETS_DIR, "/", DATASET_FILE)

# Load the dataset
data <- load(DATASET_FULL_PATH)
data <- get(data) # The actual object. We will see it twice in the environment

# Obtain plots
name = "traffic"

doMen <- function(data){
  data.ts <- ts(data$men, start = c(1989, 1), frequency = 12)
  tsdisplay(data.ts, main = "Men")
  spectrum(data.ts, main = "Men", span = 10)
}

doWomen <- function(data){
  data.ts <- ts(data$women, start = c(1989, 1), frequency = 12)
  tsdisplay(data.ts, main = "Women")
  spectrum(data.ts, main = "Women", span = 10)
}

doCSR <- function(data){
  data.ts <- ts(data$service, start = c(1989, 1), frequency = 12)
  tsdisplay(data.ts, main = "CSR")
  spectrum(data.ts, main = "CSR", span = 10)
}

doCC <- function(){
  data.ts.men <- ts(data$men, start = c(1989, 1), frequency = 12)
  data.ts.women <- ts(data$women, start = c(1989, 1), frequency = 12)
  data.ts.service <- ts(data$service, start = c(1989, 1), frequency = 12)
  ccf(data.ts.men, data.ts.women, na.action = na.omit)
  ccf(data.ts.men, data.ts.service, na.action = na.omit) # MS
  ccf(data.ts.women, data.ts.service, na.action = na.omit) # WS 
  
}

doCorrections <- function(){
  data.ts.men <- ts(data$men, start = c(1989, 1), frequency = 12)
  data.ts.women <- ts(data$women, start = c(1989, 1), frequency = 12)
  data.ts.service <- ts(data$service, start = c(1989, 1), frequency = 12)
  
  # Correct men
  data.ts.men.corrected <- diff(data.ts.men, differences = 1)
  data.ts.men.corrected <- diff(data.ts.men.corrected, lag = 12, differences = 2)
  tsdisplay(data.ts.men.corrected)

  # Correct women
  data.ts.women.corrected <- diff(data.ts.women, lag = 12, differences = 1)
  tsdisplay(data.ts.women.corrected)
  
  # Correct service
  data.ts.service.corrected <- diff(data.ts.service, differences = 2)
  data.ts.service.corrected <- diff(data.ts.service.corrected, lag = 12, differences = 1)
  tsdisplay(data.ts.service.corrected)

  ccf(data.ts.men.corrected, data.ts.women.corrected, na.action = na.omit)
  ccf(data.ts.men.corrected, data.ts.service.corrected, na.action = na.omit) # MS
  ccf(data.ts.women.corrected, data.ts.service.corrected, na.action = na.omit) # WS 
  
}

# doMen(data)
# doWomen(data)
# doCSR(data)
# doCC()
doCorrections()