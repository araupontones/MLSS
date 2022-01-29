library(shiny)
library(stringr)
library(glue)
library(shinyFeedback) #only if validate is used

#to allow larger files from users
options(shiny.maxRequestSize = 10 * 1024^2)

#Useful vectors
rounds <- c("Baseline", "Midline", "Endline")
survey_levels <- c("school", "teacher", "student")

ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  #UI to import data
  selectInput("round", label = "Round of the data",choices = rounds),
  fileInput("upload", label = "Import zip file", accept = c(".zip")),
  actionButton("sendData", label = "Validate"),
  
  
  tableOutput("head")
)

server <- function(input, output, session) {
  
  
  observeEvent(input$upload, {
    
    #define location of uploads -----------------------------------------------
    dirImports <- 'data/imports'
    dirImportsROund <- file.path(dirImports, input$round)
    
    #check if the round has not been uploaded before --------------------------
    round_exists <- dir.exists(dirImportsROund)
    shinyFeedback::feedbackDanger("upload", exists, glue("Data for {input$round} has been uploaded already!"))
    req(!round_exists)
    
   
    #check that uploaded file is a zip file ----------------------------------- 
    ext <- tools::file_ext(input$upload$name)
    shinyFeedback::feedbackDanger("upload", ext !="zip", "The upload must be a zip file")
    req(ext == "zip")
    
    #unzip --------------------------------------------------------------------
    tempDir = tempdir()
    unzip(input$upload$datapath, overwrite = T, exdir = tempDir)
    temps_stata_files <- list.files(tempDir, recursive = T, pattern = ".dta", full.names = T)
    
    
    ##check that number of uploaded files is 3----------------------------------
    
    size_num <- length(temps_stata_files)
    shinyFeedback::feedbackDanger("upload", size_num!=3, "The zip file must conaint 3 files")
    req(size_num == 3)
    
    #check that upload contains a file for student, teacher, school -------------
    check_names <- check_name_of_uploads(user_files = temps_stata_files,
                                         niveles = c("school", "teacher", "student"))
    
    shinyFeedback::feedbackDanger("upload", check_names!="OK", paste(check_names))
    
    #if everything is OK --------------------------------------------------------
    req(check_names == "OK")
    dir.create(dirImportsROund)
    copy_unzip_to_imports(user_files = temps_stata_files,
                          niveles = c("school", "teacher", "student"),
                          exdir = dirImportsROund)
    
    
  })
  
  
  
  output$head <- renderTable({
    input$upload
   
  })
}

shinyApp(ui, server)