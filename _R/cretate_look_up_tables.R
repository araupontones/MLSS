#create look up tables

library(googlesheets4)



#URL of google sheet

url_gsh <- "https://docs.google.com/spreadsheets/d/1S2X-fXJ0hb5r0m5JUury7I7Yqg0IAPmISBec57RQYFU/edit#gid=1306872261"

dir_lookups = "data/reference/lookups"
niveles <- c("school", "teacher", "student")

create_dirs <- sapply(niveles, function(x){
  
  dir_nivel <- file.path(dir_lookups, x)
  
  if(!dir.exists(dir_nivel)){
    
    dir.create(dir_nivel)
  }
  
})



#create lookups for target vars and dropdown vars

create_lookups <- sapply(niveles, function(x){
  
  exdir <- file.path(dir_lookups, x)
  
  gsheet <- read_sheet(ss = url_gsh, sheet = x)

  #create lookup for target vars (vars that must be included)

  target_vars <- gsheet %>%
    rename(dropdown = `Dropdown indicator`) %>%
    filter(Dashboard == T)

  rio::export(target_vars, file.path(exdir, glue::glue("target_vars_{x}.csv")))


  #lookup of vars that go in dropdown menu
  dropdown_vars <- target_vars %>%
    filter(dropdown != FALSE) %>%
    select(-c(format, Dashboard, Filter))

  rio::export(target_vars, file.path(exdir, glue::glue("dropdown_vars_{x}.csv")))
  
  
  
  

  })



