library(rio)
library(dplyr)
library(tidyr)

dir_reference_raw <- "data/reference/raw"
dir_reference <- "data/reference"

list.files(dir_reference_raw)




#read data ------------------------------------------------------------------
niveles <- c("school", "teacher", "student")


data_filtered <- lapply(niveles, function(x){
  
  csv <- import(file.path(dir_reference_raw, glue("{x}_ref.csv")))
  
  target <-  csv %>%
    rename(Dashboard= `For_Dashboard`) %>%
    filter(Dashboard == TRUE)
  
  export(target, file.path(dir_reference, glue("{x}_vars.csv")))
  
  
})




