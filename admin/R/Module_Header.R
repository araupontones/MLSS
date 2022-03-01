uiHead <-function(id){
  
  tagList(
    tags$head(
      tags$link(rel = 'stylesheet', href = 'styleAdmin.css')
    ),
    shinyFeedback::useShinyFeedback(),
    
    tags$div(class = 'row container-nav',
             tags$div(class = 'col-4',
                      
                      tags$ul(
                        tags$li(tags$a("Home", href = "http://198.211.96.106") ,class = 'item'),
                        tags$li(tags$a("Background"),href = "http://198.211.96.106/about.html", class = 'item'),
                        tags$li(tags$a("Dashboard"), href = "http://198.211.96.106:3838/MLSS/dashboard/",class = 'item')
                        
                      )
                      
             )
             
    ),
    
    tags$a(href = "http://198.211.96.106:3838/MLSS/admin-guide/", "Admin guide", target = "_blank")
    
  )
  
}

