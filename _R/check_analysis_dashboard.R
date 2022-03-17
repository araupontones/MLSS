library(dplyr)
library(tidyr)
library(janitor)


#define parameters
rounds <- c("Baseline", "Midline", "Endline")
nivel <- c("school", "teacher", "student")

#to get the path in dropbox
get_db <- function(round){
  
  round_number <- which(rounds == round)
  glue::glue("C:/Users/andre/Dropbox/MESIP_New_Internal RG/05_Data/0{round_number}_{round}/05_Derived")
}


rounds <- c("Baseline", "Midline", "Endline")
niveles <- c("school", "teacher", "student")


#read files and compare names with lookup -------------------------------------
read_files <- lapply(rounds, function(round){
  
  message(round)
  db <- get_db(round)
  #rlevels of round ------------------------------------------------------------
  list_niveles <- lapply(niveles, function(nivel){
    
    
 
    #data imported -----------
    infile <- list.files(db, pattern = glue::glue("{nivel}"), full.names = T)[1]
    data_upload <- rio::import(infile)
    
    #print(paste(nivel, (nrow(data_upload))))

  })
  
  names(list_niveles) <- niveles
  
  # missing_niveles <- do.call(rbind, list_niveles)
  return(list_niveles)
})
names(read_files) <- rounds



#Sense check dash analysis ----------------------------------------------------


get_mean <- function(round,
                     level,
                     var){
  
  message(round)
  inspect_data <- read_files[[round]][[level]]
  
  inspect_data %>%
    select({{var}}) %>%
    summarise(mean = mean({{var}}, na.rm = T),
              n = sum(!is.na({{var}})))
  
}


tabyl_var <- function(round, level, var){
  
  message(round)
  inspect_data <- read_files[[round]][[level]]
  
  inspect_data %>%
    mutate(label = susor::susor_get_stata_labels({{var}})) %>%
    tabyl({{var}}, label)
  
}


#check means are correct -----------------------------------------------------
lapply(rounds, function(x){get_mean(x, "school", abs_rate_tot)})


#check type of variable is defined correctly (continous, percentage, binary) ---
tabyl_var("Baseline", "student",a52 )



