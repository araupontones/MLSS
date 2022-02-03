schoolUI <- function(id, dirImports,dirLookUps, divisions, rounds ) {
 
 
  #load lookups
  #school_data <- rio::import(file.path(dirImports, "Baseline/school.rds"))
  dropdowns_v <- rio::import(file.path(dirLookUps, "school/dropdown_vars_school.csv"))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  
  
  tagList(
    shinyFeedback::useShinyFeedback(),
    sidebarLayout(
      sidebarPanel(width = 3,
        #selectInput("indicator", "Indicator",choices = "a"),
        selectInput(NS(id,"indicator"), "Select Indicator", choices = var_codes),
        selectInput(NS(id,"division"), "Division", choices = divisions),
        
  
        uiOutput(NS(id,"compareInput")),
        selectInput(NS(id,"round"), "Rounds", choices = rounds, multiple = T),
        
        selectInput(NS(id,"plot_type"), "Select Plot Type", choices = c("Bar Plot","Box Plot", "Density Plot")),
        actionButton(NS(id,"go"), "Create Plot",class="btn btn-primary")
        
        
      ),
      mainPanel(width = 7,
        plotOutput(NS(id,"plot")),
        tableOutput(NS(id,"table"))
      )
    )
  )
}


schoolServer <- function(id, dirLookUps, divisions, database) {
  moduleServer(id, function(input, output, session) {
    #load lookups -----------------------------------------------------------------

    dropdowns_v <- rio::import(file.path(dirLookUps, "school/dropdown_vars_school.csv"))
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
    #fetch indicator selected
    indicator <- eventReactive(input$indicator,{
      
      input$indicator
      
    })
    
    #label of indicator to display in charts
    indicator_label <- eventReactive(input$indicator, {
      
      names(var_codes[which(var_codes == input$indicator)])
      
    })
 
    
    
    #display radio comparison (if user selects Malawi ir a district)-----------
    output$compareInput <- renderUI({
      


      if(input$division == "Malawi"){
        radioButtons(NS(id,"compare_divisions"), "Display",choices = c("National Level", "Divisions"))

      } else {

        radioButtons(NS(id,"compare_divisions"), "Compare",choices = c("With other divisions", "Districts within"))
      }
      
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
    
    #condition to group data by division
    
    #create vector of selected division
    divisions_selected <- eventReactive(input$go,{
  
      #all divisions
      if(keep_all_divisions()){
        divisions[-1]
      } else{
        #selected division
        input$division
      }
      
    })
    
  
    
    data_divisions <- eventReactive(input$go,{
      print(paste("Group Divisions",group_by_divisions()))
      print(paste("Group Districts:", group_by_districts()))
      
      database %>%
        select(targetvar = input$indicator,
               division_nam, district_nam, round) %>%
        filter(division_nam %in% divisions_selected()) %>%
        filter(round %in% input$round)
      
    })
    
    output$table <- renderTable({
      
      
      req(!is.null(input$round), cancelOutput = T)
      data_divisions()
      
    })
    
    output$plot <- renderPlot({
      
      req(input$go)
      #label_var <- var_codes[[input$indicator]]
     
      
     
      if(input$plot_type == "Density Plot"){
        
        database %>%
          rename(var_t = input$indicator) %>%
          ggplot() +
          geom_density(aes(x = var_t),fill = "lightgray") +
          geom_vline(aes(xintercept = mean(var_t, na.rm = T)), 
                     linetype = "dashed", size = 0.6,
                     color = "#FC4E07") +
          labs(x = indicator_label()) +
          theme(text = element_text(family = "MT Extra"))
      }
      
      
    })
    
    
    observeEvent(input$indicator,{
      
      message(indicator())
      #message(input$indicator)
    })
    
  })
  
  
  
}