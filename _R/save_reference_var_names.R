#It takes the data from reference/raw
# Filters all the variables that are targeted for the dashboard
# Saves into refecnce as a csv.
# The csv files work as a lookup table in the dashboard to check which variables
# must be included in the uploaded files by the user

library(rio)
library(dplyr)
library(tidyr)

dir_reference_raw <- "data/reference/raw"
dir_reference <- "data/reference"
dir_lookups <- file.path(dir_reference,"lookups")

list.files(dir_reference_raw)




#read data ------------------------------------------------------------------
niveles <- c("school", "teacher", "student")


data_filtered <- lapply(niveles, function(x){
  
  csv <- import(file.path(dir_reference_raw, glue("{x}_ref.csv")))
  
  #keep only variables that are targeted for the dashboard
  target <-  csv %>%
    rename(Dashboard= `For_Dashboard`) %>%
    filter(Dashboard == TRUE)
  
  export(target, file.path(dir_reference, glue("{x}_vars.csv")))
  
  
})




