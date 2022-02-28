#Reactive options based on the output of outputForm===================================
serverHeader <-  function(id, inputs) {
  moduleServer(id, function(input, output, session) {
    
    
    
    text_header <- eventReactive(inputs$go(),
                                 
                                 if(inputs$by_other_var()){
                                   
                                   
                                   tags$div(
                                     tags$h3(inputs$division()),
                                     tags$h4(inputs$var_label()),
                                     tags$p(class = "compare-text",
                                            paste0("Wether ", id,"s "), 
                                            tags$span(class = "yes",inputs$compare_var_label()),
                                            tags$span(class = "no",  " or not")
                                     )
                                   )
                                   
                                 } else{
                                   
                                   tags$div(
                                     tags$h3(inputs$division()),
                                     tags$h4(inputs$var_label())
                                   )
                                   
                                 }
                                 
    )
    
    
    
    output$header <- renderUI({
      
      req(text_header(), cancelOutput = T)
      
      text_header()
      
      # if(inputs$by_other_var()){
      #   
      #   tags$div(
      #     tags$h3(inputs$division()),
      #     tags$h4(inputs$var_label()),
      #     tags$p(class = "compare-text",
      #            paste0("Wether ", id,"s "), 
      #            tags$span(class = "yes",inputs$compare_var_label()),
      #            tags$span(class = "no",  " or not")
      #     )
      #   )
      # } else{
      #   tags$div(
      #     tags$h3(inputs$division()),
      #     tags$h4(inputs$var_label())
      #   )
      #   
      # }
      
      
    })
    
    
  })
  
  
  
  
}
