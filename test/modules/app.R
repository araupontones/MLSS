library(shiny)
<<<<<<< HEAD

ui <- fluidPage(
  selectInput("var", "Variable", names(mtcars)),
  numericInput("bins", "bins", 10, min = 1),
  plotOutput("hist")
)
server <- function(input, output, session) {
  data <- reactive(mtcars[[input$var]])
  output$hist <- renderPlot({
    hist(data(), breaks = input$bins, main = input$var)
  }, res = 96)
}
=======
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(shinyjs)


#extrafont::loadfonts(device = 'win')

project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path(dirData, "/reference/lookups")
dirStyles <- file.path(project_path, "html/css")

print(dirData)

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
    database <- serverData(x, inputs, dirImports)
    
    plotServer(x, inputs, database)
    
    
    return(inputs)
  })
  
  names(inputs) <- niveles
  
  
#example to read output =======================================================  
  observeEvent(inputs$school$go(),{
    
    print(inputs$school$group_vars())
    print(inputs$school$plot_type())
    print(inputs$school$keep_divisions())
    print(inputs$school$by_other_var())
    print(inputs$school$x_var_plot()$x_lab)
    print(inputs$school$var_label())
    
    
  })
  

  

  
  }
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c

shinyApp(ui, server)