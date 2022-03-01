#' bar plot

plot_bar  <- function(database,
                     x = parameters_panel()$x,
                     y_label =  parameters_panel()$indicator_label,
                     x_label  = parameters_panel()$x_lab
){
  
  plot <- database %>%
    ggplot(aes(x = reorder(.data[[x]],-mean),
               y = mean,
               fill = round)) +
<<<<<<< HEAD
    geom_col(position = "dodge2") +
    labs(y = y_label,
         x = x_label) +
    scale_fill_manual(name = "Round",
                      values = c("#053657", '#0071bc', "#A3DAFF")) +
=======
    geom_col(position = "dodge2",
             width = .8) +
    labs(y = y_label,
         x = x_label) +
    scale_fill_manual(name = "Round",
                      values = c(alpha("#053657",.9),
                                 alpha('#0071bc',.9),
                                 alpha("#A3DAFF"), .9)
                      )+
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
    theme_MLSS()
  
  return(plot)
  
}
  