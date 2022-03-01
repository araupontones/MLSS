
#'append rounds into a single file
#'@param nivel c(school, teacher, school)
#'@param dir_imports directory to store imports


append_versions <- function(nivel,
                            dir_imports){
  
  #message(dir_imports)
  
<<<<<<< HEAD
=======
  #File to find
  find_this <- glue::glue("{nivel}.rds")
  
  #delete existing append versions
  unlink(file.path(dir_imports, find_this))
  
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
  #Define file to look and save
  find_this <- glue::glue("{nivel}.rds")
  
  #list all rounds of this file 
  files <- list.files(dir_imports, recursive = T, full.names = T, pattern =  find_this)
  
<<<<<<< HEAD
=======
  
  
  
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
  #append all rounds into a single file
  all_rounds <- lapply(files, function(x){rio::import(x)})
  appended_rounds <- do.call(rbind, all_rounds)
  
  #export file to appended
  export(appended_rounds, file.path(dir_imports, find_this))
  
  
}




