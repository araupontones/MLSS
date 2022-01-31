#' creates a message for the user if an upload is missing any og the reference variables

create_dialog_vars <- function(error_vars,
                          id_button = "close_error_school_names",
                          nivel = "school"){

modalDialog(
  HTML(paste("<b> The following variables are not in the", nivel, "uploaded file:</b><br><br>",error_vars, 
             "<br><br><b> Please verify the names of the variables in the",nivel, "file and upload again")),
  title = paste("Error in names of", nivel, "file"),
  footer = tagList(
    actionButton(id_button, "Close", class = "btn btn-danger")
  )
)

}



