schoolUI <- function(id) {
  tagList(
    sidebarLayout(
      sidebarPanel(width = 3,
        numericInput(NS(id,"m"), "Tesst", 2, min = 1, max = 100)
      ),
      mainPanel(width = 7,
        plotOutput(NS(id,"hist"))
      )
    )
  )
}


schoolServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$hist <- renderPlot({
      means <- replicate(1e4, mean(runif(input$m)))
      hist(means, breaks = 20)
    }, res = 96)
    
  })
}