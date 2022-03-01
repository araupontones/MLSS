#Module form

uiForm <- function(id){
  
  tagList(
    
    tags$div(class = 'row container-form',
             # authentication module
             
             #UI to import data
             fileInput(NS(id,"upload"), label = "Upload  a .zip file with the data", accept = c(".zip")),
             #Input select of round
             uiOutput(NS(id,"select_round")),
             
             #Button to validate
             uiOutput(NS(id,"validate_button"))
             
             
    )
  )
    
    
  
  
}


enablingConditionsForm <- function(id, rounds){
  
  moduleServer(id, function(input, output, session){
    
    output$select_round <- renderUI({
      req(input$upload)
      selectInput(NS(id,"round"), label = "Select The Round Of The Upload",choices = c("",rounds))
      
    })
    
    output$validate_button <- renderUI({
      req(input$upload, input$round)
      
      actionButton(NS(id,"sendData"), label = "Verify data", class="btn btn-primary")
      
      
    })
    
    
  })}


# Oututs from form--------------------------------------------------------------

inputsForm <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    list(
      
      round = reactive({input$round}),
      sendData = reactive({input$sendData}),
      upload = reactive(input$upload)
    )
    
  })}
