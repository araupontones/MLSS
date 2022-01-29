#'function to check that the names of the uploaded files are correct
#'(that they include the names school, teacher, student)
#'@param user_files a vector with the files contained by the user's zip file
#'@param niveles a vector with the names to check c(school, teacher, student)

check_name_of_uploads <- function(user_files = uploaded_files,
                                  niveles = survey_levels){
  
  #check if the uploaded files contain school, teacher, or student
  check <- sapply(user_files, function(f){
    any(str_detect(f, niveles))
    
  })
  
  
  #this means that at least one file does not match with the survey levels
  if(any(!check)){
    wrong_files <- paste(fles[!check], collapse = " and ")
    return(wrong_files)
  } else{
    #the files are named correctly!
    return("OK")
  }
  
  
}