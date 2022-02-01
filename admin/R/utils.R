#'useful functions
#'

#' define project directory

define_project_dir <- function(repoName = "MLSS"){
  
  if(Sys.info()["sysname"] == "Windows"){
    
    project_path <- dirname(getwd())
    #project_path <- dirname(dash_path)
    
  } else {
    
    project_path <- glue("~/{repoName}")
    #dash_path <- file.path(project_path, "dashboard")
    #project_path <- dirname(dash_path)
    
  }
  
  return(project_path)
  
}



#'create a tible with information of uploades accepted by the server

#' @param  files directory


create_summary_files <- function(dir_imports){
  
  files_import <- list.files(dir_imports, recursive =T,pattern = ".rds", full.names = T  )
  lista <- lapply(files_import, function(x){file.info(x)})
  tabla <- do.call(rbind, lista)
  tibble <- tibble(tabla,
                   upload = row.names(tabla)) %>%
    select(upload, size,
           `Modified` = mtime,
           `Accessed` = atime) %>%
    mutate(across(c(Modified, Accessed), function(x) format(x, "%B %d %Y %H:%M")))
  
}
