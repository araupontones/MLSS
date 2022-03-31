#geom line
color_line <- "#F0A85C" #same color as bg of form
size_points <- 5 
stroke_size <- 2
size_line <- 2



# one indicator over time (no comparing) ======================================  
plot_line <- function(database = database(),
                      display = inputs$display(),
                      y_label = inputs$var_label()
                      ){
  
    
  
  if(display == "round"){
    
    data_plot <- database
  } else{
    
    data_plot <- database %>%
      rename(wrap_var = display)
  }
  
  
  
  plot <- ggplot(data_plot,
                 aes(x = round,
                     y = mean,
                     group = 1))+
    geom_line(size = size_line,
              color = color_line)+
    geom_point(
      aes(
        color = round,
        fill = round
      ),
      alpha = .7,
      show.legend = F,
      shape = 21,
      size = size_points,
      stroke = stroke_size
    ) 
  
  
  if(display != "round"){
    
    
    plot <- plot + facet_wrap(~ wrap_var)
  
 }
  
  
  plot <- plot + 
    scale_fill_manual(values =  colors_rounds) +
    scale_color_manual(values =  colors_rounds) +
    labs(y = y_label,
         x = "")
  
  # 
  # if(display == "round"){
  #   
  #   plot <- ggplot(database,
  #          aes(x = round,
  #              y = mean,
  #              group = 1))+
  #     geom_line(size = 1,
  #               color = color_line)+
  #     geom_point(
  #       aes(
  #         #color = round,
  #         fill = round
  #          ),
  #       alpha = .1,
  #       show.legend = F,
  #       shape = 21,
  #       size = size_points,
  #       stroke = stroke_size
  #     ) 
  #     
  # } else{
  #   
  #   
  #   data_plot <- database %>%
  #     rename(wrap_var = display)
  #   
  #   plot <- ggplot(data_plot,
  #          aes(x = round,
  #              y = mean,
  #              group = 1))+
  #     geom_line(size = 1,
  #               color = color_line)+
  #     geom_point(
  #       aes( #color = round,
  #         fill = round
  #          ),
  #       alpha = .1,
  #       show.legend = F,
  #       shape = 21,
  #       size = size_points,
  #       stroke = stroke_size
  #     ) +
  #     facet_wrap(~ wrap_var)
  #   
  #   
  # }
  # 
  # plot <- plot + 
  #   scale_fill_manual(values =  colors_rounds) +
  #   scale_color_manual(values =  colors_rounds) +
  #   labs(y = y_label,
  #        x = "")
  # 
  
}


# Compare indicator by characteristics at the provine and district level

plot_line_compare <- function(database = database(),
                              display = inputs$display(),
                              level = id,
                              legend = inputs$compare_var_label(),
                              y_label =  inputs$var_label()){
  
  data_plot <- database %>%
    rename(wrap_var = display)
  
  
  
  plot <- ggplot(data_plot,
                 aes(x = round,
                     y = mean,
                     fill = fill)) +
    geom_line(aes(group = fill,
                  color = fill),
              show.legend = F)+
    geom_point(size = 4,
               shape = 21) +
    scale_fill_manual(name = paste(str_to_title(level),legend),
                      breaks = c("Yes", "No"),
                      values = c(alpha(color_yes, .9), alpha(color_no, .7))
    )+
    scale_color_manual(values = c(color_yes, color_no)) +
    facet_wrap(~ wrap_var) +
    labs(y = y_label,
        x = "")
  
  
  
  
}
