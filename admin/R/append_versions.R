
#'append rounds into a single file
#'@param nivel c(school, teacher, school)
#'@param dir_imports directory to store imports


append_versions <- function(nivel,
                            dir_imports){
  
  #message(dir_imports)
  
  #Define file to look and save
  find_this <- glue::glue("{nivel}.rds")
  
  #list all rounds of this file 
  files <- list.files(dir_imports, recursive = T, full.names = T, pattern =  find_this)
  
  #append all rounds into a single file
  all_rounds <- lapply(files, function(x){rio::import(x)})
  appended_rounds <- do.call(rbind, all_rounds)
  
  #export file to appended
  export(appended_rounds, file.path(dir_imports, find_this))
  
  
}




