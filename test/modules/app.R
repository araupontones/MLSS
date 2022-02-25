library(shiny)
library(dplyr)
library(tidyr)

project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path("C:/repositaries/1.work/MLSS/data/reference/lookups")
dirStyles <- file.path(project_path, "html/css")


ui <- fluidPage(
  
  uiLinks("links"),
  navbarPage(
    "MLSS",
    
    #the id of each level is used to defined the 
    tabPanel("Schools",
             uiSchool("school",
                      dirLookUps)
             ),
    tabPanel("Teacher",
             uiSchool("teacher",
                      dirLookUps)
             ),
    tabPanel("Students",
             uiSchool("student",
                      dirLookUps)
             )
  ),
  
 
)

server <- function(input, output, session) {
  #dirLookUps <- file.path("C:/repositaries/1.work/MLSS/data/reference/lookups")
  
#attach brain to forms =======================================================
  niveles <- c("school", "teacher", "student")
  
  inputs <- lapply(niveles, function(x){
    inputs<- outputForm(x, dirLookUps)
    
    serverForm(x, inputs,dirLookUps)
    
    return(inputs)
  })
  
  names(inputs) <- niveles
  
  
#example to read output =======================================================  
  observeEvent(inputs$school$indicator(),{
    
    print(inputs$school$binary_indicator())
    
  })
  

  

  
  }

shinyApp(ui, server)