#. check that user uploaded a file and confirm if she wants to proceed


countZipFiles <- function(id, inputs){
  
  moduleServer(id, function(input, output, session){
    
    #check that file is a zip file  
    showNotification("Checking format of upload", type = "warning")
    
    #format of imports
    ext <- eventReactive(inputs$upload(),{
      
      tools::file_ext(inputs$upload()$name)
    })
    
    
    #message if it isnt a zip file
    observeEvent(ext(),{
      
      shinyFeedback::feedbackDanger("upload", ext() !="zip", "The upload must be a zip file. Please verify")
      
    
    })
    
    
    tempDir <- reactive(tempdir())
    
    #get name of tempfiles 
    tempfiles <- eventReactive(ext(),{
      
      #only continue if it is a zipfile
      req(ext() == "zip")
      
      
      showNotification("Reading uploaded files", type = "warning")
      
    
      #remove old files or unzip in tempdir  
      temps_stata_files <- return_uploaded_files(from =inputs$upload()$datapath , to = tempDir())
      
      
      temps_stata_files
      
      
      
    })
      
    
    #count tomber of files
    file_num <- eventReactive(tempfiles(),{
      
      ##check that number of uploaded files is 3----------------------------------
      size_num <- length(tempfiles())
      shinyFeedback::feedbackDanger("upload", size_num!=3, "The zip file must conaint 3 files")
      
      size_num
      
    })
    
     
      
    observeEvent(file_num(),{
      
      #message if file num is less than 3
      req(file_num() != 3)
        
        modal_error_number_files <- modalDialog(
          HTML(paste("<b>",size_num,"</b> files have been uploaded.",
                     "But 3 files are expected (school, teacher, and student).",
                     "<br><br> Please verify and upload again.")),
          title = "Error in file names",
          footer = tagList(
            actionButton("close_error_num_files", "Close", class = "btn btn-danger"),
            
          )
        )
        
        showModal(modal_error_number_files)
        
        
      
      
    })


      list(
        file_num = file_num,
        tempfiles = tempfiles,
        tempDir = tempDir
        
      )
    

      
    })
    
    
    
    
    
    

  
}