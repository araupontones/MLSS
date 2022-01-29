#'To copy uploaded unzipped files into their rounds folder
#'It renmaes the files consistently (school.dta, student.dta, teacher.dta)
#'@param user_files list of dta files uplaoded by the user
#'@param niveles Niveles to rename the data (school, student, teacher)
#'@param exdir directory to store the data

copy_unzip_to_imports <- function(user_files,
                                  niveles,
                                  exdir){
  for(dta in user_files){
    
    for(nivel in niveles){
      
      if(str_detect(dta, nivel)){
        
        file.copy(dta, to= file.path(exdir,paste0(nivel, ".dta")))
      }
    }
  }
  
}

