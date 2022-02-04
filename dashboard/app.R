library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(shinyFeedback) #only if validate is used

#extrafont::fonts()
# if(length(fonts()< 1)){
#   extrafont::loadfonts(device = 'win')
#   
# }


#extrafont::loadfonts(device = 'win')

project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path(dirData, "reference/lookups")

#load data
school_data <- rio::import(file.path(dirImports, "Baseline/school.rds"))
student_data <- rio::import(file.path(dirImports, "Baseline/student.rds"))


#load lookups
divisions_lkp <- rio::import(file.path(dirLookUps, "divisions.csv"))
districts_lkp <- rio::import(file.path(dirLookUps, "districts.csv"))




#vectors 
divisions_v <- c("Malawi",divisions_lkp[["division_nam"]])
rounds_v <- c("Baseline", "Midline", "Endline")
rounds_v <- unique(school_data$round)




ui <- navbarPage(
  "Dashboard",
  tabPanel("Schools",
           schoolUI("school",
                    nivel = "school",
                    dirLookUps = dirLookUps,
                    divisions = divisions_v
                    )
           
           ),
  
  tabPanel("Teachers"),
  tabPanel("Students",
           schoolUI("student",
                    nivel = "student",
                    dirLookUps = dirLookUps,
                    divisions = divisions_v
           ))
  
)


server <- function(input, output, session) {
 
  schoolServer("school", 
               nivel = "school",
               database = school_data,
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