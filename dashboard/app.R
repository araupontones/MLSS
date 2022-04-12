library(shiny)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(shinyjs)
library(reactable) 
library(reactablefmtr)
library(glue)


#extrafont::loadfonts(device = 'win')

project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path(dirData, "reference/lookups")
dirStyles <- file.path(project_path, "html/css")


school_data <- rio::import(file.path(dirImports, "school.rds"))
choices_division <- sort(unique(school_data$division_nam))


ui <- fluidPage(
   uiLinks("links"),
  navbarPage(id = "tabs",
    
    tags$a("Malawi Public School Survey", href = "http://198.211.96.106/", target = "_blank",class = 'brand'),
    collapsible = T,
    
    #the id of each level is used to defined the 
    tabPanel("Schools",
             value = 'school',
             uiTemplate("school",
                      dirLookUps,
                      dirImports)
             ),
    tabPanel("Teachers",
             value = "teacher",
             uiTemplate("teacher",
                      dirLookUps,
                      dirImports)
             ),
    tabPanel("Students",
             value = "student",
             uiTemplate("student",
                      dirLookUps,
                      dirImports)
             ),
    tabPanel("Key MESIP Districts",
             value = "district",
             uiDistricts("district",
                         choices_divisions_mesip))
  ),
  
 
)

server <- function(input, output, session) {
  #dirLookUps <- file.path("C:/repositaries/1.work/MLSS/data/reference/lookups")
  
#attach brain to forms =======================================================
  niveles <- c("school", "teacher", "student")
  
  inputs <- lapply(niveles, function(x){
    
    #run only when tab is selected
    observe({
      
      if(input$tabs == x){
        
        #catch inputs of user
        inputs<- outputForm(x, dirLookUps)
        
        #reactive form
        serverForm(x, inputs,dirLookUps)
        
        serverHeader(x, inputs)    
        
        #reactive data
        database <- serverData(x, inputs, dirImports)
        
        
        plotServer(x, inputs, database)
        
        
        return(inputs)
        
        
      }
  
      
    })
    
    
   
    
  })
  
  names(inputs) <- niveles
  
  
#example to read output =======================================================  
  # observeEvent(inputs$school$go(),{
  #   
  #   print(paste("Group by:",inputs$school$group_vars()))
  #   print(inputs$school$display())
  #   print(paste("keep:",inputs$school$keep_divisions()))
  #   # print(inputs$school$plot_type())
  #   # print(inputs$school$keep_divisions())
  #   # print(inputs$school$by_other_var())
  #   # print(inputs$school$x_var_plot()$x_lab)
  #   # print(inputs$school$var_label())
  #   
  #   
  # })
  
#run district server only when selected
  observe({
   
    if(input$tabs == "district"){
      
      serverDistricts("district", dirImports, dirLookUps)
      
    }
    
    
  })
  
  
 

  
  }

shinyApp(ui, server)