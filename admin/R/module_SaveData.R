#' verifies if directory selected round exists.
#' Captures: message to confirm with user, and boolean to replace or create dirs
#' If if doesn exists: confirms with the user 
#' If exists:  confirmst replacement


saveData <- function(id, confirmDirs, vars_ok,inputs, survey_levels, dirLookUps){
  
  moduleServer(id, function(input, output, session){
    
    
    saveDir <- eventReactive(vars_ok$student_vars(),{
      
      req(vars_ok$student_vars() == "OK") 
      
      confirmDirs$dir_uploads()
      
      })
    
    
   
    #create directory for this round
    save_file <- eventReactive(saveDir(),{
      
     if(!dir.exists(saveDir())){
       
       dir.create(saveDir())
     }
      
      
      temps_stata_files <- return_uploaded_files(from =inputs$upload()$datapath , to = tempdir())
      
  
      
      lapply(survey_levels, function(nivel){

        showNotification(paste("Saving uploads of", nivel, "into server"), type = "warning")

        
      
        #read reference lookups  
        data_look_up <- import(file.path(dirLookUps, nivel,  glue::glue("target_vars_{nivel}.csv")))
        reference_vars <- data_look_up$var_name
     
        #read uploaded file
        tempofile <- temps_stata_files[which(str_detect(temps_stata_files, nivel))]
        data_upload <- rio::import(tempofile) %>%
            select(all_of(reference_vars)) %>%
            mutate(round = inputs$round()) 
        
        
        #fetch districts to teachers' data
        if(nivel == "teacher"){
          
          districts <- import(file.path(confirmDirs$dir_uploads(),"school.rds")) %>%
            group_by(school_id) %>%
            slice(1) %>%
            ungroup() %>%
            select(school_id, division_nam, district_nam)
          
          
          data_upload <- data_upload %>%
            left_join(districts, by = "school_id")
          
          
          
        }
        
        
        #define exfile
        exfile <- file.path(confirmDirs$dir_uploads(), paste0(nivel,".rds"))
         
        

         #delete temp file
         unlink(tempofile)
         
         rio::export(data_upload, exfile)
        

      })
      
      
     
      
      
    })
    
  
    data_saved <-eventReactive(saveDir(),{
      
      "OK"
      
    })
    
    save_file
   
  })
  
}