#' plot densities
#' 

# 
plot_density <- function(database = data_division(),
                         by_time = inputs$x_var_plot()$across_time,
                         x_label = parameters_panel()$indicator_label,
                         wrap_var = parameters_panel()$x,
                         rounds = rounds
){
  
  
  plot <- database %>%
    ggplot() +
    geom_density(aes(x = targetvar, fill = round, color = round)) +
    labs(x =  x_label) +
    scale_fill_manual(values = alpha(colors_rounds_rainbow, .5), name = "") +
    scale_color_manual(values = colors_rounds_rainbow, name = "")
  
  
  #aggregate national or division level
  if(by_time){
    
    plot <- plot 
    # +
    #   geom_vline(aes(xintercept = mean(targetvar, na.rm = T)),
    #              linetype = "dashed", size = 0.6,
    #              color = "#FC4E07")
    
  }
  
  
  #plot divisions and districts and wrap over time
  if(!by_time){
    
    plot <- plot +
      # geom_vline(data = plyr::ddply(database,
      #                               c(wrap_var,"round"),
      #                               summarize,
      #                               wavg = mean(targetvar, na.rm = T)), aes(xintercept=wavg, color = paste("Mean",round)), 
      #            linetype = "dashed", size = 0.5
      # ) +
      facet_wrap(~ .data[[wrap_var]]) +
       # scale_color_manual(name = "",
       #                    values = colors_rounds
       #                    ) +
     ggplot2::scale_y_continuous(expand = c(0,0))
    
  }
  
  return(plot)
  
}

