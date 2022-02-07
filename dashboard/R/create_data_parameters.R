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


create_data_parameters <- function(dropdowns_v,
                                   compare_vars,
                                   indicator,
                                   indicator_compare,
                                   region,
                                   by_time,
                                   by_divisions,
                                   by_districts,
                                   by_other
                                   ){
  
  
  
  
  indicator_compare_label <- compare_vars$label[compare_vars$var_name == indicator_compare]
  indicator_label <- dropdowns_v$label[dropdowns_v$var_name == indicator]
  
  #region <- input$division
  
  if(by_time){
    
    title <- region
    x_lab = "Round"
    x = "round"
    y = "mean"
    group = "round"
    color = ""
  }
  
  if(by_divisions){
    
    title <- paste("Divisions Of Malawi")
    x_lab = "Division"
    x = "division_nam"
    y = "mean"
    group = "division_nam"
  } 
  
  if(by_districts){
    
    title <- paste("Districts Of", region)
    x_lab = "District"
    x = "district_nam"
    y = "district_nam"
    group = "district_nam"
  }
  
  if(by_other){
    
    subtitle <- paste(indicator_label, "by", indicator_compare_label)
  } else {
    
    subtitle <- indicator_label
  }
  
  lista <-  list(#panel title and subtitle
                title = title,subtitle = subtitle,
                #labels of indicators
                 indicator_label = indicator_label,
                 indicator_compare_label = indicator_compare_label,
                #chart parameters
                 x = x,y = y, group = group, x_lab = x_lab)
  
  return(lista)
  
  
  
  
}
