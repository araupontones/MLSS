#' verifies if directory selected round exists.
#' Captures: message to confirm with user, and boolean to replace or create dirs
#' If if doesn exists: confirms with the user 
#' If exists:  confirmst replacement


confirmDirsExist <- function(id, inputs, dirImports){
  
  moduleServer(id, function(input, output, session){
    
    #1. define directory to store uploads based on input round
    dir_uploads <- reactive({
      req(inputs$round())
      file.path(dirImports, inputs$round())
      
    })
    
    
    
    #2. Define message to tell user what round of data is that she uploading
    existe <- reactive({
      
      req(inputs$sendData(), inputs$round())
      print(dir_uploads())  
      #check if round exists in imports
      existe <-  dir.exists(dir_uploads())
      
      
      #get time of last modification
      if(existe){
        exists_and_files <- length(list.files(dir_uploads())) > 0 #if there's data stored
        info_file <- file.info(dir_uploads())
        date_file <- format(info_file$atime[1], "%B %d %Y at %H:%M") 
        
      } else {
        
        exists_and_files <- FALSE
      }
      
      #define message to confirm with the user
      message <- ifelse(existe & exists_and_files,
             paste("Data for", inputs$round(), "was uploaded on",date_file ,"<br><br><b>Do you want to replace it?</b>"),
             paste("Uploading data for", inputs$round(), "<br><br><b>Do you want to continue?</b>")
      )
      
      
      list(
        message = message,
        replace = existe & exists_and_files,
        create = !(existe & exists_and_files)
       
      )
      
      
    })
    
    
    list(
      existe = existe,
      dir_uploads = dir_uploads
    )
    
    
    
    
  })
  
}