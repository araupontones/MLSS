
#copy temp files into data import

copy_to_imports <- function(survey_levels,
                            tempDir,
                            dir_uploads,
                            dirLookUps){
  
  
  
  for(nivel in survey_levels){
    showNotification(paste("Saving", nivel, "data"), type = "message")
    
    rds_temp <- file.path(tempDir, glue("{nivel}.rds"))
    rds_final <- file.path(dir_uploads, glue("{nivel}.rds"))
    
    #save if not teacehr
    if(nivel !="teacher"){
      #print(rds_temp)
      file.copy(from = rds_temp, to = rds_final, overwrite = T)
      
    }
    
    #getch division and district from lookup school
    if(nivel == "teacher"){
      lkp_schools <- rio::import(file.path(dirLookUps, "schools.csv")) #look up of schools
      
      #fetch division and district
      temp_data <- rio::import(rds_temp)
      temp_data <- temp_data %>%
        left_join(lkp_schools, by = "school_id")
      
      rio::export(temp_data, rds_final)
      
    }
    
    
    
    
  }
  
  
}
