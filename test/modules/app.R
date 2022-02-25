library(shiny)

ui <- fluidPage(
  uiSchool("school")
)

server <- function(input, output, session) {
  
  t <- outputForm('form')
  
  observeEvent(t$division(),{
    print(t$division())
    
  })
  serverSchool("school")
}

shinyApp(ui, server)