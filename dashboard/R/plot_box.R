
plot_box <- function(database,
                     by_time = across_time(),
                     x = parameters_panel()$x,
                     y_label = parameters_panel()$indicator_label,
                     x_label = parameters_panel()$x_lab,
                     across_time = inputs$x_var_plot()$across_time
                     ){
  
  
  data_plot <- database %>%
    group_by_at(x) %>%
    mutate(order = mean(targetvar, na.rm = T)) %>%
    ungroup() 
  
  
  
  if(across_time){
    
    
    plot <- data_plot %>%
      ggplot(aes(y = targetvar,
                 x = round))
  } else {
    
    plot <- data_plot %>%
      ggplot(aes(y = targetvar,
                 x = reorder(.data[[x]],-order)
      ))
  }
  
   plot <- plot +
    geom_boxplot(binaxis='y', stackdir='center', dotsize=1, fill = alpha(color_yes, .5)) +
    #geom_jitter(shape=16, position=position_jitter(0.2))  +
    labs(y =  y_label,
         x = x_label) 
  
  
  if(!by_time){
    
    plot <- plot + facet_wrap(~ round,
                              ncol = 3) +
      theme(axis.text.x = element_text(angle = 90))
  }
  
  return(plot)
  
}

