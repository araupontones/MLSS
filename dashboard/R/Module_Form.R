uiForm <- function(id, compare_codes, rounds,dirLookUps,nivel, divisions){
  
  #print(file.path(dirLookUps, id, glue::glue("dropdown_vars_{id}.csv")))
  dropdowns_v <- rio::import(file.path(dirLookUps, id, glue::glue("dropdown_vars_{id}.csv")))
  var_codes <- setNames(dropdowns_v$var_name, dropdowns_v$label)
  # compare_vars <- dropdowns_v %>% filter(type == "binary")
 
  
  tagList(
    
    selectInput(NS(id,"indicator"), paste(stringr::str_to_title(id), "indicators"), choices = var_codes),
    
    selectInput(NS(id,"division"), "Division", choices = divisions),
    
    uiOutput(NS(id,"binaryBars")),
    
   
    
    radioButtons(
      NS(id,"display"), label = "Display",choices = setNames(c("round", "division_nam"),
                                                             c("Across rounds","Divisions of Malawi"))
      ),
    
    
    selectInput(NS(id,"round"), "Round", choices = rounds, multiple = T, selected = rounds),
    
    selectInput(NS(id,"plot_type"), "Plot Type", choices =  c("Bar Plot","Box Plot", "Density Plot")),
    
    actionButton(NS(id,"go"), "Create Plot",class="btn btn-secondary")
    
    
    
  )
  
  
}


#get user inputs ===============================================================


outputForm <- function(id, dirLookUps){
  
  moduleServer(id, function(input, output, session){
    
   
    dropdowns_v <- rio::import(file.path(dirLookUps, id, glue::glue("dropdown_vars_{id}.csv")))
    binary_vars <- dropdowns_v %>% filter(type == "binary")
    divisions_lkp <- rio::import(file.path(dirLookUps, "divisions.csv"))
    divisions_v <- c("Malawi",divisions_lkp[["division_nam"]])
  
    
#condition to display only barplot
    only_bar <- reactive(
      
      {input$compare} != "Don't compare" |{input$indicator} %in% binary_vars$var_name
      
    )
    
    
#condition to.. characteristics 
    compare_by_chars <- eventReactive(input$compare, {
      
      {input$compare} != "Don't compare"
    })
    
    
#divisions to keep in data
    keep_divisions <- reactive(
      
      
      if({input$division} == "Malawi"){
        
        divisions_v[-1]
      } else if(str_detect({input$display}, "across|[Dd]istrict")){
        
        {input$division}
      } else{
        divisions_v[-1]
        
      }     
      
      
    )
      
    
  
    
#group_by this variables in data 
    
    group_vars <- reactive(
      
      

      if({input$display} == "division_nam"){

        vars <- c("division_nam", "round")

      } else if ({input$display} == "district_nam") {

        vars <- c("division_nam", "district_nam", "round")

        } else if ({input$display} == "round"){

        vars <- c("round")
      }
      
  
      
    )
    
#to create fill in data 
    by_other_var <- eventReactive(input$go,{
      
      compare_by_chars() & !{input$indicator} %in% binary_vars$var_name
      
      
      
    })
   
    
#Plot axis 
    
    x_var_plot <- reactive(  
      
      if({input$display} == "division_nam"){
        list(
          
          x = c("division_nam"),
          x_lab =  "Division",
          across_time = F
          
        )
        
        
      } else if (str_detect({input$display}, "[Dd]istrict")) {
        
        list( x = c("district_nam"),
              x_lab = "District",
              across_time = F)
        
       
        
        
      } else{
        
        list(
          x = c("round"),
          x_lab = "Round",
          across_time = T
        )
       
      }
      
      )
    
    
#Plot label 
    
var_label <- reactive(
  
  indicator_label <- dropdowns_v$label[dropdowns_v$var_name == input$indicator]
)
     

compare_var_label <- reactive(
  
  dropdowns_v$label_yes[dropdowns_v$var_name == input$compare]
)
   


      
#reactive elements -----------------------------------------------------------  
    
    list(
      division = reactive({input$division}),
      display = reactive({input$display}),
      round = reactive({input$round}),
      plot_type = reactive({input$plot_type}),
      indicator = reactive({input$indicator}),
      go = reactive({input$go}),
      compare_var = reactive({input$compare}),
    
      #enabling conditions
      binary_indicator = reactive({input$indicator} %in% binary_vars$var_name),
      compare_by_chars = compare_by_chars,
      compare_var_label = compare_var_label,
      only_bar = only_bar,
      #divisions_selected = divisions_selected,
      
      #parameters for data ---------
      group_vars = group_vars,
      by_other_var = by_other_var,
      keep_divisions = keep_divisions,
      
      #parameters for plot ----
      x_var_plot = x_var_plot,
      var_label = var_label, 
      
      #lookup
      lookUp = dropdowns_v
      
    )
    
    
    
    
    
    
    
  })
}

#Reactive options based on the output of outputForm===================================
serverForm <-  function(id, inputs, dirLookUps ) {
  moduleServer(id, function(input, output, session) {
    
    dropdowns_v <- rio::import(file.path(dirLookUps, id, glue::glue("dropdown_vars_{id}.csv")))
    compare_vars <- dropdowns_v %>% filter(type == "binary")
    
    

    
#Display options --------------------------------------------------------
    observeEvent(inputs$division(), {
      
      if(inputs$division() == "Malawi"){
        
        updateRadioButtons(session, "display", choices = setNames(c("round", "division_nam"),
                                                                  c("Malawi across rounds","Divisions of Malawi"))
                           )
      }
      
      
      if(inputs$division()!= "Malawi"){
        
        updateRadioButtons(session, "display", choices = setNames(c("round", "division_nam", "district_nam"),
                                                                  c(paste(inputs$division(),"across rounds"),
                                                                    paste(inputs$division(),"with other divisions"),
                                                                    paste("Districts of", inputs$division())))
                           )
      }
      
    })
    
    
#compare by characteristics options -------------------------------------
    
    lab_dont_compare <- "Don't compare"
    compare_codes <- setNames(c(lab_dont_compare,compare_vars$var_name), c(lab_dont_compare,compare_vars$label))
    
    output$binaryBars <- renderUI({


      if(inputs$binary_indicator()){


      } else {

        selectInput(NS(id,"compare"), paste0("Compare by ", id, "s characteristics?"), choices =  compare_codes)
      }

    })
    
    
    
    
   
    
      
    
#plot type options -------------------------------------------------------------
    observeEvent(inputs$only_bar(),{

      size_logic = length(inputs$only_bar())
      
      if(size_logic > 0){
        
        if(inputs$only_bar()){
          
          updateSelectInput(session, "plot_type", choices =  c("Bar Plot"))
        } else {
          
          updateSelectInput(session, "plot_type", choices =  c("Bar Plot","Box Plot", "Density Plot"))
        }
        
        
      }
      
      



    })
      
      
    })
    
    
    
  
}



