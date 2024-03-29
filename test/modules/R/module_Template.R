library(shiny)

uiTemplate <- function(id, dirLookUps, database){
  rounds_v <- unique(database$round)
  divisions_lkp <- rio::import(file.path(dirLookUps, "divisions.csv"))
  divisions_v <- c("Malawi",divisions_lkp[["division_nam"]])
  
  #districts_lkp <- rio::import(file.path(dirLookUps, "districts.csv"))
  
  tagList(
    sidebarLayout(
      
      sidebarPanel(width = 3, class = 'form',
                   uiForm(id, dirLookUps = dirLookUps, rounds = rounds_v, divisions = divisions_v)
                  
                   ),
      mainPanel(width = 7,
                shinycssloaders::withSpinner(plotOutput(NS(id, "plot")), type = 5, color = "black"),
                tableOutput(NS(id,"table")))
      
    )
    
  
    )
}

  



