schoolUI <- function(id, dirImports,dirLookUps ) {
  
 
  #load lookups
  school_data <- rio::import(file.path(dirImports, "Baseline/school.rds"))
  dropdowns_v <- rio::import(file.path(dirLookUps, "school/dropdown_vars_school.csv"))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  
  
  tagList(
    sidebarLayout(
      sidebarPanel(width = 3,
        #selectInput("indicator", "Indicator",choices = "a"),
        selectInput(NS(id,"indicator"), "Select Indicator", choices = var_codes),
        selectInput(NS(id,"plot_type"), "Select Plot Type", choices = c("Bar Plot","Box Plot", "Density Plot")),
        
        
        actionButton(NS(id,"go"), "Create Plot",class="btn btn-primary")
        
        
      ),
      mainPanel(width = 7,
        plotOutput(NS(id,"plot")),
      )
    )
  )
}


schoolServer <- function(id, dirImports, dirLookUps) {
  moduleServer(id, function(input, output, session) {
    #load data
    school_data <- rio::import(file.path(dirImports, "Baseline/school.rds"))
    dropdowns_v <- rio::import(file.path(dirLookUps, "school/dropdown_vars_school.csv"))
    var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
   
    #print(names(school_data))
    indicator <- reactive({
      
      req(input$indicator)
      print(input$indicator)
      input$indicator
      
    })
    
    output$plot <- renderPlot({
      
      req(input$go)
      #label_var <- var_codes[[input$indicator]]
     
      label_var <- names(var_codes[which(var_codes == input$indicator)])
     
      if(input$plot_type == "Density Plot"){
        
        school_data %>%
          rename(var_t = input$indicator) %>%
          ggplot() +
          geom_density(aes(x = var_t),fill = "lightgray") +
          geom_vline(aes(xintercept = mean(var_t, na.rm = T)), 
                     linetype = "dashed", size = 0.6,
                     color = "#FC4E07") +
          labs(x = label_var) +
          theme(text = element_text(family = "Roboto"))
      }
      
      
    })
    
    
    observeEvent(input$indicator,{
      
      message(indicator())
      #message(input$indicator)
    })
    
  })
  
  
  
}