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


for(name in names(data)){
  
  # convert to time-series object and plot
  data.ts <- ts(data[[name]])
  png(str_c("img/1_3_ts_", name, ".png"), width = 2048, height = 1024)
  plot(data.ts, main = name)
  dev.off()
  
  ggAcf(data.ts, main = name)
  ggsave(str_c("img/1_3_acf_", name, ".png"))
  
  ggPacf(data.ts, main = name)
  ggsave(str_c("img/1_3_pacf_", name, ".png"))
  
  png(str_c("img/1_3_spec_", name, ".png"), width = 2048, height = 1024)
  spectrum(data.ts)
  dev.off()
  
  png(str_c("img/1_3_spec10_", name, ".png"), width = 2048, height = 1024)
  spectrum(data.ts, span = 10)
  dev.off()
  
  
}



