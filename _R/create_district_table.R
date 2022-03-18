#' creates a database with summary indicators by district at the 3 levels (school, teachers, students)

library(dplyr)
options(scipen=999)

#define input directories ------------------------------------------------------
dir_lks <- "data/reference/lookups"
dir_imports <- "data/imports"



#Utils ------------------------------------------------------------------------
#' creates path to lookup fie
#' @param level c(school, teacher, student)

lkp_file <- function(level){
  
  glue::glue("{dir_lks}/{level}/dropdown_vars_{level}.csv")
  
}

#' creates path to imported file 
#' @param level c(school, techer, student)

import_file <- function(level){
  
  glue::glue("{dir_imports}/{level}.rds")
}

#'gets the type of the variable from the look up table
#' @param type c(continous, percentage, binary)
get_vars <- function(type){
  
  lkp$var_name[lkp$type == type]
}


#import files ------------------------------------------------------------------
lkp_file("school")
import_file("school")

db <- rio::import(import_file("school"))
lkp <- rio::import(lkp_file("school")) %>% select(var_name, type, label)


#define vectors by variable type -----------------------------------------------
id_vars <- c("school_id", "division_nam", "district_nam")
cont_vars <- get_vars("continous")
bin_vars <- get_vars("binary")
perc_vars <- get_vars("percentage")



# Creates summary table at the district level for continous variables =========
cont_list <- lapply(cont_vars, function(x){
  
  
  #get the label of the variable
  label <- lkp$label[lkp$var_name == x]
  
  
  db %>%
    select(all_of(c(x, id_vars, "round"))) %>%
    rename(target = x) %>%
    group_by(round, division_nam, district_nam) %>%
    summarise(mean = mean(target, na.rm = T),
              N = sum(!is.na(target)),
              .groups = "drop") %>%
    rename(label = mean) %>%
    #transform to long for better display in dashboard 
    pivot_longer(label,
                 names_to = "indicator") %>%
    mutate(indicator = label,
           level = "school") %>%
    select(division_nam, district_nam, level,round, indicator, value, N )
  
})

cont_data <- do.call(rbind, cont_list)

#end
