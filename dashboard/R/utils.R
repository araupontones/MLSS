<<<<<<< HEAD

=======
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
define_project_dir <- function(repoName = "MLSS"){
  
  if(Sys.info()["sysname"] == "Windows"){
    
    project_path <- dirname(getwd())
    #project_path <- dirname(dash_path)
    
  } else {
    
    project_path <- glue("/srv/shiny-server/{repoName}")
    #dash_path <- file.path(project_path, "dashboard")
    #project_path <- dirname(dash_path)
    
  }
  
  return(project_path)
  
<<<<<<< HEAD
}


#' to display selector by national level or Division level
#' Conditioned on user selecting Malawi or a Division

radioButtonsUser <- function(input_division){
  
  if(input_division == "Malawi"){
    butones <-radioButtons(NS(id,"compare_divisions"), "Display",choices = c("National Level", "Divisions"))
    
  } else {
    
    butones<- radioButtons(NS(id,"compare_divisions"), "Compare",choices = c("With other divisions", "Districts within"))
  }
  
  return(botones)
}
=======
}
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
