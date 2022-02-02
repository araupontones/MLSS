
library(googlesheets4)

dir_reference = "data/reference"



# gs4_create("MLSS_dashboard",
#            sheets = c("school", "teacher", "student")
# )


#URL of google sheet

url_gsh <- "https://docs.google.com/spreadsheets/d/1S2X-fXJ0hb5r0m5JUury7I7Yqg0IAPmISBec57RQYFU/edit#gid=1306872261"


#write sheets
for(nivel in c("school", "teacher", "student")){
  
  infile = file.path(dir_reference, glue::glue("{nivel}_vars.csv"))
  ref <- import(infile)
  
  ref_vars <- ref %>%
    mutate(`Name dropdown`= "",
           `Description`= "")
  
  write_sheet(ref_vars, ss = url_gsh, sheet = nivel)
}
