
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
  
}
