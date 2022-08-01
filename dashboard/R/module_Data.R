serverData <-  function(id, inputs, dirImports ) {
  moduleServer(id, function(input, output, session) {
    
    #import data ------------------------------------------------------------
    database <- rio::import(file.path(dirImports, glue::glue("{id}.rds")))
    
    print(paste("hola", id))
    
    data_user <- eventReactive(inputs$go(),{
      print(
      database %>% 
        rename(targetvar = inputs$indicator()) %>%
        group_by(round) %>%
        summarise(mean = mean(targetvar, na.rm = T),
                  total = n())
      )
      
      print(inputs$indicator())
      print(inputs$compare_by_chars())
      
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
                                  is.na(fill) ~ NA_character_,
                                  T ~ "No")) %>%
          group_by_at(c(inputs$group_vars(), "fill")) %>%
          summarise(mean = mean(targetvar, na.rm = T),
                    n = sum(!is.na(targetvar)), .groups = 'drop') %>%
          mutate(color = if_else(fill =="Yes", color_yes, color_no),
                 fill = factor(fill,
                               levels = c("Yes", "No")
                 )
                 ) %>%
          filter(!is.na(fill))
        
        #if user does not want to compare outcomes by characteristics ----------------
      } else {
        
        data_reactive <- database %>%
          select(targetvar = inputs$indicator(),
                 division_nam, district_nam, round) %>%
          filter(division_nam %in% inputs$keep_divisions()) %>%
          filter(round %in% inputs$round())
        
        print(inputs$round())
        print(inputs$keep_divisions())
        
        
        #correct misscoding of binary vars
        if(inputs$binary_indicator()){
          
          data_reactive <- data_reactive %>%
            mutate(targetvar = case_when(targetvar == 2 ~ 0,
                                         targetvar == 3 ~ NA_real_,
                                         is.na(targetvar) ~ NA_real_,
                                         targetvar == 0 ~ 0,
                                         T ~ 1))
          
        }
        
        if(inputs$plot_type() %in% c("Bar Plot", "Line Plot")){
          
          data_reactive <- data_reactive %>% 
            group_by_at(inputs$group_vars()) %>%
            summarise(mean = mean(targetvar, na.rm = T),
                      n = sum(!is.na(targetvar)),
                      .groups = "drop")
          
          
          
        }
        
        data_reactive
        
        
        
      }
      
      
      
      
      
    })
    
    
    
    title_table <- eventReactive(data_user(),{
      
      if(inputs$plot_type() %in% c("Bar Plot", "Line Plot")){
        
        title <- tags$div(
          tags$hr(),
          tags$h4("Summary table", class = "text-center" ),
          tags$br(),
          
        )
        
      } else{
        
        title <- tags$h4("")
      } 
      
      title
      
    })
    #title --------------------------------------------------------------------
    
    
    
    
    output$title_table <- renderUI({
      req(title_table())  
      
      
      
      title_table()
      
      
    })
    
    
    
    #reactive table ------------------------------------------------------------------
    my_table <- eventReactive(data_user(),{
      
      
      #remove division nam if districts is selected 
      names_data <- names(data_user())
      has_district <- length(which(names_data == "district_nam"))
      
      
      if(has_district == 1){
        
        data_table <- data_user() %>% select(-division_nam)
      } else {
        
        data_table <- data_user()
      }
     
      
      
      
      #change names in table to make table more apealing
      names(data_table)[which(names(data_table) == "round")] <- "Round"
      names(data_table)[which(names(data_table) == "division_nam")] <- "Division"
      names(data_table)[which(names(data_table) == "district_nam")] <- "District"
      
      
      
      req(inputs$go(), cancelOutput = T)
      
      if(!inputs$plot_type() %in% c("Bar Plot", "Line Plot")){
        
        
      } else if(inputs$compare_by_chars() & !inputs$binary_indicator()){
        
        
        reactable_compare(data_table, inputs$compare_var_label(), inputs$var_label(), level = id)
        
        
      } else if(inputs$binary_indicator() | inputs$percentage_indicator()) {
        
        
        reactable_bar_binary(data_table, inputs$var_label())
        
      } else if(!inputs$binary_indicator()) {
        
        
        reactable_bar(data_table, inputs$var_label())
        
      }
      
      
      
      
      
      
      
      
      
      
      
      
      
    })
    
    
    
    
    
    output$table <- renderReactable({
      
      req(my_table())
      my_table()
      
      
      
      
      
      
    })
    
    #return data user to use outside module
    reactive(data_user())
    
  })
}