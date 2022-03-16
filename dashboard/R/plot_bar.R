#' bar plot

plot_bar  <- function(database,
                     x = parameters_panel()$x,
                     y_label =  parameters_panel()$indicator_label,
                     x_label  = parameters_panel()$x_lab,
                     across_time = inputs$x_var_plot()$across_time
){
  
  
  if(across_time){
    
    plot <- database %>%
      ggplot(aes(x = round,
                 y = mean,
                 fill = round)
             )+
      geom_col(position = "dodge2",
               width = .8,
               show.legend = F)
    
} else {
    
  plot <- database %>%
    ggplot(aes(x = reorder(.data[[x]],-mean),
               y = mean,
               fill = round)) +
    geom_col(position = "dodge2",
             width = .8)
  
  }
  
  
  plot <- plot +
    labs(y = y_label,
         x = x_label) +
    scale_fill_manual(name = "Round",
                      values = alpha(colors_rounds, .9)
                      )+
    theme_MLSS()
  
  return(plot)
  
}
 

        