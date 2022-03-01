#' plot to compare outcomes by group characteristics
#' 

plot_compare_outcomes <- function(database,
                                  x = parameters_panel()$x,
                                  name_fill = input$compare,
                                  y_label =  parameters_panel()$indicator_label,
                                  x_label = parameters_panel()$x_lab
                                  ){
  
  plot <- database %>%
<<<<<<< HEAD
    ggplot(aes(x = reorder(.data[[x]], -mean),
               y = mean,
               fill = fill)) +
    geom_col(position = "dodge2") +
    scale_fill_manual(name = name_fill,
                      values = c("#002244", "#009FDA")) +
=======
    mutate(fill = factor(fill,
                         levels = c("Yes", "No"))) %>%
    ggplot(aes(x = reorder(.data[[x]], -mean),
               y = mean,
               fill = fill)) +
    geom_col(position = "dodge2",
             width = .7) +
    scale_fill_manual(name = name_fill,
                      breaks = c("Yes", "No"),
                      values = c(alpha("#002244", .9), alpha("#009FDA", .7))
                      ) +
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
    labs(y = y_label,
         x = x_label) +
    facet_wrap(~ round)
  
  return(plot)
  
  
}

#reorder(.data[[x]],-mean),