library(shiny)

ui <- fluidPage(
  uiSchool("school")
)

server <- function(input, output, session) {
  
  #t <- outputForm('form')
  
 
  serverSchool("school")
}

shinyApp(ui, server)