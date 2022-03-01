#. check that user uploaded a file and confirm if she wants to proceed


validateForm <- function(id, inputs, rounds,confirmDirs){
  
  moduleServer(id, function(input, output, session){
    cli::cli_alert("Asking user")
    #3. check that user uploaded a file and confirm if she wants to proceed
    observeEvent(inputs$sendData(),{
      
      #check that a file has been uploaded
      files_sent <- length(inputs$upload())
      shinyFeedback::feedbackDanger("upload", files_sent == 0, "Upload a file")
      
      
      req(inputs$upload())
      
      #check that user has selected a round 
      check_selected_round <- inputs$round() %in% rounds
      shinyFeedback::feedbackDanger("round", !check_selected_round, "Select the round of the upload")
      
      req(check_selected_round)    
      
      #Confirm with user if wants to proceed (defined in text_message round)
      modal_confirm <- modalDialog(
        HTML(confirmDirs$existe()$message),
        title = paste("Uploading data from", inputs$round()),
        footer = tagList(
          actionButton("ok", "Upload", class = "btn btn-primary"),
          actionButton("cancel", "Cancel", class = "btn btn-danger")
        )
      )
      
      showModal(modal_confirm)
      
     
     
    })
    
    
    
    
  })
  
}
