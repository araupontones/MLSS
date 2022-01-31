library(shiny)
library(stringr)
library(glue)
library(shinyFeedback) #only if validate is used
library(rio)
library(dplyr)
library(tidyr)

#to allow larger files from users
options(shiny.maxRequestSize = 10 * 1024^2)

#load functions  
gmdacr::load_functions("functions")

#define directory to store uploads from user
dirImports <- 'data/imports'

#define directory of reference data
dirReference <- "data/reference"

#Useful vectors
rounds <- c("Baseline", "Midline", "Endline")
survey_levels <- c("school", "teacher", "student")


#UI ---------------------------------------------------------------------------
ui <- fluidPage(
  #enable shiny feedbacks
  shinyFeedback::useShinyFeedback(),
  
  #UI to import data
  fileInput("upload", label = "Import .zip file", accept = c(".zip")),
  selectInput("round", label = "Round of the data",choices = rounds),
  
  actionButton("sendData", label = "Upload data", class="btn btn-success"),
  
  #temp: to check what has been uploaded by user
  tableOutput("head")
)


#Server ------------------------------------------------------------------------
server <- function(input, output, session) {
  
  
  #Server to import data --------------------------------------------------------
  
  #1. define directory to store uploads based on input round
  dir_uploads <- reactive({
    req(input$round)
    file.path(dirImports, input$round)
  })
  
  #2. Define message to tell user what round of data is that she uploading
  text_message_round <- reactive({
    
    req(input$sendData, input$round)
    #check if round exists in imports
    existe <-  dir.exists(dir_uploads())
    
    
    #get time of last modification
    if(existe){
      exists_and_files <- length(list.files(dir_uploads())) > 0 #if there's data stored
      info_file <- file.info(dir_uploads())
      date_file <- format(info_file$atime[1], "%B %d %Y at %H:%M") 
      
    } else {
      
      exists_and_files <- FALSE
    }
    
    #define message to confirm with the user
    ifelse(existe & exists_and_files,
           paste("Data for", input$round, "was uploaded on",date_file ,"<br><br><b>Do you want to replace it?</b>"),
           paste("Uploading data for", input$round, "<br><br><b>Do you want to continue?</b>")
    )
    
    
    
    
  })
  
  
  
  #3. check that user uploaded a file and confirm if she wants to proceed
  observeEvent(input$sendData,{
    
    #check that a file has been uploaded
    files_sent <- length(input$upload)
    
    shinyFeedback::feedbackDanger("upload", files_sent == 0, "Upload a file")
    
    
    req(input$upload)
    
    #Confirm with user if wants to proceed
    modal_confirm <- modalDialog(
      HTML(text_message_round()),
      title = paste("Uploading data from", input$round),
      footer = tagList(
        actionButton("ok", "Upload", class = "btn btn-primary"),
        actionButton("cancel", "Cancel", class = "btn btn-danger")
      )
    )
    
    showModal(modal_confirm)
  })
  
  
  
  #4. stop uploading if user cancels confirmation
  observeEvent(input$cancel, {
    removeModal()
  })
  
  #5. Continue if user says OK to confirmation message
  observeEvent(input$ok, {
    removeModal()
    
    req(input$sendData)
    showNotification("Checking format of upload", type = "warning")
    #check that uploaded file is a zip file -----------------------------------
    ext <- tools::file_ext(input$upload$name)
    shinyFeedback::feedbackDanger("upload", ext !="zip", "The upload must be a zip file. Please verify")
    req(ext == "zip")
    
    #unzip --------------------------------------------------------------------
    showNotification("Reading uploaded files", type = "warning")
    
    #delete previous stata files
    tempDir = tempdir()
    for(file in list.files(tempDir, full.names = T, pattern = ".dta", recursive = T)){
  
      unlink(file)
    }
    
    
    
    unzip(input$upload$datapath, overwrite = T, exdir = tempDir)
    temps_stata_files <- list.files(tempDir, recursive = T, pattern = ".dta", full.names = T)
    
    print(temps_stata_files)
    ##check that number of uploaded files is 3----------------------------------
    
    size_num <- length(temps_stata_files)
    shinyFeedback::feedbackDanger("upload", size_num!=3, "The zip file must conaint 3 files")
    
    
    if(size_num != 3){
      
      modal_error_number_files <- modalDialog(
        HTML(paste("<b>",size_num,"</b> files have been uploaded.", 
                   "But 3 files are expected (school, teacher, and student).",
                   "<br><br> Please verify and upload again.")),
        title = "Error in file names",
        footer = tagList(
          actionButton("close_error_num_files", "Close", class = "btn btn-danger"),
          
        )
      )
      
      showModal(modal_error_number_files)
      
      
      
    }
    
    req(size_num == 3)
    showNotification("Checking correct name of files", type = "warning")
    
    #check that upload contains a file for student, teacher, school -------------
    check_names <- check_name_of_uploads(user_files = temps_stata_files,
                                         niveles = survey_levels)
    shinyFeedback::feedbackDanger("upload", check_names!="OK", "Check the name of the files")
    
    if(check_names != "OK"){
      
      modal_error_names <- modalDialog(
        HTML(paste("<b>",check_names,"</b><br>", "Do not match with the names of expected files (school, teacher, and student).",
                   "<br><br> Please verify and upload again.")),
        title = "Error in file names",
        footer = tagList(
          actionButton("close_error_names", "Close", class = "btn btn-danger"),
          
        )
      )
      
      showModal(modal_error_names)
      
      
      
    }
    
    
    
    #if everything is OK --------------------------------------------------------
    req(check_names == "OK")
    showNotification("Copying uploads into server", type = "warning")
    
    if(!dir.exists(dir_uploads())){
      dir.create(dir_uploads())
    }
    
    copy_unzip_to_imports(user_files = temps_stata_files,
                          niveles = c("school", "teacher", "student"),
                          exdir = dir_uploads())
    
    
    #check if variable names are ok ---------------------------------------
    
    showNotification("Verifying names of school file", type = "warning")
    check_names_school <- check_var_names(dir_imports = dir_uploads(),
                                          dir_reference = dirReference,
                                          dir_tempo = tempDir,
                                          nivel = "school")
    
    
    if(check_names_school != "OK"){
      
      
      modal_error_school_names <- create_dialog_vars(error_vars = check_names_school,
                                                     id_button = "close_error_school_names",
                                                     nivel = "school")
      
      showModal(modal_error_school_names)
      shinyFeedback::feedbackDanger("upload", check_names_school!="OK", "Check variable names of school file")
      
    }
    
    
    req(check_names_school == "OK")
    
    #teacher
    showNotification("Verifying names of teacher file", type = "warning")
    check_names_teacher <- check_var_names(dir_imports = dir_uploads(),
                                          dir_reference = dirReference,
                                          dir_tempo = tempDir,
                                          nivel = "teacher")
    
    
    if(check_names_teacher != "OK"){
      
      
      modal_error_teacher_names <- create_dialog_vars(error_vars = check_names_teacher,
                                                     id_button = "close_error_teacher_names",
                                                     nivel = "teacher")
      
      showModal(modal_error_teacher_names)
      shinyFeedback::feedbackDanger("upload", check_names_teacher!="OK", "Check variable names of teacher file")
      
    }
    
    
    req(check_names_teacher == "OK")
    
    #student
    
    showNotification("Verifying names of student file", type = "warning")
    check_names_student <- check_var_names(dir_imports = dir_uploads(),
                                           dir_reference = dirReference,
                                           dir_tempo = tempDir,
                                           nivel = "student")
    
    
    if(check_names_student != "OK"){
      
      
      modal_error_student_names <- create_dialog_vars(error_vars = check_names_student,
                                                      id_button = "close_error_student_names",
                                                      nivel = "student")
      
      showModal(modal_error_student_names)
      shinyFeedback::feedbackDanger("upload", check_names_student!="OK", "Check variable names of student file")
      
    }
    
    
    #save data if everything OK
    req(check_names_student == "OK")
    
    
    for(nivel in survey_levels){
      showNotification(paste("Saving", nivel, "data"), type = "message")
      
      rds_temp <- file.path(tempDir, glue("{nivel}.rds"))
      rds_final <- file.path(dir_uploads(), glue("{nivel}.rds"))
      
      #print(rds_temp)
      file.copy(from = rds_temp, to = rds_final, overwrite = T)
      
    }
    
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
  output$head <- renderTable({
    input$upload
    
  })
}

shinyApp(ui, server)