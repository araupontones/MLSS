# define User credentials
credentials <- data.frame(
  user = c("shiny", "andres", "admin"), # mandatory
  password = c("shiny", "andres", "admin"), # mandatory
  #start = c("2019-04-15"), # optinal (all others)
  #expire = c(NA, "2019-12-31"),
  admin = c(FALSE, TRUE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)


#Secure the app
uiLogin <- function(ui){
  
  secure_app(ui,
             # add image on top ?
             tags_top = 
               tags$div(
                 tags$h4("MLSS Dashboard", style = "align:center"),
                 tags$img(
                   src = "https://1000marcas.net/wp-content/uploads/2020/07/the-world-bank.jpg", width = 100
                 )
               ),
             tags_bottom = tags$div(
               tags$p(
                 "For any question, please  contact ",
                 tags$a(
                   href = "mailto:someone@example.com?Subject=Shiny%20aManager",
                   target="_top", "administrator"
                 )
               )
             )
  )
  
}
  
  
  