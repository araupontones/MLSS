

uiDistricts <- function(id, choices_division){
  
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 3, class = "form",
                   #selectInput(NS(id,"d_division"), "Divisions", choices = choices_division),
                   tags$p(
                          HTML("The MLSS sample is nationally representative at division level. However,
                       the sample is representative at district level for 12 districts which
                       were the focus of key MESIP interventions.<br><br>
                       ")),
                   selectInput(NS(id,"d_district"), "Districts of key MESIP interventions", choices = c("Dowa")),
                   radioButtons(NS(id,"d_data"), label = "Indicators", 
                                choices = c("Key Indicators", "All Indicators")
                   )
      ),
      
      mainPanel(width = 8,
               
                uiOutput(NS(id,"header_district")),
                reactableOutput(NS(id,"table_districts"))
      )
      
    )
    
    
  )
  
}



serverDistricts <-  function(id, dirImports, dirLookUps ) {
  moduleServer(id, function(input, output, session) {
    
    
    key_indicators <- reactive({
      
      #get selected variables
      lkp <- rio::import(file.path(dirLookUps, "district/key_indicators.csv"))
      
      #to get the label of the variables, open their lookup
      niveles <- c("school", "teacher", "student")
      
      vars_niveles_l <- lapply(niveles, function(nivel){
        
        dropdowns_v <- rio::import(file.path(dirLookUps, nivel, glue::glue("dropdown_vars_{nivel}.csv"))) %>%
          select(var_name, label)
        
        return(dropdowns_v)
      })
      
      #append all niveles
      vars_niveles <- do.call(rbind, vars_niveles_l)
      
      #return vector with indicator names
      key_vars <- filter(vars_niveles, var_name %in%  lkp$key_indicators)
      key_vars$label
      
    })
    
    #data for the app ---------------------------------------------------------
    data_start <- reactive({
      
      #print("hola district")
      rio::import(file.path(dirImports, "district.rds")) %>%
        select(district_nam ,Level, Indicator, Round, value) %>%
        pivot_wider(id_cols = c(district_nam,Level, Indicator),
                    names_from = Round,
                    values_from = value)
    })
    
    
    #update districts dropdown -------------------------------------------------
    observe({
      
      district_choices <- unique(data_start()$district_nam)
      
      updateSelectInput(session, "d_district", "Districts of key MESIP interventions", choices = district_choices)
      
      
    })
    
    
    
    #districts data ------------------------------------------------------------
    data_districts <- eventReactive(input$d_district, {
      
      db <- data_start() %>%
        filter(district_nam == input$d_district) %>%
        select(-c(district_nam))
      
      
      db
      
      
    })
    
    
    data_selected <- eventReactive(input$d_data, {
      
      selected <- input$d_data
      
      
      if(selected == "Key Indicators"){
        
        ds <- data_districts() %>%
          filter(Indicator %in% key_indicators())
      } else {
        
        ds <- data_districts()
      }
      
      ds
      
    })
    
    
    
    
    
    
    
    
    #header district ===========================================================
    
    output$header_district <- renderUI({
      
      tags$div(
               tags$h3(input$d_district, class = "title_division"),
               tags$h4(input$d_data, class = "title_indicator"),
      )
      
      
      
    })
    
    
    #display table ===========================================================
    
    
    output$table_districts <- renderReactable(
      reactable(data_selected(),
                searchable = TRUE,
                columns = list(
                  
                  Level = colDef(maxWidth = 100),
                  #Round = colDef(maxWidth = 100),
                  Indicator = colDef(minWidth = 220)
                  #value = colDef(maxWidth = 100, name = input$d_district),
                  #N = colDef(maxWidth = 120, align = 'center', name = paste("N", input$d_district, sep = "-")),
                  #`National Average` = colDef(align = "right")
                
                ),
                defaultPageSize = 40, 
                language = reactableLang(
                  searchPlaceholder = "Search Indicator..."
                ))
    )
    
    
    
  })
}