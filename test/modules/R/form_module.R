uiForm <- function(id, compare_codes, rondas,dirLookUps,nivel, divisions){
  
  #print(file.path(dirLookUps, id, glue::glue("dropdown_vars_{id}.csv")))
  dropdowns_v <- rio::import(file.path(dirLookUps, id, glue::glue("dropdown_vars_{id}.csv")))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  
  tagList(
    
    selectInput(NS(id,"indicator"), paste(id, "Indicator"), choices = var_codes),
    
    selectInput(NS(id,"division"), "Division", choices = c("Malawi", "div 1")),
    
    uiOutput(NS(id,"compareVars")),
    
    radioButtons(NS(id,"display"), label = "Display",choices = c("Across time","With other divisions")),
    
    
    selectInput(NS(id,"round"), "Round", choices = c("Baseline"), multiple = T, selected = "Baseline"),
    
    selectInput(NS(id,"plot_type"), "Plot Type", choices =  c("Bar Plot","Box Plot", "Density Plot"))
    
    
    
  )
  
  
}


#===============================================================================


outputForm <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    
    list(
      division = reactive({input$division}),
      display = reactive(input$display),
      round = reactive(input$round),
      plot_type = reactive(input$plot_type)
      
    )
    
    
    
    
    
    
    
  })
}

#inputs is the output of outputForm
serverForm <-  function(id, inputs) {
  moduleServer(id, function(input, output, session) {
    
    
    observeEvent(inputs$division(), {
      
      if(inputs$division() == "Malawi"){
        
        updateRadioButtons(session, "display", choices = c("Across time","With other divisions"))
      }
      
      
      if(inputs$division()!= "Malawi"){
        
        updateRadioButtons(session, "display", choices = c("Across time","With other divisions", "Districts within"))
      }
      
    })
    
  })
}




# 
# uiTest <- function(id){
#   
#   tagList(
#     
#     selectInput(NS(id,"andres"),"Andres", choices = c("a", "b")),
#     selectInput(NS(id,"selector"),"Select this", choices = "Select")
#   )
#   
# }
# 
# 
# 
# outputTest <- function(id){
#   
#   moduleServer(id, function(input, output, session){
#     
#     
#     list(
#       
#       andres = reactive(input$andres),
#       selector = reactive(input$selector)
#     )
#     
#   
#   
#   
# })
# }
# 
# serverTest <- function(id, selected_andres){
#   
#   moduleServer(id, function(input, output, session){
#     
# 
#    observeEvent(selected_andres(),{
#      
#      if(selected_andres() == "b"){
#        
#        updateSelectInput(session,"selector", "Selecciona", c("I am a B"))
#      }
#      if(selected_andres() == "a"){
#        
#        updateSelectInput(session,"selector", "Selecciona", c("I am a A"))
#      }
#      
#    })
#       
#       


#} )



#}