library(shiny)

uiTemplate <- function(id, dirLookUps, dirImports){
  
  #rounds from imports directories
  dirs_in_imports <- list.dirs(dirImports)
  rounds_in_dists <- dirs_in_imports[which(str_detect(dirs_in_imports, "Round"))]
  rounds_v <- str_extract(rounds_in_dists, "([^\\/]+$)")
  

  
  #selection of vars from lookup
  divisions_lkp <- rio::import(file.path(dirLookUps, "divisions.csv"))
  divisions_v <- c("Malawi",divisions_lkp[["division_nam"]])
  
  #districts_lkp <- rio::import(file.path(dirLookUps, "districts.csv"))
  
  tagList(
    sidebarLayout(
      
      sidebarPanel(width = 3, class = 'form',
                   uiForm(id, dirLookUps = dirLookUps, rounds = rounds_v, divisions = divisions_v)
                  
                   ),
      mainPanel(width = 8,
               uiOutput(NS(id,"header")),
               reactableOutput(NS(id,"table")),
               shinycssloaders::withSpinner(plotOutput(NS(id, "plot")), type = 5, color = color_spinner)
      )
               
      
      
    )
    
  
    )
}

  




