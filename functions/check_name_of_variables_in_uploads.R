#'check if names of variables in files are consistent with reference data
#'@param dir_imports directory where uploads for this round are stored
#'@param dir_refernce directory where referecne data is stored
#'@param nivel level to check for (school, student, teacher)
#'@return a character: OK if variables are in uploads, a character with all
#'the variables missing in the uploads

check_var_names <- function(dir_imports = "data/imports/Baseline",
                            dir_reference = "data/reference",
                            dir_tempo, 
                            nivel = "school"){
  
  
  data_upload <- import(file.path(dir_imports, glue("{nivel}.dta"))) 
  
  
  data_reference <- import(file.path(dir_reference, glue("{nivel}_vars.csv")))
  
  
  #names of reference vars
  
  reference_vars <- data_reference$var_name
  
  
  #names of upload vars
  uploaded_vars <- names(data_upload)
  
  
  #check that all reference vars in uploaded
  
  missing_in_upload <- setdiff(reference_vars, uploaded_vars)
  if(length(missing_in_upload) > 0){
    
    
    vars_missing <-  paste(missing_in_upload, collapse =  "<br>")
    return(vars_missing)
    
  } else {
    
    #delete stata file
    unlink(file.path(dir_imports, glue("{nivel}.dta")))
    
    
    #crete temporal rds (only keep if checking protocol is OK)
    data_upload %>%
      select(reference_vars) %>%
      export(.,file.path(dir_tempo, glue("{nivel}.rds")))
    
    return("OK")
  }
  
  
  
  
  
  
  
}





