#example to validate

library(shiny)
library(shinyFeedback) #only if validate is used


ui <- fluidPage(
  shinyFeedback::useShinyFeedback(),
  numericInput("n", "number", value = 10),
  textOutput('half')
)

server <- function(input, output, session) {
  
  half <- reactive({
    even <- input$n %% 2 == 0
    shinyFeedback::feedbackWarning("n", !even, "the number is not even")
    req(even)
    input$n/2
    
  })
  
  output$half <- renderText({
    
    half()
  })
  
  
}

shinyApp(ui, server)