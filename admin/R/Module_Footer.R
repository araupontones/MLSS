uiFooter <- function(id){
  
  tagList(
    
    #logos
    
    tags$div(class = 'row container-logos text-center',
             
             tags$img(src="imgs/malawi-logo.jpeg", class = "logo" ),
             
             
             tags$img(src="imgs/wb-logo.svg", class = "logo logo-wb" )
             
    ),
    
    tags$div(class = 'row container-footer',
             tags$p(class = 'admin_text',
                    "For any question, please contact",
                    tags$a(href="mailto:someone@example.com?Subject=Shiny%20aManager", 
                           "administrator", target ="_top" )
             )
    )
    
    
    
  )
}