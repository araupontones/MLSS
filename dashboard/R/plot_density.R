#' plot densities
#' 

# 
plot_density <- function(database = data_division(),
                         by_time = across_time(),
                         x_label = parameters_panel()$indicator_label,
                         wrap_var = parameters_panel()$x,
                         rounds = rounds
){
  
  
  plot <- database %>%
    ggplot() +
    geom_density(aes(x = targetvar, fill = round)) +
    labs(x =  x_label) +
    scale_fill_manual(values = c(alpha('#053657', .5), alpha('#0071bc', .5), alpha('#A3DAFF', .5)))
  
  
  #aggregate national or division level
  if(by_time){
    
    plot <- plot +
      geom_vline(aes(xintercept = mean(targetvar, na.rm = T)),
                 linetype = "dashed", size = 0.6,
                 color = "#FC4E07")
    
  }
  
  
  #plot divisions and districts and wrap over time
  if(!by_time){
    
    plot <- plot +
      geom_vline(data = plyr::ddply(database,
                                    c(wrap_var,"round"),
                                    summarize,
                                    wavg = mean(targetvar, na.rm = T)), aes(xintercept=wavg, color = paste("Mean",rounds)),
                 linetype = "dashed", size = 0.7
      ) +
      facet_wrap(~ .data[[wrap_var]]) +
      scale_color_manual(name = "",
                         values = c("black", "red", "blue"))
    
  }
  
  return(plot)
  
}

