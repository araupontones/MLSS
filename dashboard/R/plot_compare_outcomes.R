#' plot to compare outcomes by group characteristics
#' 



#across time for Districts and provinces
plot_compare_outcomes <- function(database,
                                  x = parameters_panel()$x,
                                  name_fill = input$compare,
                                  y_label =  parameters_panel()$indicator_label,
                                  x_label = parameters_panel()$x_lab
                                  
                                  ){
  
  
  plot <- database %>%
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
    facet_wrap(~ round,
               ncol = 3) +
    theme(axis.text.x = element_text(angle = 90))
  
  return(plot)
  
  
}


#plot across time of Malawi or Province --------------------------------------
plot_compare_outcomes_time <- function(database,
                                  name_fill = inputs$compare_var_label(),
                                  y_label =  inputs$var_label(),
                                  level = id,
                                  plot_type = inputs$plot_type()
                                 
){
  
  plot <- ggplot(database,
                 aes(
                   x = round,
                   y = mean,
                   fill = fill)
  )
  
  
  if(plot_type == "Bar Plot"){
    
    plot <- plot +
    geom_col(position = "dodge2",
             width = .7) 
    
  }
  
#line plot --------------------------------------------------------------------
  if(plot_type == "Line Plot"){
  
   plot <- plot +
     geom_line(aes(group = fill,
                   color = fill),
               size = size_line,
               show.legend = F)+
     geom_point(shape = 21,
                size = size_points,
                stroke = stroke_size,
                color = color_line) +
     scale_color_manual(values = c(color_yes, color_no))
     
  }
  
  
  plot <- plot + 
    scale_fill_manual(name = paste(str_to_title(level),name_fill),
                      breaks = c("Yes", "No"),
                      values = c(alpha(color_yes, .9), alpha(color_no, .7))
    ) +
    labs(y = y_label,
         x = "Rounds")
  
    
  
  return(plot)
}

