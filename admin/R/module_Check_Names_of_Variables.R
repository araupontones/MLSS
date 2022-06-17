#. check that user uploaded a file and confirm if she wants to proceed


checkVarNames <- function(id, file_info, dirLookUps){
  
  moduleServer(id, function(input, output, session){
 
    
#school data ------------------------------------------------------------------
    vars_school <- eventReactive(file_info$tempfiles(),{
      
      #print(file_info$tempfiles())
      check_var_names(
        dir_lookups = dirLookUps,
        tempfiles = file_info$tempfiles(), 
        nivel = "school"
      )
      
      
    })
    
    
    observeEvent(vars_school(),{
      
      req(vars_school() != "OK")
      modal_error_school_names <- create_dialog_vars(error_vars = vars_school(),
                                                     id_button = "close_error_school_names",
                                                     nivel = "school")
      
      showModal(modal_error_school_names)
      shinyFeedback::feedbackDanger("upload", vars_school()!="OK", "Check variable names of school file")
      
    })
  
    

#teacher vars ------------------------------------------------------------------
    
    observeEvent(vars_school(),{
      
      req(vars_school()=="OK")
      
      showNotification("Verifying names of teacher file", type = "warning")
    })
    
    
    teacher_vars <- eventReactive(vars_school(),{
      
      req(vars_school()=="OK")
      
      check_var_names(
        dir_lookups = dirLookUps,
        tempfiles = file_info$tempfiles(), 
        nivel = "teacher"
      )
      })
    
    observeEvent(teacher_vars(),{
      
      req(teacher_vars() != "OK")
      modal_error_teacher_names <- create_dialog_vars(error_vars = teacher_vars(),
                                                     id_button = "close_error_teacher_names",
                                                     nivel = "teacher")
      
      showModal(modal_error_teacher_names)
      shinyFeedback::feedbackDanger("upload", teacher_vars()!="OK", "Check variable names of teacher file")
      
    })
    

    
#student vars ------------------------------------------------------------------
    
    observeEvent(teacher_vars(),{
      
      req(teacher_vars()=="OK")
      
      showNotification("Verifying names of school file", type = "warning")
    })
    
    
    student_vars <- eventReactive(teacher_vars(),{
      
      req(teacher_vars()=="OK")
      
      check_var_names(
        dir_lookups = dirLookUps,
        tempfiles = file_info$tempfiles(), 
        nivel = "student"
      )
    })
    
    observeEvent(student_vars(),{
      
      req(student_vars() != "OK")
      modal_error_student_names <- create_dialog_vars(error_vars = student_vars(),
                                                      id_button = "close_error_student_names",
                                                      nivel = "student")
      
      showModal(modal_error_student_names)
      shinyFeedback::feedbackDanger("upload", student_vars()!="OK", "Check variable names of student file")
      
    })
    
 
    
    
  
    
    
    list(
      
      vars_school = vars_school,
      teacher_vars = teacher_vars,
      student_vars = student_vars
    )
   
    
   
    
    

      
    })
    
    
    
    
    
    

  
}