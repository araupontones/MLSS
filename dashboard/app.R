library(shiny)

project_path <- define_project_dir(repoName="MLSS")

ui <- navbarPage(
  "Dashboard",
  tabPanel("Schools",
           schoolUI("school")),
  
  tabPanel("Teachers"),
  tabPanel("Students")
  
)


server <- function(input, output, session) {
 
  schoolServer("school")
}

shinyApp(ui, server)