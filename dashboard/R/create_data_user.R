#'creates data for plot based on user's selections
#' @param db Database imported to dashboard
#' @param indicator_user input$indicator
#' @param divisions_user = divisions_selected(),
#' @param rounds_user = rounds_selected(),
#' @param indicator_type = indicator_type() this comes from look up table
#' @param plot_user = input$plot_type, 
#' @param by_divisions = group_by_divisions(),
#' @param by_districts = group_by_districts(),
#' @param parameters_group = parameters_panel()$group,
#' @paramby_time = across_time()
#' 
#' @returns a dataframe to be plotted in the reactive plot


create_data_user <- function(db,
                             indicator_user,
                             divisions_user,
                             rounds_user,
                             indicator_type,
                             plot_user, 
                             by_divisions,
                             by_districts,
                             parameters_group,
                             by_time,
                             by_other_vars,
                             fill){
  
 
  
  #to compare outcomes by characteristics -------------------------------------
  if(by_other_vars){
    
    
    data_user <- db %>% 
      ungroup() %>%
      select(targetvar = indicator_user,
             fill = fill,
             division_nam, district_nam, round) %>%
      filter(division_nam %in% divisions_user) %>%
      filter(round %in% rounds_user) %>%
      mutate(fill = case_when(fill == 1 ~ "Yes",
                              fill == 3 ~ NA_character_,
                              T ~ "No")) 
    
    if(parameters_group == "round"){
      
      data_user <- data_user %>% 
        group_by(.data[[parameters_group]], .data[["fill"]]) %>%
        summarise(mean = mean(targetvar, na.rm = T), .groups = 'drop')
      
    } else {
      data_user <- data_user %>% 
        group_by(.data[[parameters_group]], .data[["fill"]], round) %>%
        summarise(mean = mean(targetvar, na.rm = T), .groups = 'drop')
      
    }
    
  }
  
  #if user does not want to compare outcomes by characteristics ----------------
  if(!by_other_vars){
    
    data_user <- db %>%
      select(targetvar = indicator_user,
             division_nam, district_nam, round) %>%
      filter(division_nam %in% divisions_user) %>%
      filter(round %in% rounds_user)
    
    
    
    
    #correct misscoding of binary vars
    if(indicator_type == "binary"){
      
      data_user <- data_user %>%
        mutate(targetvar = case_when(targetvar == 2 ~ 0,
                                     targetvar == 3 ~ NA_real_,
                                     T ~ 1))
      
    }
    
    if(plot_user == "Bar Plot"){
      #summarise by round
      if(by_time){
        
        data_user <- data_user %>% group_by(round) %>% summarise(mean = mean(targetvar, na.rm = T, .groups = "drop"))
      }
      
      #summarise by level of interest and round
      if(by_districts | by_divisions){
        
        
        data_user <- data_user %>%
          group_by(.data[[parameters_group]], .data[["round"]]) %>%
          summarise(mean = mean(targetvar, na.rm = T, .groups = "drop"))
      }
      
    }
    
  }
  
  return(data_user)
  
  
}




