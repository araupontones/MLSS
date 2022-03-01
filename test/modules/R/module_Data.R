serverData <-  function(id, inputs, dirImports ) {
  moduleServer(id, function(input, output, session) {
    
    database <- rio::import(file.path(dirImports, glue::glue("{id}.rds")))
    
    data_user <- eventReactive(inputs$go(),{
      
      #to compare with other characteristics ==================================
      if(inputs$compare_by_chars() & !inputs$binary_indicator()){
        
        data_reactive <-  database %>% 
          ungroup() %>%
          select(targetvar = inputs$indicator(),
                 fill = inputs$compare_var(),
                 division_nam, district_nam, round) %>%
          filter(division_nam %in% inputs$keep_divisions()) %>%
          filter(round %in% inputs$round()) %>%
          mutate(fill = case_when(fill == 1 ~ "Yes",
                                  fill == 3 ~ NA_character_,
                                  T ~ "No")) %>%
          group_by_at(c(inputs$group_vars(), "fill")) %>%
          summarise(mean = mean(targetvar, na.rm = T),
                    n = n(), .groups = 'drop')
        
        #if user does not want to compare outcomes by characteristics ----------------
      } else {
        
        data_reactive <- database %>%
          select(targetvar = inputs$indicator(),
                 division_nam, district_nam, round) %>%
          filter(division_nam %in% inputs$keep_divisions()) %>%
          filter(round %in% inputs$round())
        
        
        
        
        #correct misscoding of binary vars
        if(inputs$binary_indicator()){
          
          data_reactive <- data_reactive %>%
            mutate(targetvar = case_when(targetvar == 2 ~ 0,
                                         targetvar == 3 ~ NA_real_,
                                         targetvar == 0 ~ 0,
                                         T ~ 1))
          
        }
        
        if(inputs$plot_type() == "Bar Plot"){
          
          data_reactive <- data_reactive %>% group_by_at(inputs$group_vars()) %>%
           summarise(mean = mean(targetvar, na.rm = T),
                     n = n(),
                     .groups = "drop")
          
         
          
        }
        
        data_reactive
        
       
        
      }
      
      
      
      
      
    })
    
    
    
    output$table <- renderTable({
      
      #display <- !is.null(input$round) | across_time()
      
      req(data_user(), cancelOutput = T)
      data_user()
      
    })
      
      
    reactive(data_user())
    
  })
}