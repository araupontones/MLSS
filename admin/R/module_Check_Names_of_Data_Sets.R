#. check that user uploaded a file and confirm if she wants to proceed


checkNameFiles <- function(id, file_info, survey_levels){
  
  moduleServer(id, function(input, output, session){
 
    

    showNotification("Checking correct name of files", type = "warning")
    
    
    check_names <- eventReactive(file_info$tempfiles(),{
      
    check_name_of_uploads(user_files = file_info$tempfiles(),
                                           niveles = survey_levels)
      
    })
    
    observeEvent(check_names(),{
      
      #check that upload contains a file for student, teacher, school -------------
      
      shinyFeedback::feedbackDanger("upload", check_names()!="OK", "Check the name of the files")
    })
    
    
    observeEvent(check_names(),{
      
      req(check_names() != "OK")
        
        modal_error_names <- modalDialog(
          HTML(paste("<b>",check_names,"</b><br>", "Do not match with the names of expected files (school, teacher, and student).",
                     "<br><br> Please verify and upload again.")),
          title = "Error in file names",
          footer = tagList(
            actionButton("close_error_names", "Close", class = "btn btn-danger"),
            
          )
        )
        
        showModal(modal_error_names)
      
    })
   
    
   
    
    check_names

      
    })
    
    
    
    
    
    

  
}