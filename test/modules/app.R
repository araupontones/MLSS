library(shiny)


ui <- fluidPage(
  
  uiForm("test")
)

server <- function(input, output, session) {
  
   inputs <- outputForm("test")

   observeEvent(inputs$division(),{
      print(inputs$division())

     })
  # 
  # serverTest("test", inputs$andres)
}

shinyApp(ui, server)