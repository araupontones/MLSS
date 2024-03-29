#create look up tables

library(googlesheets4)
library(dplyr)
library(tidyr)
library(stringr)

#import school data to get districts and divisions
school_ref <- rio::import("data/imports/school.rds")


#URL of google sheet

#url_gsh <- "https://docs.google.com/spreadsheets/d/1S2X-fXJ0hb5r0m5JUury7I7Yqg0IAPmISBec57RQYFU/edit#gid=1306872261"

dir_lookups = "data/reference/lookups"
variables_excel <- file.path(dir_lookups, "MLSS_dashboard.xlsx")


niveles <- c("school", "teacher", "student")

districts_mesip <- c("Chikwawa", "Dedza", "Kasungu", "Lilongwe Rural West", 
                     "Machinga", "Mangochi", "Mzimba South", "Thyolo", "Dowa", 
                     "Mulanje", "Nkhotakota", "Rumphi")


#create directory for each level (schol, teacher, students)
create_dirs <- sapply(niveles, function(x){
  
  dir_nivel <- file.path(dir_lookups, x)
  
  if(!dir.exists(dir_nivel)){
    
    dir.create(dir_nivel)
  }
  
})







#create lookups for target vars and dropdown vars ==============================

create_lookups <- sapply(niveles, function(x){
  
  exdir <- file.path(dir_lookups, x)
  
  gsheet <- rio::import(variables_excel, sheet = x) 
    
  
    #read_sheet(ss = url_gsh, sheet = x)

  #create lookup for target vars (vars that must be included)

  target_vars <- gsheet %>%
    select(!starts_with("...")) %>%
    rename(dropdown = `Dropdown indicator`) %>%
    filter(Dashboard == T) %>%
    filter(var_name !="") %>%
    mutate(dropdown = if_else(is.na(dropdown), TRUE, FALSE))

  rio::export(target_vars, file.path(exdir, glue::glue("target_vars_{x}.csv")))

  print(names(target_vars))
  #lookup of vars that go in dropdown menu
  dropdown_vars <- target_vars %>%
    filter(dropdown) %>%
    select(-c(format, Dashboard, Filter)) %>%
    mutate(label = str_to_sentence(label))

  rio::export(dropdown_vars, file.path(exdir, glue::glue("dropdown_vars_{x}.csv")))
  
  
  
  

  })




districts_MESIP <- school_ref %>%
  select(division_nam, district_nam) %>%
  filter(district_nam %in% districts_mesip) %>%
  group_by(division_nam, district_nam) %>%
  slice(1) %>%
  ungroup()

rio::export(districts_MESIP, file.path(dir_lookups, "districts_mesip.csv"))


View(districts_MESIP)

# create lookups for divisions, districts, and schools =========================


#DIVISIONS
geo <- school_ref %>%
  select(starts_with("division"), starts_with("district"))

divisions_lkp <- geo %>%
  select(starts_with("division")) %>%
  group_by(division_nam) %>%
  slice(1) %>%
  ungroup()

View(divisions_lkp)
rio::export(divisions_lkp,file.path(dir_lookups,"divisions.csv"))


#DISTRICTS 
districts_lkp <- geo %>%
  group_by(district_nam) %>%
  slice(1) %>%
  ungroup()

View(districts_lkp)  
rio::export(districts_lkp,file.path(dir_lookups,"districts.csv"))


# Schools

schools_lkp <- school_ref %>%
  select(school_id, starts_with("division"), starts_with("district")) %>%
  arrange(school_id)


rio::export(schools_lkp,file.path(dir_lookups,"schools.csv"))

