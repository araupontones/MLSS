library(dplyr)
library(tidyr)
dir_lookups <- "C:/repositaries/1.work/MLSS/data/reference/lookups"

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
   
   
   data_look_up <- rio::import(file.path(dir_lookups, nivel,  glue::glue("target_vars_{nivel}.csv"))) %>%
     select(var_name, label)
   
   #data imported -----------
   infile <- list.files(db, pattern = glue::glue("{nivel}"), full.names = T)[1]
   data_upload <- rio::import(infile)
   
   print(paste(nivel, (nrow(data_upload))))
   #Compare variable names
   reference_vars <- data_look_up$var_name
   uploaded_vars <- names(data_upload)
   
   #print(uploaded_vars)
   #missing in file
   missing_in_upload <- setdiff(reference_vars, uploaded_vars)
   
   tibble_missing <- tibble(
     
     round = round,
     file = nivel,
     missing_var = missing_in_upload
   ) 
   
   if((nrow(tibble_missing)) >0){
     
     tibble_missing <- tibble_missing %>%
       left_join(data_look_up, by = c("missing_var" = "var_name"))
   }
   
   
   
   
 })
  
  
 missing_niveles <- do.call(rbind, list_niveles)
 return(missing_niveles)
})

names(read_files) <- rounds

#append rounds
missing_all_rounds <- do.call(rbind,read_files)
View(missing_all_rounds)

View(missing_all_rounds)
rio::export(missing_all_rounds, file.path("data/missing_vars/missing_vars.xlsx"), overwrite=T)
