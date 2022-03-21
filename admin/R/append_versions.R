
#'append rounds into a single file
#'@param nivel c(school, teacher, school)
#'@param dir_imports directory to store imports


append_versions <- function(nivel,
                            dir_imports,
                            dir_lkps){
  
  #message(dir_imports)
  
  #File to find
  find_this <- glue::glue("{nivel}.rds")
  
  #delete existing append versions
  unlink(file.path(dir_imports, find_this))
  
  #Define file to look and save
  find_this <- glue::glue("{nivel}.rds")
  
  #list all rounds of this file 
  files <- list.files(dir_imports, recursive = T, full.names = T, pattern =  find_this)
  
  #data_lookup
  data_look_up <- import(file.path(dir_lkps, nivel,  glue::glue("target_vars_{nivel}.csv")))
  
  
  
  #names of reference vars
  
  reference_vars <- data_look_up$var_name
  
  
  #append all rounds into a single file
  all_rounds <- lapply(files, function(x){rio::import(x) %>% select(all_of(c(reference_vars, "round", "district_nam", "division_nam")))})
  
  appended_rounds <- do.call(rbind, all_rounds)
  
  #export file to appended
  export(appended_rounds, file.path(dir_imports, find_this))
  
  
}




