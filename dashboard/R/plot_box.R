
plot_box <- function(database,
                     by_time = across_time(),
                     x = parameters_panel()$x,
                     y_label = parameters_panel()$indicator_label,
                     x_label = parameters_panel()$x_lab
                     ){
  
  plot <- database %>%
    ggplot(aes(y = targetvar,
               x = .data[[x]],
    )) +
    geom_boxplot(binaxis='y', stackdir='center', dotsize=1, fill = '#A8D1DF') +
    geom_jitter(shape=16, position=position_jitter(0.2))  +
    labs(y =  y_label,
         x = x_label)
  
  
  if(!by_time){
    
    plot <- plot + facet_wrap(~ round) 
  }
  
  return(plot)
  
}