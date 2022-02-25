library(shiny)

uiSchool <- function(id){
  
  tagList(
    uiForm("test")
  )
  
}


serverSchool <-  function(id, inputs) {
  moduleServer(id, function(input, output, session) {
  
    inputs <- outputForm("test")
    
    observeEvent(inputs$division(),{
      print(inputs$division())
      
    })
    # 
    serverForm("test", inputs)
    
    })
  
}




