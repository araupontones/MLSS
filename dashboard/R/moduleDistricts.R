

uiDistricts <- function(id, choices_division){
  
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 3, class = "form",
                   selectInput(NS(id,"d_division"), "Divisions", choices = choices_division),
                   
                   selectInput(NS(id,"d_district"), "Districts of key MESIP interventions", choices = c("Dowa"))
                   ),
      
      mainPanel(width = 8,
                tags$p("The MLSS sample is nationally representative at division level. However,
                       the sample is representative at district level for 12 districts which
                       were the focus of key MESIP interventions. This section presents 
                       indicators for those 12 districts."),
                uiOutput(NS(id,"header_district")),
                reactableOutput(NS(id,"table_districts"))
                )
      
    )
    
   
  )

}



serverDistricts <-  function(id, dirImports ) {
  moduleServer(id, function(input, output, session) {
    
    
    
    
    #update form ==============================================================
    observeEvent(data_divisions(), {
      
      
      
      district_choices <- unique(data_divisions()$district_nam)
      
      updateSelectInput(session, "d_district", "Districts of key MESIP interventions", choices = district_choices)
      
      
    })
    
    
    #data of the app =========================================================
    districts_data <- rio::import(file.path(dirImports, "district.rds")) 
    
    #division data 
    data_divisions <- eventReactive(input$d_division, {
    
    districts_data %>%
      filter(division_nam == input$d_division)
    
  })
  
    
    #districts data
    data_districts <- eventReactive(input$d_district, {
      
      db <- data_divisions() %>%
        filter(district_nam == input$d_district) %>%
        select(-c(district_nam, division_nam))
       
      
      db
      
      
      
    })
  
    
    #header district ===========================================================
    
    output$header_district <- renderUI({
      
      tags$h3(input$d_district)
    })
   
      
     #display table ===========================================================
  
    
    output$table_districts <- renderReactable(
      reactable(data_districts(),
                searchable = TRUE,
                columns = list(
                  
                  Level = colDef(maxWidth = 100),
                  Round = colDef(maxWidth = 100),
                  Indicator = colDef(minWidth = 180),
                  value = colDef(maxWidth = 100, name = input$d_district),
                  N = colDef(maxWidth = 120, align = 'center', name = paste("N", input$d_district, sep = "-")),
                  `National Average` = colDef(align = "right")
                  
                ),
                defaultPageSize = 15, 
                language = reactableLang(
                  searchPlaceholder = "Search Indicator..."
                ))
      )
    
    
    
  })
}