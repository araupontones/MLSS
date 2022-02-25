library(shiny)

project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path("C:/repositaries/1.work/MLSS/data/reference/lookups")
dirStyles <- file.path(project_path, "html/css")


ui <- fluidPage(
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
  
#attach brain to forms =======================================================
  niveles <- c("school", "teacher", "student")
  
  inputs <- lapply(niveles, function(x){
    inputs<- outputForm(x)
    
    serverForm(x, inputs)
    
    return(inputs)
  })
  
  names(inputs) <- niveles
  
  
#example to read output =======================================================  
  observeEvent(inputs$school$division(),{
    
    print(inputs$school$division())
    
  })
  

  

  
  }

shinyApp(ui, server)