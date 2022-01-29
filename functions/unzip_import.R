#' function to import the data. Will take the zip file submited by the user and
#' will unzip it into data/imports/round
#' @param zipDir Directory of the zipped file 
#' @param round round of the data
#' @param importDir directory where data will be unzipped



unzip_import <- function(zipDir
                         ,round,
                         unzipDir,
                         num_files = 3,
                         ...){
  
  survey_levels <- c("school", "teacher", "student")
  
  
  
  #unzip into temp directory
  unzip(zipDir, overwrite = T, exdir = tempdir())
  # #move from temp to imports -------------------------------------------------
  # 
  # #list of zipped files in stata format
  temps_stata_files <- list.files(tempdir(), recursive = T, pattern = ".dta", full.names = T)
  # 
  #message(temps_stata_files)
  # #create directory for this round (this should be checked before running this protocol)
   exDir <- file.path(unzipDir, round)
   
   if(!exists(exDir)){
     
     dir.create(exDir)
   }
  # 
  # for(stata_file in temps_stata_files){
  #    
  #    #to assure that names are in lower case
  #    name_check <- str_to_lower(str_extract(stata_file, '[^\\/]+$'))
  #    
  # #   #copy and rename the file of each level (school, teacher, student)
  #    for(level in levels){
  #      
  #      if(str_detect(name_check, level)) {
  #        
  #        file.copy(stata_file, to = glue("{exDir}/{level}.dta"))
  #      }
  #      
  #      
  #      
  #      
  #      
  #    }
  #  }
  
}






