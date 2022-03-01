#'check if names of variables in files are consistent with reference data
#'@param dir_imports directory where uploads for this round are stored
#'@param dir_refernce directory where referecne data is stored
#'@param nivel level to check for (school, student, teacher)
#'@return a character: OK if variables are in uploads, a character with all
#'the variables missing in the uploads

check_var_names <- function(#dir_imports = "data/imports/Baseline",
                            #dir_zips,
                            dir_lookups = "data/reference/lookups",
                            tempfiles, 
                            nivel = "school"
                            ){
  
  #temp file
  tempofile <- tempfiles[which(str_detect(tempfiles, nivel))]
    
    

  
  data_upload <- rio::import(tempofile)
  data_look_up <- import(file.path(dir_lookups, nivel,  glue::glue("target_vars_{nivel}.csv")))
  
  
  
  #names of reference vars
  
  reference_vars <- data_look_up$var_name
  
  
  #names of upload vars
  uploaded_vars <- names(data_upload)
  
  
  #check that all reference vars in uploaded
  
  missing_in_upload <- setdiff(reference_vars, uploaded_vars)
  if(length(missing_in_upload) > 0){
    
    
    vars_missing <-  paste(missing_in_upload, collapse =  "<br>")
    return(vars_missing)
    
  } else {
    
      #delete tempfile
    unlink(tempofile)
    # 
    # 
    # #crete temporal rds (only keep if checking protocol is OK)
    # data_upload %>%
    #   select(all_of(reference_vars)) %>%
    #   mutate(round = round) %>%
    #   export(.,file.path(dir_tempo, glue("{nivel}.rds")))
    
    return("OK")
  }
  
  
  
  
  
  
  
}





