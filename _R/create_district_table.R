#' creates a database with summary indicators by district at the 3 levels (school, teachers, students)



library(dplyr)
library(tidyr)
options(scipen=999)

#define input directories ------------------------------------------------------
dir_lks <- "data/reference/lookups"
dir_imports <- "data/imports"
exfile_districts <- "data/imports/district.rds"



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
get_vars <- function(db,type){
  
  db$var_name[db$type == type]
}

get_label <- function(db,x){
  
  label <- db$label[db$var_name == x]
  
  if(label == ""){
    label <- db$var_name[db$var_name == x]
    
  }
  
  return(label)
  
}


#' Summarize indicator 
#' @param  label label of the selected indicator
#' @return a data base with indicators by district and level

sum_indicator <- function(.data, label, level){
  .data %>%
  group_by(round) %>%
    mutate(National = round(mean(target, na.rm = T), digits = 2), .groups = 'drop') %>%
    group_by(round, division_nam, district_nam, National) %>%
    summarise(mean = round(mean(target, na.rm = T), digits = 2),
              N = sum(!is.na(target)),
              .groups = "drop") %>%
    rename(label = mean) %>%
    #transform to long for better display in dashboard 
    pivot_longer(label,
                 names_to = "indicator") %>%
    mutate(indicator = label,
           level = level) %>%
    select(division_nam, district_nam, 
           Level = level,
           Round = round, 
           Indicator = indicator,
           value, 
           N, 
           `National Average` = National) 
  
  
}


#Create table for districts ====================================================

#define levels parameters
levels <- c("school", "teacher", "student")


sum_districts <- lapply(levels, function(level){
 
  message(level)
  #import files ------------------------------------------------------------------
 
  print(lkp_file(level))
  
  db <- rio::import(import_file(level))
  lkp <- rio::import(lkp_file(level)) %>% select(var_name, type, label)
   
  #define vectors by variable type -----------------------------------------------
  id_vars <- c("division_nam", "district_nam")
  cont_vars <- get_vars(db = lkp,"continous")
  bin_vars <- get_vars(db = lkp, "binary")
  perc_vars <- get_vars(db = lkp,"percentage")


  
  
  # Creates summary table at the district level for continous variables =========
  cont_list <- lapply(cont_vars, function(x){
    
    
    #get the label of the variable
    label <- get_label(lkp, x)
    
    
    db %>%
      select(all_of(c(x, id_vars, "round"))) %>%
      rename(target = x) %>%
      sum_indicator(label = label, level = level) 
    
  })
  
  cont_data <- do.call(rbind, cont_list)
  

  # Creates summary table at the district level for percentage variables =========
  perc_list <- lapply(perc_vars, function(x){
    
    
    #get the label of the variable
    #label <- lkp$label[lkp$var_name == x]
    label <- get_label(lkp, x)
    
    db %>%
      select(all_of(c(x, id_vars, "round"))) %>%
      rename(target = x) %>%
      sum_indicator(label = label, level = level) %>%
      mutate(value = scales::percent(value, accuracy = 1),
             `National Average` = scales::percent( `National Average`, accuracy = 1)) 
    
  })
  
  perc_data <- do.call(rbind, perc_list)
  
  # Creates summary table at the district level for binary variables =========
  binary_list <- lapply(bin_vars, function(x){
    
    
    #get the label of the variable
    #label <- lkp$label[lkp$var_name == x]
    label <- get_label(lkp, x)
    
    db %>%
      select(all_of(c(x, id_vars, "round"))) %>%
      rename(target = x) %>%
      mutate(target = case_when(target == 1 ~ 1,
                                target == 3 ~ NA_real_,
                                is.na(target) ~ NA_real_,
                                T ~ 0)) %>%
      sum_indicator(label = label, level = level) %>%
      mutate(value = scales::percent(value, accuracy = 0.1),
             `National Average` = scales::percent( `National Average`, accuracy = 0.1)) 
    
  })
  
  binary_data <- do.call(rbind, binary_list)
  
  district_data <- rbind(cont_data, perc_data, binary_data)
  
  return(district_data)
 
  
})




names(sum_districts) <- levels
district_data <- tibble(do.call(rbind, sum_districts))




rio::export(district_data, exfile_districts)

#end
