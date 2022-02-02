library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

extrafont::loadfonts(device = 'win')
project_path <- define_project_dir(repoName="MLSS")
dirData <- file.path(project_path, "data")
dirImports <- file.path(dirData, "imports")
dirLookUps <- file.path(dirData, "reference/lookups")

ui <- navbarPage(
  "Dashboard",
  tabPanel("Schools",
           schoolUI("school", dirImports = dirImports, dirLookUps = dirLookUps)),
  
  tabPanel("Teachers"),
  tabPanel("Students")
  
)


server <- function(input, output, session) {
 
  schoolServer("school", dirImports =dirImports, dirLookUps = dirLookUps )
}

shinyApp(ui, server)