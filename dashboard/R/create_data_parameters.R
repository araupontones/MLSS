#'create parameters for data and plots
#'Depending on the user selections this function returns
#'@param region selction og input$region
#'@param by_time Whether the data will be displayed by rounds (only for Malawi and Division level)
#'@param by_divisions whther the data will be grouped by divisions
#'@param by_districts whether the data will be grouped by districts
#'@returns tile: tile of the panel
#'y_lab: label of the Y axis of the plot
#'x: variable of the x asis of the plot
#'y: variable of the y axis of the plot
#'group: variable to group the data for summarizing
#'color : Pending (color of the chart)


create_data_parameters <- function(region,
                                   by_time,
                                   by_divisions,
                                   by_districts){
  
  
  
  
  #region <- input$division
  
  if(by_time){
    
    title <- region
    y_lab = "Round"
    x = "round"
    y = "mean"
    group = "round"
    color = ""
  }
  
  if(by_divisions){
    
    title <- paste("Divisions Of Malawi")
    y_lab = "Division"
    x = "division_nam"
    y = "mean"
    group = "division_nam"
  } 
  
  if(by_districts){
    
    title <- paste("Districts Of", region)
    y_lab = "District"
    x = "district_nam"
    y = "district_nam"
    group = "district_nam"
  }
  
  
  lista <-  list(title = title, x = x,y = y, group = group, y_lab = y_lab)
  
  return(lista)
  
  
  
  
}
