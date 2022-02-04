schoolUI <- function(id, dirImports,dirLookUps, divisions, nivel ) {
  
  
  #load lookups
  #school_data <- rio::import(file.path(dirImports, "Baseline/school.rds"))
  dropdowns_v <- rio::import(file.path(dirLookUps, nivel, glue::glue("dropdown_vars_{nivel}.csv")))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  
  
  tagList(
    shinyFeedback::useShinyFeedback(),
    sidebarLayout(
      sidebarPanel(width = 3,
                   #selectInput("indicator", "Indicator",choices = "a"),
                   selectInput(NS(id,"indicator"), "Select Indicator", choices = var_codes),
                   selectInput(NS(id,"division"), "Division", choices = divisions),
                   
                   
                   uiOutput(NS(id,"compareInput")),
                   uiOutput(NS(id,'compareRounds')),
                   #selectInput(NS(id,"round"), "Rounds", choices = rounds, multiple = T),
                   
                   selectInput(NS(id,"plot_type"), "Select Plot Type", choices = c("Bar Plot","Box Plot", "Density Plot")),
                   actionButton(NS(id,"go"), "Create Plot",class="btn btn-primary")
                   
                   
      ),
      mainPanel(width = 7,
                uiOutput(NS(id,"title")),
                shinycssloaders::withSpinner(plotOutput(NS(id,"plot"))),
                tableOutput(NS(id,"table"))
      )
    )
  )
}


