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
options(shiny.maxRequestSize = 10 * 1024^2)

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
rounds <- c("Baseline", "Midline", "Endline")
survey_levels <- c("school", "teacher", "student")


# define some credentials
credentials <- data.frame(
  user = c("shiny", "shinymanager", "admin"), # mandatory
  password = c("shiny", "12345", "admin"), # mandatory
  #start = c("2019-04-15"), # optinal (all others)
  #expire = c(NA, "2019-12-31"),
  admin = c(FALSE, TRUE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)


#UI ---------------------------------------------------------------------------
ui <- fluidPage(
  #enable shiny feedbacks
  tags$head(
      tags$link(rel = 'stylesheet', href = 'styleAdmin.css')
  ),
  shinyFeedback::useShinyFeedback(),
  
  tags$div(class = 'row container-nav',
           tags$div(class = 'col-4',
                    
                    tags$ul(
                      tags$li(tags$a("Home", href = "http://198.211.96.106") ,class = 'item'),
                      tags$li(tags$a("Background"),href = "http://198.211.96.106/about.html", class = 'item'),
                      tags$li(tags$a("Dashboard"), href = "http://198.211.96.106:3838/MLSS/dashboard/",class = 'item')
                      
                    )
                    
           )
           
  ),
  
  tags$a(href = "admin-guide.rmd", "Admin guide", target = "_blank"),
  
  tags$div(class = 'row container-form',
           # authentication module
           
           #UI to import data
           fileInput("upload", label = "Upload  a .zip file with the data", accept = c(".zip")),
           #Input select of round
           uiOutput(outputId = "select_round"),
           
           #Button to validate
           uiOutput(outputId = "validate_button")
           
           
  ),
  #Table to inform the users of the existing files
  uiOutput(outputId = "head_summary"),
  
  tableOutput("table_summary"),
  
  #logos
  
  tags$div(class = 'row container-logos text-center',
          
                    tags$img(src="imgs/malawi-logo.jpeg", class = "logo" ),
          
          
                    tags$img(src="imgs/wb-logo.svg", class = "logo logo-wb" )
           
  ),
  
  tags$div(class = 'row container-footer',
           tags$p(class = 'admin_text',
                 "For any question, please contact",
                 tags$a(href="mailto:someone@example.com?Subject=Shiny%20aManager", 
                        "administrator", target ="_top" )
                 )
           )
  
  
)


#secure the app
ui <- secure_app(ui,
                 # add image on top ?
                 tags_top = 
                   tags$div(
                     tags$h4("MLSS Dashboard", style = "align:center"),
                     tags$img(
                       src = "https://1000marcas.net/wp-content/uploads/2020/07/the-world-bank.jpg", width = 100
                     )
                   ),
                 tags_bottom = tags$div(
                   tags$p(
                     "For any question, please  contact ",
                     tags$a(
                       href = "mailto:someone@example.com?Subject=Shiny%20aManager",
                       target="_top", "administrator"
                     )
                   )
                 ))

#Server ------------------------------------------------------------------------
server <- function(input, output, session) {
  
  
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )
  
  #User inputs (validate button and select round) ------------------------------
  
  output$select_round <- renderUI({
    req(input$upload)
    selectInput("round", label = "Select The Round Of The Upload",choices = c("",rounds))
    
  })
  
  output$validate_button <- renderUI({
    req(input$upload, input$round)
    
    actionButton("sendData", label = "Verify data", class="btn btn-primary")
    
    
  })
  
  
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
    
    #check that user has selected a round 
    check_selected_round <- input$round %in% rounds
    shinyFeedback::feedbackDanger("round", !check_selected_round, "Select the round of the upload")
    
    req(check_selected_round)    
    
    #Confirm with user if wants to proceed (defined in text_message round)
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
    temps_stata_files <- return_uploaded_files(from =input$upload$datapath , to = tempDir)
    
    
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
                                          dir_lookups =  dirLookUps,
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
                                           dir_lookups =  dirLookUps,
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
                                           dir_lookups =  dirLookUps,
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
    
    #copy temp files to imports
    copy_to_imports(survey_levels = survey_levels,
                    tempDir = tempDir,
                    dir_uploads = dir_uploads(),
                    dirLookUps = dirLookUps)
    
    #Append versions
    showNotification(paste("Appending rounds"), type = "message")
    append_rounds <- lapply(survey_levels, append_versions, dir_imports = dirImports)
    
    #say thanks to the user
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