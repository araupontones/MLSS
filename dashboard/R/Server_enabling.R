
options_time <- function(input_division){
  
  if(input_division == "Malawi"){
    t = radioButtons(NS(id,"compare_divisions"), "Display",choices = c("Across time", "Divisions"))
    
  } else {
    
    t = radioButtons(NS(id,"compare_divisions"), "Display",choices = c("Across time","With other divisions", "Districts within"))
  }
  
  return(t)
  
}


