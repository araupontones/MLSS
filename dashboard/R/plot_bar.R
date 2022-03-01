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
    geom_col(position = "dodge2",
             width = .8) +
    labs(y = y_label,
         x = x_label) +
    scale_fill_manual(name = "Round",
                      values = c(alpha("#053657",.9),
                                 alpha('#0071bc',.9),
                                 alpha("#A3DAFF"), .9)
                      )+
    theme_MLSS()
  
  return(plot)
  
}
  