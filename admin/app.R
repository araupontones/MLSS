library(shiny)
library(stringr)
library(glue)
library(shinyFeedback) #only if validate is used
library(rio)
library(dplyr)
library(tidyr)
library(shinymanager)
library(rmarkdown)
#to allow larger files from users
options(shiny.maxRequestSize = 30 * 1024^2)

#load functions  
#gmdacr::load_functions("functions")


project_path <- define_project_dir(repoName="MLSS")

#define directory to store uploads from user
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData,'imports')


#define directory of reference data
dirReference <- file.path(dirData,'reference')
dirLookUps <- file.path(dirReference,"lookups")

#Useful vectors
rounds <- c("Round 1", "Round 2", "Round 3", "Round 4", "Round 5", "Round 6")
survey_levels <- c("school", "teacher", "student")





#UI ---------------------------------------------------------------------------
ui <- fluidPage(
  
  
  uiHead('header'),
  
  
  uiForm('form'),
  
  #Table to inform the users of the existing files
  uiOutput(outputId = "head_summary"),
  tableOutput("table_summary"),
  
 #logos and footer banner
   uiFooter("footer")
 
  
  
)


#secure the app
ui <- uiLogin(ui)


#Server ------------------------------------------------------------------------
server <- function(input, output, session) {
  
  #check credentials of user
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )
  

  #Add brains to the form (enable rounds and button)
  enablingConditionsForm("form", rounds)
  inputs <- inputsForm("form")
  
  
  #check if data exists (outputs: message, replace, create, dir_uploads)
  confirmDirs <- confirmDirsExist('form', inputs,dirImports )
  #ask user if want to continue with the upload (outputs: input$cancel and input$ok)
  validateForm('form', inputs, rounds, confirmDirs)
 
  
  
  observeEvent(confirmDirs$dir_uploads(),{

    print(confirmDirs$dir_uploads())
  })
  
  
  
  #stop uploading if user cancels confirmation*********************************
  observeEvent(input$cancel, {
    removeModal()
  })
  
  
  #Upload data if user confirms
  observeEvent(input$ok, {
    removeModal()
    
    #check that files in .zip are 3 (output: file_num, tempfiles, temDir)-------
    file_info <- countZipFiles('form', inputs)
    
    observeEvent(file_info$tempDir(),{

      print(file_info$tempDir())
    })

    
    req(file_info$file_num() == 3)
    
    #check name of files (school, student, teacher)-----------------------------
    files_ok <- checkNameFiles('form', file_info, survey_levels)
    
    req(files_ok() == "OK")
    
    #check variable names output(vars_school, teacher_vars, student_vars)------
    vars_ok <- checkVarNames('form', file_info, dirLookUps)
    
    
    req(vars_ok$student_vars() == "OK")
    
    
    
    #save and append data ------------------------------------------------------
    save_data <-saveData("form", confirmDirs, vars_ok, inputs, survey_levels, dirLookUps)
    
    observeEvent(save_data(), {
      
      print(save_data())
    })
    
    req(!is.null(save_data()))
    
    showNotification(paste("Appending rounds"), type = "message", duration = 10)
    
    append_rounds <- lapply(survey_levels, append_versions, dir_imports = dirImports, dir_lkps = dirLookUps)
    
    #say thanks to the user
    req(!is.null(append_rounds))
    
    
    #create table for districts -----------------------------------------------
    
    table_districts <- create_district_table (dir_lks = dirLookUps,
                           dir_imports = dirImports,
                           exfile_districts = "district.rds")
    
    
    showNotification(paste("Creating table for ditricts"), type = "message", duration = 15)
    
    req(!is.null(table_districts))
    
    modal_success <- modalDialog(
      HTML(paste("Data has been updated succesfully!")),
      title = "Thank you!",
      footer = tagList(
        actionButton("close_success", "Ok", class = "btn btn-success"),
        
      )
    )
    
    showModal(modal_success)
    
    
    
  })
  
  
  
  
  
  
  
  
  #close error messages -------------------------------------------------------
  observeEvent(input$close_error_names,{
    removeModal()
  })
  
  observeEvent(input$close_error_num_files,{
    removeModal()
  })
  
  
  observeEvent(input$close_error_school_names,{
    removeModal()
  })
  
  observeEvent(input$close_error_teacher_names,{
    removeModal()
  })
  
  observeEvent(input$close_error_student_names,{
    removeModal()
  })
  
  observeEvent(input$close_success,{
    removeModal()
    
  })
  
  
  #temp outputs to check-------------------------------------------------------
  
  #data to show users wich files have been uploaded
  data_summary_files <- reactive({
    req(input$close_success)
    create_summary_files(dirImports)
    
  })
  
  output$head_summary <- renderUI({
    req(input$close_success)
    
    HTML(paste("<hr>",
               "<h3> Summary and dates of uploaded files </h3>"))
    
    
  })
  
  output$table_summary <- renderTable({
    
    data_summary_files()
    
  })
}

shinyApp(ui, server)