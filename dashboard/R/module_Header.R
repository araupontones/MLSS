#Reactive options based on the output of outputForm===================================
serverHeader <-  function(id, inputs) {
  moduleServer(id, function(input, output, session) {
    
    
    #header of the selected division -------------------------------------------
    title_division <- eventReactive(inputs$go(),{
      
      selected <- inputs$display()
      
      if(selected == "round") {
        
        text <- inputs$division()
        
      } else if (selected == "division_nam" & inputs$division() == "Malawi"){
        
        text <- paste("Divisions of", inputs$division())
        
      } else if (selected == "division_nam" & inputs$division() != "Malawi"){
        
        text <- paste(inputs$division(), "VS other divisions of Malawi")
        
      } else{
        
        text <- paste("Districts of", inputs$division())
      }
        
       
      
      
    }) 
    
    
    
    
    #text of header ------------------------------------------------------------
    text_header <- eventReactive(inputs$go(),
                                 
                                 if(inputs$by_other_var()){
                                   
                                   
                                   tags$div(class = "con containerHeader",
                                     tags$h3(title_division(), class = "title_division"),
                                     tags$h4(inputs$var_label(), class = "title_indicator"),
                                     tags$p(class = "compare-text",
                                            paste0("Whether ", id), 
                                            tags$span(class = "yes",inputs$compare_var_label()),
                                            tags$span(class = "no",  " or not.")
                                     )
                                   )
                                   
                                 } else{
                                   
                                   tags$div(class = "con containerHeader",
                                     tags$h3(title_division(), class = "title_division"),
                                     tags$h4(inputs$var_label(), class = "title_indicator")
                                   )
                                   
                                 }
                                 
    )
    
    
    
    output$header <- renderUI({
      
      req(text_header(), cancelOutput = T)
      
      text_header()
      
     
      
    })
    
    
  })
  
  
  
  
}
