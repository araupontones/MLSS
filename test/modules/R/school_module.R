library(shiny)

uiSchool <- function(id, dirLookUps){
  
  
  tagList(
    sidebarLayout(
      
      sidebarPanel(width = 3, class = 'form',
                   uiForm(id, dirLookUps = dirLookUps)
                   ),
      mainPanel(width = 7)
      
    )
    
  
    )
}

  