schoolServer <- function(id, dirLookUps, divisions, database, nivel, rounds) {
  moduleServer(id, function(input, output, session) {
    #load lookups -----------------------------------------------------------------
    
    
    
    dropdowns_v <- rio::import(file.path(dirLookUps, nivel, glue::glue("dropdown_vars_{nivel}.csv")))
    var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
    
    
    #confirm that all inputs have been provided by user -----------------------
    observeEvent(input$go,{
      
      shinyFeedback::feedbackDanger("round", is.null(input$round), "Select at least one round to be displayed")
      
      
    })
    
    observeEvent(input$round,{
      
      if(!is.null(input$round)){
        
        shinyFeedback::hideFeedback("round")
      }
      
      
      
    })
    
    
    #create reactive data based on users inputs -------------------------------
    
    indicator <- eventReactive(input$indicator,{
      
      input$indicator
      
    })
    
    #label of indicator to display in charts
    indicator_label <- eventReactive(input$go, {
      
      names(var_codes[which(var_codes == input$indicator)])
      
    })
    
    
    parameters_panel <- eventReactive(input$go,{
      
      #saved in functions
      create_data_parameters(region = input$division,
                             by_time = across_time(),
                             by_divisions = group_by_divisions(),
                             by_districts = group_by_districts())
      
      
      
      
      
    })
    
    
    #****************ENABLING CONDITIONS ****************************************
    output$compareInput <- renderUI({
      
      
      
      if(input$division == "Malawi"){
        radioButtons(NS(id,"compare_divisions"), "Compare",choices = c("Across time", "Divisions"))
        
      } else {
        
        radioButtons(NS(id,"compare_divisions"), "Compare",choices = c("Across time","With other divisions", "Districts within"))
      }
      
    })
    
    output$compareRounds <- renderUI({

     

      if(across_time()){


      } else {

        selectInput(NS(id,"round"), "Rounds", choices = rounds, multiple = T)
      }
      
     
      
      
    })
    
    
    # ************* DEFINE COMBINATIONS FOR DATA *********************************
    
    
    across_time <- eventReactive(input$compare_divisions,{
      
      input$compare_divisions == "Across time"
      
    })
    
    
    #condition to keep all the provinces
    keep_all_divisions <- eventReactive(input$go,{
      
      input$division == "Malawi" | str_detect(input$compare_divisions, "[Dd]ivision")
      
    })
    
    group_by_divisions <- eventReactive(input$compare_divisions,{
      
      str_detect(input$compare_divisions, "[Dd]ivision")
      
      
    })
    
    group_by_districts <- eventReactive(input$compare_divisions,{
      
      str_detect(input$compare_divisions, "[Dd]istrict")
      
      
    })
    
    #*********************CREATE VECTORS TO FILTER THE DATA *************************
    
    
    divisions_selected <- eventReactive(input$go,{
      
      #all divisions
      if(keep_all_divisions()){
        divisions[-1]
      } else{
        #selected division
        input$division
      }
      
    })
    
    #vector of rounds selected
    rounds_selected <- eventReactive(input$go,{
      
      if(across_time()){
        
        rounds
      } else{
        
        input$round
      }
      
    })
    
    
    
    #***********************REACTIVE TEXT ****************************************
    
    output$title <- renderUI({
      
      HTML(paste(
        "<h1>",parameters_panel()$title, "</h1>",
        "<h2>",indicator_label(), "</h2>"
      )
      )
      
    })
    
    
    #*****************CREATE REACTIVE DATA *****************************************
    data_divison <- eventReactive(input$go,{
      # print(paste("Group Divisions",group_by_divisions()))
      # print(paste("Group Districts:", group_by_districts()))
      # print(paste("X=", parameters_panel()$x))
      # print(paste("Y=", parameters_panel()$y))
      # print(paste("grupo=", parameters_panel()$group))
      
      data_user <- database %>%
        select(targetvar = input$indicator,
               division_nam, district_nam, round) %>%
        filter(division_nam %in% divisions_selected()) %>%
        filter(round %in% rounds_selected())
      
      
      if(input$plot_type == "Bar Plot"){
        #summarise by round
        if(across_time()){
          
          data_user <- data_user %>% group_by(round) %>% summarise(mean = mean(targetvar, na.rm = T, .groups = "drop"))
        }
        
        #summarise by level of interest and round
        if(group_by_districts() | group_by_divisions()){
          
          
          data_user <- data_user %>%
            group_by(.data[[parameters_panel()$group]], .data[["round"]]) %>%
            summarise(mean = mean(targetvar, na.rm = T))
        }
        
        
        
      }
      
      data_user
      
      
    })
    
    output$table <- renderTable({
      
      display <- !is.null(input$round) | across_time()
      
      req(display, cancelOutput = T)
      data_divison()
      
    })
    
    
    
    my_plot <- eventReactive(input$go, {
      
      print(parameters_panel()$y_lab)
      if(input$plot_type == "Bar Plot"){
        
        print(parameters_panel()$y_lab)
        
        plot <- data_divison() %>%
          ggplot(aes(x = .data[[parameters_panel()$x]],
                     y = mean,
                     fill = round)) +
          geom_col(position = "dodge2") +
          labs(y = indicator_label(),
               x = parameters_panel()$y_lab)
      }
      
      if(input$plot_type == "Box Plot"){
        
        plot <- data_divison() %>%
          ggplot(aes(y = targetvar,
                     x = .data[[parameters_panel()$x]],
          )) +
          #geom_col(aes(y = mean(school$enrol_lower_tot, na.rm = T))) +
          geom_boxplot(binaxis='y', stackdir='center', dotsize=1, fill = '#A8D1DF') +
          geom_jitter(shape=16, position=position_jitter(0.2))  +
          labs(y = indicator_label(),
               x = parameters_panel()$y_lab)
        
        
        if(!across_time()){
          
          plot <- plot + facet_wrap(~ round) 
        }
        
        
        
      }
      
      if(input$plot_type == "Density Plot"){
        
        plot <- data_divison() %>%
          ggplot() +
          geom_density(aes(x = targetvar, fill = round)) +
          labs(x = indicator_label())
        
        
        if(across_time()){
          
          plot <- plot +
            geom_vline(aes(xintercept = mean(targetvar, na.rm = T)), 
                       linetype = "dashed", size = 0.6,
                       color = "#FC4E07") 
          
        }
        
        
        
        if(!across_time()){
          
          plot <- plot +
            geom_vline(data = plyr::ddply(data_divison(), 
                                          c(parameters_panel()$x,"round"), 
                                          summarize, 
                                          wavg = mean(targetvar, na.rm = T)), aes(xintercept=wavg, color = paste("Mean",rounds)),
                       linetype = "dashed", size = 0.7
            ) +
            facet_wrap(~ .data[[parameters_panel()$x]]) +
            scale_color_manual(name = "",
                               values = c("black", "red", "blue"))
          
        }
        
      }
      
      
      
      plot +
        theme(text = element_text(family = "Roboto")) 
      
      
      
      
      
    })
    
    
    output$plot <- renderPlot({
      
      my_plot()
      
      
    })
    
    
    
    
  })
  
  
  
}