uiLinks <- function(id){
  tagList(
    tags$head(
      #fonts -------------------------------------------------
      
      tags$link(rel="preconnect", href="https://fonts.googleapis.com"),
      #Noto font
      tags$link(href="https://fonts.googleapis.com/css2?family=Noto+Serif&family=Roboto:wght@300&display=swap", rel="stylesheet"),
      tags$link( href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;700&display=swap", rel="stylesheet"),
      tags$title("MLSS-Dashboard"),
      
      #styles -----------------------------------------------
      tags$link(rel="stylesheet", href="styleDash.css")
    
  )
  
  )
  
}