#' plot to compare outcomes by group characteristics
#' 

plot_compare_outcomes <- function(database,
                                  x = parameters_panel()$x,
                                  name_fill = input$compare,
                                  y_label =  parameters_panel()$indicator_label,
                                  x_label = parameters_panel()$x_lab
                                  ){
  
  plot <- database %>%
    mutate(fill = factor(fill,
                         levels = c("Yes", "No"))) %>%
    ggplot(aes(x = reorder(.data[[x]], -mean),
               y = mean,
               fill = fill)) +
    geom_col(position = "dodge2",
             width = .7) +
    scale_fill_manual(name = name_fill,
                      breaks = c("Yes", "No"),
                      values = c(alpha(color_yes, .9), alpha(color_no, .7))
                      ) +
    labs(y = y_label,
         x = x_label) +
    facet_wrap(~ round)
  
  return(plot)
  
  
}

#reorder(.data[[x]],-mean),