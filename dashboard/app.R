library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(shinyFeedback) #only if validate is used
library(glue)

#print(extrafont::fonts())
#extrafont::loadfonts(device = 'win')


project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path(dirData, "reference/lookups")
dirStyles <- file.path(project_path, "html/css")

#load data
school_data <- rio::import(file.path(dirImports, "school.rds"))
student_data <- rio::import(file.path(dirImports, "student.rds"))
teacher_data <- rio::import(file.path(dirImports, "teacher.rds"))


#load lookups
divisions_lkp <- rio::import(file.path(dirLookUps, "divisions.csv"))
districts_lkp <- rio::import(file.path(dirLookUps, "districts.csv"))




#vectors 
divisions_v <- c("Malawi",divisions_lkp[["division_nam"]])
rounds_v <- c("Baseline", "Midline", "Endline")
rounds_v <- unique(school_data$round)




ui <- fluidPage(
    
  tags$head(
    #fonts -------------------------------------------------
  
      tags$link(rel="preconnect", href="https://fonts.googleapis.com"),
      tags$link(href="https://fonts.googleapis.com/css2?family=Noto+Serif&family=Roboto:wght@300&display=swap", rel="stylesheet"),
    tags$link( href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;700&display=swap", rel="stylesheet"),
    tags$title("MLSS-Dashboard"),
    
    #styles -----------------------------------------------
    tags$link(rel="stylesheet", href="styleDash.css")
    ),
  
    navbarPage(
      
      tags$a("Malawi Longitudinal School Survey", href = "http://198.211.96.106/", target = "_blank",class = 'brand'),
      collapsible = T,
      fluid = T,
      tabPanel("Schools",
               schoolUI("school",
                        nivel = "school",
                        dirLookUps = dirLookUps,
                        divisions = divisions_v,
                        rounds = rounds_v
                        
               )
               
      ),
      
      tabPanel("Teachers",
               schoolUI("teacher",
                        nivel = "teacher",
                        dirLookUps = dirLookUps,
                        divisions = divisions_v,
                        rounds = rounds_v
                        
               )
               ),
      tabPanel("Students",
               schoolUI("student",
                        nivel = "student",
                        dirLookUps = dirLookUps,
                        divisions = divisions_v,
                        rounds = rounds_v
                        
               )
               )
      
    )
  )



server <- function(input, output, session) {
  
  schoolServer("school", 
               nivel = "school",
               database = school_data,
               dirLookUps = dirLookUps,
               divisions = divisions_v,
               rounds = rounds_v)
  
  schoolServer("teacher", 
               nivel = "teacher",
               database = teacher_data,
               dirLookUps = dirLookUps,
               divisions = divisions_v,
               rounds = rounds_v)
  
  
  schoolServer("student", 
               nivel = "student",
               database = student_data,
               dirLookUps = dirLookUps,
               divisions = divisions_v,
               rounds = rounds_v)
}

shinyApp(ui, server)