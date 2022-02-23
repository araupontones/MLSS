#' enambling conditions form

#' compare by characteristics module ============================================


select_chars <- function(id, inputID, indicator_type, label, choices){
  
  if(indicator_type!= "binary"){
    tagList(
      selectInput(NS(id,"compare"), label = label, choices = choices)
    )
      }
   else {
    
    
  }


}


#' Display module ==============================================================

buttons_display <- function(id,inputId, selected_division, label = "Display"){
  
  if(selected_division == "Malawi"){
    choices = c("Across time","With other divisions")
    #radioButtons(NS(id,"compare_divisions"), "Display",choices = c("Across time", "Divisions"))
    
  } else {
    
    choices = c("Across time","With other divisions", "Districts within")
    #radioButtons(NS(id,"compare_divisions"), "Display",choices = c("Across time","With other divisions", "Districts within"))
  }
  
  
  
  tagList(
    radioButtons(NS(id,inputId), label,choices = choices)
  )
  
}


#' ROunds module =============================================================
#
select_rounds <- function(id, inputId, label, across_time, choices){
  
  if(across_time){
    
    
  } else {
    tagList(
      
      selectInput(NS(id,inputId), label, choices = choices, multiple = T, selected = choices[1])
      
    )
    
  }
  
  
}


#' Plots module ===============================================================



select_plot <- function(id, inputId, label, indicator_type, compare_groups){
  
  show_all <- indicator_type != "binary" & !compare_groups
  
  if(show_all){
    tagList(
      selectInput(NS(id,"plot_type"), "Plot Type", choices = c("Bar Plot","Box Plot", "Density Plot"))
    )
    
  } else {
    tagList(
      
      selectInput(NS(id,"plot_type"), "Plot Type", choices = c("Bar Plot"))
    )
    
    
    
  }
  
  
}



