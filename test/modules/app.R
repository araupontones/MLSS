library(shiny)
library(dplyr)
library(tidyr)
library(stringr)

project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path("C:/repositaries/1.work/MLSS/data/imports")
dirLookUps <- file.path("C:/repositaries/1.work/MLSS/data/reference/lookups")
dirStyles <- file.path(project_path, "html/css")


school_data <- rio::import(file.path(dirImports, "school.rds"))
teacher_data <- rio::import(file.path(dirImports, "teacher.rds"))
student_data <- rio::import(file.path(dirImports, "student.rds"))



ui <- fluidPage(
  
  uiLinks("links"),
  navbarPage(
    "MLSS",
    
    #the id of each level is used to defined the 
    tabPanel("Schools",
             uiTemplate("school",
                      dirLookUps,
                      school_data)
             ),
    tabPanel("Teacher",
             uiTemplate("teacher",
                      dirLookUps,
                      teacher_data)
             ),
    tabPanel("Students",
             uiTemplate("student",
                      dirLookUps,
                      student_data)
             )
  ),
  
 
)

server <- function(input, output, session) {
  #dirLookUps <- file.path("C:/repositaries/1.work/MLSS/data/reference/lookups")
  
#attach brain to forms =======================================================
  niveles <- c("school", "teacher", "student")
  
  inputs <- lapply(niveles, function(x){
    
    #catch inputs of user
    inputs<- outputForm(x, dirLookUps)
    
    #reactive form
    serverForm(x, inputs,dirLookUps)
    #reactive data
    data <- serverData(x, inputs, dirImports)
    
    
    return(inputs)
  })
  
  names(inputs) <- niveles
  
  
#example to read output =======================================================  
  observeEvent(inputs$school$go(),{
    
    print(inputs$school$group_vars())
    print(inputs$school$plot_type())
    print(inputs$school$keep_divisions())
    print(inputs$school$by_other_var())
    
    
    
  })
  

  

  
  }

shinyApp(ui, server)