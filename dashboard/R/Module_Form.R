uiForm <- function(id, compare_codes, rondas,dirLookUps,nivel, divisions){
  
  
  dropdowns_v <- rio::import(file.path(dirLookUps, nivel, glue::glue("dropdown_vars_{nivel}.csv")))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  #variables to compare
  compare_vars <- dropdowns_v %>% filter(type == "binary")
  
  #display selection for dont compare
  lab_dont_compare <- "Don't compare"
  compare_codes <- setNames(c(lab_dont_compare,compare_vars$var_name), c(lab_dont_compare,compare_vars$label))
  
  
  tagList(
    
    #selectInput(NS(id,"indicator"), "Indicator", choices = var_codes, selected = var_codes[1]),
    
    selectInput(NS(id,"division"), "Division", choices = divisions),
    
    uiOutput(NS(id,"compareVars")),
    
    radioButtons(NS(id,"display"), label = "Display",choices = c("Across time","With other divisions")),
    
    
    selectInput(NS(id,"round"), "Round", choices = rondas, multiple = T, selected = rondas[1]),
    
    selectInput(NS(id,"plot_type"), "Plot Type", choices =  c("Bar Plot","Box Plot", "Density Plot"))
    
    
    
  )
  
  
}


#===============================================================================


outputForm <- function(id){
  
  moduleServer(id, function(input, output, session){
    
    
    list(
     
      indicator = reactive(input$indicator),
      division = reactive(input$division),
      display = reactive(input$display),
      round = reactive(input$round),
      plot_type = reactive(input$plot_type)
     
    )
    
    
    
    
  })
}

serverForm <-  function(id, input_division) {
  moduleServer(id, function(input, output, session) {



   observeEvent(input_division(), {

     if(input_division()!= "Malawi"){

       updateSelectInput(session, "display", choices = "C")
     }

   })

  })
}