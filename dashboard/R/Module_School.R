schoolUI <- function(id, dirImports,dirLookUps, divisions, nivel ) {
  
  
  #load lookups
  #school_data <- rio::import(file.path(dirImports, "Baseline/school.rds"))
  dropdowns_v <- rio::import(file.path(dirLookUps, nivel, glue::glue("dropdown_vars_{nivel}.csv")))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  #variables to compare
  compare_vars <- dropdowns_v %>% filter(type == "binary")
  
  #display selection for dont compare
  lab_dont_compare <- "Don't compare"
  compare_codes <- setNames(c(lab_dont_compare,compare_vars$var_name), c(lab_dont_compare,compare_vars$label))
  
  
  tagList(
    shinyFeedback::useShinyFeedback(),
    sidebarLayout(
      sidebarPanel(width = 3, class ="form",
                   #selectInput("indicator", "Indicator",choices = "a"),
                   selectInput(NS(id,"indicator"), "Indicator", choices = var_codes),
                   selectInput(NS(id,"division"), "Division", choices = divisions),
                   
                   uiOutput(NS(id,"compareVars")),
                   #selectInput(NS(id,"compare"), "Compare", choices = compare_codes),
                   
                   
                   uiOutput(NS(id,"compareInput")),
                   uiOutput(NS(id,'compareRounds')),
                   #selectInput(NS(id,"round"), "Rounds", choices = rounds, multiple = T),
                   
                   uiOutput(NS(id, "definePlot")),
                   #selectInput(NS(id,"plot_type"), "Select Plot Type", choices = c("Bar Plot","Box Plot", "Density Plot")),
                   actionButton(NS(id,"go"), "Create Plot",class="btn btn-secondary")
                   
                   
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
    
    
    
    lab_dont_compare <- "Don't compare"
    dropdowns_v <- rio::import(file.path(dirLookUps, nivel, glue::glue("dropdown_vars_{nivel}.csv")))
    var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
    compare_vars <- dropdowns_v %>% filter(type == "binary")
    compare_codes <- setNames(c(lab_dont_compare,compare_vars$var_name), c(lab_dont_compare,compare_vars$label))
    
    
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
    
    
    indicator_type <- eventReactive(input$indicator,{
      
      dropdowns_v$type[dropdowns_v$var_name == input$indicator]
      
    })
    
    
    
    
    
    
    parameters_panel <- eventReactive(input$go,{
      
      #saved in functions
      create_data_parameters(dropdowns_v = dropdowns_v,
                             compare_vars = compare_vars,
                             region = input$division,
                             indicator = input$indicator,
                             indicator_compare = input$compare,
                             by_time = across_time(),
                             by_divisions = group_by_divisions(),
                             by_districts = group_by_districts(),
                             by_other = by_other_var()
      )
      
      
    })
    
    
    
    
    #****************ENABLING CONDITIONS IN USER'S INPUTS ****************************************
    
   
    
    output$compareInput <- renderUI({



      if(input$division == "Malawi"){
        radioButtons(NS(id,"compare_divisions"), "Display",choices = c("Across time", "Divisions"))

      } else {

        radioButtons(NS(id,"compare_divisions"), "Display",choices = c("Across time","With other divisions", "Districts within"))
      }

      
      
    })
    
    output$compareVars <- renderUI({
      
      if(indicator_type()!= "binary"){
        
        selectInput(NS(id,"compare"), paste0("Compare by  ", nivel,"s", " characteristics?"), choices = compare_codes)
      } else {
        
        
      }
      
    })
    
    output$compareRounds <- renderUI({
      
      
      
      if(across_time()){
        
        
      } else {
        
        selectInput(NS(id,"round"), "Rounds", choices = rounds, multiple = T)
      }
      
      
      
      
    })
    
    output$definePlot <- renderUI({
      
      
      show_all <- indicator_type() != "binary" & !compare_groups()
      
      if(show_all){
        
        selectInput(NS(id,"plot_type"), "Plot Type", choices = c("Bar Plot","Box Plot", "Density Plot"))
      } else {
        
        selectInput(NS(id,"plot_type"), "Plot Type", choices = c("Bar Plot"))
        
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
    
    compare_groups <- eventReactive(input$compare, {
      
      input$compare != lab_dont_compare
      
    })
    
    by_other_var <- eventReactive(input$go,{
      compare_groups() & indicator_type()!="binary"
    })
    
    #*********************CREATE VECTORS TO FILTER THE USER'S DATA *************************
    
    
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
        "<h2>",parameters_panel()$subtitle, "</h2>"
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
      #print(paste("compare groups:", compare_groups()))
      #print(paste("compare", input$compare))
      data_user <- create_data_user (db = database,
                                     indicator_user = input$indicator,
                                     divisions_user = divisions_selected(),
                                     rounds_user = rounds_selected(),
                                     indicator_type = indicator_type(),
                                     plot_user = input$plot_type, 
                                     by_divisions = group_by_divisions(),
                                     by_districts = group_by_districts(),
                                     
                                     parameters_group = parameters_panel()$group,
                                     by_time = across_time(),
                                     by_other_vars = by_other_var(),
                                     fill = input$compare)
      
      
      
    })
    
    output$table <- renderTable({
      
      display <- !is.null(input$round) | across_time()
      
      req(display, cancelOutput = T)
      data_divison()
      
    })
    
    
    
    my_plot <- eventReactive(input$go, {
      
      
      #bar plots =============================================================
      if(input$plot_type == "Bar Plot"){
        
        
        #if user selects to compare by other variable
        if(by_other_var()){
          
          
          plot <- plot_compare_outcomes(database = data_divison(),
                                        x = parameters_panel()$x,
                                        name_fill = input$compare,
                                        y_label =  parameters_panel()$indicator_label,
                                        x_label = parameters_panel()$x_lab
          )
          
        } else{
          
          plot <- plot_bar(database = data_divison(),
                           x = parameters_panel()$x,
                           y_label =  parameters_panel()$indicator_label,
                           x_label  = parameters_panel()$x_lab
          )
        }
        
        
      }
      
      #Box plots =============================================================
      
      if(input$plot_type == "Box Plot"){
        
        
        plot<-plot_box(database= data_divison(),
                       by_time = across_time(),
                       x = parameters_panel()$x,
                       y_label = parameters_panel()$indicator_label,
                       x_label = parameters_panel()$x_lab
        )
        
        
      }
      
      if(input$plot_type == "Density Plot"){
        
        plot <- plot_density(database = data_divison(),
                             by_time = across_time(),
                             x_label = parameters_panel()$indicator_label,
                             wrap_var = parameters_panel()$x,
                             rounds = rounds)
        
        
      }
      
      
      
      plot +
        theme(text = element_text(family = "Roboto")) 
      
      
      
      
      
    })
    
    
    output$plot <- renderPlot({
      
      my_plot()
      
      
    })
    
    
    
    
  })
  
  
  
}