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
    geom_col(position = "dodge2") +
    labs(y = y_label,
         x = x_label) +
    scale_fill_manual(name = "Round",
                      values = c("#053657", '#0071bc', "#A3DAFF")) +
    theme_MLSS()
  
  return(plot)
  
}
  